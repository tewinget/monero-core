// Copyright (c) 2014-2015, The Monero Project
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

import "../components"
import moneroComponents 1.0

Rectangle {

    color: "#F0EEEE"
    property alias addressText : addressLine.text
    property alias paymentIdText : paymentIdLine.text
    property alias integratedAddressText : integratedAddressLine.text

    function updatePaymentId() {
        var payment_id = appWindow.persistentSettings.payment_id
        if (payment_id.length === 0) {
            payment_id = appWindow.wallet.generatePaymentId()
            appWindow.persistentSettings.payment_id = payment_id
            appWindow.wallet.payment_id = payment_id
        }
        paymentIdLine.text = payment_id
        addressLine.text = appWindow.wallet.address
        integratedAddressLine.text = appWindow.wallet.integratedAddress(payment_id)
    }

    Clipboard { id: clipboard }


    /* main layout */
    ColumnLayout {
        id: mainLayout
        anchors.margins: 40
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right

        spacing: 20
        property int labelWidth: 120
        property int editWidth: 400
        property int lineEditFontSize: 12


        RowLayout {
            id: addressRow

            Label {
                id: addressLabel
                fontSize: 14
                text: qsTr("Address") + translationManager.emptyString
                width: mainLayout.labelWidth
            }

            LineEdit {
                id: addressLine
                fontSize: mainLayout.lineEditFontSize
                placeholderText: qsTr("ReadOnly wallet address displayed here") + translationManager.emptyString;
                readOnly: true
                width: mainLayout.editWidth
                Layout.fillWidth: true
                IconButton {
                    imageSource: "../images/copyToClipboard.png"
                    onClicked: {
                        if (addressLine.text.length > 0) {
                            clipboard.setText(addressLine.text)
                        }
                    }
                }
            }
        }

        RowLayout {
            id: integratedAddressRow
            Label {
                id: integratedAddressLabel
                fontSize: 14
                text: qsTr("Integrated address") + translationManager.emptyString
                width: mainLayout.labelWidth
            }


            LineEdit {

                id: integratedAddressLine
                fontSize: mainLayout.lineEditFontSize
                placeholderText: qsTr("ReadOnly wallet integrated address displayed here") + translationManager.emptyString
                readOnly: true
                width: mainLayout.editWidth
                Layout.fillWidth: true
                IconButton {
                    imageSource: "../images/copyToClipboard.png"
                    onClicked: {
                        if (integratedAddressLine.text.length > 0) {
                            clipboard.setText(integratedAddressLine.text)
                        }
                    }
                }

            }
        }

        RowLayout {
            id: paymentIdRow
            Label {
                id: paymentIdLabel
                fontSize: 14
                text: qsTr("Payment ID") + translationManager.emptyString
                width: mainLayout.labelWidth
            }


            LineEdit {
                id: paymentIdLine
                fontSize: mainLayout.lineEditFontSize
                placeholderText: qsTr("PaymentID here") + translationManager.emptyString;
                readOnly: false

                width: mainLayout.editWidth
                Layout.fillWidth: true

                IconButton {
                    imageSource: "../images/copyToClipboard.png"
                    onClicked: {
                        if (paymentIdLine.text.length > 0) {
                            clipboard.setText(paymentIdLine.text)
                        }
                    }
                }
            }

            StandardButton {
                id: generatePaymentId
                width: 80
                fontSize: 14
                shadowReleasedColor: "#FF4304"
                shadowPressedColor: "#B32D00"
                releasedColor: "#FF6C3C"
                pressedColor: "#FF4304"
                text: qsTr("Generate")
                anchors.right: parent.right
                onClicked: {
                    appWindow.persistentSettings.payment_id = appWindow.wallet.generatePaymentId();
                    updatePaymentId()
                }
            }
        }

    }

    Component.onCompleted: {
        console.log("Receive page loaded");
        updatePaymentId()
    }

}

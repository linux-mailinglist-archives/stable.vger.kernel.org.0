Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CD210BC50
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfK0VTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0VJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:09:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E51F12176D;
        Wed, 27 Nov 2019 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888996;
        bh=eS1BJnBh8mOWUbVmRx/IREx1XEcFwiiQtlXaaqSffLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELUdncm9k8Ug1CyEyVRyd0YGQBr1H9dNtAO4NCP+hnU3plvmHkV5WfN5MIorUdLIa
         6biuiPLcgUcJhzj3zNUHU7BzYtadijsAO54YvfdNIlSOK3yyCaX2CuL85VuNIT+1p5
         DMVer54fWIInJgl/0te+DgxDDGwdd4IggfhGhw5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.3 41/95] Revert "Bluetooth: hci_ll: set operational frequency earlier"
Date:   Wed, 27 Nov 2019 21:31:58 +0100
Message-Id: <20191127202908.243531316@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit cef456cd354ef485f12d57000c455e83e416a2b6 upstream.

As nice as it would be to update firmware faster, that patch broke
at least two different boards, an OMAP4+WL1285 based Motorola Droid
4, as reported by Sebasian Reichel and the Logic PD i.MX6Q +
WL1837MOD.

This reverts commit a2e02f38eff84f199c8e32359eb213f81f270047.

Signed-off-by: Adam Ford <aford173@gmail.com>
Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_ll.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -621,13 +621,6 @@ static int ll_setup(struct hci_uart *hu)
 
 	serdev_device_set_flow_control(serdev, true);
 
-	if (hu->oper_speed)
-		speed = hu->oper_speed;
-	else if (hu->proto->oper_speed)
-		speed = hu->proto->oper_speed;
-	else
-		speed = 0;
-
 	do {
 		/* Reset the Bluetooth device */
 		gpiod_set_value_cansleep(lldev->enable_gpio, 0);
@@ -639,20 +632,6 @@ static int ll_setup(struct hci_uart *hu)
 			return err;
 		}
 
-		if (speed) {
-			__le32 speed_le = cpu_to_le32(speed);
-			struct sk_buff *skb;
-
-			skb = __hci_cmd_sync(hu->hdev,
-					     HCI_VS_UPDATE_UART_HCI_BAUDRATE,
-					     sizeof(speed_le), &speed_le,
-					     HCI_INIT_TIMEOUT);
-			if (!IS_ERR(skb)) {
-				kfree_skb(skb);
-				serdev_device_set_baudrate(serdev, speed);
-			}
-		}
-
 		err = download_firmware(lldev);
 		if (!err)
 			break;
@@ -677,7 +656,25 @@ static int ll_setup(struct hci_uart *hu)
 	}
 
 	/* Operational speed if any */
+	if (hu->oper_speed)
+		speed = hu->oper_speed;
+	else if (hu->proto->oper_speed)
+		speed = hu->proto->oper_speed;
+	else
+		speed = 0;
 
+	if (speed) {
+		__le32 speed_le = cpu_to_le32(speed);
+		struct sk_buff *skb;
+
+		skb = __hci_cmd_sync(hu->hdev, HCI_VS_UPDATE_UART_HCI_BAUDRATE,
+				     sizeof(speed_le), &speed_le,
+				     HCI_INIT_TIMEOUT);
+		if (!IS_ERR(skb)) {
+			kfree_skb(skb);
+			serdev_device_set_baudrate(serdev, speed);
+		}
+	}
 
 	return 0;
 }



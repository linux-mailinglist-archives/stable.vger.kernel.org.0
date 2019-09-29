Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD57C15AB
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfI2N76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbfI2N75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:59:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398F721835;
        Sun, 29 Sep 2019 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765597;
        bh=lZJ9g3vN8/4CHNEIeGOta0sjNncUHLr4qa1CoclZ/p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wiuw8Ma2PBTPGp+VFedchOssqeqEh8i47nn2aJYDVvYD9FJm/ZTSwMA7zJ+kcUypw
         tyW1oQ7GKz9hLXQWtS3MAD7xAGk5+Gm/BFwbad3jkHDx2DlReFACvVLMc/VPpd3/SC
         I/3gykLxT/SDJMHodApQAEk9Y9JTi4nfVWBpjvs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jian-hong@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/63] Bluetooth: btrtl: HCI reset on close for Realtek BT chip
Date:   Sun, 29 Sep 2019 15:54:29 +0200
Message-Id: <20190929135040.787343548@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit 7af3f558aca74f2ee47b173f1c27f6bb9a5b5561 ]

Realtek RTL8822BE BT chip on ASUS X420FA cannot be turned on correctly
after on-off several times. Bluetooth daemon sets BT mode failed when
this issue happens. Scanning must be active while turning off for this
bug to be hit.

bluetoothd[1576]: Failed to set mode: Failed (0x03)

If BT is turned off, then turned on again, it works correctly again.

According to the vendor driver, the HCI_QUIRK_RESET_ON_CLOSE flag is set
during probing. So, this patch makes Realtek's BT reset on close to fix
this issue.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=203429
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Reviewed-by: Daniel Drake <drake@endlessm.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 20 ++++++++++++++++++++
 drivers/bluetooth/btrtl.h |  6 ++++++
 drivers/bluetooth/btusb.c |  1 +
 3 files changed, 27 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 1342f8e6025cc..8d1cd2479e36f 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -639,6 +639,26 @@ int btrtl_setup_realtek(struct hci_dev *hdev)
 }
 EXPORT_SYMBOL_GPL(btrtl_setup_realtek);
 
+int btrtl_shutdown_realtek(struct hci_dev *hdev)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	/* According to the vendor driver, BT must be reset on close to avoid
+	 * firmware crash.
+	 */
+	skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL, HCI_INIT_TIMEOUT);
+	if (IS_ERR(skb)) {
+		ret = PTR_ERR(skb);
+		bt_dev_err(hdev, "HCI reset during shutdown failed");
+		return ret;
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(btrtl_shutdown_realtek);
+
 static unsigned int btrtl_convert_baudrate(u32 device_baudrate)
 {
 	switch (device_baudrate) {
diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
index f5e36f3993a81..852f27d4ee289 100644
--- a/drivers/bluetooth/btrtl.h
+++ b/drivers/bluetooth/btrtl.h
@@ -65,6 +65,7 @@ void btrtl_free(struct btrtl_device_info *btrtl_dev);
 int btrtl_download_firmware(struct hci_dev *hdev,
 			    struct btrtl_device_info *btrtl_dev);
 int btrtl_setup_realtek(struct hci_dev *hdev);
+int btrtl_shutdown_realtek(struct hci_dev *hdev);
 int btrtl_get_uart_settings(struct hci_dev *hdev,
 			    struct btrtl_device_info *btrtl_dev,
 			    unsigned int *controller_baudrate,
@@ -93,6 +94,11 @@ static inline int btrtl_setup_realtek(struct hci_dev *hdev)
 	return -EOPNOTSUPP;
 }
 
+static inline int btrtl_shutdown_realtek(struct hci_dev *hdev)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int btrtl_get_uart_settings(struct hci_dev *hdev,
 					  struct btrtl_device_info *btrtl_dev,
 					  unsigned int *controller_baudrate,
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 09c83dc2ef677..96b8a00934c4a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3128,6 +3128,7 @@ static int btusb_probe(struct usb_interface *intf,
 #ifdef CONFIG_BT_HCIBTUSB_RTL
 	if (id->driver_info & BTUSB_REALTEK) {
 		hdev->setup = btrtl_setup_realtek;
+		hdev->shutdown = btrtl_shutdown_realtek;
 
 		/* Realtek devices lose their updated firmware over suspend,
 		 * but the USB hub doesn't notice any status change.
-- 
2.20.1




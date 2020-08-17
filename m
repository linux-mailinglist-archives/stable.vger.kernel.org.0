Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B135B2472F9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391689AbgHQStb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387613AbgHQPyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:54:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 788922072E;
        Mon, 17 Aug 2020 15:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679651;
        bh=orZtU76V2OoILPOsZJC+hXNQa/MQ+VfVGokzgVpt1Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtnvpP60SESWiWay0f1poIeTPyoWzOR+GzgP7V7E3vHu9RWSvkhKl1JasS0iSWCD0
         6BUmi1Lonsiv50IitXSYTN0CM1hPz+6lVzedY1NcQQpC/oOY7YaAj1EhSqMqklrVzO
         jEZAgP9Apt64wcY3AWaj6UkUTymA3bt86Smpyby0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Wi=C5=9Bniewski?= <brylozketrzyn@gmail.com>,
        Mike Johnson <yuyuyak@gmail.com>,
        Ricardo Rodrigues <ekatonb@gmail.com>,
        "M.Hanny Sabbagh" <mhsabbagh@outlook.com>,
        Oussama BEN BRAHIM <b.brahim.oussama@gmail.com>,
        Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 256/393] Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth controllers
Date:   Mon, 17 Aug 2020 17:15:06 +0200
Message-Id: <20200817143832.033248605@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

[ Upstream commit cde1a8a992875a7479c4321b2a4a190c2e92ec2a ]

For some reason they tend to squat on the very first CSR/
Cambridge Silicon Radio VID/PID instead of paying fees.

This is an extremely common problem; the issue goes as back as 2013
and these devices are only getting more popular, even rebranded by
reputable vendors and sold by retailers everywhere.

So, at this point in time there are hundreds of modern dongles reusing
the ID of what originally was an early Bluetooth 1.1 controller.

Linux is the only place where they don't work due to spotty checks
in our detection code. It only covered a minimum subset.

So what's the big idea? Take advantage of the fact that all CSR
chips report the same internal version as both the LMP sub-version and
HCI revision number. It always matches, couple that with the manufacturer
code, that rarely lies, and we now have a good idea of who is who.

Additionally, by compiling a list of user-reported HCI/lsusb dumps, and
searching around for legit CSR dongles in similar product ranges we can
find what CSR BlueCore firmware supported which Bluetooth versions.

That way we can narrow down ranges of fakes for each of them.

e.g. Real CSR dongles with LMP subversion 0x73 are old enough that
     support BT 1.1 only; so it's a dead giveaway when some
     third-party BT 4.0 dongle reuses it.

So, to sum things up; there are multiple classes of fake controllers
reusing the same 0A12:0001 VID/PID. This has been broken for a while.

Known 'fake' bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891
  IC markings on 0x7558: FR3191AHAL 749H15143 (???)

https://bugzilla.kernel.org/show_bug.cgi?id=60824

Fixes: 81cac64ba258ae (Deal with USB devices that are faking CSR vendor)
Reported-by: Michał Wiśniewski <brylozketrzyn@gmail.com>
Tested-by: Mike Johnson <yuyuyak@gmail.com>
Tested-by: Ricardo Rodrigues <ekatonb@gmail.com>
Tested-by: M.Hanny Sabbagh <mhsabbagh@outlook.com>
Tested-by: Oussama BEN BRAHIM <b.brahim.oussama@gmail.com>
Tested-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c         | 74 ++++++++++++++++++++++++++-----
 include/net/bluetooth/bluetooth.h |  2 +
 include/net/bluetooth/hci.h       | 11 +++++
 net/bluetooth/hci_core.c          |  6 ++-
 4 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4085387f13cfb..0c77240fd7dd4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1631,6 +1631,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 {
 	struct hci_rp_read_local_version *rp;
 	struct sk_buff *skb;
+	bool is_fake = false;
 
 	BT_DBG("%s", hdev->name);
 
@@ -1650,18 +1651,69 @@ static int btusb_setup_csr(struct hci_dev *hdev)
 
 	rp = (struct hci_rp_read_local_version *)skb->data;
 
-	/* Detect controllers which aren't real CSR ones. */
+	/* Detect a wide host of Chinese controllers that aren't CSR.
+	 *
+	 * Known fake bcdDevices: 0x0100, 0x0134, 0x1915, 0x2520, 0x7558, 0x8891
+	 *
+	 * The main thing they have in common is that these are really popular low-cost
+	 * options that support newer Bluetooth versions but rely on heavy VID/PID
+	 * squatting of this poor old Bluetooth 1.1 device. Even sold as such.
+	 *
+	 * We detect actual CSR devices by checking that the HCI manufacturer code
+	 * is Cambridge Silicon Radio (10) and ensuring that LMP sub-version and
+	 * HCI rev values always match. As they both store the firmware number.
+	 */
 	if (le16_to_cpu(rp->manufacturer) != 10 ||
-	    le16_to_cpu(rp->lmp_subver) == 0x0c5c) {
+	    le16_to_cpu(rp->hci_rev) != le16_to_cpu(rp->lmp_subver))
+		is_fake = true;
+
+	/* Known legit CSR firmware build numbers and their supported BT versions:
+	 * - 1.1 (0x1) -> 0x0073, 0x020d, 0x033c, 0x034e
+	 * - 1.2 (0x2) ->                 0x04d9, 0x0529
+	 * - 2.0 (0x3) ->         0x07a6, 0x07ad, 0x0c5c
+	 * - 2.1 (0x4) ->         0x149c, 0x1735, 0x1899 (0x1899 is a BlueCore4-External)
+	 * - 4.0 (0x6) ->         0x1d86, 0x2031, 0x22bb
+	 *
+	 * e.g. Real CSR dongles with LMP subversion 0x73 are old enough that
+	 *      support BT 1.1 only; so it's a dead giveaway when some
+	 *      third-party BT 4.0 dongle reuses it.
+	 */
+	else if (le16_to_cpu(rp->lmp_subver) <= 0x034e &&
+		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_1_1)
+		is_fake = true;
+
+	else if (le16_to_cpu(rp->lmp_subver) <= 0x0529 &&
+		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_1_2)
+		is_fake = true;
+
+	else if (le16_to_cpu(rp->lmp_subver) <= 0x0c5c &&
+		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_2_0)
+		is_fake = true;
+
+	else if (le16_to_cpu(rp->lmp_subver) <= 0x1899 &&
+		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_2_1)
+		is_fake = true;
+
+	else if (le16_to_cpu(rp->lmp_subver) <= 0x22bb &&
+		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_4_0)
+		is_fake = true;
+
+	if (is_fake) {
+		bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; adding workarounds...");
+
+		/* Generally these clones have big discrepancies between
+		 * advertised features and what's actually supported.
+		 * Probably will need to be expanded in the future;
+		 * without these the controller will lock up.
+		 */
+		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
+
 		/* Clear the reset quirk since this is not an actual
 		 * early Bluetooth 1.1 device from CSR.
 		 */
 		clear_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
-
-		/* These fake CSR controllers have all a broken
-		 * stored link key handling and so just disable it.
-		 */
-		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
+		clear_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 	}
 
 	kfree_skb(skb);
@@ -3905,11 +3957,13 @@ static int btusb_probe(struct usb_interface *intf,
 		if (bcdDevice < 0x117)
 			set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
 
+		/* This must be set first in case we disable it for fakes */
+		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
+
 		/* Fake CSR devices with broken commands */
-		if (bcdDevice <= 0x100 || bcdDevice == 0x134)
+		if (le16_to_cpu(udev->descriptor.idVendor)  == 0x0a12 &&
+		    le16_to_cpu(udev->descriptor.idProduct) == 0x0001)
 			hdev->setup = btusb_setup_csr;
-
-		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 	}
 
 	if (id->driver_info & BTUSB_SNIFFER) {
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 1576353a27732..15c54deb2b8e0 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -41,6 +41,8 @@
 #define BLUETOOTH_VER_1_1	1
 #define BLUETOOTH_VER_1_2	2
 #define BLUETOOTH_VER_2_0	3
+#define BLUETOOTH_VER_2_1	4
+#define BLUETOOTH_VER_4_0	6
 
 /* Reserv for core and drivers use */
 #define BT_SKB_RESERVE	8
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 25c2e5ee81dc5..b2c567fc3338c 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -223,6 +223,17 @@ enum {
 	 * supported.
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
+
+	/* When this quirk is set, then erroneous data reporting
+	 * is ignored. This is mainly due to the fact that the HCI
+	 * Read Default Erroneous Data Reporting command is advertised,
+	 * but not supported; these controllers often reply with unknown
+	 * command and tend to lock up randomly. Needing a hard reset.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 828847ac4b33c..4e5ecc2c9602d 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -605,7 +605,8 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 	if (hdev->commands[8] & 0x01)
 		hci_req_add(req, HCI_OP_READ_PAGE_SCAN_ACTIVITY, 0, NULL);
 
-	if (hdev->commands[18] & 0x04)
+	if (hdev->commands[18] & 0x04 &&
+	    !test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
 		hci_req_add(req, HCI_OP_READ_DEF_ERR_DATA_REPORTING, 0, NULL);
 
 	/* Some older Broadcom based Bluetooth 1.2 controllers do not
@@ -846,7 +847,8 @@ static int hci_init4_req(struct hci_request *req, unsigned long opt)
 	/* Set erroneous data reporting if supported to the wideband speech
 	 * setting value
 	 */
-	if (hdev->commands[18] & 0x08) {
+	if (hdev->commands[18] & 0x08 &&
+	    !test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks)) {
 		bool enabled = hci_dev_test_flag(hdev,
 						 HCI_WIDEBAND_SPEECH_ENABLED);
 
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E504890D8
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbiAJH0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239401AbiAJHZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1CFC061756;
        Sun,  9 Jan 2022 23:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AEA2611A5;
        Mon, 10 Jan 2022 07:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6062AC36AE9;
        Mon, 10 Jan 2022 07:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799483;
        bh=nqnTSjTMjr6041+mH6ZLO7m37kDsXeniiDfeWi1N/u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAynRw8E/ZjIffIztZKhiaXe5ewg5X7tBDiB4SJezl4X9jpJmcWLrvrRHeO5cGocd
         ODjlAOd0ojRkgYXRA9ymUKQQqJHRsuYTFeGTe0ybBcz/qh+czMJ+BpUFkL7M7SDn5+
         A0G/bAnVbtMZbxTWvXGKi1uxA7SCN3QlzdjAfOQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Levshin <ivan.levshin@microfocus.com>,
        Takashi Iwai <tiwai@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 4.9 01/21] Bluetooth: btusb: Apply QCA Rome patches for some ATH3012 models
Date:   Mon, 10 Jan 2022 08:22:48 +0100
Message-Id: <20220110071812.854591388@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 803cdb8ce584198cd45825822910cac7de6378cb upstream.

In commit f44cb4b19ed4 ("Bluetooth: btusb: Fix quirk for Atheros
1525/QCA6174") we tried to address the non-working Atheros BT devices
by changing the quirk from BTUSB_ATH3012 to BTUSB_QCA_ROME.  This made
such devices working while it turned out to break other existing chips
with the very same USB ID, hence it was reverted afterwards.

This is another attempt to tackle the issue.  The essential point to
use BTUSB_QCA_ROME is to apply the btusb_setup_qca() and do RAM-
patching.  And the previous attempt failed because btusb_setup_qca()
returns -ENODEV if the ROM version doesn't match with the expected
ones.  For some devices that have already the "correct" ROM versions,
we may just skip the setup procedure and continue the rest.

So, the first fix we'll need is to add a check of the ROM version in
the function to skip the setup if the ROM version looks already sane,
so that it can be applied for all ath devices.

However, the world is a bit more complex than that simple solution.
Since BTUSB_ATH3012 quirk checks the bcdDevice and bails out when it's
0x0001 at the beginning of probing, so the device probe always aborts
here.

In this patch, we add another check of ROM version again, and if the
device needs patching, the probe continues.  For that, a slight
refactoring of btusb_qca_send_vendor_req() was required so that the
probe function can pass usb_device pointer directly before allocating
hci_dev stuff.

Fixes: commit f44cb4b19ed4 ("Bluetooth: btusb: Fix quirk for Atheros 1525/QCA6174")
Bugzilla: http://bugzilla.opensuse.org/show_bug.cgi?id=1082504
Tested-by: Ivan Levshin <ivan.levshin@microfocus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2442,11 +2442,9 @@ static const struct qca_device_info qca_
 	{ 0x00000302, 28, 4, 18 }, /* Rome 3.2 */
 };
 
-static int btusb_qca_send_vendor_req(struct hci_dev *hdev, u8 request,
+static int btusb_qca_send_vendor_req(struct usb_device *udev, u8 request,
 				     void *data, u16 size)
 {
-	struct btusb_data *btdata = hci_get_drvdata(hdev);
-	struct usb_device *udev = btdata->udev;
 	int pipe, err;
 	u8 *buf;
 
@@ -2461,7 +2459,7 @@ static int btusb_qca_send_vendor_req(str
 	err = usb_control_msg(udev, pipe, request, USB_TYPE_VENDOR | USB_DIR_IN,
 			      0, 0, buf, size, USB_CTRL_SET_TIMEOUT);
 	if (err < 0) {
-		BT_ERR("%s: Failed to access otp area (%d)", hdev->name, err);
+		dev_err(&udev->dev, "Failed to access otp area (%d)", err);
 		goto done;
 	}
 
@@ -2617,20 +2615,38 @@ static int btusb_setup_qca_load_nvm(stru
 	return err;
 }
 
+/* identify the ROM version and check whether patches are needed */
+static bool btusb_qca_need_patch(struct usb_device *udev)
+{
+	struct qca_version ver;
+
+	if (btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
+				      sizeof(ver)) < 0)
+		return false;
+	/* only low ROM versions need patches */
+	return !(le32_to_cpu(ver.rom_version) & ~0xffffU);
+}
+
 static int btusb_setup_qca(struct hci_dev *hdev)
 {
+	struct btusb_data *btdata = hci_get_drvdata(hdev);
+	struct usb_device *udev = btdata->udev;
 	const struct qca_device_info *info = NULL;
 	struct qca_version ver;
 	u32 ver_rom;
 	u8 status;
 	int i, err;
 
-	err = btusb_qca_send_vendor_req(hdev, QCA_GET_TARGET_VERSION, &ver,
+	err = btusb_qca_send_vendor_req(udev, QCA_GET_TARGET_VERSION, &ver,
 					sizeof(ver));
 	if (err < 0)
 		return err;
 
 	ver_rom = le32_to_cpu(ver.rom_version);
+	/* Don't care about high ROM versions */
+	if (ver_rom & ~0xffffU)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(qca_devices_table); i++) {
 		if (ver_rom == qca_devices_table[i].rom_version)
 			info = &qca_devices_table[i];
@@ -2641,7 +2657,7 @@ static int btusb_setup_qca(struct hci_de
 		return -ENODEV;
 	}
 
-	err = btusb_qca_send_vendor_req(hdev, QCA_CHECK_STATUS, &status,
+	err = btusb_qca_send_vendor_req(udev, QCA_CHECK_STATUS, &status,
 					sizeof(status));
 	if (err < 0)
 		return err;
@@ -2787,7 +2803,8 @@ static int btusb_probe(struct usb_interf
 
 		/* Old firmware would otherwise let ath3k driver load
 		 * patch and sysconfig files */
-		if (le16_to_cpu(udev->descriptor.bcdDevice) <= 0x0001)
+		if (le16_to_cpu(udev->descriptor.bcdDevice) <= 0x0001 &&
+		    !btusb_qca_need_patch(udev))
 			return -ENODEV;
 	}
 
@@ -2937,6 +2954,7 @@ static int btusb_probe(struct usb_interf
 	}
 
 	if (id->driver_info & BTUSB_ATH3012) {
+		data->setup_on_usb = btusb_setup_qca;
 		hdev->set_bdaddr = btusb_set_bdaddr_ath3012;
 		set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
 		set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);



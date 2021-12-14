Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6B473FE6
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 10:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhLNJwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 04:52:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43790 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbhLNJw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 04:52:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF9F4B81803;
        Tue, 14 Dec 2021 09:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E518BC34600;
        Tue, 14 Dec 2021 09:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639475545;
        bh=X5qlRjFt3dFQT87jvAhburN/J1+QtYmjl7fJRro0SEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LY1pfdUhjqrgUoL612vXIsnrUFOldLcNlG508ldST42hLNz2A8rL6N5QwXbsJIaa2
         /GWDmJIC5Og8V10vg6qpQxApQQDWhMD0EOnj0oeE9M4HGxggmB7tyCH46b+zW9SKUE
         wrI7toq7qDMRRaBR1JtWNvsqCCm0xKkyx/hVpSEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.258
Date:   Tue, 14 Dec 2021 10:52:15 +0100
Message-Id: <1639475533198133@kroah.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1639475533171153@kroah.com>
References: <1639475533171153@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 99110c39fdc1..f77e1d686f87 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 257
+SUBLEVEL = 258
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/block/ioprio.c b/block/ioprio.c
index 6f5d0b6625e3..35bbbcae68f8 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -196,6 +196,7 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 				pgrp = task_pgrp(current);
 			else
 				pgrp = find_vpid(who);
+			read_lock(&tasklist_lock);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
 				tmpio = get_task_ioprio(p);
 				if (tmpio < 0)
@@ -205,6 +206,8 @@ SYSCALL_DEFINE2(ioprio_get, int, which, int, who)
 				else
 					ret = ioprio_best(ret, tmpio);
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
+			read_unlock(&tasklist_lock);
+
 			break;
 		case IOPRIO_WHO_USER:
 			uid = make_kuid(current_user_ns(), who);
diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 63bf8a7d477b..2412e219b7c3 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -4336,23 +4336,20 @@ static int binder_thread_release(struct binder_proc *proc,
 	}
 
 	/*
-	 * If this thread used poll, make sure we remove the waitqueue
-	 * from any epoll data structures holding it with POLLFREE.
-	 * waitqueue_active() is safe to use here because we're holding
-	 * the inner lock.
+	 * If this thread used poll, make sure we remove the waitqueue from any
+	 * poll data structures holding it.
 	 */
-	if ((thread->looper & BINDER_LOOPER_STATE_POLL) &&
-	    waitqueue_active(&thread->wait)) {
-		wake_up_poll(&thread->wait, POLLHUP | POLLFREE);
-	}
+	if (thread->looper & BINDER_LOOPER_STATE_POLL)
+		wake_up_pollfree(&thread->wait);
 
 	binder_inner_proc_unlock(thread->proc);
 
 	/*
-	 * This is needed to avoid races between wake_up_poll() above and
-	 * and ep_remove_waitqueue() called for other reasons (eg the epoll file
-	 * descriptor being closed); ep_remove_waitqueue() holds an RCU read
-	 * lock, so we can be sure it's done after calling synchronize_rcu().
+	 * This is needed to avoid races between wake_up_pollfree() above and
+	 * someone else removing the last entry from the queue for other reasons
+	 * (e.g. ep_remove_wait_queue() being called due to an epoll file
+	 * descriptor being closed).  Such other users hold an RCU read lock, so
+	 * we can be sure they're done after we call synchronize_rcu().
 	 */
 	if (thread->looper & BINDER_LOOPER_STATE_POLL)
 		synchronize_rcu();
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2ae72f31cbe3..8ec71243cdcc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4449,6 +4449,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "VRFDFC22048UCHC-TE*", NULL,		ATA_HORKAGE_NODMA },
 	/* Odd clown on sil3726/4726 PMPs */
 	{ "Config  Disk",	NULL,		ATA_HORKAGE_DISABLE },
+	/* Similar story with ASMedia 1092 */
+	{ "ASMT109x- Config",	NULL,		ATA_HORKAGE_DISABLE },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index eca4c9d97110..5f5580fbd351 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -191,14 +191,14 @@ config HID_CHERRY
 
 config HID_CHICONY
 	tristate "Chicony devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	---help---
 	Support for Chicony Tactical pad and special keys on Chicony keyboards.
 
 config HID_CORSAIR
 	tristate "Corsair devices"
-	depends on HID && USB && LEDS_CLASS
+	depends on USB_HID && LEDS_CLASS
 	---help---
 	Support for Corsair devices that are not fully compliant with the
 	HID standard.
@@ -209,7 +209,7 @@ config HID_CORSAIR
 
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
-	depends on HID && SND
+	depends on USB_HID && SND
 	select SND_RAWMIDI
 	---help---
 	Support for Prodikeys PC-MIDI Keyboard device support.
@@ -448,7 +448,7 @@ config HID_LENOVO
 
 config HID_LOGITECH
 	tristate "Logitech devices"
-	depends on HID
+	depends on USB_HID
 	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
@@ -780,7 +780,7 @@ config HID_SAITEK
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
-	depends on HID
+	depends on USB_HID
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 
diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 50c294be8324..a7a63abdea86 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -600,7 +600,7 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (drvdata->quirks & QUIRK_IS_MULTITOUCH)
 		drvdata->tp = &asus_i2c_tp;
 
-	if (drvdata->quirks & QUIRK_T100_KEYBOARD) {
+	if ((drvdata->quirks & QUIRK_T100_KEYBOARD) && hid_is_usb(hdev)) {
 		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 
 		if (intf->altsetting->desc.bInterfaceNumber == T100_TPAD_INTF) {
diff --git a/drivers/hid/hid-chicony.c b/drivers/hid/hid-chicony.c
index 397a789a41be..218f0e090f63 100644
--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -61,8 +61,12 @@ static int ch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 static __u8 *ch_switch12_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	
+	struct usb_interface *intf;
+
+	if (!hid_is_usb(hdev))
+		return rdesc;
+
+	intf = to_usb_interface(hdev->dev.parent);
 	if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
 		/* Change usage maximum and logical maximum from 0x7fff to
 		 * 0x2fff, so they don't exceed HID_MAX_USAGES */
diff --git a/drivers/hid/hid-corsair.c b/drivers/hid/hid-corsair.c
index 9ba5d98a1180..d8cf08b6b31c 100644
--- a/drivers/hid/hid-corsair.c
+++ b/drivers/hid/hid-corsair.c
@@ -553,7 +553,12 @@ static int corsair_probe(struct hid_device *dev, const struct hid_device_id *id)
 	int ret;
 	unsigned long quirks = id->driver_data;
 	struct corsair_drvdata *drvdata;
-	struct usb_interface *usbif = to_usb_interface(dev->dev.parent);
+	struct usb_interface *usbif;
+
+	if (!hid_is_usb(dev))
+		return -EINVAL;
+
+	usbif = to_usb_interface(dev->dev.parent);
 
 	drvdata = devm_kzalloc(&dev->dev, sizeof(struct corsair_drvdata),
 			       GFP_KERNEL);
diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
index 5eea6fe0d7bd..c3ecac13e620 100644
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -230,6 +230,9 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct elo_priv *priv;
 	int ret;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
diff --git a/drivers/hid/hid-holtek-kbd.c b/drivers/hid/hid-holtek-kbd.c
index ab9da597106f..2f8eb6639744 100644
--- a/drivers/hid/hid-holtek-kbd.c
+++ b/drivers/hid/hid-holtek-kbd.c
@@ -143,12 +143,17 @@ static int holtek_kbd_input_event(struct input_dev *dev, unsigned int type,
 static int holtek_kbd_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	int ret = hid_parse(hdev);
+	struct usb_interface *intf;
+	int ret;
+
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
 
+	ret = hid_parse(hdev);
 	if (!ret)
 		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 
+	intf = to_usb_interface(hdev->dev.parent);
 	if (!ret && intf->cur_altsetting->desc.bInterfaceNumber == 1) {
 		struct hid_input *hidinput;
 		list_for_each_entry(hidinput, &hdev->inputs, list) {
diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
index 78b3a0c76775..27c08ddab0e1 100644
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -65,6 +65,14 @@ static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	return rdesc;
 }
 
+static int holtek_mouse_probe(struct hid_device *hdev,
+			      const struct hid_device_id *id)
+{
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+	return 0;
+}
+
 static const struct hid_device_id holtek_mouse_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
 			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
@@ -86,6 +94,7 @@ static struct hid_driver holtek_mouse_driver = {
 	.name = "holtek_mouse",
 	.id_table = holtek_mouse_devices,
 	.report_fixup = holtek_mouse_report_fixup,
+	.probe = holtek_mouse_probe,
 };
 
 module_hid_driver(holtek_mouse_driver);
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 7e55d3f755dd..f8d1d481c838 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -714,12 +714,18 @@ static int lg_raw_event(struct hid_device *hdev, struct hid_report *report,
 
 static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
-	struct usb_interface *iface = to_usb_interface(hdev->dev.parent);
-	__u8 iface_num = iface->cur_altsetting->desc.bInterfaceNumber;
+	struct usb_interface *iface;
+	__u8 iface_num;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	struct lg_drv_data *drv_data;
 	int ret;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
+	iface = to_usb_interface(hdev->dev.parent);
+	iface_num = iface->cur_altsetting->desc.bInterfaceNumber;
+
 	/* G29 only work with the 1st interface */
 	if ((hdev->product == USB_DEVICE_ID_LOGITECH_G29_WHEEL) &&
 	    (iface_num != 0)) {
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 205f68251ac0..cc2072ea973f 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -803,12 +803,18 @@ static int pk_raw_event(struct hid_device *hdev, struct hid_report *report,
 static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret;
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	unsigned short ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
+	struct usb_interface *intf;
+	unsigned short ifnum;
 	unsigned long quirks = id->driver_data;
 	struct pk_device *pk;
 	struct pcmidi_snd *pm = NULL;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
+	intf = to_usb_interface(hdev->dev.parent);
+	ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
+
 	pk = kzalloc(sizeof(*pk), GFP_KERNEL);
 	if (pk == NULL) {
 		hid_err(hdev, "can't alloc descriptor\n");
diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 329c5d1270f9..fb545a11214f 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -347,6 +347,9 @@ static int arvo_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 02db537f8f3e..c07a7ea8a687 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -327,6 +327,9 @@ static int isku_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 9be8c31f613f..ef978586ff2f 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -752,6 +752,9 @@ static int kone_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 09e8fc72aa1d..b63de4c5b5dd 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -434,6 +434,9 @@ static int koneplus_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-konepure.c b/drivers/hid/hid-roccat-konepure.c
index 07de2f9014c6..ef9508822e5f 100644
--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -136,6 +136,9 @@ static int konepure_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 317c9c2c0a7c..6256c211398a 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -504,6 +504,9 @@ static int kovaplus_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-lua.c b/drivers/hid/hid-roccat-lua.c
index ac1a7313e259..13ae2a7d176d 100644
--- a/drivers/hid/hid-roccat-lua.c
+++ b/drivers/hid/hid-roccat-lua.c
@@ -163,6 +163,9 @@ static int lua_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index b30aa7b82bf8..027aa9d0ec1f 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -452,6 +452,9 @@ static int pyra_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-ryos.c b/drivers/hid/hid-roccat-ryos.c
index 47cc8f30ff6d..fda4a396a12e 100644
--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -144,6 +144,9 @@ static int ryos_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
index 6dbf6e04dce7..0230fb54f08a 100644
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -116,6 +116,9 @@ static int savu_probe(struct hid_device *hdev,
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 7cbb067d4a9e..89bb2260367f 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -157,6 +157,9 @@ static int samsung_probe(struct hid_device *hdev,
 	int ret;
 	unsigned int cmask = HID_CONNECT_DEFAULT;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
diff --git a/drivers/hid/hid-uclogic.c b/drivers/hid/hid-uclogic.c
index e3e6e5c893cc..bd9363538a32 100644
--- a/drivers/hid/hid-uclogic.c
+++ b/drivers/hid/hid-uclogic.c
@@ -791,6 +791,9 @@ static int uclogic_tablet_enable(struct hid_device *hdev)
 	__u8 *p;
 	s32 v;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	/*
 	 * Read string descriptor containing tablet parameters. The specific
 	 * string descriptor and data were discovered by sniffing the Windows
diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index bf8e727988c4..9a694fb27c8d 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -578,7 +578,7 @@ static void wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 	 * Skip the query for this type and modify defaults based on
 	 * interface number.
 	 */
-	if (features->type == WIRELESS) {
+	if (features->type == WIRELESS && intf) {
 		if (intf->cur_altsetting->desc.bInterfaceNumber == 0)
 			features->device_type = WACOM_DEVICETYPE_WL_MONITOR;
 		else
@@ -2049,7 +2049,7 @@ static void wacom_update_name(struct wacom *wacom, const char *suffix)
 	if ((features->type == HID_GENERIC) && !strcmp("Wacom HID", features->name)) {
 		char *product_name = wacom->hdev->name;
 
-		if (hid_is_using_ll_driver(wacom->hdev, &usb_hid_driver)) {
+		if (hid_is_usb(wacom->hdev)) {
 			struct usb_interface *intf = to_usb_interface(wacom->hdev->dev.parent);
 			struct usb_device *dev = interface_to_usbdev(intf);
 			product_name = dev->product;
@@ -2280,6 +2280,9 @@ static void wacom_wireless_work(struct work_struct *work)
 
 	wacom_destroy_battery(wacom);
 
+	if (!usbdev)
+		return;
+
 	/* Stylus interface */
 	hdev1 = usb_get_intfdata(usbdev->config->interface[1]);
 	wacom1 = hid_get_drvdata(hdev1);
@@ -2559,8 +2562,6 @@ static void wacom_mode_change_work(struct work_struct *work)
 static int wacom_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct usb_device *dev = interface_to_usbdev(intf);
 	struct wacom *wacom;
 	struct wacom_wac *wacom_wac;
 	struct wacom_features *features;
@@ -2593,8 +2594,14 @@ static int wacom_probe(struct hid_device *hdev,
 	wacom_wac->hid_data.inputmode = -1;
 	wacom_wac->mode_report = -1;
 
-	wacom->usbdev = dev;
-	wacom->intf = intf;
+	if (hid_is_usb(hdev)) {
+		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+		struct usb_device *dev = interface_to_usbdev(intf);
+
+		wacom->usbdev = dev;
+		wacom->intf = intf;
+	}
+
 	mutex_init(&wacom->lock);
 	INIT_DELAYED_WORK(&wacom->init_work, wacom_init_work);
 	INIT_WORK(&wacom->wireless_work, wacom_wireless_work);
diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 296fd00f0e97..031c150eafda 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1326,8 +1326,7 @@ static int kxcjk1013_probe(struct i2c_client *client,
 	return 0;
 
 err_buffer_cleanup:
-	if (data->dready_trig)
-		iio_triggered_buffer_cleanup(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
 	if (data->dready_trig)
 		iio_trigger_unregister(data->dready_trig);
@@ -1350,8 +1349,8 @@ static int kxcjk1013_remove(struct i2c_client *client)
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
 
+	iio_triggered_buffer_cleanup(indio_dev);
 	if (data->dready_trig) {
-		iio_triggered_buffer_cleanup(indio_dev);
 		iio_trigger_unregister(data->dready_trig);
 		iio_trigger_unregister(data->motion_trig);
 	}
diff --git a/drivers/iio/accel/kxsd9.c b/drivers/iio/accel/kxsd9.c
index 1bda730a71c0..c3ac798083f4 100644
--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -227,14 +227,14 @@ static irqreturn_t kxsd9_trigger_handler(int irq, void *p)
 			       hw_values.chan,
 			       sizeof(hw_values.chan));
 	if (ret) {
-		dev_err(st->dev,
-			"error reading data\n");
-		return ret;
+		dev_err(st->dev, "error reading data: %d\n", ret);
+		goto out;
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev,
 					   &hw_values,
 					   iio_get_time_ns(indio_dev));
+out:
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;
diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index 200ac4dad799..5dbbba365ce8 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1396,7 +1396,7 @@ static int mma8452_trigger_setup(struct iio_dev *indio_dev)
 	if (ret)
 		return ret;
 
-	indio_dev->trig = trig;
+	indio_dev->trig = iio_trigger_get(trig);
 
 	return 0;
 }
diff --git a/drivers/iio/adc/axp20x_adc.c b/drivers/iio/adc/axp20x_adc.c
index 11e177180ea0..42730cd186cc 100644
--- a/drivers/iio/adc/axp20x_adc.c
+++ b/drivers/iio/adc/axp20x_adc.c
@@ -224,19 +224,8 @@ static int axp22x_adc_raw(struct iio_dev *indio_dev,
 			  struct iio_chan_spec const *chan, int *val)
 {
 	struct axp20x_adc_iio *info = iio_priv(indio_dev);
-	int size;
 
-	/*
-	 * N.B.: Unlike the Chinese datasheets tell, the charging current is
-	 * stored on 12 bits, not 13 bits. Only discharging current is on 13
-	 * bits.
-	 */
-	if (chan->type == IIO_CURRENT && chan->channel == AXP22X_BATT_DISCHRG_I)
-		size = 13;
-	else
-		size = 12;
-
-	*val = axp20x_read_variable_width(info->regmap, chan->address, size);
+	*val = axp20x_read_variable_width(info->regmap, chan->address, 12);
 	if (*val < 0)
 		return *val;
 
@@ -329,9 +318,8 @@ static int axp22x_adc_scale(struct iio_chan_spec const *chan, int *val,
 		return IIO_VAL_INT_PLUS_MICRO;
 
 	case IIO_CURRENT:
-		*val = 0;
-		*val2 = 500000;
-		return IIO_VAL_INT_PLUS_MICRO;
+		*val = 1;
+		return IIO_VAL_INT;
 
 	case IIO_TEMP:
 		*val = 100;
diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
index 2a299bbd6acf..eef94e7b2858 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -251,7 +251,6 @@ static int dln2_adc_set_chan_period(struct dln2_adc *dln2,
 static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 {
 	int ret, i;
-	struct iio_dev *indio_dev = platform_get_drvdata(dln2->pdev);
 	u16 conflict;
 	__le16 value;
 	int olen = sizeof(value);
@@ -260,13 +259,9 @@ static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 		.chan = channel,
 	};
 
-	ret = iio_device_claim_direct_mode(indio_dev);
-	if (ret < 0)
-		return ret;
-
 	ret = dln2_adc_set_chan_enabled(dln2, channel, true);
 	if (ret < 0)
-		goto release_direct;
+		return ret;
 
 	ret = dln2_adc_set_port_enabled(dln2, true, &conflict);
 	if (ret < 0) {
@@ -303,8 +298,6 @@ static int dln2_adc_read(struct dln2_adc *dln2, unsigned int channel)
 	dln2_adc_set_port_enabled(dln2, false, NULL);
 disable_chan:
 	dln2_adc_set_chan_enabled(dln2, channel, false);
-release_direct:
-	iio_device_release_direct_mode(indio_dev);
 
 	return ret;
 }
@@ -340,10 +333,16 @@ static int dln2_adc_read_raw(struct iio_dev *indio_dev,
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+		ret = iio_device_claim_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
+
 		mutex_lock(&dln2->mutex);
 		ret = dln2_adc_read(dln2, chan->channel);
 		mutex_unlock(&dln2->mutex);
 
+		iio_device_release_direct_mode(indio_dev);
+
 		if (ret < 0)
 			return ret;
 
@@ -675,7 +674,11 @@ static int dln2_adc_probe(struct platform_device *pdev)
 	}
 	dln2->trig->ops = &dln2_adc_trigger_ops;
 	iio_trigger_set_drvdata(dln2->trig, dln2);
-	devm_iio_trigger_register(dev, dln2->trig);
+	ret = devm_iio_trigger_register(dev, dln2->trig);
+	if (ret) {
+		dev_err(dev, "failed to register trigger: %d\n", ret);
+		return ret;
+	}
 	iio_trigger_set_immutable(indio_dev, dln2->trig);
 
 	ret = devm_iio_triggered_buffer_setup(dev, indio_dev, NULL,
diff --git a/drivers/iio/gyro/itg3200_buffer.c b/drivers/iio/gyro/itg3200_buffer.c
index e04483254b28..7157b1a731a6 100644
--- a/drivers/iio/gyro/itg3200_buffer.c
+++ b/drivers/iio/gyro/itg3200_buffer.c
@@ -64,9 +64,9 @@ static irqreturn_t itg3200_trigger_handler(int irq, void *p)
 
 	iio_push_to_buffers_with_timestamp(indio_dev, &scan, pf->timestamp);
 
+error_ret:
 	iio_trigger_notify_done(indio_dev->trig);
 
-error_ret:
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
index 4061fed93f1f..7cb706b2f737 100644
--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -549,7 +549,6 @@ static struct iio_trigger *viio_trigger_alloc(const char *fmt, va_list vargs)
 		irq_modify_status(trig->subirq_base + i,
 				  IRQ_NOREQUEST | IRQ_NOAUTOEN, IRQ_NOPROBE);
 	}
-	get_device(&trig->dev);
 
 	return trig;
 
diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 3d75e155bd3e..68a7a6b20797 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1279,7 +1279,7 @@ static irqreturn_t ltr501_trigger_handler(int irq, void *p)
 		ret = regmap_bulk_read(data->regmap, LTR501_ALS_DATA1,
 				       (u8 *)als_buf, sizeof(als_buf));
 		if (ret < 0)
-			return ret;
+			goto done;
 		if (test_bit(0, indio_dev->active_scan_mask))
 			scan.channels[j++] = le16_to_cpu(als_buf[1]);
 		if (test_bit(1, indio_dev->active_scan_mask))
diff --git a/drivers/iio/light/stk3310.c b/drivers/iio/light/stk3310.c
index 45cf8b0a4363..ed9cf1ffec7b 100644
--- a/drivers/iio/light/stk3310.c
+++ b/drivers/iio/light/stk3310.c
@@ -546,9 +546,8 @@ static irqreturn_t stk3310_irq_event_handler(int irq, void *private)
 	mutex_lock(&data->lock);
 	ret = regmap_field_read(data->reg_flag_nf, &dir);
 	if (ret < 0) {
-		dev_err(&data->client->dev, "register read failed\n");
-		mutex_unlock(&data->lock);
-		return ret;
+		dev_err(&data->client->dev, "register read failed: %d\n", ret);
+		goto out;
 	}
 	event = IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY, 1,
 				     IIO_EV_TYPE_THRESH,
@@ -560,6 +559,7 @@ static irqreturn_t stk3310_irq_event_handler(int irq, void *private)
 	ret = regmap_field_write(data->reg_flag_psint, 0);
 	if (ret < 0)
 		dev_err(&data->client->dev, "failed to reset interrupts\n");
+out:
 	mutex_unlock(&data->lock);
 
 	return IRQ_HANDLED;
diff --git a/drivers/iio/trigger/stm32-timer-trigger.c b/drivers/iio/trigger/stm32-timer-trigger.c
index 0e4da570f22f..fbe8213b16cb 100644
--- a/drivers/iio/trigger/stm32-timer-trigger.c
+++ b/drivers/iio/trigger/stm32-timer-trigger.c
@@ -886,6 +886,6 @@ static struct platform_driver stm32_timer_trigger_driver = {
 };
 module_platform_driver(stm32_timer_trigger_driver);
 
-MODULE_ALIAS("platform: stm32-timer-trigger");
+MODULE_ALIAS("platform:stm32-timer-trigger");
 MODULE_DESCRIPTION("STMicroelectronics STM32 Timer Trigger driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 27e7de4c4a34..3f6e6233c60e 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1138,7 +1138,7 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	rcd->egrbufs.rcvtids = NULL;
 
 	for (e = 0; e < rcd->egrbufs.alloced; e++) {
-		if (rcd->egrbufs.buffers[e].dma)
+		if (rcd->egrbufs.buffers[e].addr)
 			dma_free_coherent(&dd->pcidev->dev,
 					  rcd->egrbufs.buffers[e].len,
 					  rcd->egrbufs.buffers[e].addr,
diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index c9bdc5221b82..5849ac5a2ad3 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -232,16 +232,12 @@ static int armada_370_xp_msi_alloc(struct irq_domain *domain, unsigned int virq,
 	int hwirq, i;
 
 	mutex_lock(&msi_used_lock);
+	hwirq = bitmap_find_free_region(msi_used, PCI_MSI_DOORBELL_NR,
+					order_base_2(nr_irqs));
+	mutex_unlock(&msi_used_lock);
 
-	hwirq = bitmap_find_next_zero_area(msi_used, PCI_MSI_DOORBELL_NR,
-					   0, nr_irqs, 0);
-	if (hwirq >= PCI_MSI_DOORBELL_NR) {
-		mutex_unlock(&msi_used_lock);
+	if (hwirq < 0)
 		return -ENOSPC;
-	}
-
-	bitmap_set(msi_used, hwirq, nr_irqs);
-	mutex_unlock(&msi_used_lock);
 
 	for (i = 0; i < nr_irqs; i++) {
 		irq_domain_set_info(domain, virq + i, hwirq + i,
@@ -250,7 +246,7 @@ static int armada_370_xp_msi_alloc(struct irq_domain *domain, unsigned int virq,
 				    NULL, NULL);
 	}
 
-	return hwirq;
+	return 0;
 }
 
 static void armada_370_xp_msi_free(struct irq_domain *domain,
@@ -259,7 +255,7 @@ static void armada_370_xp_msi_free(struct irq_domain *domain,
 	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
 
 	mutex_lock(&msi_used_lock);
-	bitmap_clear(msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&msi_used_lock);
 }
 
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 85b4610e6dc4..33251884bfa1 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -531,7 +531,7 @@ static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
 
 	its_fixup_cmd(cmd);
 
-	return NULL;
+	return desc->its_invall_cmd.col;
 }
 
 static struct its_vpe *its_build_vinvall_cmd(struct its_cmd_block *cmd,
diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index b1777104fd9f..9694529b709d 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -29,7 +29,7 @@
 
 #define NVIC_ISER		0x000
 #define NVIC_ICER		0x080
-#define NVIC_IPR		0x300
+#define NVIC_IPR		0x400
 
 #define NVIC_MAX_BANKS		16
 /*
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8751bd3e5789..c50452af4ded 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -226,15 +226,15 @@ enum m_can_mram_cfg {
 
 /* Interrupts for version 3.0.x */
 #define IR_ERR_LEC_30X	(IR_STE	| IR_FOE | IR_ACKE | IR_BE | IR_CRCE)
-#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
+#define IR_ERR_BUS_30X	(IR_ERR_LEC_30X | IR_WDI | IR_BEU | IR_BEC | \
+			 IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | IR_RF1L | \
+			 IR_RF0L)
 #define IR_ERR_ALL_30X	(IR_ERR_STATE | IR_ERR_BUS_30X)
 /* Interrupts for version >= 3.1.x */
 #define IR_ERR_LEC_31X	(IR_PED | IR_PEA)
-#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_ELO | IR_BEU | \
-			 IR_BEC | IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | \
-			 IR_RF1L | IR_RF0L)
+#define IR_ERR_BUS_31X      (IR_ERR_LEC_31X | IR_WDI | IR_BEU | IR_BEC | \
+			 IR_TOO | IR_MRAF | IR_TSW | IR_TEFL | IR_RF1L | \
+			 IR_RF0L)
 #define IR_ERR_ALL_31X	(IR_ERR_STATE | IR_ERR_BUS_31X)
 
 /* Interrupt Line Select (ILS) */
@@ -765,8 +765,6 @@ static void m_can_handle_other_err(struct net_device *dev, u32 irqstatus)
 {
 	if (irqstatus & IR_WDI)
 		netdev_err(dev, "Message RAM Watchdog event due to missing READY\n");
-	if (irqstatus & IR_ELO)
-		netdev_err(dev, "Error Logging Overflow\n");
 	if (irqstatus & IR_BEU)
 		netdev_err(dev, "Bit Error Uncorrected\n");
 	if (irqstatus & IR_BEC)
diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index c1317889d3d8..ced11ea89269 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -703,11 +703,11 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
 			cf->data[i + 1] = data_reg >> 8;
 		}
 
-		netif_receive_skb(skb);
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
 		stats->rx_bytes += cf->can_dlc;
+		netif_receive_skb(skb);
 
 		pch_fifo_thresh(priv, obj_num);
 		obj_num++;
diff --git a/drivers/net/can/sja1000/ems_pcmcia.c b/drivers/net/can/sja1000/ems_pcmcia.c
index 381de998d2f1..fef5c59c0f4c 100644
--- a/drivers/net/can/sja1000/ems_pcmcia.c
+++ b/drivers/net/can/sja1000/ems_pcmcia.c
@@ -243,7 +243,12 @@ static int ems_pcmcia_add_card(struct pcmcia_device *pdev, unsigned long base)
 			free_sja1000dev(dev);
 	}
 
-	err = request_irq(dev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
+	if (!card->channels) {
+		err = -ENODEV;
+		goto failure_cleanup;
+	}
+
+	err = request_irq(pdev->irq, &ems_pcmcia_interrupt, IRQF_SHARED,
 			  DRV_NAME, card);
 	if (!err)
 		return 0;
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 84def1ff6cb6..691fd194e5ea 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1445,16 +1445,19 @@ static int altera_tse_probe(struct platform_device *pdev)
 		priv->rxdescmem_busaddr = dma_res->start;
 
 	} else {
+		ret = -ENODEV;
 		goto err_free_netdev;
 	}
 
-	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask)))
+	if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask))) {
 		dma_set_coherent_mask(priv->device,
 				      DMA_BIT_MASK(priv->dmaops->dmamask));
-	else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32)))
+	} else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32))) {
 		dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
-	else
+	} else {
+		ret = -EIO;
 		goto err_free_netdev;
+	}
 
 	/* MAC address space */
 	ret = request_and_map(pdev, "control_port", &control_port,
diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 4d4f16ad88c3..97688ba72ade 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -372,6 +372,9 @@ struct bufdesc_ex {
 #define FEC_ENET_WAKEUP	((uint)0x00020000)	/* Wakeup request */
 #define FEC_ENET_TXF	(FEC_ENET_TXF_0 | FEC_ENET_TXF_1 | FEC_ENET_TXF_2)
 #define FEC_ENET_RXF	(FEC_ENET_RXF_0 | FEC_ENET_RXF_1 | FEC_ENET_RXF_2)
+#define FEC_ENET_RXF_GET(X)	(((X) == 0) ? FEC_ENET_RXF_0 :	\
+				(((X) == 1) ? FEC_ENET_RXF_1 :	\
+				FEC_ENET_RXF_2))
 #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 29902b8709f1..6f7ffd975631 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1385,7 +1385,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		writel(FEC_ENET_RXF_GET(queue_id), fep->hwp + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 04dd5758ecf5..62ee0bcf2413 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -787,8 +787,10 @@ int nfp_cpp_area_cache_add(struct nfp_cpp *cpp, size_t size)
 		return -ENOMEM;
 
 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
-	if (!cache)
+	if (!cache) {
+		nfp_cpp_area_free(area);
 		return -ENOMEM;
+	}
 
 	cache->id = 0;
 	cache->addr = 0;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 27c0300e7229..8a8e1616b79a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1580,6 +1580,13 @@ netdev_tx_t qede_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			data_split = true;
 		}
 	} else {
+		if (unlikely(skb->len > ETH_TX_MAX_NON_LSO_PKT_LEN)) {
+			DP_ERR(edev, "Unexpected non LSO skb length = 0x%x\n", skb->len);
+			qede_free_failed_tx_pkt(txq, first_bd, 0, false);
+			qede_update_tx_producer(txq);
+			return NETDEV_TX_OK;
+		}
+
 		val |= ((skb->len & ETH_TX_DATA_1ST_BD_PKT_LEN_MASK) <<
 			 ETH_TX_DATA_1ST_BD_PKT_LEN_SHIFT);
 	}
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 36c7d78ba780..ecd345ca160f 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3495,20 +3495,19 @@ static int ql_adapter_up(struct ql3_adapter *qdev)
 
 	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
 
-	err = ql_wait_for_drvr_lock(qdev);
-	if (err) {
-		err = ql_adapter_initialize(qdev);
-		if (err) {
-			netdev_err(ndev, "Unable to initialize adapter\n");
-			goto err_init;
-		}
-		netdev_err(ndev, "Releasing driver lock\n");
-		ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
-	} else {
+	if (!ql_wait_for_drvr_lock(qdev)) {
 		netdev_err(ndev, "Could not acquire driver lock\n");
+		err = -ENODEV;
 		goto err_lock;
 	}
 
+	err = ql_adapter_initialize(qdev);
+	if (err) {
+		netdev_err(ndev, "Unable to initialize adapter\n");
+		goto err_init;
+	}
+	ql_sem_unlock(qdev, QL_DRVR_SEM_MASK);
+
 	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
 
 	set_bit(QL_ADAPTER_UP, &qdev->flags);
diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 5b5156508f7c..7e4595510c93 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -177,6 +177,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u32 new_tx)
 	/* clamp new_tx to sane values */
 	min = ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb_cdc_ncm_nth16);
 	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
+	if (max == 0)
+		max = CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
 
 	/* some devices set dwNtbOutMaxSize too low for the above default */
 	min = min(min, max);
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 88ca8129d9df..f4f3fcef22a6 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -409,7 +409,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
 	 * the USB-2 spec requires such endpoints to have wMaxPacketSize = 0
 	 * (see the end of section 5.6.3), so don't warn about them.
 	 */
-	maxp = usb_endpoint_maxp(&endpoint->desc);
+	maxp = le16_to_cpu(endpoint->desc.wMaxPacketSize);
 	if (maxp == 0 && !(usb_endpoint_xfer_isoc(d) && asnum == 0)) {
 		dev_warn(ddev, "config %d interface %d altsetting %d endpoint 0x%X has invalid wMaxPacketSize 0\n",
 		    cfgno, inum, asnum, d->bEndpointAddress);
@@ -425,9 +425,9 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
 		maxpacket_maxes = full_speed_maxpacket_maxes;
 		break;
 	case USB_SPEED_HIGH:
-		/* Bits 12..11 are allowed only for HS periodic endpoints */
+		/* Multiple-transactions bits are allowed only for HS periodic endpoints */
 		if (usb_endpoint_xfer_int(d) || usb_endpoint_xfer_isoc(d)) {
-			i = maxp & (BIT(12) | BIT(11));
+			i = maxp & USB_EP_MAXP_MULT_MASK;
 			maxp &= ~i;
 		}
 		/* fallthrough */
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 49806837b98b..bcebec17bdd5 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1635,6 +1635,18 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	struct usb_function		*f = NULL;
 	u8				endp;
 
+	if (w_length > USB_COMP_EP0_BUFSIZ) {
+		if (ctrl->bRequestType == USB_DIR_OUT) {
+			goto done;
+		} else {
+			/* Cast away the const, we are going to overwrite on purpose. */
+			__le16 *temp = (__le16 *)&ctrl->wLength;
+
+			*temp = cpu_to_le16(USB_COMP_EP0_BUFSIZ);
+			w_length = USB_COMP_EP0_BUFSIZ;
+		}
+	}
+
 	/* partial re-init of the response message; the function or the
 	 * gadget might need to intercept e.g. a control-OUT completion
 	 * when we delegate to it.
@@ -2179,7 +2191,7 @@ int composite_dev_prepare(struct usb_composite_driver *composite,
 	if (!cdev->req)
 		return -ENOMEM;
 
-	cdev->req->buf = kmalloc(USB_COMP_EP0_BUFSIZ, GFP_KERNEL);
+	cdev->req->buf = kzalloc(USB_COMP_EP0_BUFSIZ, GFP_KERNEL);
 	if (!cdev->req->buf)
 		goto fail;
 
diff --git a/drivers/usb/gadget/legacy/dbgp.c b/drivers/usb/gadget/legacy/dbgp.c
index 99ca3dabc4f3..f1c5a22704b2 100644
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -136,7 +136,7 @@ static int dbgp_enable_ep_req(struct usb_ep *ep)
 		goto fail_1;
 	}
 
-	req->buf = kmalloc(DBGP_REQ_LEN, GFP_KERNEL);
+	req->buf = kzalloc(DBGP_REQ_LEN, GFP_KERNEL);
 	if (!req->buf) {
 		err = -ENOMEM;
 		stp = 2;
@@ -344,6 +344,19 @@ static int dbgp_setup(struct usb_gadget *gadget,
 	void *data = NULL;
 	u16 len = 0;
 
+	if (length > DBGP_REQ_LEN) {
+		if (ctrl->bRequestType == USB_DIR_OUT) {
+			return err;
+		} else {
+			/* Cast away the const, we are going to overwrite on purpose. */
+			__le16 *temp = (__le16 *)&ctrl->wLength;
+
+			*temp = cpu_to_le16(DBGP_REQ_LEN);
+			length = DBGP_REQ_LEN;
+		}
+	}
+
+
 	if (request == USB_REQ_GET_DESCRIPTOR) {
 		switch (value>>8) {
 		case USB_DT_DEVICE:
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index e9f7f2660cd1..ee4c206150a8 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -113,6 +113,8 @@ enum ep0_state {
 /* enough for the whole queue: most events invalidate others */
 #define	N_EVENT			5
 
+#define RBUF_SIZE		256
+
 struct dev_data {
 	spinlock_t			lock;
 	refcount_t			count;
@@ -147,7 +149,7 @@ struct dev_data {
 	struct dentry			*dentry;
 
 	/* except this scratch i/o buffer for ep0 */
-	u8				rbuf [256];
+	u8				rbuf[RBUF_SIZE];
 };
 
 static inline void get_dev (struct dev_data *data)
@@ -1336,6 +1338,18 @@ gadgetfs_setup (struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
 	u16				w_value = le16_to_cpu(ctrl->wValue);
 	u16				w_length = le16_to_cpu(ctrl->wLength);
 
+	if (w_length > RBUF_SIZE) {
+		if (ctrl->bRequestType == USB_DIR_OUT) {
+			return value;
+		} else {
+			/* Cast away the const, we are going to overwrite on purpose. */
+			__le16 *temp = (__le16 *)&ctrl->wLength;
+
+			*temp = cpu_to_le16(RBUF_SIZE);
+			w_length = RBUF_SIZE;
+		}
+	}
+
 	spin_lock (&dev->lock);
 	dev->setup_abort = 0;
 	if (dev->state == STATE_DEV_UNCONNECTED) {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index e4a82da434c2..7e1b5e00e1f4 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3627,7 +3627,6 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_slot_ctx *slot_ctx;
 	int i, ret;
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * We called pm_runtime_get_noresume when the device was attached.
 	 * Decrement the counter here to allow controller to runtime suspend
@@ -3635,7 +3634,6 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_put_noidle(hcd->self.controller);
-#endif
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
 	/* If the host is halted due to driver unload, we still need to free the
@@ -3790,14 +3788,12 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 
 	udev->slot_id = slot_id;
 
-#ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
 	 * If resetting upon resume, we can't put the controller into runtime
 	 * suspend if there is a device attached.
 	 */
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		pm_runtime_get_noresume(hcd->self.controller);
-#endif
 
 	/* Is this a LS or FS device under a HS hub? */
 	/* Hub or peripherial? */
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 1c667af86da5..0b7c6c2c95b8 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -35,17 +35,7 @@
 
 void signalfd_cleanup(struct sighand_struct *sighand)
 {
-	wait_queue_head_t *wqh = &sighand->signalfd_wqh;
-	/*
-	 * The lockless check can race with remove_wait_queue() in progress,
-	 * but in this case its caller should run under rcu_read_lock() and
-	 * sighand_cachep is SLAB_TYPESAFE_BY_RCU, we can safely return.
-	 */
-	if (likely(!waitqueue_active(wqh)))
-		return;
-
-	/* wait_queue_entry_t->func(POLLFREE) should do remove_wait_queue() */
-	wake_up_poll(wqh, POLLHUP | POLLFREE);
+	wake_up_pollfree(&sighand->signalfd_wqh);
 }
 
 struct signalfd_ctx {
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 0c123c5e70e0..16dc063edc4c 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -162,6 +162,77 @@ struct tracefs_fs_info {
 	struct tracefs_mount_opts mount_opts;
 };
 
+static void change_gid(struct dentry *dentry, kgid_t gid)
+{
+	if (!dentry->d_inode)
+		return;
+	dentry->d_inode->i_gid = gid;
+}
+
+/*
+ * Taken from d_walk, but without he need for handling renames.
+ * Nothing can be renamed while walking the list, as tracefs
+ * does not support renames. This is only called when mounting
+ * or remounting the file system, to set all the files to
+ * the given gid.
+ */
+static void set_gid(struct dentry *parent, kgid_t gid)
+{
+	struct dentry *this_parent;
+	struct list_head *next;
+
+	this_parent = parent;
+	spin_lock(&this_parent->d_lock);
+
+	change_gid(this_parent, gid);
+repeat:
+	next = this_parent->d_subdirs.next;
+resume:
+	while (next != &this_parent->d_subdirs) {
+		struct list_head *tmp = next;
+		struct dentry *dentry = list_entry(tmp, struct dentry, d_child);
+		next = tmp->next;
+
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+
+		change_gid(dentry, gid);
+
+		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			this_parent = dentry;
+			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			goto repeat;
+		}
+		spin_unlock(&dentry->d_lock);
+	}
+	/*
+	 * All done at this level ... ascend and resume the search.
+	 */
+	rcu_read_lock();
+ascend:
+	if (this_parent != parent) {
+		struct dentry *child = this_parent;
+		this_parent = child->d_parent;
+
+		spin_unlock(&child->d_lock);
+		spin_lock(&this_parent->d_lock);
+
+		/* go into the first sibling still alive */
+		do {
+			next = child->d_child.next;
+			if (next == &this_parent->d_subdirs)
+				goto ascend;
+			child = list_entry(next, struct dentry, d_child);
+		} while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED));
+		rcu_read_unlock();
+		goto resume;
+	}
+	rcu_read_unlock();
+	spin_unlock(&this_parent->d_lock);
+	return;
+}
+
 static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 {
 	substring_t args[MAX_OPT_ARGS];
@@ -194,6 +265,7 @@ static int tracefs_parse_options(char *data, struct tracefs_mount_opts *opts)
 			if (!gid_valid(gid))
 				return -EINVAL;
 			opts->gid = gid;
+			set_gid(tracefs_mount->mnt_root, gid);
 			break;
 		case Opt_mode:
 			if (match_octal(&args[0], &option))
@@ -409,6 +481,8 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	inode->i_mode = mode;
 	inode->i_fop = fops ? fops : &tracefs_file_operations;
 	inode->i_private = data;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 	d_instantiate(dentry, inode);
 	fsnotify_create(dentry->d_parent->d_inode, dentry);
 	return end_creating(dentry);
@@ -431,6 +505,8 @@ static struct dentry *__create_dir(const char *name, struct dentry *parent,
 	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
+	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
+	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 5a2c55ed33fa..f2a1f34f41e8 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -807,6 +807,11 @@ static inline bool hid_is_using_ll_driver(struct hid_device *hdev,
 	return hdev->ll_driver == driver;
 }
 
+static inline bool hid_is_usb(struct hid_device *hdev)
+{
+	return hid_is_using_ll_driver(hdev, &usb_hid_driver);
+}
+
 #define	PM_HINT_FULLON	1<<5
 #define PM_HINT_NORMAL	1<<1
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 158715445ffb..42e648083610 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -191,6 +191,7 @@ void __wake_up_locked_key_bookmark(struct wait_queue_head *wq_head,
 void __wake_up_sync_key(struct wait_queue_head *wq_head, unsigned int mode, int nr, void *key);
 void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr);
+void __wake_up_pollfree(struct wait_queue_head *wq_head);
 
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
@@ -215,6 +216,31 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 #define wake_up_interruptible_sync_poll(x, m)					\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
+/**
+ * wake_up_pollfree - signal that a polled waitqueue is going away
+ * @wq_head: the wait queue head
+ *
+ * In the very rare cases where a ->poll() implementation uses a waitqueue whose
+ * lifetime is tied to a task rather than to the 'struct file' being polled,
+ * this function must be called before the waitqueue is freed so that
+ * non-blocking polls (e.g. epoll) are notified that the queue is going away.
+ *
+ * The caller must also RCU-delay the freeing of the wait_queue_head, e.g. via
+ * an explicit synchronize_rcu() or call_rcu(), or via SLAB_TYPESAFE_BY_RCU.
+ */
+static inline void wake_up_pollfree(struct wait_queue_head *wq_head)
+{
+	/*
+	 * For performance reasons, we don't always take the queue lock here.
+	 * Therefore, we might race with someone removing the last entry from
+	 * the queue, and proceed while they still hold the queue lock.
+	 * However, rcu_read_lock() is required to be held in such cases, so we
+	 * can safely proceed with an RCU-delayed free.
+	 */
+	if (waitqueue_active(wq_head))
+		__wake_up_pollfree(wq_head);
+}
+
 #define ___wait_cond_timeout(condition)						\
 ({										\
 	bool __cond = (condition);						\
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4a3333039bf2..08f0588fa832 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2989,7 +2989,7 @@ static void find_good_pkt_pointers(struct bpf_verifier_state *state,
 
 	new_range = dst_reg->off;
 	if (range_right_open)
-		new_range--;
+		new_range++;
 
 	/* Examples for register markings:
 	 *
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index e29608464382..174585abc9b5 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -11,6 +11,7 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 #include <linux/kthread.h>
+#include <linux/poll.h>
 
 void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *key)
 {
@@ -213,6 +214,13 @@ void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr_e
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
+void __wake_up_pollfree(struct wait_queue_head *wq_head)
+{
+	__wake_up(wq_head, TASK_NORMAL, 0, (void *)(POLLHUP | POLLFREE));
+	/* POLLFREE must have cleared the queue. */
+	WARN_ON_ONCE(waitqueue_active(wq_head));
+}
+
 /*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f130d529824b..cd607fbbc2e1 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -942,6 +942,13 @@ void bdi_unregister(struct backing_dev_info *bdi)
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
+	/*
+	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
+	 * update the global bdi_min_ratio.
+	 */
+	if (bdi->min_ratio)
+		bdi_set_min_ratio(bdi, 0);
+
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index f9aa9912f940..358e84af0210 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -633,7 +633,7 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
 
 	ASSERT_RTNL();
 
-	n = kmalloc(sizeof(*n) + key_len, GFP_KERNEL);
+	n = kzalloc(sizeof(*n) + key_len, GFP_KERNEL);
 	if (!n)
 		goto out;
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index de4c9826c1ce..1d641e21f23f 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -128,6 +128,14 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
 
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+
+		/* the control block has been erased, so we have to set the
+		 * iif once again.
+		 * We read the receiving interface index directly from the
+		 * skb->skb_iif as it is done in the IPv4 receiving path (i.e.:
+		 * ip_rcv_core(...)).
+		 */
+		IP6CB(skb)->iif = skb->skb_iif;
 	}
 
 	hdr->nexthdr = NEXTHDR_ROUTING;
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 18957fbf37ff..d7a2580f0420 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1400,8 +1400,10 @@ static int nfc_genl_dump_ses_done(struct netlink_callback *cb)
 {
 	struct class_dev_iter *iter = (struct class_dev_iter *) cb->args[0];
 
-	nfc_device_iter_exit(iter);
-	kfree(iter);
+	if (iter) {
+		nfc_device_iter_exit(iter);
+		kfree(iter);
+	}
 
 	return 0;
 }
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 507fd5210c1c..3fc216644e0e 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -279,6 +279,7 @@ static int copy_ctl_value_to_user(void __user *userdata,
 				  struct snd_ctl_elem_value *data,
 				  int type, int count)
 {
+	struct snd_ctl_elem_value32 __user *data32 = userdata;
 	int i, size;
 
 	if (type == SNDRV_CTL_ELEM_TYPE_BOOLEAN ||
@@ -295,6 +296,8 @@ static int copy_ctl_value_to_user(void __user *userdata,
 		if (copy_to_user(valuep, data->value.bytes.data, size))
 			return -EFAULT;
 	}
+	if (copy_to_user(&data32->id, &data->id, sizeof(data32->id)))
+		return -EFAULT;
 	return 0;
 }
 
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index f855c40b0567..b092f257c1c6 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -162,7 +162,7 @@ snd_pcm_hw_param_value_min(const struct snd_pcm_hw_params *params,
  *
  * Return the maximum value for field PAR.
  */
-static unsigned int
+static int
 snd_pcm_hw_param_value_max(const struct snd_pcm_hw_params *params,
 			   snd_pcm_hw_param_t var, int *dir)
 {
@@ -697,18 +697,24 @@ static int snd_pcm_oss_period_size(struct snd_pcm_substream *substream,
 				   struct snd_pcm_hw_params *oss_params,
 				   struct snd_pcm_hw_params *slave_params)
 {
-	size_t s;
-	size_t oss_buffer_size, oss_period_size, oss_periods;
-	size_t min_period_size, max_period_size;
+	ssize_t s;
+	ssize_t oss_buffer_size;
+	ssize_t oss_period_size, oss_periods;
+	ssize_t min_period_size, max_period_size;
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	size_t oss_frame_size;
 
 	oss_frame_size = snd_pcm_format_physical_width(params_format(oss_params)) *
 			 params_channels(oss_params) / 8;
 
+	oss_buffer_size = snd_pcm_hw_param_value_max(slave_params,
+						     SNDRV_PCM_HW_PARAM_BUFFER_SIZE,
+						     NULL);
+	if (oss_buffer_size <= 0)
+		return -EINVAL;
 	oss_buffer_size = snd_pcm_plug_client_size(substream,
-						   snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_BUFFER_SIZE, NULL)) * oss_frame_size;
-	if (!oss_buffer_size)
+						   oss_buffer_size * oss_frame_size);
+	if (oss_buffer_size <= 0)
 		return -EINVAL;
 	oss_buffer_size = rounddown_pow_of_two(oss_buffer_size);
 	if (atomic_read(&substream->mmap_count)) {
@@ -745,7 +751,7 @@ static int snd_pcm_oss_period_size(struct snd_pcm_substream *substream,
 
 	min_period_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_min(slave_params, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, NULL));
-	if (min_period_size) {
+	if (min_period_size > 0) {
 		min_period_size *= oss_frame_size;
 		min_period_size = roundup_pow_of_two(min_period_size);
 		if (oss_period_size < min_period_size)
@@ -754,7 +760,7 @@ static int snd_pcm_oss_period_size(struct snd_pcm_substream *substream,
 
 	max_period_size = snd_pcm_plug_client_size(substream,
 						   snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_PERIOD_SIZE, NULL));
-	if (max_period_size) {
+	if (max_period_size > 0) {
 		max_period_size *= oss_frame_size;
 		max_period_size = rounddown_pow_of_two(max_period_size);
 		if (oss_period_size > max_period_size)
@@ -767,7 +773,7 @@ static int snd_pcm_oss_period_size(struct snd_pcm_substream *substream,
 		oss_periods = substream->oss.setup.periods;
 
 	s = snd_pcm_hw_param_value_max(slave_params, SNDRV_PCM_HW_PARAM_PERIODS, NULL);
-	if (runtime->oss.maxfrags && s > runtime->oss.maxfrags)
+	if (s > 0 && runtime->oss.maxfrags && s > runtime->oss.maxfrags)
 		s = runtime->oss.maxfrags;
 	if (oss_periods > s)
 		oss_periods = s;
@@ -893,8 +899,15 @@ static int snd_pcm_oss_change_params_locked(struct snd_pcm_substream *substream)
 		err = -EINVAL;
 		goto failure;
 	}
-	choose_rate(substream, sparams, runtime->oss.rate);
-	snd_pcm_hw_param_near(substream, sparams, SNDRV_PCM_HW_PARAM_CHANNELS, runtime->oss.channels, NULL);
+
+	err = choose_rate(substream, sparams, runtime->oss.rate);
+	if (err < 0)
+		goto failure;
+	err = snd_pcm_hw_param_near(substream, sparams,
+				    SNDRV_PCM_HW_PARAM_CHANNELS,
+				    runtime->oss.channels, NULL);
+	if (err < 0)
+		goto failure;
 
 	format = snd_pcm_oss_format_from(runtime->oss.format);
 
@@ -1961,7 +1974,7 @@ static int snd_pcm_oss_set_fragment1(struct snd_pcm_substream *substream, unsign
 	if (runtime->oss.subdivision || runtime->oss.fragshift)
 		return -EINVAL;
 	fragshift = val & 0xffff;
-	if (fragshift >= 31)
+	if (fragshift >= 25) /* should be large enough */
 		return -EINVAL;
 	runtime->oss.fragshift = fragshift;
 	runtime->oss.maxfrags = (val >> 16) & 0xffff;

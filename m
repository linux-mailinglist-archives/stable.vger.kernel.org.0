Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FA2472996
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238201AbhLMKX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33440 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbhLMJrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2CDCB80E0E;
        Mon, 13 Dec 2021 09:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74E4C00446;
        Mon, 13 Dec 2021 09:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388848;
        bh=qGtmHnYT6f1P9Bz1wRRICCh6fDRDmxUQYr0g+bd0b2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgeTrV5jOnR6wfEClqgYxdC0Wj8n/n0MWSqec9WXsT47JIEk9f94WoyI2Y7Gwg9o8
         zglGN/dEH+EJQ00XroQh3TX6OaNQGFJ/kcUwsjth8akmd2e1Sbpq4R9w3D9zqlwnmv
         bvLcCvLEfAMZQ3Tsz/leD5aS+w4Qedw+vUy6Lk8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Michael Zaidman <michael.zaidman@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 5.10 012/132] HID: check for valid USB device for many HID drivers
Date:   Mon, 13 Dec 2021 10:29:13 +0100
Message-Id: <20211213092939.501399042@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 93020953d0fa7035fd036ad87a47ae2b7aa4ae33 upstream.

Many HID drivers assume that the HID device assigned to them is a USB
device as that was the only way HID devices used to be able to be
created in Linux.  However, with the additional ways that HID devices
can be created for many different bus types, that is no longer true, so
properly check that we have a USB device associated with the HID device
before allowing a driver that makes this assumption to claim it.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Michael Zaidman <michael.zaidman@gmail.com>
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
[bentiss: amended for thrustmater.c hunk to apply]
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211201183503.2373082-3-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-chicony.c         |    8 ++++++--
 drivers/hid/hid-corsair.c         |    7 ++++++-
 drivers/hid/hid-elan.c            |    2 +-
 drivers/hid/hid-elo.c             |    3 +++
 drivers/hid/hid-holtek-kbd.c      |    9 +++++++--
 drivers/hid/hid-holtek-mouse.c    |    9 +++++++++
 drivers/hid/hid-lg.c              |   10 ++++++++--
 drivers/hid/hid-prodikeys.c       |   10 ++++++++--
 drivers/hid/hid-roccat-arvo.c     |    3 +++
 drivers/hid/hid-roccat-isku.c     |    3 +++
 drivers/hid/hid-roccat-kone.c     |    3 +++
 drivers/hid/hid-roccat-koneplus.c |    3 +++
 drivers/hid/hid-roccat-konepure.c |    3 +++
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 drivers/hid/hid-roccat-lua.c      |    3 +++
 drivers/hid/hid-roccat-pyra.c     |    3 +++
 drivers/hid/hid-roccat-ryos.c     |    3 +++
 drivers/hid/hid-roccat-savu.c     |    3 +++
 drivers/hid/hid-samsung.c         |    3 +++
 drivers/hid/hid-uclogic-core.c    |    3 +++
 20 files changed, 84 insertions(+), 10 deletions(-)

--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -58,8 +58,12 @@ static int ch_input_mapping(struct hid_d
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
--- a/drivers/hid/hid-corsair.c
+++ b/drivers/hid/hid-corsair.c
@@ -553,7 +553,12 @@ static int corsair_probe(struct hid_devi
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
--- a/drivers/hid/hid-elan.c
+++ b/drivers/hid/hid-elan.c
@@ -50,7 +50,7 @@ struct elan_drvdata {
 
 static int is_not_elan_touchpad(struct hid_device *hdev)
 {
-	if (hdev->bus == BUS_USB) {
+	if (hid_is_usb(hdev)) {
 		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 
 		return (intf->altsetting->desc.bInterfaceNumber !=
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -229,6 +229,9 @@ static int elo_probe(struct hid_device *
 	struct elo_priv *priv;
 	int ret;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
--- a/drivers/hid/hid-holtek-kbd.c
+++ b/drivers/hid/hid-holtek-kbd.c
@@ -140,12 +140,17 @@ static int holtek_kbd_input_event(struct
 static int holtek_kbd_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	int ret = hid_parse(hdev);
+	struct usb_interface *intf;
+	int ret;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
+	ret = hid_parse(hdev);
 	if (!ret)
 		ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 
+	intf = to_usb_interface(hdev->dev.parent);
 	if (!ret && intf->cur_altsetting->desc.bInterfaceNumber == 1) {
 		struct hid_input *hidinput;
 		list_for_each_entry(hidinput, &hdev->inputs, list) {
--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -62,6 +62,14 @@ static __u8 *holtek_mouse_report_fixup(s
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
@@ -83,6 +91,7 @@ static struct hid_driver holtek_mouse_dr
 	.name = "holtek_mouse",
 	.id_table = holtek_mouse_devices,
 	.report_fixup = holtek_mouse_report_fixup,
+	.probe = holtek_mouse_probe,
 };
 
 module_hid_driver(holtek_mouse_driver);
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -769,12 +769,18 @@ static int lg_raw_event(struct hid_devic
 
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
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -798,12 +798,18 @@ static int pk_raw_event(struct hid_devic
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
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -344,6 +344,9 @@ static int arvo_probe(struct hid_device
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -324,6 +324,9 @@ static int isku_probe(struct hid_device
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -749,6 +749,9 @@ static int kone_probe(struct hid_device
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -431,6 +431,9 @@ static int koneplus_probe(struct hid_dev
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -133,6 +133,9 @@ static int konepure_probe(struct hid_dev
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -501,6 +501,9 @@ static int kovaplus_probe(struct hid_dev
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-lua.c
+++ b/drivers/hid/hid-roccat-lua.c
@@ -160,6 +160,9 @@ static int lua_probe(struct hid_device *
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -449,6 +449,9 @@ static int pyra_probe(struct hid_device
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -141,6 +141,9 @@ static int ryos_probe(struct hid_device
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -113,6 +113,9 @@ static int savu_probe(struct hid_device
 {
 	int retval;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	retval = hid_parse(hdev);
 	if (retval) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -152,6 +152,9 @@ static int samsung_probe(struct hid_devi
 	int ret;
 	unsigned int cmask = HID_CONNECT_DEFAULT;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -164,6 +164,9 @@ static int uclogic_probe(struct hid_devi
 	struct uclogic_drvdata *drvdata = NULL;
 	bool params_initialized = false;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	/*
 	 * libinput requires the pad interface to be on a different node
 	 * than the pen, so use QUIRK_MULTI_INPUT for all tablets.



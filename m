Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569A04728C8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhLMKOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239686AbhLMKIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:08:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC374C08EA73;
        Mon, 13 Dec 2021 01:53:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F4C2B80E12;
        Mon, 13 Dec 2021 09:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900C6C00446;
        Mon, 13 Dec 2021 09:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389178;
        bh=Xwj1vNv4JNa7yqdxyM77U5EwxDaenz5Z3oUZdEmVxds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sptppDfs8yEnGjhK3CWn/F+WFvtcuLMKfckU71RukfLp1XmWGszGjayfPBXFbzjNP
         Gw8BtHBl0pEJfhRelZi40e15NahieTDTzcqeKJvMq3Q4Fp0tIEIm3JaakqCPjuwM9m
         29onSmvBRsjilFatNg0A/jukg2Q3I3AvTXhMoG+o=
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
Subject: [PATCH 5.15 011/171] HID: check for valid USB device for many HID drivers
Date:   Mon, 13 Dec 2021 10:28:46 +0100
Message-Id: <20211213092945.472034216@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
 drivers/hid/hid-chicony.c         |    3 +++
 drivers/hid/hid-corsair.c         |    7 ++++++-
 drivers/hid/hid-elan.c            |    2 +-
 drivers/hid/hid-elo.c             |    3 +++
 drivers/hid/hid-ft260.c           |    3 +++
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
 drivers/hid/hid-sony.c            |    6 +++++-
 drivers/hid/hid-thrustmaster.c    |    3 +++
 drivers/hid/hid-uclogic-core.c    |    3 +++
 23 files changed, 92 insertions(+), 9 deletions(-)

--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -114,6 +114,9 @@ static int ch_probe(struct hid_device *h
 {
 	int ret;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	hdev->quirks |= HID_QUIRK_INPUT_PER_APP;
 	ret = hid_parse(hdev);
 	if (ret) {
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
@@ -230,6 +230,9 @@ static int elo_probe(struct hid_device *
 	int ret;
 	struct usb_device *udev;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -915,6 +915,9 @@ static int ft260_probe(struct hid_device
 	struct ft260_get_chip_version_report version;
 	int ret;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
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
@@ -749,12 +749,18 @@ static int lg_raw_event(struct hid_devic
 
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
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -3000,7 +3000,6 @@ static int sony_probe(struct hid_device
 	sc->quirks = quirks;
 	hid_set_drvdata(hdev, sc);
 	sc->hdev = hdev;
-	usbdev = to_usb_device(sc->hdev->dev.parent->parent);
 
 	ret = hid_parse(hdev);
 	if (ret) {
@@ -3043,6 +3042,11 @@ static int sony_probe(struct hid_device
 	}
 
 	if (sc->quirks & (GHL_GUITAR_PS3WIIU | GHL_GUITAR_PS4)) {
+		if (!hid_is_usb(hdev))
+			return -EINVAL;
+
+		usbdev = to_usb_device(sc->hdev->dev.parent->parent);
+
 		sc->ghl_urb = usb_alloc_urb(0, GFP_ATOMIC);
 		if (!sc->ghl_urb)
 			return -ENOMEM;
--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -274,6 +274,9 @@ static int thrustmaster_probe(struct hid
 	int ret = 0;
 	struct tm_wheel *tm_wheel = 0;
 
+	if (!hid_is_usb(hdev))
+		return -EINVAL;
+
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed with error %d\n", ret);
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



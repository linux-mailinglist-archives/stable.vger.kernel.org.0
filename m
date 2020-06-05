Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E201EFA69
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgFEORU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgFEORS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E374020B80;
        Fri,  5 Jun 2020 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366637;
        bh=Pkcwu9AqmId6jd12wS0uGd4NuEHW69FIQ87ZrnjzgDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKq2OmYbOm/cLJlrmqzieF/NS3kD6rmBmdsVKNK8ANsT147Lem8twCImRmXMV3ibX
         PEq+Y3/bJ1Ph52nA90u88UImLhP6xbtFabrLplvx01CU2ln7PyIXTHhpsZgbB7SwWD
         /kvpKpf3rZfzaV5mJ0KFrhIdzUGNv1RuHGfNOC98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.6 33/43] HID: multitouch: enable multi-input as a quirk for some devices
Date:   Fri,  5 Jun 2020 16:15:03 +0200
Message-Id: <20200605140154.258356179@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 40d5bb87377a599d0405af765290f28aaa6abb1e upstream.

Two touchpad/trackstick combos are currently not behaving properly.
They define a mouse emulation collection, as per Win8 requirements,
but also define a separate mouse collection for the trackstick.

The way the kernel currently treat the collections is that it
merges both in one device. However, given that the first mouse
collection already defines X,Y and left, right buttons, when
mapping the events from the second mouse collection, hid-multitouch
sees that these events are already mapped, and simply ignores them.

To be able to report events from the tracktick, add a new quirked
class for it, and manually add the 2 devices we know about.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=207235
Cc: stable@vger.kernel.org
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-multitouch.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -69,6 +69,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_ASUS_CUSTOM_UP		BIT(17)
 #define MT_QUIRK_WIN8_PTP_BUTTONS	BIT(18)
 #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
+#define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -189,6 +190,7 @@ static void mt_post_parse(struct mt_devi
 #define MT_CLS_WIN_8				0x0012
 #define MT_CLS_EXPORT_ALL_INPUTS		0x0013
 #define MT_CLS_WIN_8_DUAL			0x0014
+#define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -279,6 +281,15 @@ static const struct mt_class mt_classes[
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_WIN8_PTP_BUTTONS,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_FORCE_MULTI_INPUT,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -1714,6 +1725,11 @@ static int mt_probe(struct hid_device *h
 	if (id->group != HID_GROUP_MULTITOUCH_WIN_8)
 		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
 
+	if (mtclass->quirks & MT_QUIRK_FORCE_MULTI_INPUT) {
+		hdev->quirks &= ~HID_QUIRK_INPUT_PER_APP;
+		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+	}
+
 	timer_setup(&td->release_timer, mt_expired_timeout, 0);
 
 	ret = hid_parse(hdev);
@@ -1926,6 +1942,11 @@ static const struct hid_device_id mt_dev
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002) },
 
+	/* Elan devices */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x313a) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
@@ -2056,6 +2077,11 @@ static const struct hid_device_id mt_dev
 		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
 			USB_DEVICE_ID_MTP_STM)},
 
+	/* Synaptics devices */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_SYNAPTICS, 0xce08) },
+
 	/* TopSeed panels */
 	{ .driver_data = MT_CLS_TOPSEED,
 		MT_USB_DEVICE(USB_VENDOR_ID_TOPSEED2,



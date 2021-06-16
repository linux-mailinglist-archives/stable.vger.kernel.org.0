Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6AF3A9FE6
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhFPPmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhFPPj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70982613ED;
        Wed, 16 Jun 2021 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857830;
        bh=B+nrC2yFQwCH38DZKczpZ6aG8TCc9FQtjKYz+FHicO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ1g76jHyEMuLN7/XHNvyJhGjXzRJDZFH2Q7hpFfe/pRKwQVTff/iORUQoUemmhaj
         xPqFBUDpsKjGZArPPMGlH1qbndlk6CLHeEyS+nnqjtKLa/q3vcQ5nBz/fQs51mBoJ/
         c9e+ZVV3PILydZLQuhIbzYbZ5oAoJ5dcnOPlVqpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 23/48] HID: multitouch: Disable event reporting on suspend on the Asus T101HA touchpad
Date:   Wed, 16 Jun 2021 17:33:33 +0200
Message-Id: <20210616152837.383895221@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
References: <20210616152836.655643420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 31a4cf1d223dc6144d2e7c679cc3a98f84a1607b ]

The Asus T101HA has a problem with spurious wakeups when the lid is
closed, this is caused by the screen sitting so close to the touchpad
that the touchpad ends up reporting touch events, causing these wakeups.

Add a quirk which disables event reporting on suspend when set, and
enable this quirk for the Asus T101HA touchpad fixing the spurious
wakeups, while still allowing the device to be woken by pressing a
key on the keyboard (which is part of the same USB device).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index eed81bdc2e86..2e4fb76c45f3 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -70,6 +70,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_WIN8_PTP_BUTTONS	BIT(18)
 #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
 #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
+#define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -191,6 +192,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_EXPORT_ALL_INPUTS		0x0013
 /* reserved					0x0014 */
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
+#define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -283,6 +285,15 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_WIN8_PTP_BUTTONS |
 			MT_QUIRK_FORCE_MULTI_INPUT,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_DISABLE_WAKEUP,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_DISABLE_WAKEUP,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -763,7 +774,8 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			return 1;
 		case HID_DG_CONFIDENCE:
 			if ((cls->name == MT_CLS_WIN_8 ||
-			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT) &&
+			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
+			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
 				app->quirks |= MT_QUIRK_CONFIDENCE;
@@ -1753,8 +1765,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 #ifdef CONFIG_PM
 static int mt_suspend(struct hid_device *hdev, pm_message_t state)
 {
+	struct mt_device *td = hid_get_drvdata(hdev);
+
 	/* High latency is desirable for power savings during S3/S0ix */
-	mt_set_modes(hdev, HID_LATENCY_HIGH, true, true);
+	if (td->mtclass.quirks & MT_QUIRK_DISABLE_WAKEUP)
+		mt_set_modes(hdev, HID_LATENCY_HIGH, false, false);
+	else
+		mt_set_modes(hdev, HID_LATENCY_HIGH, true, true);
+
 	return 0;
 }
 
@@ -1813,6 +1831,12 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_ANTON,
 			USB_DEVICE_ID_ANTON_TOUCH_PAD) },
 
+	/* Asus T101HA */
+	{ .driver_data = MT_CLS_WIN_8_DISABLE_WAKEUP,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_ASUSTEK,
+			   USB_DEVICE_ID_ASUSTEK_T101HA_KEYBOARD) },
+
 	/* Asus T304UA */
 	{ .driver_data = MT_CLS_ASUS,
 		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
-- 
2.30.2




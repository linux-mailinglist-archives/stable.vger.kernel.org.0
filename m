Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FAC39E1F7
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhFGQOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhFGQOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B402461403;
        Mon,  7 Jun 2021 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082364;
        bh=6oQnb4cR2EZows9NeHlZ+bIaKQt/uyMishpAEm92e1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIGdXGVhRH5hoXry/cNOveGETzKqTusrMY2xNqQSsiEHAN0hbMYra0LxOaiTYRmFV
         v2WidqoqiDv/PcRkVSrAO5vsO9DtK500triuOQCpKM/lYJeczigzk44cCd95xfBdHP
         bf0vy9rZxKYarZ1HAQzGr3Yj6WsDca4URWPeEyA5GglG6zQ/0HQfpdf+DUxUSMRWM0
         91VUfQjGpzwZivhJ6Og7rHmNc7QAnCTgT4wZ8TUjZq/7ZvMa3Yx+bj5iiM18ALtBtF
         JeNtJzqflSOS2mn1mOo0ql8YwRupWjZhldecamOKpG54755Wzt9ZzGo7wU4p8MCSYx
         q7Y/bjIwV5zVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 23/49] HID: multitouch: Disable event reporting on suspend on the Asus T101HA touchpad
Date:   Mon,  7 Jun 2021 12:11:49 -0400
Message-Id: <20210607161215.3583176-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ae1fee9d7474..6bc49fb53d74 100644
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
@@ -759,7 +770,8 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			return 1;
 		case HID_DG_CONFIDENCE:
 			if ((cls->name == MT_CLS_WIN_8 ||
-			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT) &&
+			     cls->name == MT_CLS_WIN_8_FORCE_MULTI_INPUT ||
+			     cls->name == MT_CLS_WIN_8_DISABLE_WAKEUP) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
 				app->quirks |= MT_QUIRK_CONFIDENCE;
@@ -1749,8 +1761,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
 
@@ -1809,6 +1827,12 @@ static const struct hid_device_id mt_devices[] = {
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


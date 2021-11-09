Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE64244B5D3
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241713AbhKIWXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245674AbhKIWVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CF061884;
        Tue,  9 Nov 2021 22:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496294;
        bh=dAm2WsqLF/8f/Uzm4+iGVYDQKbj5fpo0cPcL1hzI9xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCaRUfnvmTJ0xAP6OW/P9iZiGjlaOxRkdiM3zNSTvkprkrMeMnckB0kXdT0iJlXZj
         KJOEA9zesoLg6KjuTG+S8vIAqgdhn26fYlKaDLYQqmk1nBd33WULTXaKxD7TK9zuRV
         CnNZYEKGV79kSeclQSalKyC55mrjPRpCDod3JfZgRnh0b9ddXm4gFNYekw3Vj8Et3I
         TEWcVWMIsQwUr4Dz276WFjPorxuhjQiD6yj7O0jZrut/fWgcG8xvb48H2gE02snRaw
         oG/xXTGw8stiRVWth3HYzTGdrVmEqg1rauW+HZ5Ynh0jyRkSEebYQBDgFkMe9Airme
         thwJPTp+ijsOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 51/82] HID: multitouch: disable sticky fingers for UPERFECT Y
Date:   Tue,  9 Nov 2021 17:16:09 -0500
Message-Id: <20211109221641.1233217-51-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 08b9a61a87bc339a73c584d8924c86ab36d204a7 ]

When a finger is on the screen, the UPERFECT Y portable touchscreen
monitor reports a contact in the first place. However, after this
initial report, contacts are not reported at the refresh rate of the
screen as required by the Windows 8 specs.

This behaviour triggers the release_timer, removing the fingers even
though they are still present.

To avoid it, add a new class, similar to MT_CLS_WIN_8 but without the
MT_QUIRK_STICKY_FINGERS quirk for this device.

Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        |  3 +++
 drivers/hid/hid-multitouch.c | 13 +++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 29564b370341e..3706c635b12ee 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1276,6 +1276,9 @@
 #define	USB_DEVICE_ID_WEIDA_8752	0xC300
 #define	USB_DEVICE_ID_WEIDA_8755	0xC301
 
+#define USB_VENDOR_ID_WINBOND		0x0416
+#define USB_DEVICE_ID_TSTP_MTOUCH	0xc168
+
 #define USB_VENDOR_ID_WISEGROUP		0x0925
 #define USB_DEVICE_ID_SMARTJOY_PLUS	0x0005
 #define USB_DEVICE_ID_SUPER_JOY_BOX_3	0x8888
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3ea7cb1cda84c..e1afddb7b33d8 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -193,6 +193,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 /* reserved					0x0014 */
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
 #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
+#define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -294,6 +295,13 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_WIN8_PTP_BUTTONS |
 			MT_QUIRK_DISABLE_WAKEUP,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_WIN_8_NO_STICKY_FINGERS,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_WIN8_PTP_BUTTONS,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -2120,6 +2128,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_VTL,
 			USB_DEVICE_ID_VTL_MULTITOUCH_FF3F) },
 
+	/* Winbond Electronics Corp. */
+	{ .driver_data = MT_CLS_WIN_8_NO_STICKY_FINGERS,
+		HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_WINBOND, USB_DEVICE_ID_TSTP_MTOUCH) },
+
 	/* Wistron panels */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_WISTRON,
-- 
2.33.0


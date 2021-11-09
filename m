Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F4644B6E4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344712AbhKIWag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344774AbhKIW2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12A5261A55;
        Tue,  9 Nov 2021 22:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496423;
        bh=luWFUMbZtFqtHq1P8PewpSI3Ffyi8fGuNDt8uwsEVq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i72u9HQiRu+ZRzSITrt3wj/AZYUkTVq++Hii5oulkUCG9mnAr996gT5ZvyygwwzpM
         HhQkRuaf2AD5u8MAMcnKcQ47difHcHj6MDYWxikhNAXQYhhs34VIwAVJ9wEYsBNns1
         jqzZexd7kBctYm6J6N3q9IoKmsSnHKz8B//z9ozPvVyk++3xl2f0MJrzPtRD5D5Ar7
         EySIRLwnGOzytmc0Ez8T97JgIq4usefF90uO0O8wDEUW6wiq6kRF4Fai/BPmaujufl
         A3M/drY7gttCNG2baOsn7Q1FV2A70EiYpguTwqJc+uJYsaA42NfKwRavSXiKGdESwi
         PMK7qKEMTrrPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 48/75] HID: multitouch: disable sticky fingers for UPERFECT Y
Date:   Tue,  9 Nov 2021 17:18:38 -0500
Message-Id: <20211109221905.1234094-48-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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
index 8f1893e68112b..ef663c43b1772 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1273,6 +1273,9 @@
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


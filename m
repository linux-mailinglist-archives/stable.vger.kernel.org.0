Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6D645C47A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351600AbhKXNt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351159AbhKXNq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7FAB63340;
        Wed, 24 Nov 2021 13:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758872;
        bh=dAm2WsqLF/8f/Uzm4+iGVYDQKbj5fpo0cPcL1hzI9xU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXK4XITdccfo6KsOGlkv6W47xqlz8aPgfhRqEj8iwWu3vcG6hJPATvTr8zzjgZn2i
         Uty6hAPhBcPzxNQUIMeaugCEFEM1m27yqFNL/7/6om++EDiKMLIBwLZBaibQnb4fvz
         5vgFAsd8eILbrKOxgr2WO9BDbJVIiEDWK0DFBtk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/279] HID: multitouch: disable sticky fingers for UPERFECT Y
Date:   Wed, 24 Nov 2021 12:55:37 +0100
Message-Id: <20211124115720.458118368@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




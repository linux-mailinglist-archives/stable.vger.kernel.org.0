Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490786A3730
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjB0CHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjB0CG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7D6CDEE;
        Sun, 26 Feb 2023 18:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C267EB80CBB;
        Mon, 27 Feb 2023 02:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57526C4339B;
        Mon, 27 Feb 2023 02:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463586;
        bh=XPJpeSdRnBnhaLREdf2QTqaEce4WcAfaAXTbHhAWunE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0ey9l/bSAeLXYQ8QAUM/F79B9cSnqLo6kEt5IasRvOEt0p8aldmy6XvcCva12xQv
         kURHONkGHCYz3xep5ARkGb/RzdasmkBjvUhbXg4cD0/chAxsJ+aJmHh+csxskJ56bM
         /oAKCvrNSXwY/8/VR3Y8LR69Q09cHkWUMXMjNV20OrWxTvdqZF2kwesZ5XS4FRGCwP
         OSM/u2YRUK0U6lNenMKooqoKYI6w4V7JUBIqfOwlu+qT3E/oXFIk5wTgtW34O6fODQ
         cclGYYmUnKDEpSOvja6/sADisWpO4TzjxMW2/SO90oLcuB/3iEwR0tH2MmpS/C62V2
         o0H3SfPQJxt2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Mia Kanashi <chad@redpilled.dev>,
        Andreas Grosse <andig.mail@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/58] HID: uclogic: Add frame type quirk
Date:   Sun, 26 Feb 2023 21:04:17 -0500
Message-Id: <20230227020457.1048737-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 14b71e6ad8ca59dd734c7fa9676f3d60bddee2a9 ]

The report descriptor used to get information about UGEE v2 devices is
incorrect in the XP-PEN Deco Pro SW. It indicates that the device frame
is of type UCLOGIC_PARAMS_FRAME_BUTTONS but the device has a frame of
type UCLOGIC_PARAMS_FRAME_MOUSE.

Here is the original report descriptor:

  0x0e 0x03 0xc8 0xb3 0x34 0x65 0x08 0x00 0xff 0x1f 0xd8 0x13 0x00 0x00
                                     ^ This byte should be 2

Add a quirk to be able to fix the reported frame type.

Tested-by: Mia Kanashi <chad@redpilled.dev>
Tested-by: Andreas Grosse <andig.mail@t-online.de>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-core.c   | 20 +-------------------
 drivers/hid/hid-uclogic-params.c |  5 +++++
 drivers/hid/hid-uclogic-params.h | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index cfbbc39807a69..739984b8fa1b8 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -22,25 +22,6 @@
 
 #include "hid-ids.h"
 
-/* Driver data */
-struct uclogic_drvdata {
-	/* Interface parameters */
-	struct uclogic_params params;
-	/* Pointer to the replacement report descriptor. NULL if none. */
-	__u8 *desc_ptr;
-	/*
-	 * Size of the replacement report descriptor.
-	 * Only valid if desc_ptr is not NULL
-	 */
-	unsigned int desc_size;
-	/* Pen input device */
-	struct input_dev *pen_input;
-	/* In-range timer */
-	struct timer_list inrange_timer;
-	/* Last rotary encoder state, or U8_MAX for none */
-	u8 re_state;
-};
-
 /**
  * uclogic_inrange_timeout - handle pen in-range state timeout.
  * Emulate input events normally generated when pen goes out of range for
@@ -202,6 +183,7 @@ static int uclogic_probe(struct hid_device *hdev,
 	}
 	timer_setup(&drvdata->inrange_timer, uclogic_inrange_timeout, 0);
 	drvdata->re_state = U8_MAX;
+	drvdata->quirks = id->driver_data;
 	hid_set_drvdata(hdev, drvdata);
 
 	/* Initialize the device and retrieve interface parameters */
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 3c5eea3df3288..e052538a62fb3 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1298,6 +1298,7 @@ static int uclogic_params_ugee_v2_init(struct uclogic_params *params,
 				       struct hid_device *hdev)
 {
 	int rc = 0;
+	struct uclogic_drvdata *drvdata;
 	struct usb_interface *iface;
 	__u8 bInterfaceNumber;
 	const int str_desc_len = 12;
@@ -1316,6 +1317,7 @@ static int uclogic_params_ugee_v2_init(struct uclogic_params *params,
 		goto cleanup;
 	}
 
+	drvdata = hid_get_drvdata(hdev);
 	iface = to_usb_interface(hdev->dev.parent);
 	bInterfaceNumber = iface->cur_altsetting->desc.bInterfaceNumber;
 
@@ -1382,6 +1384,9 @@ static int uclogic_params_ugee_v2_init(struct uclogic_params *params,
 	p.pen.subreport_list[0].id = UCLOGIC_RDESC_V1_FRAME_ID;
 
 	/* Initialize the frame interface */
+	if (drvdata->quirks & UCLOGIC_MOUSE_FRAME_QUIRK)
+		frame_type = UCLOGIC_PARAMS_FRAME_MOUSE;
+
 	switch (frame_type) {
 	case UCLOGIC_PARAMS_FRAME_DIAL:
 	case UCLOGIC_PARAMS_FRAME_MOUSE:
diff --git a/drivers/hid/hid-uclogic-params.h b/drivers/hid/hid-uclogic-params.h
index a97477c02ff82..10a05c7fd9398 100644
--- a/drivers/hid/hid-uclogic-params.h
+++ b/drivers/hid/hid-uclogic-params.h
@@ -19,6 +19,8 @@
 #include <linux/usb.h>
 #include <linux/hid.h>
 
+#define UCLOGIC_MOUSE_FRAME_QUIRK	BIT(0)
+
 /* Types of pen in-range reporting */
 enum uclogic_params_pen_inrange {
 	/* Normal reports: zero - out of proximity, one - in proximity */
@@ -215,6 +217,27 @@ struct uclogic_params {
 	struct uclogic_params_frame frame_list[3];
 };
 
+/* Driver data */
+struct uclogic_drvdata {
+	/* Interface parameters */
+	struct uclogic_params params;
+	/* Pointer to the replacement report descriptor. NULL if none. */
+	__u8 *desc_ptr;
+	/*
+	 * Size of the replacement report descriptor.
+	 * Only valid if desc_ptr is not NULL
+	 */
+	unsigned int desc_size;
+	/* Pen input device */
+	struct input_dev *pen_input;
+	/* In-range timer */
+	struct timer_list inrange_timer;
+	/* Last rotary encoder state, or U8_MAX for none */
+	u8 re_state;
+	/* Device quirks */
+	unsigned long quirks;
+};
+
 /* Initialize a tablet interface and discover its parameters */
 extern int uclogic_params_init(struct uclogic_params *params,
 				struct hid_device *hdev);
-- 
2.39.0


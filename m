Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C16A390D
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjB0CxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjB0CxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:53:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0E38A4C;
        Sun, 26 Feb 2023 18:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6554DCE0F2C;
        Mon, 27 Feb 2023 02:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38F6C433EF;
        Mon, 27 Feb 2023 02:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463590;
        bh=aZWXodM9UhFFnnXg7/N7jBXUEp/K4EB74aSpNBJ5yBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAkSgsisjbE+jWHk6++AIg9FI2XxvPAh1dybiWhbntMneIIulagACTamZZM0CI5fD
         Qfstw0xrnfHX5DUjF62QTnCXWpLr2XoSn8LDEhd1Ko8hc9FBP0B93C6BuPu3QGAm8J
         HC8lCqDiAeGOOk1vtSJn7iLyrnij1r8jGX976EtLwISLT+A1NbV/r6abxp6Lj0ERpl
         mvpR54rhrZo5TA3y7sesSSAyneKOeScKnbR2DFgHiRNxVia0xRswEuo86hcI3yrYje
         3wXuFiTODh5FlGV27K3uDWoPOX/QwXZkx5fQsrUzL6D5kKJPTXuQgIcvYNH8YXno3V
         druSiJJxSHvEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Andreas Grosse <andig.mail@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 22/58] HID: uclogic: Add support for XP-PEN Deco Pro MW
Date:   Sun, 26 Feb 2023 21:04:20 -0500
Message-Id: <20230227020457.1048737-22-sashal@kernel.org>
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

[ Upstream commit 9266a88156d1fbb8e50d6eeff7bac44ad4eaecc2 ]

The XP-PEN Deco Pro MW is a UGEE v2 device with a frame with 8 buttons,
a bitmap dial and a mouse. Its pen has 2 buttons, supports tilt and
pressure.

It can be connected using a USB cable or, to use it in wireless mode,
using a USB Bluetooth dongle. When it is connected in wireless mode the
device battery is used to power it.

All the pieces to support it are already in place. Add its ID and
quirks in order to support the device.

Link: https://github.com/DIGImend/digimend-kernel-drivers/issues/622
Tested-by: Andreas Grosse <andig.mail@t-online.de>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h            | 1 +
 drivers/hid/hid-input.c          | 2 ++
 drivers/hid/hid-uclogic-core.c   | 3 +++
 drivers/hid/hid-uclogic-params.c | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9eca3e0cffae4..c0d983ca09107 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1296,6 +1296,7 @@
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01	0x0042
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2	0x0905
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L	0x0935
+#define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW	0x0934
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S	0x0909
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW	0x0933
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_STAR06	0x0078
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index ee07d3e341fc4..3116aee21ceb9 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -376,6 +376,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 7c05d38d3afad..bfbb51f8b5beb 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -511,6 +511,9 @@ static const struct hid_device_id uclogic_devices[] = {
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
+				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW),
+		.driver_data = UCLOGIC_MOUSE_FRAME_QUIRK | UCLOGIC_BATTERY_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 492a30f83575a..0cc03c11ecc22 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1669,6 +1669,8 @@ int uclogic_params_init(struct uclogic_params *params,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L):
+	case VID_PID(USB_VENDOR_ID_UGEE,
+		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_MW):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S):
 	case VID_PID(USB_VENDOR_ID_UGEE,
-- 
2.39.0


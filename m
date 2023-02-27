Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A6B6A36B0
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjB0CD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjB0CDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:03:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8012614238;
        Sun, 26 Feb 2023 18:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CD6A60D2D;
        Mon, 27 Feb 2023 02:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2CFC4339B;
        Mon, 27 Feb 2023 02:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463339;
        bh=9r2pqF8+uz4WaigftTV4SBlazPUhGyAOHHO2s2TW4yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msU4BUCB0/BI+7f6t5R8lXkuDbyd0lx20IctMKkB116L4MY3DTOqmyakjT+6ZGxx5
         OWicas0HzXUxiOCeT2kpLecKvrdyi/mmGTt9ZHsMOKv+mSGXYvJgLfH1NaYxIwqQ3s
         iWoG2KsKJ9jRxHT78SQ6G7QzAlAOiNDnQFmT8HPuI9VXkBfHzXzYziwoQB3fGCv8XP
         j8BoDPB7oICYnUj9xQm8oVAOcKa4JAM30PTtjpDF8NPGV6C8kNb4QUv/d64n//5bFx
         GznlHnRKBvUz/7a8nh5PV4Cv8AZfXKnx+UvZV1WcvPcMQdqyaJY4qU9NK9goJGwwgd
         dCLaTVG/0gNPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 21/60] HID: uclogic: Add support for XP-PEN Deco Pro SW
Date:   Sun, 26 Feb 2023 21:00:06 -0500
Message-Id: <20230227020045.1045105-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 7744ca571af55b794595cff2da9d51a26904998f ]

The XP-PEN Deco Pro SW is a UGEE v2 device with a frame with 8 buttons,
a bitmap dial and a mouse; however, the UCLOGIC_MOUSE_FRAME_QUIRK is
required because it reports an incorrect frame type. Its pen has 2
buttons, supports tilt and pressure.

It can be connected using a USB cable or, to use it in wireless mode,
using a USB Bluetooth dongle. When it is connected in wireless mode the
device battery is used to power it.

All the pieces to support it are already in place. Add its ID and
quirks in order to support the device.

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
index 9e36b4cd905ee..c662994d73381 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1300,6 +1300,7 @@
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2	0x0905
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L	0x0935
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S	0x0909
+#define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW	0x0933
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_STAR06	0x0078
 #define USB_DEVICE_ID_UGEE_TABLET_G5		0x0074
 #define USB_DEVICE_ID_UGEE_TABLET_EX07S		0x0071
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index bd0cfccfb7a25..0f8a5152e48b1 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -378,6 +378,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 739984b8fa1b8..7c05d38d3afad 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -513,6 +513,9 @@ static const struct hid_device_id uclogic_devices[] = {
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
+				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW),
+		.driver_data = UCLOGIC_MOUSE_FRAME_QUIRK | UCLOGIC_BATTERY_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_STAR06) },
 	{ }
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 23624d5b07b5a..492a30f83575a 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1671,6 +1671,8 @@ int uclogic_params_init(struct uclogic_params *params,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S):
+	case VID_PID(USB_VENDOR_ID_UGEE,
+		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_SW):
 		rc = uclogic_params_ugee_v2_init(&p, hdev);
 		if (rc != 0)
 			goto cleanup;
-- 
2.39.0


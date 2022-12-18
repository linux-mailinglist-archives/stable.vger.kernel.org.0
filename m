Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82D650124
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiLRQYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiLRQXU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A514113E2E;
        Sun, 18 Dec 2022 08:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C1360DDA;
        Sun, 18 Dec 2022 16:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3DEC433F1;
        Sun, 18 Dec 2022 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379750;
        bh=yreuj1Pmw8nwCm3ADVtacDriCMOlBPDxspsHT79iAJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTNYzURotwI4vx5A8pJi6uEEltQSZNH1Fvwz21YUCn0xBoyV8vvDwllHSmzTmJ5l6
         yIDtdznLItX99q+rSaNXTHuhCdJsx//kppcOiscCzs/djFQA3kBibbAA6NK9oq8+mE
         eqnlT9+ZwLvaOdFvCdl0fku7NtuSOBvhijraFsDRxcxXQB7R5hQWMhMlvcxqPZeqK5
         lkL7PG/LG3VRGFLJdPiiummJoIPSUTOnWgeiWL+vN3MSulU8NTRdwpfpG2McHBTw0w
         0yd/6rKMSoLv6QGmKFRsBaHfvE9CH1JpQN1mZA9/dwA3kSBJE1ZhRRTw3kLOnYA3h4
         m+gcjn1Mgw75w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Mia Kanashi <chad@redpilled.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 24/73] HID: input: do not query XP-PEN Deco LW battery
Date:   Sun, 18 Dec 2022 11:06:52 -0500
Message-Id: <20221218160741.927862-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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

[ Upstream commit 037c1aaeb96fe5f778026f4c1ef28b26cf600bfa ]

The XP-PEN Deco LW drawing tablet can be connected by USB cable or using
a USB Bluetooth dongle. When it is connected using the dongle, there
might be a small delay until the tablet is paired with the dongle.

Fetching the device battery during this delay results in random battery
percentage values.

Add a quirk to avoid actively querying the battery percentage and wait
for the device to report it on its own.

Reported-by: Mia Kanashi <chad@redpilled.dev>
Tested-by: Mia Kanashi <chad@redpilled.dev>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 859aeb07542e..d728a94c642e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -340,6 +340,7 @@ static enum power_supply_property hidinput_battery_props[] = {
 #define HID_BATTERY_QUIRK_PERCENT	(1 << 0) /* always reports percent */
 #define HID_BATTERY_QUIRK_FEATURE	(1 << 1) /* ask for feature report */
 #define HID_BATTERY_QUIRK_IGNORE	(1 << 2) /* completely ignore the battery */
+#define HID_BATTERY_QUIRK_AVOID_QUERY	(1 << 3) /* do not query the battery */
 
 static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
@@ -373,6 +374,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE, USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L),
+	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
@@ -554,6 +557,9 @@ static int hidinput_setup_battery(struct hid_device *dev, unsigned report_type,
 	dev->battery_avoid_query = report_type == HID_INPUT_REPORT &&
 				   field->physical == HID_DG_STYLUS;
 
+	if (quirks & HID_BATTERY_QUIRK_AVOID_QUERY)
+		dev->battery_avoid_query = true;
+
 	dev->battery = power_supply_register(&dev->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(dev->battery)) {
 		error = PTR_ERR(dev->battery);
-- 
2.35.1


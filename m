Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086B364FFD8
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiLRQGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiLRQE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:04:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2738DB4B6;
        Sun, 18 Dec 2022 08:03:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA11BB80BA4;
        Sun, 18 Dec 2022 16:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2887C433F2;
        Sun, 18 Dec 2022 16:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379413;
        bh=yreuj1Pmw8nwCm3ADVtacDriCMOlBPDxspsHT79iAJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+CmwANpKPECRANqueiqiZO1c2s880hft7WFXJ3F0lTohI+d+oTSNEbD1ZQ4rEgNn
         dR7hS6Q9teXsmjB3LFYJ8Sm/Nwe1QMzQ0XL3I3vokPqd0CnFpRwL/DsRLVy7BrBzab
         EsgZXt0f3t0vGXOOuVHamPcdZD7pFG0OpCvxUKbX0PSwls9zJizo4HOqKP6GOJ7QaJ
         a8q/pnsombQNZ1YkwdNd5klVjCXg+ov52lFy0hAgalOjqg2EWk/+El4glKmh8QgVvV
         hMLN6ubbGkomyQdLdbYR3WEF+gYpbS8sEdNpHl6BKk4sphHgfyWE8iXC7EuryCDWiD
         eAR/Yh/wZTzdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Mia Kanashi <chad@redpilled.dev>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 28/85] HID: input: do not query XP-PEN Deco LW battery
Date:   Sun, 18 Dec 2022 11:00:45 -0500
Message-Id: <20221218160142.925394-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
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


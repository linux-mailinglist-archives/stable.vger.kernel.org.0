Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6064FFAB
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiLRQFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiLRQEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:04:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B2B1F3;
        Sun, 18 Dec 2022 08:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B766B60DCE;
        Sun, 18 Dec 2022 16:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485D7C433F2;
        Sun, 18 Dec 2022 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379383;
        bh=RRlZ/RYlgnzPCUxsM7r8Nez0thPXYMbIJNno/2zX654=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8a4+U5nXmlU8pnCh2LebRiasBmF11kQ4PKv636Vr8T/wuSvUPOTAQz16+O99Uouj
         eLo/IHy9bd/d5jfD1K5rNhsupKSvqoT+SfoEhnl3rVVU9KwDoMKbvjpt6pC5DpvZ2a
         Na97upaGIrBXJn+xP5plNSexhgGuAX7OIwDsCWMVfOe1LDz2YJ9WBfiepnm+JIci4e
         MFiUNRiMaszYObaZfjjY8UA0sgcR1GIxWAnEAsghmAqBnELTBuOMlKdMgj04rRFiWE
         bK8bN6MPZd95svPpt3zoOIGdbJ8JdvKJH7jruiFSMRwtua1Bdt10wRb7rzWk6+8g2c
         JDYASaRIU68RQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kerem Karabay <kekrby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 19/85] HID: apple: enable APPLE_ISO_TILDE_QUIRK for the keyboards of Macs with the T2 chip
Date:   Sun, 18 Dec 2022 11:00:36 -0500
Message-Id: <20221218160142.925394-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 084bc074c231e716cbcb9e8f9db05b17fd3563cf ]

The iso_layout parameter must be manually set to get the driver to
swap KEY_102ND and KEY_GRAVE. This patch eliminates the need to do that.

This is safe to do, as Macs with keyboards that do not need the quirk
will keep working the same way as the value of hid->country will be
different than HID_COUNTRY_INTERNATIONAL_ISO. This was tested by one
person with a Mac with the WELLSPRINGT2_J152F keyboard with a layout
that does not require the quirk to be set.

Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index e86bbf85b87e..c671ce94671c 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -997,21 +997,21 @@ static const struct hid_device_id apple_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING9_JIS),
 		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J140K),
-		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL },
+		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J132),
-		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL },
+		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J680),
-		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL },
+		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J213),
-		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL },
+		.driver_data = APPLE_HAS_FN | APPLE_BACKLIGHT_CTL | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J214K),
-		.driver_data = APPLE_HAS_FN },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J223),
-		.driver_data = APPLE_HAS_FN },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J230K),
-		.driver_data = APPLE_HAS_FN },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRINGT2_J152F),
-		.driver_data = APPLE_HAS_FN },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
-- 
2.35.1


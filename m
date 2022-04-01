Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD94E4EF059
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347505AbiDAOfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347576AbiDAOdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70C224D9BA;
        Fri,  1 Apr 2022 07:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 651B561CB1;
        Fri,  1 Apr 2022 14:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C342EC3410F;
        Fri,  1 Apr 2022 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823389;
        bh=8puUcxcsAgziHU04aioiE2ywk84f9b43kRquxeUisbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fxnr3xgAr0NpN2wbxyolnC6Q0OATeG76OZlW4SEQddwXY0fdvYq1vrg6yell85+kf
         Y7pn+trPLQFLFWKs2/RWltXn7dB/9HVXY5gMU4l2dI/H1WOyGrMickwfMopZiGOHb9
         nu4DZdkz3sgJs+9ZwYKcxBHVUVtTRJjzlfkbfjI7ZZOyGTBVDSr8wfMjp2wEvmTZiJ
         8/yjtiNPPeQRReAb1F+vyj/Sp3wYyBsxtlkOktWnoGzXvpvJI0MiIxpa9uH/Zj5PBA
         2///O3KmlBFpPLCyTZbGtLNeVuwFREt5KLDTOqQjvcRIsn3Q7rNuTEYXpG0ZU4o4JD
         ZdTL0fCfG5llQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 076/149] HID: apple: Report Magic Keyboard 2021 with fingerprint reader battery over USB
Date:   Fri,  1 Apr 2022 10:24:23 -0400
Message-Id: <20220401142536.1948161-76-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit cbfcfbfc384890a062a5d0cc4792df094a6cc7a8 ]

Like the Apple Magic Keyboard 2015, when connected over USB, the 2021
version with fingerprint reader registers 2 different interfaces. One of
them is used to report the battery level.

However, unlike when connected over Bluetooth, the battery level is not
reported automatically and it is required to fetch it manually.

Add the APPLE_RDESC_BATTERY quirk to fix the battery report descriptor
and manually fetch the battery level.

Tested with the ANSI variant of the keyboard with and without numpad.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 18de4ccb0fb2..590376d776a1 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -752,11 +752,11 @@ static const struct hid_device_id apple_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021),
-		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021),
-		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 
-- 
2.34.1


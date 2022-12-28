Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B15658331
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiL1Qo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiL1Qob (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5A91CB0E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 856B4B817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29AFC433D2;
        Wed, 28 Dec 2022 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245601;
        bh=RRlZ/RYlgnzPCUxsM7r8Nez0thPXYMbIJNno/2zX654=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sy5UEYGHMqT0PhsB1Zh/e4VLLRmcKUqM2UXTHd4uHhDc0B3VGM7tVZ0pMuPEafunb
         bQ6eznyoRFxMwdqQTu6Pnsq0Jt4RWe0L4YetZwMHNCYuOFK3yBojb2/DcL3xiYbfBn
         ufH/IDcueh6CjlqGZgf7YEp0jZVHbhvW/MXtK2Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kerem Karabay <kekrby@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0921/1073] HID: apple: enable APPLE_ISO_TILDE_QUIRK for the keyboards of Macs with the T2 chip
Date:   Wed, 28 Dec 2022 15:41:49 +0100
Message-Id: <20221228144353.043743907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




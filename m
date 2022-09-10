Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B92B5B492F
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiIJVR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiIJVRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97E14D24F;
        Sat, 10 Sep 2022 14:16:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 803FB60EC3;
        Sat, 10 Sep 2022 21:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F36C43144;
        Sat, 10 Sep 2022 21:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844609;
        bh=d4IziVWHQFC54c13xgvwcvVa0eZNhNga1Dz57NDT6nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbamwEhqUjhCKjgr84bB35QSR8/12FK38zZOJ+p33N7nZyf4GdPM77i57F90NDJid
         iMIK79F4rijOK5U38otgwq485oJi3kE8s6lAZOSEwnH3uwWzJZZZttWruypbwnYnPZ
         ZmNyM66b0aD+Xv/GSel/b76og3pP8BZNZ0LY7jtLhdukCC4nWheAVGSZiTMLqSRWJj
         LJtLO+z6N6LQkiDXyQYn8Zu7BPcGPWn7MAeM8hyiKjk3d47YkHu/OjUKHZJHCTSmPx
         JIhxLM+VF9W79vHc6AT6sEFszo3l+MMXcQ7D9XWpR1IOxzvNdt6AkV3OVCjyG9tZxF
         Pdrh2f1tK7Bkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Garg <gargaditya08@live.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 15/38] HID: Add Apple Touchbar on T2 Macs in hid_have_special_driver list
Date:   Sat, 10 Sep 2022 17:16:00 -0400
Message-Id: <20220910211623.69825-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Aditya Garg <gargaditya08@live.com>

[ Upstream commit 750ec977288d96e9a11424e3507ede097af732c4 ]

The touchbar on Apple T2 Macs has 2 modes, one that shows the function
keys and other that shows the media controls. The user can use the fn
key on his keyboard to switch between the 2 modes.

On Linux, if people were using an external keyboard or mouse, the
touchbar failed to change modes on pressing the fn key with the following
in dmesg :-

[   10.661445] apple-ib-als 0003:05AC:8262.0001: : USB HID v1.01 Device [Apple Inc. Ambient Light Sensor] on usb-bce-vhci-3/input0
[   11.830992] apple-ib-touchbar 0003:05AC:8302.0007: input: USB HID v1.01 Keyboard [Apple Inc. Touch Bar Display] on usb-bce-vhci-6/input0
[   12.139407] apple-ib-touchbar 0003:05AC:8102.0008: : USB HID v1.01 Device [Apple Inc. Touch Bar Backlight] on usb-bce-vhci-7/input0
[   12.211824] apple-ib-touchbar 0003:05AC:8102.0009: : USB HID v1.01 Device [Apple Inc. Touch Bar Backlight] on usb-bce-vhci-7/input1
[   14.219759] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 2 (-110)
[   24.395670] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 2 (-110)
[   34.635791] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 2 (-110)
[  269.579233] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 1 (-110)

Add the USB IDs of the touchbar found in T2 Macs to HID have special
driver list to fix the issue.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 2 ++
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f7e4a0d06fb85..bc550e884f37b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -185,6 +185,8 @@
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021   0x029c
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021   0x029a
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021   0x029f
+#define USB_DEVICE_ID_APPLE_TOUCHBAR_BACKLIGHT 0x8102
+#define USB_DEVICE_ID_APPLE_TOUCHBAR_DISPLAY 0x8302
 
 #define USB_VENDOR_ID_ASUS		0x0486
 #define USB_DEVICE_ID_ASUS_T91MT	0x0185
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index dc67717d2dabc..70f602c64fd13 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -314,6 +314,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_TOUCHBAR_BACKLIGHT) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_TOUCHBAR_DISPLAY) },
 #endif
 #if IS_ENABLED(CONFIG_HID_APPLEIR)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL) },
-- 
2.35.1


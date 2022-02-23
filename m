Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDAB64C083A
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiBWCba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236974AbiBWCbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:31:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3A054BEC;
        Tue, 22 Feb 2022 18:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D519EB81E0F;
        Wed, 23 Feb 2022 02:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA3DC36AE2;
        Wed, 23 Feb 2022 02:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583384;
        bh=Kd7tWJSaOdAD0nh7OxQbtG+Qpn/HeAoCK+1NZS/YSUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2zBwYtLM/VtP3WIuI6pzCnjDlloEIxFOWucLH5Lq4N9f/4SA3ML0O8fqtTks8e1R
         0ds98ypwp7l8KnQzRXATqOawX7vbHylrlDPOlx1w02eexLsvU6GFxqNt7aOoAqF9Gd
         NKCooE8k+cIcS2MLFfOSTiHa5qtz9EQmGj0c3wvfmWfxNRpp4Zm1SvyN43O6daAEMf
         7NChZW1vHxgrOlvYp4jg2rnoaEVUoVivSS5b9MZ+gcoi1bJgOyZ8FqK0L2dE5E4+hf
         4dS3e/Pkqm65NS2a/VS2r8SmVvQRThjwhOYiEkbVNxNVRlLZoxBQUNeNQSUAzGoiUU
         rVCPa8JxML9Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/28] Input: clear BTN_RIGHT/MIDDLE on buttonpads
Date:   Tue, 22 Feb 2022 21:29:08 -0500
Message-Id: <20220223022929.241127-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
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

[ Upstream commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40 ]

Buttonpads are expected to map the INPUT_PROP_BUTTONPAD property bit
and the BTN_LEFT key bit.

As explained in the specification, where a device has a button type
value of 0 (click-pad) or 1 (pressure-pad) there should not be
discrete buttons:
https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/touchpad-windows-precision-touchpad-collection#device-capabilities-feature-report

However, some drivers map the BTN_RIGHT and/or BTN_MIDDLE key bits even
though the device is a buttonpad and therefore does not have those
buttons.

This behavior has forced userspace applications like libinput to
implement different workarounds and quirks to detect buttonpads and
offer to the user the right set of features and configuration options.
For more information:
https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/726

In order to avoid this issue clear the BTN_RIGHT and BTN_MIDDLE key
bits when the input device is register if the INPUT_PROP_BUTTONPAD
property bit is set.

Notice that this change will not affect udev because it does not check
for buttons. See systemd/src/udev/udev-builtin-input_id.c.

List of known affected hardware:

 - Chuwi AeroBook Plus
 - Chuwi Gemibook
 - Framework Laptop
 - GPD Win Max
 - Huawei MateBook 2020
 - Prestigio Smartbook 141 C2
 - Purism Librem 14v1
 - StarLite Mk II   - AMI firmware
 - StarLite Mk II   - Coreboot firmware
 - StarLite Mk III  - AMI firmware
 - StarLite Mk III  - Coreboot firmware
 - StarLabTop Mk IV - AMI firmware
 - StarLabTop Mk IV - Coreboot firmware
 - StarBook Mk V

Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://lore.kernel.org/r/20220208174806.17183-1-jose.exposito89@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index ccaeb24263854..c3139bc2aa0db 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2285,6 +2285,12 @@ int input_register_device(struct input_dev *dev)
 	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
 	__clear_bit(KEY_RESERVED, dev->keybit);
 
+	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
+	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
+		__clear_bit(BTN_RIGHT, dev->keybit);
+		__clear_bit(BTN_MIDDLE, dev->keybit);
+	}
+
 	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
 	input_cleanse_bitmasks(dev);
 
-- 
2.34.1


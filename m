Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52756A38F4
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjB0CoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjB0CoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:44:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EA8A5F3;
        Sun, 26 Feb 2023 18:43:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5D37B80D0C;
        Mon, 27 Feb 2023 02:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF04C433D2;
        Mon, 27 Feb 2023 02:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463805;
        bh=hBQhb0RMGfW9cEyhH42SqxLqPMXMK7vuDoAZ05c6kAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6CzaCC20rPLjRCH4SAA1LPsj1i0S0/TObHX8YdbeXRB9moUy7t4kJPpYBQjLt1VM
         3dnePaUM0GWP1cZG8+jDH8l03lWm8xuLXh5jNDO0nd6ZBP+254+S6nrElxowsWs8yj
         lEy04e/+GHBH2zsgrjH4j8OwIw7nHRGWupnE28fmdy/drkn8Kg9Nc0vubMmld5htlj
         ylJ3F3xq3ii4wgJq2lWxng//NldCy3uYqbxVj/1kK8UpTxGhi/lU3WwThl3+1+IMxI
         UQZXiCHeJBk/16cAdfqNPWymvGYyz5oX4DdrCE3Lsx/EPwyUbfx7fJbt+9aRoDeBoK
         sn3AI4GJlLaMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingyuan Liang <jingyliang@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/19] HID: Add Mapping for System Microphone Mute
Date:   Sun, 26 Feb 2023 21:09:38 -0500
Message-Id: <20230227020957.1052252-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020957.1052252-1-sashal@kernel.org>
References: <20230227020957.1052252-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Jingyuan Liang <jingyliang@chromium.org>

[ Upstream commit 2d60f9f4f26785a00273cb81fe60eff129ebd449 ]

HUTRR110 added a new usage code for a key that is supposed to
mute/unmute microphone system-wide.

Map the new usage code(0x01 0xa9) to keycode KEY_MICMUTE.
Additionally hid-debug is adjusted to recognize this keycode as well.

Signed-off-by: Jingyuan Liang <jingyliang@chromium.org>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-debug.c | 1 +
 drivers/hid/hid-input.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index f4e2e69377589..1f60a381ae63e 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -933,6 +933,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_VOICECOMMAND] = "VoiceCommand",
 	[KEY_EMOJI_PICKER] = "EmojiPicker",
 	[KEY_DICTATE] = "Dictate",
+	[KEY_MICMUTE] = "MicrophoneMute",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 75a4d8d6bb0fd..3399953256d85 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -675,6 +675,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
+		if ((usage->hid & 0xf0) == 0xa0) {	/* SystemControl */
+			switch (usage->hid & 0xf) {
+			case 0x9: map_key_clear(KEY_MICMUTE); break;
+			default: goto ignore;
+			}
+			break;
+		}
+
 		if ((usage->hid & 0xf0) == 0xb0) {	/* SC - Display */
 			switch (usage->hid & 0xf) {
 			case 0x05: map_key_clear(KEY_SWITCHVIDEOMODE); break;
-- 
2.39.0


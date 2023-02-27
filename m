Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6108A6A3718
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjB0CG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjB0CGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9380199E2;
        Sun, 26 Feb 2023 18:05:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07A06B80CBC;
        Mon, 27 Feb 2023 02:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E40C43322;
        Mon, 27 Feb 2023 02:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463528;
        bh=RgbIVkAAQOFWrD7bcoBYmTuv29aTodcXfuIOo4ah4vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWEBXi5hdpTGXzhMwjptDYM52PtN0IYWfO6BWq2p7m4SY5f854G+hmiUhZOPcbkIw
         yBHXkximduDugoQM5dEwZy3Tj+Nm2Z9Qedb7Cij29RqKRuJkba9b4+tk4Nl8yeCOMs
         KdEaw1XoYV/NX366Wpw3J/2zY3WEt6LlmkyETXX2mk6NV4pW9CHS233PrtHy8990j1
         J6E1ssIUP5tW/t7JF7CPf+LgItqOWdNZ486qcEpSYlDrtWtCUFyuq1zFlqe2oTPa7V
         dGtnNd/Dn/at++jQ9a9xIwYXtHZJbpJisXeFTWIX79BEatQqxYTuGwcyebP7M+gSbU
         HlmEtSffzdhUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingyuan Liang <jingyliang@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 07/58] HID: Add Mapping for System Microphone Mute
Date:   Sun, 26 Feb 2023 21:04:05 -0500
Message-Id: <20230227020457.1048737-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020457.1048737-1-sashal@kernel.org>
References: <20230227020457.1048737-1-sashal@kernel.org>
MIME-Version: 1.0
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
index 2ca6ab600bc9f..15e35702773cd 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -972,6 +972,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_KBD_LAYOUT_NEXT] = "KbdLayoutNext",
 	[KEY_EMOJI_PICKER] = "EmojiPicker",
 	[KEY_DICTATE] = "Dictate",
+	[KEY_MICMUTE] = "MicrophoneMute",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 3ee5a9fea20e6..ee5050306225f 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -789,6 +789,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
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


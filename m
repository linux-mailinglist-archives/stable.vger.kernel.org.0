Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A16A37F5
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjB0CNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjB0CNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:13:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111221C306;
        Sun, 26 Feb 2023 18:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ED3760DD6;
        Mon, 27 Feb 2023 02:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9573FC433EF;
        Mon, 27 Feb 2023 02:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463846;
        bh=u6AZLKR+GYeXpN3Vk1OPC1wP1MsbaZEPj1iisApci94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2ki1cCXAyOKB/i5ZGClxd/VbtAOJ9faoTaJAtYHKJcpQFrJF6/RLG4Ajn/wYgkwe
         VKXxVgZG5Vo5OOAo5g2256NPNNUSnAzAC5b2z0SX15aEDFRWy5ot0kwWc0TtlsbEB5
         VapB8bXD+uo5s83VKap/VyBWwVu3eltawm9vKY9fnt4bg6j88u3SiBoSP1UMuJQz9V
         PNHsHwO4zrb3ZeFbMh9Lr6vdqVU/X+5LkPllO+/T24Jtf29zjYqmiewZH7Lbv4TkmD
         tQEJk83ZnVUeFTwaZ8h23i7Fk0o3EyYV/iMYbeW1o0cUxG6OaZnjvi/AbTfvAsSYC/
         KNTsv9GzLs24Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingyuan Liang <jingyliang@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/15] HID: Add Mapping for System Microphone Mute
Date:   Sun, 26 Feb 2023 21:10:22 -0500
Message-Id: <20230227021038.1052958-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227021038.1052958-1-sashal@kernel.org>
References: <20230227021038.1052958-1-sashal@kernel.org>
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
index 419d8dec7e498..0066eab60576c 100644
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
index d1ba6fafe960f..004aa3cdeacc7 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -671,6 +671,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
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


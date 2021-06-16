Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71B33A9F84
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhFPPip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234971AbhFPPhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05DB8613CD;
        Wed, 16 Jun 2021 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857741;
        bh=FeqBGE9zqGaarMM+CfYzox4XI66YDFKHiyv3V8hjCS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqejmKiJseTgOdlrPWu7ZHsR1ibzEvIKQJarD5P8dP8EXFa6+xgK0MLVRbRJ+wL2C
         Sz/p27cGsiKJ492/gyEn/G8pPMdwIJFcokKZ9XFtMka5AnohugN5/fGMJlulCbs1vC
         nHRPtlYBBBdZenmSbgOn/zROh1hyJ2FF22sr/2uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 04/38] HID: hid-input: add mapping for emoji picker key
Date:   Wed, 16 Jun 2021 17:33:13 +0200
Message-Id: <20210616152835.545760276@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152835.407925718@linuxfoundation.org>
References: <20210616152835.407925718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 7b229b13d78d112e2c5d4a60a3c6f602289959fa ]

HUTRR101 added a new usage code for a key that is supposed to invoke and
dismiss an emoji picker widget to assist users to locate and enter emojis.

This patch adds a new key definition KEY_EMOJI_PICKER and maps 0x0c/0x0d9
usage code to this new keycode. Additionally hid-debug is adjusted to
recognize this new usage code as well.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-debug.c                | 1 +
 drivers/hid/hid-input.c                | 3 +++
 include/uapi/linux/input-event-codes.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index d7eaf9100370..982737827b87 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -929,6 +929,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_APPSELECT] = "AppSelect",
 	[KEY_SCREENSAVER] = "ScreenSaver",
 	[KEY_VOICECOMMAND] = "VoiceCommand",
+	[KEY_EMOJI_PICKER] = "EmojiPicker",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 32024905fd70..d1ab2dccf6fd 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -957,6 +957,9 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 
 		case 0x0cd: map_key_clear(KEY_PLAYPAUSE);	break;
 		case 0x0cf: map_key_clear(KEY_VOICECOMMAND);	break;
+
+		case 0x0d9: map_key_clear(KEY_EMOJI_PICKER);	break;
+
 		case 0x0e0: map_abs_clear(ABS_VOLUME);		break;
 		case 0x0e2: map_key_clear(KEY_MUTE);		break;
 		case 0x0e5: map_key_clear(KEY_BASSBOOST);	break;
diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
index ee93428ced9a..225ec87d4f22 100644
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -611,6 +611,7 @@
 #define KEY_VOICECOMMAND		0x246	/* Listening Voice Command */
 #define KEY_ASSISTANT		0x247	/* AL Context-aware desktop assistant */
 #define KEY_KBD_LAYOUT_NEXT	0x248	/* AC Next Keyboard Layout Select */
+#define KEY_EMOJI_PICKER	0x249	/* Show/hide emoji picker (HUTRR101) */
 
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
-- 
2.30.2




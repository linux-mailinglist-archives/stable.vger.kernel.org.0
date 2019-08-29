Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8CBA1739
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfH2KyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:54:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbfH2Kuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5962173E;
        Thu, 29 Aug 2019 10:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075836;
        bh=4HwPwdkwP5ccqwcPRUDXB3DKKiH9S0DRxugyWR3hUU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5PhsPfMisHJwGF27l5Lm11j2Edb+IZ1gWDg4IFLHlssENywD42ksAcvA0OxLy7Xa
         yQyaPhxeFcL833A5iho+OkBkLkbLS9n3tChGn8sd6uLUmKJ4cyGyRx9snNWpxMQNjt
         83yKNbHvcyaHkYSEh8b0B4xYp+xPf5hfRhPviJy4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 23/29] ALSA: usb-audio: Check mixer unit bitmap yet more strictly
Date:   Thu, 29 Aug 2019 06:50:03 -0400
Message-Id: <20190829105009.2265-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f9f0e9ed350e15d51ad07364b4cf910de50c472a ]

The bmControls (for UAC1) or bmMixerControls (for UAC2/3) bitmap has a
variable size depending on both input and output pins.  Its size is to
fit with input * output bits.  The problem is that the input size
can't be determined simply from the unit descriptor itself but it
needs to parse the whole connected sources.  Although the
uac_mixer_unit_get_channels() tries to check some possible overflow of
this bitmap, it's incomplete due to the lack of the  evaluation of
input pins.

For covering possible overflows, this patch adds the bitmap overflow
check in the loop of input pins in parse_audio_mixer_unit().

Fixes: 0bfe5e434e66 ("ALSA: usb-audio: Check mixer unit descriptors more strictly")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 4b3e1c48ca2f3..b0c5d4ef61374 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -754,7 +754,6 @@ static int uac_mixer_unit_get_channels(struct mixer_build *state,
 				       struct uac_mixer_unit_descriptor *desc)
 {
 	int mu_channels;
-	void *c;
 
 	if (desc->bLength < sizeof(*desc))
 		return -EINVAL;
@@ -777,13 +776,6 @@ static int uac_mixer_unit_get_channels(struct mixer_build *state,
 		break;
 	}
 
-	if (!mu_channels)
-		return 0;
-
-	c = uac_mixer_unit_bmControls(desc, state->mixer->protocol);
-	if (c - (void *)desc + (mu_channels - 1) / 8 >= desc->bLength)
-		return 0; /* no bmControls -> skip */
-
 	return mu_channels;
 }
 
@@ -2028,6 +2020,31 @@ static int parse_audio_feature_unit(struct mixer_build *state, int unitid,
  * Mixer Unit
  */
 
+/* check whether the given in/out overflows bmMixerControls matrix */
+static bool mixer_bitmap_overflow(struct uac_mixer_unit_descriptor *desc,
+				  int protocol, int num_ins, int num_outs)
+{
+	u8 *hdr = (u8 *)desc;
+	u8 *c = uac_mixer_unit_bmControls(desc, protocol);
+	size_t rest; /* remaining bytes after bmMixerControls */
+
+	switch (protocol) {
+	case UAC_VERSION_1:
+	default:
+		rest = 1; /* iMixer */
+		break;
+	case UAC_VERSION_2:
+		rest = 2; /* bmControls + iMixer */
+		break;
+	case UAC_VERSION_3:
+		rest = 6; /* bmControls + wMixerDescrStr */
+		break;
+	}
+
+	/* overflow? */
+	return c + (num_ins * num_outs + 7) / 8 + rest > hdr + hdr[0];
+}
+
 /*
  * build a mixer unit control
  *
@@ -2156,6 +2173,9 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 		if (err < 0)
 			return err;
 		num_ins += iterm.channels;
+		if (mixer_bitmap_overflow(desc, state->mixer->protocol,
+					  num_ins, num_outs))
+			break;
 		for (; ich < num_ins; ich++) {
 			int och, ich_has_controls = 0;
 
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7E53A663
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353513AbiFANxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353536AbiFANxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:53:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35ED8A314;
        Wed,  1 Jun 2022 06:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC9BBB81911;
        Wed,  1 Jun 2022 13:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50525C36AE2;
        Wed,  1 Jun 2022 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091578;
        bh=2JYU5DuEm+BMLnrJLtWoA5OKIcB5KezmZmgoLCAFNSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0aGCAFAqiGSbV+UAazc96jv3dhCioymkekr/ca4WJDh7N8vDOzqr8OSLQC74KsXo
         6IaPlqsnNozsAvTC0HJqh+jK6f7NOKTic73j0naZPHoQ2knY1GagupDkSwxNh9UuK3
         VPKDsreZWpwXVhl+ZbT6JzjTrw93Ca6g6Ja3o5TPHTleuJI53wn6iX3YJ767lVfvOx
         TWJhpQRYMwQJNEegZqVZ6rMwq5/I94MTLzWbL/DqYhBVonZvZQB3CxRLQBPRXLROzT
         ET3xgOVbsOmwrbG+tIHvgRjHc8OxNVyIN6Cs4aQg9t/5lHG1sQXaTm9ealq7UFttkw
         BTzoqY1ZBwd9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, geraldogabriel@gmail.com,
        matteomartelli3@gmail.com, alexander@tsoy.me,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 17/49] ALSA: usb-audio: Move generic implicit fb quirk entries into quirks.c
Date:   Wed,  1 Jun 2022 09:51:41 -0400
Message-Id: <20220601135214.2002647-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 67d64069bc0867e52e73a1e255b17462005ca9b4 ]

Use the new quirk bits to manage the generic implicit fb quirk
entries.  This makes easier to compare with other devices.

Link: https://lore.kernel.org/r/20220421064101.12456-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/implicit.c | 5 -----
 sound/usb/quirks.c   | 6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index 1fd087128538..e1bf1b5da423 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -45,11 +45,6 @@ struct snd_usb_implicit_fb_match {
 
 /* Implicit feedback quirk table for playback */
 static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
-	/* Generic matching */
-	IMPLICIT_FB_GENERIC_DEV(0x0499, 0x1509), /* Steinberg UR22 */
-	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2030), /* M-Audio Fast Track C400 */
-	IMPLICIT_FB_GENERIC_DEV(0x0763, 0x2031), /* M-Audio Fast Track C600 */
-
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2080, 0x81, 2), /* M-Audio FastTrack Ultra */
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index fbbe59054c3f..e8468f9b007d 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1793,6 +1793,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x046d, 0x09a4, /* Logitech QuickCam E 3500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x04d8, 0xfeea, /* Benchmark DAC1 Pre */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04e8, 0xa051, /* Samsung USBC Headset (AKG) */
@@ -1826,6 +1828,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x074d, 0x3553, /* Outlaw RR2150 (Micronas UAC3553B) */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0763, 0x2030, /* M-Audio Fast Track C400 */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0763, 0x2031, /* M-Audio Fast Track C600 */
+		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0951, 0x16ad, /* Kingston HyperX */
-- 
2.35.1


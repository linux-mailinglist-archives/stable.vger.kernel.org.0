Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E89753A7B7
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354259AbiFAOCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354846AbiFAOA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE21443DE;
        Wed,  1 Jun 2022 06:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21484615F3;
        Wed,  1 Jun 2022 13:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A0C385A5;
        Wed,  1 Jun 2022 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091812;
        bh=0AATGhPKUXP8RHSIHly1sLcQzI8B/0tKl/5Mevs/1vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8TmanAmNkHNpe2QaVMiOY2Ft2p7ed5+R5e7XObR4XMrn2meQxD8FCdRiKwcGGCXu
         c2qmj2U2DJzxa5lxbT9bpyFpUrKx4O+g9e0xn3mUxaQ23eQEMjWglQdZ3LIpuIyJ7w
         y/5Pa7aI7qWPbwG1bkctt/IRHqHBDFx+Hm9vamU0Y9vL1GexJLQsf7kfNe4b+utbJg
         2p1J2xQakq0JmykkBrEBwx7gCDiRlnajzfvn1ep/w9rnaSD66QwW3GGoEqrEHzgpfg
         HZth68W6+11Dj/MhoyiVEJieE/CyW0O/K3lb/xqOEMWjOFfDtQpXPGGOEVBRu7Ety9
         hQhbKhJ9dTOnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, geraldogabriel@gmail.com,
        matteomartelli3@gmail.com, alexander@tsoy.me,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 14/37] ALSA: usb-audio: Move generic implicit fb quirk entries into quirks.c
Date:   Wed,  1 Jun 2022 09:55:59 -0400
Message-Id: <20220601135622.2003939-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
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
index ab9f3da49941..5461cdf907e2 100644
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
@@ -1824,6 +1826,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
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


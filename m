Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03B053A737
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353857AbiFAN7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353959AbiFAN6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:58:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E0F8B0A4;
        Wed,  1 Jun 2022 06:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49159CE1C0A;
        Wed,  1 Jun 2022 13:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B25C385A5;
        Wed,  1 Jun 2022 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091702;
        bh=0AATGhPKUXP8RHSIHly1sLcQzI8B/0tKl/5Mevs/1vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PP3Pr/rKXgBDNdDS4p/8siXNGaXkyFWahXTOndinGwRSE1xHYcx4GNGLA0aqJ56SK
         4XaRJmh68BOqhvLlIUvarW1VcVoUilqPU7Tmwzd/dgFuHQYW5z1DvGR5jolg4OvG90
         c/t96PG3Eegv5PTeDyrqy60phLeKLtIKM1QGDPjw82zs0LGHwNRaEdKrlK9piE0E0r
         S+L87wyst6kJ04fgR1+hR46F2wzybUm7+MjlhAQP3m3h85kjBSMAXBiHA63KohUGOF
         LAzQvG1Clg0Q8aqfzd4m7p4zB3n1mlRRUYZoBl0E/vWmPaqLwNd/g0gWK9KcZ7Bc3t
         nViKXTvlRUW1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, geraldogabriel@gmail.com,
        matteomartelli3@gmail.com, alexander@tsoy.me,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 17/48] ALSA: usb-audio: Move generic implicit fb quirk entries into quirks.c
Date:   Wed,  1 Jun 2022 09:53:50 -0400
Message-Id: <20220601135421.2003328-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
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


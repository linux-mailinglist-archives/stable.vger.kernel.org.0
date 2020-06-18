Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AF61FE757
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbgFRCkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgFRBMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268A021924;
        Thu, 18 Jun 2020 01:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442758;
        bh=TNCde89qMsDt3lwOoVvwuyjPZiBciZnqF2mqdJ5bh8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWoWCqnvgk5jawV+64YU8C/00ihD3fN8AkWK750rSWNHFVXvgfAhpkGTAaRvT2mZB
         k5Wqpz0Rh2S9RzSN034cA2B36dD9CeRYBFIGzjzIhkEIXi0lqbkp7EdlUcrMRR1e2o
         Fp1PDErmtpo5sc0LFqG18mxTaZWguNtKnGu1JU+8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Ebeling <penguins@bollie.de>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 209/388] ALSA: usb-audio: fixing upper volume limit for RME Babyface Pro routing crosspoints
Date:   Wed, 17 Jun 2020 21:05:06 -0400
Message-Id: <20200618010805.600873-209-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Ebeling <penguins@bollie.de>

[ Upstream commit 47b4f5f5b65680fbef7a7a9a4796b35f38a6e43e ]

In my initial patch, these were set too low.

Fixes: 3e8f3bd04716 ("ALSA: usb-audio: RME Babyface Pro mixer patch")
Signed-off-by: Thomas Ebeling <penguins@bollie.de>
Link: https://lore.kernel.org/r/20200515114556.vtspnonzvp4xp44m@bollie.ca9.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index bdff8674942e..aad2683ff793 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2191,7 +2191,7 @@ static int snd_rme_controls_create(struct usb_mixer_interface *mixer)
  * These devices exposes a couple of DSP functions via request to EP0.
  * Switches are available via control registers, while routing is controlled
  * by controlling the volume on each possible crossing point.
- * Volume control is linear, from -inf (dec. 0) to +6dB (dec. 46341) with
+ * Volume control is linear, from -inf (dec. 0) to +6dB (dec. 65536) with
  * 0dB being at dec. 32768.
  */
 enum {
@@ -2220,7 +2220,7 @@ enum {
 #define SND_BBFPRO_MIXER_VAL_MASK 0x3ffff
 #define SND_BBFPRO_MIXER_VAL_SHIFT 9
 #define SND_BBFPRO_MIXER_VAL_MIN 0 // -inf
-#define SND_BBFPRO_MIXER_VAL_MAX 46341 // +6dB
+#define SND_BBFPRO_MIXER_VAL_MAX 65536 // +6dB
 
 #define SND_BBFPRO_USBREQ_CTL_REG1 0x10
 #define SND_BBFPRO_USBREQ_CTL_REG2 0x17
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969971A5AF4
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgDKXpg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbgDKXFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1025620708;
        Sat, 11 Apr 2020 23:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646334;
        bh=joOxo1Zr/oT1gUdgtaRz8hThdw45IxDOqajylLDLVvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpPxBLcRiYtciYR/f4whJOwE9hUKJWaUi8A3jnNZTwlinDibZwhhJVzg28ODzr0hW
         9LWkTtu5urhakrHVsNAgNW3PHkIiuPyX0vdRC7+qh/IZEOf+F7InwtQ9O1Q/EmNTmG
         FTgUDCID/OeGQ/Mi9daGHFGZrJA5Rwk5MiMCQ3wY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 086/149] ASoC: soc-pcm: fix regression in soc_new_pcm()
Date:   Sat, 11 Apr 2020 19:02:43 -0400
Message-Id: <20200411230347.22371-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit a4877a6fb2bd2e356a5eaacd86d6b6d69ff84e69 ]

Commit af4bac11531f ("ASoC: soc-pcm: crash in snd_soc_dapm_new_dai")
swapped the SNDRV_PCM_STREAM_* parameter in the
snd_soc_dai_stream_valid(cpu_dai, ...) checks. But that works only
for codec2codec links. For normal links it breaks registration of
playback/capture-only PCM devices.

E.g. on qcom/apq8016_sbc there is usually one playback-only and one
capture-only PCM device, but they disappeared after the commit.

The codec2codec case was added in commit a342031cdd08
("ASoC: create pcm for codec2codec links as well") as an extra check
(e.g. `playback = playback && cpu_playback->channels_min`).

We should be able to simplify the code by checking directly for
the correct stream type in the loop.
This also fixes the regression because we check for PLAYBACK for
both codec and cpu dai again when codec2codec is not used.

Fixes: af4bac11531f ("ASoC: soc-pcm: crash in snd_soc_dapm_new_dai")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/20200218103824.26708-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 2c59b3688ca01..a08ebbf5a37f3 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2888,22 +2888,19 @@ int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 		capture = rtd->dai_link->dpcm_capture;
 	} else {
 		/* Adapt stream for codec2codec links */
-		struct snd_soc_pcm_stream *cpu_capture = rtd->dai_link->params ?
-			&cpu_dai->driver->playback : &cpu_dai->driver->capture;
-		struct snd_soc_pcm_stream *cpu_playback = rtd->dai_link->params ?
-			&cpu_dai->driver->capture : &cpu_dai->driver->playback;
+		int cpu_capture = rtd->dai_link->params ?
+			SNDRV_PCM_STREAM_PLAYBACK : SNDRV_PCM_STREAM_CAPTURE;
+		int cpu_playback = rtd->dai_link->params ?
+			SNDRV_PCM_STREAM_CAPTURE : SNDRV_PCM_STREAM_PLAYBACK;
 
 		for_each_rtd_codec_dai(rtd, i, codec_dai) {
 			if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_PLAYBACK) &&
-			    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_CAPTURE))
+			    snd_soc_dai_stream_valid(cpu_dai,   cpu_playback))
 				playback = 1;
 			if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_CAPTURE) &&
-			    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_PLAYBACK))
+			    snd_soc_dai_stream_valid(cpu_dai,   cpu_capture))
 				capture = 1;
 		}
-
-		capture = capture && cpu_capture->channels_min;
-		playback = playback && cpu_playback->channels_min;
 	}
 
 	if (rtd->dai_link->playback_only) {
-- 
2.20.1


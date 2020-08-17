Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD7F247597
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgHQTZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbgHQPeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83DC422DD6;
        Mon, 17 Aug 2020 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678448;
        bh=CYQLhpc9ygtcY3Ds+KkuqeawEYrfEbppAz6zdGbpa38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbcfowwvBu66iCkpZ4lzRKf2oclskftw1e083BAoeI7+Odzb2AEWHFdtq5ma05SS+
         l2Qeflk23uBDqyFGZbLNvmA5Ni0DPDsh8kN1bXQNqgWkdX6+Bp9ZfVeAzvEfGvsjQj
         IVqSOxllVE06LA9URRyZzJQTOF/cBLH6hHdFr6PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 337/464] ASoC: core: use less strict tests for dailink capabilities
Date:   Mon, 17 Aug 2020 17:14:50 +0200
Message-Id: <20200817143849.921826452@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 4f8721542f7b75954bfad98c51aa59d683d35b50 ]

Previous updates to set dailink capabilities and check dailink
capabilities were based on a flawed assumption that all dais support
the same capabilities as the dailink. This is true for TDM
configurations but existing configurations use an amplifier and a
capture device on the same dailink, and the tests would prevent the
card from probing.

This patch modifies the snd_soc_dai_link_set_capabilities()
helper so that the dpcm_playback (resp. dpcm_capture) dailink
capabilities are set if at least one dai supports playback (resp. capture).

Likewise the checks are modified so that an error is reported only
when dpcm_playback (resp. dpcm_capture) is set but none of the CPU
DAIs support playback (resp. capture).

Fixes: 25612477d20b5 ('ASoC: soc-dai: set dai_link dpcm_ flags with a helper')
Fixes: b73287f0b0745 ('ASoC: soc-pcm: dpcm: fix playback/capture checks')
Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200723180533.220312-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dai.c | 16 +++++++++-------
 sound/soc/soc-pcm.c | 42 ++++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index 457159975b01a..cecbbed2de9d5 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -400,28 +400,30 @@ void snd_soc_dai_link_set_capabilities(struct snd_soc_dai_link *dai_link)
 	struct snd_soc_dai_link_component *codec;
 	struct snd_soc_dai *dai;
 	bool supported[SNDRV_PCM_STREAM_LAST + 1];
+	bool supported_cpu;
+	bool supported_codec;
 	int direction;
 	int i;
 
 	for_each_pcm_streams(direction) {
-		supported[direction] = true;
+		supported_cpu = false;
+		supported_codec = false;
 
 		for_each_link_cpus(dai_link, i, cpu) {
 			dai = snd_soc_find_dai(cpu);
-			if (!dai || !snd_soc_dai_stream_valid(dai, direction)) {
-				supported[direction] = false;
+			if (dai && snd_soc_dai_stream_valid(dai, direction)) {
+				supported_cpu = true;
 				break;
 			}
 		}
-		if (!supported[direction])
-			continue;
 		for_each_link_codecs(dai_link, i, codec) {
 			dai = snd_soc_find_dai(codec);
-			if (!dai || !snd_soc_dai_stream_valid(dai, direction)) {
-				supported[direction] = false;
+			if (dai && snd_soc_dai_stream_valid(dai, direction)) {
+				supported_codec = true;
 				break;
 			}
 		}
+		supported[direction] = supported_cpu && supported_codec;
 	}
 
 	dai_link->dpcm_playback = supported[SNDRV_PCM_STREAM_PLAYBACK];
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index c517064f5391b..74baf1fce053f 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2802,30 +2802,36 @@ int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 		if (rtd->dai_link->dpcm_playback) {
 			stream = SNDRV_PCM_STREAM_PLAYBACK;
 
-			for_each_rtd_cpu_dais(rtd, i, cpu_dai)
-				if (!snd_soc_dai_stream_valid(cpu_dai,
-							      stream)) {
-					dev_err(rtd->card->dev,
-						"CPU DAI %s for rtd %s does not support playback\n",
-						cpu_dai->name,
-						rtd->dai_link->stream_name);
-					return -EINVAL;
+			for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+				if (snd_soc_dai_stream_valid(cpu_dai, stream)) {
+					playback = 1;
+					break;
 				}
-			playback = 1;
+			}
+
+			if (!playback) {
+				dev_err(rtd->card->dev,
+					"No CPU DAIs support playback for stream %s\n",
+					rtd->dai_link->stream_name);
+				return -EINVAL;
+			}
 		}
 		if (rtd->dai_link->dpcm_capture) {
 			stream = SNDRV_PCM_STREAM_CAPTURE;
 
-			for_each_rtd_cpu_dais(rtd, i, cpu_dai)
-				if (!snd_soc_dai_stream_valid(cpu_dai,
-							      stream)) {
-					dev_err(rtd->card->dev,
-						"CPU DAI %s for rtd %s does not support capture\n",
-						cpu_dai->name,
-						rtd->dai_link->stream_name);
-					return -EINVAL;
+			for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+				if (snd_soc_dai_stream_valid(cpu_dai, stream)) {
+					capture = 1;
+					break;
 				}
-			capture = 1;
+			}
+
+			if (!capture) {
+				dev_err(rtd->card->dev,
+					"No CPU DAIs support capture for stream %s\n",
+					rtd->dai_link->stream_name);
+				return -EINVAL;
+			}
 		}
 	} else {
 		/* Adapt stream for codec2codec links */
-- 
2.25.1




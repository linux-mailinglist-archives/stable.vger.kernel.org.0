Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF29409294
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343858AbhIMOMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343540AbhIMOKp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89A4A61AA9;
        Mon, 13 Sep 2021 13:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540514;
        bh=VYMzusIFuWOxOAspZQy/DfCtSCwkSG7asZ0i+e+bu9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6aGa6454Ngj6WjmX5iX5TIZnfj3svEyWbu2yqRQ33AC1VKcuXx2mZZPrgvyaX2Er
         /w57/cO2kd5BucwoOmgzEZfBCZs+csNQqXtSmKN+8pp1BkpBYptKtR3NPys0+qum6o
         UAYsYL1QWJds/Ub/64aldrMbIIS+ZPU+ORwCRPeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 223/300] ASoC: Intel: kbl_da7219_max98927: Fix format selection for max98373
Date:   Mon, 13 Sep 2021 15:14:44 +0200
Message-Id: <20210913131116.888361565@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 6d41bbf2fd3615c56dbf2b67f6cbf9e83d14a2e2 ]

Contrary to what is said in board's file, topology targeting
kbl_da7219_max98373 expects format 16b, not 24/32b. Partially revert
changes added in 'ASoC: Intel: Boards: Add Maxim98373 support' to bring
old behavior back, aligning with topology expectations.

Fixes: 716d53cc7837 ("ASoC: Intel: Boards: Add Maxim98373 support")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Link: https://lore.kernel.org/r/20210818075742.1515155-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_da7219_max98927.c | 55 +++-----------------
 1 file changed, 7 insertions(+), 48 deletions(-)

diff --git a/sound/soc/intel/boards/kbl_da7219_max98927.c b/sound/soc/intel/boards/kbl_da7219_max98927.c
index 4b7b4a044f81..255f8df09d84 100644
--- a/sound/soc/intel/boards/kbl_da7219_max98927.c
+++ b/sound/soc/intel/boards/kbl_da7219_max98927.c
@@ -199,7 +199,7 @@ static int kabylake_ssp0_hw_params(struct snd_pcm_substream *substream,
 		}
 		if (!strcmp(codec_dai->component->name, MAX98373_DEV0_NAME)) {
 			ret = snd_soc_dai_set_tdm_slot(codec_dai,
-							0x03, 3, 8, 24);
+							0x30, 3, 8, 16);
 			if (ret < 0) {
 				dev_err(runtime->dev,
 						"DEV0 TDM slot err:%d\n", ret);
@@ -208,10 +208,10 @@ static int kabylake_ssp0_hw_params(struct snd_pcm_substream *substream,
 		}
 		if (!strcmp(codec_dai->component->name, MAX98373_DEV1_NAME)) {
 			ret = snd_soc_dai_set_tdm_slot(codec_dai,
-							0x0C, 3, 8, 24);
+							0xC0, 3, 8, 16);
 			if (ret < 0) {
 				dev_err(runtime->dev,
-						"DEV0 TDM slot err:%d\n", ret);
+						"DEV1 TDM slot err:%d\n", ret);
 				return ret;
 			}
 		}
@@ -311,24 +311,6 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	 * The above 2 loops are mutually exclusive based on the stream direction,
 	 * thus rtd_dpcm variable will never be overwritten
 	 */
-	/*
-	 * Topology for kblda7219m98373 & kblmax98373 supports only S24_LE,
-	 * where as kblda7219m98927 & kblmax98927 supports S16_LE by default.
-	 * Skipping the port wise FE and BE configuration for kblda7219m98373 &
-	 * kblmax98373 as the topology (FE & BE) supports S24_LE only.
-	 */
-
-	if (!strcmp(rtd->card->name, "kblda7219m98373") ||
-		!strcmp(rtd->card->name, "kblmax98373")) {
-		/* The ADSP will convert the FE rate to 48k, stereo */
-		rate->min = rate->max = 48000;
-		chan->min = chan->max = DUAL_CHANNEL;
-
-		/* set SSP to 24 bit */
-		snd_mask_none(fmt);
-		snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S24_LE);
-		return 0;
-	}
 
 	/*
 	 * The ADSP will convert the FE rate to 48k, stereo, 24 bit
@@ -479,31 +461,20 @@ static struct snd_pcm_hw_constraint_list constraints_channels_quad = {
 static int kbl_fe_startup(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *soc_rt = asoc_substream_to_rtd(substream);
 
 	/*
 	 * On this platform for PCM device we support,
 	 * 48Khz
 	 * stereo
+	 * 16 bit audio
 	 */
 
 	runtime->hw.channels_max = DUAL_CHANNEL;
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
 					   &constraints_channels);
-	/*
-	 * Setup S24_LE (32 bit container and 24 bit valid data) for
-	 * kblda7219m98373 & kblmax98373. For kblda7219m98927 &
-	 * kblmax98927 keeping it as 16/16 due to topology FW dependency.
-	 */
-	if (!strcmp(soc_rt->card->name, "kblda7219m98373") ||
-		!strcmp(soc_rt->card->name, "kblmax98373")) {
-		runtime->hw.formats = SNDRV_PCM_FMTBIT_S24_LE;
-		snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
-
-	} else {
-		runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
-		snd_pcm_hw_constraint_msbits(runtime, 0, 16, 16);
-	}
+
+	runtime->hw.formats = SNDRV_PCM_FMTBIT_S16_LE;
+	snd_pcm_hw_constraint_msbits(runtime, 0, 16, 16);
 
 	snd_pcm_hw_constraint_list(runtime, 0,
 				SNDRV_PCM_HW_PARAM_RATE, &constraints_rates);
@@ -536,23 +507,11 @@ static int kabylake_dmic_fixup(struct snd_soc_pcm_runtime *rtd,
 static int kabylake_dmic_startup(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct snd_soc_pcm_runtime *soc_rt = asoc_substream_to_rtd(substream);
 
 	runtime->hw.channels_min = runtime->hw.channels_max = QUAD_CHANNEL;
 	snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_CHANNELS,
 			&constraints_channels_quad);
 
-	/*
-	 * Topology for kblda7219m98373 & kblmax98373 supports only S24_LE.
-	 * The DMIC also configured for S24_LE. Forcing the DMIC format to
-	 * S24_LE due to the topology FW dependency.
-	 */
-	if (!strcmp(soc_rt->card->name, "kblda7219m98373") ||
-		!strcmp(soc_rt->card->name, "kblmax98373")) {
-		runtime->hw.formats = SNDRV_PCM_FMTBIT_S24_LE;
-		snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
-	}
-
 	return snd_pcm_hw_constraint_list(substream->runtime, 0,
 			SNDRV_PCM_HW_PARAM_RATE, &constraints_rates);
 }
-- 
2.30.2




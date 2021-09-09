Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CC7405127
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351313AbhIIMdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354438AbhIIMa6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:30:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C069461B39;
        Thu,  9 Sep 2021 11:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188368;
        bh=cV1bULndHYuO+pws6De6elADmnvVsd2GUAbeYhywzrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENXr6k59t0CW/YzLt6/lwO7FQYgcNDWxBuFUcyS74xyXeUvzO62i6hOl2vYh7M2Gs
         eFzHTHxRVflTJ3i1tkT6IOvxUVWqNTmevvlnq9Sl+JV5W/Jvyjnwb9YVQMjdgZh4qN
         ncQvCMG8k6facySfxkzgki7VzP+O/E2zm7W7frtA3Z0xSXDGf7lUaK6ERKxfSPvsvE
         j0XL+BZPMm7K4iU52YLzg6k3spuvDwhma3w1y4OxXoscrwUNedWhjuh5aqEN7f7vTj
         M+yiZ86afWQvKHD1VRN9uA+gbsJRHy1C0G/ooLLOYKF5DhVTubICgLfhrmuSH1srln
         AWiuea8xQ72Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 070/176] ASoC: Intel: bytcr_rt5640: Move "Platform Clock" routes to the maps for the matching in-/output
Date:   Thu,  9 Sep 2021 07:49:32 -0400
Message-Id: <20210909115118.146181-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit dccd1dfd0770bfd494b68d1135b4547b2c602c42 ]

Move the "Platform Clock" routes for the "Internal Mic" and "Speaker"
routes to the intmic_*_map[] / *_spk_map[] arrays.

This ensures that these "Platform Clock" routes do not get added when the
BYT_RT5640_NO_INTERNAL_MIC_MAP / BYT_RT5640_NO_SPEAKERS quirks are used.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210802142501.991985-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index ca14730232ba..43ee3d095a1b 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -286,9 +286,6 @@ static const struct snd_soc_dapm_widget byt_rt5640_widgets[] = {
 static const struct snd_soc_dapm_route byt_rt5640_audio_map[] = {
 	{"Headphone", NULL, "Platform Clock"},
 	{"Headset Mic", NULL, "Platform Clock"},
-	{"Internal Mic", NULL, "Platform Clock"},
-	{"Speaker", NULL, "Platform Clock"},
-
 	{"Headset Mic", NULL, "MICBIAS1"},
 	{"IN2P", NULL, "Headset Mic"},
 	{"Headphone", NULL, "HPOL"},
@@ -296,19 +293,23 @@ static const struct snd_soc_dapm_route byt_rt5640_audio_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_dmic1_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"DMIC1", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_dmic2_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"DMIC2", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_in1_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"Internal Mic", NULL, "MICBIAS1"},
 	{"IN1P", NULL, "Internal Mic"},
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_intmic_in3_map[] = {
+	{"Internal Mic", NULL, "Platform Clock"},
 	{"Internal Mic", NULL, "MICBIAS1"},
 	{"IN3P", NULL, "Internal Mic"},
 };
@@ -350,6 +351,7 @@ static const struct snd_soc_dapm_route byt_rt5640_ssp0_aif2_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_stereo_spk_map[] = {
+	{"Speaker", NULL, "Platform Clock"},
 	{"Speaker", NULL, "SPOLP"},
 	{"Speaker", NULL, "SPOLN"},
 	{"Speaker", NULL, "SPORP"},
@@ -357,6 +359,7 @@ static const struct snd_soc_dapm_route byt_rt5640_stereo_spk_map[] = {
 };
 
 static const struct snd_soc_dapm_route byt_rt5640_mono_spk_map[] = {
+	{"Speaker", NULL, "Platform Clock"},
 	{"Speaker", NULL, "SPOLP"},
 	{"Speaker", NULL, "SPOLN"},
 };
-- 
2.30.2


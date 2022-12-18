Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DAD64FF83
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiLRQDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiLRQDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:03:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA34BE04;
        Sun, 18 Dec 2022 08:02:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D48BB80B4A;
        Sun, 18 Dec 2022 16:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A51BC433D2;
        Sun, 18 Dec 2022 16:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379346;
        bh=94mJ4ktmnNf7/RYeKm5j2AXaLYPBiO/CeY1y913/4sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxVQtO7c5/KcgKfBHKbUW2lwOHzwCYc6tmjqtB56+XLaHjvXiKA2sPDULRPE0uUKY
         DgBCNYSKRxgF88smT2CiyYpi0tVdHROUJ6PWnfNl89Q/u3BaWvgMGUMgvodH9wp5P1
         GT4CNCQ6/2R/6Aqi8vGY5iqOqD7OZzIOGwyEJFXnOkodO69GWh1KMkUMAdVeirSaCh
         Znz8BtxEeC0YZ7KOdXRsqWgTkPa3B0EhEXdBHOUqNNOkRS8mRGeAeptyqG+idYkYJ9
         Qu7cWhYLfrI9ElSKEru+QLc/tKBo/eXpCvHJWUiMkII8X7RgMxakSkSHa+Ri/j6szO
         y+NKIC3IXpgVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        pierre-louis.bossart@linux.intel.com,
        liam.r.girdwood@linux.intel.com, peter.ujfalusi@linux.intel.com,
        yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
        kai.vehmanen@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.1 07/85] ASoC: Intel: avs: Add quirk for KBL-R RVP platform
Date:   Sun, 18 Dec 2022 11:00:24 -0500
Message-Id: <20221218160142.925394-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 9d0737fa0e7530313634c0ecd75f09a95ba8d44a ]

KBL-R RVPs contain built-in rt298 codec which requires different PLL
clock and .dai_fmt configuration than seen on other boards.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20221010121955.718168-5-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/boards/rt298.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/sound/soc/intel/avs/boards/rt298.c b/sound/soc/intel/avs/boards/rt298.c
index b28d36872dcb..58c9d9edecf0 100644
--- a/sound/soc/intel/avs/boards/rt298.c
+++ b/sound/soc/intel/avs/boards/rt298.c
@@ -6,6 +6,7 @@
 //          Amadeusz Slawinski <amadeuszx.slawinski@linux.intel.com>
 //
 
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <sound/jack.h>
 #include <sound/pcm.h>
@@ -14,6 +15,16 @@
 #include <sound/soc-acpi.h>
 #include "../../../codecs/rt298.h"
 
+static const struct dmi_system_id kblr_dmi_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Kabylake R DDR4 RVP"),
+		},
+	},
+	{}
+};
+
 static const struct snd_kcontrol_new card_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Headphone Jack"),
 	SOC_DAPM_PIN_SWITCH("Mic Jack"),
@@ -96,9 +107,15 @@ avs_rt298_hw_params(struct snd_pcm_substream *substream, struct snd_pcm_hw_param
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(rtd, 0);
+	unsigned int clk_freq;
 	int ret;
 
-	ret = snd_soc_dai_set_sysclk(codec_dai, RT298_SCLK_S_PLL, 19200000, SND_SOC_CLOCK_IN);
+	if (dmi_first_match(kblr_dmi_table))
+		clk_freq = 24000000;
+	else
+		clk_freq = 19200000;
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, RT298_SCLK_S_PLL, clk_freq, SND_SOC_CLOCK_IN);
 	if (ret < 0)
 		dev_err(rtd->dev, "Set codec sysclk failed: %d\n", ret);
 
@@ -139,7 +156,10 @@ static int avs_create_dai_link(struct device *dev, const char *platform_name, in
 	dl->platforms = platform;
 	dl->num_platforms = 1;
 	dl->id = 0;
-	dl->dai_fmt = SND_SOC_DAIFMT_DSP_A | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS;
+	if (dmi_first_match(kblr_dmi_table))
+		dl->dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS;
+	else
+		dl->dai_fmt = SND_SOC_DAIFMT_DSP_A | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS;
 	dl->init = avs_rt298_codec_init;
 	dl->be_hw_params_fixup = avs_rt298_be_fixup;
 	dl->ops = &avs_rt298_ops;
-- 
2.35.1


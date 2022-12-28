Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E087065831A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbiL1Qo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiL1QoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:44:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B031BEB6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE7C2B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5534CC433D2;
        Wed, 28 Dec 2022 16:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245542;
        bh=94mJ4ktmnNf7/RYeKm5j2AXaLYPBiO/CeY1y913/4sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSWxG0WF9tvcx9FH27WMKmrEPK3S2AINZ/iv07IqwkchDpV77VUhM8nc8JHfEUwB5
         2Qm2QZSBp7p1PtcCOqEDK7Y/bxO2CLiabpyQS6vSyVkAHfJxa/HoPVF516Ed6GrC88
         HoIlkY67K1+1cI4mr9K/PaIkEUTKCRtpv8TUN2bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0912/1073] ASoC: Intel: avs: Add quirk for KBL-R RVP platform
Date:   Wed, 28 Dec 2022 15:41:40 +0100
Message-Id: <20221228144352.800470472@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




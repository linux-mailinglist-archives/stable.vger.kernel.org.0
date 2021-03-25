Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8434F348FC9
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhCYL3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhCYL1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:27:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D9761A54;
        Thu, 25 Mar 2021 11:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671626;
        bh=Q/Y4k2wcSNF73hgj4PURLtegrzDPPTwTGSpbTM8Vdso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjygI+75y6F7++ldvFX1tFcQly1xSDt8bJuG9vxMVmTEyZVsv34If/+MtayqZ1vrF
         f45WOvljujKlQosNTWyQ2uSFPQawAo3f/DwfNmy3r9osydT7pDUm29VIs7CkaQ/IQk
         hw2x8TyRIFJPvK0RDf5t53PG71rZoXtfXT7SCCh2sMNAx80X6IWba5032o1CAho+v9
         uFpiS7BZbxURy/hahBeVWlJtV5+zUACDMA8GTtFlmqRAhsXEbCFRhi/CMfhNAaE0aI
         EZK23pXwcfbJ6/qRmPPyJKBnkQpwoNqyGWyl5hkSmx+avBAZ5mn6L1Jc4gLRY/K+RD
         kK6AuH+b/oKCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Tanure <tanureal@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 11/24] ASoC: cs42l42: Fix channel width support
Date:   Thu, 25 Mar 2021 07:26:37 -0400
Message-Id: <20210325112651.1927828-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Tanure <tanureal@opensource.cirrus.com>

[ Upstream commit 2bdc4f5c6838f7c3feb4fe68e4edbeea158ec0a2 ]

Remove the hard coded 32 bits width and replace with the correct width
calculated by params_width.

Signed-off-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210305173442.195740-3-tanureal@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 47 ++++++++++++++++++--------------------
 sound/soc/codecs/cs42l42.h |  1 -
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index c78e2ce37930..26ca5acf0136 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -691,24 +691,6 @@ static int cs42l42_pll_config(struct snd_soc_component *component)
 					CS42L42_CLK_OASRC_SEL_MASK,
 					CS42L42_CLK_OASRC_SEL_12 <<
 					CS42L42_CLK_OASRC_SEL_SHIFT);
-			/* channel 1 on low LRCLK, 32 bit */
-			snd_soc_component_update_bits(component,
-					CS42L42_ASP_RX_DAI0_CH1_AP_RES,
-					CS42L42_ASP_RX_CH_AP_MASK |
-					CS42L42_ASP_RX_CH_RES_MASK,
-					(CS42L42_ASP_RX_CH_AP_LOW <<
-					CS42L42_ASP_RX_CH_AP_SHIFT) |
-					(CS42L42_ASP_RX_CH_RES_32 <<
-					CS42L42_ASP_RX_CH_RES_SHIFT));
-			/* Channel 2 on high LRCLK, 32 bit */
-			snd_soc_component_update_bits(component,
-					CS42L42_ASP_RX_DAI0_CH2_AP_RES,
-					CS42L42_ASP_RX_CH_AP_MASK |
-					CS42L42_ASP_RX_CH_RES_MASK,
-					(CS42L42_ASP_RX_CH_AP_HI <<
-					CS42L42_ASP_RX_CH_AP_SHIFT) |
-					(CS42L42_ASP_RX_CH_RES_32 <<
-					CS42L42_ASP_RX_CH_RES_SHIFT));
 			if (pll_ratio_table[i].mclk_src_sel == 0) {
 				/* Pass the clock straight through */
 				snd_soc_component_update_bits(component,
@@ -824,14 +806,29 @@ static int cs42l42_pcm_hw_params(struct snd_pcm_substream *substream,
 {
 	struct snd_soc_component *component = dai->component;
 	struct cs42l42_private *cs42l42 = snd_soc_component_get_drvdata(component);
-	int retval;
+	unsigned int width = (params_width(params) / 8) - 1;
+	unsigned int val = 0;
 
 	cs42l42->srate = params_rate(params);
-	cs42l42->swidth = params_width(params);
 
-	retval = cs42l42_pll_config(component);
+	switch(substream->stream) {
+	case SNDRV_PCM_STREAM_PLAYBACK:
+		val |= width << CS42L42_ASP_RX_CH_RES_SHIFT;
+		/* channel 1 on low LRCLK */
+		snd_soc_component_update_bits(component, CS42L42_ASP_RX_DAI0_CH1_AP_RES,
+							 CS42L42_ASP_RX_CH_AP_MASK |
+							 CS42L42_ASP_RX_CH_RES_MASK, val);
+		/* Channel 2 on high LRCLK */
+		val |= CS42L42_ASP_RX_CH_AP_HI << CS42L42_ASP_RX_CH_AP_SHIFT;
+		snd_soc_component_update_bits(component, CS42L42_ASP_RX_DAI0_CH2_AP_RES,
+							 CS42L42_ASP_RX_CH_AP_MASK |
+							 CS42L42_ASP_RX_CH_RES_MASK, val);
+		break;
+	default:
+		break;
+	}
 
-	return retval;
+	return cs42l42_pll_config(component);
 }
 
 static int cs42l42_set_sysclk(struct snd_soc_dai *dai,
@@ -896,9 +893,9 @@ static int cs42l42_digital_mute(struct snd_soc_dai *dai, int mute)
 	return 0;
 }
 
-#define CS42L42_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S18_3LE | \
-			SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE | \
-			SNDRV_PCM_FMTBIT_S32_LE)
+#define CS42L42_FORMATS (SNDRV_PCM_FMTBIT_S16_LE |\
+			 SNDRV_PCM_FMTBIT_S24_LE |\
+			 SNDRV_PCM_FMTBIT_S32_LE )
 
 
 static const struct snd_soc_dai_ops cs42l42_ops = {
diff --git a/sound/soc/codecs/cs42l42.h b/sound/soc/codecs/cs42l42.h
index 1f0d67c95a9a..9b017b76828a 100644
--- a/sound/soc/codecs/cs42l42.h
+++ b/sound/soc/codecs/cs42l42.h
@@ -757,7 +757,6 @@ struct  cs42l42_private {
 	struct completion pdn_done;
 	u32 sclk;
 	u32 srate;
-	u32 swidth;
 	u8 plug_state;
 	u8 hs_type;
 	u8 ts_inv;
-- 
2.30.1


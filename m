Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6B499BE5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450384AbiAXV5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1574350AbiAXVs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:48:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F879C0811BF;
        Mon, 24 Jan 2022 12:33:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1AA6614EC;
        Mon, 24 Jan 2022 20:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CB4C340E5;
        Mon, 24 Jan 2022 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056396;
        bh=gHfSCmYBYByuJZQy+bCo3KStS81UFeM1yUwFWwaOcNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vI2KHRCS4B5iDl6vWsmCossVN9a/xg953okdT8f5N9qZ7jNtvwfegQW9t8ol+6mUB
         mfC7wCT8kVuE9h4QBdBTyXcuJ+gUSP9FslVbdHWjWrbiog1DOmgC6cgWaepjbl6IhY
         RHD5/KuDMCx/TjSC7jeezgUzuX+gR5IrU6Nl/Luo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Wu <trevor.wu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/846] ASoC: mediatek: mt8195: correct pcmif BE dai control flow
Date:   Mon, 24 Jan 2022 19:39:14 +0100
Message-Id: <20220124184116.054750113@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trevor Wu <trevor.wu@mediatek.com>

[ Upstream commit 2355028c0c54c03afb66c589347f1dc9f6fe2e38 ]

Originally, the conditions for preventing reentry are not correct.
dai->component->active is not the state specifically for pcmif dai, so it
is not a correct condition to indicate the status of pcmif dai.
On the other hand, snd_soc_dai_stream_actvie() in prepare ops for both
playback and capture possibly return true at the first entry when these
two streams are opened at the same time.

In the patch, I refer to the implementation in mt8192-dai-pcm.c.
Clock and enabling bit for PCMIF are managed by DAPM, and the condition
for prepare ops is replaced by the status of dai widget.

Fixes: 1f95c019115c ("ASoC: mediatek: mt8195: support pcm in platform driver")
Signed-off-by: Trevor Wu <trevor.wu@mediatek.com>
Link: https://lore.kernel.org/r/20211230084731.31372-2-trevor.wu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-pcm.c | 73 +++++++---------------
 sound/soc/mediatek/mt8195/mt8195-reg.h     |  1 +
 2 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c b/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c
index 5d10d2c4c991c..151914c873acd 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-pcm.c
@@ -80,8 +80,15 @@ static const struct snd_soc_dapm_widget mtk_dai_pcm_widgets[] = {
 			   mtk_dai_pcm_o001_mix,
 			   ARRAY_SIZE(mtk_dai_pcm_o001_mix)),
 
+	SND_SOC_DAPM_SUPPLY("PCM_EN", PCM_INTF_CON1,
+			    PCM_INTF_CON1_PCM_EN_SHIFT, 0, NULL, 0),
+
 	SND_SOC_DAPM_INPUT("PCM1_INPUT"),
 	SND_SOC_DAPM_OUTPUT("PCM1_OUTPUT"),
+
+	SND_SOC_DAPM_CLOCK_SUPPLY("aud_asrc11"),
+	SND_SOC_DAPM_CLOCK_SUPPLY("aud_asrc12"),
+	SND_SOC_DAPM_CLOCK_SUPPLY("aud_pcmif"),
 };
 
 static const struct snd_soc_dapm_route mtk_dai_pcm_routes[] = {
@@ -97,22 +104,18 @@ static const struct snd_soc_dapm_route mtk_dai_pcm_routes[] = {
 	{"PCM1 Playback", NULL, "O000"},
 	{"PCM1 Playback", NULL, "O001"},
 
+	{"PCM1 Playback", NULL, "PCM_EN"},
+	{"PCM1 Playback", NULL, "aud_asrc12"},
+	{"PCM1 Playback", NULL, "aud_pcmif"},
+
+	{"PCM1 Capture", NULL, "PCM_EN"},
+	{"PCM1 Capture", NULL, "aud_asrc11"},
+	{"PCM1 Capture", NULL, "aud_pcmif"},
+
 	{"PCM1_OUTPUT", NULL, "PCM1 Playback"},
 	{"PCM1 Capture", NULL, "PCM1_INPUT"},
 };
 
-static void mtk_dai_pcm_enable(struct mtk_base_afe *afe)
-{
-	regmap_update_bits(afe->regmap, PCM_INTF_CON1,
-			   PCM_INTF_CON1_PCM_EN, PCM_INTF_CON1_PCM_EN);
-}
-
-static void mtk_dai_pcm_disable(struct mtk_base_afe *afe)
-{
-	regmap_update_bits(afe->regmap, PCM_INTF_CON1,
-			   PCM_INTF_CON1_PCM_EN, 0x0);
-}
-
 static int mtk_dai_pcm_configure(struct snd_pcm_substream *substream,
 				 struct snd_soc_dai *dai)
 {
@@ -207,54 +210,22 @@ static int mtk_dai_pcm_configure(struct snd_pcm_substream *substream,
 }
 
 /* dai ops */
-static int mtk_dai_pcm_startup(struct snd_pcm_substream *substream,
-			       struct snd_soc_dai *dai)
-{
-	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
-	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-
-	if (dai->component->active)
-		return 0;
-
-	mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_ASRC11]);
-	mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_ASRC12]);
-	mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_PCMIF]);
-
-	return 0;
-}
-
-static void mtk_dai_pcm_shutdown(struct snd_pcm_substream *substream,
-				 struct snd_soc_dai *dai)
-{
-	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
-	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-
-	if (dai->component->active)
-		return;
-
-	mtk_dai_pcm_disable(afe);
-
-	mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_PCMIF]);
-	mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_ASRC12]);
-	mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_ASRC11]);
-}
-
 static int mtk_dai_pcm_prepare(struct snd_pcm_substream *substream,
 			       struct snd_soc_dai *dai)
 {
-	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
-	int ret = 0;
+	int ret;
 
-	if (snd_soc_dai_stream_active(dai, SNDRV_PCM_STREAM_PLAYBACK) &&
-	    snd_soc_dai_stream_active(dai, SNDRV_PCM_STREAM_CAPTURE))
+	dev_dbg(dai->dev, "%s(), id %d, stream %d, widget active p %d, c %d\n",
+		__func__, dai->id, substream->stream,
+		dai->playback_widget->active, dai->capture_widget->active);
+
+	if (dai->playback_widget->active || dai->capture_widget->active)
 		return 0;
 
 	ret = mtk_dai_pcm_configure(substream, dai);
 	if (ret)
 		return ret;
 
-	mtk_dai_pcm_enable(afe);
-
 	return 0;
 }
 
@@ -316,8 +287,6 @@ static int mtk_dai_pcm_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 }
 
 static const struct snd_soc_dai_ops mtk_dai_pcm_ops = {
-	.startup	= mtk_dai_pcm_startup,
-	.shutdown	= mtk_dai_pcm_shutdown,
 	.prepare	= mtk_dai_pcm_prepare,
 	.set_fmt	= mtk_dai_pcm_set_fmt,
 };
diff --git a/sound/soc/mediatek/mt8195/mt8195-reg.h b/sound/soc/mediatek/mt8195/mt8195-reg.h
index d06f9cf85a4ec..d3871353db415 100644
--- a/sound/soc/mediatek/mt8195/mt8195-reg.h
+++ b/sound/soc/mediatek/mt8195/mt8195-reg.h
@@ -2550,6 +2550,7 @@
 #define PCM_INTF_CON1_PCM_FMT(x)       (((x) & 0x3) << 1)
 #define PCM_INTF_CON1_PCM_FMT_MASK     (0x3 << 1)
 #define PCM_INTF_CON1_PCM_EN           BIT(0)
+#define PCM_INTF_CON1_PCM_EN_SHIFT     0
 
 /* PCM_INTF_CON2 */
 #define PCM_INTF_CON2_CLK_DOMAIN_SEL(x)   (((x) & 0x3) << 23)
-- 
2.34.1




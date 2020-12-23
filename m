Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B52D2E1731
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgLWDHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728345AbgLWCSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D4FC22525;
        Wed, 23 Dec 2020 02:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689874;
        bh=XC57S2E/6U4A5BTFsO9yT2N0wDA1oFFu6630l6ZodHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WcoZfFV3p75rXr6N6LsuwkSTFhTjpEOwsP1ul/jF2LL3Tai3h4S3+cFPnzBjHxikO
         BA3IAQHz5qzPGbeyjl1vnc7LLNARuJ6VOVCGvMYKe/yjesBXMdm0nUIIRjs3SUbQ9H
         lm+1l3jQ6E9JlOOq3wHI5hg378SEkidxE4GRjbys3GvWNIG7t766I7pBymVFe7iLrm
         dnSxUAfN3TItNH8Oj49KgiVR5rIu/9HRGG3wBECDmZwbPaiEcnYaxlUYyF49wQ6cGR
         vStGsdSGV2rYAZw4h591yRtlo6xNmJaO01LtwDH0in2d1AlGK94XVPRdKBCtTpJPld
         h2xskRponlfIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Shane.Chien" <shane.chien@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 066/217] ASoC: Fix vaud18 power leakage of mt6359
Date:   Tue, 22 Dec 2020 21:13:55 -0500
Message-Id: <20201223021626.2790791-66-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Shane.Chien" <shane.chien@mediatek.com>

[ Upstream commit 64a70744b77898a15d7a5b2b4dc0fa9523a75cde ]

vaud18 is power of mt6359 audio path. It
should only enable when audio is used,
instead of in boot up stage.
Once mt6359 audio path is enabled or disabled,
vaud18 is controlled by regulator supply widget
"LDO_VAUD18". Due to vaud18 is controlled by
regulator dapm macro instead of regmap, the macro
MT6359_LDO_VAUD18_CON0 and variable avdd_reg
is no used and removed from mt6359.h.

Signed-off-by: Shane.Chien <shane.chien@mediatek.com>
Link: https://lore.kernel.org/r/1604975492-6142-2-git-send-email-shane.chien@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359.c | 25 +------------------------
 sound/soc/codecs/mt6359.h |  8 --------
 2 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/sound/soc/codecs/mt6359.c b/sound/soc/codecs/mt6359.c
index 81aafb553bdd9..64b26ab969ed8 100644
--- a/sound/soc/codecs/mt6359.c
+++ b/sound/soc/codecs/mt6359.c
@@ -1833,9 +1833,7 @@ static const struct snd_soc_dapm_widget mt6359_dapm_widgets[] = {
 	SND_SOC_DAPM_SUPPLY_S("CLK_BUF", SUPPLY_SEQ_CLK_BUF,
 			      MT6359_DCXO_CW12,
 			      RG_XO_AUDIO_EN_M_SFT, 0, NULL, 0),
-	SND_SOC_DAPM_SUPPLY_S("LDO_VAUD18", SUPPLY_SEQ_LDO_VAUD18,
-			      MT6359_LDO_VAUD18_CON0,
-			      RG_LDO_VAUD18_EN_SFT, 0, NULL, 0),
+	SND_SOC_DAPM_REGULATOR_SUPPLY("LDO_VAUD18", 0, 0),
 	SND_SOC_DAPM_SUPPLY_S("AUDGLB", SUPPLY_SEQ_AUD_GLB,
 			      MT6359_AUDDEC_ANA_CON13,
 			      RG_AUDGLB_PWRDN_VA32_SFT, 1, NULL, 0),
@@ -2697,20 +2695,6 @@ static int mt6359_platform_driver_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	priv->dev = &pdev->dev;
 
-	priv->avdd_reg = devm_regulator_get(&pdev->dev, "vaud18");
-	if (IS_ERR(priv->avdd_reg)) {
-		dev_err(&pdev->dev, "%s(), have no vaud18 supply: %ld",
-			__func__, PTR_ERR(priv->avdd_reg));
-		return PTR_ERR(priv->avdd_reg);
-	}
-
-	ret = regulator_enable(priv->avdd_reg);
-	if (ret) {
-		dev_err(&pdev->dev, "%s(), failed to enable regulator!\n",
-			__func__);
-		return ret;
-	}
-
 	ret = mt6359_parse_dt(priv);
 	if (ret) {
 		dev_warn(&pdev->dev, "%s() failed to parse dts\n", __func__);
@@ -2731,13 +2715,6 @@ static int mt6359_platform_driver_remove(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "%s(), dev name %s\n",
 		__func__, dev_name(&pdev->dev));
 
-	ret = regulator_disable(priv->avdd_reg);
-	if (ret) {
-		dev_err(&pdev->dev, "%s(), failed to disable regulator!\n",
-			__func__);
-		return ret;
-	}
-
 	return 0;
 }
 
diff --git a/sound/soc/codecs/mt6359.h b/sound/soc/codecs/mt6359.h
index 3792e534a91b6..e0aebf639e461 100644
--- a/sound/soc/codecs/mt6359.h
+++ b/sound/soc/codecs/mt6359.h
@@ -135,11 +135,6 @@
 /* MT6359_DCXO_CW12 */
 #define RG_XO_AUDIO_EN_M_SFT				13
 
-/* LDO_VAUD18_CON0 */
-#define RG_LDO_VAUD18_EN_SFT				0
-#define RG_LDO_VAUD18_EN_MASK				0x1
-#define RG_LDO_VAUD18_EN_MASK_SFT			(0x1 << 0)
-
 /* AUD_TOP_CKPDN_CON0 */
 #define RG_VOW13M_CK_PDN_SFT				13
 #define RG_VOW13M_CK_PDN_MASK				0x1
@@ -2132,7 +2127,6 @@
 
 #define MT6359_DCXO_CW11				0x7a6
 #define MT6359_DCXO_CW12				0x7a8
-#define MT6359_LDO_VAUD18_CON0				0x1c98
 
 #define MT6359_GPIO_MODE0				0xcc
 #define MT6359_GPIO_MODE0_SET				0xce
@@ -2469,7 +2463,6 @@ enum {
 enum {
 	/* common */
 	SUPPLY_SEQ_CLK_BUF,
-	SUPPLY_SEQ_LDO_VAUD18,
 	SUPPLY_SEQ_AUD_GLB,
 	SUPPLY_SEQ_HP_PULL_DOWN,
 	SUPPLY_SEQ_CLKSQ,
@@ -2629,7 +2622,6 @@ struct mt6359_priv {
 	int hp_gain_ctl;
 	int hp_hifi_mode;
 	int mtkaif_protocol;
-	struct regulator *avdd_reg;
 };
 
 #define CODEC_MT6359_NAME "mtk-codec-mt6359"
-- 
2.27.0


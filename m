Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7B1A5AFC
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgDKXpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgDKXF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D617221835;
        Sat, 11 Apr 2020 23:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646328;
        bh=nakkXGfNLVDozxCTevxo+JWMDbSpXrDWS5PkJAF2ipA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mboQ15BFxYb9hSZq1FQZnfnSp+QdpJGfTsOW/pBemzI6J8Hw/6PNLX9RaPmLqScGe
         5XWc0ifsMwqaCuGCtSH9AuRVOeBVrGYgcJPDcZ2o5/ZcVenf8p4ftD58YsY13xihGl
         Oq86HyEPQztIKiOCDFwBWVSowyZBLfh5ueUhi9Go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 081/149] ASoC: mediatek: mt8183-da7219: pull TDM GPIO pins down when probed
Date:   Sat, 11 Apr 2020 19:02:38 -0400
Message-Id: <20200411230347.22371-81-sashal@kernel.org>
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

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 8726ee6148fe24e2b29d4a961ad95c4ff8025d1d ]

1. Switch TDM GPIO pins according to playback on or off.
2. Pull TDM GPIO pins down when probed to avoid current leakage.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20200213112003.2.I1d568b0c99742c6e755d051aadfd52e4be3cc0a5@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mediatek/mt8183/mt8183-da7219-max98357.c  | 104 +++++++++++++++++-
 1 file changed, 98 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
index c65493721e90d..a3974b0a90157 100644
--- a/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
+++ b/sound/soc/mediatek/mt8183/mt8183-da7219-max98357.c
@@ -18,6 +18,22 @@
 
 static struct snd_soc_jack headset_jack;
 
+enum PINCTRL_PIN_STATE {
+	PIN_STATE_DEFAULT = 0,
+	PIN_TDM_OUT_ON,
+	PIN_TDM_OUT_OFF,
+	PIN_STATE_MAX
+};
+
+static const char * const mt8183_pin_str[PIN_STATE_MAX] = {
+	"default", "aud_tdm_out_on", "aud_tdm_out_off",
+};
+
+struct mt8183_da7219_max98357_priv {
+	struct pinctrl *pinctrl;
+	struct pinctrl_state *pin_states[PIN_STATE_MAX];
+};
+
 static int mt8183_mt6358_i2s_hw_params(struct snd_pcm_substream *substream,
 				       struct snd_pcm_hw_params *params)
 {
@@ -204,6 +220,47 @@ SND_SOC_DAILINK_DEFS(tdm,
 	DAILINK_COMP_ARRAY(COMP_DUMMY()),
 	DAILINK_COMP_ARRAY(COMP_EMPTY()));
 
+static int mt8183_da7219_tdm_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct mt8183_da7219_max98357_priv *priv =
+		snd_soc_card_get_drvdata(rtd->card);
+	int ret;
+
+	if (IS_ERR(priv->pin_states[PIN_TDM_OUT_ON]))
+		return PTR_ERR(priv->pin_states[PIN_TDM_OUT_ON]);
+
+	ret = pinctrl_select_state(priv->pinctrl,
+				   priv->pin_states[PIN_TDM_OUT_ON]);
+	if (ret)
+		dev_err(rtd->card->dev, "%s failed to select state %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
+static void mt8183_da7219_tdm_shutdown(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct mt8183_da7219_max98357_priv *priv =
+		snd_soc_card_get_drvdata(rtd->card);
+	int ret;
+
+	if (IS_ERR(priv->pin_states[PIN_TDM_OUT_OFF]))
+		return;
+
+	ret = pinctrl_select_state(priv->pinctrl,
+				   priv->pin_states[PIN_TDM_OUT_OFF]);
+	if (ret)
+		dev_err(rtd->card->dev, "%s failed to select state %d\n",
+			__func__, ret);
+}
+
+static struct snd_soc_ops mt8183_da7219_tdm_ops = {
+	.startup = mt8183_da7219_tdm_startup,
+	.shutdown = mt8183_da7219_tdm_shutdown,
+};
+
 static struct snd_soc_dai_link mt8183_da7219_max98357_dai_links[] = {
 	/* FE */
 	{
@@ -353,6 +410,8 @@ static struct snd_soc_dai_link mt8183_da7219_max98357_dai_links[] = {
 		.no_pcm = 1,
 		.dpcm_playback = 1,
 		.ignore_suspend = 1,
+		.be_hw_params_fixup = mt8183_i2s_hw_params_fixup,
+		.ops = &mt8183_da7219_tdm_ops,
 		SND_SOC_DAILINK_REG(tdm),
 	},
 };
@@ -409,7 +468,7 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 	struct snd_soc_card *card = &mt8183_da7219_max98357_card;
 	struct device_node *platform_node;
 	struct snd_soc_dai_link *dai_link;
-	struct pinctrl *default_pins;
+	struct mt8183_da7219_max98357_priv *priv;
 	int ret, i;
 
 	card->dev = &pdev->dev;
@@ -443,12 +502,45 @@ static int mt8183_da7219_max98357_dev_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	default_pins =
-		devm_pinctrl_get_select(&pdev->dev, PINCTRL_STATE_DEFAULT);
-	if (IS_ERR(default_pins)) {
-		dev_err(&pdev->dev, "%s set pins failed\n",
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	snd_soc_card_set_drvdata(card, priv);
+
+	priv->pinctrl = devm_pinctrl_get(&pdev->dev);
+	if (IS_ERR(priv->pinctrl)) {
+		dev_err(&pdev->dev, "%s devm_pinctrl_get failed\n",
 			__func__);
-		return PTR_ERR(default_pins);
+		return PTR_ERR(priv->pinctrl);
+	}
+
+	for (i = 0; i < PIN_STATE_MAX; i++) {
+		priv->pin_states[i] = pinctrl_lookup_state(priv->pinctrl,
+							   mt8183_pin_str[i]);
+		if (IS_ERR(priv->pin_states[i])) {
+			ret = PTR_ERR(priv->pin_states[i]);
+			dev_info(&pdev->dev, "%s Can't find pin state %s %d\n",
+				 __func__, mt8183_pin_str[i], ret);
+		}
+	}
+
+	if (!IS_ERR(priv->pin_states[PIN_TDM_OUT_OFF])) {
+		ret = pinctrl_select_state(priv->pinctrl,
+					   priv->pin_states[PIN_TDM_OUT_OFF]);
+		if (ret)
+			dev_info(&pdev->dev,
+				 "%s failed to select state %d\n",
+				 __func__, ret);
+	}
+
+	if (!IS_ERR(priv->pin_states[PIN_STATE_DEFAULT])) {
+		ret = pinctrl_select_state(priv->pinctrl,
+					   priv->pin_states[PIN_STATE_DEFAULT]);
+		if (ret)
+			dev_info(&pdev->dev,
+				 "%s failed to select state %d\n",
+				 __func__, ret);
 	}
 
 	return ret;
-- 
2.20.1


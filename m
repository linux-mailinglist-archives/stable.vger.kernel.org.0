Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC6BA46D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391701AbfIVSsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391693AbfIVSsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 076FB208C2;
        Sun, 22 Sep 2019 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178116;
        bh=9qfmsiCNaEBBbVAUBNjUeGmGxH7qdzSy+RWQqBp7ZR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ordSCYFRGf1zkUMc2ZSYmyiFfCh0sUbgiXk28MVkKksf1ev1w3bL44Z1qNeKMtYMi
         nSr6jM86A1dKUW87wReDSqtnVnabsxEBpwr6kQemkOK/myZsTcjzzZJPomd0ed7SBm
         jS91K2ncL+Fg0SMIzrjG4Ye0ExEX9d9usYZ/u+JQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 173/203] ASoC: es8316: support fixed and variable both clock rates
Date:   Sun, 22 Sep 2019 14:43:19 -0400
Message-Id: <20190922184350.30563-173-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Katsuhiro Suzuki <katsuhiro@katsuster.net>

[ Upstream commit ebe02a5b9ef05e3b812af3d628cdf6206d9ba610 ]

This patch supports some type of machine drivers that set 0 to mclk
when sound device goes to idle state. After applied this patch,
sysclk == 0 means there is no constraint of sound rate and other
values will set constraints which is derived by sysclk setting.

Original code refuses sysclk == 0 setting. But some boards and SoC
(such as RockPro64 and RockChip I2S) has connected SoC MCLK out to
ES8316 MCLK in. In this case, SoC side I2S will choose suitable
frequency of MCLK such as fs * mclk-fs when user starts playing or
capturing.

Bad scenario as follows (mclk-fs = 256):
  - Initialize sysclk by correct value (Ex. 12.288MHz)
    - ES8316 set constraints of PCM rate by sysclk
      48kHz (1/256), 32kHz (1/384), 30.720kHz (1/400),
      24kHz (1/512), 16kHz (1/768), 12kHz (1/1024)
  - Play 48kHz sound, it's acceptable
  - Sysclk is not changed

  - Play 32kHz sound, it's acceptable
  - Set sysclk by 8.192MHz (= fs * mclk-fs = 32k * 256)
    - ES8316 set constraints of PCM rate by sysclk
      32kHz (1/256), 21.33kHz (1/384), 20.48kHz (1/400),
      16kHz (1/512), 10.66kHz (1/768), 8kHz (1/1024)

  - Play 48kHz again, but it's NOT acceptable because constraints
    list does not allow 48kHz

Signed-off-by: Katsuhiro Suzuki <katsuhiro@katsuster.net>
Link: https://lore.kernel.org/r/20190907163653.9382-2-katsuhiro@katsuster.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 96d04896193f2..c47b3c4bb06c7 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -368,8 +368,12 @@ static int es8316_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 
 	es8316->sysclk = freq;
 
-	if (freq == 0)
+	if (freq == 0) {
+		es8316->sysclk_constraints.list = NULL;
+		es8316->sysclk_constraints.count = 0;
+
 		return 0;
+	}
 
 	/* Limit supported sample rates to ones that can be autodetected
 	 * by the codec running in slave mode.
@@ -444,17 +448,10 @@ static int es8316_pcm_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_component *component = dai->component;
 	struct es8316_priv *es8316 = snd_soc_component_get_drvdata(component);
 
-	if (es8316->sysclk == 0) {
-		dev_err(component->dev, "No sysclk provided\n");
-		return -EINVAL;
-	}
-
-	/* The set of sample rates that can be supported depends on the
-	 * MCLK supplied to the CODEC.
-	 */
-	snd_pcm_hw_constraint_list(substream->runtime, 0,
-				   SNDRV_PCM_HW_PARAM_RATE,
-				   &es8316->sysclk_constraints);
+	if (es8316->sysclk_constraints.list)
+		snd_pcm_hw_constraint_list(substream->runtime, 0,
+					   SNDRV_PCM_HW_PARAM_RATE,
+					   &es8316->sysclk_constraints);
 
 	return 0;
 }
@@ -466,11 +463,19 @@ static int es8316_pcm_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_component *component = dai->component;
 	struct es8316_priv *es8316 = snd_soc_component_get_drvdata(component);
 	u8 wordlen = 0;
+	int i;
 
-	if (!es8316->sysclk) {
-		dev_err(component->dev, "No MCLK configured\n");
-		return -EINVAL;
+	/* Validate supported sample rates that are autodetected from MCLK */
+	for (i = 0; i < NR_SUPPORTED_MCLK_LRCK_RATIOS; i++) {
+		const unsigned int ratio = supported_mclk_lrck_ratios[i];
+
+		if (es8316->sysclk % ratio != 0)
+			continue;
+		if (es8316->sysclk / ratio == params_rate(params))
+			break;
 	}
+	if (i == NR_SUPPORTED_MCLK_LRCK_RATIOS)
+		return -EINVAL;
 
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
-- 
2.20.1


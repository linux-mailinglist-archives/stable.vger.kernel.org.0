Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1563A8530
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhFOPx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232209AbhFOPw1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:52:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3079E61883;
        Tue, 15 Jun 2021 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772212;
        bh=9BY+7FlAR/W7EiBSFe7ISrft7bHXbXUdoK/bMZJNjuw=;
        h=From:To:Cc:Subject:Date:From;
        b=Krs5EhRYGaisd+KNgXWF9vNq9dcrcQmqjg0zQnKuP3N3aww2MLz9AfsfSSD+B7e8q
         92YauaiPdLWDEAAOapeqN/9CCplfuzybI2uoPdz2fp97Gw/93UkkRkZovkJsS6F5PM
         5joTzcSkH+CLYT6VTLT6vuIwJrF9Wf3mqi8dTea9mQzhFhmw+OTETRzcSc8nzLWq5o
         I7p/CeyVEtWhL9EJXxCbXi65xz3T8DjKsnG1eQzUCLif6zw8frXWGRp8bgQ1GTR6lU
         omKhywm7gkCxy31tJ/2zVHZ3t+cgc+XJQr5JHh+CqwDRERwN8qbPhsOoDuEiGmr0aO
         rZFOhHnlGC/pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Yu <jack.yu@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 01/12] ASoC: rt5659: Fix the lost powers for the HDA header
Date:   Tue, 15 Jun 2021 11:49:58 -0400
Message-Id: <20210615155009.62894-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 6308c44ed6eeadf65c0a7ba68d609773ed860fbb ]

The power of "LDO2", "MICBIAS1" and "Mic Det Power" were powered off after
the DAPM widgets were added, and these powers were set by the JD settings
"RT5659_JD_HDA_HEADER" in the probe function. In the codec probe function,
these powers were ignored to prevent them controlled by DAPM.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Signed-off-by: Jack Yu <jack.yu@realtek.com>
Message-Id: <15fced51977b458798ca4eebf03dafb9@realtek.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index b331b3ba61a9..ab73f84b5970 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -2473,13 +2473,18 @@ static int set_dmic_power(struct snd_soc_dapm_widget *w,
 	return 0;
 }
 
-static const struct snd_soc_dapm_widget rt5659_dapm_widgets[] = {
+static const struct snd_soc_dapm_widget rt5659_particular_dapm_widgets[] = {
 	SND_SOC_DAPM_SUPPLY("LDO2", RT5659_PWR_ANLG_3, RT5659_PWR_LDO2_BIT, 0,
 		NULL, 0),
-	SND_SOC_DAPM_SUPPLY("PLL", RT5659_PWR_ANLG_3, RT5659_PWR_PLL_BIT, 0,
-		NULL, 0),
+	SND_SOC_DAPM_SUPPLY("MICBIAS1", RT5659_PWR_ANLG_2, RT5659_PWR_MB1_BIT,
+		0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("Mic Det Power", RT5659_PWR_VOL,
 		RT5659_PWR_MIC_DET_BIT, 0, NULL, 0),
+};
+
+static const struct snd_soc_dapm_widget rt5659_dapm_widgets[] = {
+	SND_SOC_DAPM_SUPPLY("PLL", RT5659_PWR_ANLG_3, RT5659_PWR_PLL_BIT, 0,
+		NULL, 0),
 	SND_SOC_DAPM_SUPPLY("Mono Vref", RT5659_PWR_ANLG_1,
 		RT5659_PWR_VREF3_BIT, 0, NULL, 0),
 
@@ -2504,8 +2509,6 @@ static const struct snd_soc_dapm_widget rt5659_dapm_widgets[] = {
 		RT5659_ADC_MONO_R_ASRC_SFT, 0, NULL, 0),
 
 	/* Input Side */
-	SND_SOC_DAPM_SUPPLY("MICBIAS1", RT5659_PWR_ANLG_2, RT5659_PWR_MB1_BIT,
-		0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("MICBIAS2", RT5659_PWR_ANLG_2, RT5659_PWR_MB2_BIT,
 		0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("MICBIAS3", RT5659_PWR_ANLG_2, RT5659_PWR_MB3_BIT,
@@ -3700,10 +3703,23 @@ static int rt5659_set_bias_level(struct snd_soc_component *component,
 
 static int rt5659_probe(struct snd_soc_component *component)
 {
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 
 	rt5659->component = component;
 
+	switch (rt5659->pdata.jd_src) {
+	case RT5659_JD_HDA_HEADER:
+		break;
+
+	default:
+		snd_soc_dapm_new_controls(dapm,
+			rt5659_particular_dapm_widgets,
+			ARRAY_SIZE(rt5659_particular_dapm_widgets));
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.30.2


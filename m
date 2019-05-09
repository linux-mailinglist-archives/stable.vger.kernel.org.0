Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD7191E5
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfEISud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbfEISuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5AE20578;
        Thu,  9 May 2019 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427831;
        bh=j0ip8W1xQew4moKi3fx+8yA/sDU883+LnLommJGVs5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJPDhKlVVJgDGEegaR4CbJqTeAXW/1gZTryS8L9zlPsT+8hNANHhMc25OCc3OwI9w
         ImUmGKat99cuUq9dPgIkjSDmV0vp48SfjWIe5TQXfVebi/8l0/PsihlNCMtWNr2Z7i
         sAl96ZNGGV2lyXyCNXHDnAcPO20IigiYKiiocIdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 20/95] ASoC: rt5682: Check JD status when system resume
Date:   Thu,  9 May 2019 20:41:37 +0200
Message-Id: <20190509181310.766022247@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4834d7070c85a5fb69637265dbbb05d13043280c ]

The IRQ function may not work when system suspend.
We remove snd_soc_dapm_force_enable_pin function call to
make sure the bias off when idle and run into suspend/resume function.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index a9b91bcfcc096..49ff5e52db584 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -904,13 +904,20 @@ static int rt5682_headset_detect(struct snd_soc_component *component,
 		int jack_insert)
 {
 	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
-	struct snd_soc_dapm_context *dapm =
-		snd_soc_component_get_dapm(component);
 	unsigned int val, count;
 
 	if (jack_insert) {
-		snd_soc_dapm_force_enable_pin(dapm, "CBJ Power");
-		snd_soc_dapm_sync(dapm);
+
+		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
+			RT5682_PWR_VREF2, RT5682_PWR_VREF2);
+		snd_soc_component_update_bits(component,
+				RT5682_PWR_ANLG_1, RT5682_PWR_FV2, 0);
+		usleep_range(15000, 20000);
+		snd_soc_component_update_bits(component,
+				RT5682_PWR_ANLG_1, RT5682_PWR_FV2, RT5682_PWR_FV2);
+		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_3,
+			RT5682_PWR_CBJ, RT5682_PWR_CBJ);
+
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_HIGH);
 
@@ -938,8 +945,10 @@ static int rt5682_headset_detect(struct snd_soc_component *component,
 		rt5682_enable_push_button_irq(component, false);
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_1,
 			RT5682_TRIG_JD_MASK, RT5682_TRIG_JD_LOW);
-		snd_soc_dapm_disable_pin(dapm, "CBJ Power");
-		snd_soc_dapm_sync(dapm);
+		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_1,
+			RT5682_PWR_VREF2, 0);
+		snd_soc_component_update_bits(component, RT5682_PWR_ANLG_3,
+			RT5682_PWR_CBJ, 0);
 
 		rt5682->jack_type = 0;
 	}
@@ -1585,8 +1594,6 @@ static const struct snd_soc_dapm_widget rt5682_dapm_widgets[] = {
 		0, NULL, 0),
 	SND_SOC_DAPM_SUPPLY("Vref1", RT5682_PWR_ANLG_1, RT5682_PWR_VREF1_BIT, 0,
 		rt5655_set_verf, SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU),
-	SND_SOC_DAPM_SUPPLY("Vref2", RT5682_PWR_ANLG_1, RT5682_PWR_VREF2_BIT, 0,
-		rt5655_set_verf, SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMU),
 
 	/* ASRC */
 	SND_SOC_DAPM_SUPPLY_S("DAC STO1 ASRC", 1, RT5682_PLL_TRACK_1,
@@ -1621,9 +1628,6 @@ static const struct snd_soc_dapm_widget rt5682_dapm_widgets[] = {
 	SND_SOC_DAPM_PGA("BST1 CBJ", SND_SOC_NOPM,
 		0, 0, NULL, 0),
 
-	SND_SOC_DAPM_SUPPLY("CBJ Power", RT5682_PWR_ANLG_3,
-		RT5682_PWR_CBJ_BIT, 0, NULL, 0),
-
 	/* REC Mixer */
 	SND_SOC_DAPM_MIXER("RECMIX1L", SND_SOC_NOPM, 0, 0, rt5682_rec1_l_mix,
 		ARRAY_SIZE(rt5682_rec1_l_mix)),
@@ -1786,17 +1790,13 @@ static const struct snd_soc_dapm_route rt5682_dapm_routes[] = {
 
 	/*Vref*/
 	{"MICBIAS1", NULL, "Vref1"},
-	{"MICBIAS1", NULL, "Vref2"},
 	{"MICBIAS2", NULL, "Vref1"},
-	{"MICBIAS2", NULL, "Vref2"},
 
 	{"CLKDET SYS", NULL, "CLKDET"},
 
 	{"IN1P", NULL, "LDO2"},
 
 	{"BST1 CBJ", NULL, "IN1P"},
-	{"BST1 CBJ", NULL, "CBJ Power"},
-	{"CBJ Power", NULL, "Vref2"},
 
 	{"RECMIX1L", "CBJ Switch", "BST1 CBJ"},
 	{"RECMIX1L", NULL, "RECMIX1L Power"},
@@ -1906,9 +1906,7 @@ static const struct snd_soc_dapm_route rt5682_dapm_routes[] = {
 	{"HP Amp", NULL, "Capless"},
 	{"HP Amp", NULL, "Charge Pump"},
 	{"HP Amp", NULL, "CLKDET SYS"},
-	{"HP Amp", NULL, "CBJ Power"},
 	{"HP Amp", NULL, "Vref1"},
-	{"HP Amp", NULL, "Vref2"},
 	{"HPOL Playback", "Switch", "HP Amp"},
 	{"HPOR Playback", "Switch", "HP Amp"},
 	{"HPOL", NULL, "HPOL Playback"},
@@ -2357,6 +2355,8 @@ static int rt5682_resume(struct snd_soc_component *component)
 	regcache_cache_only(rt5682->regmap, false);
 	regcache_sync(rt5682->regmap);
 
+	rt5682_irq(0, rt5682);
+
 	return 0;
 }
 #else
-- 
2.20.1




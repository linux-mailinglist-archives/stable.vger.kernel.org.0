Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED964EC1A5
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344405AbiC3Lzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344735AbiC3Lxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B235B26E55D;
        Wed, 30 Mar 2022 04:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5746DB81C37;
        Wed, 30 Mar 2022 11:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C4CC340F3;
        Wed, 30 Mar 2022 11:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640972;
        bh=8MKOSueqAUGuN31VyJtXZ8WouYprwqTW9CycYNHA2Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpDA1CfQ2ZyjOO7v0FhTlMhKfK6acdfApFGqC6X2v1Y5cCysLKIiJ4Vqn/hzCA20K
         DHmohNtoeTjsbbQhKaA202fcSyMRlBcPBOxhZpX4lIaACXajPzelmXxj0DbtZw906O
         VV/yl9G00mEyKY/X1dftqaczSLc2HBh4eVjARY6UVAv2rSrkKYNfmCD8QXLV4qqGkX
         wlLg+QD5Yk2gxAaf5e25Z1hDAFEj5cG8AUk3XLUlh3cVJ2RY3W6ifKHhtLS5WHoPNM
         pab7/G/qnFi+PTQMufkmYhYJVV8LVRpfj3c19YMYathVfbR7SpD+BCXMmw2F9PijI1
         lUQ0bc95PUrGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, bardliao@realtek.com,
        oder_chiou@realtek.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 39/59] ASoC: rt5682s: Fix the wrong jack type detected
Date:   Wed, 30 Mar 2022 07:48:11 -0400
Message-Id: <20220330114831.1670235-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit c07ac3ee76e5e5506bca9c03fbbb15e40ab28430 ]

Some powers were changed during the jack insert detection and clk's
enable/disable in CCF.
If in parallel, the influence has a chance to detect the wrong jack
type.

We refer to the below commit of the variant codec (rt5682) to fix
this issue.
  ASoC: rt5682: Fix deadlock on resume

1. Remove rt5682s_headset_detect in rt5682s_jd_check_handler and
   use jack_detect_work instead of.
2. Use dapm mutex used in CCF to protect most of jack_detect_work.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20220223101450.4577-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682s.c | 26 +++++++++-----------------
 sound/soc/codecs/rt5682s.h |  1 -
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index d79b548d23fa..f2a2f3d60925 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -822,6 +822,7 @@ static void rt5682s_jack_detect_handler(struct work_struct *work)
 {
 	struct rt5682s_priv *rt5682s =
 		container_of(work, struct rt5682s_priv, jack_detect_work.work);
+	struct snd_soc_dapm_context *dapm;
 	int val, btn_type;
 
 	if (!rt5682s->component || !rt5682s->component->card ||
@@ -832,7 +833,9 @@ static void rt5682s_jack_detect_handler(struct work_struct *work)
 		return;
 	}
 
-	mutex_lock(&rt5682s->jdet_mutex);
+	dapm = snd_soc_component_get_dapm(rt5682s->component);
+
+	snd_soc_dapm_mutex_lock(dapm);
 	mutex_lock(&rt5682s->calibrate_mutex);
 
 	val = snd_soc_component_read(rt5682s->component, RT5682S_AJD1_CTRL)
@@ -889,6 +892,9 @@ static void rt5682s_jack_detect_handler(struct work_struct *work)
 		rt5682s->irq_work_delay_time = 50;
 	}
 
+	mutex_unlock(&rt5682s->calibrate_mutex);
+	snd_soc_dapm_mutex_unlock(dapm);
+
 	snd_soc_jack_report(rt5682s->hs_jack, rt5682s->jack_type,
 		SND_JACK_HEADSET | SND_JACK_BTN_0 | SND_JACK_BTN_1 |
 		SND_JACK_BTN_2 | SND_JACK_BTN_3);
@@ -898,9 +904,6 @@ static void rt5682s_jack_detect_handler(struct work_struct *work)
 		schedule_delayed_work(&rt5682s->jd_check_work, 0);
 	else
 		cancel_delayed_work_sync(&rt5682s->jd_check_work);
-
-	mutex_unlock(&rt5682s->calibrate_mutex);
-	mutex_unlock(&rt5682s->jdet_mutex);
 }
 
 static void rt5682s_jd_check_handler(struct work_struct *work)
@@ -908,14 +911,9 @@ static void rt5682s_jd_check_handler(struct work_struct *work)
 	struct rt5682s_priv *rt5682s =
 		container_of(work, struct rt5682s_priv, jd_check_work.work);
 
-	if (snd_soc_component_read(rt5682s->component, RT5682S_AJD1_CTRL)
-		& RT5682S_JDH_RS_MASK) {
+	if (snd_soc_component_read(rt5682s->component, RT5682S_AJD1_CTRL) & RT5682S_JDH_RS_MASK) {
 		/* jack out */
-		rt5682s->jack_type = rt5682s_headset_detect(rt5682s->component, 0);
-
-		snd_soc_jack_report(rt5682s->hs_jack, rt5682s->jack_type,
-			SND_JACK_HEADSET | SND_JACK_BTN_0 | SND_JACK_BTN_1 |
-			SND_JACK_BTN_2 | SND_JACK_BTN_3);
+		schedule_delayed_work(&rt5682s->jack_detect_work, 0);
 	} else {
 		schedule_delayed_work(&rt5682s->jd_check_work, 500);
 	}
@@ -1323,7 +1321,6 @@ static int rt5682s_hp_amp_event(struct snd_soc_dapm_widget *w,
 		struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
-	struct rt5682s_priv *rt5682s = snd_soc_component_get_drvdata(component);
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
@@ -1339,8 +1336,6 @@ static int rt5682s_hp_amp_event(struct snd_soc_dapm_widget *w,
 		snd_soc_component_write(component, RT5682S_BIAS_CUR_CTRL_11, 0x6666);
 		snd_soc_component_write(component, RT5682S_BIAS_CUR_CTRL_12, 0xa82a);
 
-		mutex_lock(&rt5682s->jdet_mutex);
-
 		snd_soc_component_update_bits(component, RT5682S_HP_CTRL_2,
 			RT5682S_HPO_L_PATH_MASK | RT5682S_HPO_R_PATH_MASK |
 			RT5682S_HPO_SEL_IP_EN_SW, RT5682S_HPO_L_PATH_EN |
@@ -1348,8 +1343,6 @@ static int rt5682s_hp_amp_event(struct snd_soc_dapm_widget *w,
 		usleep_range(5000, 10000);
 		snd_soc_component_update_bits(component, RT5682S_HP_AMP_DET_CTL_1,
 			RT5682S_CP_SW_SIZE_MASK, RT5682S_CP_SW_SIZE_L | RT5682S_CP_SW_SIZE_S);
-
-		mutex_unlock(&rt5682s->jdet_mutex);
 		break;
 
 	case SND_SOC_DAPM_POST_PMD:
@@ -3075,7 +3068,6 @@ static int rt5682s_i2c_probe(struct i2c_client *i2c,
 
 	mutex_init(&rt5682s->calibrate_mutex);
 	mutex_init(&rt5682s->sar_mutex);
-	mutex_init(&rt5682s->jdet_mutex);
 	rt5682s_calibrate(rt5682s);
 
 	regmap_update_bits(rt5682s->regmap, RT5682S_MICBIAS_2,
diff --git a/sound/soc/codecs/rt5682s.h b/sound/soc/codecs/rt5682s.h
index 1bf2ef7ce578..397a2531b6f6 100644
--- a/sound/soc/codecs/rt5682s.h
+++ b/sound/soc/codecs/rt5682s.h
@@ -1446,7 +1446,6 @@ struct rt5682s_priv {
 	struct delayed_work jd_check_work;
 	struct mutex calibrate_mutex;
 	struct mutex sar_mutex;
-	struct mutex jdet_mutex;
 
 #ifdef CONFIG_COMMON_CLK
 	struct clk_hw dai_clks_hw[RT5682S_DAI_NUM_CLKS];
-- 
2.34.1


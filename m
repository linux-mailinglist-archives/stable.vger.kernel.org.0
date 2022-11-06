Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AF161E3B2
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiKFRE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiKFREQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:04:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E37FAE9;
        Sun,  6 Nov 2022 09:04:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D035FB80B3A;
        Sun,  6 Nov 2022 17:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F47C433C1;
        Sun,  6 Nov 2022 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754248;
        bh=K4+hEwzxI9XhAcJOWo31ZmIXhFSIztFf4SkdZ8kRC0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqsPxUBSG1PCWvndPMa9+/xQ3rFXjd6sglNm8fMtEK9EN94fQGTa3y9baYUjoFviD
         hwcyRmyqsJMjqzgz3pux8qR7L4iyQS5MF7CcWQprnREZj/eWwjzwUDwcZd9V8/TWXB
         PsQETwf9cX3G0QvwrPB4+tWjtHoAN9KrsGJTwSPeD0kxcgu8ow2QSZEGNd3DXShmTa
         n6EDGk43xtWV7V1Ls0maW+tbfoG/agqHTXYtRUbhnNg3dVZQ5FmoHrQmNKuLPURn2y
         UM4IFHY+BAPaz+6NfuViI/0el9IC1R5TqslQ6Q2nPZA70h0QGWTfT3X38/G4obS8fu
         p+zsVXVPeWVqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaolei Wang <xiaolei.wang@windriver.com>,
        Adam Ford <aford173@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, steve@sk2.org,
        chi.minghao@zte.com.cn, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 09/30] ASoC: wm8962: Add an event handler for TEMP_HP and TEMP_SPK
Date:   Sun,  6 Nov 2022 12:03:21 -0500
Message-Id: <20221106170345.1579893-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170345.1579893-1-sashal@kernel.org>
References: <20221106170345.1579893-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit ee1aa2ae3eaa96e70229fa61deee87ef4528ffdf ]

In wm8962 driver, the WM8962_ADDITIONAL_CONTROL_4 is used as a volatile
register, but this register mixes a bunch of volatile status bits and a
bunch of non-volatile control bits. The dapm widgets TEMP_HP and
TEMP_SPK leverages the control bits in this register. After the wm8962
probe, the regmap will bet set to cache only mode, then a read error
like below would be triggered when trying to read the initial power
state of the dapm widgets TEMP_HP and TEMP_SPK.
  wm8962 0-001a: ASoC: error at soc_component_read_no_lock
  on wm8962.0-001a: -16

In order to fix this issue, we add event handler to actually power
up/down these widgets. With this change, we also need to explicitly
power off these widgets in the wm8962 probe since they are enabled
by default.

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Tested-by: Adam Ford <aford173@gmail.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20221010092014.2229246-1-xiaolei.wang@windriver.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 54 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 398c448ea854..6df06fba4377 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1840,6 +1840,49 @@ SOC_SINGLE_TLV("SPKOUTR Mixer DACR Volume", WM8962_SPEAKER_MIXER_5,
 	       4, 1, 0, inmix_tlv),
 };
 
+static int tp_event(struct snd_soc_dapm_widget *w,
+		    struct snd_kcontrol *kcontrol, int event)
+{
+	int ret, reg, val, mask;
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		dev_err(component->dev, "Failed to resume device: %d\n", ret);
+		return ret;
+	}
+
+	reg = WM8962_ADDITIONAL_CONTROL_4;
+
+	if (!strcmp(w->name, "TEMP_HP")) {
+		mask = WM8962_TEMP_ENA_HP_MASK;
+		val = WM8962_TEMP_ENA_HP;
+	} else if (!strcmp(w->name, "TEMP_SPK")) {
+		mask = WM8962_TEMP_ENA_SPK_MASK;
+		val = WM8962_TEMP_ENA_SPK;
+	} else {
+		pm_runtime_put(component->dev);
+		return -EINVAL;
+	}
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMD:
+		val = 0;
+		fallthrough;
+	case SND_SOC_DAPM_POST_PMU:
+		ret = snd_soc_component_update_bits(component, reg, mask, val);
+		break;
+	default:
+		WARN(1, "Invalid event %d\n", event);
+		pm_runtime_put(component->dev);
+		return -EINVAL;
+	}
+
+	pm_runtime_put(component->dev);
+
+	return 0;
+}
+
 static int cp_event(struct snd_soc_dapm_widget *w,
 		    struct snd_kcontrol *kcontrol, int event)
 {
@@ -2140,8 +2183,10 @@ SND_SOC_DAPM_SUPPLY("TOCLK", WM8962_ADDITIONAL_CONTROL_1, 0, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY_S("DSP2", 1, WM8962_DSP2_POWER_MANAGEMENT,
 		      WM8962_DSP2_ENA_SHIFT, 0, dsp2_event,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
-SND_SOC_DAPM_SUPPLY("TEMP_HP", WM8962_ADDITIONAL_CONTROL_4, 2, 0, NULL, 0),
-SND_SOC_DAPM_SUPPLY("TEMP_SPK", WM8962_ADDITIONAL_CONTROL_4, 1, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("TEMP_HP", SND_SOC_NOPM, 0, 0, tp_event,
+		SND_SOC_DAPM_POST_PMU|SND_SOC_DAPM_POST_PMD),
+SND_SOC_DAPM_SUPPLY("TEMP_SPK", SND_SOC_NOPM, 0, 0, tp_event,
+		SND_SOC_DAPM_POST_PMU|SND_SOC_DAPM_POST_PMD),
 
 SND_SOC_DAPM_MIXER("INPGAL", WM8962_LEFT_INPUT_PGA_CONTROL, 4, 0,
 		   inpgal, ARRAY_SIZE(inpgal)),
@@ -3763,6 +3808,11 @@ static int wm8962_i2c_probe(struct i2c_client *i2c)
 	if (ret < 0)
 		goto err_pm_runtime;
 
+	regmap_update_bits(wm8962->regmap, WM8962_ADDITIONAL_CONTROL_4,
+			    WM8962_TEMP_ENA_HP_MASK, 0);
+	regmap_update_bits(wm8962->regmap, WM8962_ADDITIONAL_CONTROL_4,
+			    WM8962_TEMP_ENA_SPK_MASK, 0);
+
 	regcache_cache_only(wm8962->regmap, true);
 
 	/* The drivers should power up as needed */
-- 
2.35.1


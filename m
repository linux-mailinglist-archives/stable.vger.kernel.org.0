Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5177363568B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbiKWJbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiKWJbD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:31:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D8248F1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 112BF61A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C8DC433D6;
        Wed, 23 Nov 2022 09:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195790;
        bh=blrU5POMMjcvR24QCC3s33yEJDcl1a7y+lUMpzpd9MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGr86XLMAKeUbuRJTsPXVFA3gUcARsoup4Ky+qjphh8y1c9YSUrrpUsbQk0DfbxTx
         S9uW4d6Qo374wFeihfZWxJT3dbg/bkeHc7fL7jIni3MtDAMXxKX2CQzcFTftbaGgwr
         p1YE2GcqCDTqf73cxGbTyuaMGYJmbqlcUM6xzf7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaolei Wang <xiaolei.wang@windriver.com>,
        Adam Ford <aford173@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/181] ASoC: wm8962: Add an event handler for TEMP_HP and TEMP_SPK
Date:   Wed, 23 Nov 2022 09:49:32 +0100
Message-Id: <20221123084603.022961021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index a5a4ae4440cc..09a73b854964 100644
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
@@ -2133,8 +2176,10 @@ SND_SOC_DAPM_SUPPLY("TOCLK", WM8962_ADDITIONAL_CONTROL_1, 0, 0, NULL, 0),
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
@@ -3763,6 +3808,11 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
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




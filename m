Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3231156FD16
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiGKJuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiGKJtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7923B23BE1;
        Mon, 11 Jul 2022 02:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 071F161137;
        Mon, 11 Jul 2022 09:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD7CC34115;
        Mon, 11 Jul 2022 09:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531463;
        bh=VaAKUmeoSHCUKx+/wcTdAV8VPn+5DYvP1BM4UbaOHhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckKnu7wl2jTD/+Lgwh5I4uMWfFaCkYikyvORxl4GoVZ1h4RxmCn4zw0X8QDAfM79e
         Btx4q4t8zhtAHWYNDK3dATGAX3TfA4TDAIBvNxCn10LqBItcgoaVFF7p38UnnSaV9h
         b1ImNiaKWDUh5Wj8CIV1DBHbxymQC6qbZgtlCzZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Yu <jack.yu@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/230] ASoC: rt5682: move clk related code to rt5682_i2c_probe
Date:   Mon, 11 Jul 2022 11:06:10 +0200
Message-Id: <20220711090607.300417959@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 57589f82762e40bdaa975d840fa2bc5157b5be95 ]

The DAI clock is only used in I2S mode, to make it clear
and to fix clock resource release issue, we move CCF clock
related code to rt5682_i2c_probe to fix clock
register/unregister issue.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/20210929054344.12112-1-jack.yu@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c | 22 +++++++++++
 sound/soc/codecs/rt5682.c     | 70 +++++++++++++----------------------
 sound/soc/codecs/rt5682.h     |  3 ++
 3 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index 74a1fee071dd..3d2d7c9ce66d 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -133,6 +133,8 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, rt5682);
 
+	rt5682->i2c_dev = &i2c->dev;
+
 	rt5682->pdata = i2s_default_platform_data;
 
 	if (pdata)
@@ -270,6 +272,26 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 			dev_err(&i2c->dev, "Failed to reguest IRQ: %d\n", ret);
 	}
 
+#ifdef CONFIG_COMMON_CLK
+	/* Check if MCLK provided */
+	rt5682->mclk = devm_clk_get(&i2c->dev, "mclk");
+	if (IS_ERR(rt5682->mclk)) {
+		if (PTR_ERR(rt5682->mclk) != -ENOENT) {
+			ret = PTR_ERR(rt5682->mclk);
+			return ret;
+		}
+		rt5682->mclk = NULL;
+	}
+
+	/* Register CCF DAI clock control */
+	ret = rt5682_register_dai_clks(rt5682);
+	if (ret)
+		return ret;
+
+	/* Initial setup for CCF */
+	rt5682->lrck[RT5682_AIF1] = 48000;
+#endif
+
 	return devm_snd_soc_register_component(&i2c->dev,
 					       &rt5682_soc_component_dev,
 					       rt5682_dai, ARRAY_SIZE(rt5682_dai));
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 1cd59e166cce..80d199843b8c 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -2562,7 +2562,7 @@ static int rt5682_set_bias_level(struct snd_soc_component *component,
 static bool rt5682_clk_check(struct rt5682_priv *rt5682)
 {
 	if (!rt5682->master[RT5682_AIF1]) {
-		dev_dbg(rt5682->component->dev, "sysclk/dai not set correctly\n");
+		dev_dbg(rt5682->i2c_dev, "sysclk/dai not set correctly\n");
 		return false;
 	}
 	return true;
@@ -2573,13 +2573,15 @@ static int rt5682_wclk_prepare(struct clk_hw *hw)
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
-	struct snd_soc_dapm_context *dapm =
-			snd_soc_component_get_dapm(component);
+	struct snd_soc_component *component;
+	struct snd_soc_dapm_context *dapm;
 
 	if (!rt5682_clk_check(rt5682))
 		return -EINVAL;
 
+	component = rt5682->component;
+	dapm = snd_soc_component_get_dapm(component);
+
 	snd_soc_dapm_mutex_lock(dapm);
 
 	snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS");
@@ -2609,13 +2611,15 @@ static void rt5682_wclk_unprepare(struct clk_hw *hw)
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
-	struct snd_soc_dapm_context *dapm =
-			snd_soc_component_get_dapm(component);
+	struct snd_soc_component *component;
+	struct snd_soc_dapm_context *dapm;
 
 	if (!rt5682_clk_check(rt5682))
 		return;
 
+	component = rt5682->component;
+	dapm = snd_soc_component_get_dapm(component);
+
 	snd_soc_dapm_mutex_lock(dapm);
 
 	snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS");
@@ -2639,7 +2643,6 @@ static unsigned long rt5682_wclk_recalc_rate(struct clk_hw *hw,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
 	const char * const clk_name = clk_hw_get_name(hw);
 
 	if (!rt5682_clk_check(rt5682))
@@ -2649,7 +2652,7 @@ static unsigned long rt5682_wclk_recalc_rate(struct clk_hw *hw,
 	 */
 	if (rt5682->lrck[RT5682_AIF1] != CLK_48 &&
 	    rt5682->lrck[RT5682_AIF1] != CLK_44) {
-		dev_warn(component->dev, "%s: clk %s only support %d or %d Hz output\n",
+		dev_warn(rt5682->i2c_dev, "%s: clk %s only support %d or %d Hz output\n",
 			__func__, clk_name, CLK_44, CLK_48);
 		return 0;
 	}
@@ -2663,7 +2666,6 @@ static long rt5682_wclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
 	const char * const clk_name = clk_hw_get_name(hw);
 
 	if (!rt5682_clk_check(rt5682))
@@ -2673,7 +2675,7 @@ static long rt5682_wclk_round_rate(struct clk_hw *hw, unsigned long rate,
 	 * It will force to 48kHz if not both.
 	 */
 	if (rate != CLK_48 && rate != CLK_44) {
-		dev_warn(component->dev, "%s: clk %s only support %d or %d Hz output\n",
+		dev_warn(rt5682->i2c_dev, "%s: clk %s only support %d or %d Hz output\n",
 			__func__, clk_name, CLK_44, CLK_48);
 		rate = CLK_48;
 	}
@@ -2687,7 +2689,7 @@ static int rt5682_wclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_WCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
+	struct snd_soc_component *component;
 	struct clk_hw *parent_hw;
 	const char * const clk_name = clk_hw_get_name(hw);
 	int pre_div;
@@ -2696,6 +2698,8 @@ static int rt5682_wclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (!rt5682_clk_check(rt5682))
 		return -EINVAL;
 
+	component = rt5682->component;
+
 	/*
 	 * Whether the wclk's parent clk (mclk) exists or not, please ensure
 	 * it is fixed or set to 48MHz before setting wclk rate. It's a
@@ -2705,12 +2709,12 @@ static int rt5682_wclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	 */
 	parent_hw = clk_hw_get_parent(hw);
 	if (!parent_hw)
-		dev_warn(component->dev,
+		dev_warn(rt5682->i2c_dev,
 			"Parent mclk of wclk not acquired in driver. Please ensure mclk was provided as %d Hz.\n",
 			CLK_PLL2_FIN);
 
 	if (parent_rate != CLK_PLL2_FIN)
-		dev_warn(component->dev, "clk %s only support %d Hz input\n",
+		dev_warn(rt5682->i2c_dev, "clk %s only support %d Hz input\n",
 			clk_name, CLK_PLL2_FIN);
 
 	/*
@@ -2742,10 +2746,9 @@ static unsigned long rt5682_bclk_recalc_rate(struct clk_hw *hw,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_BCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
 	unsigned int bclks_per_wclk;
 
-	bclks_per_wclk = snd_soc_component_read(component, RT5682_TDM_TCON_CTRL);
+	regmap_read(rt5682->regmap, RT5682_TDM_TCON_CTRL, &bclks_per_wclk);
 
 	switch (bclks_per_wclk & RT5682_TDM_BCLK_MS1_MASK) {
 	case RT5682_TDM_BCLK_MS1_256:
@@ -2806,20 +2809,22 @@ static int rt5682_bclk_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct rt5682_priv *rt5682 =
 		container_of(hw, struct rt5682_priv,
 			     dai_clks_hw[RT5682_DAI_BCLK_IDX]);
-	struct snd_soc_component *component = rt5682->component;
+	struct snd_soc_component *component;
 	struct snd_soc_dai *dai;
 	unsigned long factor;
 
 	if (!rt5682_clk_check(rt5682))
 		return -EINVAL;
 
+	component = rt5682->component;
+
 	factor = rt5682_bclk_get_factor(rate, parent_rate);
 
 	for_each_component_dais(component, dai)
 		if (dai->id == RT5682_AIF1)
 			break;
 	if (!dai) {
-		dev_err(component->dev, "dai %d not found in component\n",
+		dev_err(rt5682->i2c_dev, "dai %d not found in component\n",
 			RT5682_AIF1);
 		return -ENODEV;
 	}
@@ -2842,10 +2847,9 @@ static const struct clk_ops rt5682_dai_clk_ops[RT5682_DAI_NUM_CLKS] = {
 	},
 };
 
-static int rt5682_register_dai_clks(struct snd_soc_component *component)
+int rt5682_register_dai_clks(struct rt5682_priv *rt5682)
 {
-	struct device *dev = component->dev;
-	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
+	struct device *dev = rt5682->i2c_dev;
 	struct rt5682_platform_data *pdata = &rt5682->pdata;
 	struct clk_hw *dai_clk_hw;
 	int i, ret;
@@ -2905,6 +2909,7 @@ static int rt5682_register_dai_clks(struct snd_soc_component *component)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rt5682_register_dai_clks);
 #endif /* CONFIG_COMMON_CLK */
 
 static int rt5682_probe(struct snd_soc_component *component)
@@ -2914,9 +2919,6 @@ static int rt5682_probe(struct snd_soc_component *component)
 	unsigned long time;
 	struct snd_soc_dapm_context *dapm = &component->dapm;
 
-#ifdef CONFIG_COMMON_CLK
-	int ret;
-#endif
 	rt5682->component = component;
 
 	if (rt5682->is_sdw) {
@@ -2928,26 +2930,6 @@ static int rt5682_probe(struct snd_soc_component *component)
 			dev_err(&slave->dev, "Initialization not complete, timed out\n");
 			return -ETIMEDOUT;
 		}
-	} else {
-#ifdef CONFIG_COMMON_CLK
-		/* Check if MCLK provided */
-		rt5682->mclk = devm_clk_get(component->dev, "mclk");
-		if (IS_ERR(rt5682->mclk)) {
-			if (PTR_ERR(rt5682->mclk) != -ENOENT) {
-				ret = PTR_ERR(rt5682->mclk);
-				return ret;
-			}
-			rt5682->mclk = NULL;
-		}
-
-		/* Register CCF DAI clock control */
-		ret = rt5682_register_dai_clks(component);
-		if (ret)
-			return ret;
-
-		/* Initial setup for CCF */
-		rt5682->lrck[RT5682_AIF1] = CLK_48;
-#endif
 	}
 
 	snd_soc_dapm_disable_pin(dapm, "MICBIAS");
diff --git a/sound/soc/codecs/rt5682.h b/sound/soc/codecs/rt5682.h
index 539a9fe26294..52ff0d9c36c5 100644
--- a/sound/soc/codecs/rt5682.h
+++ b/sound/soc/codecs/rt5682.h
@@ -1428,6 +1428,7 @@ enum {
 
 struct rt5682_priv {
 	struct snd_soc_component *component;
+	struct device *i2c_dev;
 	struct rt5682_platform_data pdata;
 	struct regmap *regmap;
 	struct regmap *sdw_regmap;
@@ -1481,6 +1482,8 @@ void rt5682_calibrate(struct rt5682_priv *rt5682);
 void rt5682_reset(struct rt5682_priv *rt5682);
 int rt5682_parse_dt(struct rt5682_priv *rt5682, struct device *dev);
 
+int rt5682_register_dai_clks(struct rt5682_priv *rt5682);
+
 #define RT5682_REG_NUM 318
 extern const struct reg_default rt5682_reg[RT5682_REG_NUM];
 
-- 
2.35.1




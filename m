Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB586AF409
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbjCGTMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbjCGTMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:12:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119C5900A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:56:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B85B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83966C433D2;
        Tue,  7 Mar 2023 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215361;
        bh=4PMyTuzIYICgIj68GbNEHDKsbujsFs++q9QNGjwI8Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x12EKk9HVRHWiuuaHj7i80uvnh4UgJS3bLlFO/mtg0y99JvmhhaVng3i2AT8ZNu3g
         GzCBBeEMbAR+Fr3a5/0bjh9/UUi6Lqrg+D/YBSBPEuKmdE82egwJL1PAAEfgxY1MlE
         t/6UhN6Ss4Nwh9e2r8I0QqokOaW4hzyVJMDwsvjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/567] ASoC: codecs: rx-macro: move to individual clks from bulk
Date:   Tue,  7 Mar 2023 17:59:33 +0100
Message-Id: <20230307165916.225157041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 43b647d9940454263421f9a1c756680bdf1d443c ]

Using bulk clocks and referencing them individually using array index is
not great for readers.
So move them to individual clocks handling and also remove some unnecessary
error handling in the code.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220224111718.6264-5-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e7621434378c ("ASoC: codecs: lpass: fix incorrect mclk rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 85 +++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 21 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index f3e5755a49a1d..213ededb6f9ee 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -608,7 +608,11 @@ struct rx_macro {
 	int softclip_clk_users;
 
 	struct regmap *regmap;
-	struct clk_bulk_data clks[RX_NUM_CLKS_MAX];
+	struct clk *mclk;
+	struct clk *npl;
+	struct clk *macro;
+	struct clk *dcodec;
+	struct clk *fsgen;
 	struct clk_hw hw;
 };
 #define to_rx_macro(_hw) container_of(_hw, struct rx_macro, hw)
@@ -3488,7 +3492,7 @@ static int rx_macro_register_mclk_output(struct rx_macro *rx)
 	struct clk_init_data init;
 	int ret;
 
-	parent_clk_name = __clk_get_name(rx->clks[2].clk);
+	parent_clk_name = __clk_get_name(rx->mclk);
 
 	init.name = clk_name;
 	init.ops = &swclk_gate_ops;
@@ -3526,17 +3530,25 @@ static int rx_macro_probe(struct platform_device *pdev)
 	if (!rx)
 		return -ENOMEM;
 
-	rx->clks[0].id = "macro";
-	rx->clks[1].id = "dcodec";
-	rx->clks[2].id = "mclk";
-	rx->clks[3].id = "npl";
-	rx->clks[4].id = "fsgen";
+	rx->macro = devm_clk_get_optional(dev, "macro");
+	if (IS_ERR(rx->macro))
+		return PTR_ERR(rx->macro);
 
-	ret = devm_clk_bulk_get_optional(dev, RX_NUM_CLKS_MAX, rx->clks);
-	if (ret) {
-		dev_err(dev, "Error getting RX Clocks (%d)\n", ret);
-		return ret;
-	}
+	rx->dcodec = devm_clk_get_optional(dev, "dcodec");
+	if (IS_ERR(rx->dcodec))
+		return PTR_ERR(rx->dcodec);
+
+	rx->mclk = devm_clk_get(dev, "mclk");
+	if (IS_ERR(rx->mclk))
+		return PTR_ERR(rx->mclk);
+
+	rx->npl = devm_clk_get(dev, "npl");
+	if (IS_ERR(rx->npl))
+		return PTR_ERR(rx->npl);
+
+	rx->fsgen = devm_clk_get(dev, "fsgen");
+	if (IS_ERR(rx->fsgen))
+		return PTR_ERR(rx->fsgen);
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
@@ -3552,26 +3564,52 @@ static int rx_macro_probe(struct platform_device *pdev)
 	rx->dev = dev;
 
 	/* set MCLK and NPL rates */
-	clk_set_rate(rx->clks[2].clk, MCLK_FREQ);
-	clk_set_rate(rx->clks[3].clk, 2 * MCLK_FREQ);
+	clk_set_rate(rx->mclk, MCLK_FREQ);
+	clk_set_rate(rx->npl, 2 * MCLK_FREQ);
 
-	ret = clk_bulk_prepare_enable(RX_NUM_CLKS_MAX, rx->clks);
+	ret = clk_prepare_enable(rx->macro);
 	if (ret)
-		return ret;
+		goto err;
+
+	ret = clk_prepare_enable(rx->dcodec);
+	if (ret)
+		goto err_dcodec;
+
+	ret = clk_prepare_enable(rx->mclk);
+	if (ret)
+		goto err_mclk;
+
+	ret = clk_prepare_enable(rx->npl);
+	if (ret)
+		goto err_npl;
+
+	ret = clk_prepare_enable(rx->fsgen);
+	if (ret)
+		goto err_fsgen;
 
 	ret = rx_macro_register_mclk_output(rx);
 	if (ret)
-		goto err;
+		goto err_clkout;
 
 	ret = devm_snd_soc_register_component(dev, &rx_macro_component_drv,
 					      rx_macro_dai,
 					      ARRAY_SIZE(rx_macro_dai));
 	if (ret)
-		goto err;
+		goto err_clkout;
 
-	return ret;
+	return 0;
+
+err_clkout:
+	clk_disable_unprepare(rx->fsgen);
+err_fsgen:
+	clk_disable_unprepare(rx->npl);
+err_npl:
+	clk_disable_unprepare(rx->mclk);
+err_mclk:
+	clk_disable_unprepare(rx->dcodec);
+err_dcodec:
+	clk_disable_unprepare(rx->macro);
 err:
-	clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
 	return ret;
 }
 
@@ -3579,7 +3617,12 @@ static int rx_macro_remove(struct platform_device *pdev)
 {
 	struct rx_macro *rx = dev_get_drvdata(&pdev->dev);
 
-	clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
+	clk_disable_unprepare(rx->mclk);
+	clk_disable_unprepare(rx->npl);
+	clk_disable_unprepare(rx->fsgen);
+	clk_disable_unprepare(rx->macro);
+	clk_disable_unprepare(rx->dcodec);
+
 	return 0;
 }
 
-- 
2.39.2




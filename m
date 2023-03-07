Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7EB6AF400
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbjCGTM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjCGTMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:12:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92984A882F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FEEF61553
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41FFC433EF;
        Tue,  7 Mar 2023 18:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215365;
        bh=LImIl3zyKD0x0wY7/1BUJUsqUFMplrr2YtR30A43KPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvUz7WYRGgiLHfHIxJClKxxfNRauAVFj+grm6OZaIfu972xerfLNHGEYrylji7019
         hVpvokQPLr5YA1gnsCYdxun/YsZKNaDD79np4OpWIrkyj2XhjjeEaVXYp6Jb3ehNRT
         gZu8K/P5EqZ0hYK90oSW1VdmLEkz0BLJXQ0aEOb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/567] ASoC: codecs: tx-macro: move to individual clks from bulk
Date:   Tue,  7 Mar 2023 17:59:34 +0100
Message-Id: <20230307165916.275648386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 512864c4ffa70522b9c44d5b40c15273330ae9c7 ]

Using bulk clocks and referencing them individually using array index is
not great for readers.
So move them to individual clocks handling and also remove some unnecessary
error handling in the code.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220224111718.6264-6-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e7621434378c ("ASoC: codecs: lpass: fix incorrect mclk rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 87 +++++++++++++++++++++++--------
 1 file changed, 65 insertions(+), 22 deletions(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 4192f91612e16..d604e2b0109b0 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -6,6 +6,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
@@ -258,7 +259,11 @@ struct tx_macro {
 	unsigned long active_ch_cnt[TX_MACRO_MAX_DAIS];
 	unsigned long active_decimator[TX_MACRO_MAX_DAIS];
 	struct regmap *regmap;
-	struct clk_bulk_data clks[TX_NUM_CLKS_MAX];
+	struct clk *mclk;
+	struct clk *npl;
+	struct clk *macro;
+	struct clk *dcodec;
+	struct clk *fsgen;
 	struct clk_hw hw;
 	bool dec_active[NUM_DECIMATORS];
 	bool reset_swr;
@@ -1754,7 +1759,7 @@ static int tx_macro_register_mclk_output(struct tx_macro *tx)
 	struct clk_init_data init;
 	int ret;
 
-	parent_clk_name = __clk_get_name(tx->clks[2].clk);
+	parent_clk_name = __clk_get_name(tx->mclk);
 
 	init.name = clk_name;
 	init.ops = &swclk_gate_ops;
@@ -1792,17 +1797,25 @@ static int tx_macro_probe(struct platform_device *pdev)
 	if (!tx)
 		return -ENOMEM;
 
-	tx->clks[0].id = "macro";
-	tx->clks[1].id = "dcodec";
-	tx->clks[2].id = "mclk";
-	tx->clks[3].id = "npl";
-	tx->clks[4].id = "fsgen";
+	tx->macro = devm_clk_get_optional(dev, "macro");
+	if (IS_ERR(tx->macro))
+		return PTR_ERR(tx->macro);
 
-	ret = devm_clk_bulk_get_optional(dev, TX_NUM_CLKS_MAX, tx->clks);
-	if (ret) {
-		dev_err(dev, "Error getting RX Clocks (%d)\n", ret);
-		return ret;
-	}
+	tx->dcodec = devm_clk_get_optional(dev, "dcodec");
+	if (IS_ERR(tx->dcodec))
+		return PTR_ERR(tx->dcodec);
+
+	tx->mclk = devm_clk_get(dev, "mclk");
+	if (IS_ERR(tx->mclk))
+		return PTR_ERR(tx->mclk);
+
+	tx->npl = devm_clk_get(dev, "npl");
+	if (IS_ERR(tx->npl))
+		return PTR_ERR(tx->npl);
+
+	tx->fsgen = devm_clk_get(dev, "fsgen");
+	if (IS_ERR(tx->fsgen))
+		return PTR_ERR(tx->fsgen);
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
@@ -1818,26 +1831,52 @@ static int tx_macro_probe(struct platform_device *pdev)
 	tx->dev = dev;
 
 	/* set MCLK and NPL rates */
-	clk_set_rate(tx->clks[2].clk, MCLK_FREQ);
-	clk_set_rate(tx->clks[3].clk, 2 * MCLK_FREQ);
+	clk_set_rate(tx->mclk, MCLK_FREQ);
+	clk_set_rate(tx->npl, 2 * MCLK_FREQ);
 
-	ret = clk_bulk_prepare_enable(TX_NUM_CLKS_MAX, tx->clks);
+	ret = clk_prepare_enable(tx->macro);
 	if (ret)
-		return ret;
+		goto err;
+
+	ret = clk_prepare_enable(tx->dcodec);
+	if (ret)
+		goto err_dcodec;
+
+	ret = clk_prepare_enable(tx->mclk);
+	if (ret)
+		goto err_mclk;
+
+	ret = clk_prepare_enable(tx->npl);
+	if (ret)
+		goto err_npl;
+
+	ret = clk_prepare_enable(tx->fsgen);
+	if (ret)
+		goto err_fsgen;
 
 	ret = tx_macro_register_mclk_output(tx);
 	if (ret)
-		goto err;
+		goto err_clkout;
 
 	ret = devm_snd_soc_register_component(dev, &tx_macro_component_drv,
 					      tx_macro_dai,
 					      ARRAY_SIZE(tx_macro_dai));
 	if (ret)
-		goto err;
-	return ret;
-err:
-	clk_bulk_disable_unprepare(TX_NUM_CLKS_MAX, tx->clks);
+		goto err_clkout;
 
+	return 0;
+
+err_clkout:
+	clk_disable_unprepare(tx->fsgen);
+err_fsgen:
+	clk_disable_unprepare(tx->npl);
+err_npl:
+	clk_disable_unprepare(tx->mclk);
+err_mclk:
+	clk_disable_unprepare(tx->dcodec);
+err_dcodec:
+	clk_disable_unprepare(tx->macro);
+err:
 	return ret;
 }
 
@@ -1845,7 +1884,11 @@ static int tx_macro_remove(struct platform_device *pdev)
 {
 	struct tx_macro *tx = dev_get_drvdata(&pdev->dev);
 
-	clk_bulk_disable_unprepare(TX_NUM_CLKS_MAX, tx->clks);
+	clk_disable_unprepare(tx->macro);
+	clk_disable_unprepare(tx->dcodec);
+	clk_disable_unprepare(tx->mclk);
+	clk_disable_unprepare(tx->npl);
+	clk_disable_unprepare(tx->fsgen);
 
 	return 0;
 }
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B5763DE03
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiK3Sc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiK3Scy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC401DA79
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A8961AFE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF93BC433D6;
        Wed, 30 Nov 2022 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833161;
        bh=Pb/05drjHF2erpe8ZDphKF0/ymbdUpeM/gxeTxwf3pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KIo8lK6ew/bhe5OtsgNRUGZKXL3uRmmv7uj5tDEN+928FFAI0bSZBBPvUT6jWf9i
         p+6qIzMiNmBez4/KGJeYL4P/dV/Brzx64sjPVGFWwgHPGYgw3xfO+vDrMegBfMSs1w
         W2Npww7YzBrAzS6+6Ln/z6Rhe2Brg4G6fkWPFCh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marco Felsch <m.felsch@pengutronix.de>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/206] ASoC: fsl_sai: use local device pointer
Date:   Wed, 30 Nov 2022 19:20:53 +0100
Message-Id: <20221130180533.015509317@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit f53f50ee21d46094a8c48970e95e38a4deaa128e ]

Use a local variable to dereference the device pointer once and use the
local variable in further calls. No functional changes.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://lore.kernel.org/r/20220601092342.3328644-1-m.felsch@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6a564338a23c ("ASoC: fsl_asrc fsl_esai fsl_sai: allow CONFIG_PM=N")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 53 +++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 38f6362099d5..bcf6b66a5ac0 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1000,6 +1000,7 @@ static int fsl_sai_runtime_resume(struct device *dev);
 static int fsl_sai_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
 	struct fsl_sai *sai;
 	struct regmap *gpr;
 	struct resource *res;
@@ -1008,12 +1009,12 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	int irq, ret, i;
 	int index;
 
-	sai = devm_kzalloc(&pdev->dev, sizeof(*sai), GFP_KERNEL);
+	sai = devm_kzalloc(dev, sizeof(*sai), GFP_KERNEL);
 	if (!sai)
 		return -ENOMEM;
 
 	sai->pdev = pdev;
-	sai->soc_data = of_device_get_match_data(&pdev->dev);
+	sai->soc_data = of_device_get_match_data(dev);
 
 	sai->is_lsb_first = of_property_read_bool(np, "lsb-first");
 
@@ -1028,18 +1029,18 @@ static int fsl_sai_probe(struct platform_device *pdev)
 			ARRAY_SIZE(fsl_sai_reg_defaults_ofs8);
 	}
 
-	sai->regmap = devm_regmap_init_mmio(&pdev->dev, base, &fsl_sai_regmap_config);
+	sai->regmap = devm_regmap_init_mmio(dev, base, &fsl_sai_regmap_config);
 	if (IS_ERR(sai->regmap)) {
-		dev_err(&pdev->dev, "regmap init failed\n");
+		dev_err(dev, "regmap init failed\n");
 		return PTR_ERR(sai->regmap);
 	}
 
-	sai->bus_clk = devm_clk_get(&pdev->dev, "bus");
+	sai->bus_clk = devm_clk_get(dev, "bus");
 	/* Compatible with old DTB cases */
 	if (IS_ERR(sai->bus_clk) && PTR_ERR(sai->bus_clk) != -EPROBE_DEFER)
-		sai->bus_clk = devm_clk_get(&pdev->dev, "sai");
+		sai->bus_clk = devm_clk_get(dev, "sai");
 	if (IS_ERR(sai->bus_clk)) {
-		dev_err(&pdev->dev, "failed to get bus clock: %ld\n",
+		dev_err(dev, "failed to get bus clock: %ld\n",
 				PTR_ERR(sai->bus_clk));
 		/* -EPROBE_DEFER */
 		return PTR_ERR(sai->bus_clk);
@@ -1047,9 +1048,9 @@ static int fsl_sai_probe(struct platform_device *pdev)
 
 	for (i = 1; i < FSL_SAI_MCLK_MAX; i++) {
 		sprintf(tmp, "mclk%d", i);
-		sai->mclk_clk[i] = devm_clk_get(&pdev->dev, tmp);
+		sai->mclk_clk[i] = devm_clk_get(dev, tmp);
 		if (IS_ERR(sai->mclk_clk[i])) {
-			dev_err(&pdev->dev, "failed to get mclk%d clock: %ld\n",
+			dev_err(dev, "failed to get mclk%d clock: %ld\n",
 					i + 1, PTR_ERR(sai->mclk_clk[i]));
 			sai->mclk_clk[i] = NULL;
 		}
@@ -1064,10 +1065,10 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_irq(&pdev->dev, irq, fsl_sai_isr, IRQF_SHARED,
+	ret = devm_request_irq(dev, irq, fsl_sai_isr, IRQF_SHARED,
 			       np->name, sai);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to claim irq %u\n", irq);
+		dev_err(dev, "failed to claim irq %u\n", irq);
 		return ret;
 	}
 
@@ -1084,7 +1085,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (of_find_property(np, "fsl,sai-synchronous-rx", NULL) &&
 	    of_find_property(np, "fsl,sai-asynchronous", NULL)) {
 		/* error out if both synchronous and asynchronous are present */
-		dev_err(&pdev->dev, "invalid binding for synchronous mode\n");
+		dev_err(dev, "invalid binding for synchronous mode\n");
 		return -EINVAL;
 	}
 
@@ -1105,7 +1106,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	    of_device_is_compatible(np, "fsl,imx6ul-sai")) {
 		gpr = syscon_regmap_lookup_by_compatible("fsl,imx6ul-iomuxc-gpr");
 		if (IS_ERR(gpr)) {
-			dev_err(&pdev->dev, "cannot find iomuxc registers\n");
+			dev_err(dev, "cannot find iomuxc registers\n");
 			return PTR_ERR(gpr);
 		}
 
@@ -1123,23 +1124,23 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	sai->dma_params_tx.maxburst = FSL_SAI_MAXBURST_TX;
 
 	platform_set_drvdata(pdev, sai);
-	pm_runtime_enable(&pdev->dev);
-	if (!pm_runtime_enabled(&pdev->dev)) {
-		ret = fsl_sai_runtime_resume(&pdev->dev);
+	pm_runtime_enable(dev);
+	if (!pm_runtime_enabled(dev)) {
+		ret = fsl_sai_runtime_resume(dev);
 		if (ret)
 			goto err_pm_disable;
 	}
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
-		pm_runtime_put_noidle(&pdev->dev);
+		pm_runtime_put_noidle(dev);
 		goto err_pm_get_sync;
 	}
 
 	/* Get sai version */
-	ret = fsl_sai_check_version(&pdev->dev);
+	ret = fsl_sai_check_version(dev);
 	if (ret < 0)
-		dev_warn(&pdev->dev, "Error reading SAI version: %d\n", ret);
+		dev_warn(dev, "Error reading SAI version: %d\n", ret);
 
 	/* Select MCLK direction */
 	if (of_find_property(np, "fsl,sai-mclk-direction-output", NULL) &&
@@ -1148,7 +1149,7 @@ static int fsl_sai_probe(struct platform_device *pdev)
 				   FSL_SAI_MCTL_MCLK_EN, FSL_SAI_MCTL_MCLK_EN);
 	}
 
-	ret = pm_runtime_put_sync(&pdev->dev);
+	ret = pm_runtime_put_sync(dev);
 	if (ret < 0)
 		goto err_pm_get_sync;
 
@@ -1161,12 +1162,12 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		if (ret)
 			goto err_pm_get_sync;
 	} else {
-		ret = devm_snd_dmaengine_pcm_register(&pdev->dev, NULL, 0);
+		ret = devm_snd_dmaengine_pcm_register(dev, NULL, 0);
 		if (ret)
 			goto err_pm_get_sync;
 	}
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &fsl_component,
+	ret = devm_snd_soc_register_component(dev, &fsl_component,
 					      &sai->cpu_dai_drv, 1);
 	if (ret)
 		goto err_pm_get_sync;
@@ -1174,10 +1175,10 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	return ret;
 
 err_pm_get_sync:
-	if (!pm_runtime_status_suspended(&pdev->dev))
-		fsl_sai_runtime_suspend(&pdev->dev);
+	if (!pm_runtime_status_suspended(dev))
+		fsl_sai_runtime_suspend(dev);
 err_pm_disable:
-	pm_runtime_disable(&pdev->dev);
+	pm_runtime_disable(dev);
 
 	return ret;
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139AF6AEA7A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjCGReT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjCGReG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0083A1884
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D464614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728F9C433D2;
        Tue,  7 Mar 2023 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210176;
        bh=BTM/18aUdxDLfWwmZakr41SnKfVD/IJ4AFPXF8ioH8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pt09fTv04hZhaAxhJl7nHqM2DmamrGrsT7xIUifoNAmB5wQCgM7CsUuWSL9ozdCtc
         V9jO4twxO8v+DrZIa1UVh2jxaDXfv26SWg6ZtNCXYcjhWzfGyZH8SFV1EqDroRSGC7
         9aKRiSsxDCksfjhpodGW6OKLhVCYOJ2+4BPN2gDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0427/1001] ASoC: codecs: lpass: register mclk after runtime pm
Date:   Tue,  7 Mar 2023 17:53:19 +0100
Message-Id: <20230307170039.878217445@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 1dc3459009c33e335f0d62b84dd39a6bbd7fd5d2 ]

move mclk out registration after runtime pm is enabled so that the
clk framework can resume the codec if it requires to enable the mclk out.

Fixes: c96baa2949b2 ("ASoC: codecs: wsa-macro: add runtime pm support")
Fixes: 72ad25eabda0 ("ASoC: codecs: va-macro: add runtime pm support")
Fixes: 366ff79ed539 ("ASoC: codecs: rx-macro: add runtime pm support")
Fixes: 1fb83bc5cf64 ("ASoC: codecs: tx-macro: add runtime pm support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-6-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c  |  8 ++++----
 sound/soc/codecs/lpass-tx-macro.c  |  8 ++++----
 sound/soc/codecs/lpass-va-macro.c  | 20 ++++++++++----------
 sound/soc/codecs/lpass-wsa-macro.c |  9 ++++-----
 4 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index a9ef9d5ffcc5c..dd6970d5eb8d1 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3601,10 +3601,6 @@ static int rx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_fsgen;
 
-	ret = rx_macro_register_mclk_output(rx);
-	if (ret)
-		goto err_clkout;
-
 	ret = devm_snd_soc_register_component(dev, &rx_macro_component_drv,
 					      rx_macro_dai,
 					      ARRAY_SIZE(rx_macro_dai));
@@ -3618,6 +3614,10 @@ static int rx_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+	ret = rx_macro_register_mclk_output(rx);
+	if (ret)
+		goto err_clkout;
+
 	return 0;
 
 err_clkout:
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 2ef62d6edc302..b9475ba55e203 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -2036,10 +2036,6 @@ static int tx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_fsgen;
 
-	ret = tx_macro_register_mclk_output(tx);
-	if (ret)
-		goto err_clkout;
-
 	ret = devm_snd_soc_register_component(dev, &tx_macro_component_drv,
 					      tx_macro_dai,
 					      ARRAY_SIZE(tx_macro_dai));
@@ -2052,6 +2048,10 @@ static int tx_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+	ret = tx_macro_register_mclk_output(tx);
+	if (ret)
+		goto err_clkout;
+
 	return 0;
 
 err_clkout:
diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index b0b6cf29cba30..1623ba78ddb3d 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1524,16 +1524,6 @@ static int va_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_mclk;
 
-	ret = va_macro_register_fsgen_output(va);
-	if (ret)
-		goto err_clkout;
-
-	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
-	if (IS_ERR(va->fsgen)) {
-		ret = PTR_ERR(va->fsgen);
-		goto err_clkout;
-	}
-
 	if (va->has_swr_master) {
 		/* Set default CLK div to 1 */
 		regmap_update_bits(va->regmap, CDC_VA_TOP_CSR_SWR_MIC_CTL0,
@@ -1560,6 +1550,16 @@ static int va_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+	ret = va_macro_register_fsgen_output(va);
+	if (ret)
+		goto err_clkout;
+
+	va->fsgen = clk_hw_get_clk(&va->hw, "fsgen");
+	if (IS_ERR(va->fsgen)) {
+		ret = PTR_ERR(va->fsgen);
+		goto err_clkout;
+	}
+
 	return 0;
 
 err_clkout:
diff --git a/sound/soc/codecs/lpass-wsa-macro.c b/sound/soc/codecs/lpass-wsa-macro.c
index 5cfe96f6e430e..c0b86d69c72e3 100644
--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -2451,11 +2451,6 @@ static int wsa_macro_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_fsgen;
 
-	ret = wsa_macro_register_mclk_output(wsa);
-	if (ret)
-		goto err_clkout;
-
-
 	ret = devm_snd_soc_register_component(dev, &wsa_macro_component_drv,
 					      wsa_macro_dai,
 					      ARRAY_SIZE(wsa_macro_dai));
@@ -2468,6 +2463,10 @@ static int wsa_macro_probe(struct platform_device *pdev)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
+	ret = wsa_macro_register_mclk_output(wsa);
+	if (ret)
+		goto err_clkout;
+
 	return 0;
 
 err_clkout:
-- 
2.39.2




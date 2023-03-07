Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED076AF3FE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbjCGTMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbjCGTMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:12:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B8F4BE87
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BFA761531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B14C433EF;
        Tue,  7 Mar 2023 18:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215358;
        bh=F5KvaQX4ilsiGqGDHP6QMCOgZQpYR9z5RaeFL1m+nBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCh+8nw3nfcbq3oyq0THMTTHsXWE4j9ulUQFdL1/fF4v655zLhmdfucRyk/ruMnhv
         4aMS7KDl5hUJ/xZ+eYIbrqZPit6YD6LVJygFm2XjAZMLoL6Jg7kzBdGDX0g8OQUUad
         btpMQyjMrcM/5YfISZiN4sVc2sKHhBBo948/M4hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 236/567] ASoC: codecs: tx-macro: move clk provider to managed variants
Date:   Tue,  7 Mar 2023 17:59:32 +0100
Message-Id: <20230307165916.173280807@linuxfoundation.org>
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

[ Upstream commit db8665a3e904f579840417f9414415c4dd54ac84 ]

move clk provider registration to managed api variants, this should help
with some code tidyup.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220224111718.6264-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e7621434378c ("ASoC: codecs: lpass: fix incorrect mclk rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index 8d1126802ddfa..4192f91612e16 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1745,10 +1745,9 @@ static const struct clk_ops swclk_gate_ops = {
 
 };
 
-static struct clk *tx_macro_register_mclk_output(struct tx_macro *tx)
+static int tx_macro_register_mclk_output(struct tx_macro *tx)
 {
 	struct device *dev = tx->dev;
-	struct device_node *np = dev->of_node;
 	const char *parent_clk_name = NULL;
 	const char *clk_name = "lpass-tx-mclk";
 	struct clk_hw *hw;
@@ -1764,13 +1763,11 @@ static struct clk *tx_macro_register_mclk_output(struct tx_macro *tx)
 	init.num_parents = 1;
 	tx->hw.init = &init;
 	hw = &tx->hw;
-	ret = clk_hw_register(tx->dev, hw);
+	ret = devm_clk_hw_register(dev, hw);
 	if (ret)
-		return ERR_PTR(ret);
-
-	of_clk_add_provider(np, of_clk_src_simple_get, hw->clk);
+		return ret;
 
-	return NULL;
+	return devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, hw);
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
@@ -1828,7 +1825,9 @@ static int tx_macro_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	tx_macro_register_mclk_output(tx);
+	ret = tx_macro_register_mclk_output(tx);
+	if (ret)
+		goto err;
 
 	ret = devm_snd_soc_register_component(dev, &tx_macro_component_drv,
 					      tx_macro_dai,
@@ -1846,8 +1845,6 @@ static int tx_macro_remove(struct platform_device *pdev)
 {
 	struct tx_macro *tx = dev_get_drvdata(&pdev->dev);
 
-	of_clk_del_provider(pdev->dev.of_node);
-
 	clk_bulk_disable_unprepare(TX_NUM_CLKS_MAX, tx->clks);
 
 	return 0;
-- 
2.39.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD718657E94
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbiL1PzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234175AbiL1PzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:55:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C2918B34
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F10136155B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC02C433D2;
        Wed, 28 Dec 2022 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242909;
        bh=6SQ70RZccRw/EhbzPjDFSwlXxLAY5Ne+GUKkdIONBpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JszPqMcmo+PIdZ84oKFo9TeeimciE/t5tac731MVPUj9D/ChGQiz0M17IkKrctU/v
         CfcUUUfNfAA4aNMo7bUNbGWzsh6YGzDyMW0hYctec8rEbCEWZ76Z4t1L3ibsra3AYH
         Q1UvQm472JMHGzMZr8gCFeKN0/hYldH0U3GjAIfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0453/1073] clk: qcom: lpass-sc7180: Fix pm_runtime usage
Date:   Wed, 28 Dec 2022 15:34:01 +0100
Message-Id: <20221228144340.339199303@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit ff1ccf59eaffd192efe21f7de9fb0c130faf1b1b ]

The sc7180 lpass clock controller's pm_runtime usage wasn't broken
quite as spectacularly as the sc7280's pm_runtime usage, but it was
still broken. Putting some printouts in at boot showed me this (with
serial console enabled, which makes the prints slow and thus changes
timing):
  [    3.109951] DOUG: my_pm_clk_resume, usage=1
  [    3.114767] DOUG: my_pm_clk_resume, usage=1
  [    3.664443] DOUG: my_pm_clk_suspend, usage=0
  [    3.897566] DOUG: my_pm_clk_suspend, usage=0
  [    3.910137] DOUG: my_pm_clk_resume, usage=1
  [    3.923217] DOUG: my_pm_clk_resume, usage=0
  [    4.440116] DOUG: my_pm_clk_suspend, usage=-1
  [    4.444982] DOUG: my_pm_clk_suspend, usage=0
  [   14.170501] DOUG: my_pm_clk_resume, usage=1
  [   14.176245] DOUG: my_pm_clk_resume, usage=0

...or this w/out serial console:
  [    0.556139] DOUG: my_pm_clk_resume, usage=1
  [    0.556279] DOUG: my_pm_clk_resume, usage=1
  [    1.058422] DOUG: my_pm_clk_suspend, usage=-1
  [    1.058464] DOUG: my_pm_clk_suspend, usage=0
  [    1.186250] DOUG: my_pm_clk_resume, usage=1
  [    1.186292] DOUG: my_pm_clk_resume, usage=0
  [    1.731536] DOUG: my_pm_clk_suspend, usage=-1
  [    1.731557] DOUG: my_pm_clk_suspend, usage=0
  [   10.288910] DOUG: my_pm_clk_resume, usage=1
  [   10.289496] DOUG: my_pm_clk_resume, usage=0

It seems to be doing roughly the right sequence of calls, but just
like with sc7280 this is more by luck than anything. Having a usage of
-1 is just not OK.

Let's fix this like we did with sc7280.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Fixes: ce8c195e652f ("clk: qcom: lpasscc: Introduce pm autosuspend for SC7180")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221104064055.2.I49b25b9bda9430fc7ea21e5a708ca5a0aced2798@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/lpasscorecc-sc7180.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/qcom/lpasscorecc-sc7180.c b/drivers/clk/qcom/lpasscorecc-sc7180.c
index ac09b7b840ab..a5731994cbed 100644
--- a/drivers/clk/qcom/lpasscorecc-sc7180.c
+++ b/drivers/clk/qcom/lpasscorecc-sc7180.c
@@ -356,7 +356,7 @@ static const struct qcom_cc_desc lpass_audio_hm_sc7180_desc = {
 	.num_gdscs = ARRAY_SIZE(lpass_audio_hm_sc7180_gdscs),
 };
 
-static int lpass_create_pm_clks(struct platform_device *pdev)
+static int lpass_setup_runtime_pm(struct platform_device *pdev)
 {
 	int ret;
 
@@ -375,7 +375,7 @@ static int lpass_create_pm_clks(struct platform_device *pdev)
 	if (ret < 0)
 		dev_err(&pdev->dev, "failed to acquire iface clock\n");
 
-	return ret;
+	return pm_runtime_resume_and_get(&pdev->dev);
 }
 
 static int lpass_core_cc_sc7180_probe(struct platform_device *pdev)
@@ -384,7 +384,7 @@ static int lpass_core_cc_sc7180_probe(struct platform_device *pdev)
 	struct regmap *regmap;
 	int ret;
 
-	ret = lpass_create_pm_clks(pdev);
+	ret = lpass_setup_runtime_pm(pdev);
 	if (ret)
 		return ret;
 
@@ -392,12 +392,14 @@ static int lpass_core_cc_sc7180_probe(struct platform_device *pdev)
 	desc = &lpass_audio_hm_sc7180_desc;
 	ret = qcom_cc_probe_by_index(pdev, 1, desc);
 	if (ret)
-		return ret;
+		goto exit;
 
 	lpass_core_cc_sc7180_regmap_config.name = "lpass_core_cc";
 	regmap = qcom_cc_map(pdev, &lpass_core_cc_sc7180_desc);
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto exit;
+	}
 
 	/*
 	 * Keep the CLK always-ON
@@ -415,6 +417,7 @@ static int lpass_core_cc_sc7180_probe(struct platform_device *pdev)
 	ret = qcom_cc_really_probe(pdev, &lpass_core_cc_sc7180_desc, regmap);
 
 	pm_runtime_mark_last_busy(&pdev->dev);
+exit:
 	pm_runtime_put_autosuspend(&pdev->dev);
 
 	return ret;
@@ -425,14 +428,19 @@ static int lpass_hm_core_probe(struct platform_device *pdev)
 	const struct qcom_cc_desc *desc;
 	int ret;
 
-	ret = lpass_create_pm_clks(pdev);
+	ret = lpass_setup_runtime_pm(pdev);
 	if (ret)
 		return ret;
 
 	lpass_core_cc_sc7180_regmap_config.name = "lpass_hm_core";
 	desc = &lpass_core_hm_sc7180_desc;
 
-	return qcom_cc_probe_by_index(pdev, 0, desc);
+	ret = qcom_cc_probe_by_index(pdev, 0, desc);
+
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
+
+	return ret;
 }
 
 static const struct of_device_id lpass_hm_sc7180_match_table[] = {
-- 
2.35.1




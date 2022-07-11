Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CE956D67D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 09:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiGKHPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 03:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiGKHPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 03:15:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA54E4F
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 00:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE344612AB
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 07:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED4AC34115;
        Mon, 11 Jul 2022 07:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657523614;
        bh=4SIsiLsjIusLlkWEAZ/5UzwMDHtPsUB+3iCdlITBHyQ=;
        h=Subject:To:Cc:From:Date:From;
        b=Tx1t3vp21MoX0+iGYfpYq2pTXqVvUlFIrIKZIW365n0JONT3aww4HnOZtYlDI1+JU
         mx2l4BOaJrIBY4AT1vvk7d91NsLKQqQgJo942scoff6fkYa+W/aHtODEPP6HIT9A8Y
         46/C6bUOhhdimMfrH4Vqxs4nwCEI/xVV0UQeS8jQ=
Subject: FAILED: patch "[PATCH] dmaengine: qcom: bam_dma: fix runtime PM underflow" failed to apply to 5.4-stable tree
To:     caleb.connolly@linaro.org, stephan@gerhold.net, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 09:13:23 +0200
Message-ID: <165752360312129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ac9c3dd0d6fe293cd5044cfad10bec27d171e4e Mon Sep 17 00:00:00 2001
From: Caleb Connolly <caleb.connolly@linaro.org>
Date: Wed, 29 Jun 2022 15:06:00 +0100
Subject: [PATCH] dmaengine: qcom: bam_dma: fix runtime PM underflow

Commit dbad41e7bb5f ("dmaengine: qcom: bam_dma: check if the runtime pm enabled")
caused unbalanced pm_runtime_get/put() calls when the bam is
controlled remotely. This commit reverts it and just enables pm_runtime
in all cases, the clk_* functions already just nop when the clock is NULL.

Also clean up a bit by removing unnecessary bamclk null checks.

Suggested-by: Stephan Gerhold <stephan@gerhold.net>
Fixes: dbad41e7bb5f ("dmaengine: qcom: bam_dma: check if the runtime pm enabled")
Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
Link: https://lore.kernel.org/r/20220629140559.118537-1-caleb.connolly@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 87f6ca1541cf..2ff787df513e 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -558,14 +558,6 @@ static int bam_alloc_chan(struct dma_chan *chan)
 	return 0;
 }
 
-static int bam_pm_runtime_get_sync(struct device *dev)
-{
-	if (pm_runtime_enabled(dev))
-		return pm_runtime_get_sync(dev);
-
-	return 0;
-}
-
 /**
  * bam_free_chan - Frees dma resources associated with specific channel
  * @chan: specified channel
@@ -581,7 +573,7 @@ static void bam_free_chan(struct dma_chan *chan)
 	unsigned long flags;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
@@ -784,7 +776,7 @@ static int bam_pause(struct dma_chan *chan)
 	unsigned long flag;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -810,7 +802,7 @@ static int bam_resume(struct dma_chan *chan)
 	unsigned long flag;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -919,7 +911,7 @@ static irqreturn_t bam_dma_irq(int irq, void *data)
 	if (srcs & P_IRQ)
 		tasklet_schedule(&bdev->task);
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return IRQ_NONE;
 
@@ -1037,7 +1029,7 @@ static void bam_start_dma(struct bam_chan *bchan)
 	if (!vd)
 		return;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
@@ -1374,11 +1366,6 @@ static int bam_dma_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unregister_dma;
 
-	if (!bdev->bamclk) {
-		pm_runtime_disable(&pdev->dev);
-		return 0;
-	}
-
 	pm_runtime_irq_safe(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, BAM_DMA_AUTOSUSPEND_DELAY);
 	pm_runtime_use_autosuspend(&pdev->dev);
@@ -1462,10 +1449,8 @@ static int __maybe_unused bam_dma_suspend(struct device *dev)
 {
 	struct bam_device *bdev = dev_get_drvdata(dev);
 
-	if (bdev->bamclk) {
-		pm_runtime_force_suspend(dev);
-		clk_unprepare(bdev->bamclk);
-	}
+	pm_runtime_force_suspend(dev);
+	clk_unprepare(bdev->bamclk);
 
 	return 0;
 }
@@ -1475,13 +1460,11 @@ static int __maybe_unused bam_dma_resume(struct device *dev)
 	struct bam_device *bdev = dev_get_drvdata(dev);
 	int ret;
 
-	if (bdev->bamclk) {
-		ret = clk_prepare(bdev->bamclk);
-		if (ret)
-			return ret;
+	ret = clk_prepare(bdev->bamclk);
+	if (ret)
+		return ret;
 
-		pm_runtime_force_resume(dev);
-	}
+	pm_runtime_force_resume(dev);
 
 	return 0;
 }


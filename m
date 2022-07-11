Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DC756FBF3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiGKJhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiGKJgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:36:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9B9823A0;
        Mon, 11 Jul 2022 02:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAEF86111F;
        Mon, 11 Jul 2022 09:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D83C34115;
        Mon, 11 Jul 2022 09:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531142;
        bh=gqWazm/mNwpkstb0KhVnW7UFdBsaUH4OBtp1yI4PIXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQNBR/Rwn3S/TOl5S0m3nWKHazzCN2hbiFq8ZNAaCQrevJ684hGA9D77YYI8BwzA4
         tT0AcpSEafdB2E7Sx8NXom2G3ntoFuHX24HqJ+UB8wMRK7777DBXWDbkKXQLucfZ7M
         qVAXBtCy+ErOODTABACI18//JikqapyntHE65kbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Caleb Connolly <caleb.connolly@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 110/112] dmaengine: qcom: bam_dma: fix runtime PM underflow
Date:   Mon, 11 Jul 2022 11:07:50 +0200
Message-Id: <20220711090552.690669633@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

From: Caleb Connolly <caleb.connolly@linaro.org>

commit 0ac9c3dd0d6fe293cd5044cfad10bec27d171e4e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/bam_dma.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -558,14 +558,6 @@ static int bam_alloc_chan(struct dma_cha
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
@@ -581,7 +573,7 @@ static void bam_free_chan(struct dma_cha
 	unsigned long flags;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
@@ -784,7 +776,7 @@ static int bam_pause(struct dma_chan *ch
 	unsigned long flag;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -810,7 +802,7 @@ static int bam_resume(struct dma_chan *c
 	unsigned long flag;
 	int ret;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return ret;
 
@@ -919,7 +911,7 @@ static irqreturn_t bam_dma_irq(int irq,
 	if (srcs & P_IRQ)
 		tasklet_schedule(&bdev->task);
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return IRQ_NONE;
 
@@ -1037,7 +1029,7 @@ static void bam_start_dma(struct bam_cha
 	if (!vd)
 		return;
 
-	ret = bam_pm_runtime_get_sync(bdev->dev);
+	ret = pm_runtime_get_sync(bdev->dev);
 	if (ret < 0)
 		return;
 
@@ -1374,11 +1366,6 @@ static int bam_dma_probe(struct platform
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
@@ -1462,10 +1449,8 @@ static int __maybe_unused bam_dma_suspen
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
@@ -1475,13 +1460,11 @@ static int __maybe_unused bam_dma_resume
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



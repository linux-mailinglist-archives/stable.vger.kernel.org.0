Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ADF441756
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhKAJfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233589AbhKAJdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CBE561266;
        Mon,  1 Nov 2021 09:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758702;
        bh=ESQKUtkM4InYMNExH3qDwqsx9HLqgV9G3H1q3JNLPbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAzE3OIPEvGWeV7VVTNdLP9QFhqYu5no3M00Y7nUN2FEpB0+9jgN6ZAz/2N8wp1JS
         YqomNyZqwkoBYS8lfW4o28rvcxrqfOMvzoDpz0ZDlB3JUUPq7Dnwf1wRQuGcsf25FE
         OmOjO1BLWegPLeZcxgLjXdqNfMNxGI0BMSbaoAAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenbin Mei <wenbin.mei@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 22/77] mmc: mediatek: Move cqhci init behind ungate clock
Date:   Mon,  1 Nov 2021 10:17:10 +0100
Message-Id: <20211101082516.569216846@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenbin Mei <wenbin.mei@mediatek.com>

commit e8a1ff65927080278e6826f797b7c197fb2611a6 upstream.

We must enable clock before cqhci init, because crypto needs read
information from CQHCI registers, otherwise, it will hang in MediaTek mmc
host controller.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Fixes: 88bd652b3c74 ("mmc: mediatek: command queue support")
Cc: stable@vger.kernel.org
Acked-by: Chaotian Jing <chaotian.jing@mediatek.com>
Link: https://lore.kernel.org/r/20211028022049.22129-1-wenbin.mei@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2503,6 +2503,25 @@ static int msdc_drv_probe(struct platfor
 		host->dma_mask = DMA_BIT_MASK(32);
 	mmc_dev(mmc)->dma_mask = &host->dma_mask;
 
+	host->timeout_clks = 3 * 1048576;
+	host->dma.gpd = dma_alloc_coherent(&pdev->dev,
+				2 * sizeof(struct mt_gpdma_desc),
+				&host->dma.gpd_addr, GFP_KERNEL);
+	host->dma.bd = dma_alloc_coherent(&pdev->dev,
+				MAX_BD_NUM * sizeof(struct mt_bdma_desc),
+				&host->dma.bd_addr, GFP_KERNEL);
+	if (!host->dma.gpd || !host->dma.bd) {
+		ret = -ENOMEM;
+		goto release_mem;
+	}
+	msdc_init_gpd_bd(host, &host->dma);
+	INIT_DELAYED_WORK(&host->req_timeout, msdc_request_timeout);
+	spin_lock_init(&host->lock);
+
+	platform_set_drvdata(pdev, mmc);
+	msdc_ungate_clock(host);
+	msdc_init_hw(host);
+
 	if (mmc->caps2 & MMC_CAP2_CQE) {
 		host->cq_host = devm_kzalloc(mmc->parent,
 					     sizeof(*host->cq_host),
@@ -2523,25 +2542,6 @@ static int msdc_drv_probe(struct platfor
 		mmc->max_seg_size = 64 * 1024;
 	}
 
-	host->timeout_clks = 3 * 1048576;
-	host->dma.gpd = dma_alloc_coherent(&pdev->dev,
-				2 * sizeof(struct mt_gpdma_desc),
-				&host->dma.gpd_addr, GFP_KERNEL);
-	host->dma.bd = dma_alloc_coherent(&pdev->dev,
-				MAX_BD_NUM * sizeof(struct mt_bdma_desc),
-				&host->dma.bd_addr, GFP_KERNEL);
-	if (!host->dma.gpd || !host->dma.bd) {
-		ret = -ENOMEM;
-		goto release_mem;
-	}
-	msdc_init_gpd_bd(host, &host->dma);
-	INIT_DELAYED_WORK(&host->req_timeout, msdc_request_timeout);
-	spin_lock_init(&host->lock);
-
-	platform_set_drvdata(pdev, mmc);
-	msdc_ungate_clock(host);
-	msdc_init_hw(host);
-
 	ret = devm_request_irq(&pdev->dev, host->irq, msdc_irq,
 			       IRQF_TRIGGER_NONE, pdev->name, host);
 	if (ret)



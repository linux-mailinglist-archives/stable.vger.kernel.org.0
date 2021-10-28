Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3A43D947
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 04:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhJ1CXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 22:23:24 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:44216 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229809AbhJ1CXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 22:23:24 -0400
X-UUID: 1de94ce069ba4bd59c11ecb3b1595b5d-20211028
X-UUID: 1de94ce069ba4bd59c11ecb3b1595b5d-20211028
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <wenbin.mei@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 52249534; Thu, 28 Oct 2021 10:20:54 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 28 Oct 2021 10:20:52 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs10n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 28 Oct 2021 10:20:52 +0800
From:   Wenbin Mei <wenbin.mei@mediatek.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Chun-Hung Wu <chun-hung.wu@mediatek.com>,
        "Yong Mao" <yong.mao@mediatek.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <srv_heupstream@mediatek.com>,
        "Wenbin Mei" <wenbin.mei@mediatek.com>, <stable@vger.kernel.org>
Subject: [PATCH] mmc: mediatek: move cqhci init behind ungate clock
Date:   Thu, 28 Oct 2021 10:20:49 +0800
Message-ID: <20211028022049.22129-1-wenbin.mei@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We must enable clock before cqhci init, because crypto needs
read information from CQHCI registers, otherwise, it will hang
in MediaTek mmc host controller.

Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
Fixes: 88bd652b3c74 ("mmc: mediatek: command queue support")
Cc: stable@vger.kernel.org
---
 drivers/mmc/host/mtk-sd.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index b124cfee05a1..943940b44e83 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2656,6 +2656,25 @@ static int msdc_drv_probe(struct platform_device *pdev)
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
@@ -2676,25 +2695,6 @@ static int msdc_drv_probe(struct platform_device *pdev)
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
-- 
2.25.1


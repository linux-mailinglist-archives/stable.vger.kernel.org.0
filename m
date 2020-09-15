Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C28826B4E4
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIOXdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbgIOOga (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:36:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEBD6223EA;
        Tue, 15 Sep 2020 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180007;
        bh=FHTcrPnwNgdAZABEN21HVNkT3V+T3gP6yMDMA/0pYuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MW/lSUFNhU3gZqnBfvoFe/yQwSkTdYSSftJMzlls1toRk+PmrdBRPwO0xg5Ct/GsT
         vdQ2KPVcbiAAyRYrYTcfILU0VKErhbTn2+Bo1UKC1dFe4ZiRpFsdaRmpXea8Mwf8NX
         /Lul17rPkCxwTXY7IqUa38iaQ74Su8Ej8cz5mvGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 072/177] drivers/dma/dma-jz4780: Fix race condition between probe and irq handler
Date:   Tue, 15 Sep 2020 16:12:23 +0200
Message-Id: <20200915140657.084051853@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

[ Upstream commit 6d6018fc30bee67290dbed2fa51123f7c6f3d691 ]

In probe, IRQ is requested before zchan->id is initialized which can be
read in the irq handler. Hence, shift request irq after other initializations
complete.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20200821034423.12713-1-madhuparnabhowmik10@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-jz4780.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/dma-jz4780.c b/drivers/dma/dma-jz4780.c
index 448f663da89c6..8beed91428bd6 100644
--- a/drivers/dma/dma-jz4780.c
+++ b/drivers/dma/dma-jz4780.c
@@ -879,24 +879,11 @@ static int jz4780_dma_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	ret = platform_get_irq(pdev, 0);
-	if (ret < 0)
-		return ret;
-
-	jzdma->irq = ret;
-
-	ret = request_irq(jzdma->irq, jz4780_dma_irq_handler, 0, dev_name(dev),
-			  jzdma);
-	if (ret) {
-		dev_err(dev, "failed to request IRQ %u!\n", jzdma->irq);
-		return ret;
-	}
-
 	jzdma->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(jzdma->clk)) {
 		dev_err(dev, "failed to get clock\n");
 		ret = PTR_ERR(jzdma->clk);
-		goto err_free_irq;
+		return ret;
 	}
 
 	clk_prepare_enable(jzdma->clk);
@@ -949,10 +936,23 @@ static int jz4780_dma_probe(struct platform_device *pdev)
 		jzchan->vchan.desc_free = jz4780_dma_desc_free;
 	}
 
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		goto err_disable_clk;
+
+	jzdma->irq = ret;
+
+	ret = request_irq(jzdma->irq, jz4780_dma_irq_handler, 0, dev_name(dev),
+			  jzdma);
+	if (ret) {
+		dev_err(dev, "failed to request IRQ %u!\n", jzdma->irq);
+		goto err_disable_clk;
+	}
+
 	ret = dmaenginem_async_device_register(dd);
 	if (ret) {
 		dev_err(dev, "failed to register device\n");
-		goto err_disable_clk;
+		goto err_free_irq;
 	}
 
 	/* Register with OF DMA helpers. */
@@ -960,17 +960,17 @@ static int jz4780_dma_probe(struct platform_device *pdev)
 					 jzdma);
 	if (ret) {
 		dev_err(dev, "failed to register OF DMA controller\n");
-		goto err_disable_clk;
+		goto err_free_irq;
 	}
 
 	dev_info(dev, "JZ4780 DMA controller initialised\n");
 	return 0;
 
-err_disable_clk:
-	clk_disable_unprepare(jzdma->clk);
-
 err_free_irq:
 	free_irq(jzdma->irq, jzdma);
+
+err_disable_clk:
+	clk_disable_unprepare(jzdma->clk);
 	return ret;
 }
 
-- 
2.25.1




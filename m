Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA2C658192
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiL1Q3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiL1Q3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB531B1C2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05998B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698B6C433EF;
        Wed, 28 Dec 2022 16:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244729;
        bh=vDNttQro2rZ1btYr9mz5SKAaJBGFtWPmInT6noPodaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kL+hY+xGpaBz7OB/46RM3I/hdu2PcqZqkxKf/3yxvDK1RacXCxPMrMc4TVqubizUP
         3ZDwU3e7NaPQA0N7f0ZhYVSix0qf4PSL8X1oAGqKCkgkyKTIF7hOwoGBTktWFufDfk
         y6nDmySdQKab0Ujw9uby7ps1jS+i9+2ncWA2sZx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0764/1073] dmaengine: apple-admac: Do not use devres for IRQs
Date:   Wed, 28 Dec 2022 15:39:12 +0100
Message-Id: <20221228144348.766037262@linuxfoundation.org>
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

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 072431595a57bc6605c29724afce5f9ef8114915 ]

This is in advance of adding support for triggering the reset signal to
the peripheral, since registering the IRQ handler will have to be
sequenced with it.

Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20220918095845.68860-4-povik+lin@cutebit.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 568aa6dd641f ("dmaengine: apple-admac: Allocate cache SRAM to channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/apple-admac.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/apple-admac.c b/drivers/dma/apple-admac.c
index 6780761a1640..d69ed9c93648 100644
--- a/drivers/dma/apple-admac.c
+++ b/drivers/dma/apple-admac.c
@@ -96,6 +96,7 @@ struct admac_data {
 	struct device *dev;
 	__iomem void *base;
 
+	int irq;
 	int irq_index;
 	int nchannels;
 	struct admac_chan channels[];
@@ -724,12 +725,7 @@ static int admac_probe(struct platform_device *pdev)
 
 	if (irq < 0)
 		return dev_err_probe(&pdev->dev, irq, "no usable interrupt\n");
-
-	err = devm_request_irq(&pdev->dev, irq, admac_interrupt,
-			       0, dev_name(&pdev->dev), ad);
-	if (err)
-		return dev_err_probe(&pdev->dev, err,
-				     "unable to register interrupt\n");
+	ad->irq = irq;
 
 	ad->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(ad->base))
@@ -774,17 +770,29 @@ static int admac_probe(struct platform_device *pdev)
 		tasklet_setup(&adchan->tasklet, admac_chan_tasklet);
 	}
 
-	err = dma_async_device_register(&ad->dma);
+	err = request_irq(irq, admac_interrupt, 0, dev_name(&pdev->dev), ad);
 	if (err)
-		return dev_err_probe(&pdev->dev, err, "failed to register DMA device\n");
+		return dev_err_probe(&pdev->dev, err,
+				     "unable to register interrupt\n");
+
+	err = dma_async_device_register(&ad->dma);
+	if (err) {
+		dev_err_probe(&pdev->dev, err, "failed to register DMA device\n");
+		goto free_irq;
+	}
 
 	err = of_dma_controller_register(pdev->dev.of_node, admac_dma_of_xlate, ad);
 	if (err) {
 		dma_async_device_unregister(&ad->dma);
-		return dev_err_probe(&pdev->dev, err, "failed to register with OF\n");
+		dev_err_probe(&pdev->dev, err, "failed to register with OF\n");
+		goto free_irq;
 	}
 
 	return 0;
+
+free_irq:
+	free_irq(ad->irq, ad);
+	return err;
 }
 
 static int admac_remove(struct platform_device *pdev)
@@ -793,6 +801,7 @@ static int admac_remove(struct platform_device *pdev)
 
 	of_dma_controller_free(pdev->dev.of_node);
 	dma_async_device_unregister(&ad->dma);
+	free_irq(ad->irq, ad);
 
 	return 0;
 }
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95463604866
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJSN4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiJSNxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60461CBAA3;
        Wed, 19 Oct 2022 06:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FB0B824E3;
        Wed, 19 Oct 2022 09:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1CBC433C1;
        Wed, 19 Oct 2022 09:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170919;
        bh=UcMC/ohTlfSufjYNgla/y8KiliyHVdq5JfegDQggsIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGqZ/gxw51pz5lRNmKLeg31r/KhzFnuBMsgRx3hAWGQAymvm4Yu3Z5l9vaX9HgufB
         a61vYuopX3AJGZ+6t0+dgNrPvM7zy3jT3DFj5V5Wt0pkK+Zdh+IL4ZAfImCMG/q1u4
         lHzlZekVMQw7nyG56dEIiMzmE+c2JWNvXIlL1pn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Serge Semin <fancer.lancer@gmail.com>,
        Frank Li <Frank.Li@nxp.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 836/862] dmaengine: dw-edma: Remove runtime PM support
Date:   Wed, 19 Oct 2022 10:35:23 +0200
Message-Id: <20221019083326.826965155@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit a0188eb6e71c93ab7dd9bfa4305fac43c70db309 ]

Currently, the dw-edma driver enables the runtime_pm for parent device
(chip->dev) and increments/decrements the refcount during alloc/free
chan resources callbacks.

This leads to a problem when the eDMA driver has been probed, but the
channels were not used. This scenario can happen when the DW PCIe driver
probes eDMA driver successfully, but the PCI EPF driver decides not to
use eDMA channels and use iATU instead for PCI transfers.

In this case, the underlying device would be runtime suspended due to
pm_runtime_enable() in dw_edma_probe() and the PCI EPF driver would have
no knowledge of it.

Ideally, the eDMA driver should not be the one doing the runtime PM of
the parent device. The responsibility should instead belong to the client
drivers like PCI EPF.

So let's remove the runtime PM support from eDMA driver.

Cc: Serge Semin <fancer.lancer@gmail.com>
Cc: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20220910054700.12205-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 07f756479663..c54b24ff5206 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
-#include <linux/pm_runtime.h>
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
@@ -682,15 +681,12 @@ static int dw_edma_alloc_chan_resources(struct dma_chan *dchan)
 	if (chan->status != EDMA_ST_IDLE)
 		return -EBUSY;
 
-	pm_runtime_get(chan->dw->chip->dev);
-
 	return 0;
 }
 
 static void dw_edma_free_chan_resources(struct dma_chan *dchan)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(5000);
-	struct dw_edma_chan *chan = dchan2dw_edma_chan(dchan);
 	int ret;
 
 	while (time_before(jiffies, timeout)) {
@@ -703,8 +699,6 @@ static void dw_edma_free_chan_resources(struct dma_chan *dchan)
 
 		cpu_relax();
 	}
-
-	pm_runtime_put(chan->dw->chip->dev);
 }
 
 static int dw_edma_channel_setup(struct dw_edma *dw, bool write,
@@ -977,9 +971,6 @@ int dw_edma_probe(struct dw_edma_chip *chip)
 	if (err)
 		goto err_irq_free;
 
-	/* Power management */
-	pm_runtime_enable(dev);
-
 	/* Turn debugfs on */
 	dw_edma_v0_core_debugfs_on(dw);
 
@@ -1009,9 +1000,6 @@ int dw_edma_remove(struct dw_edma_chip *chip)
 	for (i = (dw->nr_irqs - 1); i >= 0; i--)
 		free_irq(chip->ops->irq_vector(dev, i), &dw->irq[i]);
 
-	/* Power management */
-	pm_runtime_disable(dev);
-
 	/* Deregister eDMA device */
 	dma_async_device_unregister(&dw->wr_edma);
 	list_for_each_entry_safe(chan, _chan, &dw->wr_edma.channels,
-- 
2.35.1




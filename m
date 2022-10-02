Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9AC5F267C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiJBWyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJBWxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F64111803;
        Sun,  2 Oct 2022 15:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B99A8B80D9A;
        Sun,  2 Oct 2022 22:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28969C433C1;
        Sun,  2 Oct 2022 22:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751069;
        bh=YQdDdJ2wBIObSkIQqBsYU0YvqiqEvaVtU7QUzxUfiEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0LIaY9+rWFr90MgGw42jHLE2/tnrkDtnnzoE/iLF6lBpX/D9utW3OF/aYJvtCAJL
         qe4UrdykE2fzFOvxd9wRxmUpdBmBxDr2ssyID9CXtvhVMxaV8cjGSiAEk5RNaQwnfC
         Nh3Ks+VhnWPqDdc8VVTWRJlVKXl3O2EOedOyI79ah1QyELE9chxPMWwItwQiCGcoU0
         ZkpCeJwbY4SkZA/aFOlyJ58EuYyg+ideb9t3zJKr9+x4B0WhqtO2d64J7u2uIh9dQY
         +mocowjABk/tc5TsawISzdgbTdMIE0S/7CSgzr0k8RVXsW2McPioBg+XSKBYl3+V25
         qOjw3gPLjtlQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Swati Agarwal <swati.agarwal@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        lars@metafoo.de, adrianml@alumnos.upm.es,
        shravya.kumbham@xilinx.com, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/20] dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling
Date:   Sun,  2 Oct 2022 18:50:44 -0400
Message-Id: <20221002225100.239217-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Swati Agarwal <swati.agarwal@xilinx.com>

[ Upstream commit 91df7751eb890e970afc08f50b8f0fa5ea39e03d ]

Add missing cleanup in devm_platform_ioremap_resource().
When probe fails remove dma channel resources and disable clocks in
accordance with the order of resources allocated .

Signed-off-by: Swati Agarwal <swati.agarwal@xilinx.com>
Link: https://lore.kernel.org/r/20220817061125.4720-2-swati.agarwal@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index a4450bc95466..d3556b00a672 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3037,9 +3037,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	/* Request and map I/O memory */
 	xdev->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(xdev->regs))
-		return PTR_ERR(xdev->regs);
-
+	if (IS_ERR(xdev->regs)) {
+		err = PTR_ERR(xdev->regs);
+		goto disable_clks;
+	}
 	/* Retrieve the DMA engine properties from the device tree */
 	xdev->max_buffer_len = GENMASK(XILINX_DMA_MAX_TRANS_LEN_MAX - 1, 0);
 	xdev->s2mm_chan_id = xdev->dma_config->max_channels / 2;
@@ -3134,7 +3135,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	for_each_child_of_node(node, child) {
 		err = xilinx_dma_child_probe(xdev, child);
 		if (err < 0)
-			goto disable_clks;
+			goto error;
 	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
@@ -3169,12 +3170,12 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	return 0;
 
-disable_clks:
-	xdma_disable_allclks(xdev);
 error:
 	for (i = 0; i < xdev->dma_config->max_channels; i++)
 		if (xdev->chan[i])
 			xilinx_dma_chan_remove(xdev->chan[i]);
+disable_clks:
+	xdma_disable_allclks(xdev);
 
 	return err;
 }
-- 
2.35.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4235F9929
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiJJHIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiJJHHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796055A3E1;
        Mon, 10 Oct 2022 00:05:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4C0AB80E5A;
        Mon, 10 Oct 2022 07:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152D3C4314A;
        Mon, 10 Oct 2022 07:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385532;
        bh=TyREBzyre60IBy24xJfvU5P0XRa2Pc9FiHrPgZyW9FM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKzm6qg73yNUlIe7gv38UG1EbU54iwolTcGdQewJs770QuPdkUQ+WcRRnZ3z6FZ7K
         74v9lma3M3l+bEBEqHW5Y/XlN/umx0FEUMhi7G7QlFoZkUnE1sE3Smtf1zhzAZ/wLB
         lD+T44cBY7UMkvjantRctTVIt1JhOIUbweT0uf1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Swati Agarwal <swati.agarwal@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 13/48] dmaengine: xilinx_dma: Fix devm_platform_ioremap_resource error handling
Date:   Mon, 10 Oct 2022 09:05:11 +0200
Message-Id: <20221010070334.052955088@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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
index cd62bbb50e8b..ba0dccaa8cf1 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3160,9 +3160,10 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
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
@@ -3259,7 +3260,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	for_each_child_of_node(node, child) {
 		err = xilinx_dma_child_probe(xdev, child);
 		if (err < 0)
-			goto disable_clks;
+			goto error;
 	}
 
 	if (xdev->dma_config->dmatype == XDMA_TYPE_VDMA) {
@@ -3294,12 +3295,12 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
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




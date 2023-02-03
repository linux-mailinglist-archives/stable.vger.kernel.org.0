Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A554689636
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjBCK2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjBCK1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:27:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26F7A2A78
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1F9261EC2
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D909AC433EF;
        Fri,  3 Feb 2023 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419988;
        bh=JQHZBqIBruppcoaMDjh/ee0haDJY5sRTY4Wk+pKdAi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJxUYfUebd5t5U+fre/XLdaiRN3oJwpMA4gh185Mf3/22RkHDu9XhuFL+1ZAUKyY9
         S2u95NiuJCCwqw/x/DxlYdzc6pilquww84jX65ersFsP7MPyDW/SQO8Ya+3t26v++5
         THQd1NJz9t+Roau2/zigyAjZCUMihMR814/1fky0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/134] dmaengine: xilinx_dma: use devm_platform_ioremap_resource()
Date:   Fri,  3 Feb 2023 11:12:28 +0100
Message-Id: <20230203101025.809964642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit a8bd47542863947e2433db35558477caf0d89995 ]

Replace the chain of platform_get_resource() and devm_ioremap_resource()
with devm_platform_ioremap_resource(). It simplifies the flow and there
is no functional change.

Fixes below cocinelle warning-
WARNING: Use devm_platform_ioremap_resource for xdev -> regs

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1569495060-18117-4-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 596b53ccc36a ("dmaengine: xilinx_dma: call of_node_put() when breaking out of for_each_child_of_node()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 3bb711e735ab..8a7606bc326a 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2626,7 +2626,6 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	struct xilinx_dma_device *xdev;
 	struct device_node *child, *np = pdev->dev.of_node;
-	struct resource *io;
 	u32 num_frames, addr_width, len_width;
 	int i, err;
 
@@ -2652,8 +2651,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		return err;
 
 	/* Request and map I/O memory */
-	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	xdev->regs = devm_ioremap_resource(&pdev->dev, io);
+	xdev->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(xdev->regs))
 		return PTR_ERR(xdev->regs);
 
-- 
2.39.0




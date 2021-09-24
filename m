Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555C24172A4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344264AbhIXMuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344072AbhIXMst (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FBB61260;
        Fri, 24 Sep 2021 12:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487636;
        bh=uxeC18+KYd3DDoE2HahwBABAOWHCCk42OYrS5i2MukU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/5Dz0N4ZAGs8pW2INa0L5T3vgIdvcKcLtQ8cZ1URftcslQZLMbpQANTy46+H4zPN
         BPaiB1HQUnfKkbwir+FWhzHB6u6okjRs/yD9BqXBBjQqt4psvdgZsAm/QA+eC2QjDR
         qgcTCYIg9NNsyci1euiHIqjDLYEyWjSTWXXHoFsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/27] dmaengine: xilinx_dma: Set DMA mask for coherent APIs
Date:   Fri, 24 Sep 2021 14:44:11 +0200
Message-Id: <20210924124329.747980233@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit aac6c0f90799d66b8989be1e056408f33fd99fe6 ]

The xilinx dma driver uses the consistent allocations, so for correct
operation also set the DMA mask for coherent APIs. It fixes the below
kernel crash with dmatest client when DMA IP is configured with 64-bit
address width and linux is booted from high (>4GB) memory.

Call trace:
[  489.531257]  dma_alloc_from_pool+0x8c/0x1c0
[  489.535431]  dma_direct_alloc+0x284/0x330
[  489.539432]  dma_alloc_attrs+0x80/0xf0
[  489.543174]  dma_pool_alloc+0x160/0x2c0
[  489.547003]  xilinx_cdma_prep_memcpy+0xa4/0x180
[  489.551524]  dmatest_func+0x3cc/0x114c
[  489.555266]  kthread+0x124/0x130
[  489.558486]  ret_from_fork+0x10/0x3c
[  489.562051] ---[ end trace 248625b2d596a90a ]---

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Harini Katakam <harini.katakam@xilinx.com>
Link: https://lore.kernel.org/r/1629363528-30347-1-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 21203e3a54fd..3c2084766a31 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2585,7 +2585,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask(xdev->dev, DMA_BIT_MASK(addr_width));
+	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
-- 
2.33.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9942409FFF
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348712AbhIMWgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348575AbhIMWfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA2A361108;
        Mon, 13 Sep 2021 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572462;
        bh=DyJ6Rx33sxAmbKetNDXQ4Ae+kiVCSg4Y1eBB9sdXNH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKf76B+c4GYEow1I/DVf5BVztqxzON0lyD+htaQ5mcpM6QJU6rE37hWUqWeMj+gKu
         iZZYdK8jo4kQU+dX0+FueOE37T9gBRxqpAEAixPWRpvPccUGY4aEyGgYkIc2kH5ZMm
         w1piD3siydRqVvyu211/gjdTZJCvLGxAp+ZQTHHWz6BBDL3Q0JXTv54BJpmI/3dU0D
         LzAQ3URmeqgIcm6QUWJp/UPmxd7E+swgY0UKD6BxFq4IJhepOIU4q5Rtrax4DNQoYz
         pEamRB6Ien0QNHJnk5gA3b4w+/7mM6VNTwdFbDEmRuV76OckEq/MJzjRgI1oA0O+M6
         qwPOZBxxLW5wQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 05/19] dmaengine: xilinx_dma: Set DMA mask for coherent APIs
Date:   Mon, 13 Sep 2021 18:34:01 -0400
Message-Id: <20210913223415.435654-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223415.435654-1-sashal@kernel.org>
References: <20210913223415.435654-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4b9530a7bf65..434b1ff22e31 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -3077,7 +3077,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask(xdev->dev, DMA_BIT_MASK(addr_width));
+	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
-- 
2.30.2


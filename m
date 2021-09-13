Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071DB40A088
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348736AbhIMWjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:51304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244930AbhIMWhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1E461354;
        Mon, 13 Sep 2021 22:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572526;
        bh=nSJ9gpXuPaoi1bnAhq8W/J3axyHgdcIDw9hzK5lHd/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuVBApAGoUZMO0MmBN+YNZRtl29TiXRL+pXqusGfwwYjDeyS/76boMCPpGtamHMAo
         0ooHNcwuCAwsD/72om3njoVPPLxHsvDTf85pF33zx5/v+j/ZZDt6RShhk44dGB5FGz
         LlKAtl8+06hrcDo640l/soGsGQ/VQJueQq7oARlxvLpJc4Rdn/QsHTjz37zlWNB7YD
         IqgyjoqFP/vuNZJchNlPgp4rAizFjJA6yCkj4a7NQVuBKkouUSMIZ8aB68/iONLwbm
         JWU02/7P8gh+7W6WYCWXgldL/ohre0uA47Yr7MIialyHusJxKjuxRxD5AyDGLjZ3rk
         BKZuq2XkBm3Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 03/10] dmaengine: xilinx_dma: Set DMA mask for coherent APIs
Date:   Mon, 13 Sep 2021 18:35:14 -0400
Message-Id: <20210913223521.436250-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223521.436250-1-sashal@kernel.org>
References: <20210913223521.436250-1-sashal@kernel.org>
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
index d891ec05bc48..3f38df6b51f2 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2674,7 +2674,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask(xdev->dev, DMA_BIT_MASK(addr_width));
+	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
-- 
2.30.2


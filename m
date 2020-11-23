Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AD02C09D5
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbgKWNNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:13:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731757AbgKWMpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:45:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE0220732;
        Mon, 23 Nov 2020 12:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135542;
        bh=SgtpoC4SYf6lCQKes0N3SIZrkOXwiDe0hl6yULzIJ9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mdjZUfoLs5fTpZZ5O/eEJv5zGHzeVmTLx0K95bB9KilSK7C5rdn1vmidUCIWh1PEj
         xpJ+3mCmSF338dO1/CmDBMhB2EhZ44Lh4Fo5U+V4W+1wTWc/EDl9Ib7g7QnR5uGJnr
         NWwz1I5dc+FzScdZC0BdC5tZ3CjcFkOCBiIJ5Rxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Murrian <matthew.murrian@goctsi.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 105/252] dmaengine: xilinx_dma: Fix SG capability check for MCDMA
Date:   Mon, 23 Nov 2020 13:20:55 +0100
Message-Id: <20201123121840.654143296@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Murrian <matthew.murrian@goctsi.com>

[ Upstream commit 96d5d884f78306206d745d856aad322becd100c3 ]

The SG capability is inherently present with Multichannel DMA operation.
The register used to check for this capability with other DMA driver types
is not defined for MCDMA.

Fixes: 6ccd692bfb7f ("dmaengine: xilinx_dma: Add Xilinx AXI MCDMA Engine driver support")
Signed-off-by: Matthew Murrian <matthew.murrian@goctsi.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Link: https://lore.kernel.org/r/1604473206-32573-4-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index f0662f6672ff9..0fc432567b857 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2875,10 +2875,11 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		chan->stop_transfer = xilinx_dma_stop_transfer;
 	}
 
-	/* check if SG is enabled (only for AXIDMA and CDMA) */
+	/* check if SG is enabled (only for AXIDMA, AXIMCDMA, and CDMA) */
 	if (xdev->dma_config->dmatype != XDMA_TYPE_VDMA) {
-		if (dma_ctrl_read(chan, XILINX_DMA_REG_DMASR) &
-		    XILINX_DMA_DMASR_SG_MASK)
+		if (xdev->dma_config->dmatype == XDMA_TYPE_AXIMCDMA ||
+		    dma_ctrl_read(chan, XILINX_DMA_REG_DMASR) &
+			    XILINX_DMA_DMASR_SG_MASK)
 			chan->has_sg = true;
 		dev_dbg(chan->dev, "ch %d: SG %s\n", chan->id,
 			chan->has_sg ? "enabled" : "disabled");
-- 
2.27.0




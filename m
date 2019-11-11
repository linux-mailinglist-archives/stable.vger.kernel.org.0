Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8A6F7E76
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbfKKSoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbfKKSn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:43:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DA7204FD;
        Mon, 11 Nov 2019 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497838;
        bh=8oNkIOiv5Va1epVVjrY/bljrdj9DIi333mUax+51ZZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zo8Er6ZVfyjf8A1j1nHxSK0Lq//k4DjfhE6Aejxbka7NIry0AqeZ70+cxLiaglXSq
         aOZUTDfbyKHbDa4n68a7CRs9hd7H8RpiGuh7s2QFJiTYU7W36m798lSxHGZBDqluM6
         mgJSwB6i//C2q3r2nihCI2R6paMvst8lk++Ipd0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/125] dmaengine: xilinx_dma: Fix control reg update in vdma_channel_set_config
Date:   Mon, 11 Nov 2019 19:28:30 +0100
Message-Id: <20191111181449.613331688@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

[ Upstream commit 6c6de1ddb1be3840f2ed5cc9d009a622720940c9 ]

In vdma_channel_set_config clear the delay, frame count and master mask
before updating their new values. It avoids programming incorrect state
when input parameters are different from default.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Acked-by: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/1569495060-18117-3-git-send-email-radhey.shyam.pandey@xilinx.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index c124423125951..8aec137b4fcaa 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -72,6 +72,9 @@
 #define XILINX_DMA_DMACR_CIRC_EN		BIT(1)
 #define XILINX_DMA_DMACR_RUNSTOP		BIT(0)
 #define XILINX_DMA_DMACR_FSYNCSRC_MASK		GENMASK(6, 5)
+#define XILINX_DMA_DMACR_DELAY_MASK		GENMASK(31, 24)
+#define XILINX_DMA_DMACR_FRAME_COUNT_MASK	GENMASK(23, 16)
+#define XILINX_DMA_DMACR_MASTER_MASK		GENMASK(11, 8)
 
 #define XILINX_DMA_REG_DMASR			0x0004
 #define XILINX_DMA_DMASR_EOL_LATE_ERR		BIT(15)
@@ -2112,8 +2115,10 @@ int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
 	chan->config.gen_lock = cfg->gen_lock;
 	chan->config.master = cfg->master;
 
+	dmacr &= ~XILINX_DMA_DMACR_GENLOCK_EN;
 	if (cfg->gen_lock && chan->genlock) {
 		dmacr |= XILINX_DMA_DMACR_GENLOCK_EN;
+		dmacr &= ~XILINX_DMA_DMACR_MASTER_MASK;
 		dmacr |= cfg->master << XILINX_DMA_DMACR_MASTER_SHIFT;
 	}
 
@@ -2129,11 +2134,13 @@ int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
 	chan->config.delay = cfg->delay;
 
 	if (cfg->coalesc <= XILINX_DMA_DMACR_FRAME_COUNT_MAX) {
+		dmacr &= ~XILINX_DMA_DMACR_FRAME_COUNT_MASK;
 		dmacr |= cfg->coalesc << XILINX_DMA_DMACR_FRAME_COUNT_SHIFT;
 		chan->config.coalesc = cfg->coalesc;
 	}
 
 	if (cfg->delay <= XILINX_DMA_DMACR_DELAY_MAX) {
+		dmacr &= ~XILINX_DMA_DMACR_DELAY_MASK;
 		dmacr |= cfg->delay << XILINX_DMA_DMACR_DELAY_SHIFT;
 		chan->config.delay = cfg->delay;
 	}
-- 
2.20.1




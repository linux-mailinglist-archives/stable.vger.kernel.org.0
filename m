Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E876843
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbfGZNnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388209AbfGZNne (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:43:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E1222CC2;
        Fri, 26 Jul 2019 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148614;
        bh=SRWkb1rYWHX8LGcFo1lj7BcnybwsJzYcZ56huQNPnn4=;
        h=From:To:Cc:Subject:Date:From;
        b=qOErhd9UFQFRYmMcnXTvr9QzOqBoeGFOBP2umWmUe+l5g5UbcuGPB/qswDmJshaum
         Ys3ZVV14aScpp/ZAuLFW+FE7WszAD0VgqfcT78uDhtf5s3F0Q9lhBbbRcFdswoJ4Nc
         ATI1vn56rsiqg8fT5wL+rMr+GZHexCNcqjHG/DMk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 01/37] ARM: riscpc: fix DMA
Date:   Fri, 26 Jul 2019 09:42:56 -0400
Message-Id: <20190726134332.12626-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit ffd9a1ba9fdb7f2bd1d1ad9b9243d34e96756ba2 ]

DMA got broken a while back in two different ways:
1) a change in the behaviour of disable_irq() to wait for the interrupt
   to finish executing causes us to deadlock at the end of DMA.
2) a change to avoid modifying the scatterlist left the first transfer
   uninitialised.

DMA is only used with expansion cards, so has gone unnoticed.

Fixes: fa4e99899932 ("[ARM] dma: RiscPC: don't modify DMA SG entries")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-rpc/dma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-rpc/dma.c b/arch/arm/mach-rpc/dma.c
index fb48f3141fb4..c4c96661eb89 100644
--- a/arch/arm/mach-rpc/dma.c
+++ b/arch/arm/mach-rpc/dma.c
@@ -131,7 +131,7 @@ static irqreturn_t iomd_dma_handle(int irq, void *dev_id)
 	} while (1);
 
 	idma->state = ~DMA_ST_AB;
-	disable_irq(irq);
+	disable_irq_nosync(irq);
 
 	return IRQ_HANDLED;
 }
@@ -174,6 +174,9 @@ static void iomd_enable_dma(unsigned int chan, dma_t *dma)
 				DMA_FROM_DEVICE : DMA_TO_DEVICE);
 		}
 
+		idma->dma_addr = idma->dma.sg->dma_address;
+		idma->dma_len = idma->dma.sg->length;
+
 		iomd_writeb(DMA_CR_C, dma_base + CR);
 		idma->state = DMA_ST_AB;
 	}
-- 
2.20.1


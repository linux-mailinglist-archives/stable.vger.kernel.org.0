Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DE4767B5
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfGZNji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:39:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfGZNji (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A4C62238C;
        Fri, 26 Jul 2019 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148377;
        bh=BLhOaEzJpiBcupFrtwkSwZl9BKQjZCKbWHEf4i+tVgs=;
        h=From:To:Cc:Subject:Date:From;
        b=o8XecPiq6Q0TxInDoHpzia59CA+uNtJYXboMsbjwdkwEIiCcqO+L7yVogTioR9sWy
         ORqV95bstScTeBdhV4or48XUT6GRHwddAp5QJwdfasBbjnIb81dk5aDTM267RIH3ny
         OBWkUdqnAXKDgXX+XvtnUgfKnAh2OPVroVAWm/ZI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 01/85] ARM: riscpc: fix DMA
Date:   Fri, 26 Jul 2019 09:38:11 -0400
Message-Id: <20190726133936.11177-1-sashal@kernel.org>
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
index 488d5c3b37f4..799e0b016b62 100644
--- a/arch/arm/mach-rpc/dma.c
+++ b/arch/arm/mach-rpc/dma.c
@@ -128,7 +128,7 @@ static irqreturn_t iomd_dma_handle(int irq, void *dev_id)
 	} while (1);
 
 	idma->state = ~DMA_ST_AB;
-	disable_irq(irq);
+	disable_irq_nosync(irq);
 
 	return IRQ_HANDLED;
 }
@@ -177,6 +177,9 @@ static void iomd_enable_dma(unsigned int chan, dma_t *dma)
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


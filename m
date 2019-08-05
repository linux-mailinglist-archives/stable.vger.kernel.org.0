Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816F681D36
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfHENUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfHENUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:20:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04A7D20657;
        Mon,  5 Aug 2019 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011217;
        bh=8pXbc23W2MSPORqkmmAVFP+73bFbEIlrDdBc/Ts3/JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vevCbfrTfVyE9J9H4HCzPuCV9aTAwjnPKQeto0mpV7n6dwRPPK2YTqtzTlBgd3NU6
         mfl9BqLEpEZr+HG+K9VeOSeCtGJ2qrzeYdaBjmuHB870xjNUdsoWgu0ECbJpWNwCce
         a3gnaAMJajIBr1zrVCIoJfF6csoSUzf9O+36x3W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 001/131] ARM: riscpc: fix DMA
Date:   Mon,  5 Aug 2019 15:01:28 +0200
Message-Id: <20190805124951.547437569@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 488d5c3b37f44..799e0b016b622 100644
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




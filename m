Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70C03A9A3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbfFIRAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387788AbfFIRAJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:00:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4720C204EC;
        Sun,  9 Jun 2019 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099608;
        bh=c1kYXeUl9J5LHBC44XkMNayVBjkctNEI8okF4IdkjgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTyo33M6wrLI4fGAgBdOid+W4mcYqbQvM/15/W4RNznPsQEoxboIWgJby7TXBUN5w
         vuRvwMAKxlHT7En31tlBac9YTsSpn3ymukf9LNUY+a7oEcxtisUseVdHRXMCmCf3mH
         uUgyTnTUTqM9wy75Z/qdCNKC/WiRfU/KA3OqqWvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sugar Zhang <sugar.zhang@rock-chips.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 102/241] dmaengine: pl330: _stop: clear interrupt status
Date:   Sun,  9 Jun 2019 18:40:44 +0200
Message-Id: <20190609164150.739364628@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2da254cc7908105a60a6bb219d18e8dced03dcb9 ]

This patch kill instructs the DMAC to immediately terminate
execution of a thread. and then clear the interrupt status,
at last, stop generating interrupts for DMA_SEV. to guarantee
the next dma start is clean. otherwise, one interrupt maybe leave
to next start and make some mistake.

we can reporduce the problem as follows:

DMASEV: modify the event-interrupt resource, and if the INTEN sets
function as interrupt, the DMAC will set irq<event_num> HIGH to
generate interrupt. write INTCLR to clear interrupt.

	DMA EXECUTING INSTRUCTS		DMA TERMINATE
		|				|
		|				|
	       ...			      _stop
		|				|
		|			spin_lock_irqsave
	     DMASEV				|
		|				|
		|			    mask INTEN
		|				|
		|			     DMAKILL
		|				|
		|			spin_unlock_irqrestore

in above case, a interrupt was left, and if we unmask INTEN, the DMAC
will set irq<event_num> HIGH to generate interrupt.

to fix this, do as follows:

	DMA EXECUTING INSTRUCTS		DMA TERMINATE
		|				|
		|				|
	       ...			      _stop
		|				|
		|			spin_lock_irqsave
	     DMASEV				|
		|				|
		|			     DMAKILL
		|				|
		|			   clear INTCLR
		|			    mask INTEN
		|				|
		|			spin_unlock_irqrestore

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 95619ee33112c..799c182c3eacc 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1006,6 +1006,7 @@ static void _stop(struct pl330_thread *thrd)
 {
 	void __iomem *regs = thrd->dmac->base;
 	u8 insn[6] = {0, 0, 0, 0, 0, 0};
+	u32 inten = readl(regs + INTEN);
 
 	if (_state(thrd) == PL330_STATE_FAULT_COMPLETING)
 		UNTIL(thrd, PL330_STATE_FAULTING | PL330_STATE_KILLING);
@@ -1018,10 +1019,13 @@ static void _stop(struct pl330_thread *thrd)
 
 	_emit_KILL(0, insn);
 
-	/* Stop generating interrupts for SEV */
-	writel(readl(regs + INTEN) & ~(1 << thrd->ev), regs + INTEN);
-
 	_execute_DBGINSN(thrd, insn, is_manager(thrd));
+
+	/* clear the event */
+	if (inten & (1 << thrd->ev))
+		writel(1 << thrd->ev, regs + INTCLR);
+	/* Stop generating interrupts for SEV */
+	writel(inten & ~(1 << thrd->ev), regs + INTEN);
 }
 
 /* Start doing req 'idx' of thread 'thrd' */
-- 
2.20.1




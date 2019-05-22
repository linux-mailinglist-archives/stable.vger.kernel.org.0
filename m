Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429E926F2F
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731968AbfEVTyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731646AbfEVTZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:25:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667B42173C;
        Wed, 22 May 2019 19:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553135;
        bh=JtjKtKDXX3bcYRXIWSnueYMGbBzLZTQv9kgYNNPNOE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xK+rYLGWFjBf3GOnHmlV3Djg2x0nm4Mvv9dW99Wdk2Cmu+k2IM8qWxd7w8b3HY8c4
         aBt1G+lBl08BPlKBj4oUrI2r0KtfCWEp10CYdMh/O85SuyXbuRvTtJupsdWOW4qnjd
         ThCt7P0AWuWSpruXCl5fRFTXfAdufPUMF6QTDro4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sugar Zhang <sugar.zhang@rock-chips.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 065/317] dmaengine: pl330: _stop: clear interrupt status
Date:   Wed, 22 May 2019 15:19:26 -0400
Message-Id: <20190522192338.23715-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sugar Zhang <sugar.zhang@rock-chips.com>

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
index cff1b143fff5d..9b7a49fc76971 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -966,6 +966,7 @@ static void _stop(struct pl330_thread *thrd)
 {
 	void __iomem *regs = thrd->dmac->base;
 	u8 insn[6] = {0, 0, 0, 0, 0, 0};
+	u32 inten = readl(regs + INTEN);
 
 	if (_state(thrd) == PL330_STATE_FAULT_COMPLETING)
 		UNTIL(thrd, PL330_STATE_FAULTING | PL330_STATE_KILLING);
@@ -978,10 +979,13 @@ static void _stop(struct pl330_thread *thrd)
 
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


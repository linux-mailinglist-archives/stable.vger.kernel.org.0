Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2622A226959
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732558AbgGTQBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731433AbgGTQBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE2620672;
        Mon, 20 Jul 2020 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260894;
        bh=MjQVEo8ePfmHAxMzEUEPB8j9rECsoTukm0HF3RCe50g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wz5W7fq2gs/jK2vV41lfgPCmSdruu+SIBu5Xx+Ydgo9ZrgewfWtQvzLvW5oIq9jyE
         7d7f4qMbcearp+CIAZSs7L/PRD6t9gOoCmB4VuxpSuEiCtGiQYyqAdnf7yD8+5iS4v
         w6AEN5BLOvzcQqSSINCXHhTvr8R9zzhs0dAAHrSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/215] dmaengine: dw: Initialize channel before each transfer
Date:   Mon, 20 Jul 2020 17:36:25 +0200
Message-Id: <20200720152825.107548982@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 99ba8b9b0d9780e9937eb1d488d120e9e5c2533d ]

In some cases DMA can be used only with a consumer which does runtime power
management and on the platforms, that have DMA auto power gating logic
(see comments in the drivers/acpi/acpi_lpss.c), may result in DMA losing
its context. Simple mitigation of this issue is to initialize channel
each time the consumer initiates a transfer.

Fixes: cfdf5b6cc598 ("dw_dmac: add support for Lynxpoint DMA controllers")
Reported-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206403
Link: https://lore.kernel.org/r/20200705115620.51929-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/core.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 21cb2a58dbd29..a1b56f52db2f2 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -118,16 +118,11 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 {
 	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
 
-	if (test_bit(DW_DMA_IS_INITIALIZED, &dwc->flags))
-		return;
-
 	dw->initialize_chan(dwc);
 
 	/* Enable interrupts */
 	channel_set_bit(dw, MASK.XFER, dwc->mask);
 	channel_set_bit(dw, MASK.ERROR, dwc->mask);
-
-	set_bit(DW_DMA_IS_INITIALIZED, &dwc->flags);
 }
 
 /*----------------------------------------------------------------------*/
@@ -954,8 +949,6 @@ static void dwc_issue_pending(struct dma_chan *chan)
 
 void do_dw_dma_off(struct dw_dma *dw)
 {
-	unsigned int i;
-
 	dma_writel(dw, CFG, 0);
 
 	channel_clear_bit(dw, MASK.XFER, dw->all_chan_mask);
@@ -966,9 +959,6 @@ void do_dw_dma_off(struct dw_dma *dw)
 
 	while (dma_readl(dw, CFG) & DW_CFG_DMA_EN)
 		cpu_relax();
-
-	for (i = 0; i < dw->dma.chancnt; i++)
-		clear_bit(DW_DMA_IS_INITIALIZED, &dw->chan[i].flags);
 }
 
 void do_dw_dma_on(struct dw_dma *dw)
@@ -1032,8 +1022,6 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	/* Clear custom channel configuration */
 	memset(&dwc->dws, 0, sizeof(struct dw_dma_slave));
 
-	clear_bit(DW_DMA_IS_INITIALIZED, &dwc->flags);
-
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
 	channel_clear_bit(dw, MASK.BLOCK, dwc->mask);
-- 
2.25.1




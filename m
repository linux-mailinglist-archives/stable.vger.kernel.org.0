Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D16291DA0
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgJRTW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbgJRTW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0FA72137B;
        Sun, 18 Oct 2020 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048948;
        bh=X3yF2WEk7jjodg1N+eVjY14Uiapn2eIHGyzVg1Pa178=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPH/XSA02XRkuqIiD//Dimzm61hMOepzpHzv1mFysaxBlZ5vo7AgLzDVzyA7F1I3I
         opQCyTRrUzaaaKTQnjEpNbvF/EqxZqWM5kTfgProbnvEJn2DoNxvQ80qjKtfy7fFxy
         PsaBKbolqzgj1k2OgCdpL2fHSjyWsVKs8EJtyJ6w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 100/101] dmaengine: dw: Activate FIFO-mode for memory peripherals only
Date:   Sun, 18 Oct 2020 15:20:25 -0400
Message-Id: <20201018192026.4053674-100-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 6d9459d04081c796fc67c2bb771f4e4ebb5744c4 ]

CFGx.FIFO_MODE field controls a DMA-controller "FIFO readiness" criterion.
In other words it determines when to start pushing data out of a DW
DMAC channel FIFO to a destination peripheral or from a source
peripheral to the DW DMAC channel FIFO. Currently FIFO-mode is set to one
for all DW DMAC channels. It means they are tuned to flush data out of
FIFO (to a memory peripheral or by accepting the burst transaction
requests) when FIFO is at least half-full (except at the end of the block
transfer, when FIFO-flush mode is activated) and are configured to get
data to the FIFO when it's at least half-empty.

Such configuration is a good choice when there is no slave device involved
in the DMA transfers. In that case the number of bursts per block is less
than when CFGx.FIFO_MODE = 0 and, hence, the bus utilization will improve.
But the latency of DMA transfers may increase when CFGx.FIFO_MODE = 1,
since DW DMAC will wait for the channel FIFO contents to be either
half-full or half-empty depending on having the destination or the source
transfers. Such latencies might be dangerous in case if the DMA transfers
are expected to be performed from/to a slave device. Since normally
peripheral devices keep data in internal FIFOs, any latency at some
critical moment may cause one being overflown and consequently losing
data. This especially concerns a case when either a peripheral device is
relatively fast or the DW DMAC engine is relatively slow with respect to
the incoming data pace.

In order to solve problems, which might be caused by the latencies
described above, let's enable the FIFO half-full/half-empty "FIFO
readiness" criterion only for DMA transfers with no slave device involved.
Thanks to the commit 99ba8b9b0d97 ("dmaengine: dw: Initialize channel
before each transfer") we can freely do that in the generic
dw_dma_initialize_chan() method.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20200731200826.9292-3-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/dw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw/dw.c b/drivers/dma/dw/dw.c
index 7a085b3c1854c..d9810980920a1 100644
--- a/drivers/dma/dw/dw.c
+++ b/drivers/dma/dw/dw.c
@@ -14,7 +14,7 @@
 static void dw_dma_initialize_chan(struct dw_dma_chan *dwc)
 {
 	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
-	u32 cfghi = DWC_CFGH_FIFO_MODE;
+	u32 cfghi = is_slave_direction(dwc->direction) ? 0 : DWC_CFGH_FIFO_MODE;
 	u32 cfglo = DWC_CFGL_CH_PRIOR(dwc->priority);
 	bool hs_polarity = dwc->dws.hs_polarity;
 
-- 
2.25.1


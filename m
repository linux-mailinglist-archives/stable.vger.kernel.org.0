Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C4743FCAB
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 14:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhJ2MxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 08:53:19 -0400
Received: from mga03.intel.com ([134.134.136.65]:19931 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhJ2MxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Oct 2021 08:53:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="230609015"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="230609015"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 05:50:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="636685360"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2021 05:50:40 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     quic_pkondeti@quicinc.com, youling257@gmail.com
Cc:     pkondeti@codeaurora.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [RFT PATCH] xhci: Fix commad ring abort, write all 64 bits to CRCR register.
Date:   Fri, 29 Oct 2021 15:51:54 +0300
Message-Id: <20211029125154.438152-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <e96e2a96-00c4-6e6b-fc5a-e4a881325dc0@linux.intel.com>
References: <e96e2a96-00c4-6e6b-fc5a-e4a881325dc0@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Turns out some xHC controllers require all 64 bits in the CRCR register
to be written to execute a command abort.

The lower 32 bits containing the command abort bit is written first.
In case the command ring stops before we write the upper 32 bits then
hardware may use these upper bits to set the commnd ring dequeue pointer.

Solve this by making sure the upper 32 bits contain a valid command
ring dequeue pointer.

The original patch that only wrote the first 32 to stop the ring went
to stable, so this fix should go there as well.

Fixes: ff0e50d3564f ("xhci: Fix command ring pointer corruption while aborting a command")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 311597bba80e..eaa49aef2935 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -366,7 +366,9 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 /* Must be called with xhci->lock held, releases and aquires lock back */
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 {
-	u32 temp_32;
+	struct xhci_segment *new_seg	= xhci->cmd_ring->deq_seg;
+	union xhci_trb *new_deq		= xhci->cmd_ring->dequeue;
+	u64 crcr;
 	int ret;
 
 	xhci_dbg(xhci, "Abort command ring\n");
@@ -375,13 +377,18 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 
 	/*
 	 * The control bits like command stop, abort are located in lower
-	 * dword of the command ring control register. Limit the write
-	 * to the lower dword to avoid corrupting the command ring pointer
-	 * in case if the command ring is stopped by the time upper dword
-	 * is written.
+	 * dword of the command ring control register.
+	 * Some controllers require all 64 bits to be written to abort the ring.
+	 * Make sure the upper dword is valid, pointing to the next command,
+	 * avoiding corrupting the command ring pointer in case the command ring
+	 * is stopped by the time the upper dword is written.
 	 */
-	temp_32 = readl(&xhci->op_regs->cmd_ring);
-	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
+	next_trb(xhci, NULL, &new_seg, &new_deq);
+	if (trb_is_link(new_deq))
+		next_trb(xhci, NULL, &new_seg, &new_deq);
+
+	crcr = xhci_trb_virt_to_dma(new_seg, new_deq);
+	xhci_write_64(xhci, crcr | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
 
 	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
 	 * completion of the Command Abort operation. If CRR is not negated in 5
-- 
2.25.1


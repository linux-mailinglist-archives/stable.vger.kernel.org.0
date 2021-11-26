Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D088045EDD8
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 13:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377417AbhKZM3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 07:29:13 -0500
Received: from mga04.intel.com ([192.55.52.120]:43605 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237249AbhKZM1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Nov 2021 07:27:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10179"; a="234388665"
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="234388665"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 04:22:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="510623410"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga008.jf.intel.com with ESMTP; 26 Nov 2021 04:22:17 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: [PATCH 1/1] xhci: Fix commad ring abort, write all 64 bits to CRCR register.
Date:   Fri, 26 Nov 2021 14:23:40 +0200
Message-Id: <20211126122340.1193239-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126122340.1193239-1-mathias.nyman@linux.intel.com>
References: <20211126122340.1193239-1-mathias.nyman@linux.intel.com>
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
Tested-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
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


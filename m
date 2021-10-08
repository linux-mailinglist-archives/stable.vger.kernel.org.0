Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911E24266AB
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbhJHJZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:25:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:41430 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235969AbhJHJZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 05:25:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="249830696"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="249830696"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 02:23:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="489390552"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2021 02:23:19 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4/5] xhci: Fix command ring pointer corruption while aborting a command
Date:   Fri,  8 Oct 2021 12:25:46 +0300
Message-Id: <20211008092547.3996295-5-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
References: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavankumar Kondeti <pkondeti@codeaurora.org>

The command ring pointer is located at [6:63] bits of the command
ring control register (CRCR). All the control bits like command stop,
abort are located at [0:3] bits. While aborting a command, we read the
CRCR and set the abort bit and write to the CRCR. The read will always
give command ring pointer as all zeros. So we essentially write only
the control bits. Since we split the 64 bit write into two 32 bit writes,
there is a possibility of xHC command ring stopped before the upper
dword (all zeros) is written. If that happens, xHC updates the upper
dword of its internal command ring pointer with all zeros. Next time,
when the command ring is restarted, we see xHC memory access failures.
Fix this issue by only writing to the lower dword of CRCR where all
control bits are located.

Signed-off-by: Pavankumar Kondeti <pkondeti@codeaurora.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 7dbd26a9bc24..311597bba80e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -366,16 +366,22 @@ static void xhci_handle_stopped_cmd_ring(struct xhci_hcd *xhci,
 /* Must be called with xhci->lock held, releases and aquires lock back */
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 {
-	u64 temp_64;
+	u32 temp_32;
 	int ret;
 
 	xhci_dbg(xhci, "Abort command ring\n");
 
 	reinit_completion(&xhci->cmd_ring_stop_completion);
 
-	temp_64 = xhci_read_64(xhci, &xhci->op_regs->cmd_ring);
-	xhci_write_64(xhci, temp_64 | CMD_RING_ABORT,
-			&xhci->op_regs->cmd_ring);
+	/*
+	 * The control bits like command stop, abort are located in lower
+	 * dword of the command ring control register. Limit the write
+	 * to the lower dword to avoid corrupting the command ring pointer
+	 * in case if the command ring is stopped by the time upper dword
+	 * is written.
+	 */
+	temp_32 = readl(&xhci->op_regs->cmd_ring);
+	writel(temp_32 | CMD_RING_ABORT, &xhci->op_regs->cmd_ring);
 
 	/* Section 4.6.1.2 of xHCI 1.0 spec says software should also time the
 	 * completion of the Command Abort operation. If CRR is not negated in 5
-- 
2.25.1


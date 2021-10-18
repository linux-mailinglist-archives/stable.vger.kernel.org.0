Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA676431B19
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhJRNan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhJRN3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 862EE6128E;
        Mon, 18 Oct 2021 13:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563658;
        bh=5fkEOeRKMpAv1rt8DKebXAXjaN3huRnJpE8l2uHkoJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLBohUsTt3ww61mE/2U+70vmX05LZkDyrdA6uSows7JXrTww2OqMpRBuM0xFQWX6f
         WdLUebjH0UtEACMMS8rQH5E21hTJ3gTn50smQs0/6XDDX1asedkMsGDSgmcELTzW39
         UuNx6ANjabmwckiRmqGLCwSFy0fbtV4px9POPaNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 13/50] xhci: Fix command ring pointer corruption while aborting a command
Date:   Mon, 18 Oct 2021 15:24:20 +0200
Message-Id: <20211018132326.980569595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavankumar Kondeti <pkondeti@codeaurora.org>

commit ff0e50d3564f33b7f4b35cadeabd951d66cfc570 upstream.

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

Cc: stable@vger.kernel.org
Signed-off-by: Pavankumar Kondeti <pkondeti@codeaurora.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211008092547.3996295-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -339,16 +339,22 @@ static void xhci_handle_stopped_cmd_ring
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



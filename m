Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7750D469F29
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391476AbhLFPpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390613AbhLFPmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AC6C0698E0;
        Mon,  6 Dec 2021 07:29:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AF2FB81129;
        Mon,  6 Dec 2021 15:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9081CC34900;
        Mon,  6 Dec 2021 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804554;
        bh=jqKnJvJuUvNp4onCimjt+rXQb9IHdiPVeZrzf5Ou/rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwYcBZRPTfVIRg/WdxQKmuBnlJgQrEqPQQOSI44H9bwmajPHI7CFrYsnU3CmDUmf+
         xff3TYhoCfMLiOQwfMj2XuVJ6spzIRJBoEsmLFTf2WO3npFD7wwLrcxdnfe8eBHzBj
         uV83wiYfnXfGlxsojpDulAqwpa9+wK0TZaQZBD6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 189/207] xhci: Fix commad ring abort, write all 64 bits to CRCR register.
Date:   Mon,  6 Dec 2021 15:57:23 +0100
Message-Id: <20211206145616.824936525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 09f736aa95476631227d2dc0e6b9aeee1ad7ed58 upstream.

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
Link: https://lore.kernel.org/r/20211126122340.1193239-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -366,7 +366,9 @@ static void xhci_handle_stopped_cmd_ring
 /* Must be called with xhci->lock held, releases and aquires lock back */
 static int xhci_abort_cmd_ring(struct xhci_hcd *xhci, unsigned long flags)
 {
-	u32 temp_32;
+	struct xhci_segment *new_seg	= xhci->cmd_ring->deq_seg;
+	union xhci_trb *new_deq		= xhci->cmd_ring->dequeue;
+	u64 crcr;
 	int ret;
 
 	xhci_dbg(xhci, "Abort command ring\n");
@@ -375,13 +377,18 @@ static int xhci_abort_cmd_ring(struct xh
 
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



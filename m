Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA32171C26
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbgB0OJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388384AbgB0OJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:09:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BB321D7E;
        Thu, 27 Feb 2020 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812562;
        bh=40/YJTNEfQFz961lGWDIvzjZtpTxZbNNhGx8Y5tN/3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edWTdBzrrPekgdUWg3Of7sZwEMXnTHTgWtfCmcICKMPkIaNSNAwbTmNyclG9+wxmm
         W6IESbpvr6PwU+N/BfHHABqxbaRVjHIJtA1MTNvrLhaopMuRj214VPKnkxUKRACUd/
         KwyjhlzVAyRl4+EtFLZ9AAvZu40550HFxYC3NQ8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 5.4 027/135] usb: host: xhci: update event ring dequeue pointer on purpose
Date:   Thu, 27 Feb 2020 14:36:07 +0100
Message-Id: <20200227132233.228653421@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit dc0ffbea5729a3abafa577ebfce87f18b79e294b upstream.

On some situations, the software handles TRB events slower
than adding TRBs, then xhci_handle_event can't return zero
long time, the xHC will consider the event ring is full,
and trigger "Event Ring Full" error, but in fact, the software
has already finished lots of events, just no chance to
update ERDP (event ring dequeue pointer).

In this commit, we force update ERDP if half of TRBS_PER_SEGMENT
events have handled to avoid "Event Ring Full" error.

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1573836603-10871-2-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   60 ++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 17 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2741,6 +2741,42 @@ static int xhci_handle_event(struct xhci
 }
 
 /*
+ * Update Event Ring Dequeue Pointer:
+ * - When all events have finished
+ * - To avoid "Event Ring Full Error" condition
+ */
+static void xhci_update_erst_dequeue(struct xhci_hcd *xhci,
+		union xhci_trb *event_ring_deq)
+{
+	u64 temp_64;
+	dma_addr_t deq;
+
+	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
+	/* If necessary, update the HW's version of the event ring deq ptr. */
+	if (event_ring_deq != xhci->event_ring->dequeue) {
+		deq = xhci_trb_virt_to_dma(xhci->event_ring->deq_seg,
+				xhci->event_ring->dequeue);
+		if (deq == 0)
+			xhci_warn(xhci, "WARN something wrong with SW event ring dequeue ptr\n");
+		/*
+		 * Per 4.9.4, Software writes to the ERDP register shall
+		 * always advance the Event Ring Dequeue Pointer value.
+		 */
+		if ((temp_64 & (u64) ~ERST_PTR_MASK) ==
+				((u64) deq & (u64) ~ERST_PTR_MASK))
+			return;
+
+		/* Update HC event ring dequeue pointer */
+		temp_64 &= ERST_PTR_MASK;
+		temp_64 |= ((u64) deq & (u64) ~ERST_PTR_MASK);
+	}
+
+	/* Clear the event handler busy flag (RW1C) */
+	temp_64 |= ERST_EHB;
+	xhci_write_64(xhci, temp_64, &xhci->ir_set->erst_dequeue);
+}
+
+/*
  * xHCI spec says we can get an interrupt, and if the HC has an error condition,
  * we might get bad data out of the event ring.  Section 4.10.2.7 has a list of
  * indicators of an event TRB error, but we check the status *first* to be safe.
@@ -2751,9 +2787,9 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd
 	union xhci_trb *event_ring_deq;
 	irqreturn_t ret = IRQ_NONE;
 	unsigned long flags;
-	dma_addr_t deq;
 	u64 temp_64;
 	u32 status;
+	int event_loop = 0;
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	/* Check if the xHC generated the interrupt, or the irq is shared */
@@ -2807,24 +2843,14 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd
 	/* FIXME this should be a delayed service routine
 	 * that clears the EHB.
 	 */
-	while (xhci_handle_event(xhci) > 0) {}
-
-	temp_64 = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
-	/* If necessary, update the HW's version of the event ring deq ptr. */
-	if (event_ring_deq != xhci->event_ring->dequeue) {
-		deq = xhci_trb_virt_to_dma(xhci->event_ring->deq_seg,
-				xhci->event_ring->dequeue);
-		if (deq == 0)
-			xhci_warn(xhci, "WARN something wrong with SW event "
-					"ring dequeue ptr.\n");
-		/* Update HC event ring dequeue pointer */
-		temp_64 &= ERST_PTR_MASK;
-		temp_64 |= ((u64) deq & (u64) ~ERST_PTR_MASK);
+	while (xhci_handle_event(xhci) > 0) {
+		if (event_loop++ < TRBS_PER_SEGMENT / 2)
+			continue;
+		xhci_update_erst_dequeue(xhci, event_ring_deq);
+		event_loop = 0;
 	}
 
-	/* Clear the event handler busy flag (RW1C); event ring is empty. */
-	temp_64 |= ERST_EHB;
-	xhci_write_64(xhci, temp_64, &xhci->ir_set->erst_dequeue);
+	xhci_update_erst_dequeue(xhci, event_ring_deq);
 	ret = IRQ_HANDLED;
 
 out:



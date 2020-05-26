Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2681BCA14
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbgD1Spn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731337AbgD1SoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:44:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61CF9208E0;
        Tue, 28 Apr 2020 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099444;
        bh=T4pNiME8jG3hHsMX1Z7OJDtbf4iDtf/uugR3igHjm1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odHoph/3LWUu9IUWHZlDSdC8edKoEO1HjXOSJLmbyJct5Fsaauc2OzAerVeXM6kcH
         FuZILQ02p5m8OzFDuuNi2lT6QaV4+eaOmC+HiFzg7jEx6qo1ezST02UMy/bliJM926
         1OUC01/DoQZSj61BYwFd6H50koUY7dYyT8RLV2qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeremy Compostella <jeremy.compostella@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 154/168] xhci: Fix handling halted endpoint even if endpoint ring appears empty
Date:   Tue, 28 Apr 2020 20:25:28 +0200
Message-Id: <20200428182250.795230657@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 93ceaa808e8defc67ebca1396e2f42f812a2efc0 upstream.

If a class driver cancels its only URB then the endpoint ring buffer will
appear empty to the xhci driver. xHC hardware may still process cached
TRBs, and complete with a STALL, halting the endpoint.

This halted endpoint was not handled correctly by xhci driver as events on
empty rings were all assumed to be spurious events.
xhci driver refused to restart the ring with EP_HALTED flag set, so class
driver was never informed the endpoint halted even if it queued new URBs.

The host side of the endpoint needs to be reset, and dequeue pointer should
be moved in order to clear the cached TRBs and resetart the endpoint.

Small adjustments in finding the new dequeue pointer are needed to support
the case of stall on an empty ring and unknown current TD.

Cc: <stable@vger.kernel.org>
cc: Jeremy Compostella <jeremy.compostella@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200421140822.28233-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |   30 +++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.c      |   14 +++++++-------
 drivers/usb/host/xhci.h      |    5 +++--
 3 files changed, 39 insertions(+), 10 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -541,6 +541,23 @@ void xhci_find_new_dequeue_state(struct
 				stream_id);
 		return;
 	}
+	/*
+	 * A cancelled TD can complete with a stall if HW cached the trb.
+	 * In this case driver can't find cur_td, but if the ring is empty we
+	 * can move the dequeue pointer to the current enqueue position.
+	 */
+	if (!cur_td) {
+		if (list_empty(&ep_ring->td_list)) {
+			state->new_deq_seg = ep_ring->enq_seg;
+			state->new_deq_ptr = ep_ring->enqueue;
+			state->new_cycle_state = ep_ring->cycle_state;
+			goto done;
+		} else {
+			xhci_warn(xhci, "Can't find new dequeue state, missing cur_td\n");
+			return;
+		}
+	}
+
 	/* Dig out the cycle state saved by the xHC during the stop ep cmd */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
 			"Finding endpoint context");
@@ -586,6 +603,7 @@ void xhci_find_new_dequeue_state(struct
 	state->new_deq_seg = new_seg;
 	state->new_deq_ptr = new_deq;
 
+done:
 	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
 			"Cycle state = 0x%x", state->new_cycle_state);
@@ -1848,7 +1866,8 @@ static void xhci_cleanup_halted_endpoint
 
 	if (reset_type == EP_HARD_RESET) {
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
-		xhci_cleanup_stalled_ring(xhci, ep_index, stream_id, td);
+		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
+					  td);
 		xhci_clear_hub_tt_buffer(xhci, td, ep);
 	}
 	xhci_ring_cmd_db(xhci);
@@ -2527,6 +2546,15 @@ static int handle_tx_event(struct xhci_h
 				xhci_dbg(xhci, "td_list is empty while skip flag set. Clear skip flag for slot %u ep %u.\n",
 					 slot_id, ep_index);
 			}
+			if (trb_comp_code == COMP_STALL_ERROR ||
+			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
+							      trb_comp_code)) {
+				xhci_cleanup_halted_endpoint(xhci, slot_id,
+							     ep_index,
+							     ep_ring->stream_id,
+							     NULL,
+							     EP_HARD_RESET);
+			}
 			goto cleanup;
 		}
 
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3031,19 +3031,19 @@ static void xhci_setup_input_ctx_for_qui
 			added_ctxs, added_ctxs);
 }
 
-void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int ep_index,
-			       unsigned int stream_id, struct xhci_td *td)
+void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int slot_id,
+			       unsigned int ep_index, unsigned int stream_id,
+			       struct xhci_td *td)
 {
 	struct xhci_dequeue_state deq_state;
-	struct usb_device *udev = td->urb->dev;
 
 	xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 			"Cleaning up stalled endpoint ring");
 	/* We need to move the HW's dequeue pointer past this TD,
 	 * or it will attempt to resend it on the next doorbell ring.
 	 */
-	xhci_find_new_dequeue_state(xhci, udev->slot_id,
-			ep_index, stream_id, td, &deq_state);
+	xhci_find_new_dequeue_state(xhci, slot_id, ep_index, stream_id, td,
+				    &deq_state);
 
 	if (!deq_state.new_deq_ptr || !deq_state.new_deq_seg)
 		return;
@@ -3054,7 +3054,7 @@ void xhci_cleanup_stalled_ring(struct xh
 	if (!(xhci->quirks & XHCI_RESET_EP_QUIRK)) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 				"Queueing new dequeue state");
-		xhci_queue_new_dequeue_state(xhci, udev->slot_id,
+		xhci_queue_new_dequeue_state(xhci, slot_id,
 				ep_index, &deq_state);
 	} else {
 		/* Better hope no one uses the input context between now and the
@@ -3065,7 +3065,7 @@ void xhci_cleanup_stalled_ring(struct xh
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"Setting up input context for "
 				"configure endpoint command");
-		xhci_setup_input_ctx_for_quirk(xhci, udev->slot_id,
+		xhci_setup_input_ctx_for_quirk(xhci, slot_id,
 				ep_index, &deq_state);
 	}
 }
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2116,8 +2116,9 @@ void xhci_find_new_dequeue_state(struct
 void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
 		unsigned int slot_id, unsigned int ep_index,
 		struct xhci_dequeue_state *deq_state);
-void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int ep_index,
-		unsigned int stream_id, struct xhci_td *td);
+void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int slot_id,
+			       unsigned int ep_index, unsigned int stream_id,
+			       struct xhci_td *td);
 void xhci_stop_endpoint_command_watchdog(struct timer_list *t);
 void xhci_handle_command_timeout(struct work_struct *work);
 



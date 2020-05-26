Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A0C1B28FD
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 16:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgDUOGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 10:06:13 -0400
Received: from mga03.intel.com ([134.134.136.65]:63242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgDUOGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 10:06:10 -0400
IronPort-SDR: OOB2buhqClYQ6qIMiAI9zPPvpwBb3Av57UVNiEH3ZlpkyNuFp6kmiT44YhU5iNJrz2cqPkfMGL
 oIT86dmqGsDg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 07:05:50 -0700
IronPort-SDR: VLvW7sE1BVjMMmJqiJseg+5kNRpLfKuB9W4kmus6Je6tgy/4nCYp4HmCSjUvYoH24MiabtXh49
 cdJvEnpwf1aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,410,1580803200"; 
   d="scan'208";a="300618776"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Apr 2020 07:05:49 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org,
        Jeremy Compostella <jeremy.compostella@intel.com>
Subject: [PATCH 1/3] xhci: Fix handling halted endpoint even if endpoint ring appears empty
Date:   Tue, 21 Apr 2020 17:08:20 +0300
Message-Id: <20200421140822.28233-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421140822.28233-1-mathias.nyman@linux.intel.com>
References: <20200421140822.28233-1-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/host/xhci-ring.c | 30 +++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.c      | 14 +++++++-------
 drivers/usb/host/xhci.h      |  5 +++--
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index a78787bb5133..a7f4cd35da55 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -547,6 +547,23 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
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
@@ -592,6 +609,7 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	state->new_deq_seg = new_seg;
 	state->new_deq_ptr = new_deq;
 
+done:
 	/* Don't update the ring cycle state for the producer (us). */
 	xhci_dbg_trace(xhci, trace_xhci_dbg_cancel_urb,
 			"Cycle state = 0x%x", state->new_cycle_state);
@@ -1856,7 +1874,8 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 
 	if (reset_type == EP_HARD_RESET) {
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
-		xhci_cleanup_stalled_ring(xhci, ep_index, stream_id, td);
+		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
+					  td);
 		xhci_clear_hub_tt_buffer(xhci, td, ep);
 	}
 	xhci_ring_cmd_db(xhci);
@@ -2539,6 +2558,15 @@ static int handle_tx_event(struct xhci_hcd *xhci,
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
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index fe38275363e0..bee5deccc83d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3031,19 +3031,19 @@ static void xhci_setup_input_ctx_for_quirk(struct xhci_hcd *xhci,
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
@@ -3054,7 +3054,7 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int ep_index,
 	if (!(xhci->quirks & XHCI_RESET_EP_QUIRK)) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 				"Queueing new dequeue state");
-		xhci_queue_new_dequeue_state(xhci, udev->slot_id,
+		xhci_queue_new_dequeue_state(xhci, slot_id,
 				ep_index, &deq_state);
 	} else {
 		/* Better hope no one uses the input context between now and the
@@ -3065,7 +3065,7 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci, unsigned int ep_index,
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"Setting up input context for "
 				"configure endpoint command");
-		xhci_setup_input_ctx_for_quirk(xhci, udev->slot_id,
+		xhci_setup_input_ctx_for_quirk(xhci, slot_id,
 				ep_index, &deq_state);
 	}
 }
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3289bb516201..86cfefdd6632 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2116,8 +2116,9 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
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
 
-- 
2.17.1


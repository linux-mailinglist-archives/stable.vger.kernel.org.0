Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1773D5F81
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhGZPSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236876AbhGZPPn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ABA26100A;
        Mon, 26 Jul 2021 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314864;
        bh=jiFzxWuU03fj4V0bcvzfCoo4ysO2I6opMy+NkIKgBMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PP0NGUwwlRrTw7sW1YD9bUe1+fyZluezLAPMIanoVPFemIsrhYBSy5yfD2KzZkQQd
         FIcdtQ3NP9GgLjWa4HjKBahvsWbr+Yv+lC1rAdvlLQqHQRuW7XoRBvyzEZS0S11DF6
         b9lnzXtsDr+wWMHvRcxKGXleIQj1TCjAc3lanGK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Carsten Schmid <carsten_schmid@mentor.com>
Subject: [PATCH 4.19 120/120] xhci: add xhci_get_virt_ep() helper
Date:   Mon, 26 Jul 2021 17:39:32 +0200
Message-Id: <20210726153836.330754176@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[commit b1adc42d440df3233255e313a45ab7e9b2b74096 upstream]

In several event handlers we need to find the right endpoint
structure from slot_id and ep_index in the event.

Add a helper for this, check that slot_id and ep_index are valid.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carsten Schmid <carsten_schmid@mentor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   58 +++++++++++++++++++++++++++++++++----------
 drivers/usb/host/xhci.h      |    3 +-
 2 files changed, 47 insertions(+), 14 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -433,6 +433,26 @@ static void ring_doorbell_for_active_rin
 	}
 }
 
+static struct xhci_virt_ep *xhci_get_virt_ep(struct xhci_hcd *xhci,
+					     unsigned int slot_id,
+					     unsigned int ep_index)
+{
+	if (slot_id == 0 || slot_id >= MAX_HC_SLOTS) {
+		xhci_warn(xhci, "Invalid slot_id %u\n", slot_id);
+		return NULL;
+	}
+	if (ep_index >= EP_CTX_PER_DEV) {
+		xhci_warn(xhci, "Invalid endpoint index %u\n", ep_index);
+		return NULL;
+	}
+	if (!xhci->devs[slot_id]) {
+		xhci_warn(xhci, "No xhci virt device for slot_id %u\n", slot_id);
+		return NULL;
+	}
+
+	return &xhci->devs[slot_id]->eps[ep_index];
+}
+
 /* Get the right ring for the given slot_id, ep_index and stream_id.
  * If the endpoint supports streams, boundary check the URB's stream ID.
  * If the endpoint doesn't support streams, return the singular endpoint ring.
@@ -443,7 +463,10 @@ struct xhci_ring *xhci_triad_to_transfer
 {
 	struct xhci_virt_ep *ep;
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return NULL;
+
 	/* Common case: no streams */
 	if (!(ep->ep_state & EP_HAS_STREAMS))
 		return ep->ring;
@@ -718,11 +741,14 @@ static void xhci_handle_cmd_stop_ep(stru
 	memset(&deq_state, 0, sizeof(deq_state));
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
 
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	vdev = xhci->devs[slot_id];
 	ep_ctx = xhci_get_ep_ctx(xhci, vdev->out_ctx, ep_index);
 	trace_xhci_handle_cmd_stop_ep(ep_ctx);
 
-	ep = &xhci->devs[slot_id]->eps[ep_index];
 	last_unlinked_td = list_last_entry(&ep->cancelled_td_list,
 			struct xhci_td, cancelled_td_list);
 
@@ -1043,9 +1069,11 @@ static void xhci_handle_cmd_set_deq(stru
 
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
 	stream_id = TRB_TO_STREAM_ID(le32_to_cpu(trb->generic.field[2]));
-	dev = xhci->devs[slot_id];
-	ep = &dev->eps[ep_index];
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
 
+	dev = xhci->devs[slot_id];
 	ep_ring = xhci_stream_id_to_ring(dev, ep_index, stream_id);
 	if (!ep_ring) {
 		xhci_warn(xhci, "WARN Set TR deq ptr command for freed stream ID %u\n",
@@ -1118,9 +1146,9 @@ static void xhci_handle_cmd_set_deq(stru
 	}
 
 cleanup:
-	dev->eps[ep_index].ep_state &= ~SET_DEQ_PENDING;
-	dev->eps[ep_index].queued_deq_seg = NULL;
-	dev->eps[ep_index].queued_deq_ptr = NULL;
+	ep->ep_state &= ~SET_DEQ_PENDING;
+	ep->queued_deq_seg = NULL;
+	ep->queued_deq_ptr = NULL;
 	/* Restart any rings with pending URBs */
 	ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 }
@@ -1129,10 +1157,15 @@ static void xhci_handle_cmd_reset_ep(str
 		union xhci_trb *trb, u32 cmd_comp_code)
 {
 	struct xhci_virt_device *vdev;
+	struct xhci_virt_ep *ep;
 	struct xhci_ep_ctx *ep_ctx;
 	unsigned int ep_index;
 
 	ep_index = TRB_TO_EP_INDEX(le32_to_cpu(trb->generic.field[3]));
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep)
+		return;
+
 	vdev = xhci->devs[slot_id];
 	ep_ctx = xhci_get_ep_ctx(xhci, vdev->out_ctx, ep_index);
 	trace_xhci_handle_cmd_reset_ep(ep_ctx);
@@ -1162,7 +1195,7 @@ static void xhci_handle_cmd_reset_ep(str
 		xhci_ring_cmd_db(xhci);
 	} else {
 		/* Clear our internal halted state */
-		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
+		ep->ep_state &= ~EP_HALTED;
 	}
 }
 
@@ -2281,14 +2314,13 @@ static int handle_tx_event(struct xhci_h
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	ep_trb_dma = le64_to_cpu(event->buffer);
 
-	xdev = xhci->devs[slot_id];
-	if (!xdev) {
-		xhci_err(xhci, "ERROR Transfer event pointed to bad slot %u\n",
-			 slot_id);
+	ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
+	if (!ep) {
+		xhci_err(xhci, "ERROR Invalid Transfer event\n");
 		goto err_out;
 	}
 
-	ep = &xdev->eps[ep_index];
+	xdev = xhci->devs[slot_id];
 	ep_ring = xhci_dma_to_transfer_ring(ep, ep_trb_dma);
 	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -991,6 +991,7 @@ struct xhci_interval_bw_table {
 	unsigned int		ss_bw_out;
 };
 
+#define EP_CTX_PER_DEV		31
 
 struct xhci_virt_device {
 	struct usb_device		*udev;
@@ -1005,7 +1006,7 @@ struct xhci_virt_device {
 	struct xhci_container_ctx       *out_ctx;
 	/* Used for addressing devices and configuration changes */
 	struct xhci_container_ctx       *in_ctx;
-	struct xhci_virt_ep		eps[31];
+	struct xhci_virt_ep		eps[EP_CTX_PER_DEV];
 	u8				fake_port;
 	u8				real_port;
 	struct xhci_interval_bw_table	*bw_table;



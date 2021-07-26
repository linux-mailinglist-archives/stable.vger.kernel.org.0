Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3D53D5E95
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhGZPLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236180AbhGZPJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 992E260FA0;
        Mon, 26 Jul 2021 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314534;
        bh=5GLnUEDwsafm+R3Yj769smm66nObHIA6+h6XuMUrziE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yez9akwUH2p3dJCGnLMU2ACr0qkFQMO5d64KqD5PM8L3lDgoebBsOG8RikJwUfWXo
         CFjS4JEMb7HLBoXakQ1dk1YTY70+Uk8Ct9QMCXOHgRGpu40cGFuYMt9f/pASv4Y4rL
         gvmcZA8OE7li8MfsEL2Grhg1EZTmsc1R8kAjYdKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Carsten Schmid <carsten_schmid@mentor.com>
Subject: [PATCH 4.14 82/82] xhci: add xhci_get_virt_ep() helper
Date:   Mon, 26 Jul 2021 17:39:22 +0200
Message-Id: <20210726153830.844177432@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
@@ -444,6 +444,26 @@ static void ring_doorbell_for_active_rin
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
@@ -454,7 +474,10 @@ struct xhci_ring *xhci_triad_to_transfer
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
@@ -729,11 +752,14 @@ static void xhci_handle_cmd_stop_ep(stru
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
 
@@ -1057,9 +1083,11 @@ static void xhci_handle_cmd_set_deq(stru
 
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
@@ -1132,9 +1160,9 @@ static void xhci_handle_cmd_set_deq(stru
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
@@ -1143,10 +1171,15 @@ static void xhci_handle_cmd_reset_ep(str
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
@@ -1176,7 +1209,7 @@ static void xhci_handle_cmd_reset_ep(str
 		xhci_ring_cmd_db(xhci);
 	} else {
 		/* Clear our internal halted state */
-		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
+		ep->ep_state &= ~EP_HALTED;
 	}
 }
 
@@ -2352,14 +2385,13 @@ static int handle_tx_event(struct xhci_h
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



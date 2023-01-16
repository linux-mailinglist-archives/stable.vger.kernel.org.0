Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB7A66C5D6
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjAPQK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232278AbjAPQKJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8736298E3
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28104B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D28BC433F0;
        Mon, 16 Jan 2023 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885199;
        bh=t3IiQ6/rcszscYvKAaH8qG79If9HNsebBRNb0SZhqQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfxa852Un4PtJdXcFw6oyxaqLwNumAhBHqkkKkpLGFgTZAOmppUH01xurO6nj7Fu/
         U/VdEzX8sU1HrEgZMDv+jtgxZnKnxZXRHJd1ctIWoJOIucQTeA2BnRFitrNxOpClYY
         /m1H5GdsmYgBwxT7ikmoMI4kRyaxvr02cQUTT9fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/64] xhci: adjust parameters passed to cleanup_halted_endpoint()
Date:   Mon, 16 Jan 2023 16:51:33 +0100
Message-Id: <20230116154744.501401626@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit d70f4231b81eeb6dd78bd913ff42729b524eec51 ]

Instead of passing slot id and endpoint index to
cleanup_halted_endpoint() pass the endpoint structure pointer
as it's already known.

Avoids again digging out the endpoint structure based on
slot id and endpoint index, and passing them along the
call chain for this purpose only.

Add slot_id to the virt_dev structure so that it
can easily be found from a virt_dev, or its child, the
virt_ep endpoint structure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c  |  2 ++
 drivers/usb/host/xhci-ring.c | 35 ++++++++++++++---------------------
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 002e4948993d..a8a9addb4d25 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1003,6 +1003,8 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 	if (!dev)
 		return 0;
 
+	dev->slot_id = slot_id;
+
 	/* Allocate the (output) device context that will be used in the HC. */
 	dev->out_ctx = xhci_alloc_container_ctx(xhci, XHCI_CTX_TYPE_DEVICE, flags);
 	if (!dev->out_ctx)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6d34c56376e5..a0d210d3a3c6 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1925,13 +1925,12 @@ static void xhci_clear_hub_tt_buffer(struct xhci_hcd *xhci, struct xhci_td *td,
 }
 
 static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
-		unsigned int slot_id, unsigned int ep_index,
-		unsigned int stream_id, struct xhci_td *td,
-		enum xhci_ep_reset_type reset_type)
+				struct xhci_virt_ep *ep, unsigned int stream_id,
+				struct xhci_td *td,
+				enum xhci_ep_reset_type reset_type)
 {
-	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
 	struct xhci_command *command;
-
+	unsigned int slot_id = ep->vdev->slot_id;
 	/*
 	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
 	 * Device will be reset soon to recover the link so don't do anything
@@ -1945,11 +1944,11 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 
 	ep->ep_state |= EP_HALTED;
 
-	xhci_queue_reset_ep(xhci, command, slot_id, ep_index, reset_type);
+	xhci_queue_reset_ep(xhci, command, slot_id, ep->ep_index, reset_type);
 
 	if (reset_type == EP_HARD_RESET) {
 		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
-		xhci_cleanup_stalled_ring(xhci, slot_id, ep_index, stream_id,
+		xhci_cleanup_stalled_ring(xhci, slot_id, ep->ep_index, stream_id,
 					  td);
 	}
 	xhci_ring_cmd_db(xhci);
@@ -2047,10 +2046,8 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 {
 	struct xhci_ep_ctx *ep_ctx;
 	struct xhci_ring *ep_ring;
-	unsigned int slot_id;
 	u32 trb_comp_code;
 
-	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	ep_ctx = xhci_get_ep_ctx(xhci, ep->vdev->out_ctx, ep->ep_index);
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
@@ -2079,8 +2076,8 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		 */
 		if ((ep->ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
 			xhci_clear_hub_tt_buffer(xhci, td, ep);
-		xhci_cleanup_halted_endpoint(xhci, slot_id, ep->ep_index,
-					ep_ring->stream_id, td, EP_HARD_RESET);
+		xhci_cleanup_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
+					     EP_HARD_RESET);
 	} else {
 		/* Update ring dequeue pointer */
 		while (ep_ring->dequeue != td->last_trb)
@@ -2323,9 +2320,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	struct xhci_ring *ep_ring;
 	u32 trb_comp_code;
 	u32 remaining, requested, ep_trb_len;
-	unsigned int slot_id;
 
-	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
 	slot_ctx = xhci_get_slot_ctx(xhci, ep->vdev->out_ctx);
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
@@ -2365,8 +2360,8 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 		*status = 0;
-		xhci_cleanup_halted_endpoint(xhci, slot_id, ep->ep_index,
-					ep_ring->stream_id, td, EP_SOFT_RESET);
+		xhci_cleanup_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
+					     EP_SOFT_RESET);
 		return 0;
 	default:
 		/* do nothing */
@@ -2441,8 +2436,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		case COMP_USB_TRANSACTION_ERROR:
 		case COMP_INVALID_STREAM_TYPE_ERROR:
 		case COMP_INVALID_STREAM_ID_ERROR:
-			xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index, 0,
-						     NULL, EP_SOFT_RESET);
+			xhci_cleanup_halted_endpoint(xhci, ep, 0, NULL,
+						     EP_SOFT_RESET);
 			goto cleanup;
 		case COMP_RING_UNDERRUN:
 		case COMP_RING_OVERRUN:
@@ -2625,8 +2620,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 							      trb_comp_code)) {
-				xhci_cleanup_halted_endpoint(xhci, slot_id,
-							     ep_index,
+				xhci_cleanup_halted_endpoint(xhci, ep,
 							     ep_ring->stream_id,
 							     NULL,
 							     EP_HARD_RESET);
@@ -2720,8 +2714,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 							      trb_comp_code))
-				xhci_cleanup_halted_endpoint(xhci, slot_id,
-							     ep_index,
+				xhci_cleanup_halted_endpoint(xhci, ep,
 							     ep_ring->stream_id,
 							     td, EP_HARD_RESET);
 			goto cleanup;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 5fbd159f6fa5..9cbf106fb3ee 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1004,6 +1004,7 @@ struct xhci_interval_bw_table {
 #define EP_CTX_PER_DEV		31
 
 struct xhci_virt_device {
+	int				slot_id;
 	struct usb_device		*udev;
 	/*
 	 * Commands to the hardware are passed an "input context" that
-- 
2.35.1




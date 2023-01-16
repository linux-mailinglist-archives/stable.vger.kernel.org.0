Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAE66C5DA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbjAPQLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbjAPQKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A07244A9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB7A6B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E5BC433F0;
        Mon, 16 Jan 2023 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885207;
        bh=ZA+EuWnwctKgwmlKSfotzMYvJrToAhbi1YrzgvWsVvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtCfajemMNE5INEDki8LswKMJSc63dvzYKn0cqP9Yo4xMXTroYBJnQ4nOybBnHIFX
         fuS8oZZv9bfhpEkE+Mee5S2t1vab/k3kn130/C0RJAnXmKg9yVqj3hn2EtNU2+IbtB
         hAW8NfS0Xdi5G/l70pPa/7wX+0OaAVg15UahMnzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/64] xhci: store TD status in the td struct instead of passing it along
Date:   Mon, 16 Jan 2023 16:51:36 +0100
Message-Id: <20230116154744.598979065@linuxfoundation.org>
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

[ Upstream commit a6ccd1fd4bd4fca37eaa3d76bef940d6332919bc ]

In cases where the TD can't be given back in current handler we want
to be able to store it until its time to return the TD.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-19-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 56 +++++++++++++++++++-----------------
 drivers/usb/host/xhci.h      |  1 +
 2 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d523cbe7fcf1..2bd407ff9f0b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -774,7 +774,7 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 }
 
 static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
-		struct xhci_ring *ep_ring, int *status)
+			   struct xhci_ring *ep_ring, int status)
 {
 	struct urb *urb = NULL;
 
@@ -793,7 +793,7 @@ static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
 		xhci_warn(xhci, "URB req %u and actual %u transfer length mismatch\n",
 			  urb->transfer_buffer_length, urb->actual_length);
 		urb->actual_length = 0;
-		*status = 0;
+		status = 0;
 	}
 	list_del_init(&td->td_list);
 	/* Was this TD slated to be cancelled but completed anyway? */
@@ -805,15 +805,15 @@ static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
 	if (last_td_in_urb(td)) {
 		if ((urb->actual_length != urb->transfer_buffer_length &&
 		     (urb->transfer_flags & URB_SHORT_NOT_OK)) ||
-		    (*status != 0 && !usb_endpoint_xfer_isoc(&urb->ep->desc)))
+		    (status != 0 && !usb_endpoint_xfer_isoc(&urb->ep->desc)))
 			xhci_dbg(xhci, "Giveback URB %p, len = %d, expected = %d, status = %d\n",
 				 urb, urb->actual_length,
-				 urb->transfer_buffer_length, *status);
+				 urb->transfer_buffer_length, status);
 
 		/* set isoc urb status to 0 just as EHCI, UHCI, and OHCI */
 		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
-			*status = 0;
-		xhci_giveback_urb_in_irq(xhci, td, *status);
+			status = 0;
+		xhci_giveback_urb_in_irq(xhci, td, status);
 	}
 
 	return 0;
@@ -2060,8 +2060,7 @@ int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code)
 }
 
 static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
-	struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_transfer_event *event, struct xhci_virt_ep *ep)
 {
 	struct xhci_ep_ctx *ep_ctx;
 	struct xhci_ring *ep_ring;
@@ -2104,7 +2103,7 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		inc_deq(xhci, ep_ring);
 	}
 
-	return xhci_td_cleanup(xhci, td, ep_ring, status);
+	return xhci_td_cleanup(xhci, td, ep_ring, td->status);
 }
 
 /* sum trb lengths from ring dequeue up to stop_trb, _excluding_ stop_trb */
@@ -2127,7 +2126,7 @@ static int sum_trb_lengths(struct xhci_hcd *xhci, struct xhci_ring *ring,
  */
 static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_virt_ep *ep)
 {
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
@@ -2145,13 +2144,13 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		if (trb_type != TRB_STATUS) {
 			xhci_warn(xhci, "WARN: Success on ctrl %s TRB without IOC set?\n",
 				  (trb_type == TRB_DATA) ? "data" : "setup");
-			*status = -ESHUTDOWN;
+			td->status = -ESHUTDOWN;
 			break;
 		}
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
 		if (trb_type == TRB_DATA || trb_type == TRB_NORMAL)
@@ -2215,7 +2214,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		td->urb->actual_length = requested;
 
 finish_td:
-	return finish_td(xhci, td, event, ep, status);
+	return finish_td(xhci, td, event, ep);
 }
 
 /*
@@ -2223,7 +2222,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
  */
 static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_virt_ep *ep)
 {
 	struct urb_priv *urb_priv;
 	int idx;
@@ -2300,11 +2299,11 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 
 	td->urb->actual_length += frame->actual_length;
 
-	return finish_td(xhci, td, event, ep, status);
+	return finish_td(xhci, td, event, ep);
 }
 
 static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
-			struct xhci_virt_ep *ep, int *status)
+			struct xhci_virt_ep *ep, int status)
 {
 	struct urb_priv *urb_priv;
 	struct usb_iso_packet_descriptor *frame;
@@ -2333,7 +2332,7 @@ static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
  */
 static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep, int *status)
+	struct xhci_virt_ep *ep)
 {
 	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_ring *ep_ring;
@@ -2357,13 +2356,13 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 				 td->urb->ep->desc.bEndpointAddress,
 				 requested, remaining);
 		}
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
 		xhci_dbg(xhci, "ep %#x - asked for %d bytes, %d bytes untransferred\n",
 			 td->urb->ep->desc.bEndpointAddress,
 			 requested, remaining);
-		*status = 0;
+		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
 		td->urb->actual_length = remaining;
@@ -2378,7 +2377,8 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		    (ep_ring->err_count++ > MAX_SOFT_RETRY) ||
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
-		*status = 0;
+
+		td->status = 0;
 		xhci_cleanup_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
 					     EP_SOFT_RESET);
 		return 0;
@@ -2399,7 +2399,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 			  remaining);
 		td->urb->actual_length = 0;
 	}
-	return finish_td(xhci, td, event, ep, status);
+	return finish_td(xhci, td, event, ep);
 }
 
 /*
@@ -2701,7 +2701,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				return -ESHUTDOWN;
 			}
 
-			skip_isoc_td(xhci, td, ep, &status);
+			skip_isoc_td(xhci, td, ep, status);
 			goto cleanup;
 		}
 		if (trb_comp_code == COMP_SHORT_PACKET)
@@ -2729,6 +2729,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		 * endpoint. Otherwise, the endpoint remains stalled
 		 * indefinitely.
 		 */
+
 		if (trb_is_noop(ep_trb)) {
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
@@ -2739,14 +2740,15 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			goto cleanup;
 		}
 
+		td->status = status;
+
 		/* update the urb's actual_length and give back to the core */
 		if (usb_endpoint_xfer_control(&td->urb->ep->desc))
-			process_ctrl_td(xhci, td, ep_trb, event, ep, &status);
+			process_ctrl_td(xhci, td, ep_trb, event, ep);
 		else if (usb_endpoint_xfer_isoc(&td->urb->ep->desc))
-			process_isoc_td(xhci, td, ep_trb, event, ep, &status);
+			process_isoc_td(xhci, td, ep_trb, event, ep);
 		else
-			process_bulk_intr_td(xhci, td, ep_trb, event, ep,
-					     &status);
+			process_bulk_intr_td(xhci, td, ep_trb, event, ep);
 cleanup:
 		handling_skipped_tds = ep->skip &&
 			trb_comp_code != COMP_MISSED_SERVICE_ERROR &&
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9cbf106fb3ee..af3759928a95 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1544,6 +1544,7 @@ struct xhci_segment {
 struct xhci_td {
 	struct list_head	td_list;
 	struct list_head	cancelled_td_list;
+	int			status;
 	struct urb		*urb;
 	struct xhci_segment	*start_seg;
 	union xhci_trb		*first_trb;
-- 
2.35.1




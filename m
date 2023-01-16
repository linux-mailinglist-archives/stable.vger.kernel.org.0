Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D6766C5D0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjAPQKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjAPQKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A4D298CD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE576B81065
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE70C433F0;
        Mon, 16 Jan 2023 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885194;
        bh=bg1MfXF29Tz6UN9Ge5QQ94Qhk8kCCMnSgWffqtJlinI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSFmutUR8DXpp0SuAIEcU/NKLSepQkXwSfJGz2ovwnEkk+ewB5+Ivm2/6V5pqU2tB
         LYv+NrICeUWR4Z0d13oNQgKp8vEb8JQ73HZpIZjFnAoc+iybtRBv8/zyFmpPBX5N5b
         bqTrk299HDIonZu1RTFoiFhL86tYWBFqBLoI4n4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/64] xhci: Avoid parsing transfer events several times
Date:   Mon, 16 Jan 2023 16:51:31 +0100
Message-Id: <20230116154744.441590618@linuxfoundation.org>
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

[ Upstream commit ab58f3bb6aaaf98ba81d5c627ac25c08ff4ed4f1 ]

When handling transfer events the event is passed along the handling
callpath and parsed again in several occasions.

The event contains slot_id and endpoint index, from which the driver
endpoint structure can be found. There wasn't however a way to get the
endpoint index or parent usb device from this endpoint structure.

A lot of extra event parsing, and thus some DMA doublefetch cases,
and excess variables and code can be avoided by adding endpoint index
and parent usb virt device pointer to the endpoint structure.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c  |  2 ++
 drivers/usb/host/xhci-ring.c | 28 ++++++++--------------------
 drivers/usb/host/xhci.h      |  2 ++
 3 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index d1a42300ae58..002e4948993d 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1021,6 +1021,8 @@ int xhci_alloc_virt_device(struct xhci_hcd *xhci, int slot_id,
 
 	/* Initialize the cancellation list and watchdog timers for each ep */
 	for (i = 0; i < 31; i++) {
+		dev->eps[i].ep_index = i;
+		dev->eps[i].vdev = dev;
 		xhci_init_endpoint_timer(xhci, &dev->eps[i]);
 		INIT_LIST_HEAD(&dev->eps[i].cancelled_td_list);
 		INIT_LIST_HEAD(&dev->eps[i].bw_endpoint_list);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index fa3a7ac15f82..5cee7150376d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1936,7 +1936,7 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
 	 * Device will be reset soon to recover the link so don't do anything
 	 */
-	if (xhci->devs[slot_id]->flags & VDEV_PORT_ERROR)
+	if (ep->vdev->flags & VDEV_PORT_ERROR)
 		return;
 
 	command = xhci_alloc_command(xhci, false, GFP_ATOMIC);
@@ -2045,18 +2045,14 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	struct xhci_transfer_event *event,
 	struct xhci_virt_ep *ep, int *status)
 {
-	struct xhci_virt_device *xdev;
 	struct xhci_ep_ctx *ep_ctx;
 	struct xhci_ring *ep_ring;
 	unsigned int slot_id;
 	u32 trb_comp_code;
-	int ep_index;
 
 	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
-	xdev = xhci->devs[slot_id];
-	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
-	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
+	ep_ctx = xhci_get_ep_ctx(xhci, ep->vdev->out_ctx, ep->ep_index);
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 
 	if (trb_comp_code == COMP_STOPPED_LENGTH_INVALID ||
@@ -2081,9 +2077,9 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		 * stall later. Hub TT buffer should only be cleared for FS/LS
 		 * devices behind HS hubs for functional stalls.
 		 */
-		if ((ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
+		if ((ep->ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
 			xhci_clear_hub_tt_buffer(xhci, td, ep);
-		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
+		xhci_cleanup_halted_endpoint(xhci, slot_id, ep->ep_index,
 					ep_ring->stream_id, td, EP_HARD_RESET);
 	} else {
 		/* Update ring dequeue pointer */
@@ -2117,19 +2113,13 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
 	struct xhci_virt_ep *ep, int *status)
 {
-	struct xhci_virt_device *xdev;
-	unsigned int slot_id;
-	int ep_index;
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
 	u32 remaining, requested;
 	u32 trb_type;
 
 	trb_type = TRB_FIELD_TO_TYPE(le32_to_cpu(ep_trb->generic.field[3]));
-	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
-	xdev = xhci->devs[slot_id];
-	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
-	ep_ctx = xhci_get_ep_ctx(xhci, xdev->out_ctx, ep_index);
+	ep_ctx = xhci_get_ep_ctx(xhci, ep->vdev->out_ctx, ep->ep_index);
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	requested = td->urb->transfer_buffer_length;
 	remaining = EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
@@ -2177,7 +2167,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 						       ep_ctx, trb_comp_code))
 			break;
 		xhci_dbg(xhci, "TRB error %u, halted endpoint index = %u\n",
-			 trb_comp_code, ep_index);
+			 trb_comp_code, ep->ep_index);
 		fallthrough;
 	case COMP_STALL_ERROR:
 		/* Did we transfer part of the data (middle) phase? */
@@ -2339,11 +2329,9 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	u32 trb_comp_code;
 	u32 remaining, requested, ep_trb_len;
 	unsigned int slot_id;
-	int ep_index;
 
 	slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
-	slot_ctx = xhci_get_slot_ctx(xhci, xhci->devs[slot_id]->out_ctx);
-	ep_index = TRB_TO_EP_ID(le32_to_cpu(event->flags)) - 1;
+	slot_ctx = xhci_get_slot_ctx(xhci, ep->vdev->out_ctx);
 	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	remaining = EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
@@ -2382,7 +2370,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		    le32_to_cpu(slot_ctx->tt_info) & TT_SLOT)
 			break;
 		*status = 0;
-		xhci_cleanup_halted_endpoint(xhci, slot_id, ep_index,
+		xhci_cleanup_halted_endpoint(xhci, slot_id, ep->ep_index,
 					ep_ring->stream_id, td, EP_SOFT_RESET);
 		return 0;
 	default:
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 059050f13522..5fbd159f6fa5 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -924,6 +924,8 @@ struct xhci_bw_info {
 #define SS_BW_RESERVED		10
 
 struct xhci_virt_ep {
+	struct xhci_virt_device		*vdev;	/* parent */
+	unsigned int			ep_index;
 	struct xhci_ring		*ring;
 	/* Related to endpoints that are configured to use stream IDs only */
 	struct xhci_stream_info		*stream_info;
-- 
2.35.1




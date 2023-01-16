Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE9366C5D2
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjAPQKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbjAPQKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93BC298D2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89924B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB9EC433EF;
        Mon, 16 Jan 2023 16:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885197;
        bh=mmJGH3qKA4XYqplHXT50W9TRgTQvZGNX0DtIqJkaUow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fy8smI8+uU/nLV2zIfCAj0FYsYbwm5FEatAeMhzcfj5FdzHwJmVZHSIMGG3fQpFZd
         NpaVtk4wGvdff68sZvZp9Qvjm3HzmTC/46zExLkoDuxoLHwdCIFiYgryBcoERQyvaG
         Ju7GU9/QTzuEicrtSZHsvL8Hb5bKanOIzrJG0BXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/64] xhci: get isochronous ring directly from endpoint structure
Date:   Mon, 16 Jan 2023 16:51:32 +0100
Message-Id: <20230116154744.471346329@linuxfoundation.org>
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

[ Upstream commit d4dff8043ea5b93a30cb9b19d4407bd506a6877a ]

isochronous endpoints do not support streams, meaning that
there is only one ring per endpoint.

Avoid double-fetching the transfer event DMA to get the
ring. Also makes passing the event to skip_isoc_td() uncecessary.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 5cee7150376d..6d34c56376e5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2209,7 +2209,6 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
 	struct xhci_virt_ep *ep, int *status)
 {
-	struct xhci_ring *ep_ring;
 	struct urb_priv *urb_priv;
 	int idx;
 	struct usb_iso_packet_descriptor *frame;
@@ -2218,7 +2217,6 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	u32 remaining, requested, ep_trb_len;
 	int short_framestatus;
 
-	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	urb_priv = td->urb->hcpriv;
 	idx = urb_priv->num_tds_done;
@@ -2279,7 +2277,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	}
 
 	if (sum_trbs_for_length)
-		frame->actual_length = sum_trb_lengths(xhci, ep_ring, ep_trb) +
+		frame->actual_length = sum_trb_lengths(xhci, ep->ring, ep_trb) +
 			ep_trb_len - remaining;
 	else
 		frame->actual_length = requested;
@@ -2290,15 +2288,12 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 }
 
 static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
-			struct xhci_transfer_event *event,
 			struct xhci_virt_ep *ep, int *status)
 {
-	struct xhci_ring *ep_ring;
 	struct urb_priv *urb_priv;
 	struct usb_iso_packet_descriptor *frame;
 	int idx;
 
-	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	urb_priv = td->urb->hcpriv;
 	idx = urb_priv->num_tds_done;
 	frame = &td->urb->iso_frame_desc[idx];
@@ -2310,11 +2305,11 @@ static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	frame->actual_length = 0;
 
 	/* Update ring dequeue pointer */
-	while (ep_ring->dequeue != td->last_trb)
-		inc_deq(xhci, ep_ring);
-	inc_deq(xhci, ep_ring);
+	while (ep->ring->dequeue != td->last_trb)
+		inc_deq(xhci, ep->ring);
+	inc_deq(xhci, ep->ring);
 
-	return xhci_td_cleanup(xhci, td, ep_ring, status);
+	return xhci_td_cleanup(xhci, td, ep->ring, status);
 }
 
 /*
@@ -2693,7 +2688,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 				return -ESHUTDOWN;
 			}
 
-			skip_isoc_td(xhci, td, event, ep, &status);
+			skip_isoc_td(xhci, td, ep, &status);
 			goto cleanup;
 		}
 		if (trb_comp_code == COMP_SHORT_PACKET)
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34537877C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbhEJLPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236473AbhEJLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36ECB6199B;
        Mon, 10 May 2021 11:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644498;
        bh=mjHj9aXp8zL/4CbmtQ8hqd8JBWfk66CZHwupVyKWP18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dlq3qtSVCKKM1EcrZAzJnErNtiqPUVjWdVjsZPo4s7bw/EhF6AnwoHHWlWzDhKP/P
         tO+Q9AUH1FqjAFAyuDfF+11sAe7/RgXhzrvwK1tAG6JTdB1EIqYzxL3KnauVu+UuZx
         5luR10ir7XZbhsR+poACvd+1j90lUZUdnMVoEPmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 106/384] xhci: prevent double-fetch of transfer and transfer event TRBs
Date:   Mon, 10 May 2021 12:18:15 +0200
Message-Id: <20210510102018.381222868@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit e9fcb07704fcef6fa6d0333fd2b3a62442eaf45b ]

The same values are parsed several times from transfer and event
TRBs by different functions in the same call path, all while processing
one transfer event.

As the TRBs are in DMA memory and can be accessed by the xHC host we want
to avoid this to prevent double-fetch issues.

To resolve this pass the already parsed values to the different functions
in the path of parsing a transfer event

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210406070208.3406266-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 42 ++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index ce38076901e2..59d41d2c200d 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2129,16 +2129,13 @@ int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code)
 	return 0;
 }
 
-static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
-	struct xhci_transfer_event *event, struct xhci_virt_ep *ep)
+static int finish_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
+		     struct xhci_ring *ep_ring, struct xhci_td *td,
+		     u32 trb_comp_code)
 {
 	struct xhci_ep_ctx *ep_ctx;
-	struct xhci_ring *ep_ring;
-	u32 trb_comp_code;
 
-	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	ep_ctx = xhci_get_ep_ctx(xhci, ep->vdev->out_ctx, ep->ep_index);
-	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 
 	switch (trb_comp_code) {
 	case COMP_STOPPED_LENGTH_INVALID:
@@ -2234,9 +2231,9 @@ static int sum_trb_lengths(struct xhci_hcd *xhci, struct xhci_ring *ring,
 /*
  * Process control tds, update urb status and actual_length.
  */
-static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
-	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep)
+static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
+		struct xhci_ring *ep_ring,  struct xhci_td *td,
+			   union xhci_trb *ep_trb, struct xhci_transfer_event *event)
 {
 	struct xhci_ep_ctx *ep_ctx;
 	u32 trb_comp_code;
@@ -2324,15 +2321,15 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		td->urb->actual_length = requested;
 
 finish_td:
-	return finish_td(xhci, td, event, ep);
+	return finish_td(xhci, ep, ep_ring, td, trb_comp_code);
 }
 
 /*
  * Process isochronous tds, update urb packet status and actual_length.
  */
-static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
-	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep)
+static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
+		struct xhci_ring *ep_ring, struct xhci_td *td,
+		union xhci_trb *ep_trb, struct xhci_transfer_event *event)
 {
 	struct urb_priv *urb_priv;
 	int idx;
@@ -2409,7 +2406,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 
 	td->urb->actual_length += frame->actual_length;
 
-	return finish_td(xhci, td, event, ep);
+	return finish_td(xhci, ep, ep_ring, td, trb_comp_code);
 }
 
 static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
@@ -2441,17 +2438,15 @@ static int skip_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
 /*
  * Process bulk and interrupt tds, update urb status and actual_length.
  */
-static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
-	union xhci_trb *ep_trb, struct xhci_transfer_event *event,
-	struct xhci_virt_ep *ep)
+static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
+		struct xhci_ring *ep_ring, struct xhci_td *td,
+		union xhci_trb *ep_trb, struct xhci_transfer_event *event)
 {
 	struct xhci_slot_ctx *slot_ctx;
-	struct xhci_ring *ep_ring;
 	u32 trb_comp_code;
 	u32 remaining, requested, ep_trb_len;
 
 	slot_ctx = xhci_get_slot_ctx(xhci, ep->vdev->out_ctx);
-	ep_ring = xhci_dma_to_transfer_ring(ep, le64_to_cpu(event->buffer));
 	trb_comp_code = GET_COMP_CODE(le32_to_cpu(event->transfer_len));
 	remaining = EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
 	ep_trb_len = TRB_LEN(le32_to_cpu(ep_trb->generic.field[2]));
@@ -2511,7 +2506,8 @@ finish_td:
 			  remaining);
 		td->urb->actual_length = 0;
 	}
-	return finish_td(xhci, td, event, ep);
+
+	return finish_td(xhci, ep, ep_ring, td, trb_comp_code);
 }
 
 /*
@@ -2854,11 +2850,11 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 
 		/* update the urb's actual_length and give back to the core */
 		if (usb_endpoint_xfer_control(&td->urb->ep->desc))
-			process_ctrl_td(xhci, td, ep_trb, event, ep);
+			process_ctrl_td(xhci, ep, ep_ring, td, ep_trb, event);
 		else if (usb_endpoint_xfer_isoc(&td->urb->ep->desc))
-			process_isoc_td(xhci, td, ep_trb, event, ep);
+			process_isoc_td(xhci, ep, ep_ring, td, ep_trb, event);
 		else
-			process_bulk_intr_td(xhci, td, ep_trb, event, ep);
+			process_bulk_intr_td(xhci, ep, ep_ring, td, ep_trb, event);
 cleanup:
 		handling_skipped_tds = ep->skip &&
 			trb_comp_code != COMP_MISSED_SERVICE_ERROR &&
-- 
2.30.2




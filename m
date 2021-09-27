Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B00419A19
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbhI0RGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236007AbhI0RGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:06:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D29611C3;
        Mon, 27 Sep 2021 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762280;
        bh=fTqrMztZg0fHlYlgafgD1gVUVoD4FdxzF/Yoz/WirWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy0bBeCZC9TCeucRADRRea1R5i+Bz6UCnFHBGkO3T3rYVCsMVvtONGBAojARC8lVk
         BoDZpXY57+Y5jjMTp0VzosMlkcf9/RBFlC1JY1awfaCRDDsN3FRjYsPFo/UmoODQOU
         E/1v3Ux1fEQlM83HTtKxXb2vEOdJJoMyRoyUpbNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.4 03/68] usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave
Date:   Mon, 27 Sep 2021 19:01:59 +0200
Message-Id: <20210927170220.022626278@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 91bb163e1e4f88092f50dfaa5a816b658753e4b2 upstream.

According USB spec each ISOC transaction should be performed in a
designated for that transaction interval. On bus errors or delays
in operating system scheduling of client software can result in no
packet being transferred for a (micro)frame. An error indication
should be returned as status to the client software in such a case.

Current implementation in case of missed/dropped interval send same
data in next possible interval instead of reporting missed isoc.

This fix complete requests with -ENODATA if interval elapsed.

HSOTG core in BDMA and Slave modes haven't HW support for
(micro)frames tracking, this is why SW should care about tracking
of (micro)frames. Because of that method and consider operating
system scheduling delays, added few additional checking's of elapsed
target (micro)frame:
1. Immediately before enabling EP to start transfer.
2. With any transfer completion interrupt.
3. With incomplete isoc in/out interrupt.
4. With EP disabled interrupt because of incomplete transfer.
5. With OUT token received while EP disabled interrupt (for OUT
transfers).
6. With NAK replied to IN token interrupt (for IN transfers).

As part of ISOC flow, additionally fixed 'current' and 'target' frame
calculation functions. In HS mode SOF limits provided by DSTS register
is 0x3fff, but in non HS mode this limit is 0x7ff.

Tested by internal tool which also using for dwc3 testing.

Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/95d1423adf4b0f68187c9894820c4b7e964a3f7f.1631175721.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c |  189 +++++++++++++++++++++++++---------------------
 1 file changed, 106 insertions(+), 83 deletions(-)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -115,10 +115,16 @@ static inline bool using_desc_dma(struct
  */
 static inline void dwc2_gadget_incr_frame_num(struct dwc2_hsotg_ep *hs_ep)
 {
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
+	u16 limit = DSTS_SOFFN_LIMIT;
+
+	if (hsotg->gadget.speed != USB_SPEED_HIGH)
+		limit >>= 3;
+
 	hs_ep->target_frame += hs_ep->interval;
-	if (hs_ep->target_frame > DSTS_SOFFN_LIMIT) {
+	if (hs_ep->target_frame > limit) {
 		hs_ep->frame_overrun = true;
-		hs_ep->target_frame &= DSTS_SOFFN_LIMIT;
+		hs_ep->target_frame &= limit;
 	} else {
 		hs_ep->frame_overrun = false;
 	}
@@ -136,10 +142,16 @@ static inline void dwc2_gadget_incr_fram
  */
 static inline void dwc2_gadget_dec_frame_num_by_one(struct dwc2_hsotg_ep *hs_ep)
 {
+	struct dwc2_hsotg *hsotg = hs_ep->parent;
+	u16 limit = DSTS_SOFFN_LIMIT;
+
+	if (hsotg->gadget.speed != USB_SPEED_HIGH)
+		limit >>= 3;
+
 	if (hs_ep->target_frame)
 		hs_ep->target_frame -= 1;
 	else
-		hs_ep->target_frame = DSTS_SOFFN_LIMIT;
+		hs_ep->target_frame = limit;
 }
 
 /**
@@ -1018,6 +1030,12 @@ static void dwc2_gadget_start_isoc_ddma(
 	dwc2_writel(hsotg, ctrl, depctl);
 }
 
+static bool dwc2_gadget_target_frame_elapsed(struct dwc2_hsotg_ep *hs_ep);
+static void dwc2_hsotg_complete_request(struct dwc2_hsotg *hsotg,
+					struct dwc2_hsotg_ep *hs_ep,
+				       struct dwc2_hsotg_req *hs_req,
+				       int result);
+
 /**
  * dwc2_hsotg_start_req - start a USB request from an endpoint's queue
  * @hsotg: The controller state.
@@ -1170,14 +1188,19 @@ static void dwc2_hsotg_start_req(struct
 		}
 	}
 
-	if (hs_ep->isochronous && hs_ep->interval == 1) {
-		hs_ep->target_frame = dwc2_hsotg_read_frameno(hsotg);
-		dwc2_gadget_incr_frame_num(hs_ep);
-
-		if (hs_ep->target_frame & 0x1)
-			ctrl |= DXEPCTL_SETODDFR;
-		else
-			ctrl |= DXEPCTL_SETEVENFR;
+	if (hs_ep->isochronous) {
+		if (!dwc2_gadget_target_frame_elapsed(hs_ep)) {
+			if (hs_ep->interval == 1) {
+				if (hs_ep->target_frame & 0x1)
+					ctrl |= DXEPCTL_SETODDFR;
+				else
+					ctrl |= DXEPCTL_SETEVENFR;
+			}
+			ctrl |= DXEPCTL_CNAK;
+		} else {
+			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
+			return;
+		}
 	}
 
 	ctrl |= DXEPCTL_EPENA;	/* ensure ep enabled */
@@ -1325,12 +1348,16 @@ static bool dwc2_gadget_target_frame_ela
 	u32 target_frame = hs_ep->target_frame;
 	u32 current_frame = hsotg->frame_number;
 	bool frame_overrun = hs_ep->frame_overrun;
+	u16 limit = DSTS_SOFFN_LIMIT;
+
+	if (hsotg->gadget.speed != USB_SPEED_HIGH)
+		limit >>= 3;
 
 	if (!frame_overrun && current_frame >= target_frame)
 		return true;
 
 	if (frame_overrun && current_frame >= target_frame &&
-	    ((current_frame - target_frame) < DSTS_SOFFN_LIMIT / 2))
+	    ((current_frame - target_frame) < limit / 2))
 		return true;
 
 	return false;
@@ -1712,11 +1739,9 @@ static struct dwc2_hsotg_req *get_ep_hea
  */
 static void dwc2_gadget_start_next_request(struct dwc2_hsotg_ep *hs_ep)
 {
-	u32 mask;
 	struct dwc2_hsotg *hsotg = hs_ep->parent;
 	int dir_in = hs_ep->dir_in;
 	struct dwc2_hsotg_req *hs_req;
-	u32 epmsk_reg = dir_in ? DIEPMSK : DOEPMSK;
 
 	if (!list_empty(&hs_ep->queue)) {
 		hs_req = get_ep_head(hs_ep);
@@ -1732,9 +1757,6 @@ static void dwc2_gadget_start_next_reque
 	} else {
 		dev_dbg(hsotg->dev, "%s: No more ISOC-OUT requests\n",
 			__func__);
-		mask = dwc2_readl(hsotg, epmsk_reg);
-		mask |= DOEPMSK_OUTTKNEPDISMSK;
-		dwc2_writel(hsotg, mask, epmsk_reg);
 	}
 }
 
@@ -2304,19 +2326,6 @@ static void dwc2_hsotg_ep0_zlp(struct dw
 	dwc2_hsotg_program_zlp(hsotg, hsotg->eps_out[0]);
 }
 
-static void dwc2_hsotg_change_ep_iso_parity(struct dwc2_hsotg *hsotg,
-					    u32 epctl_reg)
-{
-	u32 ctrl;
-
-	ctrl = dwc2_readl(hsotg, epctl_reg);
-	if (ctrl & DXEPCTL_EOFRNUM)
-		ctrl |= DXEPCTL_SETEVENFR;
-	else
-		ctrl |= DXEPCTL_SETODDFR;
-	dwc2_writel(hsotg, ctrl, epctl_reg);
-}
-
 /*
  * dwc2_gadget_get_xfersize_ddma - get transferred bytes amount from desc
  * @hs_ep - The endpoint on which transfer went
@@ -2437,20 +2446,11 @@ static void dwc2_hsotg_handle_outdone(st
 			dwc2_hsotg_ep0_zlp(hsotg, true);
 	}
 
-	/*
-	 * Slave mode OUT transfers do not go through XferComplete so
-	 * adjust the ISOC parity here.
-	 */
-	if (!using_dma(hsotg)) {
-		if (hs_ep->isochronous && hs_ep->interval == 1)
-			dwc2_hsotg_change_ep_iso_parity(hsotg, DOEPCTL(epnum));
-		else if (hs_ep->isochronous && hs_ep->interval > 1)
-			dwc2_gadget_incr_frame_num(hs_ep);
-	}
-
 	/* Set actual frame number for completed transfers */
-	if (!using_desc_dma(hsotg) && hs_ep->isochronous)
-		req->frame_number = hsotg->frame_number;
+	if (!using_desc_dma(hsotg) && hs_ep->isochronous) {
+		req->frame_number = hs_ep->target_frame;
+		dwc2_gadget_incr_frame_num(hs_ep);
+	}
 
 	dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, result);
 }
@@ -2764,6 +2764,12 @@ static void dwc2_hsotg_complete_in(struc
 		return;
 	}
 
+	/* Set actual frame number for completed transfers */
+	if (!using_desc_dma(hsotg) && hs_ep->isochronous) {
+		hs_req->req.frame_number = hs_ep->target_frame;
+		dwc2_gadget_incr_frame_num(hs_ep);
+	}
+
 	dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, 0);
 }
 
@@ -2824,23 +2830,18 @@ static void dwc2_gadget_handle_ep_disabl
 
 		dwc2_hsotg_txfifo_flush(hsotg, hs_ep->fifo_index);
 
-		if (hs_ep->isochronous) {
-			dwc2_hsotg_complete_in(hsotg, hs_ep);
-			return;
-		}
-
 		if ((epctl & DXEPCTL_STALL) && (epctl & DXEPCTL_EPTYPE_BULK)) {
 			int dctl = dwc2_readl(hsotg, DCTL);
 
 			dctl |= DCTL_CGNPINNAK;
 			dwc2_writel(hsotg, dctl, DCTL);
 		}
-		return;
-	}
+	} else {
 
-	if (dctl & DCTL_GOUTNAKSTS) {
-		dctl |= DCTL_CGOUTNAK;
-		dwc2_writel(hsotg, dctl, DCTL);
+		if (dctl & DCTL_GOUTNAKSTS) {
+			dctl |= DCTL_CGOUTNAK;
+			dwc2_writel(hsotg, dctl, DCTL);
+		}
 	}
 
 	if (!hs_ep->isochronous)
@@ -2861,8 +2862,6 @@ static void dwc2_gadget_handle_ep_disabl
 		/* Update current frame number value. */
 		hsotg->frame_number = dwc2_hsotg_read_frameno(hsotg);
 	} while (dwc2_gadget_target_frame_elapsed(hs_ep));
-
-	dwc2_gadget_start_next_request(hs_ep);
 }
 
 /**
@@ -2879,8 +2878,8 @@ static void dwc2_gadget_handle_ep_disabl
 static void dwc2_gadget_handle_out_token_ep_disabled(struct dwc2_hsotg_ep *ep)
 {
 	struct dwc2_hsotg *hsotg = ep->parent;
+	struct dwc2_hsotg_req *hs_req;
 	int dir_in = ep->dir_in;
-	u32 doepmsk;
 
 	if (dir_in || !ep->isochronous)
 		return;
@@ -2894,28 +2893,39 @@ static void dwc2_gadget_handle_out_token
 		return;
 	}
 
-	if (ep->interval > 1 &&
-	    ep->target_frame == TARGET_FRAME_INITIAL) {
+	if (ep->target_frame == TARGET_FRAME_INITIAL) {
 		u32 ctrl;
 
 		ep->target_frame = hsotg->frame_number;
-		dwc2_gadget_incr_frame_num(ep);
+		if (ep->interval > 1) {
+			ctrl = dwc2_readl(hsotg, DOEPCTL(ep->index));
+			if (ep->target_frame & 0x1)
+				ctrl |= DXEPCTL_SETODDFR;
+			else
+				ctrl |= DXEPCTL_SETEVENFR;
 
-		ctrl = dwc2_readl(hsotg, DOEPCTL(ep->index));
-		if (ep->target_frame & 0x1)
-			ctrl |= DXEPCTL_SETODDFR;
-		else
-			ctrl |= DXEPCTL_SETEVENFR;
+			dwc2_writel(hsotg, ctrl, DOEPCTL(ep->index));
+		}
+	}
+
+	while (dwc2_gadget_target_frame_elapsed(ep)) {
+		hs_req = get_ep_head(ep);
+		if (hs_req)
+			dwc2_hsotg_complete_request(hsotg, ep, hs_req, -ENODATA);
 
-		dwc2_writel(hsotg, ctrl, DOEPCTL(ep->index));
+		dwc2_gadget_incr_frame_num(ep);
+		/* Update current frame number value. */
+		hsotg->frame_number = dwc2_hsotg_read_frameno(hsotg);
 	}
 
-	dwc2_gadget_start_next_request(ep);
-	doepmsk = dwc2_readl(hsotg, DOEPMSK);
-	doepmsk &= ~DOEPMSK_OUTTKNEPDISMSK;
-	dwc2_writel(hsotg, doepmsk, DOEPMSK);
+	if (!ep->req)
+		dwc2_gadget_start_next_request(ep);
+
 }
 
+static void dwc2_hsotg_ep_stop_xfr(struct dwc2_hsotg *hsotg,
+				   struct dwc2_hsotg_ep *hs_ep);
+
 /**
  * dwc2_gadget_handle_nak - handle NAK interrupt
  * @hs_ep: The endpoint on which interrupt is asserted.
@@ -2933,7 +2943,9 @@ static void dwc2_gadget_handle_out_token
 static void dwc2_gadget_handle_nak(struct dwc2_hsotg_ep *hs_ep)
 {
 	struct dwc2_hsotg *hsotg = hs_ep->parent;
+	struct dwc2_hsotg_req *hs_req;
 	int dir_in = hs_ep->dir_in;
+	u32 ctrl;
 
 	if (!dir_in || !hs_ep->isochronous)
 		return;
@@ -2975,13 +2987,29 @@ static void dwc2_gadget_handle_nak(struc
 
 			dwc2_writel(hsotg, ctrl, DIEPCTL(hs_ep->index));
 		}
-
-		dwc2_hsotg_complete_request(hsotg, hs_ep,
-					    get_ep_head(hs_ep), 0);
 	}
 
-	if (!using_desc_dma(hsotg))
+	if (using_desc_dma(hsotg))
+		return;
+
+	ctrl = dwc2_readl(hsotg, DIEPCTL(hs_ep->index));
+	if (ctrl & DXEPCTL_EPENA)
+		dwc2_hsotg_ep_stop_xfr(hsotg, hs_ep);
+	else
+		dwc2_hsotg_txfifo_flush(hsotg, hs_ep->fifo_index);
+
+	while (dwc2_gadget_target_frame_elapsed(hs_ep)) {
+		hs_req = get_ep_head(hs_ep);
+		if (hs_req)
+			dwc2_hsotg_complete_request(hsotg, hs_ep, hs_req, -ENODATA);
+
 		dwc2_gadget_incr_frame_num(hs_ep);
+		/* Update current frame number value. */
+		hsotg->frame_number = dwc2_hsotg_read_frameno(hsotg);
+	}
+
+	if (!hs_ep->req)
+		dwc2_gadget_start_next_request(hs_ep);
 }
 
 /**
@@ -3048,12 +3076,8 @@ static void dwc2_hsotg_epint(struct dwc2
 			 * need to look at completing IN requests here
 			 * if operating slave mode
 			 */
-			if (hs_ep->isochronous && hs_ep->interval > 1)
-				dwc2_gadget_incr_frame_num(hs_ep);
-
-			dwc2_hsotg_complete_in(hsotg, hs_ep);
-			if (ints & DXEPINT_NAKINTRPT)
-				ints &= ~DXEPINT_NAKINTRPT;
+			if (!hs_ep->isochronous || !(ints & DXEPINT_NAKINTRPT))
+				dwc2_hsotg_complete_in(hsotg, hs_ep);
 
 			if (idx == 0 && !hs_ep->req)
 				dwc2_hsotg_enqueue_setup(hsotg);
@@ -3062,10 +3086,8 @@ static void dwc2_hsotg_epint(struct dwc2
 			 * We're using DMA, we need to fire an OutDone here
 			 * as we ignore the RXFIFO.
 			 */
-			if (hs_ep->isochronous && hs_ep->interval > 1)
-				dwc2_gadget_incr_frame_num(hs_ep);
-
-			dwc2_hsotg_handle_outdone(hsotg, idx);
+			if (!hs_ep->isochronous || !(ints & DXEPINT_OUTTKNEPDIS))
+				dwc2_hsotg_handle_outdone(hsotg, idx);
 		}
 	}
 
@@ -4055,6 +4077,7 @@ static int dwc2_hsotg_ep_enable(struct u
 			mask |= DIEPMSK_NAKMSK;
 			dwc2_writel(hsotg, mask, DIEPMSK);
 		} else {
+			epctrl |= DXEPCTL_SNAK;
 			mask = dwc2_readl(hsotg, DOEPMSK);
 			mask |= DOEPMSK_OUTTKNEPDISMSK;
 			dwc2_writel(hsotg, mask, DOEPMSK);



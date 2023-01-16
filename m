Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53B566C5DB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjAPQLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjAPQKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD79298F4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C927F6102F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC937C433F1;
        Mon, 16 Jan 2023 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885210;
        bh=bDcatN90bVcVFprsN3lbVFuFnSkUmu134nJwshdttxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eWZHwdhHWjjRrW4cT9axoN/uaj7YH9dW8DZj5NsRLbNLsDkUxh+x/HdTorf3Mi8Ny
         77tBmoee9iWolYV7H3nMOTaPD4Cn8nKYu6Y1ILrDZxwa811tXwNfiFk2ws8HKB8Whk
         KLqgj77YiIqi3AX6zMw0TlAgNRCjJ/8prvwQ2wUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/64] xhci: move and rename xhci_cleanup_halted_endpoint()
Date:   Mon, 16 Jan 2023 16:51:37 +0100
Message-Id: <20230116154744.629882826@linuxfoundation.org>
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

[ Upstream commit 7c6c334e6fc8cd99e780fd74cd29687886a81862 ]

Halted endpoints can be discoverd both when handling transfer events and
command completion events. Move code that handles halted endpoints before
both of those event handlers.

Rename the function to xhci_handle_halted_ep() to better describe
what it does. Try to reserve "cleanup" word in function names for last
stage cleanup activities.

No functional changes

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-21-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 84 ++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 41 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2bd407ff9f0b..edb712081815 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -839,6 +839,35 @@ static int xhci_reset_halted_ep(struct xhci_hcd *xhci, unsigned int slot_id,
 	return ret;
 }
 
+static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
+				struct xhci_virt_ep *ep, unsigned int stream_id,
+				struct xhci_td *td,
+				enum xhci_ep_reset_type reset_type)
+{
+	unsigned int slot_id = ep->vdev->slot_id;
+	int err;
+
+	/*
+	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
+	 * Device will be reset soon to recover the link so don't do anything
+	 */
+	if (ep->vdev->flags & VDEV_PORT_ERROR)
+		return;
+
+	ep->ep_state |= EP_HALTED;
+
+	err = xhci_reset_halted_ep(xhci, slot_id, ep->ep_index, reset_type);
+	if (err)
+		return;
+
+	if (reset_type == EP_HARD_RESET) {
+		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
+		xhci_cleanup_stalled_ring(xhci, slot_id, ep->ep_index, stream_id,
+					  td);
+	}
+	xhci_ring_cmd_db(xhci);
+}
+
 /*
  * When we get a command completion for a Stop Endpoint Command, we need to
  * unlink any cancelled TDs from the ring.  There are two ways to do that:
@@ -1990,35 +2019,6 @@ static void xhci_clear_hub_tt_buffer(struct xhci_hcd *xhci, struct xhci_td *td,
 	}
 }
 
-static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
-				struct xhci_virt_ep *ep, unsigned int stream_id,
-				struct xhci_td *td,
-				enum xhci_ep_reset_type reset_type)
-{
-	unsigned int slot_id = ep->vdev->slot_id;
-	int err;
-
-	/*
-	 * Avoid resetting endpoint if link is inactive. Can cause host hang.
-	 * Device will be reset soon to recover the link so don't do anything
-	 */
-	if (ep->vdev->flags & VDEV_PORT_ERROR)
-		return;
-
-	ep->ep_state |= EP_HALTED;
-
-	err = xhci_reset_halted_ep(xhci, slot_id, ep->ep_index, reset_type);
-	if (err)
-		return;
-
-	if (reset_type == EP_HARD_RESET) {
-		ep->ep_state |= EP_HARD_CLEAR_TOGGLE;
-		xhci_cleanup_stalled_ring(xhci, slot_id, ep->ep_index, stream_id,
-					  td);
-	}
-	xhci_ring_cmd_db(xhci);
-}
-
 /* Check if an error has halted the endpoint ring.  The class driver will
  * cleanup the halt for a non-default control endpoint if we indicate a stall.
  * However, a babble and other errors also halt the endpoint ring, and the class
@@ -2094,7 +2094,8 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		 */
 		if ((ep->ep_index != 0) || (trb_comp_code != COMP_STALL_ERROR))
 			xhci_clear_hub_tt_buffer(xhci, td, ep);
-		xhci_cleanup_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
+
+		xhci_handle_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
 					     EP_HARD_RESET);
 	} else {
 		/* Update ring dequeue pointer */
@@ -2379,8 +2380,9 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 			break;
 
 		td->status = 0;
-		xhci_cleanup_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
-					     EP_SOFT_RESET);
+
+		xhci_handle_halted_endpoint(xhci, ep, ep_ring->stream_id, td,
+					    EP_SOFT_RESET);
 		return 0;
 	default:
 		/* do nothing */
@@ -2455,8 +2457,8 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 		case COMP_USB_TRANSACTION_ERROR:
 		case COMP_INVALID_STREAM_TYPE_ERROR:
 		case COMP_INVALID_STREAM_ID_ERROR:
-			xhci_cleanup_halted_endpoint(xhci, ep, 0, NULL,
-						     EP_SOFT_RESET);
+			xhci_handle_halted_endpoint(xhci, ep, 0, NULL,
+						    EP_SOFT_RESET);
 			goto cleanup;
 		case COMP_RING_UNDERRUN:
 		case COMP_RING_OVERRUN:
@@ -2639,10 +2641,10 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 							      trb_comp_code)) {
-				xhci_cleanup_halted_endpoint(xhci, ep,
-							     ep_ring->stream_id,
-							     NULL,
-							     EP_HARD_RESET);
+				xhci_handle_halted_endpoint(xhci, ep,
+							    ep_ring->stream_id,
+							    NULL,
+							    EP_HARD_RESET);
 			}
 			goto cleanup;
 		}
@@ -2734,9 +2736,9 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 			if (trb_comp_code == COMP_STALL_ERROR ||
 			    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
 							      trb_comp_code))
-				xhci_cleanup_halted_endpoint(xhci, ep,
-							     ep_ring->stream_id,
-							     td, EP_HARD_RESET);
+				xhci_handle_halted_endpoint(xhci, ep,
+							    ep_ring->stream_id,
+							    td, EP_HARD_RESET);
 			goto cleanup;
 		}
 
-- 
2.35.1




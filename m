Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2DE66C5D9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjAPQL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjAPQKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F152D298E2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BA6E60FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53EEC433F1;
        Mon, 16 Jan 2023 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885205;
        bh=r7LWjY7KDnQqI/bpebbUExV6jsnzHphMPFsTTJnaVKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUZc+xJ8NujZICDgj5sKJx0aBHr+MiXo/8/Oe1UU4cOUjGLz7ct5704ew8GxxpiEg
         z+1uA4vhYB4tsZuZXw87sh0KzQjx7z6jHQCsCoswrKOyijh6t7iJ1jMFEGhPj5b+CA
         hKti62lRCp0AvE1wun38/mdVJKNS67qvWpmzCtNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/64] xhci: move xhci_td_cleanup so it can be called by more functions
Date:   Mon, 16 Jan 2023 16:51:35 +0100
Message-Id: <20230116154744.569082636@linuxfoundation.org>
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

[ Upstream commit 69eaf9e79fa7c7ff4b1eb626493ce5a81e467520 ]

No funtional changes

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210129130044.206855-17-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1575120972e ("xhci: Prevent infinite loop in transaction errors recovery for streams")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 92 ++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index b4a510450ac2..d523cbe7fcf1 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -773,6 +773,52 @@ static void xhci_unmap_td_bounce_buffer(struct xhci_hcd *xhci,
 	seg->bounce_offs = 0;
 }
 
+static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
+		struct xhci_ring *ep_ring, int *status)
+{
+	struct urb *urb = NULL;
+
+	/* Clean up the endpoint's TD list */
+	urb = td->urb;
+
+	/* if a bounce buffer was used to align this td then unmap it */
+	xhci_unmap_td_bounce_buffer(xhci, ep_ring, td);
+
+	/* Do one last check of the actual transfer length.
+	 * If the host controller said we transferred more data than the buffer
+	 * length, urb->actual_length will be a very big number (since it's
+	 * unsigned).  Play it safe and say we didn't transfer anything.
+	 */
+	if (urb->actual_length > urb->transfer_buffer_length) {
+		xhci_warn(xhci, "URB req %u and actual %u transfer length mismatch\n",
+			  urb->transfer_buffer_length, urb->actual_length);
+		urb->actual_length = 0;
+		*status = 0;
+	}
+	list_del_init(&td->td_list);
+	/* Was this TD slated to be cancelled but completed anyway? */
+	if (!list_empty(&td->cancelled_td_list))
+		list_del_init(&td->cancelled_td_list);
+
+	inc_td_cnt(urb);
+	/* Giveback the urb when all the tds are completed */
+	if (last_td_in_urb(td)) {
+		if ((urb->actual_length != urb->transfer_buffer_length &&
+		     (urb->transfer_flags & URB_SHORT_NOT_OK)) ||
+		    (*status != 0 && !usb_endpoint_xfer_isoc(&urb->ep->desc)))
+			xhci_dbg(xhci, "Giveback URB %p, len = %d, expected = %d, status = %d\n",
+				 urb, urb->actual_length,
+				 urb->transfer_buffer_length, *status);
+
+		/* set isoc urb status to 0 just as EHCI, UHCI, and OHCI */
+		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
+			*status = 0;
+		xhci_giveback_urb_in_irq(xhci, td, *status);
+	}
+
+	return 0;
+}
+
 static int xhci_reset_halted_ep(struct xhci_hcd *xhci, unsigned int slot_id,
 				unsigned int ep_index, enum xhci_ep_reset_type reset_type)
 {
@@ -2013,52 +2059,6 @@ int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code)
 	return 0;
 }
 
-static int xhci_td_cleanup(struct xhci_hcd *xhci, struct xhci_td *td,
-		struct xhci_ring *ep_ring, int *status)
-{
-	struct urb *urb = NULL;
-
-	/* Clean up the endpoint's TD list */
-	urb = td->urb;
-
-	/* if a bounce buffer was used to align this td then unmap it */
-	xhci_unmap_td_bounce_buffer(xhci, ep_ring, td);
-
-	/* Do one last check of the actual transfer length.
-	 * If the host controller said we transferred more data than the buffer
-	 * length, urb->actual_length will be a very big number (since it's
-	 * unsigned).  Play it safe and say we didn't transfer anything.
-	 */
-	if (urb->actual_length > urb->transfer_buffer_length) {
-		xhci_warn(xhci, "URB req %u and actual %u transfer length mismatch\n",
-			  urb->transfer_buffer_length, urb->actual_length);
-		urb->actual_length = 0;
-		*status = 0;
-	}
-	list_del_init(&td->td_list);
-	/* Was this TD slated to be cancelled but completed anyway? */
-	if (!list_empty(&td->cancelled_td_list))
-		list_del_init(&td->cancelled_td_list);
-
-	inc_td_cnt(urb);
-	/* Giveback the urb when all the tds are completed */
-	if (last_td_in_urb(td)) {
-		if ((urb->actual_length != urb->transfer_buffer_length &&
-		     (urb->transfer_flags & URB_SHORT_NOT_OK)) ||
-		    (*status != 0 && !usb_endpoint_xfer_isoc(&urb->ep->desc)))
-			xhci_dbg(xhci, "Giveback URB %p, len = %d, expected = %d, status = %d\n",
-				 urb, urb->actual_length,
-				 urb->transfer_buffer_length, *status);
-
-		/* set isoc urb status to 0 just as EHCI, UHCI, and OHCI */
-		if (usb_pipetype(urb->pipe) == PIPE_ISOCHRONOUS)
-			*status = 0;
-		xhci_giveback_urb_in_irq(xhci, td, *status);
-	}
-
-	return 0;
-}
-
 static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 	struct xhci_transfer_event *event,
 	struct xhci_virt_ep *ep, int *status)
-- 
2.35.1




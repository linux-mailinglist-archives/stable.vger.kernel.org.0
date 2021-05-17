Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66C5383217
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhEQOqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241229AbhEQOnX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:43:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C21613B9;
        Mon, 17 May 2021 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261216;
        bh=4fC5HsOTKcLEAtG19XwQO4teDrxBG44yjknxmcT/IcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md0iSO58Ehko6nCA68m2dsy8YtSqLc+2aUIbA2kfF/dywY7fUQPeSbnaM2Ik1c5Rs
         PlmQFrxGNQaRC8zALiDXb19bkwQMP1tLz4ZhXXwgdBmx3vqFlRQWSua93K4c+WQRbQ
         9dVUKCUfy95mJJjwW/3UpnXKXO4YG3qXxLW8lLGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.12 320/363] xhci: Fix giving back cancelled URBs even if halted endpoint cant reset
Date:   Mon, 17 May 2021 16:03:06 +0200
Message-Id: <20210517140313.421104428@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 9b6a126ae58d9edfdde2d5f2e87f7615ea5e0155 upstream.

Commit 9ebf30007858 ("xhci: Fix halted endpoint at stop endpoint command
completion") in 5.12 changes how cancelled URBs are given back.

To cancel a URB xhci driver needs to stop the endpoint first.
To clear a halted endpoint xhci driver needs to reset the endpoint.

In rare cases when an endpoint halt (error) races with a endpoint stop we
need to clear the reset before removing, and giving back the cancelled URB.

The above change in 5.12 takes care of this, but it also relies on the
reset endpoint completion handler to give back the cancelled URBs.

There are cases when driver refuses to queue reset endpoint commands,
for example when a link suddenly goes to an inactive error state.
In this case the cancelled URB is never given back.

Fix this by giving back the URB in the stop endpoint if queuing a reset
endpoint command fails.

Fixes: 9ebf30007858 ("xhci: Fix halted endpoint at stop endpoint command completion")
CC: <stable@vger.kernel.org> # 5.12
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -863,7 +863,7 @@ done:
 	return ret;
 }
 
-static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
+static int xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 				struct xhci_virt_ep *ep, unsigned int stream_id,
 				struct xhci_td *td,
 				enum xhci_ep_reset_type reset_type)
@@ -876,7 +876,7 @@ static void xhci_handle_halted_endpoint(
 	 * Device will be reset soon to recover the link so don't do anything
 	 */
 	if (ep->vdev->flags & VDEV_PORT_ERROR)
-		return;
+		return -ENODEV;
 
 	/* add td to cancelled list and let reset ep handler take care of it */
 	if (reset_type == EP_HARD_RESET) {
@@ -889,16 +889,18 @@ static void xhci_handle_halted_endpoint(
 
 	if (ep->ep_state & EP_HALTED) {
 		xhci_dbg(xhci, "Reset ep command already pending\n");
-		return;
+		return 0;
 	}
 
 	err = xhci_reset_halted_ep(xhci, slot_id, ep->ep_index, reset_type);
 	if (err)
-		return;
+		return err;
 
 	ep->ep_state |= EP_HALTED;
 
 	xhci_ring_cmd_db(xhci);
+
+	return 0;
 }
 
 /*
@@ -1015,6 +1017,7 @@ static void xhci_handle_cmd_stop_ep(stru
 	struct xhci_td *td = NULL;
 	enum xhci_ep_reset_type reset_type;
 	struct xhci_command *command;
+	int err;
 
 	if (unlikely(TRB_TO_SUSPEND_PORT(le32_to_cpu(trb->generic.field[3])))) {
 		if (!xhci->devs[slot_id])
@@ -1059,7 +1062,10 @@ static void xhci_handle_cmd_stop_ep(stru
 					td->status = -EPROTO;
 			}
 			/* reset ep, reset handler cleans up cancelled tds */
-			xhci_handle_halted_endpoint(xhci, ep, 0, td, reset_type);
+			err = xhci_handle_halted_endpoint(xhci, ep, 0, td,
+							  reset_type);
+			if (err)
+				break;
 			xhci_stop_watchdog_timer_in_irq(xhci, ep);
 			return;
 		case EP_STATE_RUNNING:



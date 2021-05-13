Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F26A37F824
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 14:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhEMMtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 08:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhEMMtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 08:49:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04745613CA;
        Thu, 13 May 2021 12:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620910084;
        bh=Ozur7Lwm5pRblfQz6wkABeEn8JA0LUYKBqLIBoAdRdw=;
        h=Subject:To:From:Date:From;
        b=e2lN/7gfxgOV+3ffm9a1t58i9ympNqk5/Ydn0czP8BzUqbZ0UzuQJ3slXLU6ihe01
         b1NznTp1EA2FbIMCNrZ8KlDlW4zWkyZx+EutNCuk0UGpHpfErTBY1Z9oaXRVDlca9r
         /gFM74U2ptDZLVuIqcMlyatWpGuXt6mMDiAW2dok=
Subject: patch "xhci: Fix giving back cancelled URBs even if halted endpoint can't" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 14:47:54 +0200
Message-ID: <162091007411342@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix giving back cancelled URBs even if halted endpoint can't

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9b6a126ae58d9edfdde2d5f2e87f7615ea5e0155 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Wed, 12 May 2021 11:08:13 +0300
Subject: xhci: Fix giving back cancelled URBs even if halted endpoint can't
 reset

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
 drivers/usb/host/xhci-ring.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 05c38dd3ee36..a8e4189277da 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -862,7 +862,7 @@ static int xhci_reset_halted_ep(struct xhci_hcd *xhci, unsigned int slot_id,
 	return ret;
 }
 
-static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
+static int xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 				struct xhci_virt_ep *ep, unsigned int stream_id,
 				struct xhci_td *td,
 				enum xhci_ep_reset_type reset_type)
@@ -875,7 +875,7 @@ static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 	 * Device will be reset soon to recover the link so don't do anything
 	 */
 	if (ep->vdev->flags & VDEV_PORT_ERROR)
-		return;
+		return -ENODEV;
 
 	/* add td to cancelled list and let reset ep handler take care of it */
 	if (reset_type == EP_HARD_RESET) {
@@ -888,16 +888,18 @@ static void xhci_handle_halted_endpoint(struct xhci_hcd *xhci,
 
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
@@ -1014,6 +1016,7 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
 	struct xhci_td *td = NULL;
 	enum xhci_ep_reset_type reset_type;
 	struct xhci_command *command;
+	int err;
 
 	if (unlikely(TRB_TO_SUSPEND_PORT(le32_to_cpu(trb->generic.field[3])))) {
 		if (!xhci->devs[slot_id])
@@ -1058,7 +1061,10 @@ static void xhci_handle_cmd_stop_ep(struct xhci_hcd *xhci, int slot_id,
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
-- 
2.31.1



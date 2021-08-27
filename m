Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52873F956A
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 09:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbhH0HuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 03:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244460AbhH0HuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 03:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCF0860F42;
        Fri, 27 Aug 2021 07:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630050559;
        bh=ibErO/t2DN91UEN1QoD2rDjYzBO3m0w6/eOEFiufOnU=;
        h=Subject:To:From:Date:From;
        b=TqLRMTmNJ/58J/SnApMBLt0N32UhasyfJjrawaMPvBdLskaNDs4xvjyZxzVzSigY6
         QEf+3juVNdcZGXEdrn22dZ+WAtqsJgJl878LuntSo8mTGHbe7M2JgsAUwQ/ucSUDyJ
         u0CRzOP58b7yNLsZpVU6PSC8vPoQlM49RRlUxkkg=
Subject: patch "xhci: Fix failure to give back some cached cancelled URBs." added to usb-next
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, wat@codeaurora.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Aug 2021 09:41:00 +0200
Message-ID: <1630050060176132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix failure to give back some cached cancelled URBs.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 94f339147fc3eb9edef7ee4ef6e39c569c073753 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 20 Aug 2021 15:35:00 +0300
Subject: xhci: Fix failure to give back some cached cancelled URBs.

Only TDs with status TD_CLEARING_CACHE will be given back after
cache is cleared with a set TR deq command.

xhci_invalidate_cached_td() failed to set the TD_CLEARING_CACHE status
for some cancelled TDs as it assumed an endpoint only needs to clear the
TD it stopped on.

This isn't always true. For example with streams enabled an endpoint may
have several stream rings, each stopping on a different TDs.

Note that if an endpoint has several stream rings, the current code
will still only clear the cache of the stream pointed to by the last
cancelled TD in the cancel list.

This patch only focus on making sure all canceled TDs are given back,
avoiding hung task after device removal.
Another fix to solve clearing the caches of all stream rings with
cancelled TDs is needed, but not as urgent.

This issue was simultanously discovered and debugged by
by Tao Wang, with a slightly different fix proposal.

Fixes: 674f8438c121 ("xhci: split handling halted endpoints into two steps")
Cc: <stable@vger.kernel.org> #5.12
Reported-by: Tao Wang <wat@codeaurora.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210820123503.2605901-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-ring.c | 40 ++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d0faa67a689d..9017986241f5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -942,17 +942,21 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 					 td->urb->stream_id);
 		hw_deq &= ~0xf;
 
-		if (td->cancel_status == TD_HALTED) {
-			cached_td = td;
-		} else if (trb_in_td(xhci, td->start_seg, td->first_trb,
-			      td->last_trb, hw_deq, false)) {
+		if (td->cancel_status == TD_HALTED ||
+		    trb_in_td(xhci, td->start_seg, td->first_trb, td->last_trb, hw_deq, false)) {
 			switch (td->cancel_status) {
 			case TD_CLEARED: /* TD is already no-op */
 			case TD_CLEARING_CACHE: /* set TR deq command already queued */
 				break;
 			case TD_DIRTY: /* TD is cached, clear it */
 			case TD_HALTED:
-				/* FIXME  stream case, several stopped rings */
+				td->cancel_status = TD_CLEARING_CACHE;
+				if (cached_td)
+					/* FIXME  stream case, several stopped rings */
+					xhci_dbg(xhci,
+						 "Move dq past stream %u URB %p instead of stream %u URB %p\n",
+						 td->urb->stream_id, td->urb,
+						 cached_td->urb->stream_id, cached_td->urb);
 				cached_td = td;
 				break;
 			}
@@ -961,18 +965,24 @@ static int xhci_invalidate_cancelled_tds(struct xhci_virt_ep *ep)
 			td->cancel_status = TD_CLEARED;
 		}
 	}
-	if (cached_td) {
-		cached_td->cancel_status = TD_CLEARING_CACHE;
 
-		err = xhci_move_dequeue_past_td(xhci, slot_id, ep->ep_index,
-						cached_td->urb->stream_id,
-						cached_td);
-		/* Failed to move past cached td, try just setting it noop */
-		if (err) {
-			td_to_noop(xhci, ring, cached_td, false);
-			cached_td->cancel_status = TD_CLEARED;
+	/* If there's no need to move the dequeue pointer then we're done */
+	if (!cached_td)
+		return 0;
+
+	err = xhci_move_dequeue_past_td(xhci, slot_id, ep->ep_index,
+					cached_td->urb->stream_id,
+					cached_td);
+	if (err) {
+		/* Failed to move past cached td, just set cached TDs to no-op */
+		list_for_each_entry_safe(td, tmp_td, &ep->cancelled_td_list, cancelled_td_list) {
+			if (td->cancel_status != TD_CLEARING_CACHE)
+				continue;
+			xhci_dbg(xhci, "Failed to clear cancelled cached URB %p, mark clear anyway\n",
+				 td->urb);
+			td_to_noop(xhci, ring, td, false);
+			td->cancel_status = TD_CLEARED;
 		}
-		cached_td = NULL;
 	}
 	return 0;
 }
-- 
2.32.0



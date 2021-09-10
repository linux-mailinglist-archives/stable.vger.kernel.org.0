Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF31406B88
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhIJMcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhIJMcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51AAA611C8;
        Fri, 10 Sep 2021 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277073;
        bh=zyqoNqZppJPK1gv9y9sHtdwlchOr1PMS2idfI9KuZsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoZaXxgk0Z9LUybi4oRUTGo6whHoZKmbcJREAXkiH81WoQ0TdMUWuTPnghOoRPDot
         U5O5kZIZ44Au9aUX6Na6TAowdhsXWMUxUcMmpjlMwVxJmkFmuVqap7l/CpwMOWRW4i
         6dpfisRh2gVp5mhJSbsOzUsPb0Bllwyw5uYWDg1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tao Wang <wat@codeaurora.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.14 17/23] xhci: Fix failure to give back some cached cancelled URBs.
Date:   Fri, 10 Sep 2021 14:30:07 +0200
Message-Id: <20210910122916.562398810@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 94f339147fc3eb9edef7ee4ef6e39c569c073753 upstream.

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
 drivers/usb/host/xhci-ring.c |   40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -942,17 +942,21 @@ static int xhci_invalidate_cancelled_tds
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
@@ -961,18 +965,24 @@ static int xhci_invalidate_cancelled_tds
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



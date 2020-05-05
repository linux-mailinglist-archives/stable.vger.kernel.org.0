Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C641C6175
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 21:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgEET6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 15:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgEET6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 15:58:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C7220721;
        Tue,  5 May 2020 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588708704;
        bh=AGAyuOl23LkOq3eXFLXmteHUyjQk3+QNmuS0+xQOI+c=;
        h=Date:From:To:Subject:From;
        b=CW7SuaEqsqVfZf+wQtRWJsiNIrmGTgkJAT7roWU+i1LjrLD744s7tCqcf/tTaDnbu
         467WCDmbsW1xZEMS0vnod4Kb8+kF7S11R4sMYVNctvKxI/ScaIM95QDzGr7D/F1kYy
         IifTehTnybKzxeTIFihwQsPEd9F4IPit1Ze6Ys6M=
Date:   Tue, 05 May 2020 12:58:23 -0700
From:   akpm@linux-foundation.org
To:     dbueso@suse.de, jbaron@akamai.com, khazhy@google.com,
        mm-commits@vger.kernel.org, r@hev.cc, rpenyaev@suse.de,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [withdrawn]
 epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch removed from -mm tree
Message-ID: <20200505195823.6UeQAW7XV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: epoll: ensure ep_poll() doesn't miss wakeup events
has been removed from the -mm tree.  Its filename was
     epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Jason Baron <jbaron@akamai.com>
Subject: epoll: ensure ep_poll() doesn't miss wakeup events

Now that the ep_events_available() check is done in a lockless way, and we
no longer perform wakeups from ep_scan_ready_list(), we need to ensure
that either ep->rdllist has items or the overflow list is active.  Prior
to: commit 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested
epoll"), we did wake_up(&ep->wq) after manipulating the ep->rdllist and
the overflow list.  Thus, any waiters would observe the correct state. 
However, with that wake_up() now removed we need to be more careful to
ensure that condition.

Here's an example of what could go wrong:

We have epoll fds: epfd1, epfd2.  And epfd1 is added to epfd2 and epfd2 is
added to a socket: epfd1->epfd2->socket.  Thread a is doing epoll_wait()
on epfd1, and thread b is doing epoll_wait on epfd2.  Then:

1) data comes in on socket

ep_poll_callback() wakes up threads a and b

2) thread a runs

ep_poll()
 ep_scan_ready_list()
  ep_send_events_proc()
   ep_item_poll()
     ep_scan_ready_list()
       list_splice_init(&ep->rdllist, &txlist);

3) now thread b is running

ep_poll()
 ep_events_available()
   returns false
 schedule_hrtimeout_range()

Thus, thread b has now scheduled and missed the wakeup.

Link: http://lkml.kernel.org/r/1588360533-11828-1-git-send-email-jbaron@akamai.com
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Jason Baron <jbaron@akamai.com>
Reviewed-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/fs/eventpoll.c~epoll-ensure-ep_poll-doesnt-miss-wakeup-events
+++ a/fs/eventpoll.c
@@ -704,8 +704,14 @@ static __poll_t ep_scan_ready_list(struc
 	 * in a lockless way.
 	 */
 	write_lock_irq(&ep->lock);
-	list_splice_init(&ep->rdllist, &txlist);
 	WRITE_ONCE(ep->ovflist, NULL);
+	/*
+	 * In ep_poll() we use ep_events_available() in a lockless way to decide
+	 * if events are available. So we need to preserve that either
+	 * ep->oflist != EP_UNACTIVE_PTR or there are events on the ep->rdllist.
+	 */
+	smp_wmb();
+	list_splice_init(&ep->rdllist, &txlist);
 	write_unlock_irq(&ep->lock);
 
 	/*
@@ -737,16 +743,21 @@ static __poll_t ep_scan_ready_list(struc
 		}
 	}
 	/*
+	 * Quickly re-inject items left on "txlist".
+	 */
+	list_splice(&txlist, &ep->rdllist);
+	/*
+	 * In ep_poll() we use ep_events_available() in a lockless way to decide
+	 * if events are available. So we need to preserve that either
+	 * ep->oflist != EP_UNACTIVE_PTR or there are events on the ep->rdllist.
+	 */
+	smp_wmb();
+	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside
 	 * ep->rdllist.
 	 */
 	WRITE_ONCE(ep->ovflist, EP_UNACTIVE_PTR);
-
-	/*
-	 * Quickly re-inject items left on "txlist".
-	 */
-	list_splice(&txlist, &ep->rdllist);
 	__pm_relax(ep->ws);
 	write_unlock_irq(&ep->lock);
 
_

Patches currently in -mm which might be from jbaron@akamai.com are



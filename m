Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC21C1E9A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 22:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgEAUcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 16:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgEAUcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 16:32:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F39692166E;
        Fri,  1 May 2020 20:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588365174;
        bh=UBgnUT59SBIdOyHVmemUVu9VrMDBciMNDgAsqjfZ1/U=;
        h=Date:From:To:Subject:From;
        b=spJd2QVSfJPq55lolVQF8QrxxEwiebjaWRYfILn1yRAPNRJUogwZASpNrrV595iKj
         KQQZ4bh3xGJRvRF/zQVwmdwRLFF+hrvl9u2wUiu9l0n5crYcYo6G9DzZJQB5T7QlVQ
         g/0nA99bQCn7IZ0E17MEC9s66UC0XoPcOHORKqCk=
Date:   Fri, 01 May 2020 13:32:53 -0700
From:   akpm@linux-foundation.org
To:     dbueso@suse.de, jbaron@akamai.com, khazhy@google.com,
        mm-commits@vger.kernel.org, r@hev.cc, rpenyaev@suse.de,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  + epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch
 added to -mm tree
Message-ID: <20200501203253.rwAfrJbDX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: epoll: ensure ep_poll() doesn't miss wakeup events
has been added to the -mm tree.  Its filename is
     epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: Roman Penyaev <rpenyaev@suse.de>
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

epoll-ensure-ep_poll-doesnt-miss-wakeup-events.patch


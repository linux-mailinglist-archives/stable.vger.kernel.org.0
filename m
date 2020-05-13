Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBAA1D0ECC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgEMKC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387424AbgEMJuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D8B923126;
        Wed, 13 May 2020 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363399;
        bh=OTJv1G1EvSM2281z6zR4SjicsyoHdJm6SF5MRtyv4Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuSm0jQeqNtyhaV4o9x49rh89xvBDCeYp1qc4wF+9BzFh6V+H1X9HIvDU3tBBHmiF
         St8K9mun6cw3PcgXgPmu32OWpUv4cMDMTOqK7tQAU8sL25odXwGvOgX5bTgR9959E3
         YTWo5H+VSa5ZsgMwLjuWh/RfEOz5aXAe6GeHHOu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Penyaev <rpenyaev@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 58/90] epoll: atomically remove wait entry on wake up
Date:   Wed, 13 May 2020 11:44:54 +0200
Message-Id: <20200513094415.888707435@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Penyaev <rpenyaev@suse.de>

commit 412895f03cbf9633298111cb4dfde13b7720e2c5 upstream.

This patch does two things:

 - fixes a lost wakeup introduced by commit 339ddb53d373 ("fs/epoll:
   remove unnecessary wakeups of nested epoll")

 - improves performance for events delivery.

The description of the problem is the following: if N (>1) threads are
waiting on ep->wq for new events and M (>1) events come, it is quite
likely that >1 wakeups hit the same wait queue entry, because there is
quite a big window between __add_wait_queue_exclusive() and the
following __remove_wait_queue() calls in ep_poll() function.

This can lead to lost wakeups, because thread, which was woken up, can
handle not all the events in ->rdllist.  (in better words the problem is
described here: https://lkml.org/lkml/2019/10/7/905)

The idea of the current patch is to use init_wait() instead of
init_waitqueue_entry().

Internally init_wait() sets autoremove_wake_function as a callback,
which removes the wait entry atomically (under the wq locks) from the
list, thus the next coming wakeup hits the next wait entry in the wait
queue, thus preventing lost wakeups.

Problem is very well reproduced by the epoll60 test case [1].

Wait entry removal on wakeup has also performance benefits, because
there is no need to take a ep->lock and remove wait entry from the queue
after the successful wakeup.  Here is the timing output of the epoll60
test case:

  With explicit wakeup from ep_scan_ready_list() (the state of the
  code prior 339ddb53d373):

    real    0m6.970s
    user    0m49.786s
    sys     0m0.113s

 After this patch:

   real    0m5.220s
   user    0m36.879s
   sys     0m0.019s

The other testcase is the stress-epoll [2], where one thread consumes
all the events and other threads produce many events:

  With explicit wakeup from ep_scan_ready_list() (the state of the
  code prior 339ddb53d373):

    threads  events/ms  run-time ms
          8       5427         1474
         16       6163         2596
         32       6824         4689
         64       7060         9064
        128       6991        18309

 After this patch:

    threads  events/ms  run-time ms
          8       5598         1429
         16       7073         2262
         32       7502         4265
         64       7640         8376
        128       7634        16767

 (number of "events/ms" represents event bandwidth, thus higher is
  better; number of "run-time ms" represents overall time spent
  doing the benchmark, thus lower is better)

[1] tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
[2] https://github.com/rouming/test-tools/blob/master/stress-epoll.c

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jason Baron <jbaron@akamai.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200430130326.1368509-2-rpenyaev@suse.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1827,7 +1827,6 @@ static int ep_poll(struct eventpoll *ep,
 {
 	int res = 0, eavail, timed_out = 0;
 	u64 slack = 0;
-	bool waiter = false;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
 
@@ -1872,21 +1871,23 @@ fetch_events:
 	 */
 	ep_reset_busy_poll_napi_id(ep);
 
-	/*
-	 * We don't have any available event to return to the caller.  We need
-	 * to sleep here, and we will be woken by ep_poll_callback() when events
-	 * become available.
-	 */
-	if (!waiter) {
-		waiter = true;
-		init_waitqueue_entry(&wait, current);
-
+	do {
+		/*
+		 * Internally init_wait() uses autoremove_wake_function(),
+		 * thus wait entry is removed from the wait queue on each
+		 * wakeup. Why it is important? In case of several waiters
+		 * each new wakeup will hit the next waiter, giving it the
+		 * chance to harvest new event. Otherwise wakeup can be
+		 * lost. This is also good performance-wise, because on
+		 * normal wakeup path no need to call __remove_wait_queue()
+		 * explicitly, thus ep->lock is not taken, which halts the
+		 * event delivery.
+		 */
+		init_wait(&wait);
 		write_lock_irq(&ep->lock);
 		__add_wait_queue_exclusive(&ep->wq, &wait);
 		write_unlock_irq(&ep->lock);
-	}
 
-	for (;;) {
 		/*
 		 * We don't want to sleep if the ep_poll_callback() sends us
 		 * a wakeup in between. That's why we set the task state
@@ -1916,10 +1917,20 @@ fetch_events:
 			timed_out = 1;
 			break;
 		}
-	}
+
+		/* We were woken up, thus go and try to harvest some events */
+		eavail = 1;
+
+	} while (0);
 
 	__set_current_state(TASK_RUNNING);
 
+	if (!list_empty_careful(&wait.entry)) {
+		write_lock_irq(&ep->lock);
+		__remove_wait_queue(&ep->wq, &wait);
+		write_unlock_irq(&ep->lock);
+	}
+
 send_events:
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
@@ -1930,12 +1941,6 @@ send_events:
 	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
 		goto fetch_events;
 
-	if (waiter) {
-		write_lock_irq(&ep->lock);
-		__remove_wait_queue(&ep->wq, &wait);
-		write_unlock_irq(&ep->lock);
-	}
-
 	return res;
 }
 



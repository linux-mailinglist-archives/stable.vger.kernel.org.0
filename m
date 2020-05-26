Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8971BF8CD
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD3NDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:03:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:49728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgD3NDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:03:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5BD26AC85;
        Thu, 30 Apr 2020 13:03:35 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Roman Penyaev <rpenyaev@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Heiher <r@hev.cc>,
        Jason Baron <jbaron@akamai.com>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] epoll: atomically remove wait entry on wake up
Date:   Thu, 30 Apr 2020 15:03:26 +0200
Message-Id: <20200430130326.1368509-2-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200430130326.1368509-1-rpenyaev@suse.de>
References: <20200430130326.1368509-1-rpenyaev@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch does two things:

1. fixes lost wakeup introduced by:
  339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")

2. improves performance for events delivery.

The description of the problem is the following: if N (>1) threads
are waiting on ep->wq for new events and M (>1) events come, it is
quite likely that >1 wakeups hit the same wait queue entry, because
there is quite a big window between __add_wait_queue_exclusive() and
the following __remove_wait_queue() calls in ep_poll() function.  This
can lead to lost wakeups, because thread, which was woken up, can
handle not all the events in ->rdllist. (in better words the problem
is described here: https://lkml.org/lkml/2019/10/7/905)

The idea of the current patch is to use init_wait() instead of
init_waitqueue_entry(). Internally init_wait() sets
autoremove_wake_function as a callback, which removes the wait entry
atomically (under the wq locks) from the list, thus the next coming
wakeup hits the next wait entry in the wait queue, thus preventing
lost wakeups.

Problem is very well reproduced by the epoll60 test case [1].

Wait entry removal on wakeup has also performance benefits, because
there is no need to take a ep->lock and remove wait entry from the
queue after the successful wakeup. Here is the timing output of
the epoll60 test case:

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Heiher <r@hev.cc>
Cc: Jason Baron <jbaron@akamai.com>
Cc: stable@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 fs/eventpoll.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d6ba0e52439b..aba03ee749f8 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1822,7 +1822,6 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 {
 	int res = 0, eavail, timed_out = 0;
 	u64 slack = 0;
-	bool waiter = false;
 	wait_queue_entry_t wait;
 	ktime_t expires, *to = NULL;
 
@@ -1867,21 +1866,23 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
@@ -1911,10 +1912,20 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
@@ -1925,12 +1936,6 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
 
-- 
2.24.1


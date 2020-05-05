Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0C81C605B
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgEESnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 14:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgEESnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 14:43:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3A320721;
        Tue,  5 May 2020 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588704184;
        bh=iUijfZGtWFgaeu5AM4sQX3So+e8YwUKs/nlxJ+7mmoY=;
        h=Date:From:To:Subject:From;
        b=oWQ5qbTacml+1RTLGzoguJQ/L6gILzN0nf3X6kolH54n7Pdrb0uSU2qg9TdvYlttv
         XbNUI+bflTLHmTIrV4JIbQZ7GrL29r1tDs5ZmdPElprTqeq6OA17s1Idf9IIrwMBm8
         utFp18k9pLWHEOwjr4ulKfMvMJ5VUmJiPG2oiex8=
Date:   Tue, 05 May 2020 11:43:04 -0700
From:   akpm@linux-foundation.org
To:     jbaron@akamai.com, khazhy@google.com, mm-commits@vger.kernel.org,
        rpenyaev@suse.de, stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  +
 epoll-call-final-ep_events_available-check-under-the-lock.patch added to
 -mm tree
Message-ID: <20200505184304.mOo7THuYh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: epoll: call final ep_events_available() check under the lock
has been added to the -mm tree.  Its filename is
     epoll-call-final-ep_events_available-check-under-the-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/epoll-call-final-ep_events_available-check-under-the-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/epoll-call-final-ep_events_available-check-under-the-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Penyaev <rpenyaev@suse.de>
Subject: epoll: call final ep_events_available() check under the lock

There is a possible race when ep_scan_ready_list() leaves ->rdllist and
->obflist empty for a short period of time although some events are
pending.  It is quite likely that ep_events_available() observes empty
lists and goes to sleep.  Since 339ddb53d373 ("fs/epoll: remove
unnecessary wakeups of nested epoll") we are conservative in wakeups
(there is only one place for wakeup and this is ep_poll_callback()), thus
ep_events_available() must always observe correct state of two lists.  The
easiest and correct way is to do the final check under the lock.  This
does not impact the performance, since lock is taken anyway for adding a
wait entry to the wait queue.

The discussion of the problem can be found here:
   https://lore.kernel.org/linux-fsdevel/a2f22c3c-c25a-4bda-8339-a7bdaf17849e@akamai.com/

In this patch barrierless __set_current_state() is used.  This is safe
since waitqueue_active() is called under the same lock on wakeup side.

Short-circuit for fatal signals (i.e.  fatal_signal_pending() check) is
moved to the line just before actual events harvesting routine.  This is
fully compliant to what is said in the comment of the patch where the
actual fatal_signal_pending() check was added: c257a340ede0 ("fs, epoll:
short circuit fetching events if thread has been killed").

Link: http://lkml.kernel.org/r/20200505145609.1865152-1-rpenyaev@suse.de
Fixes: 339ddb53d373 ("fs/epoll: remove unnecessary wakeups of nested epoll")
Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Reported-by: Jason Baron <jbaron@akamai.com>
Reviewed-by: Jason Baron <jbaron@akamai.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   48 +++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

--- a/fs/eventpoll.c~epoll-call-final-ep_events_available-check-under-the-lock
+++ a/fs/eventpoll.c
@@ -1890,34 +1890,33 @@ fetch_events:
 		 * event delivery.
 		 */
 		init_wait(&wait);
-		write_lock_irq(&ep->lock);
-		__add_wait_queue_exclusive(&ep->wq, &wait);
-		write_unlock_irq(&ep->lock);
 
+		write_lock_irq(&ep->lock);
 		/*
-		 * We don't want to sleep if the ep_poll_callback() sends us
-		 * a wakeup in between. That's why we set the task state
-		 * to TASK_INTERRUPTIBLE before doing the checks.
+		 * Barrierless variant, waitqueue_active() is called under
+		 * the same lock on wakeup ep_poll_callback() side, so it
+		 * is safe to avoid an explicit barrier.
 		 */
-		set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_INTERRUPTIBLE);
+
 		/*
-		 * Always short-circuit for fatal signals to allow
-		 * threads to make a timely exit without the chance of
-		 * finding more events available and fetching
-		 * repeatedly.
+		 * Do the final check under the lock. ep_scan_ready_list()
+		 * plays with two lists (->rdllist and ->ovflist) and there
+		 * is always a race when both lists are empty for short
+		 * period of time although events are pending, so lock is
+		 * important.
 		 */
-		if (fatal_signal_pending(current)) {
-			res = -EINTR;
-			break;
+		eavail = ep_events_available(ep);
+		if (!eavail) {
+			if (signal_pending(current))
+				res = -EINTR;
+			else
+				__add_wait_queue_exclusive(&ep->wq, &wait);
 		}
+		write_unlock_irq(&ep->lock);
 
-		eavail = ep_events_available(ep);
-		if (eavail)
-			break;
-		if (signal_pending(current)) {
-			res = -EINTR;
+		if (eavail || res)
 			break;
-		}
 
 		if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS)) {
 			timed_out = 1;
@@ -1938,6 +1937,15 @@ fetch_events:
 	}
 
 send_events:
+	if (fatal_signal_pending(current)) {
+		/*
+		 * Always short-circuit for fatal signals to allow
+		 * threads to make a timely exit without the chance of
+		 * finding more events available and fetching
+		 * repeatedly.
+		 */
+		res = -EINTR;
+	}
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
 	 * there's still timeout left over, we go trying again in search of
_

Patches currently in -mm which might be from rpenyaev@suse.de are

kselftests-introduce-new-epoll60-testcase-for-catching-lost-wakeups.patch
epoll-atomically-remove-wait-entry-on-wake-up.patch
epoll-call-final-ep_events_available-check-under-the-lock.patch


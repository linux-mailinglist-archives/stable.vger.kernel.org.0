Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C67472534
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhLMJm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:42:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34734 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbhLMJkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B15FCE0E89;
        Mon, 13 Dec 2021 09:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347DFC341C5;
        Mon, 13 Dec 2021 09:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388402;
        bh=p5JObUvkvYOjf1/be0ZhU9n5CEiCsWZ45FccFw68DJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLzbZTFuNdNwq963/6VvX+Zew/vpzk3KdIze6y9kJwigqImstUpu4aqvEx5q5GJQi
         1xT89Tt3yojVESr325jIEJGkn4GP3tLbvN4tCD7zIwBJzO/t0CjvFOjPjO7it2iofY
         oNsGP4M7DD4ieT8fMXXQKIEv2uY0r6gk0L1DichM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 38/74] aio: fix use-after-free due to missing POLLFREE handling
Date:   Mon, 13 Dec 2021 10:30:09 +0100
Message-Id: <20211213092932.091303396@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 50252e4b5e989ce64555c7aef7516bdefc2fea72 upstream.

signalfd_poll() and binder_poll() are special in that they use a
waitqueue whose lifetime is the current task, rather than the struct
file as is normally the case.  This is okay for blocking polls, since a
blocking poll occurs within one task; however, non-blocking polls
require another solution.  This solution is for the queue to be cleared
before it is freed, by sending a POLLFREE notification to all waiters.

Unfortunately, only eventpoll handles POLLFREE.  A second type of
non-blocking poll, aio poll, was added in kernel v4.18, and it doesn't
handle POLLFREE.  This allows a use-after-free to occur if a signalfd or
binder fd is polled with aio poll, and the waitqueue gets freed.

Fix this by making aio poll handle POLLFREE.

A patch by Ramji Jiyani <ramjiyani@google.com>
(https://lore.kernel.org/r/20211027011834.2497484-1-ramjiyani@google.com)
tried to do this by making aio_poll_wake() always complete the request
inline if POLLFREE is seen.  However, that solution had two bugs.
First, it introduced a deadlock, as it unconditionally locked the aio
context while holding the waitqueue lock, which inverts the normal
locking order.  Second, it didn't consider that POLLFREE notifications
are missed while the request has been temporarily de-queued.

The second problem was solved by my previous patch.  This patch then
properly fixes the use-after-free by handling POLLFREE in a
deadlock-free way.  It does this by taking advantage of the fact that
freeing of the waitqueue is RCU-delayed, similar to what eventpoll does.

Fixes: 2c14fa838cbe ("aio: implement IOCB_CMD_POLL")
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c                        |  137 ++++++++++++++++++++++++++++++----------
 include/uapi/asm-generic/poll.h |    2 
 2 files changed, 107 insertions(+), 32 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1617,6 +1617,51 @@ static void aio_poll_put_work(struct wor
 	iocb_put(iocb);
 }
 
+/*
+ * Safely lock the waitqueue which the request is on, synchronizing with the
+ * case where the ->poll() provider decides to free its waitqueue early.
+ *
+ * Returns true on success, meaning that req->head->lock was locked, req->wait
+ * is on req->head, and an RCU read lock was taken.  Returns false if the
+ * request was already removed from its waitqueue (which might no longer exist).
+ */
+static bool poll_iocb_lock_wq(struct poll_iocb *req)
+{
+	wait_queue_head_t *head;
+
+	/*
+	 * While we hold the waitqueue lock and the waitqueue is nonempty,
+	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
+	 * lock in the first place can race with the waitqueue being freed.
+	 *
+	 * We solve this as eventpoll does: by taking advantage of the fact that
+	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
+	 * we enter rcu_read_lock() and see that the pointer to the queue is
+	 * non-NULL, we can then lock it without the memory being freed out from
+	 * under us, then check whether the request is still on the queue.
+	 *
+	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
+	 * case the caller deletes the entry from the queue, leaving it empty.
+	 * In that case, only RCU prevents the queue memory from being freed.
+	 */
+	rcu_read_lock();
+	head = smp_load_acquire(&req->head);
+	if (head) {
+		spin_lock(&head->lock);
+		if (!list_empty(&req->wait.entry))
+			return true;
+		spin_unlock(&head->lock);
+	}
+	rcu_read_unlock();
+	return false;
+}
+
+static void poll_iocb_unlock_wq(struct poll_iocb *req)
+{
+	spin_unlock(&req->head->lock);
+	rcu_read_unlock();
+}
+
 static void aio_poll_complete_work(struct work_struct *work)
 {
 	struct poll_iocb *req = container_of(work, struct poll_iocb, work);
@@ -1636,24 +1681,25 @@ static void aio_poll_complete_work(struc
 	 * avoid further branches in the fast path.
 	 */
 	spin_lock_irq(&ctx->ctx_lock);
-	spin_lock(&req->head->lock);
-	if (!mask && !READ_ONCE(req->cancelled)) {
-		/*
-		 * The request isn't actually ready to be completed yet.
-		 * Reschedule completion if another wakeup came in.
-		 */
-		if (req->work_need_resched) {
-			schedule_work(&req->work);
-			req->work_need_resched = false;
-		} else {
-			req->work_scheduled = false;
+	if (poll_iocb_lock_wq(req)) {
+		if (!mask && !READ_ONCE(req->cancelled)) {
+			/*
+			 * The request isn't actually ready to be completed yet.
+			 * Reschedule completion if another wakeup came in.
+			 */
+			if (req->work_need_resched) {
+				schedule_work(&req->work);
+				req->work_need_resched = false;
+			} else {
+				req->work_scheduled = false;
+			}
+			poll_iocb_unlock_wq(req);
+			spin_unlock_irq(&ctx->ctx_lock);
+			return;
 		}
-		spin_unlock(&req->head->lock);
-		spin_unlock_irq(&ctx->ctx_lock);
-		return;
-	}
-	list_del_init(&req->wait.entry);
-	spin_unlock(&req->head->lock);
+		list_del_init(&req->wait.entry);
+		poll_iocb_unlock_wq(req);
+	} /* else, POLLFREE has freed the waitqueue, so we must complete */
 	list_del_init(&iocb->ki_list);
 	iocb->ki_res.res = mangle_poll(mask);
 	spin_unlock_irq(&ctx->ctx_lock);
@@ -1667,13 +1713,14 @@ static int aio_poll_cancel(struct kiocb
 	struct aio_kiocb *aiocb = container_of(iocb, struct aio_kiocb, rw);
 	struct poll_iocb *req = &aiocb->poll;
 
-	spin_lock(&req->head->lock);
-	WRITE_ONCE(req->cancelled, true);
-	if (!req->work_scheduled) {
-		schedule_work(&aiocb->poll.work);
-		req->work_scheduled = true;
-	}
-	spin_unlock(&req->head->lock);
+	if (poll_iocb_lock_wq(req)) {
+		WRITE_ONCE(req->cancelled, true);
+		if (!req->work_scheduled) {
+			schedule_work(&aiocb->poll.work);
+			req->work_scheduled = true;
+		}
+		poll_iocb_unlock_wq(req);
+	} /* else, the request was force-cancelled by POLLFREE already */
 
 	return 0;
 }
@@ -1725,7 +1772,8 @@ static int aio_poll_wake(struct wait_que
 		 *
 		 * Don't remove the request from the waitqueue here, as it might
 		 * not actually be complete yet (we won't know until vfs_poll()
-		 * is called), and we must not miss any wakeups.
+		 * is called), and we must not miss any wakeups.  POLLFREE is an
+		 * exception to this; see below.
 		 */
 		if (req->work_scheduled) {
 			req->work_need_resched = true;
@@ -1733,6 +1781,28 @@ static int aio_poll_wake(struct wait_que
 			schedule_work(&req->work);
 			req->work_scheduled = true;
 		}
+
+		/*
+		 * If the waitqueue is being freed early but we can't complete
+		 * the request inline, we have to tear down the request as best
+		 * we can.  That means immediately removing the request from its
+		 * waitqueue and preventing all further accesses to the
+		 * waitqueue via the request.  We also need to schedule the
+		 * completion work (done above).  Also mark the request as
+		 * cancelled, to potentially skip an unneeded call to ->poll().
+		 */
+		if (mask & POLLFREE) {
+			WRITE_ONCE(req->cancelled, true);
+			list_del_init(&req->wait.entry);
+
+			/*
+			 * Careful: this *must* be the last step, since as soon
+			 * as req->head is NULL'ed out, the request can be
+			 * completed and freed, since aio_poll_complete_work()
+			 * will no longer need to take the waitqueue lock.
+			 */
+			smp_store_release(&req->head, NULL);
+		}
 	}
 	return 1;
 }
@@ -1740,6 +1810,7 @@ static int aio_poll_wake(struct wait_que
 struct aio_poll_table {
 	struct poll_table_struct	pt;
 	struct aio_kiocb		*iocb;
+	bool				queued;
 	int				error;
 };
 
@@ -1750,11 +1821,12 @@ aio_poll_queue_proc(struct file *file, s
 	struct aio_poll_table *pt = container_of(p, struct aio_poll_table, pt);
 
 	/* multiple wait queues per file are not supported */
-	if (unlikely(pt->iocb->poll.head)) {
+	if (unlikely(pt->queued)) {
 		pt->error = -EINVAL;
 		return;
 	}
 
+	pt->queued = true;
 	pt->error = 0;
 	pt->iocb->poll.head = head;
 	add_wait_queue(head, &pt->iocb->poll.wait);
@@ -1786,6 +1858,7 @@ static ssize_t aio_poll(struct aio_kiocb
 	apt.pt._qproc = aio_poll_queue_proc;
 	apt.pt._key = req->events;
 	apt.iocb = aiocb;
+	apt.queued = false;
 	apt.error = -EINVAL; /* same as no support for IOCB_CMD_POLL */
 
 	/* initialized the list so that we can do list_empty checks */
@@ -1794,9 +1867,10 @@ static ssize_t aio_poll(struct aio_kiocb
 
 	mask = vfs_poll(req->file, &apt.pt) & req->events;
 	spin_lock_irq(&ctx->ctx_lock);
-	if (likely(req->head)) {
-		spin_lock(&req->head->lock);
-		if (list_empty(&req->wait.entry) || req->work_scheduled) {
+	if (likely(apt.queued)) {
+		bool on_queue = poll_iocb_lock_wq(req);
+
+		if (!on_queue || req->work_scheduled) {
 			/*
 			 * aio_poll_wake() already either scheduled the async
 			 * completion work, or completed the request inline.
@@ -1812,7 +1886,7 @@ static ssize_t aio_poll(struct aio_kiocb
 		} else if (cancel) {
 			/* Cancel if possible (may be too late though). */
 			WRITE_ONCE(req->cancelled, true);
-		} else if (!list_empty(&req->wait.entry)) {
+		} else if (on_queue) {
 			/*
 			 * Actually waiting for an event, so add the request to
 			 * active_reqs so that it can be cancelled if needed.
@@ -1820,7 +1894,8 @@ static ssize_t aio_poll(struct aio_kiocb
 			list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
 			aiocb->ki_cancel = aio_poll_cancel;
 		}
-		spin_unlock(&req->head->lock);
+		if (on_queue)
+			poll_iocb_unlock_wq(req);
 	}
 	if (mask) { /* no async, we'd stolen it */
 		aiocb->ki_res.res = mangle_poll(mask);
--- a/include/uapi/asm-generic/poll.h
+++ b/include/uapi/asm-generic/poll.h
@@ -29,7 +29,7 @@
 #define POLLRDHUP       0x2000
 #endif
 
-#define POLLFREE	(__force __poll_t)0x4000	/* currently only for epoll */
+#define POLLFREE	(__force __poll_t)0x4000
 
 #define POLL_BUSY_LOOP	(__force __poll_t)0x8000
 



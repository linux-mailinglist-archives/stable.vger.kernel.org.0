Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD3D46812E
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 01:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhLDA05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 19:26:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50824 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhLDA05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 19:26:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3188B62D30;
        Sat,  4 Dec 2021 00:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A55EC341C3;
        Sat,  4 Dec 2021 00:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638577411;
        bh=Xl/m6arGuXEXZBudPQZQMrVA4rXHK9NUDTwVAGLzwV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NwWyCnNsy8GaN9n0/5dR/04986Zph9oJLXU54r/ZQggYv3tGLg+Nwm4xzCXOoFclY
         rKAajPt4EvSU2pUuKnr7pW5E2EQuo7wWszWTQ79GoHhc7jME5G4IJQniXgu2FF2juR
         gU3LPPSlfT2oCO7kHIe9ms4ZaA9qi4l+oN2FTmA8/ExuHACKLexRENrZDA4ZBO9RW8
         BFNyBbdXWxTS2H0ysXCd/uu8/xf6RHwB2mW9nhxU859RwFIwESVnkYJE1/sDcQCkcw
         RD8SLgn0Ygdg0xg7wHU+STmMUj5/Yhr7dNxOJYum/d5rzYwEkvU2rdlzG3Yym3w9Se
         C8YmX0yR00oYg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] aio: fix use-after-free due to missing POLLFREE handling
Date:   Fri,  3 Dec 2021 16:23:01 -0800
Message-Id: <20211204002301.116139-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211204002301.116139-1-ebiggers@kernel.org>
References: <20211204002301.116139-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

signalfd_poll() and binder_poll() are special in that they use a
waitqueue whose lifetime is the current task, rather than the struct
file as is normally the case.  This is okay for blocking polls, since a
blocking poll occurs within one task; however, non-blocking polls
require another solution.  This solution is for the queue to be cleared
before it is freed, using 'wake_up_poll(wq, EPOLLHUP | POLLFREE);'.

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
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/aio.c                        | 102 ++++++++++++++++++++++++--------
 include/uapi/asm-generic/poll.h |   2 +-
 2 files changed, 79 insertions(+), 25 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index b72beeaed0631..8daafb95b6801 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1620,6 +1620,50 @@ static void aio_poll_put_work(struct work_struct *work)
 	iocb_put(iocb);
 }
 
+/*
+ * Safely lock the waitqueue which the request is on, taking into account the
+ * fact that the waitqueue may be freed at any time before the lock is taken.
+ *
+ * Returns true on success, meaning that req->head->lock was locked and
+ * req->wait is on req->head.  Returns false if the request has already been
+ * removed from its waitqueue (which might no longer exist).
+ */
+static bool poll_iocb_lock_wq(struct poll_iocb *req)
+{
+	/*
+	 * Holding req->head->lock prevents req->wait being removed from the
+	 * waitqueue, and thus prevents the waitqueue from being freed
+	 * (POLLFREE) in the rare cases of ->poll() implementations where the
+	 * waitqueue may not live as long as the struct file.  However, taking
+	 * req->head->lock in the first place can race with POLLFREE.
+	 *
+	 * We solve this in a similar way as eventpoll does: by taking advantage
+	 * of the fact that all users of POLLFREE will RCU-delay the actual
+	 * free.  If we enter rcu_read_lock() and check that req->wait isn't
+	 * already removed, then req->head is guaranteed to be accessible until
+	 * rcu_read_unlock().  We can then lock req->head->lock and re-check
+	 * whether req->wait has been removed or not.
+	 */
+	rcu_read_lock();
+	if (list_empty_careful(&req->wait.entry)) {
+		rcu_read_unlock();
+		return false;
+	}
+	spin_lock(&req->head->lock);
+	if (list_empty(&req->wait.entry)) {
+		spin_unlock(&req->head->lock);
+		rcu_read_unlock();
+		return false;
+	}
+	rcu_read_unlock();
+	return true;
+}
+
+static void poll_iocb_unlock_wq(struct poll_iocb *req)
+{
+	spin_unlock(&req->head->lock);
+}
+
 static void aio_poll_complete_work(struct work_struct *work)
 {
 	struct poll_iocb *req = container_of(work, struct poll_iocb, work);
@@ -1639,21 +1683,22 @@ static void aio_poll_complete_work(struct work_struct *work)
 	 * avoid further branches in the fast path.
 	 */
 	spin_lock_irq(&ctx->ctx_lock);
-	spin_lock(&req->head->lock);
-	if (!mask && !READ_ONCE(req->cancelled)) {
-		/* Reschedule completion if another wakeup came in. */
-		if (req->work_need_resched) {
-			schedule_work(&req->work);
-			req->work_need_resched = false;
-		} else {
-			req->work_scheduled = false;
+	if (poll_iocb_lock_wq(req)) {
+		if (!mask && !READ_ONCE(req->cancelled)) {
+			/* Reschedule completion if another wakeup came in. */
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
@@ -1667,13 +1712,12 @@ static int aio_poll_cancel(struct kiocb *iocb)
 	struct aio_kiocb *aiocb = container_of(iocb, struct aio_kiocb, rw);
 	struct poll_iocb *req = &aiocb->poll;
 
-	spin_lock(&req->head->lock);
-	WRITE_ONCE(req->cancelled, true);
-	if (!list_empty(&req->wait.entry)) {
+	if (poll_iocb_lock_wq(req)) {
+		WRITE_ONCE(req->cancelled, true);
 		list_del_init(&req->wait.entry);
-		schedule_work(&aiocb->poll.work);
-	}
-	spin_unlock(&req->head->lock);
+		schedule_work(&req->work);
+		poll_iocb_unlock_wq(req);
+	} /* else, the request was force-cancelled by POLLFREE already */
 
 	return 0;
 }
@@ -1717,6 +1761,14 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		if (iocb)
 			iocb_put(iocb);
 	} else {
+		if (mask & POLLFREE) {
+			/*
+			 * The waitqueue is going to be freed, so remove the
+			 * request from the waitqueue and mark it as cancelled.
+			 */
+			list_del_init(&req->wait.entry);
+			WRITE_ONCE(req->cancelled, true);
+		}
 		/*
 		 * Schedule the completion work if needed.  If it was already
 		 * scheduled, record that another wakeup came in.
@@ -1789,8 +1841,9 @@ static int aio_poll(struct aio_kiocb *aiocb, const struct iocb *iocb)
 	mask = vfs_poll(req->file, &apt.pt) & req->events;
 	spin_lock_irq(&ctx->ctx_lock);
 	if (likely(req->head)) {
-		spin_lock(&req->head->lock);
-		if (req->work_scheduled) {
+		bool on_queue = poll_iocb_lock_wq(req);
+
+		if (!on_queue || req->work_scheduled) {
 			/* async completion work was already scheduled */
 			if (apt.error)
 				cancel = true;
@@ -1803,12 +1856,13 @@ static int aio_poll(struct aio_kiocb *aiocb, const struct iocb *iocb)
 		} else if (cancel) {
 			/* cancel if possible (may be too late though) */
 			WRITE_ONCE(req->cancelled, true);
-		} else if (!list_empty(&req->wait.entry)) {
+		} else if (on_queue) {
 			/* actually waiting for an event */
 			list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
 			aiocb->ki_cancel = aio_poll_cancel;
 		}
-		spin_unlock(&req->head->lock);
+		if (on_queue)
+			poll_iocb_unlock_wq(req);
 	}
 	if (mask) { /* no async, we'd stolen it */
 		aiocb->ki_res.res = mangle_poll(mask);
diff --git a/include/uapi/asm-generic/poll.h b/include/uapi/asm-generic/poll.h
index 41b509f410bf9..f9c520ce4bf4e 100644
--- a/include/uapi/asm-generic/poll.h
+++ b/include/uapi/asm-generic/poll.h
@@ -29,7 +29,7 @@
 #define POLLRDHUP       0x2000
 #endif
 
-#define POLLFREE	(__force __poll_t)0x4000	/* currently only for epoll */
+#define POLLFREE	(__force __poll_t)0x4000
 
 #define POLL_BUSY_LOOP	(__force __poll_t)0x8000
 
-- 
2.34.1


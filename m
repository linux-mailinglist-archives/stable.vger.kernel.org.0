Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963A5F770
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfD3L7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbfD3Lqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF20E21734;
        Tue, 30 Apr 2019 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624808;
        bh=WODdMlRd7ADBsAwml0QYtWkgJAv6lbsFph3U73Y0E94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HncsNMf0yFgMoOoOlNAsNNz2KZMWOs8qy6UieBTCR8Y616t+fqHpQIqj+8/NTddux
         Hgpa19ZltLLPdOKTkpfnFzJ32MrInkrcoSoa55OVJS9E19bNHP01D43LrdD4cDqqrg
         WFcRnzhKcAKpMoAgvgP6SoWB2oR+AvYNxAEKATpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 079/100] Fix aio_poll() races
Date:   Tue, 30 Apr 2019 13:38:48 +0200
Message-Id: <20190430113612.474789646@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit af5c72b1fc7a00aa484e90b0c4e0eeb582545634 upstream.

aio_poll() has to cope with several unpleasant problems:
	* requests that might stay around indefinitely need to
be made visible for io_cancel(2); that must not be done to
a request already completed, though.
	* in cases when ->poll() has placed us on a waitqueue,
wakeup might have happened (and request completed) before ->poll()
returns.
	* worse, in some early wakeup cases request might end
up re-added into the queue later - we can't treat "woken up and
currently not in the queue" as "it's not going to stick around
indefinitely"
	* ... moreover, ->poll() might have decided not to
put it on any queues to start with, and that needs to be distinguished
from the previous case
	* ->poll() might have tried to put us on more than one queue.
Only the first will succeed for aio poll, so we might end up missing
wakeups.  OTOH, we might very well notice that only after the
wakeup hits and request gets completed (all before ->poll() gets
around to the second poll_wait()).  In that case it's too late to
decide that we have an error.

req->woken was an attempt to deal with that.  Unfortunately, it was
broken.  What we need to keep track of is not that wakeup has happened -
the thing might come back after that.  It's that async reference is
already gone and won't come back, so we can't (and needn't) put the
request on the list of cancellables.

The easiest case is "request hadn't been put on any waitqueues"; we
can tell by seeing NULL apt.head, and in that case there won't be
anything async.  We should either complete the request ourselves
(if vfs_poll() reports anything of interest) or return an error.

In all other cases we get exclusion with wakeups by grabbing the
queue lock.

If request is currently on queue and we have something interesting
from vfs_poll(), we can steal it and complete the request ourselves.

If it's on queue and vfs_poll() has not reported anything interesting,
we either put it on the cancellable list, or, if we know that it
hadn't been put on all queues ->poll() wanted it on, we steal it and
return an error.

If it's _not_ on queue, it's either been already dealt with (in which
case we do nothing), or there's aio_poll_complete_work() about to be
executed.  In that case we either put it on the cancellable list,
or, if we know it hadn't been put on all queues ->poll() wanted it on,
simulate what cancel would've done.

It's a lot more convoluted than I'd like it to be.  Single-consumer APIs
suck, and unfortunately aio is not an exception...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   90 ++++++++++++++++++++++++++++-----------------------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -175,7 +175,7 @@ struct poll_iocb {
 	struct file		*file;
 	struct wait_queue_head	*head;
 	__poll_t		events;
-	bool			woken;
+	bool			done;
 	bool			cancelled;
 	struct wait_queue_entry	wait;
 	struct work_struct	work;
@@ -1600,12 +1600,6 @@ static int aio_fsync(struct fsync_iocb *
 	return 0;
 }
 
-static inline void aio_poll_complete(struct aio_kiocb *iocb, __poll_t mask)
-{
-	iocb->ki_res.res = mangle_poll(mask);
-	iocb_put(iocb);
-}
-
 static void aio_poll_complete_work(struct work_struct *work)
 {
 	struct poll_iocb *req = container_of(work, struct poll_iocb, work);
@@ -1631,9 +1625,11 @@ static void aio_poll_complete_work(struc
 		return;
 	}
 	list_del_init(&iocb->ki_list);
+	iocb->ki_res.res = mangle_poll(mask);
+	req->done = true;
 	spin_unlock_irq(&ctx->ctx_lock);
 
-	aio_poll_complete(iocb, mask);
+	iocb_put(iocb);
 }
 
 /* assumes we are called with irqs disabled */
@@ -1661,31 +1657,27 @@ static int aio_poll_wake(struct wait_que
 	__poll_t mask = key_to_poll(key);
 	unsigned long flags;
 
-	req->woken = true;
-
 	/* for instances that support it check for an event match first: */
-	if (mask) {
-		if (!(mask & req->events))
-			return 0;
+	if (mask && !(mask & req->events))
+		return 0;
 
+	list_del_init(&req->wait.entry);
+
+	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
 		/*
 		 * Try to complete the iocb inline if we can. Use
 		 * irqsave/irqrestore because not all filesystems (e.g. fuse)
 		 * call this function with IRQs disabled and because IRQs
 		 * have to be disabled before ctx_lock is obtained.
 		 */
-		if (spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
-			list_del(&iocb->ki_list);
-			spin_unlock_irqrestore(&iocb->ki_ctx->ctx_lock, flags);
-
-			list_del_init(&req->wait.entry);
-			aio_poll_complete(iocb, mask);
-			return 1;
-		}
+		list_del(&iocb->ki_list);
+		iocb->ki_res.res = mangle_poll(mask);
+		req->done = true;
+		spin_unlock_irqrestore(&iocb->ki_ctx->ctx_lock, flags);
+		iocb_put(iocb);
+	} else {
+		schedule_work(&req->work);
 	}
-
-	list_del_init(&req->wait.entry);
-	schedule_work(&req->work);
 	return 1;
 }
 
@@ -1717,6 +1709,7 @@ static ssize_t aio_poll(struct aio_kiocb
 	struct kioctx *ctx = aiocb->ki_ctx;
 	struct poll_iocb *req = &aiocb->poll;
 	struct aio_poll_table apt;
+	bool cancel = false;
 	__poll_t mask;
 
 	/* reject any unknown events outside the normal event mask. */
@@ -1730,7 +1723,7 @@ static ssize_t aio_poll(struct aio_kiocb
 	req->events = demangle_poll(iocb->aio_buf) | EPOLLERR | EPOLLHUP;
 
 	req->head = NULL;
-	req->woken = false;
+	req->done = false;
 	req->cancelled = false;
 
 	apt.pt._qproc = aio_poll_queue_proc;
@@ -1743,36 +1736,33 @@ static ssize_t aio_poll(struct aio_kiocb
 	init_waitqueue_func_entry(&req->wait, aio_poll_wake);
 
 	mask = vfs_poll(req->file, &apt.pt) & req->events;
-	if (unlikely(!req->head)) {
-		/* we did not manage to set up a waitqueue, done */
-		goto out;
-	}
-
 	spin_lock_irq(&ctx->ctx_lock);
-	spin_lock(&req->head->lock);
-	if (req->woken) {
-		/* wake_up context handles the rest */
-		mask = 0;
+	if (likely(req->head)) {
+		spin_lock(&req->head->lock);
+		if (unlikely(list_empty(&req->wait.entry))) {
+			if (apt.error)
+				cancel = true;
+			apt.error = 0;
+			mask = 0;
+		}
+		if (mask || apt.error) {
+			list_del_init(&req->wait.entry);
+		} else if (cancel) {
+			WRITE_ONCE(req->cancelled, true);
+		} else if (!req->done) { /* actually waiting for an event */
+			list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
+			aiocb->ki_cancel = aio_poll_cancel;
+		}
+		spin_unlock(&req->head->lock);
+	}
+	if (mask) { /* no async, we'd stolen it */
+		aiocb->ki_res.res = mangle_poll(mask);
 		apt.error = 0;
-	} else if (mask || apt.error) {
-		/* if we get an error or a mask we are done */
-		WARN_ON_ONCE(list_empty(&req->wait.entry));
-		list_del_init(&req->wait.entry);
-	} else {
-		/* actually waiting for an event */
-		list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
-		aiocb->ki_cancel = aio_poll_cancel;
 	}
-	spin_unlock(&req->head->lock);
 	spin_unlock_irq(&ctx->ctx_lock);
-
-out:
-	if (unlikely(apt.error))
-		return apt.error;
-
 	if (mask)
-		aio_poll_complete(aiocb, mask);
-	return 0;
+		iocb_put(aiocb);
+	return apt.error;
 }
 
 static int __io_submit_one(struct kioctx *ctx, const struct iocb *iocb,



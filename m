Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE647255A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbhLMJn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235056AbhLMJkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:40:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B2DB80E0B;
        Mon, 13 Dec 2021 09:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A56C341C5;
        Mon, 13 Dec 2021 09:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388399;
        bh=DQCUutKUGhabyVeopq3tf13shY82HsGV0JIdWwr6m5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1d7Aa2Q6AaaE6IXUkjHpX2NMeLbnmoF1TOVVgrp/lVL5GQCgMk+VA2XXJBWCe00vn
         i1Mk9wKkTHFBbkpexSwxySUVdmcYW6ZWtnAUcxUrF5xn+kcefQ0wmXXtUiKX9Sdcwz
         cnrdutSxcjkKn4WtqihLFQB+He76zWP7PnLf3JEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.19 37/74] aio: keep poll requests on waitqueue until completed
Date:   Mon, 13 Dec 2021 10:30:08 +0100
Message-Id: <20211213092932.060590322@linuxfoundation.org>
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

commit 363bee27e25804d8981dd1c025b4ad49dc39c530 upstream.

Currently, aio_poll_wake() will always remove the poll request from the
waitqueue.  Then, if aio_poll_complete_work() sees that none of the
polled events are ready and the request isn't cancelled, it re-adds the
request to the waitqueue.  (This can easily happen when polling a file
that doesn't pass an event mask when waking up its waitqueue.)

This is fundamentally broken for two reasons:

  1. If a wakeup occurs between vfs_poll() and the request being
     re-added to the waitqueue, it will be missed because the request
     wasn't on the waitqueue at the time.  Therefore, IOCB_CMD_POLL
     might never complete even if the polled file is ready.

  2. When the request isn't on the waitqueue, there is no way to be
     notified that the waitqueue is being freed (which happens when its
     lifetime is shorter than the struct file's).  This is supposed to
     happen via the waitqueue entries being woken up with POLLFREE.

Therefore, leave the requests on the waitqueue until they are actually
completed (or cancelled).  To keep track of when aio_poll_complete_work
needs to be scheduled, use new fields in struct poll_iocb.  Remove the
'done' field which is now redundant.

Note that this is consistent with how sys_poll() and eventpoll work;
their wakeup functions do *not* remove the waitqueue entries.

Fixes: 2c14fa838cbe ("aio: implement IOCB_CMD_POLL")
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://lore.kernel.org/r/20211209010455.42744-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/aio.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 20 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -176,8 +176,9 @@ struct poll_iocb {
 	struct file		*file;
 	struct wait_queue_head	*head;
 	__poll_t		events;
-	bool			done;
 	bool			cancelled;
+	bool			work_scheduled;
+	bool			work_need_resched;
 	struct wait_queue_entry	wait;
 	struct work_struct	work;
 };
@@ -1635,14 +1636,26 @@ static void aio_poll_complete_work(struc
 	 * avoid further branches in the fast path.
 	 */
 	spin_lock_irq(&ctx->ctx_lock);
+	spin_lock(&req->head->lock);
 	if (!mask && !READ_ONCE(req->cancelled)) {
-		add_wait_queue(req->head, &req->wait);
+		/*
+		 * The request isn't actually ready to be completed yet.
+		 * Reschedule completion if another wakeup came in.
+		 */
+		if (req->work_need_resched) {
+			schedule_work(&req->work);
+			req->work_need_resched = false;
+		} else {
+			req->work_scheduled = false;
+		}
+		spin_unlock(&req->head->lock);
 		spin_unlock_irq(&ctx->ctx_lock);
 		return;
 	}
+	list_del_init(&req->wait.entry);
+	spin_unlock(&req->head->lock);
 	list_del_init(&iocb->ki_list);
 	iocb->ki_res.res = mangle_poll(mask);
-	req->done = true;
 	spin_unlock_irq(&ctx->ctx_lock);
 
 	iocb_put(iocb);
@@ -1656,9 +1669,9 @@ static int aio_poll_cancel(struct kiocb
 
 	spin_lock(&req->head->lock);
 	WRITE_ONCE(req->cancelled, true);
-	if (!list_empty(&req->wait.entry)) {
-		list_del_init(&req->wait.entry);
+	if (!req->work_scheduled) {
 		schedule_work(&aiocb->poll.work);
+		req->work_scheduled = true;
 	}
 	spin_unlock(&req->head->lock);
 
@@ -1677,20 +1690,26 @@ static int aio_poll_wake(struct wait_que
 	if (mask && !(mask & req->events))
 		return 0;
 
-	list_del_init(&req->wait.entry);
-
-	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
+	/*
+	 * Complete the request inline if possible.  This requires that three
+	 * conditions be met:
+	 *   1. An event mask must have been passed.  If a plain wakeup was done
+	 *	instead, then mask == 0 and we have to call vfs_poll() to get
+	 *	the events, so inline completion isn't possible.
+	 *   2. The completion work must not have already been scheduled.
+	 *   3. ctx_lock must not be busy.  We have to use trylock because we
+	 *	already hold the waitqueue lock, so this inverts the normal
+	 *	locking order.  Use irqsave/irqrestore because not all
+	 *	filesystems (e.g. fuse) call this function with IRQs disabled,
+	 *	yet IRQs have to be disabled before ctx_lock is obtained.
+	 */
+	if (mask && !req->work_scheduled &&
+	    spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
 		struct kioctx *ctx = iocb->ki_ctx;
 
-		/*
-		 * Try to complete the iocb inline if we can. Use
-		 * irqsave/irqrestore because not all filesystems (e.g. fuse)
-		 * call this function with IRQs disabled and because IRQs
-		 * have to be disabled before ctx_lock is obtained.
-		 */
+		list_del_init(&req->wait.entry);
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
-		req->done = true;
 		if (iocb->ki_eventfd && eventfd_signal_count()) {
 			iocb = NULL;
 			INIT_WORK(&req->work, aio_poll_put_work);
@@ -1700,7 +1719,20 @@ static int aio_poll_wake(struct wait_que
 		if (iocb)
 			iocb_put(iocb);
 	} else {
-		schedule_work(&req->work);
+		/*
+		 * Schedule the completion work if needed.  If it was already
+		 * scheduled, record that another wakeup came in.
+		 *
+		 * Don't remove the request from the waitqueue here, as it might
+		 * not actually be complete yet (we won't know until vfs_poll()
+		 * is called), and we must not miss any wakeups.
+		 */
+		if (req->work_scheduled) {
+			req->work_need_resched = true;
+		} else {
+			schedule_work(&req->work);
+			req->work_scheduled = true;
+		}
 	}
 	return 1;
 }
@@ -1747,8 +1779,9 @@ static ssize_t aio_poll(struct aio_kiocb
 	req->events = demangle_poll(iocb->aio_buf) | EPOLLERR | EPOLLHUP;
 
 	req->head = NULL;
-	req->done = false;
 	req->cancelled = false;
+	req->work_scheduled = false;
+	req->work_need_resched = false;
 
 	apt.pt._qproc = aio_poll_queue_proc;
 	apt.pt._key = req->events;
@@ -1763,17 +1796,27 @@ static ssize_t aio_poll(struct aio_kiocb
 	spin_lock_irq(&ctx->ctx_lock);
 	if (likely(req->head)) {
 		spin_lock(&req->head->lock);
-		if (unlikely(list_empty(&req->wait.entry))) {
-			if (apt.error)
+		if (list_empty(&req->wait.entry) || req->work_scheduled) {
+			/*
+			 * aio_poll_wake() already either scheduled the async
+			 * completion work, or completed the request inline.
+			 */
+			if (apt.error) /* unsupported case: multiple queues */
 				cancel = true;
 			apt.error = 0;
 			mask = 0;
 		}
 		if (mask || apt.error) {
+			/* Steal to complete synchronously. */
 			list_del_init(&req->wait.entry);
 		} else if (cancel) {
+			/* Cancel if possible (may be too late though). */
 			WRITE_ONCE(req->cancelled, true);
-		} else if (!req->done) { /* actually waiting for an event */
+		} else if (!list_empty(&req->wait.entry)) {
+			/*
+			 * Actually waiting for an event, so add the request to
+			 * active_reqs so that it can be cancelled if needed.
+			 */
 			list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
 			aiocb->ki_cancel = aio_poll_cancel;
 		}



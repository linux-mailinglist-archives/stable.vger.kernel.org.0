Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EE5468133
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 01:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354363AbhLDA1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 19:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354282AbhLDA07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 19:26:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940D8C061353;
        Fri,  3 Dec 2021 16:23:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 666E4B829C0;
        Sat,  4 Dec 2021 00:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C952AC341C0;
        Sat,  4 Dec 2021 00:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638577411;
        bh=5Ubfy5qLXjhCeuRKa9utt/2JcFrlgDPKmQcajB2MFAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHz01nIbdJuxCAUlgDBu8nSaMNqXz0YthU2DF2ErJls74BbvL/OCwvjBna/LJc8zf
         a/Fba4Y2U5h6mIrf0vgD8nLdpMKdUV8wX8J86ZiAmVkdJfUcHSck0DHIrVSudVz3Gn
         jcRCC8ChBjZ4JqDfcgyQZqsalhd08CgOBmF+MoQLa9JfB/RFx7EFlHyjrj5CaeMimr
         yy+mpicn2TlnMq6qnbPcewSZ9GbuKND6mkb8jEEgeBePPnZQzYP5vOi+9e3yATkhuY
         /g1eC5oHP8Mg66yMOHr7q3kWzCAjogV3XHpRd8Jqt4xcDfSZJ+JwJfMnSQR3nA3f3H
         XAanNa1XUrYaA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Cc:     linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] aio: keep poll requests on waitqueue until completed
Date:   Fri,  3 Dec 2021 16:23:00 -0800
Message-Id: <20211204002301.116139-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211204002301.116139-1-ebiggers@kernel.org>
References: <20211204002301.116139-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
completed or cancelled.  To keep track of when aio_poll_complete_work
needs to be scheduled, use new fields in struct poll_iocb.  Remove the
'done' field which is now redundant.

Note that this is consistent with how sys_poll() and eventpoll work;
their wakeup functions do *not* remove the waitqueue entries.

Fixes: 2c14fa838cbe ("aio: implement IOCB_CMD_POLL")
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/aio.c | 60 +++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 16 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9c81cf611d659..b72beeaed0631 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -181,8 +181,9 @@ struct poll_iocb {
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
@@ -1638,14 +1639,23 @@ static void aio_poll_complete_work(struct work_struct *work)
 	 * avoid further branches in the fast path.
 	 */
 	spin_lock_irq(&ctx->ctx_lock);
+	spin_lock(&req->head->lock);
 	if (!mask && !READ_ONCE(req->cancelled)) {
-		add_wait_queue(req->head, &req->wait);
+		/* Reschedule completion if another wakeup came in. */
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
@@ -1680,20 +1690,24 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & req->events))
 		return 0;
 
-	list_del_init(&req->wait.entry);
-
+	/*
+	 * Complete the iocb inline if possible.  This requires that two
+	 * conditions be met:
+	 *   1. The event mask must have been passed.  If a regular wakeup was
+	 *	done instead, then mask == 0 and we have to call vfs_poll() to
+	 *	get the events, so inline completion isn't possible.
+	 *   2. ctx_lock must not be busy.  We have to use trylock because we
+	 *      already hold the waitqueue lock, so this inverts the normal
+	 *      locking order.  Use irqsave/irqrestore because not all
+	 *      filesystems (e.g. fuse) call this function with IRQs disabled,
+	 *      yet IRQs have to be disabled before ctx_lock is obtained.
+	 */
 	if (mask && spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
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
 		if (iocb->ki_eventfd && eventfd_signal_allowed()) {
 			iocb = NULL;
 			INIT_WORK(&req->work, aio_poll_put_work);
@@ -1703,7 +1717,16 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		if (iocb)
 			iocb_put(iocb);
 	} else {
-		schedule_work(&req->work);
+		/*
+		 * Schedule the completion work if needed.  If it was already
+		 * scheduled, record that another wakeup came in.
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
@@ -1750,8 +1773,9 @@ static int aio_poll(struct aio_kiocb *aiocb, const struct iocb *iocb)
 	req->events = demangle_poll(iocb->aio_buf) | EPOLLERR | EPOLLHUP;
 
 	req->head = NULL;
-	req->done = false;
 	req->cancelled = false;
+	req->work_scheduled = false;
+	req->work_need_resched = false;
 
 	apt.pt._qproc = aio_poll_queue_proc;
 	apt.pt._key = req->events;
@@ -1766,17 +1790,21 @@ static int aio_poll(struct aio_kiocb *aiocb, const struct iocb *iocb)
 	spin_lock_irq(&ctx->ctx_lock);
 	if (likely(req->head)) {
 		spin_lock(&req->head->lock);
-		if (unlikely(list_empty(&req->wait.entry))) {
+		if (req->work_scheduled) {
+			/* async completion work was already scheduled */
 			if (apt.error)
 				cancel = true;
 			apt.error = 0;
 			mask = 0;
 		}
 		if (mask || apt.error) {
+			/* steal to complete synchronously */
 			list_del_init(&req->wait.entry);
 		} else if (cancel) {
+			/* cancel if possible (may be too late though) */
 			WRITE_ONCE(req->cancelled, true);
-		} else if (!req->done) { /* actually waiting for an event */
+		} else if (!list_empty(&req->wait.entry)) {
+			/* actually waiting for an event */
 			list_add_tail(&aiocb->ki_list, &ctx->active_reqs);
 			aiocb->ki_cancel = aio_poll_cancel;
 		}
-- 
2.34.1


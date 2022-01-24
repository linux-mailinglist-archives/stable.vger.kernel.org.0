Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD9B4980C7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbiAXNPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243015AbiAXNPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:15:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BEDC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 185876124D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE34C340E1;
        Mon, 24 Jan 2022 13:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643030152;
        bh=nSTW9ITa35Uqds0Scjcf/EXhTOpfpU5yzb54maL87RI=;
        h=Subject:To:Cc:From:Date:From;
        b=PqjxqoJ9RUOBYoGKoZpAn+hjLNdhBR432K/I5vosToa6IM5Oyr3YxOFzrcHYz7yi7
         ZA/gVTD1JrTOXwDfkxCwmjc5XmLZ/okE5hCv+Zn3LlIvIr5IZkubqzB+tlN5stlmt0
         x0i0tMq1+c64t0ubz4lMg/allPDSS5wfTlvGmET8=
Subject: FAILED: patch "[PATCH] io_uring: fix UAF due to missing POLLFREE handling" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, ebiggers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:15:38 +0100
Message-ID: <1643030138975@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 791f3465c4afde02d7f16cf7424ca87070b69396 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 14 Jan 2022 11:59:10 +0000
Subject: [PATCH] io_uring: fix UAF due to missing POLLFREE handling

Fixes a problem described in 50252e4b5e989
("aio: fix use-after-free due to missing POLLFREE handling")
and copies the approach used there.

In short, we have to forcibly eject a poll entry when we meet POLLFREE.
We can't rely on io_poll_get_ownership() as can't wait for potentially
running tw handlers, so we use the fact that wqs are RCU freed. See
Eric's patch and comments for more details.

Reported-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com
[axboe: drop non-functional change from patch]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa3277844d2e..422d6de48688 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5462,12 +5462,14 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 
 static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
 {
-	struct wait_queue_head *head = poll->head;
+	struct wait_queue_head *head = smp_load_acquire(&poll->head);
 
-	spin_lock_irq(&head->lock);
-	list_del_init(&poll->wait.entry);
-	poll->head = NULL;
-	spin_unlock_irq(&head->lock);
+	if (head) {
+		spin_lock_irq(&head->lock);
+		list_del_init(&poll->wait.entry);
+		poll->head = NULL;
+		spin_unlock_irq(&head->lock);
+	}
 }
 
 static void io_poll_remove_entries(struct io_kiocb *req)
@@ -5475,10 +5477,26 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	struct io_poll_iocb *poll = io_poll_get_single(req);
 	struct io_poll_iocb *poll_double = io_poll_get_double(req);
 
-	if (poll->head)
-		io_poll_remove_entry(poll);
-	if (poll_double && poll_double->head)
+	/*
+	 * While we hold the waitqueue lock and the waitqueue is nonempty,
+	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
+	 * lock in the first place can race with the waitqueue being freed.
+	 *
+	 * We solve this as eventpoll does: by taking advantage of the fact that
+	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
+	 * we enter rcu_read_lock() and see that the pointer to the queue is
+	 * non-NULL, we can then lock it without the memory being freed out from
+	 * under us.
+	 *
+	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
+	 * case the caller deletes the entry from the queue, leaving it empty.
+	 * In that case, only RCU prevents the queue memory from being freed.
+	 */
+	rcu_read_lock();
+	io_poll_remove_entry(poll);
+	if (poll_double)
 		io_poll_remove_entry(poll_double);
+	rcu_read_unlock();
 }
 
 /*
@@ -5618,6 +5636,30 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 						 wait);
 	__poll_t mask = key_to_poll(key);
 
+	if (unlikely(mask & POLLFREE)) {
+		io_poll_mark_cancelled(req);
+		/* we have to kick tw in case it's not already */
+		io_poll_execute(req, 0);
+
+		/*
+		 * If the waitqueue is being freed early but someone is already
+		 * holds ownership over it, we have to tear down the request as
+		 * best we can. That means immediately removing the request from
+		 * its waitqueue and preventing all further accesses to the
+		 * waitqueue via the request.
+		 */
+		list_del_init(&poll->wait.entry);
+
+		/*
+		 * Careful: this *must* be the last step, since as soon
+		 * as req->head is NULL'ed out, the request can be
+		 * completed and freed, since aio_poll_complete_work()
+		 * will no longer need to take the waitqueue lock.
+		 */
+		smp_store_release(&poll->head, NULL);
+		return 1;
+	}
+
 	/* for instances that support it check for an event match first */
 	if (mask && !(mask & poll->events))
 		return 0;


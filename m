Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4D5AAFB9
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiIBMnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbiIBMmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:42:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639F9E9255;
        Fri,  2 Sep 2022 05:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED083621A6;
        Fri,  2 Sep 2022 12:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E38C433D7;
        Fri,  2 Sep 2022 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121902;
        bh=a9DYgK2g59OD5cCAIuKdT7mUo0T9p9dpCE3R3Zs+vG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=klhIzGsdr08QCKXsewSLiES5fEYhOi8imtwGzGc3uCxoRlX5+wK2sNKlEJJ1vcAfZ
         wpAbH/KHTyR7lJUaSZQBKbjcHQpDF/30S+6sz6yO95gp0XbVUba8yp4gbRhF8bVxrK
         dGrgJVhNg6BBENcyLNEbPytqivcxUWFJDtdluX5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Subject: [PATCH 5.15 23/73] io_uring: fix UAF due to missing POLLFREE handling
Date:   Fri,  2 Sep 2022 14:18:47 +0200
Message-Id: <20220902121405.211182833@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commmit 791f3465c4afde02d7f16cf7424ca87070b69396 ]

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
[pavel: backport]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 8 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5369,12 +5369,14 @@ static void io_init_poll_iocb(struct io_
 
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
@@ -5382,10 +5384,26 @@ static void io_poll_remove_entries(struc
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
@@ -5523,6 +5541,30 @@ static int io_poll_wake(struct wait_queu
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



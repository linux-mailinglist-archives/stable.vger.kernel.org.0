Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA6D635855
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiKWJzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiKWJyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3749CE3D16
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C928861B44
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51ADC433D6;
        Wed, 23 Nov 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197016;
        bh=s8TwmhikQFi+dPZmiYoe2XRKrHbo3Fz36XTspp6JOUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goMrd+nvgyY0j/pAARRF7ueqbmOcNJ6FBhxyvVk1Mlay7q/7ujpMKmj/bT2Br362d
         JIXJnpmid89HuQPqz9rnGS6zdesbsW4eNdq8WPr62AlC4WPfz0g+ua02OrODXt9U4G
         1pO3W9RlYkLrudZxft2d87+l7RKy/u3szSQuftUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 144/314] io_uring/poll: fix double poll req->flags races
Date:   Wed, 23 Nov 2022 09:49:49 +0100
Message-Id: <20221123084632.073086046@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 30a33669fa21cd3dc7d92a00ba736358059014b7 ]

io_poll_double_prepare()            | io_poll_wake()
                                    | poll->head = NULL
smp_load(&poll->head); /* NULL */   |
flags = req->flags;                 |
                                    | req->flags &= ~SINGLE_POLL;
req->flags = flags | DOUBLE_POLL    |

The idea behind io_poll_double_prepare() is to serialise with the
first poll entry by taking the wq lock. However, it's not safe to assume
that io_poll_wake() is not running when we can't grab the lock and so we
may race modifying req->flags.

Skip double poll setup if that happens. It's ok because the first poll
entry will only be removed when it's definitely completing, e.g.
pollfree or oneshot with a valid mask.

Fixes: 49f1c68e048f1 ("io_uring: optimise submission side poll_refs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b7fab2d502f6121a7d7b199fe4d914a43ca9cdfd.1668184658.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/poll.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0d9f49c575e0..97c214aa688c 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -394,7 +394,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	return 1;
 }
 
-static void io_poll_double_prepare(struct io_kiocb *req)
+/* fails only when polling is already completing by the first entry */
+static bool io_poll_double_prepare(struct io_kiocb *req)
 {
 	struct wait_queue_head *head;
 	struct io_poll *poll = io_poll_get_single(req);
@@ -403,20 +404,20 @@ static void io_poll_double_prepare(struct io_kiocb *req)
 	rcu_read_lock();
 	head = smp_load_acquire(&poll->head);
 	/*
-	 * poll arm may not hold ownership and so race with
-	 * io_poll_wake() by modifying req->flags. There is only one
-	 * poll entry queued, serialise with it by taking its head lock.
+	 * poll arm might not hold ownership and so race for req->flags with
+	 * io_poll_wake(). There is only one poll entry queued, serialise with
+	 * it by taking its head lock. As we're still arming the tw hanlder
+	 * is not going to be run, so there are no races with it.
 	 */
-	if (head)
+	if (head) {
 		spin_lock_irq(&head->lock);
-
-	req->flags |= REQ_F_DOUBLE_POLL;
-	if (req->opcode == IORING_OP_POLL_ADD)
-		req->flags |= REQ_F_ASYNC_DATA;
-
-	if (head)
+		req->flags |= REQ_F_DOUBLE_POLL;
+		if (req->opcode == IORING_OP_POLL_ADD)
+			req->flags |= REQ_F_ASYNC_DATA;
 		spin_unlock_irq(&head->lock);
+	}
 	rcu_read_unlock();
+	return !!head;
 }
 
 static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
@@ -454,7 +455,11 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 		/* mark as double wq entry */
 		wqe_private |= IO_WQE_F_DOUBLE;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
-		io_poll_double_prepare(req);
+		if (!io_poll_double_prepare(req)) {
+			/* the request is completing, just back off */
+			kfree(poll);
+			return;
+		}
 		*poll_ptr = poll;
 	} else {
 		/* fine to modify, there is no poll queued to race with us */
-- 
2.35.1




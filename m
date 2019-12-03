Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F024A111C04
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfLCWj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbfLCWj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4247D20803;
        Tue,  3 Dec 2019 22:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412765;
        bh=vYI+vGSC1ZWE4PZB7cBETX+gWlmKph+RXwAAx5znR1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvlnaC7vQVLr4eHw+5ANZ5RBKccD1/t04xP9nd3AZzqzna6t8b0jyrETMOcgL7YTl
         bd1c/3i2fCgLlJDTU8kT5ukLq5tUjynj1b5qA8kuGi/raGeK+LD5vZ//aoQBeKigw5
         EPtYF/5GV6A56zQnElkyNkkqjDF5F8zeSSgxdzuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 001/135] io_uring: async workers should inherit the user creds
Date:   Tue,  3 Dec 2019 23:34:01 +0100
Message-Id: <20191203213006.034386207@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 181e448d8709e517c9c7b523fcd209f24eb38ca7 ]

If we don't inherit the original task creds, then we can confuse users
like fuse that pass creds in the request header. See link below on
identical aio issue.

Link: https://lore.kernel.org/linux-fsdevel/26f0d78e-99ca-2f1b-78b9-433088053a61@scylladb.com/T/#u
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 56c23dee98117..f563a581b924c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -260,6 +260,8 @@ struct io_ring_ctx {
 
 	struct user_struct	*user;
 
+	struct cred		*creds;
+
 	struct completion	ctx_done;
 
 	struct {
@@ -1633,8 +1635,11 @@ static void io_poll_complete_work(struct work_struct *work)
 	struct io_poll_iocb *poll = &req->poll;
 	struct poll_table_struct pt = { ._key = poll->events };
 	struct io_ring_ctx *ctx = req->ctx;
+	const struct cred *old_cred;
 	__poll_t mask = 0;
 
+	old_cred = override_creds(ctx->creds);
+
 	if (!READ_ONCE(poll->canceled))
 		mask = vfs_poll(poll->file, &pt) & poll->events;
 
@@ -1649,7 +1654,7 @@ static void io_poll_complete_work(struct work_struct *work)
 	if (!mask && !READ_ONCE(poll->canceled)) {
 		add_wait_queue(poll->head, &poll->wait);
 		spin_unlock_irq(&ctx->completion_lock);
-		return;
+		goto out;
 	}
 	list_del_init(&req->list);
 	io_poll_complete(ctx, req, mask);
@@ -1657,6 +1662,8 @@ static void io_poll_complete_work(struct work_struct *work)
 
 	io_cqring_ev_posted(ctx);
 	io_put_req(req);
+out:
+	revert_creds(old_cred);
 }
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -1906,10 +1913,12 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct mm_struct *cur_mm = NULL;
 	struct async_list *async_list;
+	const struct cred *old_cred;
 	LIST_HEAD(req_list);
 	mm_segment_t old_fs;
 	int ret;
 
+	old_cred = override_creds(ctx->creds);
 	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
 restart:
 	do {
@@ -2017,6 +2026,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
+	revert_creds(old_cred);
 }
 
 /*
@@ -2354,6 +2364,7 @@ static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
 	struct mm_struct *cur_mm = NULL;
+	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
 	unsigned inflight;
@@ -2363,6 +2374,7 @@ static int io_sq_thread(void *data)
 
 	old_fs = get_fs();
 	set_fs(USER_DS);
+	old_cred = override_creds(ctx->creds);
 
 	timeout = inflight = 0;
 	while (!kthread_should_park()) {
@@ -2473,6 +2485,7 @@ static int io_sq_thread(void *data)
 		unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
+	revert_creds(old_cred);
 
 	kthread_parkme();
 
@@ -3142,6 +3155,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_unaccount_mem(ctx->user,
 				ring_pages(ctx->sq_entries, ctx->cq_entries));
 	free_uid(ctx->user);
+	if (ctx->creds)
+		put_cred(ctx->creds);
 	kfree(ctx);
 }
 
@@ -3419,6 +3434,12 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	ctx->account_mem = account_mem;
 	ctx->user = user;
 
+	ctx->creds = prepare_creds();
+	if (!ctx->creds) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
 	ret = io_allocate_scq_urings(ctx, p);
 	if (ret)
 		goto err;
-- 
2.20.1




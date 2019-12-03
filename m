Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216C0111BC7
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfLCWhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:37:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbfLCWhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:37:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFFE2073C;
        Tue,  3 Dec 2019 22:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412643;
        bh=oy5MgZd9FE8jJtqyAzpj1hr20GefxSGVoZjV5oMZD9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlscqmltlyLrDfCCW7yfOajUpPdiyJuOoUI1FZEUiknSK/q567GNC37+UelFgOKx/
         YxKnf13o0pQ1ix7G3FbWZ6QZXmnni4Wqt1NoOEdxRAgrVRR558zCVKx5mND5s0EbA0
         Xwf2Dk0az0CElibxPkiMkV0VBDAXugPggaJeEpHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/46] io_uring: async workers should inherit the user creds
Date:   Tue,  3 Dec 2019 23:35:21 +0100
Message-Id: <20191203212706.684429867@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
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
index 2c819c3c855d2..cbe8dabb6479c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -238,6 +238,8 @@ struct io_ring_ctx {
 
 	struct user_struct	*user;
 
+	struct cred		*creds;
+
 	struct completion	ctx_done;
 
 	struct {
@@ -1752,8 +1754,11 @@ static void io_poll_complete_work(struct work_struct *work)
 	struct io_poll_iocb *poll = &req->poll;
 	struct poll_table_struct pt = { ._key = poll->events };
 	struct io_ring_ctx *ctx = req->ctx;
+	const struct cred *old_cred;
 	__poll_t mask = 0;
 
+	old_cred = override_creds(ctx->creds);
+
 	if (!READ_ONCE(poll->canceled))
 		mask = vfs_poll(poll->file, &pt) & poll->events;
 
@@ -1768,7 +1773,7 @@ static void io_poll_complete_work(struct work_struct *work)
 	if (!mask && !READ_ONCE(poll->canceled)) {
 		add_wait_queue(poll->head, &poll->wait);
 		spin_unlock_irq(&ctx->completion_lock);
-		return;
+		goto out;
 	}
 	list_del_init(&req->list);
 	io_poll_complete(ctx, req, mask);
@@ -1776,6 +1781,8 @@ static void io_poll_complete_work(struct work_struct *work)
 
 	io_cqring_ev_posted(ctx);
 	io_put_req(req);
+out:
+	revert_creds(old_cred);
 }
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -2147,10 +2154,12 @@ static void io_sq_wq_submit_work(struct work_struct *work)
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
@@ -2258,6 +2267,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
+	revert_creds(old_cred);
 }
 
 /*
@@ -2663,6 +2673,7 @@ static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
 	struct mm_struct *cur_mm = NULL;
+	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
 	unsigned inflight;
@@ -2672,6 +2683,7 @@ static int io_sq_thread(void *data)
 
 	old_fs = get_fs();
 	set_fs(USER_DS);
+	old_cred = override_creds(ctx->creds);
 
 	timeout = inflight = 0;
 	while (!kthread_should_park()) {
@@ -2782,6 +2794,7 @@ static int io_sq_thread(void *data)
 		unuse_mm(cur_mm);
 		mmput(cur_mm);
 	}
+	revert_creds(old_cred);
 
 	kthread_parkme();
 
@@ -3567,6 +3580,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_unaccount_mem(ctx->user,
 				ring_pages(ctx->sq_entries, ctx->cq_entries));
 	free_uid(ctx->user);
+	if (ctx->creds)
+		put_cred(ctx->creds);
 	kfree(ctx);
 }
 
@@ -3838,6 +3853,12 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
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




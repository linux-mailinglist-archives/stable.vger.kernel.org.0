Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4C321720D
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgGGP2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:28:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729176AbgGGP2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:28:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16F320663;
        Tue,  7 Jul 2020 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135682;
        bh=BLq+7ekXzyO3NbF70Wi6NnkYVRG+s2BoLo1H7UPaafU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCGrX1ck6tOVZsA9/g1ojtqRTYcrXsOipcsu1jmWEJOZxvJIVomPNyToCKfhyoz24
         Y/bHc5vQheGoKehncqOXT+6kqYbiDKj5dH0JVIy+qYJ1Xra472nS9pDuGa8bIGzjHR
         w1rNraIzg4Bs0OKucSXN8f+gUMc/KVqP7sB8dDi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Agarwal, Anchal" <anchalag@amazon.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/65] io_uring: make sure async workqueue is canceled on exit
Date:   Tue,  7 Jul 2020 17:16:40 +0200
Message-Id: <20200707145752.491283624@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
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

Track async work items that we queue, so we can safely cancel them
if the ring is closed or the process exits. Newer kernels handle
this automatically with io-wq, but the old workqueue based setup needs
a bit of special help to get there.

There's no upstream variant of this, as that would require backporting
all the io-wq changes from 5.5 and on. Hence I made a one-off that
ensures that we don't leak memory if we have async work items that
need active cancelation (like socket IO).

Reported-by: Agarwal, Anchal <anchalag@amazon.com>
Tested-by: Agarwal, Anchal <anchalag@amazon.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fa3cd3fff4d2..e0200406765c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -267,6 +267,9 @@ struct io_ring_ctx {
 #if defined(CONFIG_UNIX)
 	struct socket		*ring_sock;
 #endif
+
+	struct list_head	task_list;
+	spinlock_t		task_lock;
 };
 
 struct sqe_submit {
@@ -331,14 +334,18 @@ struct io_kiocb {
 #define REQ_F_ISREG		2048	/* regular file */
 #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
 #define REQ_F_TIMEOUT_NOSEQ	8192	/* no timeout sequence */
+#define REQ_F_CANCEL		16384	/* cancel request */
 	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
+	struct task_struct	*task;
 
 	struct fs_struct	*fs;
 
 	struct work_struct	work;
+	struct task_struct	*work_task;
+	struct list_head	task_list;
 };
 
 #define IO_PLUG_THRESHOLD		2
@@ -425,6 +432,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cancel_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
+	INIT_LIST_HEAD(&ctx->task_list);
+	spin_lock_init(&ctx->task_lock);
 	return ctx;
 }
 
@@ -492,6 +501,7 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 				       struct io_kiocb *req)
 {
+	unsigned long flags;
 	int rw = 0;
 
 	if (req->submit.sqe) {
@@ -503,6 +513,13 @@ static inline void io_queue_async_work(struct io_ring_ctx *ctx,
 		}
 	}
 
+	req->task = current;
+
+	spin_lock_irqsave(&ctx->task_lock, flags);
+	list_add(&req->task_list, &ctx->task_list);
+	req->work_task = NULL;
+	spin_unlock_irqrestore(&ctx->task_lock, flags);
+
 	queue_work(ctx->sqo_wq[rw], &req->work);
 }
 
@@ -2201,6 +2218,8 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 
 	old_cred = override_creds(ctx->creds);
 	async_list = io_async_list_from_sqe(ctx, req->submit.sqe);
+
+	allow_kernel_signal(SIGINT);
 restart:
 	do {
 		struct sqe_submit *s = &req->submit;
@@ -2232,6 +2251,12 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 		}
 
 		if (!ret) {
+			req->work_task = current;
+			if (req->flags & REQ_F_CANCEL) {
+				ret = -ECANCELED;
+				goto end_req;
+			}
+
 			s->has_user = cur_mm != NULL;
 			s->needs_lock = true;
 			do {
@@ -2246,6 +2271,12 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 					break;
 				cond_resched();
 			} while (1);
+end_req:
+			if (!list_empty(&req->task_list)) {
+				spin_lock_irq(&ctx->task_lock);
+				list_del_init(&req->task_list);
+				spin_unlock_irq(&ctx->task_lock);
+			}
 		}
 
 		/* drop submission reference */
@@ -2311,6 +2342,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 	}
 
 out:
+	disallow_signal(SIGINT);
 	if (cur_mm) {
 		set_fs(old_fs);
 		unuse_mm(cur_mm);
@@ -3675,12 +3707,32 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
 }
 
+static void io_cancel_async_work(struct io_ring_ctx *ctx,
+				 struct task_struct *task)
+{
+	if (list_empty(&ctx->task_list))
+		return;
+
+	spin_lock_irq(&ctx->task_lock);
+	while (!list_empty(&ctx->task_list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&ctx->task_list, struct io_kiocb, task_list);
+		list_del_init(&req->task_list);
+		req->flags |= REQ_F_CANCEL;
+		if (req->work_task && (!task || req->task == task))
+			send_sig(SIGINT, req->work_task, 1);
+	}
+	spin_unlock_irq(&ctx->task_lock);
+}
+
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
+	io_cancel_async_work(ctx, NULL);
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
 	io_iopoll_reap_events(ctx);
@@ -3688,6 +3740,16 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	io_ring_ctx_free(ctx);
 }
 
+static int io_uring_flush(struct file *file, void *data)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_cancel_async_work(ctx, current);
+
+	return 0;
+}
+
 static int io_uring_release(struct inode *inode, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
@@ -3792,6 +3854,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
+	.flush		= io_uring_flush,
 	.mmap		= io_uring_mmap,
 	.poll		= io_uring_poll,
 	.fasync		= io_uring_fasync,
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4272A1605
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgJaLk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbgJaLk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:40:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E732087D;
        Sat, 31 Oct 2020 11:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144455;
        bh=n0i98aVi3CGLMn6dUOTfIYdjC2ANdIrUMKI9lSPOILU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQQRsEVId8x9XHgjHDSOcnen5HUsnX/PmdhFEWdo18hQRvZhJsSAzEcQMcpDP9XAA
         6ng1dKZ/B5XXbcWprESBaBG6Rcbv2o5zgfxbrpmw48Uy2j9zaL+UADIZKuCulkdXKv
         vusjEEUBljLHeP5ClO9AF8xGYe0JAiG1Z8zAIKh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 09/70] io_uring: dont rely on weak ->files references
Date:   Sat, 31 Oct 2020 12:35:41 +0100
Message-Id: <20201031113459.943389893@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 0f2122045b946241a9e549c2a76cea54fa58a7ff upstream.

Grab actual references to the files_struct. To avoid circular references
issues due to this, we add a per-task note that keeps track of what
io_uring contexts a task has used. When the tasks execs or exits its
assigned files, we cancel requests based on this tracking.

With that, we can grab proper references to the files table, and no
longer need to rely on stashing away ring_fd and ring_file to check
if the ring_fd may have been closed.

Cc: stable@vger.kernel.org # v5.5+
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c                |    6 
 fs/file.c                |    2 
 fs/io_uring.c            |  301 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/io_uring.h |   53 ++++++++
 include/linux/sched.h    |    5 
 init/init_task.c         |    3 
 kernel/fork.c            |    6 
 7 files changed, 340 insertions(+), 36 deletions(-)
 create mode 100644 include/linux/io_uring.h

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -62,6 +62,7 @@
 #include <linux/oom.h>
 #include <linux/compat.h>
 #include <linux/vmalloc.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1847,6 +1848,11 @@ static int __do_execve_file(int fd, stru
 	 * further execve() calls fail. */
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
+	/*
+	 * Cancel any io_uring activity across execve
+	 */
+	io_uring_task_cancel();
+
 	retval = unshare_files(&displaced);
 	if (retval)
 		goto out_ret;
--- a/fs/file.c
+++ b/fs/file.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/io_uring.h>
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
@@ -439,6 +440,7 @@ void exit_files(struct task_struct *tsk)
 	struct files_struct * files = tsk->files;
 
 	if (files) {
+		io_uring_files_cancel(files);
 		task_lock(tsk);
 		tsk->files = NULL;
 		task_unlock(tsk);
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -78,6 +78,7 @@
 #include <linux/fs_struct.h>
 #include <linux/splice.h>
 #include <linux/task_work.h>
+#include <linux/io_uring.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -283,8 +284,6 @@ struct io_ring_ctx {
 	 */
 	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
-	int 			ring_fd;
-	struct file 		*ring_file;
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
@@ -1335,7 +1334,12 @@ static void __io_cqring_fill_event(struc
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
-	} else if (ctx->cq_overflow_flushed) {
+	} else if (ctx->cq_overflow_flushed || req->task->io_uring->in_idle) {
+		/*
+		 * If we're in ring overflow flush mode, or in task cancel mode,
+		 * then we cannot store the request for later flushing, we need
+		 * to drop it on the floor.
+		 */
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
 	} else {
@@ -1451,17 +1455,22 @@ static void io_req_drop_files(struct io_
 		wake_up(&ctx->inflight_wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
+	put_files_struct(req->work.files);
 	req->work.files = NULL;
 }
 
 static void __io_req_aux_free(struct io_kiocb *req)
 {
+	struct io_uring_task *tctx = req->task->io_uring;
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
 
 	kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
+	atomic_long_inc(&tctx->req_complete);
+	if (tctx->in_idle)
+		wake_up(&tctx->wait);
 	put_task_struct(req->task);
 	io_req_work_drop_env(req);
 }
@@ -3532,8 +3541,7 @@ static int io_close_prep(struct io_kiocb
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if ((req->file && req->file->f_op == &io_uring_fops) ||
-	    req->close.fd == req->ctx->ring_fd)
+	if ((req->file && req->file->f_op == &io_uring_fops))
 		return -EBADF;
 
 	req->close.put_file = NULL;
@@ -5671,32 +5679,18 @@ static int io_req_set_file(struct io_sub
 
 static int io_grab_files(struct io_kiocb *req)
 {
-	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
-	if (!ctx->ring_file)
-		return -EBADF;
 
-	rcu_read_lock();
+	req->work.files = get_files_struct(current);
+	req->flags |= REQ_F_INFLIGHT;
+
 	spin_lock_irq(&ctx->inflight_lock);
-	/*
-	 * We use the f_ops->flush() handler to ensure that we can flush
-	 * out work accessing these files if the fd is closed. Check if
-	 * the fd has changed since we started down this path, and disallow
-	 * this operation if it has.
-	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		req->flags |= REQ_F_INFLIGHT;
-		req->work.files = current->files;
-		ret = 0;
-	}
+	list_add(&req->inflight_entry, &ctx->inflight_list);
 	spin_unlock_irq(&ctx->inflight_lock);
-	rcu_read_unlock();
-
-	return ret;
+	return 0;
 }
 
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
@@ -6067,6 +6061,7 @@ static int io_init_req(struct io_ring_ct
 	refcount_set(&req->refs, 2);
 	req->task = current;
 	get_task_struct(req->task);
+	atomic_long_inc(&req->task->io_uring->req_issue);
 	req->result = 0;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
@@ -6102,8 +6097,7 @@ static int io_init_req(struct io_ring_ct
 	return io_req_set_file(state, req, READ_ONCE(sqe->fd));
 }
 
-static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
-			  struct file *ring_file, int ring_fd)
+static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
@@ -6127,9 +6121,6 @@ static int io_submit_sqes(struct io_ring
 		statep = &state;
 	}
 
-	ctx->ring_fd = ring_fd;
-	ctx->ring_file = ring_file;
-
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
@@ -6290,7 +6281,7 @@ static int io_sq_thread(void *data)
 
 		mutex_lock(&ctx->uring_lock);
 		if (likely(!percpu_ref_is_dying(&ctx->refs)))
-			ret = io_submit_sqes(ctx, to_submit, NULL, -1);
+			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
@@ -7119,6 +7110,34 @@ out_fput:
 	return ret;
 }
 
+static int io_uring_alloc_task_context(struct task_struct *task)
+{
+	struct io_uring_task *tctx;
+
+	tctx = kmalloc(sizeof(*tctx), GFP_KERNEL);
+	if (unlikely(!tctx))
+		return -ENOMEM;
+
+	xa_init(&tctx->xa);
+	init_waitqueue_head(&tctx->wait);
+	tctx->last = NULL;
+	tctx->in_idle = 0;
+	atomic_long_set(&tctx->req_issue, 0);
+	atomic_long_set(&tctx->req_complete, 0);
+	task->io_uring = tctx;
+	return 0;
+}
+
+void __io_uring_free(struct task_struct *tsk)
+{
+	struct io_uring_task *tctx = tsk->io_uring;
+
+	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	xa_destroy(&tctx->xa);
+	kfree(tctx);
+	tsk->io_uring = NULL;
+}
+
 static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			       struct io_uring_params *p)
 {
@@ -7154,6 +7173,9 @@ static int io_sq_offload_start(struct io
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
+		ret = io_uring_alloc_task_context(ctx->sqo_thread);
+		if (ret)
+			goto err;
 		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
@@ -7633,7 +7655,7 @@ static bool io_wq_files_match(struct io_
 {
 	struct files_struct *files = data;
 
-	return work->files == files;
+	return !files || work->files == files;
 }
 
 /*
@@ -7787,7 +7809,7 @@ static bool io_uring_cancel_files(struct
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->work.files != files)
+			if (files && req->work.files != files)
 				continue;
 			/* req is being completed, ignore */
 			if (!refcount_inc_not_zero(&req->refs))
@@ -7850,18 +7872,217 @@ static bool io_cancel_task_cb(struct io_
 	return io_task_match(req, task);
 }
 
+static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task,
+					    struct files_struct *files)
+{
+	bool ret;
+
+	ret = io_uring_cancel_files(ctx, files);
+	if (!files) {
+		enum io_wq_cancel cret;
+
+		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
+		if (cret != IO_WQ_CANCEL_NOTFOUND)
+			ret = true;
+
+		/* SQPOLL thread does its own polling */
+		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+			if (!list_empty_careful(&ctx->poll_list)) {
+				io_iopoll_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_poll_remove_all(ctx, task);
+		ret |= io_kill_timeouts(ctx, task);
+	}
+
+	return ret;
+}
+
+/*
+ * We need to iteratively cancel requests, in case a request has dependent
+ * hard links. These persist even for failure of cancelations, hence keep
+ * looping until none are found.
+ */
+static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					  struct files_struct *files)
+{
+	struct task_struct *task = current;
+
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		task = ctx->sqo_thread;
+
+	io_cqring_overflow_flush(ctx, true, task, files);
+
+	while (__io_uring_cancel_task_requests(ctx, task, files)) {
+		io_run_task_work();
+		cond_resched();
+	}
+}
+
+/*
+ * Note that this task has used io_uring. We use it for cancelation purposes.
+ */
+static int io_uring_add_task_file(struct file *file)
+{
+	if (unlikely(!current->io_uring)) {
+		int ret;
+
+		ret = io_uring_alloc_task_context(current);
+		if (unlikely(ret))
+			return ret;
+	}
+	if (current->io_uring->last != file) {
+		XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
+		void *old;
+
+		rcu_read_lock();
+		old = xas_load(&xas);
+		if (old != file) {
+			get_file(file);
+			xas_lock(&xas);
+			xas_store(&xas, file);
+			xas_unlock(&xas);
+		}
+		rcu_read_unlock();
+		current->io_uring->last = file;
+	}
+
+	return 0;
+}
+
+/*
+ * Remove this io_uring_file -> task mapping.
+ */
+static void io_uring_del_task_file(struct file *file)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	XA_STATE(xas, &tctx->xa, (unsigned long) file);
+
+	if (tctx->last == file)
+		tctx->last = NULL;
+
+	xas_lock(&xas);
+	file = xas_store(&xas, NULL);
+	xas_unlock(&xas);
+
+	if (file)
+		fput(file);
+}
+
+static void __io_uring_attempt_task_drop(struct file *file)
+{
+	XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
+	struct file *old;
+
+	rcu_read_lock();
+	old = xas_load(&xas);
+	rcu_read_unlock();
+
+	if (old == file)
+		io_uring_del_task_file(file);
+}
+
+/*
+ * Drop task note for this file if we're the only ones that hold it after
+ * pending fput()
+ */
+static void io_uring_attempt_task_drop(struct file *file, bool exiting)
+{
+	if (!current->io_uring)
+		return;
+	/*
+	 * fput() is pending, will be 2 if the only other ref is our potential
+	 * task file note. If the task is exiting, drop regardless of count.
+	 */
+	if (!exiting && atomic_long_read(&file->f_count) != 2)
+		return;
+
+	__io_uring_attempt_task_drop(file);
+}
+
+void __io_uring_files_cancel(struct files_struct *files)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	XA_STATE(xas, &tctx->xa, 0);
+
+	/* make sure overflow events are dropped */
+	tctx->in_idle = true;
+
+	do {
+		struct io_ring_ctx *ctx;
+		struct file *file;
+
+		xas_lock(&xas);
+		file = xas_next_entry(&xas, ULONG_MAX);
+		xas_unlock(&xas);
+
+		if (!file)
+			break;
+
+		ctx = file->private_data;
+
+		io_uring_cancel_task_requests(ctx, files);
+		if (files)
+			io_uring_del_task_file(file);
+	} while (1);
+}
+
+static inline bool io_uring_task_idle(struct io_uring_task *tctx)
+{
+	return atomic_long_read(&tctx->req_issue) ==
+		atomic_long_read(&tctx->req_complete);
+}
+
+/*
+ * Find any io_uring fd that this task has registered or done IO on, and cancel
+ * requests.
+ */
+void __io_uring_task_cancel(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	DEFINE_WAIT(wait);
+	long completions;
+
+	/* make sure overflow events are dropped */
+	tctx->in_idle = true;
+
+	while (!io_uring_task_idle(tctx)) {
+		/* read completions before cancelations */
+		completions = atomic_long_read(&tctx->req_complete);
+		__io_uring_files_cancel(NULL);
+
+		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+
+		/*
+		 * If we've seen completions, retry. This avoids a race where
+		 * a completion comes in before we did prepare_to_wait().
+		 */
+		if (completions != atomic_long_read(&tctx->req_complete))
+			continue;
+		if (io_uring_task_idle(tctx))
+			break;
+		schedule();
+	}
+
+	finish_wait(&tctx->wait, &wait);
+	tctx->in_idle = false;
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
-	io_uring_cancel_files(ctx, data);
-
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
+		data = NULL;
 
+	io_uring_cancel_task_requests(ctx, data);
+	io_uring_attempt_task_drop(file, !data);
 	return 0;
 }
 
@@ -7975,8 +8196,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
+		ret = io_uring_add_task_file(f.file);
+		if (unlikely(ret))
+			goto out;
 		mutex_lock(&ctx->uring_lock);
-		submitted = io_submit_sqes(ctx, to_submit, f.file, fd);
+		submitted = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (submitted != to_submit)
@@ -8188,6 +8412,7 @@ static int io_uring_get_fd(struct io_rin
 	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
 					O_RDWR | O_CLOEXEC);
 	if (IS_ERR(file)) {
+err_fd:
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
 		goto err;
@@ -8196,6 +8421,10 @@ static int io_uring_get_fd(struct io_rin
 #if defined(CONFIG_UNIX)
 	ctx->ring_sock->file = file;
 #endif
+	if (unlikely(io_uring_add_task_file(file))) {
+		file = ERR_PTR(-ENOMEM);
+		goto err_fd;
+	}
 	fd_install(ret, file);
 	return ret;
 err:
--- /dev/null
+++ b/include/linux/io_uring.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_H
+#define _LINUX_IO_URING_H
+
+#include <linux/sched.h>
+#include <linux/xarray.h>
+#include <linux/percpu-refcount.h>
+
+struct io_uring_task {
+	/* submission side */
+	struct xarray		xa;
+	struct wait_queue_head	wait;
+	struct file		*last;
+	atomic_long_t		req_issue;
+
+	/* completion side */
+	bool			in_idle ____cacheline_aligned_in_smp;
+	atomic_long_t		req_complete;
+};
+
+#if defined(CONFIG_IO_URING)
+void __io_uring_task_cancel(void);
+void __io_uring_files_cancel(struct files_struct *files);
+void __io_uring_free(struct task_struct *tsk);
+
+static inline void io_uring_task_cancel(void)
+{
+	if (current->io_uring && !xa_empty(&current->io_uring->xa))
+		__io_uring_task_cancel();
+}
+static inline void io_uring_files_cancel(struct files_struct *files)
+{
+	if (current->io_uring && !xa_empty(&current->io_uring->xa))
+		__io_uring_files_cancel(files);
+}
+static inline void io_uring_free(struct task_struct *tsk)
+{
+	if (tsk->io_uring)
+		__io_uring_free(tsk);
+}
+#else
+static inline void io_uring_task_cancel(void)
+{
+}
+static inline void io_uring_files_cancel(struct files_struct *files)
+{
+}
+static inline void io_uring_free(struct task_struct *tsk)
+{
+}
+#endif
+
+#endif
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -61,6 +61,7 @@ struct sighand_struct;
 struct signal_struct;
 struct task_delay_info;
 struct task_group;
+struct io_uring_task;
 
 /*
  * Task state bitmask. NOTE! These bits are also
@@ -923,6 +924,10 @@ struct task_struct {
 	/* Open file information: */
 	struct files_struct		*files;
 
+#ifdef CONFIG_IO_URING
+	struct io_uring_task		*io_uring;
+#endif
+
 	/* Namespaces: */
 	struct nsproxy			*nsproxy;
 
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -113,6 +113,9 @@ struct task_struct init_task
 	.thread		= INIT_THREAD,
 	.fs		= &init_fs,
 	.files		= &init_files,
+#ifdef CONFIG_IO_URING
+	.io_uring	= NULL,
+#endif
 	.signal		= &init_signals,
 	.sighand	= &init_sighand,
 	.nsproxy	= &init_nsproxy,
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -95,6 +95,7 @@
 #include <linux/stackleak.h>
 #include <linux/kasan.h>
 #include <linux/scs.h>
+#include <linux/io_uring.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -745,6 +746,7 @@ void __put_task_struct(struct task_struc
 	WARN_ON(refcount_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	io_uring_free(tsk);
 	cgroup_free(tsk);
 	task_numa_free(tsk, true);
 	security_task_free(tsk);
@@ -2022,6 +2024,10 @@ static __latent_entropy struct task_stru
 	p->vtime.state = VTIME_INACTIVE;
 #endif
 
+#ifdef CONFIG_IO_URING
+	p->io_uring = NULL;
+#endif
+
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif



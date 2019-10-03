Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1876CA456
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389827AbfJCQXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390637AbfJCQXu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7794521A4C;
        Thu,  3 Oct 2019 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119829;
        bh=5kOGsLFcc085JBeDpdale80pGg9vAEsNkc8ZCJj6BDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkWyQcselcozXSYf3skVcXgzNv6/AB46KFtxzwsd1QoTeWZt28xxpip296kfojZRf
         iRKh65BYp7IyNwJCtZQnnzUm6d/RawmdhEkn2KwD6x2gf9t7K1Ixa8YfABI4WcNGz3
         kCZcx8jzmuRo6BOGg8dTNzhRXgjkDvpO8yETnNVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af05535bb79520f95431@syzkaller.appspotmail.com,
        syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Eric Biggers <ebiggers@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 209/211] fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock
Date:   Thu,  3 Oct 2019 17:54:35 +0200
Message-Id: <20191003154530.645657617@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 76e43c8ccaa35c30d5df853013561145a0f750a5 ]

When IOCB_CMD_POLL is used on the FUSE device, aio_poll() disables IRQs
and takes kioctx::ctx_lock, then fuse_iqueue::waitq.lock.

This may have to wait for fuse_iqueue::waitq.lock to be released by one
of many places that take it with IRQs enabled.  Since the IRQ handler
may take kioctx::ctx_lock, lockdep reports that a deadlock is possible.

Fix it by protecting the state of struct fuse_iqueue with a separate
spinlock, and only accessing fuse_iqueue::waitq using the versions of
the waitqueue functions which do IRQ-safe locking internally.

Reproducer:

	#include <fcntl.h>
	#include <stdio.h>
	#include <sys/mount.h>
	#include <sys/stat.h>
	#include <sys/syscall.h>
	#include <unistd.h>
	#include <linux/aio_abi.h>

	int main()
	{
		char opts[128];
		int fd = open("/dev/fuse", O_RDWR);
		aio_context_t ctx = 0;
		struct iocb cb = { .aio_lio_opcode = IOCB_CMD_POLL, .aio_fildes = fd };
		struct iocb *cbp = &cb;

		sprintf(opts, "fd=%d,rootmode=040000,user_id=0,group_id=0", fd);
		mkdir("mnt", 0700);
		mount("foo",  "mnt", "fuse", 0, opts);
		syscall(__NR_io_setup, 1, &ctx);
		syscall(__NR_io_submit, ctx, 1, &cbp);
	}

Beginning of lockdep output:

	=====================================================
	WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
	5.3.0-rc5 #9 Not tainted
	-----------------------------------------------------
	syz_fuse/135 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
	000000003590ceda (&fiq->waitq){+.+.}, at: spin_lock include/linux/spinlock.h:338 [inline]
	000000003590ceda (&fiq->waitq){+.+.}, at: aio_poll fs/aio.c:1751 [inline]
	000000003590ceda (&fiq->waitq){+.+.}, at: __io_submit_one.constprop.0+0x203/0x5b0 fs/aio.c:1825

	and this task is already holding:
	0000000075037284 (&(&ctx->ctx_lock)->rlock){..-.}, at: spin_lock_irq include/linux/spinlock.h:363 [inline]
	0000000075037284 (&(&ctx->ctx_lock)->rlock){..-.}, at: aio_poll fs/aio.c:1749 [inline]
	0000000075037284 (&(&ctx->ctx_lock)->rlock){..-.}, at: __io_submit_one.constprop.0+0x1f4/0x5b0 fs/aio.c:1825
	which would create a new lock dependency:
	 (&(&ctx->ctx_lock)->rlock){..-.} -> (&fiq->waitq){+.+.}

	but this new dependency connects a SOFTIRQ-irq-safe lock:
	 (&(&ctx->ctx_lock)->rlock){..-.}

	[...]

Reported-by: syzbot+af05535bb79520f95431@syzkaller.appspotmail.com
Reported-by: syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com
Fixes: bfe4037e722e ("aio: implement IOCB_CMD_POLL")
Cc: <stable@vger.kernel.org> # v4.19+
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c    | 89 +++++++++++++++++++++++++-----------------------
 fs/fuse/fuse_i.h |  3 ++
 fs/fuse/inode.c  |  1 +
 3 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 6ee471b72a34d..c0d59a86ada2e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -331,7 +331,7 @@ static void queue_request(struct fuse_iqueue *fiq, struct fuse_req *req)
 	req->in.h.len = sizeof(struct fuse_in_header) +
 		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
 	list_add_tail(&req->list, &fiq->pending);
-	wake_up_locked(&fiq->waitq);
+	wake_up(&fiq->waitq);
 	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 }
 
@@ -343,16 +343,16 @@ void fuse_queue_forget(struct fuse_conn *fc, struct fuse_forget_link *forget,
 	forget->forget_one.nodeid = nodeid;
 	forget->forget_one.nlookup = nlookup;
 
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	if (fiq->connected) {
 		fiq->forget_list_tail->next = forget;
 		fiq->forget_list_tail = forget;
-		wake_up_locked(&fiq->waitq);
+		wake_up(&fiq->waitq);
 		kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 	} else {
 		kfree(forget);
 	}
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 }
 
 static void flush_bg_queue(struct fuse_conn *fc)
@@ -365,10 +365,10 @@ static void flush_bg_queue(struct fuse_conn *fc)
 		req = list_entry(fc->bg_queue.next, struct fuse_req, list);
 		list_del(&req->list);
 		fc->active_background++;
-		spin_lock(&fiq->waitq.lock);
+		spin_lock(&fiq->lock);
 		req->in.h.unique = fuse_get_unique(fiq);
 		queue_request(fiq, req);
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 	}
 }
 
@@ -387,9 +387,9 @@ static void request_end(struct fuse_conn *fc, struct fuse_req *req)
 	if (test_and_set_bit(FR_FINISHED, &req->flags))
 		goto put_request;
 
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	list_del_init(&req->intr_entry);
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	WARN_ON(test_bit(FR_PENDING, &req->flags));
 	WARN_ON(test_bit(FR_SENT, &req->flags));
 	if (test_bit(FR_BACKGROUND, &req->flags)) {
@@ -427,16 +427,16 @@ static void request_end(struct fuse_conn *fc, struct fuse_req *req)
 
 static void queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	if (test_bit(FR_FINISHED, &req->flags)) {
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 		return;
 	}
 	if (list_empty(&req->intr_entry)) {
 		list_add_tail(&req->intr_entry, &fiq->interrupts);
 		wake_up_locked(&fiq->waitq);
 	}
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 }
 
@@ -466,16 +466,16 @@ static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
 		if (!err)
 			return;
 
-		spin_lock(&fiq->waitq.lock);
+		spin_lock(&fiq->lock);
 		/* Request is not yet in userspace, bail out */
 		if (test_bit(FR_PENDING, &req->flags)) {
 			list_del(&req->list);
-			spin_unlock(&fiq->waitq.lock);
+			spin_unlock(&fiq->lock);
 			__fuse_put_request(req);
 			req->out.h.error = -EINTR;
 			return;
 		}
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 	}
 
 	/*
@@ -490,9 +490,9 @@ static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 	struct fuse_iqueue *fiq = &fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	if (!fiq->connected) {
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 		req->out.h.error = -ENOTCONN;
 	} else {
 		req->in.h.unique = fuse_get_unique(fiq);
@@ -500,7 +500,7 @@ static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 		/* acquire extra reference, since request is still needed
 		   after request_end() */
 		__fuse_get_request(req);
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 
 		request_wait_answer(fc, req);
 		/* Pairs with smp_wmb() in request_end() */
@@ -633,12 +633,12 @@ static int fuse_request_send_notify_reply(struct fuse_conn *fc,
 
 	__clear_bit(FR_ISREPLY, &req->flags);
 	req->in.h.unique = unique;
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	if (fiq->connected) {
 		queue_request(fiq, req);
 		err = 0;
 	}
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 
 	return err;
 }
@@ -1082,12 +1082,12 @@ static int request_pending(struct fuse_iqueue *fiq)
  * Unlike other requests this is assembled on demand, without a need
  * to allocate a separate fuse_req structure.
  *
- * Called with fiq->waitq.lock held, releases it
+ * Called with fiq->lock held, releases it
  */
 static int fuse_read_interrupt(struct fuse_iqueue *fiq,
 			       struct fuse_copy_state *cs,
 			       size_t nbytes, struct fuse_req *req)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	struct fuse_in_header ih;
 	struct fuse_interrupt_in arg;
@@ -1103,7 +1103,7 @@ __releases(fiq->waitq.lock)
 	ih.unique = req->intr_unique;
 	arg.unique = req->in.h.unique;
 
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	if (nbytes < reqsize)
 		return -EINVAL;
 
@@ -1140,7 +1140,7 @@ static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
 static int fuse_read_single_forget(struct fuse_iqueue *fiq,
 				   struct fuse_copy_state *cs,
 				   size_t nbytes)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	int err;
 	struct fuse_forget_link *forget = dequeue_forget(fiq, 1, NULL);
@@ -1154,7 +1154,7 @@ __releases(fiq->waitq.lock)
 		.len = sizeof(ih) + sizeof(arg),
 	};
 
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	kfree(forget);
 	if (nbytes < ih.len)
 		return -EINVAL;
@@ -1172,7 +1172,7 @@ __releases(fiq->waitq.lock)
 
 static int fuse_read_batch_forget(struct fuse_iqueue *fiq,
 				   struct fuse_copy_state *cs, size_t nbytes)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	int err;
 	unsigned max_forgets;
@@ -1186,13 +1186,13 @@ __releases(fiq->waitq.lock)
 	};
 
 	if (nbytes < ih.len) {
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 		return -EINVAL;
 	}
 
 	max_forgets = (nbytes - ih.len) / sizeof(struct fuse_forget_one);
 	head = dequeue_forget(fiq, max_forgets, &count);
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 
 	arg.count = count;
 	ih.len += count * sizeof(struct fuse_forget_one);
@@ -1222,7 +1222,7 @@ __releases(fiq->waitq.lock)
 static int fuse_read_forget(struct fuse_conn *fc, struct fuse_iqueue *fiq,
 			    struct fuse_copy_state *cs,
 			    size_t nbytes)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	if (fc->minor < 16 || fiq->forget_list_head.next->next == NULL)
 		return fuse_read_single_forget(fiq, cs, nbytes);
@@ -1251,16 +1251,19 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	unsigned reqsize;
 
  restart:
-	spin_lock(&fiq->waitq.lock);
-	err = -EAGAIN;
-	if ((file->f_flags & O_NONBLOCK) && fiq->connected &&
-	    !request_pending(fiq))
-		goto err_unlock;
+	for (;;) {
+		spin_lock(&fiq->lock);
+		if (!fiq->connected || request_pending(fiq))
+			break;
+		spin_unlock(&fiq->lock);
 
-	err = wait_event_interruptible_exclusive_locked(fiq->waitq,
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+		err = wait_event_interruptible_exclusive(fiq->waitq,
 				!fiq->connected || request_pending(fiq));
-	if (err)
-		goto err_unlock;
+		if (err)
+			return err;
+	}
 
 	if (!fiq->connected) {
 		err = (fc->aborted && fc->abort_err) ? -ECONNABORTED : -ENODEV;
@@ -1284,7 +1287,7 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	req = list_entry(fiq->pending.next, struct fuse_req, list);
 	clear_bit(FR_PENDING, &req->flags);
 	list_del_init(&req->list);
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 
 	in = &req->in;
 	reqsize = in->h.len;
@@ -1341,7 +1344,7 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	return err;
 
  err_unlock:
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	return err;
 }
 
@@ -2054,12 +2057,12 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
 	fiq = &fud->fc->iq;
 	poll_wait(file, &fiq->waitq, wait);
 
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	if (!fiq->connected)
 		mask = EPOLLERR;
 	else if (request_pending(fiq))
 		mask |= EPOLLIN | EPOLLRDNORM;
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 
 	return mask;
 }
@@ -2150,15 +2153,15 @@ void fuse_abort_conn(struct fuse_conn *fc, bool is_abort)
 		fc->max_background = UINT_MAX;
 		flush_bg_queue(fc);
 
-		spin_lock(&fiq->waitq.lock);
+		spin_lock(&fiq->lock);
 		fiq->connected = 0;
 		list_for_each_entry(req, &fiq->pending, list)
 			clear_bit(FR_PENDING, &req->flags);
 		list_splice_tail_init(&fiq->pending, &to_end);
 		while (forget_pending(fiq))
 			kfree(dequeue_forget(fiq, 1, NULL));
-		wake_up_all_locked(&fiq->waitq);
-		spin_unlock(&fiq->waitq.lock);
+		wake_up_all(&fiq->waitq);
+		spin_unlock(&fiq->lock);
 		kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 		end_polls(fc);
 		wake_up_all(&fc->blocked_waitq);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index cec8b8e749695..900bdcf79bfc0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -388,6 +388,9 @@ struct fuse_iqueue {
 	/** Connection established */
 	unsigned connected;
 
+	/** Lock protecting accesses to members of this structure */
+	spinlock_t lock;
+
 	/** Readers of the connection are waiting on this */
 	wait_queue_head_t waitq;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index db9e60b7eb691..cb018315ecaf5 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -585,6 +585,7 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 static void fuse_iqueue_init(struct fuse_iqueue *fiq)
 {
 	memset(fiq, 0, sizeof(struct fuse_iqueue));
+	spin_lock_init(&fiq->lock);
 	init_waitqueue_head(&fiq->waitq);
 	INIT_LIST_HEAD(&fiq->pending);
 	INIT_LIST_HEAD(&fiq->interrupts);
-- 
2.20.1




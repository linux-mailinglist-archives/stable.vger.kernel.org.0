Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D914CA708
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405129AbfJCQtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405840AbfJCQtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E632A2086A;
        Thu,  3 Oct 2019 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121383;
        bh=VS8LeK5tgXZVV+R6iRzbTdYXkZcnNzVvuRInIv8yveM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4fAVwcYDMaUxv5ynJgU0hWiz3Xg3PvfqWf0W4oY/QF6yiVjPRUcBwTWNefI1nr0v
         wenAqYpSKGKqa1/dzBsE2h61JrrnU/0MmFTlc8CyWtoaZUwDtDN/1Vxf0j2GTC/fyY
         ypCly8y0v1UZCanXLDzXTTSiVUHQk8wddsjgiNFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af05535bb79520f95431@syzkaller.appspotmail.com,
        syzbot+d86c4426a01f60feddc7@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Eric Biggers <ebiggers@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.3 257/344] fuse: fix deadlock with aio poll and fuse_iqueue::waitq.lock
Date:   Thu,  3 Oct 2019 17:53:42 +0200
Message-Id: <20191003154605.845369774@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 76e43c8ccaa35c30d5df853013561145a0f750a5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c    |   93 ++++++++++++++++++++++++++++---------------------------
 fs/fuse/fuse_i.h |    3 +
 fs/fuse/inode.c  |    1 
 3 files changed, 52 insertions(+), 45 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -377,7 +377,7 @@ static void queue_request(struct fuse_iq
 	req->in.h.len = sizeof(struct fuse_in_header) +
 		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
 	list_add_tail(&req->list, &fiq->pending);
-	wake_up_locked(&fiq->waitq);
+	wake_up(&fiq->waitq);
 	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 }
 
@@ -389,16 +389,16 @@ void fuse_queue_forget(struct fuse_conn
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
@@ -412,10 +412,10 @@ static void flush_bg_queue(struct fuse_c
 		req = list_first_entry(&fc->bg_queue, struct fuse_req, list);
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
 
@@ -439,9 +439,9 @@ static void request_end(struct fuse_conn
 	 * smp_mb() from queue_interrupt().
 	 */
 	if (!list_empty(&req->intr_entry)) {
-		spin_lock(&fiq->waitq.lock);
+		spin_lock(&fiq->lock);
 		list_del_init(&req->intr_entry);
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 	}
 	WARN_ON(test_bit(FR_PENDING, &req->flags));
 	WARN_ON(test_bit(FR_SENT, &req->flags));
@@ -483,10 +483,10 @@ put_request:
 
 static int queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
 {
-	spin_lock(&fiq->waitq.lock);
+	spin_lock(&fiq->lock);
 	/* Check for we've sent request to interrupt this req */
 	if (unlikely(!test_bit(FR_INTERRUPTED, &req->flags))) {
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 		return -EINVAL;
 	}
 
@@ -499,13 +499,13 @@ static int queue_interrupt(struct fuse_i
 		smp_mb();
 		if (test_bit(FR_FINISHED, &req->flags)) {
 			list_del_init(&req->intr_entry);
-			spin_unlock(&fiq->waitq.lock);
+			spin_unlock(&fiq->lock);
 			return 0;
 		}
-		wake_up_locked(&fiq->waitq);
+		wake_up(&fiq->waitq);
 		kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 	}
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	return 0;
 }
 
@@ -535,16 +535,16 @@ static void request_wait_answer(struct f
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
@@ -559,9 +559,9 @@ static void __fuse_request_send(struct f
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
@@ -569,7 +569,7 @@ static void __fuse_request_send(struct f
 		/* acquire extra reference, since request is still needed
 		   after request_end() */
 		__fuse_get_request(req);
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 
 		request_wait_answer(fc, req);
 		/* Pairs with smp_wmb() in request_end() */
@@ -700,12 +700,12 @@ static int fuse_request_send_notify_repl
 
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
@@ -1149,12 +1149,12 @@ static int request_pending(struct fuse_i
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
@@ -1169,7 +1169,7 @@ __releases(fiq->waitq.lock)
 	ih.unique = (req->in.h.unique | FUSE_INT_REQ_BIT);
 	arg.unique = req->in.h.unique;
 
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	if (nbytes < reqsize)
 		return -EINVAL;
 
@@ -1206,7 +1206,7 @@ static struct fuse_forget_link *dequeue_
 static int fuse_read_single_forget(struct fuse_iqueue *fiq,
 				   struct fuse_copy_state *cs,
 				   size_t nbytes)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	int err;
 	struct fuse_forget_link *forget = dequeue_forget(fiq, 1, NULL);
@@ -1220,7 +1220,7 @@ __releases(fiq->waitq.lock)
 		.len = sizeof(ih) + sizeof(arg),
 	};
 
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	kfree(forget);
 	if (nbytes < ih.len)
 		return -EINVAL;
@@ -1238,7 +1238,7 @@ __releases(fiq->waitq.lock)
 
 static int fuse_read_batch_forget(struct fuse_iqueue *fiq,
 				   struct fuse_copy_state *cs, size_t nbytes)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	int err;
 	unsigned max_forgets;
@@ -1252,13 +1252,13 @@ __releases(fiq->waitq.lock)
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
@@ -1288,7 +1288,7 @@ __releases(fiq->waitq.lock)
 static int fuse_read_forget(struct fuse_conn *fc, struct fuse_iqueue *fiq,
 			    struct fuse_copy_state *cs,
 			    size_t nbytes)
-__releases(fiq->waitq.lock)
+__releases(fiq->lock)
 {
 	if (fc->minor < 16 || fiq->forget_list_head.next->next == NULL)
 		return fuse_read_single_forget(fiq, cs, nbytes);
@@ -1318,16 +1318,19 @@ static ssize_t fuse_dev_do_read(struct f
 	unsigned int hash;
 
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
 		err = fc->aborted ? -ECONNABORTED : -ENODEV;
@@ -1351,7 +1354,7 @@ static ssize_t fuse_dev_do_read(struct f
 	req = list_entry(fiq->pending.next, struct fuse_req, list);
 	clear_bit(FR_PENDING, &req->flags);
 	list_del_init(&req->list);
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 
 	in = &req->in;
 	reqsize = in->h.len;
@@ -1409,7 +1412,7 @@ out_end:
 	return err;
 
  err_unlock:
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	return err;
 }
 
@@ -2121,12 +2124,12 @@ static __poll_t fuse_dev_poll(struct fil
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
@@ -2221,15 +2224,15 @@ void fuse_abort_conn(struct fuse_conn *f
 		flush_bg_queue(fc);
 		spin_unlock(&fc->bg_lock);
 
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
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -450,6 +450,9 @@ struct fuse_iqueue {
 	/** Connection established */
 	unsigned connected;
 
+	/** Lock protecting accesses to members of this structure */
+	spinlock_t lock;
+
 	/** Readers of the connection are waiting on this */
 	wait_queue_head_t waitq;
 
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -582,6 +582,7 @@ static int fuse_show_options(struct seq_
 static void fuse_iqueue_init(struct fuse_iqueue *fiq)
 {
 	memset(fiq, 0, sizeof(struct fuse_iqueue));
+	spin_lock_init(&fiq->lock);
 	init_waitqueue_head(&fiq->waitq);
 	INIT_LIST_HEAD(&fiq->pending);
 	INIT_LIST_HEAD(&fiq->interrupts);



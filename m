Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19422F775
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfD3L7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbfD3Lqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549552182B;
        Tue, 30 Apr 2019 11:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624792;
        bh=JSJpkAVkNv/JX/+V1ccBGPwdbmTUhawtKjf0TRPSt0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxFYFupFUYiJAXcUkLZ6Ub1ypjfpN8Ouo9MLMAHmAOWwvkV2lpfK3O391N5AxhbFU
         75TNcmM2zKtbHeK47L8hQOajBnz4DNY8h36LC+08hSCQg/p5CGZit23HmP5iJlm5P8
         O8xTWaTJVNKzlKgseduzvQqJ+/9RGsIQhAI8uu18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        syzbot+503d4cc169fcec1cb18c@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 074/100] aio: simplify - and fix - fget/fput for io_submit()
Date:   Tue, 30 Apr 2019 13:38:43 +0200
Message-Id: <20190430113612.228279107@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 84c4e1f89fefe70554da0ab33be72c9be7994379 upstream.

Al Viro root-caused a race where the IOCB_CMD_POLL handling of
fget/fput() could cause us to access the file pointer after it had
already been freed:

 "In more details - normally IOCB_CMD_POLL handling looks so:

   1) io_submit(2) allocates aio_kiocb instance and passes it to
      aio_poll()

   2) aio_poll() resolves the descriptor to struct file by req->file =
      fget(iocb->aio_fildes)

   3) aio_poll() sets ->woken to false and raises ->ki_refcnt of that
      aio_kiocb to 2 (bumps by 1, that is).

   4) aio_poll() calls vfs_poll(). After sanity checks (basically,
      "poll_wait() had been called and only once") it locks the queue.
      That's what the extra reference to iocb had been for - we know we
      can safely access it.

   5) With queue locked, we check if ->woken has already been set to
      true (by aio_poll_wake()) and, if it had been, we unlock the
      queue, drop a reference to aio_kiocb and bugger off - at that
      point it's a responsibility to aio_poll_wake() and the stuff
      called/scheduled by it. That code will drop the reference to file
      in req->file, along with the other reference to our aio_kiocb.

   6) otherwise, we see whether we need to wait. If we do, we unlock the
      queue, drop one reference to aio_kiocb and go away - eventual
      wakeup (or cancel) will deal with the reference to file and with
      the other reference to aio_kiocb

   7) otherwise we remove ourselves from waitqueue (still under the
      queue lock), so that wakeup won't get us. No async activity will
      be happening, so we can safely drop req->file and iocb ourselves.

  If wakeup happens while we are in vfs_poll(), we are fine - aio_kiocb
  won't get freed under us, so we can do all the checks and locking
  safely. And we don't touch ->file if we detect that case.

  However, vfs_poll() most certainly *does* touch the file it had been
  given. So wakeup coming while we are still in ->poll() might end up
  doing fput() on that file. That case is not too rare, and usually we
  are saved by the still present reference from descriptor table - that
  fput() is not the final one.

  But if another thread closes that descriptor right after our fget()
  and wakeup does happen before ->poll() returns, we are in trouble -
  final fput() done while we are in the middle of a method:

Al also wrote a patch to take an extra reference to the file descriptor
to fix this, but I instead suggested we just streamline the whole file
pointer handling by submit_io() so that the generic aio submission code
simply keeps the file pointer around until the aio has completed.

Fixes: bfe4037e722e ("aio: implement IOCB_CMD_POLL")
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: syzbot+503d4cc169fcec1cb18c@syzkaller.appspotmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c           |   72 +++++++++++++++++++++--------------------------------
 include/linux/fs.h |    8 +++++
 2 files changed, 36 insertions(+), 44 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -161,9 +161,13 @@ struct kioctx {
 	unsigned		id;
 };
 
+/*
+ * First field must be the file pointer in all the
+ * iocb unions! See also 'struct kiocb' in <linux/fs.h>
+ */
 struct fsync_iocb {
-	struct work_struct	work;
 	struct file		*file;
+	struct work_struct	work;
 	bool			datasync;
 };
 
@@ -177,8 +181,15 @@ struct poll_iocb {
 	struct work_struct	work;
 };
 
+/*
+ * NOTE! Each of the iocb union members has the file pointer
+ * as the first entry in their struct definition. So you can
+ * access the file pointer through any of the sub-structs,
+ * or directly as just 'ki_filp' in this struct.
+ */
 struct aio_kiocb {
 	union {
+		struct file		*ki_filp;
 		struct kiocb		rw;
 		struct fsync_iocb	fsync;
 		struct poll_iocb	poll;
@@ -1054,6 +1065,8 @@ static inline void iocb_put(struct aio_k
 {
 	if (refcount_read(&iocb->ki_refcnt) == 0 ||
 	    refcount_dec_and_test(&iocb->ki_refcnt)) {
+		if (iocb->ki_filp)
+			fput(iocb->ki_filp);
 		percpu_ref_put(&iocb->ki_ctx->reqs);
 		kmem_cache_free(kiocb_cachep, iocb);
 	}
@@ -1418,7 +1431,6 @@ static void aio_complete_rw(struct kiocb
 		file_end_write(kiocb->ki_filp);
 	}
 
-	fput(kiocb->ki_filp);
 	aio_complete(iocb, res, res2);
 }
 
@@ -1426,9 +1438,6 @@ static int aio_prep_rw(struct kiocb *req
 {
 	int ret;
 
-	req->ki_filp = fget(iocb->aio_fildes);
-	if (unlikely(!req->ki_filp))
-		return -EBADF;
 	req->ki_complete = aio_complete_rw;
 	req->private = NULL;
 	req->ki_pos = iocb->aio_offset;
@@ -1445,7 +1454,7 @@ static int aio_prep_rw(struct kiocb *req
 		ret = ioprio_check_cap(iocb->aio_reqprio);
 		if (ret) {
 			pr_debug("aio ioprio check cap error: %d\n", ret);
-			goto out_fput;
+			return ret;
 		}
 
 		req->ki_ioprio = iocb->aio_reqprio;
@@ -1454,14 +1463,10 @@ static int aio_prep_rw(struct kiocb *req
 
 	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
 	if (unlikely(ret))
-		goto out_fput;
+		return ret;
 
 	req->ki_flags &= ~IOCB_HIPRI; /* no one is going to poll for this I/O */
 	return 0;
-
-out_fput:
-	fput(req->ki_filp);
-	return ret;
 }
 
 static int aio_setup_rw(int rw, const struct iocb *iocb, struct iovec **iovec,
@@ -1515,24 +1520,19 @@ static ssize_t aio_read(struct kiocb *re
 	if (ret)
 		return ret;
 	file = req->ki_filp;
-
-	ret = -EBADF;
 	if (unlikely(!(file->f_mode & FMODE_READ)))
-		goto out_fput;
+		return -EBADF;
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter))
-		goto out_fput;
+		return -EINVAL;
 
 	ret = aio_setup_rw(READ, iocb, &iovec, vectored, compat, &iter);
 	if (ret)
-		goto out_fput;
+		return ret;
 	ret = rw_verify_area(READ, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret)
 		aio_rw_done(req, call_read_iter(file, req, &iter));
 	kfree(iovec);
-out_fput:
-	if (unlikely(ret))
-		fput(file);
 	return ret;
 }
 
@@ -1549,16 +1549,14 @@ static ssize_t aio_write(struct kiocb *r
 		return ret;
 	file = req->ki_filp;
 
-	ret = -EBADF;
 	if (unlikely(!(file->f_mode & FMODE_WRITE)))
-		goto out_fput;
-	ret = -EINVAL;
+		return -EBADF;
 	if (unlikely(!file->f_op->write_iter))
-		goto out_fput;
+		return -EINVAL;
 
 	ret = aio_setup_rw(WRITE, iocb, &iovec, vectored, compat, &iter);
 	if (ret)
-		goto out_fput;
+		return ret;
 	ret = rw_verify_area(WRITE, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret) {
 		/*
@@ -1576,9 +1574,6 @@ static ssize_t aio_write(struct kiocb *r
 		aio_rw_done(req, call_write_iter(file, req, &iter));
 	}
 	kfree(iovec);
-out_fput:
-	if (unlikely(ret))
-		fput(file);
 	return ret;
 }
 
@@ -1588,7 +1583,6 @@ static void aio_fsync_work(struct work_s
 	int ret;
 
 	ret = vfs_fsync(req->file, req->datasync);
-	fput(req->file);
 	aio_complete(container_of(req, struct aio_kiocb, fsync), ret, 0);
 }
 
@@ -1599,13 +1593,8 @@ static int aio_fsync(struct fsync_iocb *
 			iocb->aio_rw_flags))
 		return -EINVAL;
 
-	req->file = fget(iocb->aio_fildes);
-	if (unlikely(!req->file))
-		return -EBADF;
-	if (unlikely(!req->file->f_op->fsync)) {
-		fput(req->file);
+	if (unlikely(!req->file->f_op->fsync))
 		return -EINVAL;
-	}
 
 	req->datasync = datasync;
 	INIT_WORK(&req->work, aio_fsync_work);
@@ -1615,10 +1604,7 @@ static int aio_fsync(struct fsync_iocb *
 
 static inline void aio_poll_complete(struct aio_kiocb *iocb, __poll_t mask)
 {
-	struct file *file = iocb->poll.file;
-
 	aio_complete(iocb, mangle_poll(mask), 0);
-	fput(file);
 }
 
 static void aio_poll_complete_work(struct work_struct *work)
@@ -1743,9 +1729,6 @@ static ssize_t aio_poll(struct aio_kiocb
 
 	INIT_WORK(&req->work, aio_poll_complete_work);
 	req->events = demangle_poll(iocb->aio_buf) | EPOLLERR | EPOLLHUP;
-	req->file = fget(iocb->aio_fildes);
-	if (unlikely(!req->file))
-		return -EBADF;
 
 	req->head = NULL;
 	req->woken = false;
@@ -1788,10 +1771,8 @@ static ssize_t aio_poll(struct aio_kiocb
 	spin_unlock_irq(&ctx->ctx_lock);
 
 out:
-	if (unlikely(apt.error)) {
-		fput(req->file);
+	if (unlikely(apt.error))
 		return apt.error;
-	}
 
 	if (mask)
 		aio_poll_complete(aiocb, mask);
@@ -1829,6 +1810,11 @@ static int __io_submit_one(struct kioctx
 	if (unlikely(!req))
 		goto out_put_reqs_available;
 
+	req->ki_filp = fget(iocb->aio_fildes);
+	ret = -EBADF;
+	if (unlikely(!req->ki_filp))
+		goto out_put_req;
+
 	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
 		/*
 		 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -304,13 +304,19 @@ enum rw_hint {
 
 struct kiocb {
 	struct file		*ki_filp;
+
+	/* The 'ki_filp' pointer is shared in a union for aio */
+	randomized_struct_fields_start
+
 	loff_t			ki_pos;
 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
 	int			ki_flags;
 	u16			ki_hint;
 	u16			ki_ioprio; /* See linux/ioprio.h */
-} __randomize_layout;
+
+	randomized_struct_fields_end
+};
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {



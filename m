Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2EE0AB1C1
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 06:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbfIFEn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 00:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbfIFEn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 00:43:28 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FA832075C;
        Fri,  6 Sep 2019 04:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567745006;
        bh=wn4U8Q/qQxRtfOtocVcHPESyjSxHnOU4LtCC4mvET5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xzxEOBccCCHGRhcuK5V4D9Up8fcf0jVNSDjvIEyHsc5c9BWUcsJqlUPz91ZOwffnm
         QH0nFPkOuGyFssNDeu06cqSemrsyPhakM5PI35h40eCnf5Hr2pOT0JOP0WkOzGnRnT
         +4HNm3XCtTB2a5nDQrTRttt1QwUqP8s9hpn5np3c=
Date:   Thu, 5 Sep 2019 21:43:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fuse: disable irqs for fuse_iqueue::waitq.lock
Message-ID: <20190906044324.GE803@sol.localdomain>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
References: <0000000000008d8eac05906691ac@google.com>
 <20190822233529.4176-1-ebiggers@kernel.org>
 <CAJfpegvHgcZGFi-Ydyo2j89zQxqAtZ1Lh0+vC6vWeU-aEFZkYQ@mail.gmail.com>
 <20190903133910.GA5144@zzz.localdomain>
 <CAJfpegtrkxAYq4_rXVNEhe=6SFCfXGgpNVtaiuyfSdh+kthazA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtrkxAYq4_rXVNEhe=6SFCfXGgpNVtaiuyfSdh+kthazA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 04:29:03PM +0200, Miklos Szeredi wrote:
> On Tue, Sep 3, 2019 at 3:39 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Sep 03, 2019 at 09:31:29AM +0200, Miklos Szeredi wrote:
> > > On Fri, Aug 23, 2019 at 1:35 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > From: Eric Biggers <ebiggers@google.com>
> > > >
> > > > When IOCB_CMD_POLL is used on the FUSE device, aio_poll() disables IRQs
> > > > and takes kioctx::ctx_lock, then fuse_iqueue::waitq.lock.
> > >
> > > Not in -linus.
> > >
> > > Which tree was this reproduced with?
> > >
> > > Thanks,
> > > Miklos
> >
> > Linus's tree.  Here's the full symbolized output on v5.3-rc7:
> 
> Okay.
> 
> TBH, I find the fix disgusting. It's confusing to sprinke code that
> has absolutely nothing to do with interrupts with spin_lock_irq()
> calls.
> 
> I think the lock/unlock calls should at least be done with a helper
> with a comment explaining why disabling interrupts is needed (though I
> have not managed to understand why aio needs to actually mess with the
> waitq lock...)

The aio code is doing a poll(), so it needs to use the wait queue.

> 
> Probably a better fix would be to just use a separate spinlock to
> avoid the need to disable interrupts in cases where it's not
> necessary.

Well, the below is what a separate lock would look like.  Note that it actually
still disables IRQs in some places; it's just hidden away in the nested
spin_lock_irqsave() in wake_up().  Likewise, adding something to the fuse_iqueue
then requires taking 2 spin locks -- one explicit, and one hidden in wake_up().

Is this the solution you'd prefer?

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ea8237513dfa..1d9d555f2699 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -377,7 +377,7 @@ static void queue_request(struct fuse_iqueue *fiq, struct fuse_req *req)
 	req->in.h.len = sizeof(struct fuse_in_header) +
 		len_args(req->in.numargs, (struct fuse_arg *) req->in.args);
 	list_add_tail(&req->list, &fiq->pending);
-	wake_up_locked(&fiq->waitq);
+	wake_up(&fiq->waitq);
 	kill_fasync(&fiq->fasync, SIGIO, POLL_IN);
 }
 
@@ -389,16 +389,16 @@ void fuse_queue_forget(struct fuse_conn *fc, struct fuse_forget_link *forget,
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
@@ -412,10 +412,10 @@ static void flush_bg_queue(struct fuse_conn *fc)
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
 
@@ -439,9 +439,9 @@ static void request_end(struct fuse_conn *fc, struct fuse_req *req)
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
@@ -483,10 +483,10 @@ static void request_end(struct fuse_conn *fc, struct fuse_req *req)
 
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
 
@@ -499,13 +499,13 @@ static int queue_interrupt(struct fuse_iqueue *fiq, struct fuse_req *req)
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
 
@@ -535,16 +535,16 @@ static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
 		if (!err)
 			return;
 
-		spin_lock(&fiq->waitq.lock);
+		spin_lock(&fiq->lock);
 		/* Request is not yet in userspace, bail out */
 		if (test_bit(FR_PENDING, &req->flags)) {
 			list_del(&req->list);
-			spin_unlock(&fiq->waitq.lock);
+			spin_unlock(&fiq->lock);;
 			__fuse_put_request(req);
 			req->out.h.error = -EINTR;
 			return;
 		}
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 	}
 
 	/*
@@ -559,9 +559,9 @@ static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 	struct fuse_iqueue *fiq = &fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
-	spin_lock(&fiq->waitq.lock);
+	spin_lock_irq(&fiq->lock);
 	if (!fiq->connected) {
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 		req->out.h.error = -ENOTCONN;
 	} else {
 		req->in.h.unique = fuse_get_unique(fiq);
@@ -569,7 +569,7 @@ static void __fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 		/* acquire extra reference, since request is still needed
 		   after request_end() */
 		__fuse_get_request(req);
-		spin_unlock(&fiq->waitq.lock);
+		spin_unlock(&fiq->lock);
 
 		request_wait_answer(fc, req);
 		/* Pairs with smp_wmb() in request_end() */
@@ -700,12 +700,12 @@ static int fuse_request_send_notify_reply(struct fuse_conn *fc,
 
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
@@ -1149,12 +1149,12 @@ static int request_pending(struct fuse_iqueue *fiq)
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
 
@@ -1206,7 +1206,7 @@ static struct fuse_forget_link *dequeue_forget(struct fuse_iqueue *fiq,
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
@@ -1318,16 +1318,19 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
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
@@ -1351,7 +1354,7 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	req = list_entry(fiq->pending.next, struct fuse_req, list);
 	clear_bit(FR_PENDING, &req->flags);
 	list_del_init(&req->list);
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 
 	in = &req->in;
 	reqsize = in->h.len;
@@ -1409,7 +1412,7 @@ static ssize_t fuse_dev_do_read(struct fuse_dev *fud, struct file *file,
 	return err;
 
  err_unlock:
-	spin_unlock(&fiq->waitq.lock);
+	spin_unlock(&fiq->lock);
 	return err;
 }
 
@@ -2121,12 +2124,12 @@ static __poll_t fuse_dev_poll(struct file *file, poll_table *wait)
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
@@ -2221,15 +2224,15 @@ void fuse_abort_conn(struct fuse_conn *fc)
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
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 24dbca777775..5de7fd0fd6ef 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -450,6 +450,9 @@ struct fuse_iqueue {
 	/** Connection established */
 	unsigned connected;
 
+	/** Lock protecting accessess to members of this structure */
+	spinlock_t lock;
+
 	/** Readers of the connection are waiting on this */
 	wait_queue_head_t waitq;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4bb885b0f032..987877860c01 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -582,6 +582,7 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 static void fuse_iqueue_init(struct fuse_iqueue *fiq)
 {
 	memset(fiq, 0, sizeof(struct fuse_iqueue));
+	spin_lock_init(&fiq->lock);
 	init_waitqueue_head(&fiq->waitq);
 	INIT_LIST_HEAD(&fiq->pending);
 	INIT_LIST_HEAD(&fiq->interrupts);
-- 
2.23.0


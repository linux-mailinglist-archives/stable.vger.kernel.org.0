Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0821A409332
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343497AbhIMOTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245433AbhIMORF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:17:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60A1061425;
        Mon, 13 Sep 2021 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540688;
        bh=V8czTzhLblTRyg1mOKwxh7utR6ydZ/5Q9sg8OGprbAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qs+w9TT/nTzn+Zpp+AWzeYreStcgOws39zpMljIbF6YLwemj/7xNC48+GcqdDMiQ+
         7F/lKHwoJ9IEA+r4mu5zjsGYq3H7cYQ47yT4XIDxp6ogdivsIgb3ph8qeTuBTZvj/q
         3xT8Efqtk5oKYB2jfG1GQ1KVjlo1QsB+JSMj1QlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.13 294/300] fuse: wait for writepages in syncfs
Date:   Mon, 13 Sep 2021 15:15:55 +0200
Message-Id: <20210913131119.281956313@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 660585b56e63ca034ad506ea53c807c5cdca3196 upstream.

In case of fuse the MM subsystem doesn't guarantee that page writeback
completes by the time ->sync_fs() is called.  This is because fuse
completes page writeback immediately to prevent DoS of memory reclaim by
the userspace file server.

This means that fuse itself must ensure that writes are synced before
sending the SYNCFS request to the server.

Introduce sync buckets, that hold a counter for the number of outstanding
write requests.  On syncfs replace the current bucket with a new one and
wait until the old bucket's counter goes down to zero.

It is possible to have multiple syncfs calls in parallel, in which case
there could be more than one waited-on buckets.  Descendant buckets must
not complete until the parent completes.  Add a count to the child (new)
bucket until the (parent) old bucket completes.

Use RCU protection to dereference the current bucket and to wake up an
emptied bucket.  Use fc->lock to protect against parallel assignments to
the current bucket.

This leaves just the counter to be a possible scalability issue.  The
fc->num_waiting counter has a similar issue, so both should be addressed at
the same time.

Reported-by: Amir Goldstein <amir73il@gmail.com>
Fixes: 2d82ab251ef0 ("virtiofs: propagate sync() to file server")
Cc: <stable@vger.kernel.org> # v5.14
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c   |   21 +++++++++++++++++++
 fs/fuse/fuse_i.h |   19 +++++++++++++++++
 fs/fuse/inode.c  |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 100 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -392,6 +392,7 @@ struct fuse_writepage_args {
 	struct list_head queue_entry;
 	struct fuse_writepage_args *next;
 	struct inode *inode;
+	struct fuse_sync_bucket *bucket;
 };
 
 static struct fuse_writepage_args *fuse_find_writeback(struct fuse_inode *fi,
@@ -1613,6 +1614,9 @@ static void fuse_writepage_free(struct f
 	struct fuse_args_pages *ap = &wpa->ia.ap;
 	int i;
 
+	if (wpa->bucket)
+		fuse_sync_bucket_dec(wpa->bucket);
+
 	for (i = 0; i < ap->num_pages; i++)
 		__free_page(ap->pages[i]);
 
@@ -1876,6 +1880,20 @@ static struct fuse_writepage_args *fuse_
 
 }
 
+static void fuse_writepage_add_to_bucket(struct fuse_conn *fc,
+					 struct fuse_writepage_args *wpa)
+{
+	if (!fc->sync_fs)
+		return;
+
+	rcu_read_lock();
+	/* Prevent resurrection of dead bucket in unlikely race with syncfs */
+	do {
+		wpa->bucket = rcu_dereference(fc->curr_bucket);
+	} while (unlikely(!atomic_inc_not_zero(&wpa->bucket->count)));
+	rcu_read_unlock();
+}
+
 static int fuse_writepage_locked(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
@@ -1903,6 +1921,7 @@ static int fuse_writepage_locked(struct
 	if (!wpa->ia.ff)
 		goto err_nofile;
 
+	fuse_writepage_add_to_bucket(fc, wpa);
 	fuse_write_args_fill(&wpa->ia, wpa->ia.ff, page_offset(page), 0);
 
 	copy_highpage(tmp_page, page);
@@ -2153,6 +2172,8 @@ static int fuse_writepages_fill(struct p
 			__free_page(tmp_page);
 			goto out_unlock;
 		}
+		fuse_writepage_add_to_bucket(fc, wpa);
+
 		data->max_pages = 1;
 
 		ap = &wpa->ia.ap;
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -515,6 +515,13 @@ struct fuse_fs_context {
 	void **fudptr;
 };
 
+struct fuse_sync_bucket {
+	/* count is a possible scalability bottleneck */
+	atomic_t count;
+	wait_queue_head_t waitq;
+	struct rcu_head rcu;
+};
+
 /**
  * A Fuse connection.
  *
@@ -807,6 +814,9 @@ struct fuse_conn {
 
 	/** List of filesystems using this connection */
 	struct list_head mounts;
+
+	/* New writepages go into this bucket */
+	struct fuse_sync_bucket __rcu *curr_bucket;
 };
 
 /*
@@ -910,6 +920,15 @@ static inline void fuse_page_descs_lengt
 		descs[i].length = PAGE_SIZE - descs[i].offset;
 }
 
+static inline void fuse_sync_bucket_dec(struct fuse_sync_bucket *bucket)
+{
+	/* Need RCU protection to prevent use after free after the decrement */
+	rcu_read_lock();
+	if (atomic_dec_and_test(&bucket->count))
+		wake_up(&bucket->waitq);
+	rcu_read_unlock();
+}
+
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -506,6 +506,57 @@ static int fuse_statfs(struct dentry *de
 	return err;
 }
 
+static struct fuse_sync_bucket *fuse_sync_bucket_alloc(void)
+{
+	struct fuse_sync_bucket *bucket;
+
+	bucket = kzalloc(sizeof(*bucket), GFP_KERNEL | __GFP_NOFAIL);
+	if (bucket) {
+		init_waitqueue_head(&bucket->waitq);
+		/* Initial active count */
+		atomic_set(&bucket->count, 1);
+	}
+	return bucket;
+}
+
+static void fuse_sync_fs_writes(struct fuse_conn *fc)
+{
+	struct fuse_sync_bucket *bucket, *new_bucket;
+	int count;
+
+	new_bucket = fuse_sync_bucket_alloc();
+	spin_lock(&fc->lock);
+	bucket = rcu_dereference_protected(fc->curr_bucket, 1);
+	count = atomic_read(&bucket->count);
+	WARN_ON(count < 1);
+	/* No outstanding writes? */
+	if (count == 1) {
+		spin_unlock(&fc->lock);
+		kfree(new_bucket);
+		return;
+	}
+
+	/*
+	 * Completion of new bucket depends on completion of this bucket, so add
+	 * one more count.
+	 */
+	atomic_inc(&new_bucket->count);
+	rcu_assign_pointer(fc->curr_bucket, new_bucket);
+	spin_unlock(&fc->lock);
+	/*
+	 * Drop initial active count.  At this point if all writes in this and
+	 * ancestor buckets complete, the count will go to zero and this task
+	 * will be woken up.
+	 */
+	atomic_dec(&bucket->count);
+
+	wait_event(bucket->waitq, atomic_read(&bucket->count) == 0);
+
+	/* Drop temp count on descendant bucket */
+	fuse_sync_bucket_dec(new_bucket);
+	kfree_rcu(bucket, rcu);
+}
+
 static int fuse_sync_fs(struct super_block *sb, int wait)
 {
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
@@ -528,6 +579,8 @@ static int fuse_sync_fs(struct super_blo
 	if (!fc->sync_fs)
 		return 0;
 
+	fuse_sync_fs_writes(fc);
+
 	memset(&inarg, 0, sizeof(inarg));
 	args.in_numargs = 1;
 	args.in_args[0].size = sizeof(inarg);
@@ -763,6 +816,7 @@ void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (refcount_dec_and_test(&fc->count)) {
 		struct fuse_iqueue *fiq = &fc->iq;
+		struct fuse_sync_bucket *bucket;
 
 		if (IS_ENABLED(CONFIG_FUSE_DAX))
 			fuse_dax_conn_free(fc);
@@ -770,6 +824,11 @@ void fuse_conn_put(struct fuse_conn *fc)
 			fiq->ops->release(fiq);
 		put_pid_ns(fc->pid_ns);
 		put_user_ns(fc->user_ns);
+		bucket = rcu_dereference_protected(fc->curr_bucket, 1);
+		if (bucket) {
+			WARN_ON(atomic_read(&bucket->count) != 1);
+			kfree(bucket);
+		}
 		fc->release(fc);
 	}
 }
@@ -1366,6 +1425,7 @@ int fuse_fill_super_common(struct super_
 	if (sb->s_flags & SB_MANDLOCK)
 		goto err;
 
+	rcu_assign_pointer(fc->curr_bucket, fuse_sync_bucket_alloc());
 	fuse_sb_defaults(sb);
 
 	if (ctx->is_bdev) {



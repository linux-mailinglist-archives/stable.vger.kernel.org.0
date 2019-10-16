Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAE5D9EE1
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404301AbfJPWDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438519AbfJPV73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:29 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CCBB21928;
        Wed, 16 Oct 2019 21:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263168;
        bh=Zzo8yMFoA1prS3xWp7Xq1gA2nAOj7saQWS884tzy5h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy5AuoxbyU8/g0/KwS4KTrWkBOMY61XTcACtyTwFEIJ6FqH2vfrkUaHk7rwlSLACC
         dFOMjrtShiLBVVTV42dYfbsMrf2yQFHFmvoakwMxz17/jRZYhCux/NywwhFuCRjbZP
         HUmQrFnkRmhdSgbt1K1dmNHoBz+nCfVI6bNr+xKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhengbin (A)" <zhengbin13@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.3 096/112] Fix the locking in dcache_readdir() and friends
Date:   Wed, 16 Oct 2019 14:51:28 -0700
Message-Id: <20191016214905.994291404@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit d4f4de5e5ef8efde85febb6876cd3c8ab1631999 upstream.

There are two problems in dcache_readdir() - one is that lockless traversal
of the list needs non-trivial cooperation of d_alloc() (at least a switch
to list_add_rcu(), and probably more than just that) and another is that
it assumes that no removal will happen without the directory locked exclusive.
Said assumption had always been there, never had been stated explicitly and
is violated by several places in the kernel (devpts and selinuxfs).

        * replacement of next_positive() with different calling conventions:
it returns struct list_head * instead of struct dentry *; the latter is
passed in and out by reference, grabbing the result and dropping the original
value.
        * scan is under ->d_lock.  If we run out of timeslice, cursor is moved
after the last position we'd reached and we reschedule; then the scan continues
from that place.  To avoid livelocks between multiple lseek() (with cursors
getting moved past each other, never reaching the real entries) we always
skip the cursors, need_resched() or not.
        * returned list_head * is either ->d_child of dentry we'd found or
->d_subdirs of parent (if we got to the end of the list).
        * dcache_readdir() and dcache_dir_lseek() switched to new helper.
dcache_readdir() always holds a reference to dentry passed to dir_emit() now.
Cursor is moved to just before the entry where dir_emit() has failed or into
the very end of the list, if we'd run out.
        * move_cursor() eliminated - it had sucky calling conventions and
after fixing that it became simply list_move() (in lseek and scan_positives)
or list_move_tail() (in readdir).

        All operations with the list are under ->d_lock now, and we do not
depend upon having all file removals done with parent locked exclusive
anymore.

Cc: stable@vger.kernel.org
Reported-by: "zhengbin (A)" <zhengbin13@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/libfs.c |  134 +++++++++++++++++++++++++++++++------------------------------
 1 file changed, 69 insertions(+), 65 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -89,58 +89,47 @@ int dcache_dir_close(struct inode *inode
 EXPORT_SYMBOL(dcache_dir_close);
 
 /* parent is locked at least shared */
-static struct dentry *next_positive(struct dentry *parent,
-				    struct list_head *from,
-				    int count)
+/*
+ * Returns an element of siblings' list.
+ * We are looking for <count>th positive after <p>; if
+ * found, dentry is grabbed and passed to caller via *<res>.
+ * If no such element exists, the anchor of list is returned
+ * and *<res> is set to NULL.
+ */
+static struct list_head *scan_positives(struct dentry *cursor,
+					struct list_head *p,
+					loff_t count,
+					struct dentry **res)
 {
-	unsigned *seq = &parent->d_inode->i_dir_seq, n;
-	struct dentry *res;
-	struct list_head *p;
-	bool skipped;
-	int i;
+	struct dentry *dentry = cursor->d_parent, *found = NULL;
 
-retry:
-	i = count;
-	skipped = false;
-	n = smp_load_acquire(seq) & ~1;
-	res = NULL;
-	rcu_read_lock();
-	for (p = from->next; p != &parent->d_subdirs; p = p->next) {
+	spin_lock(&dentry->d_lock);
+	while ((p = p->next) != &dentry->d_subdirs) {
 		struct dentry *d = list_entry(p, struct dentry, d_child);
-		if (!simple_positive(d)) {
-			skipped = true;
-		} else if (!--i) {
-			res = d;
-			break;
+		// we must at least skip cursors, to avoid livelocks
+		if (d->d_flags & DCACHE_DENTRY_CURSOR)
+			continue;
+		if (simple_positive(d) && !--count) {
+			spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
+			if (simple_positive(d))
+				found = dget_dlock(d);
+			spin_unlock(&d->d_lock);
+			if (likely(found))
+				break;
+			count = 1;
+		}
+		if (need_resched()) {
+			list_move(&cursor->d_child, p);
+			p = &cursor->d_child;
+			spin_unlock(&dentry->d_lock);
+			cond_resched();
+			spin_lock(&dentry->d_lock);
 		}
 	}
-	rcu_read_unlock();
-	if (skipped) {
-		smp_rmb();
-		if (unlikely(*seq != n))
-			goto retry;
-	}
-	return res;
-}
-
-static void move_cursor(struct dentry *cursor, struct list_head *after)
-{
-	struct dentry *parent = cursor->d_parent;
-	unsigned n, *seq = &parent->d_inode->i_dir_seq;
-	spin_lock(&parent->d_lock);
-	for (;;) {
-		n = *seq;
-		if (!(n & 1) && cmpxchg(seq, n, n + 1) == n)
-			break;
-		cpu_relax();
-	}
-	__list_del(cursor->d_child.prev, cursor->d_child.next);
-	if (after)
-		list_add(&cursor->d_child, after);
-	else
-		list_add_tail(&cursor->d_child, &parent->d_subdirs);
-	smp_store_release(seq, n + 2);
-	spin_unlock(&parent->d_lock);
+	spin_unlock(&dentry->d_lock);
+	dput(*res);
+	*res = found;
+	return p;
 }
 
 loff_t dcache_dir_lseek(struct file *file, loff_t offset, int whence)
@@ -158,17 +147,28 @@ loff_t dcache_dir_lseek(struct file *fil
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
+		struct dentry *cursor = file->private_data;
+		struct dentry *to = NULL;
+		struct list_head *p;
+
 		file->f_pos = offset;
-		if (file->f_pos >= 2) {
-			struct dentry *cursor = file->private_data;
-			struct dentry *to;
-			loff_t n = file->f_pos - 2;
-
-			inode_lock_shared(dentry->d_inode);
-			to = next_positive(dentry, &dentry->d_subdirs, n);
-			move_cursor(cursor, to ? &to->d_child : NULL);
-			inode_unlock_shared(dentry->d_inode);
+		inode_lock_shared(dentry->d_inode);
+
+		if (file->f_pos > 2) {
+			p = scan_positives(cursor, &dentry->d_subdirs,
+					   file->f_pos - 2, &to);
+			spin_lock(&dentry->d_lock);
+			list_move(&cursor->d_child, p);
+			spin_unlock(&dentry->d_lock);
+		} else {
+			spin_lock(&dentry->d_lock);
+			list_del_init(&cursor->d_child);
+			spin_unlock(&dentry->d_lock);
 		}
+
+		dput(to);
+
+		inode_unlock_shared(dentry->d_inode);
 	}
 	return offset;
 }
@@ -190,25 +190,29 @@ int dcache_readdir(struct file *file, st
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct dentry *cursor = file->private_data;
-	struct list_head *p = &cursor->d_child;
-	struct dentry *next;
-	bool moved = false;
+	struct list_head *anchor = &dentry->d_subdirs;
+	struct dentry *next = NULL;
+	struct list_head *p;
 
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
 	if (ctx->pos == 2)
-		p = &dentry->d_subdirs;
-	while ((next = next_positive(dentry, p, 1)) != NULL) {
+		p = anchor;
+	else
+		p = &cursor->d_child;
+
+	while ((p = scan_positives(cursor, p, 1, &next)) != anchor) {
 		if (!dir_emit(ctx, next->d_name.name, next->d_name.len,
 			      d_inode(next)->i_ino, dt_type(d_inode(next))))
 			break;
-		moved = true;
-		p = &next->d_child;
 		ctx->pos++;
 	}
-	if (moved)
-		move_cursor(cursor, p);
+	spin_lock(&dentry->d_lock);
+	list_move_tail(&cursor->d_child, p);
+	spin_unlock(&dentry->d_lock);
+	dput(next);
+
 	return 0;
 }
 EXPORT_SYMBOL(dcache_readdir);



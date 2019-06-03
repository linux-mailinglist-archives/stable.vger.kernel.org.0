Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0626330EE
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 15:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFCNWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 09:22:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:40920 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727707AbfFCNWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 09:22:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 325BCADC4;
        Mon,  3 Jun 2019 13:22:03 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 4E8AB1E0DBA; Mon,  3 Jun 2019 15:22:00 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] mm: Add readahead file operation
Date:   Mon,  3 Jun 2019 15:21:54 +0200
Message-Id: <20190603132155.20600-2-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190603132155.20600-1-jack@suse.cz>
References: <20190603132155.20600-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some filesystems need to acquire locks before pages are read into page
cache to protect from races with hole punching. The lock generally
cannot be acquired within readpage as it ranks above page lock so we are
left with acquiring the lock within filesystem's ->read_iter
implementation for normal reads and ->fault implementation during page
faults. That however does not cover all paths how pages can be
instantiated within page cache - namely explicitely requested readahead.
Add new ->readahead file operation which filesystem can use for this.

CC: stable@vger.kernel.org # Needed by following ext4 fix
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |  5 +++++
 include/linux/mm.h |  3 ---
 mm/fadvise.c       | 12 +-----------
 mm/madvise.c       |  3 ++-
 mm/readahead.c     | 26 ++++++++++++++++++++++++--
 5 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index f7fdfe93e25d..9968abcd06ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1828,6 +1828,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
+	int (*readahead)(struct file *, loff_t, loff_t);
 } __randomize_layout;
 
 struct inode_operations {
@@ -3537,6 +3538,10 @@ extern void inode_nohighmem(struct inode *inode);
 extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 		       int advice);
 
+/* mm/readahead.c */
+extern int generic_readahead(struct file *filp, loff_t start, loff_t end);
+extern int vfs_readahead(struct file *filp, loff_t start, loff_t end);
+
 #if defined(CONFIG_IO_URING)
 extern struct sock *io_uring_get_socket(struct file *file);
 #else
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e8834ac32b7..8f6597295920 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2461,9 +2461,6 @@ void task_dirty_inc(struct task_struct *tsk);
 /* readahead.c */
 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
 
-int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read);
-
 void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra,
 			       struct file *filp,
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 467bcd032037..e5aab207550e 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -36,7 +36,6 @@ static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 	loff_t endbyte;			/* inclusive */
 	pgoff_t start_index;
 	pgoff_t end_index;
-	unsigned long nrpages;
 
 	inode = file_inode(file);
 	if (S_ISFIFO(inode->i_mode))
@@ -94,20 +93,11 @@ static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
-		/* First and last PARTIAL page! */
-		start_index = offset >> PAGE_SHIFT;
-		end_index = endbyte >> PAGE_SHIFT;
-
-		/* Careful about overflow on the "+1" */
-		nrpages = end_index - start_index + 1;
-		if (!nrpages)
-			nrpages = ~0UL;
-
 		/*
 		 * Ignore return value because fadvise() shall return
 		 * success even if filesystem can't retrieve a hint,
 		 */
-		force_page_cache_readahead(mapping, file, start_index, nrpages);
+		vfs_readahead(file, offset, endbyte);
 		break;
 	case POSIX_FADV_NOREUSE:
 		break;
diff --git a/mm/madvise.c b/mm/madvise.c
index 628022e674a7..9111b75e88cf 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -303,7 +303,8 @@ static long madvise_willneed(struct vm_area_struct *vma,
 		end = vma->vm_end;
 	end = ((end - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-	force_page_cache_readahead(file->f_mapping, file, start, end - start);
+	vfs_readahead(file, (loff_t)start << PAGE_SHIFT,
+		      (loff_t)end << PAGE_SHIFT);
 	return 0;
 }
 
diff --git a/mm/readahead.c b/mm/readahead.c
index 2fe72cd29b47..e66ae8c764ad 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -219,8 +219,9 @@ unsigned int __do_page_cache_readahead(struct address_space *mapping,
  * Chunk the readahead into 2 megabyte units, so that we don't pin too much
  * memory at once.
  */
-int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			       pgoff_t offset, unsigned long nr_to_read)
+static int force_page_cache_readahead(struct address_space *mapping,
+				      struct file *filp, pgoff_t offset,
+				      unsigned long nr_to_read)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	struct file_ra_state *ra = &filp->f_ra;
@@ -248,6 +249,20 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	return 0;
 }
 
+int generic_readahead(struct file *filp, loff_t start, loff_t end)
+{
+	pgoff_t first, last;
+	unsigned long count;
+
+	first = start >> PAGE_SHIFT;
+	last = end >> PAGE_SHIFT;
+	count = last - first + 1;
+	if (!count)
+		count = ~0UL;
+	return force_page_cache_readahead(filp->f_mapping, filp, first, count);
+}
+EXPORT_SYMBOL_GPL(generic_readahead);
+
 /*
  * Set the initial window size, round to next power of 2 and square
  * for small size, x 4 for medium, and x 2 for large
@@ -575,6 +590,13 @@ page_cache_async_readahead(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
+int vfs_readahead(struct file *filp, loff_t start, loff_t end)
+{
+	if (filp->f_op->readahead)
+		return filp->f_op->readahead(filp, start, end);
+	return generic_readahead(filp, start, end);
+}
+
 ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
 {
 	ssize_t ret;
-- 
2.16.4


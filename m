Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17871B69A9
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgDWXZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:25:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48168 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgDWXG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:28 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zc-De; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6fE-Pf; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jan Kara" <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>
Date:   Fri, 24 Apr 2020 00:04:01 +0100
Message-ID: <lsq.1587683028.925591340@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 014/245] ext4: fix races between page faults and hole
 punching
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.com>

commit ea3d7209ca01da209cda6f0dea8be9cc4b7a933b upstream.

Currently, page faults and hole punching are completely unsynchronized.
This can result in page fault faulting in a page into a range that we
are punching after truncate_pagecache_range() has been called and thus
we can end up with a page mapped to disk blocks that will be shortly
freed. Filesystem corruption will shortly follow. Note that the same
race is avoided for truncate by checking page fault offset against
i_size but there isn't similar mechanism available for punching holes.

Fix the problem by creating new rw semaphore i_mmap_sem in inode and
grab it for writing over truncate, hole punching, and other functions
removing blocks from extent tree and for read over page faults. We
cannot easily use i_data_sem for this since that ranks below transaction
start and we need something ranking above it so that it can be held over
the whole truncate / hole punching operation. Also remove various
workarounds we had in the code to reduce race window when page fault
could have created pages with stale mapping information.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16:
 - Drop changes in ext4_insert_range(), ext4_dax_*
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -937,6 +937,15 @@ struct ext4_inode_info {
 	 * by other means, so we have i_data_sem.
 	 */
 	struct rw_semaphore i_data_sem;
+	/*
+	 * i_mmap_sem is for serializing page faults with truncate / punch hole
+	 * operations. We have to make sure that new page cannot be faulted in
+	 * a section of the inode that is being punched. We cannot easily use
+	 * i_data_sem for this since we need protection for the whole punch
+	 * operation and i_data_sem ranks below transaction start so we have
+	 * to occasionally drop it.
+	 */
+	struct rw_semaphore i_mmap_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
 
@@ -2205,6 +2214,7 @@ extern int ext4_chunk_trans_blocks(struc
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
+extern int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4778,7 +4778,6 @@ static long ext4_zero_range(struct file
 	int partial_begin, partial_end;
 	loff_t start, end;
 	ext4_lblk_t lblk;
-	struct address_space *mapping = inode->i_mapping;
 	unsigned int blkbits = inode->i_blkbits;
 
 	trace_ext4_zero_range(inode, offset, len, mode);
@@ -4794,17 +4793,6 @@ static long ext4_zero_range(struct file
 	}
 
 	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret = filemap_write_and_wait_range(mapping, offset,
-						   offset + len - 1);
-		if (ret)
-			return ret;
-	}
-
-	/*
 	 * Round up offset. This is not fallocate, we neet to zero out
 	 * blocks, so convert interior block aligned part of the range to
 	 * unwritten and possibly manually zero out unaligned parts of the
@@ -4865,16 +4853,22 @@ static long ext4_zero_range(struct file
 		flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
 			  EXT4_EX_NOCACHE);
 
-		/* Now release the pages and zero block aligned part of pages*/
-		truncate_pagecache_range(inode, start, end - 1);
-		inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-
 		/* Wait all existing dio workers, newcomers will block on i_mutex */
 		ext4_inode_block_unlocked_dio(inode);
 		inode_dio_wait(inode);
 
+		/*
+		 * Prevent page faults from reinstantiating pages we have
+		 * released from page cache.
+		 */
+		down_write(&EXT4_I(inode)->i_mmap_sem);
+		/* Now release the pages and zero block aligned part of pages */
+		truncate_pagecache_range(inode, start, end - 1);
+		inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+
 		ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size,
 					     flags, mode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
 		if (ret)
 			goto out_dio;
 	}
@@ -5490,17 +5484,22 @@ int ext4_collapse_range(struct inode *in
 		goto out_mutex;
 	}
 
-	truncate_pagecache(inode, ioffset);
-
 	/* Wait for existing dio to complete */
 	ext4_inode_block_unlocked_dio(inode);
 	inode_dio_wait(inode);
 
+	/*
+	 * Prevent page faults from reinstantiating pages we have released from
+	 * page cache.
+	 */
+	down_write(&EXT4_I(inode)->i_mmap_sem);
+	truncate_pagecache(inode, ioffset);
+
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		goto out_dio;
+		goto out_mmap;
 	}
 
 	down_write(&EXT4_I(inode)->i_data_sem);
@@ -5540,7 +5539,8 @@ int ext4_collapse_range(struct inode *in
 
 out_stop:
 	ext4_journal_stop(handle);
-out_dio:
+out_mmap:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -199,7 +199,7 @@ errout:
 }
 
 static const struct vm_operations_struct ext4_file_vm_ops = {
-	.fault		= filemap_fault,
+	.fault		= ext4_filemap_fault,
 	.map_pages	= filemap_map_pages,
 	.page_mkwrite   = ext4_page_mkwrite,
 };
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3716,6 +3716,15 @@ int ext4_punch_hole(struct inode *inode,
 
 	}
 
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
+	/*
+	 * Prevent page faults from reinstantiating pages we have released from
+	 * page cache.
+	 */
+	down_write(&EXT4_I(inode)->i_mmap_sem);
 	first_block_offset = round_up(offset, sb->s_blocksize);
 	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
 
@@ -3724,10 +3733,6 @@ int ext4_punch_hole(struct inode *inode,
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
 
-	/* Wait all existing dio workers, newcomers will block on i_mutex */
-	ext4_inode_block_unlocked_dio(inode);
-	inode_dio_wait(inode);
-
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		credits = ext4_writepage_trans_blocks(inode);
 	else
@@ -3773,11 +3778,6 @@ int ext4_punch_hole(struct inode *inode,
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-	/* Now release the pages again to reduce race window */
-	if (last_block_offset > first_block_offset)
-		truncate_pagecache_range(inode, first_block_offset,
-					 last_block_offset);
-
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	if (ret >= 0)
@@ -3785,6 +3785,7 @@ int ext4_punch_hole(struct inode *inode,
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
 out_mutex:
 	mutex_unlock(&inode->i_mutex);
@@ -4879,6 +4880,7 @@ int ext4_setattr(struct dentry *dentry,
 			} else
 				ext4_wait_for_tail_page_commit(inode);
 		}
+		down_write(&EXT4_I(inode)->i_mmap_sem);
 		/*
 		 * Truncate pagecache after we've waited for commit
 		 * in data=journal mode to make pages freeable.
@@ -4886,6 +4888,7 @@ int ext4_setattr(struct dentry *dentry,
 			truncate_pagecache(inode, inode->i_size);
 		if (shrink)
 			ext4_truncate(inode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
 	}
 
 	if (!rc) {
@@ -5338,6 +5341,8 @@ int ext4_page_mkwrite(struct vm_area_str
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+
 	ret = ext4_convert_inline_data(inode);
 	if (ret)
 		goto out_ret;
@@ -5411,6 +5416,19 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	up_read(&EXT4_I(inode)->i_mmap_sem);
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
+
+int ext4_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	int err;
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	err = filemap_fault(vma, vmf);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+
+	return err;
+}
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -967,6 +967,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&ei->i_orphan);
 	init_rwsem(&ei->xattr_sem);
 	init_rwsem(&ei->i_data_sem);
+	init_rwsem(&ei->i_mmap_sem);
 	inode_init_once(&ei->vfs_inode);
 }
 
--- a/fs/ext4/truncate.h
+++ b/fs/ext4/truncate.h
@@ -10,8 +10,10 @@
  */
 static inline void ext4_truncate_failed_write(struct inode *inode)
 {
+	down_write(&EXT4_I(inode)->i_mmap_sem);
 	truncate_inode_pages(inode->i_mapping, inode->i_size);
 	ext4_truncate(inode);
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 }
 
 /*


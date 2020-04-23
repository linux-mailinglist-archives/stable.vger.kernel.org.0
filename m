Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE631B6986
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgDWXG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48176 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728054AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004Zj-IY; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6fT-UX; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>, "Jan Kara" <jack@suse.com>
Date:   Fri, 24 Apr 2020 00:04:04 +0100
Message-ID: <lsq.1587683028.514455743@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 017/245] ext4: fix races of writeback with punch hole
 and zero range
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

commit 011278485ecc3cd2a3954b5d4c73101d919bf1fa upstream.

When doing delayed allocation, update of on-disk inode size is postponed
until IO submission time. However hole punch or zero range fallocate
calls can end up discarding the tail page cache page and thus on-disk
inode size would never be properly updated.

Make sure the on-disk inode size is updated before truncating page
cache.

Signed-off-by: Jan Kara <jack@suse.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/ext4.h    |  3 +++
 fs/ext4/extents.c |  5 +++++
 fs/ext4/inode.c   | 35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 1 deletion(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2560,6 +2560,9 @@ static inline int ext4_update_inode_size
 	return changed;
 }
 
+int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
+				      loff_t len);
+
 struct ext4_group_info {
 	unsigned long   bb_state;
 	struct rb_root  bb_free_root;
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4856,6 +4856,11 @@ static long ext4_zero_range(struct file
 		 * released from page cache.
 		 */
 		down_write(&EXT4_I(inode)->i_mmap_sem);
+		ret = ext4_update_disksize_before_punch(inode, offset, len);
+		if (ret) {
+			up_write(&EXT4_I(inode)->i_mmap_sem);
+			goto out_dio;
+		}
 		/* Now release the pages and zero block aligned part of pages */
 		truncate_pagecache_range(inode, start, end - 1);
 		inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3652,6 +3652,35 @@ int ext4_can_truncate(struct inode *inod
 }
 
 /*
+ * We have to make sure i_disksize gets properly updated before we truncate
+ * page cache due to hole punching or zero range. Otherwise i_disksize update
+ * can get lost as it may have been postponed to submission of writeback but
+ * that will never happen after we truncate page cache.
+ */
+int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
+				      loff_t len)
+{
+	handle_t *handle;
+	loff_t size = i_size_read(inode);
+
+	WARN_ON(!mutex_is_locked(&inode->i_mutex));
+	if (offset > size || offset + len < size)
+		return 0;
+
+	if (EXT4_I(inode)->i_disksize >= size)
+		return 0;
+
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+	ext4_update_i_disksize(inode, size);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+
+	return 0;
+}
+
+/*
  * ext4_punch_hole: punches a hole in a file by releaseing the blocks
  * associated with the given offset and length
  *
@@ -3729,9 +3758,13 @@ int ext4_punch_hole(struct inode *inode,
 	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
 
 	/* Now release the pages and zero block aligned part of pages*/
-	if (last_block_offset > first_block_offset)
+	if (last_block_offset > first_block_offset) {
+		ret = ext4_update_disksize_before_punch(inode, offset, length);
+		if (ret)
+			goto out_dio;
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
+	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		credits = ext4_writepage_trans_blocks(inode);


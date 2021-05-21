Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48C38C11C
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 09:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhEUH5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 03:57:13 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:20199 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231301AbhEUH5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 03:57:13 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 21 May 2021 00:55:46 -0700
Received: from localhost.localdomain (unknown [10.118.101.147])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id E58882042B;
        Fri, 21 May 2021 00:55:49 -0700 (PDT)
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>
CC:     <linux-ext4@vger.kernel.org>, <stable@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Alexey Makhalov <amakhalov@vmware.com>
Subject: [PATCH v2] ext4: fix memory leak in ext4_fill_super
Date:   Fri, 21 May 2021 07:55:33 +0000
Message-ID: <20210521075533.95732-1-amakhalov@vmware.com>
X-Mailer: git-send-email 2.14.2
In-Reply-To: <459B4724-842E-4B47-B2E7-D29805431E69@vmware.com>
References: <459B4724-842E-4B47-B2E7-D29805431E69@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: amakhalov@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've recently discovered that doing infinite loop of
  systemctl start <ext4_on_lvm>.mount, and
  systemctl stop <ext4_on_lvm>.mount
linearly increases percpu allocator memory consumption.
In several hours, it might lead to system instability by
consuming most of the memory.

During debugging it was found that most of active percpu
allocations are from /system.slice/<ext4_on_lvm>.mount
memory cgroups (created by systemd for each mount). All
of these cgroups are in dying state with refcount equal
to 2. And most interesting that each mount/umount itera-
tion creates exactly one dying memory cgroup.

Tracking down the remaining refcounts showed that it was
charged from ext4_fill_super(). And the page is always
0 index in the page cache mapping.

The issue was hidden behind initial super block read using
logical blocksize from bdev and adjusting blocksize later
after reading actual block size from superblock.
If blocksizes differ, sb_set_blocksize() will kill current
buffers and page cache by using kill_bdev(). And then super
block will be reread again but using correct blocksize this
time. sb_set_blocksize() didn't fully free superblock page
and buffers as buffer pointed by bh variable remained busy.
So buffer and its page remains in the memory (leak). Super
block reread logic does not happen when ext4 filesystem is
on physical partition as blocksize is correct for initial
superblock read.

brelse(bh), where bh is a buffer head of superblock page,
must be called and bh references must be released before
kill_bdev(). kill_bdev() subfunctions (see callstack below)
won't be able to free not released buffer (even if it's
clean) and superblock page won't be freed as well.

callstack:
kill_bdev()
->truncate_inode_pages()
  ->truncate_inode_pages_range()
    ->truncate_cleanup_page()
      ->do_invalidatepage
        ->block_invalidatepage()
	  ->try_to_release_page() == fail to release
	    ->try_to_free_buffers() == fail to free
	      ->drop_buffers()
	        ->buffer_busy() == yes

Incorrect order of brelse() and kill_bdev() in ext4_fill_super()
was introduced by commit ce40733ce93d ("ext4: Check for return
value from sb_set_blocksize") 13 years ago! Thanks to memory
hungry percpu, it was easy to detect this issue now.

Fix this by moving the brelse() before sb_set_blocksize() and
add a comment about the dependency.

In addition, fix similar issue under failed_mount: label (in
the same function) about incorrect order of ext4_blkdev_remove()
vs brelse() introduced by commit ac27a0ec112a ("ext4: initial
copy of files from ext3")

Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Cc: stable@vger.kernel.org
Fixes: ce40733ce93d ("ext4: Check for return value from sb_set_blocksize")
Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext4/super.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b9693680463a..6c8f68309834 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4451,14 +4451,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (sb->s_blocksize != blocksize) {
+		/*
+		 * bh must be released before kill_bdev(), otherwise
+		 * it won't be freed and its page also. kill_bdev()
+		 * is called by sb_set_blocksize().
+		 */
+		brelse(bh);
 		/* Validate the filesystem blocksize */
 		if (!sb_set_blocksize(sb, blocksize)) {
 			ext4_msg(sb, KERN_ERR, "bad block size %d",
 					blocksize);
+			bh = NULL;
 			goto failed_mount;
 		}
 
-		brelse(bh);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = ext4_sb_bread_unmovable(sb, logical_sb_block);
@@ -5178,8 +5184,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		kfree(get_qf_name(sb, sbi, i));
 #endif
 	fscrypt_free_dummy_policy(&sbi->s_dummy_enc_policy);
-	ext4_blkdev_remove(sbi);
+	/* ext4_blkdev_remove() calls kill_bdev(), release bh before it. */
 	brelse(bh);
+	ext4_blkdev_remove(sbi);
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
-- 
2.14.2


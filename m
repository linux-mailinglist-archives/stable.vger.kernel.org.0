Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7F73A0570
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 23:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFHVD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 17:03:57 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:42833 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhFHVD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 17:03:57 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 8 Jun 2021 14:02:02 -0700
Received: from amakhalov-virtual-machine.eng.vmware.com (unknown [10.118.101.187])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 0ABCC20151;
        Tue,  8 Jun 2021 14:02:04 -0700 (PDT)
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     <stable@vger.kernel.org>
CC:     Alexey Makhalov <amakhalov@vmware.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix memory leak in ext4_fill_super
Date:   Tue, 8 Jun 2021 14:02:03 -0700
Message-ID: <20210608210203.91286-1-amakhalov@vmware.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <162315503023234@kroah.com>
References: <162315503023234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: amakhalov@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit afd09b617db3786b6ef3dc43e28fe728cfea84df upstream.
Note: this backport is only targeted for the following LTS branches:
v5.4, v4.19, v4.14, v4.9 and v4.4.

Buffer head references must be released before calling kill_bdev();
otherwise the buffer head (and its page referenced by b_data) will not
be freed by kill_bdev, and subsequently that bh will be leaked.

If blocksizes differ, sb_set_blocksize() will kill current buffers and
page cache by using kill_bdev(). And then super block will be reread
again but using correct blocksize this time. sb_set_blocksize() didn't
fully free superblock page and buffer head, and being busy, they were
not freed and instead leaked.

This can easily be reproduced by calling an infinite loop of:

  systemctl start <ext4_on_lvm>.mount, and
  systemctl stop <ext4_on_lvm>.mount

... since systemd creates a cgroup for each slice which it mounts, and
the bh leak get amplified by a dying memory cgroup that also never
gets freed, and memory consumption is much more easily noticed.

Fixes: ce40733ce93d ("ext4: Check for return value from sb_set_blocksize")
Fixes: ac27a0ec112a ("ext4: initial copy of files from ext3")
Link: https://lore.kernel.org/r/20210521075533.95732-1-amakhalov@vmware.com
Signed-off-by: Alexey Makhalov <amakhalov@vmware.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org # v5.4 and prior
---
 fs/ext4/super.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b364f5e6fdf..8650511ae6af 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4066,14 +4066,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
 		bh = sb_bread_unmovable(sb, logical_sb_block);
@@ -4748,8 +4754,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(get_qf_name(sb, sbi, i));
 #endif
-	ext4_blkdev_remove(sbi);
+	/* ext4_blkdev_remove() calls kill_bdev(), release bh before it. */
 	brelse(bh);
+	ext4_blkdev_remove(sbi);
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
-- 
2.11.0


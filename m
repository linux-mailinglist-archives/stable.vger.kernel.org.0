Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B155156FBD
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 08:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgBJHCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 02:02:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10605 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726061AbgBJHCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 02:02:21 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 950C45A910F7BD655A9D;
        Mon, 10 Feb 2020 15:02:14 +0800 (CST)
Received: from szvp000203569.huawei.com (10.120.216.130) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 10 Feb 2020 15:02:04 +0800
From:   Chao Yu <yuchao0@huawei.com>
To:     <jaegeuk@kernel.org>
CC:     <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <chao@kernel.org>,
        Chao Yu <yuchao0@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH] f2fs: fix to add swap extent correctly
Date:   Mon, 10 Feb 2020 15:01:08 +0800
Message-ID: <20200210070108.8963-1-yuchao0@huawei.com>
X-Mailer: git-send-email 2.18.0.rc1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.120.216.130]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As Youling reported in mailing list:

https://www.linuxquestions.org/questions/linux-newbie-8/the-file-system-f2fs-is-broken-4175666043/

https://www.linux.org/threads/the-file-system-f2fs-is-broken.26490/

There is a test case can corrupt f2fs image:
- dd if=/dev/zero of=/swapfile bs=1M count=4096
- chmod 600 /swapfile
- mkswap /swapfile
- swapon --discard /swapfile

The root cause is f2fs_swap_activate() intends to return zero value
to setup_swap_extents() to enable SWP_FS mode (swap file goes through
fs), in this flow, setup_swap_extents() setups swap extent with wrong
block address range, result in discard_swap() erasing incorrect address.

Because f2fs_swap_activate() has pinned swapfile, its data block
address will not change, it's safe to let swap to handle IO through
raw device, so we can get rid of SWAP_FS mode and initial swap extents
inside f2fs_swap_activate(), by this way, later discard_swap() can trim
in right address range.

Fixes: 4969c06a0d83 ("f2fs: support swap file w/ DIO")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 98c946dfee13..b56437d4973d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3627,7 +3627,8 @@ int f2fs_migrate_page(struct address_space *mapping,
 
 #ifdef CONFIG_SWAP
 /* Copied from generic_swapfile_activate() to check any holes */
-static int check_swap_activate(struct file *swap_file, unsigned int max)
+static int check_swap_activate(struct swap_info_struct *sis,
+				struct file *swap_file, sector_t *span)
 {
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
@@ -3638,6 +3639,8 @@ static int check_swap_activate(struct file *swap_file, unsigned int max)
 	sector_t last_block;
 	sector_t lowest_block = -1;
 	sector_t highest_block = 0;
+	int nr_extents = 0;
+	int ret;
 
 	blkbits = inode->i_blkbits;
 	blocks_per_page = PAGE_SIZE >> blkbits;
@@ -3649,7 +3652,8 @@ static int check_swap_activate(struct file *swap_file, unsigned int max)
 	probe_block = 0;
 	page_no = 0;
 	last_block = i_size_read(inode) >> blkbits;
-	while ((probe_block + blocks_per_page) <= last_block && page_no < max) {
+	while ((probe_block + blocks_per_page) <= last_block &&
+			page_no < sis->max) {
 		unsigned block_in_page;
 		sector_t first_block;
 
@@ -3689,13 +3693,27 @@ static int check_swap_activate(struct file *swap_file, unsigned int max)
 				highest_block = first_block;
 		}
 
+		/*
+		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
+		 */
+		ret = add_swap_extent(sis, page_no, 1, first_block);
+		if (ret < 0)
+			goto out;
+		nr_extents += ret;
 		page_no++;
 		probe_block += blocks_per_page;
 reprobe:
 		continue;
 	}
-	return 0;
-
+	ret = nr_extents;
+	*span = 1 + highest_block - lowest_block;
+	if (page_no == 0)
+		page_no = 1;	/* force Empty message */
+	sis->max = page_no;
+	sis->pages = page_no - 1;
+	sis->highest_bit = page_no - 1;
+out:
+	return ret;
 bad_bmap:
 	pr_err("swapon: swapfile has holes\n");
 	return -EINVAL;
@@ -3720,14 +3738,14 @@ static int f2fs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	if (f2fs_disable_compressed_file(inode))
 		return -EINVAL;
 
-	ret = check_swap_activate(file, sis->max);
-	if (ret)
+	ret = check_swap_activate(sis, file, span);
+	if (ret < 0)
 		return ret;
 
 	set_inode_flag(inode, FI_PIN_FILE);
 	f2fs_precache_extents(inode);
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-	return 0;
+	return ret;
 }
 
 static void f2fs_swap_deactivate(struct file *file)
-- 
2.18.0.rc1


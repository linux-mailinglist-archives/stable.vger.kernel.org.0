Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61A0177F63
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731909AbgCCRu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731339AbgCCRu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D9C20870;
        Tue,  3 Mar 2020 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257825;
        bh=I0XUsqRf2jAq64kwDSfSJrrFK0p23XKnlBLODGyNgXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrGACyr8di3WVjXIFWFGQwGOMP/F7qvWiucbbuVd4V5qwUp0vnzpHhpqfmiSEu7G2
         /EhPVnsybMANWbMegVCWy05ng7r6IQqoU8dCkU7bdR2W8c2b3sII/r9N79HDAHAY6U
         VcWFAeM9uJd0RuJBmFF/9dhKNNZhRLE3j8SMja0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.5 144/176] f2fs: fix to add swap extent correctly
Date:   Tue,  3 Mar 2020 18:43:28 +0100
Message-Id: <20200303174321.418900015@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit 3e5e479a39ce9ed60cd63f7565cc1d9da77c2a4e upstream.

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
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/data.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3132,7 +3132,8 @@ int f2fs_migrate_page(struct address_spa
 
 #ifdef CONFIG_SWAP
 /* Copied from generic_swapfile_activate() to check any holes */
-static int check_swap_activate(struct file *swap_file, unsigned int max)
+static int check_swap_activate(struct swap_info_struct *sis,
+				struct file *swap_file, sector_t *span)
 {
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
@@ -3143,6 +3144,8 @@ static int check_swap_activate(struct fi
 	sector_t last_block;
 	sector_t lowest_block = -1;
 	sector_t highest_block = 0;
+	int nr_extents = 0;
+	int ret;
 
 	blkbits = inode->i_blkbits;
 	blocks_per_page = PAGE_SIZE >> blkbits;
@@ -3154,7 +3157,8 @@ static int check_swap_activate(struct fi
 	probe_block = 0;
 	page_no = 0;
 	last_block = i_size_read(inode) >> blkbits;
-	while ((probe_block + blocks_per_page) <= last_block && page_no < max) {
+	while ((probe_block + blocks_per_page) <= last_block &&
+			page_no < sis->max) {
 		unsigned block_in_page;
 		sector_t first_block;
 
@@ -3194,13 +3198,27 @@ static int check_swap_activate(struct fi
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
@@ -3222,14 +3240,14 @@ static int f2fs_swap_activate(struct swa
 	if (ret)
 		return ret;
 
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



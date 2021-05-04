Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE03726E5
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 10:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhEDIG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 04:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhEDIG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 04:06:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0718CC061574;
        Tue,  4 May 2021 01:06:03 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id x19so12058347lfa.2;
        Tue, 04 May 2021 01:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5ABF2UKQe/gesNGBqzyoumN3x63DuLndBy+FMhwdt4=;
        b=DSGxPJBiTETehS36ZOFREEkCKVQk2+edBF7y5dTQpD5Ky+kvMCnEgsFG+RB4blm2st
         5cezGiZblFbsyxbQIxlFUY+jgaPLyY/E41Lywteo5vXgJIZDk4oBBAAptyLk/vek8fNA
         03/sLNCwmc6wvAfuFLet1/4d4SpnEnA6cgSnoRrdXAPjcvrsIZUjuMMYGG7jEFBIRj7r
         n5khpxTmL5WAZrnAfuh2C9nJ+/ScYZzrK18j8xg6Vu19BeuO2gTIY3hLc7Ha1wo65LPp
         dom7KpKjaUt1fsuG3x+xVGmGA5SbusNHBeTMcyhl4t7H9XINthd2jrrCVC8HpIXALhMu
         ntUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A5ABF2UKQe/gesNGBqzyoumN3x63DuLndBy+FMhwdt4=;
        b=k2/zl4p1foCzIvs/WexaEy79OUXPIOyyRqGzGpPAOVUTLWxJ7AEFw78HXKDgtfy+7P
         1Q9YgJBhLcegmIkuHcoOa0cEZNdUU/F+It8ZJ4/wCrwD9prqRkazUISZqd+mY0OnmR7E
         3h56U/8jsPPIhtpZ9FkJ1c2xvJ81BbFy4NixtqBEWcslgBUyrwKpLiRro7Vd7SfGnQHE
         U5PCoTXjFYHu7aZOe8U13VfDEpxlM+iQw+B2vObKFhF7g1fXA68MIrSFHHktxDEYEKh1
         UpwMYDPxSoxiyXBMSlpwUFtQjQrF20Y+Q8at239TY+c8LS6djgVEj2hNTQU7xdPfIaKz
         nlGQ==
X-Gm-Message-State: AOAM533Shh4l2swKOF1gh6FKQFyUlafyrl1Pg8MRpy0AqmWcIZVID0H9
        /5EtFJc7bY5VlKODcFRW+4IqOciCdLaY19X7
X-Google-Smtp-Source: ABdhPJzWK//xopu+TXHxWLIJw+amC/iHDxkQzqKxSEIrgzne5f7dPGsW5V6GEyThEaXZwugwCbuzsQ==
X-Received: by 2002:ac2:511a:: with SMTP id q26mr15706526lfb.399.1620115561491;
        Tue, 04 May 2021 01:06:01 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.84])
        by smtp.gmail.com with ESMTPSA id e11sm1570648ljk.128.2021.05.04.01.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 01:06:01 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     phillip@squashfs.org.uk
Cc:     linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com
Subject: [PATCH] squashfs: fix divide error
Date:   Tue,  4 May 2021 11:05:52 +0300
Message-Id: <20210504080552.21473-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The problem was in calculate_skip() function.

	int skip = calculate_skip(i_size_read(inode) >> msblk->block_log);

i_size_read(inode) and msblk->block_log are unsigned integers,
but calculate_skip had a signed int as argument. This cast led
to wrong skip value and then to divide by zero bug.

Fixes: 1701aecb6849 ("Squashfs: regular file operations")
Cc: stable@vger.kernel.org
Reported-by: syzbot+e8f781243ce16ac2f962@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 fs/squashfs/file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 7b1128398976..2ebcbd4f84cc 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -44,8 +44,8 @@
  * Locate cache slot in range [offset, index] for specified inode.  If
  * there's more than one return the slot closest to index.
  */
-static struct meta_index *locate_meta_index(struct inode *inode, int offset,
-				int index)
+static struct meta_index *locate_meta_index(struct inode *inode, unsigned int offset,
+				unsigned int index)
 {
 	struct meta_index *meta = NULL;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
@@ -83,8 +83,8 @@ static struct meta_index *locate_meta_index(struct inode *inode, int offset,
 /*
  * Find and initialise an empty cache slot for index offset.
  */
-static struct meta_index *empty_meta_index(struct inode *inode, int offset,
-				int skip)
+static struct meta_index *empty_meta_index(struct inode *inode, unsigned int offset,
+				unsigned int skip)
 {
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	struct meta_index *meta = NULL;
@@ -211,11 +211,11 @@ static long long read_indexes(struct super_block *sb, int n,
  * If the skip factor is limited in this way then the file will use multiple
  * slots.
  */
-static inline int calculate_skip(int blocks)
+static inline unsigned int calculate_skip(unsigned int blocks)
 {
-	int skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
+	unsigned int skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
 		 * SQUASHFS_META_INDEXES);
-	return min(SQUASHFS_CACHED_BLKS - 1, skip + 1);
+	return min((unsigned int) SQUASHFS_CACHED_BLKS - 1, skip + 1);
 }
 
 
@@ -224,12 +224,12 @@ static inline int calculate_skip(int blocks)
  * on-disk locations of the datablock and block list metadata block
  * <index_block, index_offset> for index (scaled to nearest cache index).
  */
-static int fill_meta_index(struct inode *inode, int index,
+static int fill_meta_index(struct inode *inode, unsigned int index,
 		u64 *index_block, int *index_offset, u64 *data_block)
 {
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int skip = calculate_skip(i_size_read(inode) >> msblk->block_log);
-	int offset = 0;
+	unsigned int skip = calculate_skip(i_size_read(inode) >> msblk->block_log);
+	unsigned int offset = 0;
 	struct meta_index *meta;
 	struct meta_entry *meta_entry;
 	u64 cur_index_block = squashfs_i(inode)->block_list_start;
@@ -323,7 +323,7 @@ static int fill_meta_index(struct inode *inode, int index,
  * Get the on-disk location and compressed size of the datablock
  * specified by index.  Fill_meta_index() does most of the work.
  */
-static int read_blocklist(struct inode *inode, int index, u64 *block)
+static int read_blocklist(struct inode *inode, unsigned int index, u64 *block)
 {
 	u64 start;
 	long long blks;
@@ -448,7 +448,7 @@ static int squashfs_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int index = page->index >> (msblk->block_log - PAGE_SHIFT);
+	unsigned int index = page->index >> (msblk->block_log - PAGE_SHIFT);
 	int file_end = i_size_read(inode) >> msblk->block_log;
 	int expected = index == file_end ?
 			(i_size_read(inode) & (msblk->block_size - 1)) :
-- 
2.31.1


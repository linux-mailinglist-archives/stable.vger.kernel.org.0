Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6D6D4933
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjDCOfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbjDCOfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3CDE52
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6854161E62
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5E4C433EF;
        Mon,  3 Apr 2023 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532541;
        bh=YWUIhUGmDSeWy3aORCPdrTjd/+X6kzcpkRQkPLNex6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3gBhuEb+MfTcXI+YoYCGWq5SNR2gUcX1QCYnXXVx9Hs9E0tC5yQr7P+UnYZiXxu7
         WmSEOWA7xAIk0FTo//ZoTxJIYPGyhJKAqx3mp3K5Nnf3xw57Iq1mEMNj6sLU8/38CU
         ZGwjSzuyqWBhWyU5FN8kwYwmFNNAFhVsZ2vSAUzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/181] zonefs: Reduce struct zonefs_inode_info size
Date:   Mon,  3 Apr 2023 16:07:22 +0200
Message-Id: <20230403140415.357461016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 34422914dc00b291d1c47dbdabe93b154c2f2b25 ]

Instead of using the i_ztype field in struct zonefs_inode_info to
indicate the zone type of an inode, introduce the new inode flag
ZONEFS_ZONE_CNV to be set in the i_flags field of struct
zonefs_inode_info to identify conventional zones. If this flag is not
set, the zone of an inode is considered to be a sequential zone.

The helpers zonefs_zone_is_cnv(), zonefs_zone_is_seq(),
zonefs_inode_is_cnv() and zonefs_inode_is_seq() are introduced to
simplify testing the zone type of a struct zonefs_inode_info and of a
struct inode.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Stable-dep-of: 88b170088ad2 ("zonefs: Fix error message in zonefs_file_dio_append()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/file.c   | 35 ++++++++++++++---------------------
 fs/zonefs/super.c  | 12 +++++++-----
 fs/zonefs/zonefs.h | 24 +++++++++++++++++++++---
 3 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index ece0f3959b6d1..64873d31d75dd 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -77,8 +77,7 @@ static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
 	 * checked when writes are issued, so warn if we see a page writeback
 	 * operation.
 	 */
-	if (WARN_ON_ONCE(zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
-			 !(flags & IOMAP_DIRECT)))
+	if (WARN_ON_ONCE(zonefs_zone_is_seq(zi) && !(flags & IOMAP_DIRECT)))
 		return -EIO;
 
 	/*
@@ -128,7 +127,7 @@ static int zonefs_write_map_blocks(struct iomap_writepage_ctx *wpc,
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 
-	if (WARN_ON_ONCE(zi->i_ztype != ZONEFS_ZTYPE_CNV))
+	if (WARN_ON_ONCE(zonefs_zone_is_seq(zi)))
 		return -EIO;
 	if (WARN_ON_ONCE(offset >= i_size_read(inode)))
 		return -EIO;
@@ -158,9 +157,8 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
 				struct file *swap_file, sector_t *span)
 {
 	struct inode *inode = file_inode(swap_file);
-	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 
-	if (zi->i_ztype != ZONEFS_ZTYPE_CNV) {
+	if (zonefs_inode_is_seq(inode)) {
 		zonefs_err(inode->i_sb,
 			   "swap file: not a conventional zone file\n");
 		return -EINVAL;
@@ -196,7 +194,7 @@ int zonefs_file_truncate(struct inode *inode, loff_t isize)
 	 * only down to a 0 size, which is equivalent to a zone reset, and to
 	 * the maximum file size, which is equivalent to a zone finish.
 	 */
-	if (zi->i_ztype != ZONEFS_ZTYPE_SEQ)
+	if (!zonefs_zone_is_seq(zi))
 		return -EPERM;
 
 	if (!isize)
@@ -266,7 +264,7 @@ static int zonefs_file_fsync(struct file *file, loff_t start, loff_t end,
 	 * Since only direct writes are allowed in sequential files, page cache
 	 * flush is needed only for conventional zone files.
 	 */
-	if (ZONEFS_I(inode)->i_ztype == ZONEFS_ZTYPE_CNV)
+	if (zonefs_inode_is_cnv(inode))
 		ret = file_write_and_wait_range(file, start, end);
 	if (!ret)
 		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
@@ -280,7 +278,6 @@ static int zonefs_file_fsync(struct file *file, loff_t start, loff_t end,
 static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	vm_fault_t ret;
 
 	if (unlikely(IS_IMMUTABLE(inode)))
@@ -290,7 +287,7 @@ static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
 	 * Sanity check: only conventional zone files can have shared
 	 * writeable mappings.
 	 */
-	if (WARN_ON_ONCE(zi->i_ztype != ZONEFS_ZTYPE_CNV))
+	if (zonefs_inode_is_seq(inode))
 		return VM_FAULT_NOPAGE;
 
 	sb_start_pagefault(inode->i_sb);
@@ -319,7 +316,7 @@ static int zonefs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 * mappings are possible since there are no guarantees for write
 	 * ordering between msync() and page cache writeback.
 	 */
-	if (ZONEFS_I(file_inode(file))->i_ztype == ZONEFS_ZTYPE_SEQ &&
+	if (zonefs_inode_is_seq(file_inode(file)) &&
 	    (vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
 		return -EINVAL;
 
@@ -352,7 +349,7 @@ static int zonefs_file_write_dio_end_io(struct kiocb *iocb, ssize_t size,
 		return error;
 	}
 
-	if (size && zi->i_ztype != ZONEFS_ZTYPE_CNV) {
+	if (size && zonefs_zone_is_seq(zi)) {
 		/*
 		 * Note that we may be seeing completions out of order,
 		 * but that is not a problem since a write completed
@@ -491,7 +488,7 @@ static ssize_t zonefs_write_checks(struct kiocb *iocb, struct iov_iter *from)
 		return -EINVAL;
 
 	if (iocb->ki_flags & IOCB_APPEND) {
-		if (zi->i_ztype != ZONEFS_ZTYPE_SEQ)
+		if (zonefs_zone_is_cnv(zi))
 			return -EINVAL;
 		mutex_lock(&zi->i_truncate_mutex);
 		iocb->ki_pos = zi->i_wpoffset;
@@ -531,8 +528,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 	 * as this can cause write reordering (e.g. the first aio gets EAGAIN
 	 * on the inode lock but the second goes through but is now unaligned).
 	 */
-	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ && !sync &&
-	    (iocb->ki_flags & IOCB_NOWAIT))
+	if (zonefs_zone_is_seq(zi) && !sync && (iocb->ki_flags & IOCB_NOWAIT))
 		return -EOPNOTSUPP;
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
@@ -554,7 +550,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Enforce sequential writes (append only) in sequential zones */
-	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ) {
+	if (zonefs_zone_is_seq(zi)) {
 		mutex_lock(&zi->i_truncate_mutex);
 		if (iocb->ki_pos != zi->i_wpoffset) {
 			mutex_unlock(&zi->i_truncate_mutex);
@@ -570,7 +566,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 	else
 		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, 0, NULL, 0);
-	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
+	if (zonefs_zone_is_seq(zi) &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
 		if (ret > 0)
 			count = ret;
@@ -596,14 +592,13 @@ static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
 					  struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
-	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	ssize_t ret;
 
 	/*
 	 * Direct IO writes are mandatory for sequential zone files so that the
 	 * write IO issuing order is preserved.
 	 */
-	if (zi->i_ztype != ZONEFS_ZTYPE_CNV)
+	if (zonefs_inode_is_seq(inode))
 		return -EIO;
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
@@ -731,9 +726,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 static inline bool zonefs_seq_file_need_wro(struct inode *inode,
 					    struct file *file)
 {
-	struct zonefs_inode_info *zi = ZONEFS_I(inode);
-
-	if (zi->i_ztype != ZONEFS_ZTYPE_SEQ)
+	if (zonefs_inode_is_cnv(inode))
 		return false;
 
 	if (!(file->f_mode & FMODE_WRITE))
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 6307cc95be061..a4af29dc32e7d 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -37,7 +37,7 @@ void zonefs_account_active(struct inode *inode)
 
 	lockdep_assert_held(&zi->i_truncate_mutex);
 
-	if (zi->i_ztype != ZONEFS_ZTYPE_SEQ)
+	if (zonefs_zone_is_cnv(zi))
 		return;
 
 	/*
@@ -177,14 +177,14 @@ static loff_t zonefs_check_zone_condition(struct inode *inode,
 		zonefs_warn(inode->i_sb, "inode %lu: read-only zone\n",
 			    inode->i_ino);
 		zi->i_flags |= ZONEFS_ZONE_READONLY;
-		if (zi->i_ztype == ZONEFS_ZTYPE_CNV)
+		if (zonefs_zone_is_cnv(zi))
 			return zi->i_max_size;
 		return zi->i_wpoffset;
 	case BLK_ZONE_COND_FULL:
 		/* The write pointer of full zones is invalid. */
 		return zi->i_max_size;
 	default:
-		if (zi->i_ztype == ZONEFS_ZTYPE_CNV)
+		if (zonefs_zone_is_cnv(zi))
 			return zi->i_max_size;
 		return (zone->wp - zone->start) << SECTOR_SHIFT;
 	}
@@ -260,7 +260,7 @@ static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
 	 * In all cases, warn about inode size inconsistency and handle the
 	 * IO error according to the zone condition and to the mount options.
 	 */
-	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ && isize != data_size)
+	if (zonefs_zone_is_seq(zi) && isize != data_size)
 		zonefs_warn(sb, "inode %lu: invalid size %lld (should be %lld)\n",
 			    inode->i_ino, isize, data_size);
 
@@ -584,7 +584,9 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
 	inode->i_mode = S_IFREG | sbi->s_perm;
 
-	zi->i_ztype = type;
+	if (type == ZONEFS_ZTYPE_CNV)
+		zi->i_flags |= ZONEFS_ZONE_CNV;
+
 	zi->i_zsector = zone->start;
 	zi->i_zone_size = zone->len << SECTOR_SHIFT;
 	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev) << SECTOR_SHIFT &&
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 439096445ee53..1a225f74015a0 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -44,6 +44,7 @@ static inline enum zonefs_ztype zonefs_zone_type(struct blk_zone *zone)
 #define ZONEFS_ZONE_ACTIVE	(1U << 2)
 #define ZONEFS_ZONE_OFFLINE	(1U << 3)
 #define ZONEFS_ZONE_READONLY	(1U << 4)
+#define ZONEFS_ZONE_CNV		(1U << 31)
 
 /*
  * In-memory inode data.
@@ -51,9 +52,6 @@ static inline enum zonefs_ztype zonefs_zone_type(struct blk_zone *zone)
 struct zonefs_inode_info {
 	struct inode		i_vnode;
 
-	/* File zone type */
-	enum zonefs_ztype	i_ztype;
-
 	/* File zone start sector (512B unit) */
 	sector_t		i_zsector;
 
@@ -91,6 +89,26 @@ static inline struct zonefs_inode_info *ZONEFS_I(struct inode *inode)
 	return container_of(inode, struct zonefs_inode_info, i_vnode);
 }
 
+static inline bool zonefs_zone_is_cnv(struct zonefs_inode_info *zi)
+{
+	return zi->i_flags & ZONEFS_ZONE_CNV;
+}
+
+static inline bool zonefs_zone_is_seq(struct zonefs_inode_info *zi)
+{
+	return !zonefs_zone_is_cnv(zi);
+}
+
+static inline bool zonefs_inode_is_cnv(struct inode *inode)
+{
+	return zonefs_zone_is_cnv(ZONEFS_I(inode));
+}
+
+static inline bool zonefs_inode_is_seq(struct inode *inode)
+{
+	return zonefs_zone_is_seq(ZONEFS_I(inode));
+}
+
 /*
  * On-disk super block (block 0).
  */
-- 
2.39.2




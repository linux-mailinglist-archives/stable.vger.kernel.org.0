Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A461A5584BD
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiFWRtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235433AbiFWRsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:48:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C72385D35;
        Thu, 23 Jun 2022 10:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F42376159A;
        Thu, 23 Jun 2022 17:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08DBC341C4;
        Thu, 23 Jun 2022 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004282;
        bh=oQrqeyJi3JhlbvbSWqGXGVE7fbjngFPqO0VO6PLddLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THNg/rgTbdBVtGrIWrVGYyXF9pvfj8Q2s4KtzLk5WOneFPJUw6hao4/9Y6LsHZn4P
         M7FDTV+Bsa/YmB6O/SFX16bAg+1bmclpNHVUe5Opmlt5EeSLJvzTMB6oCxcfszA8Pi
         1ZzO0YzqNjxDeZAlOvBitSZ8eozQ2PBnF01OuN2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorgen Hansen <Jorgen.Hansen@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 5.10 02/11] zonefs: fix zonefs_iomap_begin() for reads
Date:   Thu, 23 Jun 2022 18:44:35 +0200
Message-Id: <20220623164322.370072847@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
References: <20220623164322.296526800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit c1c1204c0d0c1dccc1310b9277fb2bd8b663d8fe upstream.

If a readahead is issued to a sequential zone file with an offset
exactly equal to the current file size, the iomap type is set to
IOMAP_UNWRITTEN, which will prevent an IO, but the iomap length is
calculated as 0. This causes a WARN_ON() in iomap_iter():

[17309.548939] WARNING: CPU: 3 PID: 2137 at fs/iomap/iter.c:34 iomap_iter+0x9cf/0xe80
[...]
[17309.650907] RIP: 0010:iomap_iter+0x9cf/0xe80
[...]
[17309.754560] Call Trace:
[17309.757078]  <TASK>
[17309.759240]  ? lock_is_held_type+0xd8/0x130
[17309.763531]  iomap_readahead+0x1a8/0x870
[17309.767550]  ? iomap_read_folio+0x4c0/0x4c0
[17309.771817]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[17309.778848]  ? lock_release+0x370/0x750
[17309.784462]  ? folio_add_lru+0x217/0x3f0
[17309.790220]  ? reacquire_held_locks+0x4e0/0x4e0
[17309.796543]  read_pages+0x17d/0xb60
[17309.801854]  ? folio_add_lru+0x238/0x3f0
[17309.807573]  ? readahead_expand+0x5f0/0x5f0
[17309.813554]  ? policy_node+0xb5/0x140
[17309.819018]  page_cache_ra_unbounded+0x27d/0x450
[17309.825439]  filemap_get_pages+0x500/0x1450
[17309.831444]  ? filemap_add_folio+0x140/0x140
[17309.837519]  ? lock_is_held_type+0xd8/0x130
[17309.843509]  filemap_read+0x28c/0x9f0
[17309.848953]  ? zonefs_file_read_iter+0x1ea/0x4d0 [zonefs]
[17309.856162]  ? trace_contention_end+0xd6/0x130
[17309.862416]  ? __mutex_lock+0x221/0x1480
[17309.868151]  ? zonefs_file_read_iter+0x166/0x4d0 [zonefs]
[17309.875364]  ? filemap_get_pages+0x1450/0x1450
[17309.881647]  ? __mutex_unlock_slowpath+0x15e/0x620
[17309.888248]  ? wait_for_completion_io_timeout+0x20/0x20
[17309.895231]  ? lock_is_held_type+0xd8/0x130
[17309.901115]  ? lock_is_held_type+0xd8/0x130
[17309.906934]  zonefs_file_read_iter+0x356/0x4d0 [zonefs]
[17309.913750]  new_sync_read+0x2d8/0x520
[17309.919035]  ? __x64_sys_lseek+0x1d0/0x1d0

Furthermore, this causes iomap_readahead() to loop forever as
iomap_readahead_iter() always returns 0, making no progress.

Fix this by treating reads after the file size as access to holes,
setting the iomap type to IOMAP_HOLE, the iomap addr to IOMAP_NULL_ADDR
and using the length argument as is for the iomap length. To simplify
the code with this change, zonefs_iomap_begin() is split into the read
variant, zonefs_read_iomap_begin() and zonefs_read_iomap_ops, and the
write variant, zonefs_write_iomap_begin() and zonefs_write_iomap_ops.

Reported-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Jorgen Hansen <Jorgen.Hansen@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   92 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 30 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -68,15 +68,49 @@ static inline void zonefs_i_size_write(s
 		zi->i_flags &= ~ZONEFS_ZONE_OPEN;
 }
 
-static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
-			      unsigned int flags, struct iomap *iomap,
-			      struct iomap *srcmap)
+static int zonefs_read_iomap_begin(struct inode *inode, loff_t offset,
+				   loff_t length, unsigned int flags,
+				   struct iomap *iomap, struct iomap *srcmap)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct super_block *sb = inode->i_sb;
 	loff_t isize;
 
-	/* All I/Os should always be within the file maximum size */
+	/*
+	 * All blocks are always mapped below EOF. If reading past EOF,
+	 * act as if there is a hole up to the file maximum size.
+	 */
+	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	isize = i_size_read(inode);
+	if (iomap->offset >= isize) {
+		iomap->type = IOMAP_HOLE;
+		iomap->addr = IOMAP_NULL_ADDR;
+		iomap->length = length;
+	} else {
+		iomap->type = IOMAP_MAPPED;
+		iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
+		iomap->length = isize - iomap->offset;
+	}
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	return 0;
+}
+
+static const struct iomap_ops zonefs_read_iomap_ops = {
+	.iomap_begin	= zonefs_read_iomap_begin,
+};
+
+static int zonefs_write_iomap_begin(struct inode *inode, loff_t offset,
+				    loff_t length, unsigned int flags,
+				    struct iomap *iomap, struct iomap *srcmap)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	loff_t isize;
+
+	/* All write I/Os should always be within the file maximum size */
 	if (WARN_ON_ONCE(offset + length > zi->i_max_size))
 		return -EIO;
 
@@ -86,7 +120,7 @@ static int zonefs_iomap_begin(struct ino
 	 * operation.
 	 */
 	if (WARN_ON_ONCE(zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
-			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
+			 !(flags & IOMAP_DIRECT)))
 		return -EIO;
 
 	/*
@@ -95,45 +129,42 @@ static int zonefs_iomap_begin(struct ino
 	 * write pointer) and unwriten beyond.
 	 */
 	mutex_lock(&zi->i_truncate_mutex);
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
 	isize = i_size_read(inode);
-	if (offset >= isize)
+	if (iomap->offset >= isize) {
 		iomap->type = IOMAP_UNWRITTEN;
-	else
+		iomap->length = zi->i_max_size - iomap->offset;
+	} else {
 		iomap->type = IOMAP_MAPPED;
-	if (flags & IOMAP_WRITE)
-		length = zi->i_max_size - offset;
-	else
-		length = min(length, isize - offset);
+		iomap->length = isize - iomap->offset;
+	}
 	mutex_unlock(&zi->i_truncate_mutex);
 
-	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
-	iomap->length = ALIGN(offset + length, sb->s_blocksize) - iomap->offset;
-	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
-
 	return 0;
 }
 
-static const struct iomap_ops zonefs_iomap_ops = {
-	.iomap_begin	= zonefs_iomap_begin,
+static const struct iomap_ops zonefs_write_iomap_ops = {
+	.iomap_begin	= zonefs_write_iomap_begin,
 };
 
 static int zonefs_readpage(struct file *unused, struct page *page)
 {
-	return iomap_readpage(page, &zonefs_iomap_ops);
+	return iomap_readpage(page, &zonefs_read_iomap_ops);
 }
 
 static void zonefs_readahead(struct readahead_control *rac)
 {
-	iomap_readahead(rac, &zonefs_iomap_ops);
+	iomap_readahead(rac, &zonefs_read_iomap_ops);
 }
 
 /*
  * Map blocks for page writeback. This is used only on conventional zone files,
  * which implies that the page range can only be within the fixed inode size.
  */
-static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
-			     struct inode *inode, loff_t offset)
+static int zonefs_write_map_blocks(struct iomap_writepage_ctx *wpc,
+				   struct inode *inode, loff_t offset)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 
@@ -147,12 +178,12 @@ static int zonefs_map_blocks(struct ioma
 	    offset < wpc->iomap.offset + wpc->iomap.length)
 		return 0;
 
-	return zonefs_iomap_begin(inode, offset, zi->i_max_size - offset,
-				  IOMAP_WRITE, &wpc->iomap, NULL);
+	return zonefs_write_iomap_begin(inode, offset, zi->i_max_size - offset,
+					IOMAP_WRITE, &wpc->iomap, NULL);
 }
 
 static const struct iomap_writeback_ops zonefs_writeback_ops = {
-	.map_blocks		= zonefs_map_blocks,
+	.map_blocks		= zonefs_write_map_blocks,
 };
 
 static int zonefs_writepage(struct page *page, struct writeback_control *wbc)
@@ -182,7 +213,8 @@ static int zonefs_swap_activate(struct s
 		return -EINVAL;
 	}
 
-	return iomap_swapfile_activate(sis, swap_file, span, &zonefs_iomap_ops);
+	return iomap_swapfile_activate(sis, swap_file, span,
+				       &zonefs_read_iomap_ops);
 }
 
 static const struct address_space_operations zonefs_file_aops = {
@@ -612,7 +644,7 @@ static vm_fault_t zonefs_filemap_page_mk
 
 	/* Serialize against truncates */
 	down_read(&zi->i_mmap_sem);
-	ret = iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
+	ret = iomap_page_mkwrite(vmf, &zonefs_write_iomap_ops);
 	up_read(&zi->i_mmap_sem);
 
 	sb_end_pagefault(inode->i_sb);
@@ -869,7 +901,7 @@ static ssize_t zonefs_file_dio_write(str
 	if (append)
 		ret = zonefs_file_dio_append(iocb, from);
 	else
-		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
+		ret = iomap_dio_rw(iocb, from, &zonefs_write_iomap_ops,
 				   &zonefs_write_dio_ops, sync);
 	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
@@ -911,7 +943,7 @@ static ssize_t zonefs_file_buffered_writ
 	if (ret <= 0)
 		goto inode_unlock;
 
-	ret = iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
+	ret = iomap_file_buffered_write(iocb, from, &zonefs_write_iomap_ops);
 	if (ret > 0)
 		iocb->ki_pos += ret;
 	else if (ret == -EIO)
@@ -1004,7 +1036,7 @@ static ssize_t zonefs_file_read_iter(str
 			goto inode_unlock;
 		}
 		file_accessed(iocb->ki_filp);
-		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
+		ret = iomap_dio_rw(iocb, to, &zonefs_read_iomap_ops,
 				   &zonefs_read_dio_ops, is_sync_kiocb(iocb));
 	} else {
 		ret = generic_file_read_iter(iocb, to);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA5E1B3F81
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgDVKiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729846AbgDVKWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 312B620CC7;
        Wed, 22 Apr 2020 10:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550908;
        bh=Jkaizt38vuK3ad4xV68G+hRZiQoc5INa/ZDzkOBwnko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GG4gZyam3HWH9z/vBCFdzSMsYHqrZ8vMXoCAeAAi0x0UgkGSewvhID2w0AaSaStQ+
         9qdZsSPHHoaWYP9YoWlIBQzLHuB4l1as1vP2JkexhDhn+6TJ2SyuttCMR5KY5ABUIV
         CGMGcW/G7d6YTPdzsDYBihrD8YUfcvLtnEQkNSZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Roman Gushchin <guro@fb.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.6 006/166] ext4: use non-movable memory for superblock readahead
Date:   Wed, 22 Apr 2020 11:55:33 +0200
Message-Id: <20200422095048.754376835@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit d87f639258a6a5980183f11876c884931ad93da2 upstream.

Since commit a8ac900b8163 ("ext4: use non-movable memory for the
superblock") buffers for ext4 superblock were allocated using
the sb_bread_unmovable() helper which allocated buffer heads
out of non-movable memory blocks. It was necessarily to not block
page migrations and do not cause cma allocation failures.

However commit 85c8f176a611 ("ext4: preload block group descriptors")
broke this by introducing pre-reading of the ext4 superblock.
The problem is that __breadahead() is using __getblk() underneath,
which allocates buffer heads out of movable memory.

It resulted in page migration failures I've seen on a machine
with an ext4 partition and a preallocated cma area.

Fix this by introducing sb_breadahead_unmovable() and
__breadahead_gfp() helpers which use non-movable memory for buffer
head allocations and use them for the ext4 superblock readahead.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Fixes: 85c8f176a611 ("ext4: preload block group descriptors")
Signed-off-by: Roman Gushchin <guro@fb.com>
Link: https://lore.kernel.org/r/20200229001411.128010-1-guro@fb.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/buffer.c                 |   11 +++++++++++
 fs/ext4/inode.c             |    2 +-
 fs/ext4/super.c             |    2 +-
 include/linux/buffer_head.h |    8 ++++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1377,6 +1377,17 @@ void __breadahead(struct block_device *b
 }
 EXPORT_SYMBOL(__breadahead);
 
+void __breadahead_gfp(struct block_device *bdev, sector_t block, unsigned size,
+		      gfp_t gfp)
+{
+	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
+	if (likely(bh)) {
+		ll_rw_block(REQ_OP_READ, REQ_RAHEAD, 1, &bh);
+		brelse(bh);
+	}
+}
+EXPORT_SYMBOL(__breadahead_gfp);
+
 /**
  *  __bread_gfp() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4348,7 +4348,7 @@ make_io:
 			if (end > table)
 				end = table;
 			while (b <= end)
-				sb_breadahead(sb, b++);
+				sb_breadahead_unmovable(sb, b++);
 		}
 
 		/*
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4331,7 +4331,7 @@ static int ext4_fill_super(struct super_
 	/* Pre-read the descriptors into the buffer cache */
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sb_breadahead(sb, block);
+		sb_breadahead_unmovable(sb, block);
 	}
 
 	for (i = 0; i < db_count; i++) {
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -189,6 +189,8 @@ struct buffer_head *__getblk_gfp(struct
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
+void __breadahead_gfp(struct block_device *, sector_t block, unsigned int size,
+		  gfp_t gfp);
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
@@ -319,6 +321,12 @@ sb_breadahead(struct super_block *sb, se
 	__breadahead(sb->s_bdev, block, sb->s_blocksize);
 }
 
+static inline void
+sb_breadahead_unmovable(struct super_block *sb, sector_t block)
+{
+	__breadahead_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
+}
+
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
 {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCC21B7486
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgDXMYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728477AbgDXMYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C21920700;
        Fri, 24 Apr 2020 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731077;
        bh=DHDc8HltG1BdWiLHKwuKbNTHzHVBSNJSqnUSXAbGIkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmCBCtmqZYFv9jo52Njgf/8cM5336w1GJDY6bfo0NPzIX8sQRYkq9ODyTZlCwUJqS
         SUYhtyw9lsAgpCOz4VAt9lLGiEkhk5+DzxHdPGPQvm/f3cSiF+aYDxZjsCpyk5yZbT
         TN+9MgV7kENYUapNUWjsqfg2gM0yAfQy41nidSu0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Gushchin <guro@fb.com>, Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/21] ext4: use non-movable memory for superblock readahead
Date:   Fri, 24 Apr 2020 08:24:12 -0400
Message-Id: <20200424122419.10648-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122419.10648-1-sashal@kernel.org>
References: <20200424122419.10648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

[ Upstream commit d87f639258a6a5980183f11876c884931ad93da2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c                 | 11 +++++++++++
 fs/ext4/inode.c             |  2 +-
 fs/ext4/super.c             |  2 +-
 include/linux/buffer_head.h |  8 ++++++++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bdca7b10e239b..cae7f24a0410e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1398,6 +1398,17 @@ void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
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
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 10838b28c5bbd..c8a1c68c33ae5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4593,7 +4593,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 			if (end > table)
 				end = table;
 			while (b <= end)
-				sb_breadahead(sb, b++);
+				sb_breadahead_unmovable(sb, b++);
 		}
 
 		/*
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f5646bcad7702..074b9d43e24d8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4145,7 +4145,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	/* Pre-read the descriptors into the buffer cache */
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sb_breadahead(sb, block);
+		sb_breadahead_unmovable(sb, block);
 	}
 
 	for (i = 0; i < db_count; i++) {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index afa37f807f12c..2e1077ea77db0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -187,6 +187,8 @@ struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
+void __breadahead_gfp(struct block_device *, sector_t block, unsigned int size,
+		  gfp_t gfp);
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
@@ -319,6 +321,12 @@ sb_breadahead(struct super_block *sb, sector_t block)
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
-- 
2.20.1


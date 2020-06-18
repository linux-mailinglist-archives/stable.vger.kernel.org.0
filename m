Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474171FDBFE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgFRBPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbgFRBPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7CFB21D80;
        Thu, 18 Jun 2020 01:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442951;
        bh=EfwLt18W55XzLY/moPI0FPDyRzLo0xfT/qZhxO+kjmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODfOCHheYl55F2Sn7n1cOBtTDf3bzom53Rwy5agX+Rac60sDNIjK+a7NSrZanDqGe
         20g7v6FUnd/80rGu5nCER/xebymncmR05aRYXKle8KU9wB4LEzqtM9z5kRzaja8QoX
         Ubda9MMKrPwS+FkDGskjrD96/PFtiFbcqUesomgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.7 360/388] f2fs: don't return vmalloc() memory from f2fs_kmalloc()
Date:   Wed, 17 Jun 2020 21:07:37 -0400
Message-Id: <20200618010805.600873-360-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 0b6d4ca04a86b9dababbb76e58d33c437e127b77 ]

kmalloc() returns kmalloc'ed memory, and kvmalloc() returns either
kmalloc'ed or vmalloc'ed memory.  But the f2fs wrappers, f2fs_kmalloc()
and f2fs_kvmalloc(), both return both kinds of memory.

It's redundant to have two functions that do the same thing, and also
breaking the standard naming convention is causing bugs since people
assume it's safe to kfree() memory allocated by f2fs_kmalloc().  See
e.g. the various allocations in fs/f2fs/compress.c.

Fix this by making f2fs_kmalloc() just use kmalloc().  And to avoid
re-introducing the allocation failures that the vmalloc fallback was
intended to fix, convert the largest allocations to use f2fs_kvmalloc().

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 4 ++--
 fs/f2fs/f2fs.h       | 8 +-------
 fs/f2fs/node.c       | 8 ++++----
 fs/f2fs/super.c      | 2 +-
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 852890b72d6a..448b3dc6f925 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -889,8 +889,8 @@ int f2fs_get_valid_checkpoint(struct f2fs_sb_info *sbi)
 	int i;
 	int err;
 
-	sbi->ckpt = f2fs_kzalloc(sbi, array_size(blk_size, cp_blks),
-				 GFP_KERNEL);
+	sbi->ckpt = f2fs_kvzalloc(sbi, array_size(blk_size, cp_blks),
+				  GFP_KERNEL);
 	if (!sbi->ckpt)
 		return -ENOMEM;
 	/*
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1f8ae28d7ccf..6579f43f8519 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2935,18 +2935,12 @@ static inline bool f2fs_may_extent_tree(struct inode *inode)
 static inline void *f2fs_kmalloc(struct f2fs_sb_info *sbi,
 					size_t size, gfp_t flags)
 {
-	void *ret;
-
 	if (time_to_inject(sbi, FAULT_KMALLOC)) {
 		f2fs_show_injection_info(sbi, FAULT_KMALLOC);
 		return NULL;
 	}
 
-	ret = kmalloc(size, flags);
-	if (ret)
-		return ret;
-
-	return kvmalloc(size, flags);
+	return kmalloc(size, flags);
 }
 
 static inline void *f2fs_kzalloc(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index ecbd6bd14a49..daf531e69b67 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2928,7 +2928,7 @@ static int __get_nat_bitmaps(struct f2fs_sb_info *sbi)
 		return 0;
 
 	nm_i->nat_bits_blocks = F2FS_BLK_ALIGN((nat_bits_bytes << 1) + 8);
-	nm_i->nat_bits = f2fs_kzalloc(sbi,
+	nm_i->nat_bits = f2fs_kvzalloc(sbi,
 			nm_i->nat_bits_blocks << F2FS_BLKSIZE_BITS, GFP_KERNEL);
 	if (!nm_i->nat_bits)
 		return -ENOMEM;
@@ -3061,9 +3061,9 @@ static int init_free_nid_cache(struct f2fs_sb_info *sbi)
 	int i;
 
 	nm_i->free_nid_bitmap =
-		f2fs_kzalloc(sbi, array_size(sizeof(unsigned char *),
-					     nm_i->nat_blocks),
-			     GFP_KERNEL);
+		f2fs_kvzalloc(sbi, array_size(sizeof(unsigned char *),
+					      nm_i->nat_blocks),
+			      GFP_KERNEL);
 	if (!nm_i->free_nid_bitmap)
 		return -ENOMEM;
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c5e8cb31626f..b7d14ddcd469 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3027,7 +3027,7 @@ static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
 	if (nr_sectors & (bdev_zone_sectors(bdev) - 1))
 		FDEV(devi).nr_blkz++;
 
-	FDEV(devi).blkz_seq = f2fs_kzalloc(sbi,
+	FDEV(devi).blkz_seq = f2fs_kvzalloc(sbi,
 					BITS_TO_LONGS(FDEV(devi).nr_blkz)
 					* sizeof(unsigned long),
 					GFP_KERNEL);
-- 
2.25.1


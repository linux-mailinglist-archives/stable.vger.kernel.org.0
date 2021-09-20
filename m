Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A941218E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350657AbhITSGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357130AbhITSDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C48263233;
        Mon, 20 Sep 2021 17:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158202;
        bh=Hi66xODOrAOt8rma2/m9f3uAEUNhrRrnltfN6p+vFUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0Nab/C7vKl0pPraPGkIvGTnU+zLe+hdEkWXR3BcR240vxMSh9rY5WS1/PtM9fKqZ
         kCM/m5a68Mfjk/IeaH0umNWktzrt4faPLtfiubtr42k1cBUdWVKXdt/sbBRMT3Ueho
         dO7JS4VfXsW3PJhhQOl8hNOVVWQid7ELiKlYJeso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/260] f2fs: show f2fs instance in printk_ratelimited
Date:   Mon, 20 Sep 2021 18:41:04 +0200
Message-Id: <20210920163932.678624571@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit c45d6002ff7a322022560e9b19ad867b01fec77f ]

As Eric mentioned, bare printk{,_ratelimited} won't show which
filesystem instance these message is coming from, this patch tries
to show fs instance with sb->s_id field in all places we missed
before.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/data.c       |  9 +++++----
 fs/f2fs/dir.c        |  7 ++++---
 fs/f2fs/f2fs.h       | 24 +++++++++++++-----------
 fs/f2fs/file.c       |  2 +-
 fs/f2fs/gc.c         |  2 +-
 fs/f2fs/inode.c      |  2 +-
 fs/f2fs/node.c       |  2 +-
 fs/f2fs/segment.c    |  9 +++++----
 9 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index a57219c51c01..f7d27cbbeb86 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -583,7 +583,7 @@ int f2fs_acquire_orphan_inode(struct f2fs_sb_info *sbi)
 
 	if (time_to_inject(sbi, FAULT_ORPHAN)) {
 		spin_unlock(&im->ino_lock);
-		f2fs_show_injection_info(FAULT_ORPHAN);
+		f2fs_show_injection_info(sbi, FAULT_ORPHAN);
 		return -ENOSPC;
 	}
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 64ee2a064e33..df2c361feade 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -167,9 +167,10 @@ static bool f2fs_bio_post_read_required(struct bio *bio)
 
 static void f2fs_read_end_io(struct bio *bio)
 {
-	if (time_to_inject(F2FS_P_SB(bio_first_page_all(bio)),
-						FAULT_READ_IO)) {
-		f2fs_show_injection_info(FAULT_READ_IO);
+	struct f2fs_sb_info *sbi = F2FS_P_SB(bio_first_page_all(bio));
+
+	if (time_to_inject(sbi, FAULT_READ_IO)) {
+		f2fs_show_injection_info(sbi, FAULT_READ_IO);
 		bio->bi_status = BLK_STS_IOERR;
 	}
 
@@ -191,7 +192,7 @@ static void f2fs_write_end_io(struct bio *bio)
 	struct bvec_iter_all iter_all;
 
 	if (time_to_inject(sbi, FAULT_WRITE_IO)) {
-		f2fs_show_injection_info(FAULT_WRITE_IO);
+		f2fs_show_injection_info(sbi, FAULT_WRITE_IO);
 		bio->bi_status = BLK_STS_IOERR;
 	}
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 78d041f9775a..7b3fbfe68f8c 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -618,7 +618,7 @@ int f2fs_add_regular_entry(struct inode *dir, const struct qstr *new_name,
 
 start:
 	if (time_to_inject(F2FS_I_SB(dir), FAULT_DIR_DEPTH)) {
-		f2fs_show_injection_info(FAULT_DIR_DEPTH);
+		f2fs_show_injection_info(F2FS_I_SB(dir), FAULT_DIR_DEPTH);
 		return -ENOSPC;
 	}
 
@@ -909,8 +909,9 @@ int f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 			bit_pos++;
 			ctx->pos = start_pos + bit_pos;
 			printk_ratelimited(
-				"%s, invalid namelen(0), ino:%u, run fsck to fix.",
-				KERN_WARNING, le32_to_cpu(de->ino));
+				"%sF2FS-fs (%s): invalid namelen(0), ino:%u, run fsck to fix.",
+				KERN_WARNING, sbi->sb->s_id,
+				le32_to_cpu(de->ino));
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			continue;
 		}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 4ca3c2a0a0f5..031a17bf52a2 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1374,9 +1374,10 @@ struct f2fs_private_dio {
 };
 
 #ifdef CONFIG_F2FS_FAULT_INJECTION
-#define f2fs_show_injection_info(type)					\
-	printk_ratelimited("%sF2FS-fs : inject %s in %s of %pS\n",	\
-		KERN_INFO, f2fs_fault_name[type],			\
+#define f2fs_show_injection_info(sbi, type)					\
+	printk_ratelimited("%sF2FS-fs (%s) : inject %s in %s of %pS\n",	\
+		KERN_INFO, sbi->sb->s_id,				\
+		f2fs_fault_name[type],					\
 		__func__, __builtin_return_address(0))
 static inline bool time_to_inject(struct f2fs_sb_info *sbi, int type)
 {
@@ -1396,7 +1397,7 @@ static inline bool time_to_inject(struct f2fs_sb_info *sbi, int type)
 	return false;
 }
 #else
-#define f2fs_show_injection_info(type) do { } while (0)
+#define f2fs_show_injection_info(sbi, type) do { } while (0)
 static inline bool time_to_inject(struct f2fs_sb_info *sbi, int type)
 {
 	return false;
@@ -1781,7 +1782,7 @@ static inline int inc_valid_block_count(struct f2fs_sb_info *sbi,
 		return ret;
 
 	if (time_to_inject(sbi, FAULT_BLOCK)) {
-		f2fs_show_injection_info(FAULT_BLOCK);
+		f2fs_show_injection_info(sbi, FAULT_BLOCK);
 		release = *count;
 		goto release_quota;
 	}
@@ -2033,7 +2034,7 @@ static inline int inc_valid_node_count(struct f2fs_sb_info *sbi,
 	}
 
 	if (time_to_inject(sbi, FAULT_BLOCK)) {
-		f2fs_show_injection_info(FAULT_BLOCK);
+		f2fs_show_injection_info(sbi, FAULT_BLOCK);
 		goto enospc;
 	}
 
@@ -2148,7 +2149,8 @@ static inline struct page *f2fs_grab_cache_page(struct address_space *mapping,
 			return page;
 
 		if (time_to_inject(F2FS_M_SB(mapping), FAULT_PAGE_ALLOC)) {
-			f2fs_show_injection_info(FAULT_PAGE_ALLOC);
+			f2fs_show_injection_info(F2FS_M_SB(mapping),
+							FAULT_PAGE_ALLOC);
 			return NULL;
 		}
 	}
@@ -2163,7 +2165,7 @@ static inline struct page *f2fs_pagecache_get_page(
 				int fgp_flags, gfp_t gfp_mask)
 {
 	if (time_to_inject(F2FS_M_SB(mapping), FAULT_PAGE_GET)) {
-		f2fs_show_injection_info(FAULT_PAGE_GET);
+		f2fs_show_injection_info(F2FS_M_SB(mapping), FAULT_PAGE_GET);
 		return NULL;
 	}
 
@@ -2232,7 +2234,7 @@ static inline struct bio *f2fs_bio_alloc(struct f2fs_sb_info *sbi,
 		return bio;
 	}
 	if (time_to_inject(sbi, FAULT_ALLOC_BIO)) {
-		f2fs_show_injection_info(FAULT_ALLOC_BIO);
+		f2fs_show_injection_info(sbi, FAULT_ALLOC_BIO);
 		return NULL;
 	}
 
@@ -2797,7 +2799,7 @@ static inline void *f2fs_kmalloc(struct f2fs_sb_info *sbi,
 					size_t size, gfp_t flags)
 {
 	if (time_to_inject(sbi, FAULT_KMALLOC)) {
-		f2fs_show_injection_info(FAULT_KMALLOC);
+		f2fs_show_injection_info(sbi, FAULT_KMALLOC);
 		return NULL;
 	}
 
@@ -2814,7 +2816,7 @@ static inline void *f2fs_kvmalloc(struct f2fs_sb_info *sbi,
 					size_t size, gfp_t flags)
 {
 	if (time_to_inject(sbi, FAULT_KVMALLOC)) {
-		f2fs_show_injection_info(FAULT_KVMALLOC);
+		f2fs_show_injection_info(sbi, FAULT_KVMALLOC);
 		return NULL;
 	}
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6e58b2e62b18..f98dce4d07b3 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -682,7 +682,7 @@ int f2fs_truncate(struct inode *inode)
 	trace_f2fs_truncate(inode);
 
 	if (time_to_inject(F2FS_I_SB(inode), FAULT_TRUNCATE)) {
-		f2fs_show_injection_info(FAULT_TRUNCATE);
+		f2fs_show_injection_info(F2FS_I_SB(inode), FAULT_TRUNCATE);
 		return -EIO;
 	}
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index a78aa5480454..6b13a1a89206 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -54,7 +54,7 @@ static int gc_thread_func(void *data)
 		}
 
 		if (time_to_inject(sbi, FAULT_CHECKPOINT)) {
-			f2fs_show_injection_info(FAULT_CHECKPOINT);
+			f2fs_show_injection_info(sbi, FAULT_CHECKPOINT);
 			f2fs_stop_checkpoint(sbi, false);
 		}
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 386ad54c13c3..502bd491336a 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -681,7 +681,7 @@ void f2fs_evict_inode(struct inode *inode)
 		err = f2fs_truncate(inode);
 
 	if (time_to_inject(sbi, FAULT_EVICT_INODE)) {
-		f2fs_show_injection_info(FAULT_EVICT_INODE);
+		f2fs_show_injection_info(sbi, FAULT_EVICT_INODE);
 		err = -EIO;
 	}
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 48bb5d3c709d..4cb182c20eed 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2406,7 +2406,7 @@ bool f2fs_alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 	struct free_nid *i = NULL;
 retry:
 	if (time_to_inject(sbi, FAULT_ALLOC_NID)) {
-		f2fs_show_injection_info(FAULT_ALLOC_NID);
+		f2fs_show_injection_info(sbi, FAULT_ALLOC_NID);
 		return false;
 	}
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 5ba677f85533..78c54bb7898d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -489,7 +489,7 @@ int f2fs_commit_inmem_pages(struct inode *inode)
 void f2fs_balance_fs(struct f2fs_sb_info *sbi, bool need)
 {
 	if (time_to_inject(sbi, FAULT_CHECKPOINT)) {
-		f2fs_show_injection_info(FAULT_CHECKPOINT);
+		f2fs_show_injection_info(sbi, FAULT_CHECKPOINT);
 		f2fs_stop_checkpoint(sbi, false);
 	}
 
@@ -1017,8 +1017,9 @@ static void __remove_discard_cmd(struct f2fs_sb_info *sbi,
 
 	if (dc->error)
 		printk_ratelimited(
-			"%sF2FS-fs: Issue discard(%u, %u, %u) failed, ret: %d",
-			KERN_INFO, dc->lstart, dc->start, dc->len, dc->error);
+			"%sF2FS-fs (%s): Issue discard(%u, %u, %u) failed, ret: %d",
+			KERN_INFO, sbi->sb->s_id,
+			dc->lstart, dc->start, dc->len, dc->error);
 	__detach_discard_cmd(dcc, dc);
 }
 
@@ -1158,7 +1159,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 		dc->len += len;
 
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
-			f2fs_show_injection_info(FAULT_DISCARD);
+			f2fs_show_injection_info(sbi, FAULT_DISCARD);
 			err = -EIO;
 			goto submit;
 		}
-- 
2.30.2




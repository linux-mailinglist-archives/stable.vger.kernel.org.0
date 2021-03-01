Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C47A328A25
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhCASND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239013AbhCASGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F9346502A;
        Mon,  1 Mar 2021 17:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618816;
        bh=chlXqqNxFUMkX9JphlrvzkPfsNDgmKNdMUUROlQ/fMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4e9h15/yn0J4B2Sb/Ch5D35TOtCsc69UPFTQvi5OKxuAAtA+NPlW0tAFHDrOBAor
         +GIjURp3MtiSIR6bpKuLrDp9ThWnhUXMkabGLwoFRFjRhyVJ676f8+mRlsWAHteGO3
         GSshbhM0qDPNOvXzFcnT/Sey4gQ/JNDAr59gvi2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/663] f2fs: compress: fix potential deadlock
Date:   Mon,  1 Mar 2021 17:07:25 +0100
Message-Id: <20210301161151.527590889@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 3afae09ffea5e08f523823be99a784675995d6bb ]

generic/269 reports a hangtask issue, the root cause is ABBA deadlock
described as below:

Thread A			Thread B
- down_write(&sbi->gc_lock) -- A
				- f2fs_write_data_pages
				 - lock all pages in cluster -- B
				 - f2fs_write_multi_pages
				  - f2fs_write_raw_pages
				   - f2fs_write_single_data_page
				    - f2fs_balance_fs
				     - down_write(&sbi->gc_lock) -- A
- f2fs_gc
 - do_garbage_collect
  - ra_data_block
   - pagecache_get_page -- B

To fix this, it needs to avoid calling f2fs_balance_fs() if there is
still cluster pages been locked in context of cluster writeback, so
instead, let's call f2fs_balance_fs() in the end of
f2fs_write_raw_pages() when all cluster pages were unlocked.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c |  5 ++++-
 fs/f2fs/data.c     | 10 ++++++----
 fs/f2fs/f2fs.h     |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index c5fee4d7ea72f..d3f407ba64c9e 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1393,7 +1393,7 @@ retry_write:
 
 		ret = f2fs_write_single_data_page(cc->rpages[i], &_submitted,
 						NULL, NULL, wbc, io_type,
-						compr_blocks);
+						compr_blocks, false);
 		if (ret) {
 			if (ret == AOP_WRITEPAGE_ACTIVATE) {
 				unlock_page(cc->rpages[i]);
@@ -1428,6 +1428,9 @@ retry_write:
 
 		*submitted += _submitted;
 	}
+
+	f2fs_balance_fs(F2FS_M_SB(mapping), true);
+
 	return 0;
 out_err:
 	for (++i; i < cc->cluster_size; i++) {
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b29243ee1c3e5..4f326bce525f7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2757,7 +2757,8 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 				sector_t *last_block,
 				struct writeback_control *wbc,
 				enum iostat_type io_type,
-				int compr_blocks)
+				int compr_blocks,
+				bool allow_balance)
 {
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
@@ -2895,7 +2896,7 @@ out:
 	}
 	unlock_page(page);
 	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
-					!F2FS_I(inode)->cp_task)
+			!F2FS_I(inode)->cp_task && allow_balance)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -2942,7 +2943,7 @@ out:
 #endif
 
 	return f2fs_write_single_data_page(page, NULL, NULL, NULL,
-						wbc, FS_DATA_IO, 0);
+						wbc, FS_DATA_IO, 0, true);
 }
 
 /*
@@ -3110,7 +3111,8 @@ continue_unlock:
 			}
 #endif
 			ret = f2fs_write_single_data_page(page, &submitted,
-					&bio, &last_block, wbc, io_type, 0);
+					&bio, &last_block, wbc, io_type,
+					0, true);
 			if (ret == AOP_WRITEPAGE_ACTIVATE)
 				unlock_page(page);
 #ifdef CONFIG_F2FS_FS_COMPRESSION
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 06e5a6053f3f9..699815e94bd30 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3507,7 +3507,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 				struct bio **bio, sector_t *last_block,
 				struct writeback_control *wbc,
 				enum iostat_type io_type,
-				int compr_blocks);
+				int compr_blocks, bool allow_balance);
 void f2fs_invalidate_page(struct page *page, unsigned int offset,
 			unsigned int length);
 int f2fs_release_page(struct page *page, gfp_t wait);
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD0B328DA8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbhCATPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240447AbhCATK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:10:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F8456535E;
        Mon,  1 Mar 2021 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620754;
        bh=S+QW9hh9mJ37hBQuOdAPwSZ0vQfS3UapgfeipdWGbzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=is7OX0lX2RIbWH30nVxxCrWNH0tZmwbQJuQEn8DoY9JK3ypYuteTpyq0dkBo1ZLmO
         ftWxtZeAmQEF6Oj8QYWfZYCcllHOKJ8ReULHSoe4e3UcVsFxcJqYag5y9FJA2PCVVC
         U/lIY54OdrNo94I9a/81Rx1/aRIpUL4Z/Me868f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 237/775] f2fs: compress: fix potential deadlock
Date:   Mon,  1 Mar 2021 17:06:45 +0100
Message-Id: <20210301161213.341496022@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 4bcbacfe33259..7a774c9e4cb89 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1415,7 +1415,7 @@ retry_write:
 
 		ret = f2fs_write_single_data_page(cc->rpages[i], &_submitted,
 						NULL, NULL, wbc, io_type,
-						compr_blocks);
+						compr_blocks, false);
 		if (ret) {
 			if (ret == AOP_WRITEPAGE_ACTIVATE) {
 				unlock_page(cc->rpages[i]);
@@ -1450,6 +1450,9 @@ retry_write:
 
 		*submitted += _submitted;
 	}
+
+	f2fs_balance_fs(F2FS_M_SB(mapping), true);
+
 	return 0;
 out_err:
 	for (++i; i < cc->cluster_size; i++) {
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa34d620bec98..d72c99d9bd1f4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2743,7 +2743,8 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 				sector_t *last_block,
 				struct writeback_control *wbc,
 				enum iostat_type io_type,
-				int compr_blocks)
+				int compr_blocks,
+				bool allow_balance)
 {
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
@@ -2881,7 +2882,7 @@ out:
 	}
 	unlock_page(page);
 	if (!S_ISDIR(inode->i_mode) && !IS_NOQUOTA(inode) &&
-					!F2FS_I(inode)->cp_task)
+			!F2FS_I(inode)->cp_task && allow_balance)
 		f2fs_balance_fs(sbi, need_balance_fs);
 
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -2928,7 +2929,7 @@ out:
 #endif
 
 	return f2fs_write_single_data_page(page, NULL, NULL, NULL,
-						wbc, FS_DATA_IO, 0);
+						wbc, FS_DATA_IO, 0, true);
 }
 
 /*
@@ -3096,7 +3097,8 @@ continue_unlock:
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
index bb11759191dcc..1578402c58444 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3469,7 +3469,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
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




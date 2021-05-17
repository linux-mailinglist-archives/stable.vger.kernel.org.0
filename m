Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE5D3837D6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244545AbhEQPrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344711AbhEQPpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE2861D2A;
        Mon, 17 May 2021 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262622;
        bh=A3aj7XsdKFjdT5a1NUfr0FrUX38Ab4ZfX67qPR7dwI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nu0EtrHL1bAcT08wVMslUFjxLzqn1qx90cdlka2Ahil0yVQsoZAf8oQP87D9Et4rb
         FDRwmz9F5ObfZmFXBLp3nScL/A6z5JZPbVdopOoFO35PXGYJToV0+k+65rsiGcx/Qk
         w8c/zh2hePlNIO1vGCBxTI8YQWEX3MuSuIGbaEs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/289] f2fs: compress: fix race condition of overwrite vs truncate
Date:   Mon, 17 May 2021 16:02:40 +0200
Message-Id: <20210517140313.087306799@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a949dc5f2c5cfe0c910b664650f45371254c0744 ]

pos_fsstress testcase complains a panic as belew:

------------[ cut here ]------------
kernel BUG at fs/f2fs/compress.c:1082!
invalid opcode: 0000 [#1] SMP PTI
CPU: 4 PID: 2753477 Comm: kworker/u16:2 Tainted: G           OE     5.12.0-rc1-custom #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Workqueue: writeback wb_workfn (flush-252:16)
RIP: 0010:prepare_compress_overwrite+0x4c0/0x760 [f2fs]
Call Trace:
 f2fs_prepare_compress_overwrite+0x5f/0x80 [f2fs]
 f2fs_write_cache_pages+0x468/0x8a0 [f2fs]
 f2fs_write_data_pages+0x2a4/0x2f0 [f2fs]
 do_writepages+0x38/0xc0
 __writeback_single_inode+0x44/0x2a0
 writeback_sb_inodes+0x223/0x4d0
 __writeback_inodes_wb+0x56/0xf0
 wb_writeback+0x1dd/0x290
 wb_workfn+0x309/0x500
 process_one_work+0x220/0x3c0
 worker_thread+0x53/0x420
 kthread+0x12f/0x150
 ret_from_fork+0x22/0x30

The root cause is truncate() may race with overwrite as below,
so that one reference count left in page can not guarantee the
page attaching in mapping tree all the time, after truncation,
later find_lock_page() may return NULL pointer.

- prepare_compress_overwrite
 - f2fs_pagecache_get_page
 - unlock_page
					- f2fs_setattr
					 - truncate_setsize
					  - truncate_inode_page
					   - delete_from_page_cache
 - find_lock_page

Fix this by avoiding referencing updated page.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index b6b7b1552769..58eb5eefe268 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -123,19 +123,6 @@ static void f2fs_unlock_rpages(struct compress_ctx *cc, int len)
 	f2fs_drop_rpages(cc, len, true);
 }
 
-static void f2fs_put_rpages_mapping(struct address_space *mapping,
-				pgoff_t start, int len)
-{
-	int i;
-
-	for (i = 0; i < len; i++) {
-		struct page *page = find_get_page(mapping, start + i);
-
-		put_page(page);
-		put_page(page);
-	}
-}
-
 static void f2fs_put_rpages_wbc(struct compress_ctx *cc,
 		struct writeback_control *wbc, bool redirty, int unlock)
 {
@@ -986,7 +973,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 		}
 
 		if (PageUptodate(page))
-			unlock_page(page);
+			f2fs_put_page(page, 1);
 		else
 			f2fs_compress_ctx_add_page(cc, page);
 	}
@@ -996,32 +983,34 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 
 		ret = f2fs_read_multi_pages(cc, &bio, cc->cluster_size,
 					&last_block_in_bio, false, true);
+		f2fs_put_rpages(cc);
 		f2fs_destroy_compress_ctx(cc);
 		if (ret)
-			goto release_pages;
+			goto out;
 		if (bio)
 			f2fs_submit_bio(sbi, bio, DATA);
 
 		ret = f2fs_init_compress_ctx(cc);
 		if (ret)
-			goto release_pages;
+			goto out;
 	}
 
 	for (i = 0; i < cc->cluster_size; i++) {
 		f2fs_bug_on(sbi, cc->rpages[i]);
 
 		page = find_lock_page(mapping, start_idx + i);
-		f2fs_bug_on(sbi, !page);
+		if (!page) {
+			/* page can be truncated */
+			goto release_and_retry;
+		}
 
 		f2fs_wait_on_page_writeback(page, DATA, true, true);
-
 		f2fs_compress_ctx_add_page(cc, page);
-		f2fs_put_page(page, 0);
 
 		if (!PageUptodate(page)) {
+release_and_retry:
+			f2fs_put_rpages(cc);
 			f2fs_unlock_rpages(cc, i + 1);
-			f2fs_put_rpages_mapping(mapping, start_idx,
-					cc->cluster_size);
 			f2fs_destroy_compress_ctx(cc);
 			goto retry;
 		}
@@ -1053,10 +1042,10 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 	}
 
 unlock_pages:
+	f2fs_put_rpages(cc);
 	f2fs_unlock_rpages(cc, i);
-release_pages:
-	f2fs_put_rpages_mapping(mapping, start_idx, i);
 	f2fs_destroy_compress_ctx(cc);
+out:
 	return ret;
 }
 
-- 
2.30.2




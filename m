Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2E7499182
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348633AbiAXUL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:11:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33840 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378402AbiAXUG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:06:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72BF160B89;
        Mon, 24 Jan 2022 20:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DBDC340E5;
        Mon, 24 Jan 2022 20:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054818;
        bh=aaHOJV8MOIdHgFB4aY/Fq/gj7JNcclxTGHGizhQJaHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MT49/35v/9MTMlXxTHpMCf3p2eMs8hOBCKvVQg7Bz4hs/474l/nsD31NpsSyTE/bK
         2ZILgOFCA/fc9X41wkxROwVYqdny/bRcR2H2u9GHlLE0pl9KUISG71CCG55gk9gUoA
         syvuzX2N2riSb5WlxVmdtAfqWFC51t+jJNVLglCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeong-Jun Kim <hj514.kim@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Youngjin Gil <youngjin.gil@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 514/563] f2fs: compress: fix potential deadlock of compress file
Date:   Mon, 24 Jan 2022 19:44:39 +0100
Message-Id: <20220124184042.229711221@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeong-Jun Kim <hj514.kim@samsung.com>

commit 7377e853967ba45bf409e3b5536624d2cbc99f21 upstream.

There is a potential deadlock between writeback process and a process
performing write_begin() or write_cache_pages() while trying to write
same compress file, but not compressable, as below:

[Process A] - doing checkpoint
[Process B]                     [Process C]
f2fs_write_cache_pages()
- lock_page() [all pages in cluster, 0-31]
- f2fs_write_multi_pages()
 - f2fs_write_raw_pages()
  - f2fs_write_single_data_page()
   - f2fs_do_write_data_page()
     - return -EAGAIN [f2fs_trylock_op() failed]
   - unlock_page(page) [e.g., page 0]
                                - generic_perform_write()
                                 - f2fs_write_begin()
                                  - f2fs_prepare_compress_overwrite()
                                   - prepare_compress_overwrite()
                                    - lock_page() [e.g., page 0]
                                    - lock_page() [e.g., page 1]
   - lock_page(page) [e.g., page 0]

Since there is no compress process, it is no longer necessary to hold
locks on every pages in cluster within f2fs_write_raw_pages().

This patch changes f2fs_write_raw_pages() to release all locks first
and then perform write same as the non-compress file in
f2fs_write_cache_pages().

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Hyeong-Jun Kim <hj514.kim@samsung.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |   50 ++++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1362,25 +1362,38 @@ static int f2fs_write_raw_pages(struct c
 					enum iostat_type io_type)
 {
 	struct address_space *mapping = cc->inode->i_mapping;
-	int _submitted, compr_blocks, ret;
-	int i = -1, err = 0;
+	int _submitted, compr_blocks, ret, i;
 
 	compr_blocks = f2fs_compressed_blocks(cc);
-	if (compr_blocks < 0) {
-		err = compr_blocks;
-		goto out_err;
+
+	for (i = 0; i < cc->cluster_size; i++) {
+		if (!cc->rpages[i])
+			continue;
+
+		redirty_page_for_writepage(wbc, cc->rpages[i]);
+		unlock_page(cc->rpages[i]);
 	}
 
+	if (compr_blocks < 0)
+		return compr_blocks;
+
 	for (i = 0; i < cc->cluster_size; i++) {
 		if (!cc->rpages[i])
 			continue;
 retry_write:
+		lock_page(cc->rpages[i]);
+
 		if (cc->rpages[i]->mapping != mapping) {
+continue_unlock:
 			unlock_page(cc->rpages[i]);
 			continue;
 		}
 
-		BUG_ON(!PageLocked(cc->rpages[i]));
+		if (!PageDirty(cc->rpages[i]))
+			goto continue_unlock;
+
+		if (!clear_page_dirty_for_io(cc->rpages[i]))
+			goto continue_unlock;
 
 		ret = f2fs_write_single_data_page(cc->rpages[i], &_submitted,
 						NULL, NULL, wbc, io_type,
@@ -1395,26 +1408,15 @@ retry_write:
 				 * avoid deadlock caused by cluster update race
 				 * from foreground operation.
 				 */
-				if (IS_NOQUOTA(cc->inode)) {
-					err = 0;
-					goto out_err;
-				}
+				if (IS_NOQUOTA(cc->inode))
+					return 0;
 				ret = 0;
 				cond_resched();
 				congestion_wait(BLK_RW_ASYNC,
 						DEFAULT_IO_TIMEOUT);
-				lock_page(cc->rpages[i]);
-
-				if (!PageDirty(cc->rpages[i])) {
-					unlock_page(cc->rpages[i]);
-					continue;
-				}
-
-				clear_page_dirty_for_io(cc->rpages[i]);
 				goto retry_write;
 			}
-			err = ret;
-			goto out_err;
+			return ret;
 		}
 
 		*submitted += _submitted;
@@ -1423,14 +1425,6 @@ retry_write:
 	f2fs_balance_fs(F2FS_M_SB(mapping), true);
 
 	return 0;
-out_err:
-	for (++i; i < cc->cluster_size; i++) {
-		if (!cc->rpages[i])
-			continue;
-		redirty_page_for_writepage(wbc, cc->rpages[i]);
-		unlock_page(cc->rpages[i]);
-	}
-	return err;
 }
 
 int f2fs_write_multi_pages(struct compress_ctx *cc,



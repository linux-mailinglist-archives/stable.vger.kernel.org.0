Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C6F496E93
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiAWANM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:13:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40998 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiAWAMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A885CB80924;
        Sun, 23 Jan 2022 00:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B438DC340E2;
        Sun, 23 Jan 2022 00:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896741;
        bh=GIY153ZvKfvQuNYDLicwOPgKn62OaYHA8oRdOYRdUUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ti84i3EIJkIDYG3JvtqH8z3NcvEtfetsyv5X+84jwnXn0NldfhP5FIOxZLpwnZKvI
         SWXzCQv81eAiCUks8bNR3Nu9pMHJZniHndBg0NkdadF6DvJXHcZHlQQl0xigiuGAV1
         qx3lPX6bdplKK+tVl6twX4F7OwHFV9uz5HbuuxpGRo4YZr1JsLKQtI4c/DMTFFWHjP
         VjgKBwp5blYPagHolQjIeu829LByy8oLKefu+KSaMf8H6gAthLvn53H4SmFDfTxwxz
         3394SlS77RoW/F7fxCni06AWZ0n0T+zA591ZKtBjBzimCJoaMH59OjbxkTxS9bc+s6
         04bNGHbphDhfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 03/16] f2fs: don't drop compressed page cache in .{invalidate,release}page
Date:   Sat, 22 Jan 2022 19:12:02 -0500
Message-Id: <20220123001216.2460383-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2a64e303e3051550c75897239174e399dfcb8b7e ]

For compressed inode, in .{invalidate,release}page, we will call
f2fs_invalidate_compress_pages() to drop all compressed page cache of
current inode.

But we don't need to drop compressed page cache synchronously in
.invalidatepage, because, all trancation paths of compressed physical
block has been covered with f2fs_invalidate_compress_page().

And also we don't need to drop compressed page cache synchronously
in .releasepage, because, if there is out-of-memory, we can count
on page cache reclaim on sbi->compress_inode.

BTW, this patch may fix the issue reported below:

https://lore.kernel.org/linux-f2fs-devel/20211202092812.197647-1-changfengnan@vivo.com/T/#u

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index f4fd6c246c9a9..ae50bdf19afc5 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3717,12 +3717,9 @@ void f2fs_invalidate_page(struct page *page, unsigned int offset,
 
 	clear_page_private_gcing(page);
 
-	if (test_opt(sbi, COMPRESS_CACHE)) {
-		if (f2fs_compressed_file(inode))
-			f2fs_invalidate_compress_pages(sbi, inode->i_ino);
-		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
-			clear_page_private_data(page);
-	}
+	if (test_opt(sbi, COMPRESS_CACHE) &&
+			inode->i_ino == F2FS_COMPRESS_INO(sbi))
+		clear_page_private_data(page);
 
 	if (page_private_atomic(page))
 		return f2fs_drop_inmem_page(inode, page);
@@ -3742,12 +3739,9 @@ int f2fs_release_page(struct page *page, gfp_t wait)
 		return 0;
 
 	if (test_opt(F2FS_P_SB(page), COMPRESS_CACHE)) {
-		struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 		struct inode *inode = page->mapping->host;
 
-		if (f2fs_compressed_file(inode))
-			f2fs_invalidate_compress_pages(sbi, inode->i_ino);
-		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
+		if (inode->i_ino == F2FS_COMPRESS_INO(F2FS_I_SB(inode)))
 			clear_page_private_data(page);
 	}
 
-- 
2.34.1


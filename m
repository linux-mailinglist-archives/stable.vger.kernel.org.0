Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E76496E59
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiAWALc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:11:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35560 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235117AbiAWALa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:11:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB4160DCB;
        Sun, 23 Jan 2022 00:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68139C340E2;
        Sun, 23 Jan 2022 00:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896689;
        bh=BrDSlStalQdzU+ebZKUiYrJ4gnOOGfjJ74pdXELcfhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knxN9uTBTWJvUvYlSyTwpXBH2k9XC3lfzdh35ihT1oW2A74o7/w8xGiGkDqpchXtr
         6tThhkWYGnXj2N4myk5Bj3+N3xa1r+FhpLmEO4bOaUCFJEITQh8DXBRtddZzdV/xhj
         O9EwT8gKlSZ8D4dFoPQL3FxprYTXIua2VdpM1S0XUVr7m/H31lWRBLlAtOvzGBq2r6
         qrqeorGFgNrL3D4w9/+IqfEPDuyvPwDCTS/k+mOuRx/nrijiFiJY6oaQGFlRmxX48s
         l1Vqk5F4bDrKrod8qa0dAY59Q1Fsq3dZ+0hjtO/eeY3vzUCVIjUrRRbYqdWWazY55T
         FKi5CBg4Y19NQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.16 03/19] f2fs: don't drop compressed page cache in .{invalidate,release}page
Date:   Sat, 22 Jan 2022 19:10:56 -0500
Message-Id: <20220123001113.2460140-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
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
index 9f754aaef558b..7ee105eb6940a 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3770,12 +3770,9 @@ void f2fs_invalidate_page(struct page *page, unsigned int offset,
 
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
@@ -3795,12 +3792,9 @@ int f2fs_release_page(struct page *page, gfp_t wait)
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


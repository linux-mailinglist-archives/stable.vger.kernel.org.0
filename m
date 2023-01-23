Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD7C67755F
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 08:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjAWHFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 02:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAWHFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 02:05:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF59815559
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 23:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65900B80BA9
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 07:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCDCC433D2;
        Mon, 23 Jan 2023 07:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674457530;
        bh=ik4H9BFLeehEHUHENH+ekDYEnVxW9h+jwxQCqF3Y5xY=;
        h=From:To:Cc:Subject:Date:From;
        b=MZ4astp6imdsZFowVuLbr8SZ1zd1Yt9BpGMpmoxlPvlwh5O4jGIq3bOzjwtjoWIzx
         FUt1Se5EXKRHXG6Av7ikOj9hSrxmRbm1RbwdGXwib/juxFioM874exSgWYzMRQJ12y
         YdofX93HEgl4qakrjaRZGeLks0UVHk4U005M2CgQrxcZeWqVz7cuASjTgE6etItJRa
         l5idirs5+QRmC9Zp9A3w0LQnokNJZkJ3sz4WFcius9s+hKpKEnMb3sSl0l5RpZ64f6
         ptVifMQzNPzflOTyCnUsM6UOeX0s/5Xp9BXk9Okr20jJ8qZOLksH17CM7aGmD8Q57L
         uEPH72hZpvwoQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     Alexander Potapenko <glider@google.com>, stable@vger.kernel.org
Subject: [PATCH] f2fs: fix information leak in f2fs_move_inline_dirents()
Date:   Sun, 22 Jan 2023 23:04:14 -0800
Message-Id: <20230123070414.138052-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When converting an inline directory to a regular one, f2fs is leaking
uninitialized memory to disk because it doesn't initialize the entire
directory block.  Fix this by zero-initializing the block.

This bug was introduced by commit 4ec17d688d74 ("f2fs: avoid unneeded
initializing when converting inline dentry"), which didn't consider the
security implications of leaking uninitialized memory to disk.

This was found by running xfstest generic/435 on a KMSAN-enabled kernel.

Fixes: 4ec17d688d74 ("f2fs: avoid unneeded initializing when converting inline dentry")
Cc: <stable@vger.kernel.org> # v4.3+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/inline.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 08e302d32118d..72269e7efd260 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -421,18 +421,17 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 
 	dentry_blk = page_address(page);
 
+	/*
+	 * Start by zeroing the full block, to ensure that all unused space is
+	 * zeroed and no uninitialized memory is leaked to disk.
+	 */
+	memset(dentry_blk, 0, F2FS_BLKSIZE);
+
 	make_dentry_ptr_inline(dir, &src, inline_dentry);
 	make_dentry_ptr_block(dir, &dst, dentry_blk);
 
 	/* copy data from inline dentry block to new dentry block */
 	memcpy(dst.bitmap, src.bitmap, src.nr_bitmap);
-	memset(dst.bitmap + src.nr_bitmap, 0, dst.nr_bitmap - src.nr_bitmap);
-	/*
-	 * we do not need to zero out remainder part of dentry and filename
-	 * field, since we have used bitmap for marking the usage status of
-	 * them, besides, we can also ignore copying/zeroing reserved space
-	 * of dentry block, because them haven't been used so far.
-	 */
 	memcpy(dst.dentry, src.dentry, SIZE_OF_DIR_ENTRY * src.max);
 	memcpy(dst.filename, src.filename, src.max * F2FS_SLOT_LEN);
 

base-commit: 7a2b15cfa8dbbd54beb4e2ce7b2f42eb0ad00425
-- 
2.39.1


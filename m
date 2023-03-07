Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F386AF1AD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbjCGSq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjCGSpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:45:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6A6B95D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5497BB819BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C9AC433D2;
        Tue,  7 Mar 2023 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214034;
        bh=a/kFXoq5FFwyZxffgqmGvSqcyjnYnHAmNQk2zFqw274=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6/NYI6AtkFmsRFWfH15ySU2QObdyC1CigDPZ5Kaw2hFimnEhE1WqEtulNUf8c/JV
         XZoVCFW9hbF1Vu4avpkg0TDJ1nTzVjaYjEuK5PYvIxesOQv1VyH8pe71NNXJyYMUk5
         iXdvp3sb7N+6BjEZwrYGxQEW6wHg7nKPd+MPHWLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 698/885] f2fs: fix information leak in f2fs_move_inline_dirents()
Date:   Tue,  7 Mar 2023 18:00:32 +0100
Message-Id: <20230307170032.417888621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 9a5571cff4ffcfc24847df9fd545cc5799ac0ee5 upstream.

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
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inline.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -422,18 +422,17 @@ static int f2fs_move_inline_dirents(stru
 
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
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A1D54FFF5
	for <lists+stable@lfdr.de>; Sat, 18 Jun 2022 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiFQWbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 18:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiFQWbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 18:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3352C62125;
        Fri, 17 Jun 2022 15:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3374B82B1E;
        Fri, 17 Jun 2022 22:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB69C3411B;
        Fri, 17 Jun 2022 22:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655505080;
        bh=Jp4eIONtSs6CWILka62alidYJLIpx9VDEl4Ouzu1iBE=;
        h=From:To:Cc:Subject:Date:From;
        b=cfe2aC3SsNv0taX/O9yxiekxXZfxv7Xte5M7lNEsPf9x0mhp1IskXj9gxyIHxJQeM
         SMXqmYDl6hCotPpO7UIzpuF5kXqA/b561wOipbmHC6YV1wYklHKqHaZmmi1HGGnajd
         Mxhthm91pBBjLjNK2knc9Royz6jSdAjxwpTtwQFWE8UYt9hnGD5e6IcSn6qIx+aRyi
         qMvIReINpOQ++H5QLWm4pDap7NU8sZiiBCagoXMnDWeFOrH1lg5c0lkj1pIlEnWWm+
         OaYHWWY6rsZRtmxOZLoDYNkTvhR10qy1yj/rBNEsN+Rn248lpISKV7bKA6ND7yPRla
         3uIeLQYhieXBg==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] f2fs: attach inline_data after setting compression
Date:   Fri, 17 Jun 2022 15:31:04 -0700
Message-Id: <20220617223106.3517374-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fixes the below corruption.

[345393.335389] F2FS-fs (vdb): sanity_check_inode: inode (ino=6d0, mode=33206) should not have inline_data, run fsck to fix

Cc: <stable@vger.kernel.org>
Fixes: 677a82b44ebf ("f2fs: fix to do sanity check for inline inode")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/namei.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index c549acb52ac4..a841abe6a071 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -89,8 +89,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 	if (test_opt(sbi, INLINE_XATTR))
 		set_inode_flag(inode, FI_INLINE_XATTR);
 
-	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
-		set_inode_flag(inode, FI_INLINE_DATA);
 	if (f2fs_may_inline_dentry(inode))
 		set_inode_flag(inode, FI_INLINE_DENTRY);
 
@@ -107,10 +105,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 
 	f2fs_init_extent_tree(inode, NULL);
 
-	stat_inc_inline_xattr(inode);
-	stat_inc_inline_inode(inode);
-	stat_inc_inline_dir(inode);
-
 	F2FS_I(inode)->i_flags =
 		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
 
@@ -127,6 +121,14 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 			set_compress_context(inode);
 	}
 
+	/* Should enable inline_data after compression set */
+	if (test_opt(sbi, INLINE_DATA) && f2fs_may_inline_data(inode))
+		set_inode_flag(inode, FI_INLINE_DATA);
+
+	stat_inc_inline_xattr(inode);
+	stat_inc_inline_inode(inode);
+	stat_inc_inline_dir(inode);
+
 	f2fs_set_inode_flags(inode);
 
 	trace_f2fs_new_inode(inode, 0);
@@ -325,6 +327,8 @@ static void set_compress_inode(struct f2fs_sb_info *sbi, struct inode *inode,
 		if (!is_extension_exist(name, ext[i], false))
 			continue;
 
+		/* Do not use inline_data with compression */
+		clear_inode_flag(inode, FI_INLINE_DATA);
 		set_compress_context(inode);
 		return;
 	}
-- 
2.36.1.476.g0c4daa206d-goog


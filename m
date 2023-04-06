Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7F86DA1FD
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 21:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbjDFTvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 15:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDFTv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 15:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE829012;
        Thu,  6 Apr 2023 12:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B80A62CE1;
        Thu,  6 Apr 2023 19:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75E4C433EF;
        Thu,  6 Apr 2023 19:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810686;
        bh=/s7giKfeSIqZNbsqf9X75JHxU9L9jKT2SkAOoZXyTxQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WdcEZbDAhSV3qRTsIEn4xieYPuVjP7x/zfXStn2g84Ui9Hb+mQ2TKHHiNOXoII8e8
         Xo2Xl4XziPGlcqjZMkUvovCw1JnOFz8qvw/svxGiTFv2T/plKwUoQmnCCvlfDiBkss
         PhT4R54hIuXu98K8F1N5fMtLRufzm6YN5e1LksLgTHryki8HxeBE2oflAcHJna6Kea
         E0o48/Hs5A3jrw7YdkPKpFf1s6LRqOSKz5+yq3ego/ms6u+XPzNXn4ROo1crbD/jGz
         il6Aey9VwcJNQYnmctWT4R5E60KdNz+GODVw4W5LbqKSwai9TwKTdMdzNWxYQsu2um
         9mH5Gbtn0AsyA==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: fix potential corruption when moving a directory
Date:   Thu,  6 Apr 2023 12:51:22 -0700
Message-Id: <20230406195122.3917650-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

F2FS has the same issue in ext4_rename causing crash revealed by
xfstests/generic/707.

See also commit 0813299c586b ("ext4: Fix possible corruption when moving a directory")

CC: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/namei.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index ad597b417fea..77a71276ecb1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -995,12 +995,20 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 			goto out;
 	}
 
+	/*
+	 * Copied from ext4_rename: we need to protect against old.inode
+	 * directory getting converted from inline directory format into
+	 * a normal one.
+	 */
+	if (S_ISDIR(old_inode->i_mode))
+		inode_lock_nested(old_inode, I_MUTEX_NONDIR2);
+
 	err = -ENOENT;
 	old_entry = f2fs_find_entry(old_dir, &old_dentry->d_name, &old_page);
 	if (!old_entry) {
 		if (IS_ERR(old_page))
 			err = PTR_ERR(old_page);
-		goto out;
+		goto out_unlock_old;
 	}
 
 	if (S_ISDIR(old_inode->i_mode)) {
@@ -1108,6 +1116,9 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 
 	f2fs_unlock_op(sbi);
 
+	if (S_ISDIR(old_inode->i_mode))
+		inode_unlock(old_inode);
+
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		f2fs_sync_fs(sbi->sb, 1);
 
@@ -1122,6 +1133,9 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		f2fs_put_page(old_dir_page, 0);
 out_old:
 	f2fs_put_page(old_page, 0);
+out_unlock_old:
+	if (S_ISDIR(old_inode->i_mode))
+		inode_unlock(old_inode);
 out:
 	iput(whiteout);
 	return err;
-- 
2.40.0.577.gac1e443424-goog


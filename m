Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B303538006
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiE3Nxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiE3NwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEC711447;
        Mon, 30 May 2022 06:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0BF2B80D84;
        Mon, 30 May 2022 13:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56321C3411C;
        Mon, 30 May 2022 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917834;
        bh=jAZ7dqfEeDobrOdTI8ufggj5s7R4RsJZydxUTGMo1yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZevX4HLI+RXjfnQxXXyW4B2nkLrhZRnafmMJKyIdRzWTkhQjQUKLf5ggAwLzAAol
         ARW2lpCNbjHWHWitruNF4NltZh8AlilDX4qVIOfdw7xTRNGHBjbjIKHAKw3xO0dya3
         Ky03X3cNh76g+9DktLF+Do3EBQLUP7unKi+n7Nel23TQfCU9rLKizZGyr2IGkS0AEq
         ifk1YL0ii86u9RaISdXeH89T31hq6gbyaQ43JcfKkfUKC3fwo4VXmnhulWExtXHbsm
         4jGwwPVgB7dm25KbDmoJPkerkPGaw7L+i6L6KVCqsLC2gjxXKC7qkJvn0CkrplF/gk
         nnj1PYhZ3TcjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 110/135] btrfs: fix anon_dev leak in create_subvol()
Date:   Mon, 30 May 2022 09:31:08 -0400
Message-Id: <20220530133133.1931716-110-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 2256e901f5bddc56e24089c96f27b77da932dfcc ]

When btrfs_qgroup_inherit(), btrfs_alloc_tree_block, or
btrfs_insert_root() fail in create_subvol(), we return without freeing
anon_dev. Reorganize the error handling in create_subvol() to fix this.

Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 49 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8fe9d55d6862..072cdcab3061 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -544,7 +544,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	struct timespec64 cur_time = current_time(dir);
 	struct inode *inode;
 	int ret;
-	dev_t anon_dev = 0;
+	dev_t anon_dev;
 	u64 objectid;
 	u64 index = 0;
 
@@ -554,11 +554,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 
 	ret = btrfs_get_free_objectid(fs_info->tree_root, &objectid);
 	if (ret)
-		goto fail_free;
-
-	ret = get_anon_bdev(&anon_dev);
-	if (ret < 0)
-		goto fail_free;
+		goto out_root_item;
 
 	/*
 	 * Don't create subvolume whose level is not zero. Or qgroup will be
@@ -566,9 +562,13 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	 */
 	if (btrfs_qgroup_level(objectid)) {
 		ret = -ENOSPC;
-		goto fail_free;
+		goto out_root_item;
 	}
 
+	ret = get_anon_bdev(&anon_dev);
+	if (ret < 0)
+		goto out_root_item;
+
 	btrfs_init_block_rsv(&block_rsv, BTRFS_BLOCK_RSV_TEMP);
 	/*
 	 * The same as the snapshot creation, please see the comment
@@ -576,26 +576,26 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	 */
 	ret = btrfs_subvolume_reserve_metadata(root, &block_rsv, 8, false);
 	if (ret)
-		goto fail_free;
+		goto out_anon_dev;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		btrfs_subvolume_release_metadata(root, &block_rsv);
-		goto fail_free;
+		goto out_anon_dev;
 	}
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
 	ret = btrfs_qgroup_inherit(trans, 0, objectid, inherit);
 	if (ret)
-		goto fail;
+		goto out;
 
 	leaf = btrfs_alloc_tree_block(trans, root, 0, objectid, NULL, 0, 0, 0,
 				      BTRFS_NESTING_NORMAL);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
-		goto fail;
+		goto out;
 	}
 
 	btrfs_mark_buffer_dirty(leaf);
@@ -650,7 +650,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 		btrfs_tree_unlock(leaf);
 		btrfs_free_tree_block(trans, objectid, leaf, 0, 1);
 		free_extent_buffer(leaf);
-		goto fail;
+		goto out;
 	}
 
 	free_extent_buffer(leaf);
@@ -659,19 +659,18 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	key.offset = (u64)-1;
 	new_root = btrfs_get_new_fs_root(fs_info, objectid, anon_dev);
 	if (IS_ERR(new_root)) {
-		free_anon_bdev(anon_dev);
 		ret = PTR_ERR(new_root);
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
-	/* Freeing will be done in btrfs_put_root() of new_root */
+	/* anon_dev is owned by new_root now. */
 	anon_dev = 0;
 
 	ret = btrfs_record_root_in_trans(trans, new_root);
 	if (ret) {
 		btrfs_put_root(new_root);
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	ret = btrfs_create_subvol_root(trans, new_root, root, mnt_userns);
@@ -679,7 +678,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	if (ret) {
 		/* We potentially lose an unused inode item here */
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	/*
@@ -688,28 +687,28 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	ret = btrfs_set_inode_index(BTRFS_I(dir), &index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	ret = btrfs_insert_dir_item(trans, name, namelen, BTRFS_I(dir), &key,
 				    BTRFS_FT_DIR, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	btrfs_i_size_write(BTRFS_I(dir), dir->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, root, BTRFS_I(dir));
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	ret = btrfs_add_root_ref(trans, objectid, root->root_key.objectid,
 				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	ret = btrfs_uuid_tree_add(trans, root_item->uuid,
@@ -717,8 +716,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 
-fail:
-	kfree(root_item);
+out:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
 	btrfs_subvolume_release_metadata(root, &block_rsv);
@@ -734,11 +732,10 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 			return PTR_ERR(inode);
 		d_instantiate(dentry, inode);
 	}
-	return ret;
-
-fail_free:
+out_anon_dev:
 	if (anon_dev)
 		free_anon_bdev(anon_dev);
+out_root_item:
 	kfree(root_item);
 	return ret;
 }
-- 
2.35.1


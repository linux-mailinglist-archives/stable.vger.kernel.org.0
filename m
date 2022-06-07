Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADD2541894
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379893AbiFGVMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349467AbiFGVLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA372194CE;
        Tue,  7 Jun 2022 11:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C82361724;
        Tue,  7 Jun 2022 18:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AAEC36B00;
        Tue,  7 Jun 2022 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628033;
        bh=A3CivUUyS2UHd9YX6XuOP1Gz13QUVPcNKCp/bvnCo6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGlrZbV26dQ/cgfo9TCiqJ0qnwwQtFovdRHJ/quTQGBzkcqb2sXMs4Hpnm14CqmIo
         qfobOPyRikBnIwIL1FWDXfiM9+t+j12VNIei+m+eX8ooDWBa1JgrsgoVJUH7Hu2UDv
         9FRFGhIPs5+oZR1I8aV29xNuQfoDzMFyTmhah/ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 181/879] btrfs: fix anon_dev leak in create_subvol()
Date:   Tue,  7 Jun 2022 18:54:59 +0200
Message-Id: <20220607165008.093753515@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index be6c24577dbe..777801902511 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -561,7 +561,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	struct timespec64 cur_time = current_time(dir);
 	struct inode *inode;
 	int ret;
-	dev_t anon_dev = 0;
+	dev_t anon_dev;
 	u64 objectid;
 	u64 index = 0;
 
@@ -571,11 +571,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 
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
@@ -583,9 +579,13 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
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
@@ -593,26 +593,26 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
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
@@ -667,7 +667,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 		btrfs_tree_unlock(leaf);
 		btrfs_free_tree_block(trans, objectid, leaf, 0, 1);
 		free_extent_buffer(leaf);
-		goto fail;
+		goto out;
 	}
 
 	free_extent_buffer(leaf);
@@ -676,19 +676,18 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
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
@@ -696,7 +695,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	if (ret) {
 		/* We potentially lose an unused inode item here */
 		btrfs_abort_transaction(trans, ret);
-		goto fail;
+		goto out;
 	}
 
 	/*
@@ -705,28 +704,28 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
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
@@ -734,8 +733,7 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 
-fail:
-	kfree(root_item);
+out:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
 	btrfs_subvolume_release_metadata(root, &block_rsv);
@@ -751,11 +749,10 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B5C5AB1FA
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiIBNr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237910AbiIBNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E07520BF;
        Fri,  2 Sep 2022 06:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3968620E1;
        Fri,  2 Sep 2022 12:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7479C433D6;
        Fri,  2 Sep 2022 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121974;
        bh=y37tV+cJxWaQA+JUIIfyEgt8l2LZQV4TVUBgf/nD8ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXrVtanoTGSbQa5dn8o9lNf5Bf+UTNLmpupdjMa5MDOnp12cAfIBphu5apvbNKVYB
         q87FVhNFBtrRcVmN8lGqOLhhUKwaleYVtVkbjzcI4WWbzWAP7U/nrkMtarK4836oki
         7XKHd5r/nYnlFl4Ul4MAFt2Pa20vvRJEbhxZot4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/73] btrfs: remove root argument from btrfs_unlink_inode()
Date:   Fri,  2 Sep 2022 14:19:10 +0200
Message-Id: <20220902121405.985677826@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 4467af8809299c12529b5c21481c1d44a3b209f9 ]

The root argument passed to btrfs_unlink_inode() and its callee,
__btrfs_unlink_inode(), always matches the root of the given directory and
the given inode. So remove the argument and make __btrfs_unlink_inode()
use the root of the directory.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h    |  1 -
 fs/btrfs/inode.c    | 25 +++++++++++--------------
 fs/btrfs/tree-log.c | 14 +++++++-------
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1831135fef1ab..cd72570d11f65 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3166,7 +3166,6 @@ void __btrfs_del_delalloc_inode(struct btrfs_root *root,
 struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
 int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const char *name, int name_len);
 int btrfs_add_link(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 428a56f248bba..f8a01964a2169 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4097,11 +4097,11 @@ int btrfs_update_inode_fallback(struct btrfs_trans_handle *trans,
  * also drops the back refs in the inode to the directory
  */
 static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
 				struct btrfs_inode *dir,
 				struct btrfs_inode *inode,
 				const char *name, int name_len)
 {
+	struct btrfs_root *root = dir->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_path *path;
 	int ret = 0;
@@ -4201,15 +4201,14 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *root,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const char *name, int name_len)
 {
 	int ret;
-	ret = __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
+	ret = __btrfs_unlink_inode(trans, dir, inode, name, name_len);
 	if (!ret) {
 		drop_nlink(&inode->vfs_inode);
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, inode->root, inode);
 	}
 	return ret;
 }
@@ -4238,7 +4237,6 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir)
 
 static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_trans_handle *trans;
 	struct inode *inode = d_inode(dentry);
 	int ret;
@@ -4250,7 +4248,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
 			0);
 
-	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir),
 			BTRFS_I(d_inode(dentry)), dentry->d_name.name,
 			dentry->d_name.len);
 	if (ret)
@@ -4264,7 +4262,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 
 out:
 	btrfs_end_transaction(trans);
-	btrfs_btree_balance_dirty(root->fs_info);
+	btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
 	return ret;
 }
 
@@ -4622,7 +4620,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	int err = 0;
-	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_trans_handle *trans;
 	u64 last_unlink_trans;
 
@@ -4647,7 +4644,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	last_unlink_trans = BTRFS_I(inode)->last_unlink_trans;
 
 	/* now the directory is empty */
-	err = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+	err = btrfs_unlink_inode(trans, BTRFS_I(dir),
 			BTRFS_I(d_inode(dentry)), dentry->d_name.name,
 			dentry->d_name.len);
 	if (!err) {
@@ -4668,7 +4665,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	}
 out:
 	btrfs_end_transaction(trans);
-	btrfs_btree_balance_dirty(root->fs_info);
+	btrfs_btree_balance_dirty(BTRFS_I(dir)->root->fs_info);
 
 	return err;
 }
@@ -9571,7 +9568,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_unlink_subvol(trans, old_dir, old_dentry);
 	} else { /* src is an inode */
-		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
+		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					   BTRFS_I(old_dentry->d_inode),
 					   old_dentry->d_name.name,
 					   old_dentry->d_name.len);
@@ -9587,7 +9584,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 	} else { /* dest is an inode */
-		ret = __btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
+		ret = __btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 					   BTRFS_I(new_dentry->d_inode),
 					   new_dentry->d_name.name,
 					   new_dentry->d_name.len);
@@ -9862,7 +9859,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 		 */
 		btrfs_pin_log_trans(root);
 		log_pinned = true;
-		ret = __btrfs_unlink_inode(trans, root, BTRFS_I(old_dir),
+		ret = __btrfs_unlink_inode(trans, BTRFS_I(old_dir),
 					BTRFS_I(d_inode(old_dentry)),
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
@@ -9882,7 +9879,7 @@ static int btrfs_rename(struct user_namespace *mnt_userns,
 			ret = btrfs_unlink_subvol(trans, new_dir, new_dentry);
 			BUG_ON(new_inode->i_nlink == 0);
 		} else {
-			ret = btrfs_unlink_inode(trans, dest, BTRFS_I(new_dir),
+			ret = btrfs_unlink_inode(trans, BTRFS_I(new_dir),
 						 BTRFS_I(d_inode(new_dentry)),
 						 new_dentry->d_name.name,
 						 new_dentry->d_name.len);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d7e9812f55e1..6f51c4d922d48 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -926,7 +926,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_unlink_inode(trans, root, dir, BTRFS_I(inode), name,
+	ret = btrfs_unlink_inode(trans, dir, BTRFS_I(inode), name,
 			name_len);
 	if (ret)
 		goto out;
@@ -1091,7 +1091,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				inc_nlink(&inode->vfs_inode);
 				btrfs_release_path(path);
 
-				ret = btrfs_unlink_inode(trans, root, dir, inode,
+				ret = btrfs_unlink_inode(trans, dir, inode,
 						victim_name, victim_name_len);
 				kfree(victim_name);
 				if (ret)
@@ -1165,7 +1165,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					inc_nlink(&inode->vfs_inode);
 					btrfs_release_path(path);
 
-					ret = btrfs_unlink_inode(trans, root,
+					ret = btrfs_unlink_inode(trans,
 							BTRFS_I(victim_parent),
 							inode,
 							victim_name,
@@ -1327,7 +1327,7 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
 				kfree(name);
 				goto out;
 			}
-			ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+			ret = btrfs_unlink_inode(trans, BTRFS_I(dir),
 						 inode, name, namelen);
 			kfree(name);
 			iput(dir);
@@ -1434,7 +1434,7 @@ static int add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		ret = -ENOENT;
 		goto out;
 	}
-	ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir), BTRFS_I(other_inode),
+	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(other_inode),
 				 name, namelen);
 	if (ret)
 		goto out;
@@ -1580,7 +1580,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			ret = btrfs_inode_ref_exists(inode, dir, key->type,
 						     name, namelen);
 			if (ret > 0) {
-				ret = btrfs_unlink_inode(trans, root,
+				ret = btrfs_unlink_inode(trans,
 							 BTRFS_I(dir),
 							 BTRFS_I(inode),
 							 name, namelen);
@@ -2339,7 +2339,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 			}
 
 			inc_nlink(inode);
-			ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
+			ret = btrfs_unlink_inode(trans, BTRFS_I(dir),
 					BTRFS_I(inode), name, name_len);
 			if (!ret)
 				ret = btrfs_run_delayed_items(trans);
-- 
2.35.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87795AB1FC
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbiIBNr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbiIBNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:47:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DE11314DA;
        Fri,  2 Sep 2022 06:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42ECB621DC;
        Fri,  2 Sep 2022 12:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBE4C4314B;
        Fri,  2 Sep 2022 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121980;
        bh=OPFqOeplPxjLpT7FNeHNIjL3xnGd6cc0XPttc6ZELYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ErwuQNIGFoUwh1+WuaOnApFtRsmikA58wFvyEFF3uy1WRoE9VjKO4UoLYCZFkNPB
         K6Npc70rn38hAgnLbjMq1GcRtO5oRdiIHHUyg7V0pxtjWsR4IS8XtWy6b59ZXfhtMc
         ATFCoQgysLg33+KXQk9V1upOobUnIkJQbS+h1T0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/73] btrfs: add and use helper for unlinking inode during log replay
Date:   Fri,  2 Sep 2022 14:19:12 +0200
Message-Id: <20220902121406.040599652@linuxfoundation.org>
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

[ Upstream commit 313ab75399d0c7d0ebc718c545572c1b4d8d22ef ]

During log replay there is this pattern of running delayed items after
every inode unlink. To avoid repeating this several times, move the
logic into an helper function and use it instead of calling
btrfs_unlink_inode() followed by btrfs_run_delayed_items().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 77 +++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4ab1bbc344760..c56a89d224bbb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -884,6 +884,26 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int unlink_inode_for_log_replay(struct btrfs_trans_handle *trans,
+				       struct btrfs_inode *dir,
+				       struct btrfs_inode *inode,
+				       const char *name,
+				       int name_len)
+{
+	int ret;
+
+	ret = btrfs_unlink_inode(trans, dir, inode, name, name_len);
+	if (ret)
+		return ret;
+	/*
+	 * Whenever we need to check if a name exists or not, we check the
+	 * fs/subvolume tree. So after an unlink we must run delayed items, so
+	 * that future checks for a name during log replay see that the name
+	 * does not exists anymore.
+	 */
+	return btrfs_run_delayed_items(trans);
+}
+
 /*
  * when cleaning up conflicts between the directory names in the
  * subvolume, directory names in the log and directory names in the
@@ -926,12 +946,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_unlink_inode(trans, dir, BTRFS_I(inode), name,
+	ret = unlink_inode_for_log_replay(trans, dir, BTRFS_I(inode), name,
 			name_len);
-	if (ret)
-		goto out;
-	else
-		ret = btrfs_run_delayed_items(trans);
 out:
 	kfree(name);
 	iput(inode);
@@ -1091,12 +1107,9 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				inc_nlink(&inode->vfs_inode);
 				btrfs_release_path(path);
 
-				ret = btrfs_unlink_inode(trans, dir, inode,
+				ret = unlink_inode_for_log_replay(trans, dir, inode,
 						victim_name, victim_name_len);
 				kfree(victim_name);
-				if (ret)
-					return ret;
-				ret = btrfs_run_delayed_items(trans);
 				if (ret)
 					return ret;
 				*search_done = 1;
@@ -1165,14 +1178,11 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 					inc_nlink(&inode->vfs_inode);
 					btrfs_release_path(path);
 
-					ret = btrfs_unlink_inode(trans,
+					ret = unlink_inode_for_log_replay(trans,
 							BTRFS_I(victim_parent),
 							inode,
 							victim_name,
 							victim_name_len);
-					if (!ret)
-						ret = btrfs_run_delayed_items(
-								  trans);
 				}
 				iput(victim_parent);
 				kfree(victim_name);
@@ -1327,19 +1337,10 @@ static int unlink_old_inode_refs(struct btrfs_trans_handle *trans,
 				kfree(name);
 				goto out;
 			}
-			ret = btrfs_unlink_inode(trans, BTRFS_I(dir),
+			ret = unlink_inode_for_log_replay(trans, BTRFS_I(dir),
 						 inode, name, namelen);
 			kfree(name);
 			iput(dir);
-			/*
-			 * Whenever we need to check if a name exists or not, we
-			 * check the subvolume tree. So after an unlink we must
-			 * run delayed items, so that future checks for a name
-			 * during log replay see that the name does not exists
-			 * anymore.
-			 */
-			if (!ret)
-				ret = btrfs_run_delayed_items(trans);
 			if (ret)
 				goto out;
 			goto again;
@@ -1434,8 +1435,8 @@ static int add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		ret = -ENOENT;
 		goto out;
 	}
-	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(other_inode),
-				 name, namelen);
+	ret = unlink_inode_for_log_replay(trans, BTRFS_I(dir), BTRFS_I(other_inode),
+					  name, namelen);
 	if (ret)
 		goto out;
 	/*
@@ -1444,10 +1445,6 @@ static int add_link(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	 */
 	if (other_inode->i_nlink == 0)
 		inc_nlink(other_inode);
-
-	ret = btrfs_run_delayed_items(trans);
-	if (ret)
-		goto out;
 add_link:
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
 			     name, namelen, 0, ref_index);
@@ -1580,7 +1577,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			ret = btrfs_inode_ref_exists(inode, dir, key->type,
 						     name, namelen);
 			if (ret > 0) {
-				ret = btrfs_unlink_inode(trans,
+				ret = unlink_inode_for_log_replay(trans,
 							 BTRFS_I(dir),
 							 BTRFS_I(inode),
 							 name, namelen);
@@ -1591,15 +1588,6 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 				 */
 				if (!ret && inode->i_nlink == 0)
 					inc_nlink(inode);
-				/*
-				 * Whenever we need to check if a name exists or
-				 * not, we check the subvolume tree. So after an
-				 * unlink we must run delayed items, so that future
-				 * checks for a name during log replay see that the
-				 * name does not exists anymore.
-				 */
-				if (!ret)
-					ret = btrfs_run_delayed_items(trans);
 			}
 			if (ret < 0)
 				goto out;
@@ -2339,15 +2327,8 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 		goto out;
 
 	inc_nlink(inode);
-	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(inode), name,
-				 name_len);
-	if (ret)
-		goto out;
-
-	ret = btrfs_run_delayed_items(trans);
-	if (ret)
-		goto out;
-
+	ret = unlink_inode_for_log_replay(trans, BTRFS_I(dir), BTRFS_I(inode),
+					  name, name_len);
 	/*
 	 * Unlike dir item keys, dir index keys can only have one name (entry) in
 	 * them, as there are no key collisions since each key has a unique offset
-- 
2.35.1




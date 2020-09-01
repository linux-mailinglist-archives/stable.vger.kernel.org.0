Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4282725990F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgIAQgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730549AbgIAP3n (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:29:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9DD206C0;
        Tue,  1 Sep 2020 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974182;
        bh=dGGmsSgV6M2q3nLgYYLdCHhSTJycpB/dZrb2O4mga+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcOfdTCZA3oP5NxU5zzzpPVLPnGYdq15QFEjCHeW5tqNcXPN+WYlYhJU8VLVlfTTI
         T5uZXOUoveY/QkQK4xzOtj6UsbtLlVbfwHxAljmf/+CPMXTNXjyuJbSKqxqEdqltnJ
         j0avwUS/oIaG+uil1Q6Bj7gQH7yG8IZRoitu0pqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/214] btrfs: factor out inode items copy loop from btrfs_log_inode()
Date:   Tue,  1 Sep 2020 17:09:17 +0200
Message-Id: <20200901150956.666592982@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit da447009a25609327309f695b244710f12794471 ]

The function btrfs_log_inode() is quite large and so is its loop which
iterates the inode items from the fs/subvolume tree and copies them into
a log tree. Because this is a large loop inside a very large function
and because an upcoming patch in this series needs to add some more logic
inside that loop, move the loop into a helper function to make it a bit
more manageable.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 274 ++++++++++++++++++++++----------------------
 1 file changed, 138 insertions(+), 136 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3c090549ed07d..cc407c68d356f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4994,6 +4994,138 @@ static int log_conflicting_inodes(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int copy_inode_items_to_log(struct btrfs_trans_handle *trans,
+				   struct btrfs_inode *inode,
+				   struct btrfs_key *min_key,
+				   const struct btrfs_key *max_key,
+				   struct btrfs_path *path,
+				   struct btrfs_path *dst_path,
+				   const u64 logged_isize,
+				   const bool recursive_logging,
+				   const int inode_only,
+				   struct btrfs_log_ctx *ctx,
+				   bool *need_log_inode_item)
+{
+	struct btrfs_root *root = inode->root;
+	int ins_start_slot = 0;
+	int ins_nr = 0;
+	int ret;
+
+	while (1) {
+		ret = btrfs_search_forward(root, min_key, path, trans->transid);
+		if (ret < 0)
+			return ret;
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+again:
+		/* Note, ins_nr might be > 0 here, cleanup outside the loop */
+		if (min_key->objectid != max_key->objectid)
+			break;
+		if (min_key->type > max_key->type)
+			break;
+
+		if (min_key->type == BTRFS_INODE_ITEM_KEY)
+			*need_log_inode_item = false;
+
+		if ((min_key->type == BTRFS_INODE_REF_KEY ||
+		     min_key->type == BTRFS_INODE_EXTREF_KEY) &&
+		    inode->generation == trans->transid &&
+		    !recursive_logging) {
+			u64 other_ino = 0;
+			u64 other_parent = 0;
+
+			ret = btrfs_check_ref_name_override(path->nodes[0],
+					path->slots[0], min_key, inode,
+					&other_ino, &other_parent);
+			if (ret < 0) {
+				return ret;
+			} else if (ret > 0 && ctx &&
+				   other_ino != btrfs_ino(BTRFS_I(ctx->inode))) {
+				if (ins_nr > 0) {
+					ins_nr++;
+				} else {
+					ins_nr = 1;
+					ins_start_slot = path->slots[0];
+				}
+				ret = copy_items(trans, inode, dst_path, path,
+						 ins_start_slot, ins_nr,
+						 inode_only, logged_isize);
+				if (ret < 0)
+					return ret;
+				ins_nr = 0;
+
+				ret = log_conflicting_inodes(trans, root, path,
+						ctx, other_ino, other_parent);
+				if (ret)
+					return ret;
+				btrfs_release_path(path);
+				goto next_key;
+			}
+		}
+
+		/* Skip xattrs, we log them later with btrfs_log_all_xattrs() */
+		if (min_key->type == BTRFS_XATTR_ITEM_KEY) {
+			if (ins_nr == 0)
+				goto next_slot;
+			ret = copy_items(trans, inode, dst_path, path,
+					 ins_start_slot,
+					 ins_nr, inode_only, logged_isize);
+			if (ret < 0)
+				return ret;
+			ins_nr = 0;
+			goto next_slot;
+		}
+
+		if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
+			ins_nr++;
+			goto next_slot;
+		} else if (!ins_nr) {
+			ins_start_slot = path->slots[0];
+			ins_nr = 1;
+			goto next_slot;
+		}
+
+		ret = copy_items(trans, inode, dst_path, path, ins_start_slot,
+				 ins_nr, inode_only, logged_isize);
+		if (ret < 0)
+			return ret;
+		ins_nr = 1;
+		ins_start_slot = path->slots[0];
+next_slot:
+		path->slots[0]++;
+		if (path->slots[0] < btrfs_header_nritems(path->nodes[0])) {
+			btrfs_item_key_to_cpu(path->nodes[0], min_key,
+					      path->slots[0]);
+			goto again;
+		}
+		if (ins_nr) {
+			ret = copy_items(trans, inode, dst_path, path,
+					 ins_start_slot, ins_nr, inode_only,
+					 logged_isize);
+			if (ret < 0)
+				return ret;
+			ins_nr = 0;
+		}
+		btrfs_release_path(path);
+next_key:
+		if (min_key->offset < (u64)-1) {
+			min_key->offset++;
+		} else if (min_key->type < max_key->type) {
+			min_key->type++;
+			min_key->offset = 0;
+		} else {
+			break;
+		}
+	}
+	if (ins_nr)
+		ret = copy_items(trans, inode, dst_path, path, ins_start_slot,
+				 ins_nr, inode_only, logged_isize);
+
+	return ret;
+}
+
 /* log a single inode in the tree log.
  * At least one parent directory for this inode must exist in the tree
  * or be logged already.
@@ -5023,9 +5155,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_root *log = root->log_root;
 	int err = 0;
 	int ret;
-	int nritems;
-	int ins_start_slot = 0;
-	int ins_nr;
 	bool fast_search = false;
 	u64 ino = btrfs_ino(inode);
 	struct extent_map_tree *em_tree = &inode->extent_tree;
@@ -5156,139 +5285,12 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		goto out_unlock;
 	}
 
-	while (1) {
-		ins_nr = 0;
-		ret = btrfs_search_forward(root, &min_key,
-					   path, trans->transid);
-		if (ret < 0) {
-			err = ret;
-			goto out_unlock;
-		}
-		if (ret != 0)
-			break;
-again:
-		/* note, ins_nr might be > 0 here, cleanup outside the loop */
-		if (min_key.objectid != ino)
-			break;
-		if (min_key.type > max_key.type)
-			break;
-
-		if (min_key.type == BTRFS_INODE_ITEM_KEY)
-			need_log_inode_item = false;
-
-		if ((min_key.type == BTRFS_INODE_REF_KEY ||
-		     min_key.type == BTRFS_INODE_EXTREF_KEY) &&
-		    inode->generation == trans->transid &&
-		    !recursive_logging) {
-			u64 other_ino = 0;
-			u64 other_parent = 0;
-
-			ret = btrfs_check_ref_name_override(path->nodes[0],
-					path->slots[0], &min_key, inode,
-					&other_ino, &other_parent);
-			if (ret < 0) {
-				err = ret;
-				goto out_unlock;
-			} else if (ret > 0 && ctx &&
-				   other_ino != btrfs_ino(BTRFS_I(ctx->inode))) {
-				if (ins_nr > 0) {
-					ins_nr++;
-				} else {
-					ins_nr = 1;
-					ins_start_slot = path->slots[0];
-				}
-				ret = copy_items(trans, inode, dst_path, path,
-						 ins_start_slot,
-						 ins_nr, inode_only,
-						 logged_isize);
-				if (ret < 0) {
-					err = ret;
-					goto out_unlock;
-				}
-				ins_nr = 0;
-
-				err = log_conflicting_inodes(trans, root, path,
-						ctx, other_ino, other_parent);
-				if (err)
-					goto out_unlock;
-				btrfs_release_path(path);
-				goto next_key;
-			}
-		}
-
-		/* Skip xattrs, we log them later with btrfs_log_all_xattrs() */
-		if (min_key.type == BTRFS_XATTR_ITEM_KEY) {
-			if (ins_nr == 0)
-				goto next_slot;
-			ret = copy_items(trans, inode, dst_path, path,
-					 ins_start_slot,
-					 ins_nr, inode_only, logged_isize);
-			if (ret < 0) {
-				err = ret;
-				goto out_unlock;
-			}
-			ins_nr = 0;
-			goto next_slot;
-		}
-
-		if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
-			ins_nr++;
-			goto next_slot;
-		} else if (!ins_nr) {
-			ins_start_slot = path->slots[0];
-			ins_nr = 1;
-			goto next_slot;
-		}
-
-		ret = copy_items(trans, inode, dst_path, path,
-				 ins_start_slot, ins_nr, inode_only,
-				 logged_isize);
-		if (ret < 0) {
-			err = ret;
-			goto out_unlock;
-		}
-		ins_nr = 1;
-		ins_start_slot = path->slots[0];
-next_slot:
-
-		nritems = btrfs_header_nritems(path->nodes[0]);
-		path->slots[0]++;
-		if (path->slots[0] < nritems) {
-			btrfs_item_key_to_cpu(path->nodes[0], &min_key,
-					      path->slots[0]);
-			goto again;
-		}
-		if (ins_nr) {
-			ret = copy_items(trans, inode, dst_path, path,
-					 ins_start_slot,
-					 ins_nr, inode_only, logged_isize);
-			if (ret < 0) {
-				err = ret;
-				goto out_unlock;
-			}
-			ins_nr = 0;
-		}
-		btrfs_release_path(path);
-next_key:
-		if (min_key.offset < (u64)-1) {
-			min_key.offset++;
-		} else if (min_key.type < max_key.type) {
-			min_key.type++;
-			min_key.offset = 0;
-		} else {
-			break;
-		}
-	}
-	if (ins_nr) {
-		ret = copy_items(trans, inode, dst_path, path,
-				 ins_start_slot, ins_nr, inode_only,
-				 logged_isize);
-		if (ret < 0) {
-			err = ret;
-			goto out_unlock;
-		}
-		ins_nr = 0;
-	}
+	err = copy_inode_items_to_log(trans, inode, &min_key, &max_key,
+				      path, dst_path, logged_isize,
+				      recursive_logging, inode_only, ctx,
+				      &need_log_inode_item);
+	if (err)
+		goto out_unlock;
 
 	btrfs_release_path(path);
 	btrfs_release_path(dst_path);
-- 
2.25.1




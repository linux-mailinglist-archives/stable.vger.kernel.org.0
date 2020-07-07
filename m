Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBF8217037
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgGGPQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbgGGPQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:16:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7DD2065D;
        Tue,  7 Jul 2020 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134962;
        bh=FM+KNp3Mca0cmqELRNXXFn2a70pA88OGgs7zjVYJz8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks5rolKXbz96ur//COjT5gUckS/fzTv237ZcPnH+uT9Z+jQqTE1jSsvw6nWSXxJwf
         KZHGDqGztSWcb1DiVUMNTUO4PlKsYx18FBWAK4Ep7Kkvkdj38S1GRZYmq6SmP8j6+O
         vS70jsz/u0WwNArYT8uPM90vIvnl0ZofdatgheIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/27] btrfs: fix a block group ref counter leak after failure to remove block group
Date:   Tue,  7 Jul 2020 17:15:28 +0200
Message-Id: <20200707145749.015690556@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
References: <20200707145748.944863698@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 9fecd13202f520f3f25d5b1c313adb740fe19773 ]

When removing a block group, if we fail to delete the block group's item
from the extent tree, we jump to the 'out' label and end up decrementing
the block group's reference count once only (by 1), resulting in a counter
leak because the block group at that point was already removed from the
block group cache rbtree - so we have to decrement the reference count
twice, once for the rbtree and once for our lookup at the start of the
function.

There is a second bug where if removing the free space tree entries (the
call to remove_block_group_free_space()) fails we end up jumping to the
'out_put_group' label but end up decrementing the reference count only
once, when we should have done it twice, since we have already removed
the block group from the block group cache rbtree. This happens because
the reference count decrement for the rbtree reference happens after
attempting to remove the free space tree entries, which is far away from
the place where we remove the block group from the rbtree.

To make things less error prone, decrement the reference count for the
rbtree immediately after removing the block group from it. This also
eleminates the need for two different exit labels on error, renaming
'out_put_label' to just 'out' and removing the old 'out'.

Fixes: f6033c5e333238 ("btrfs: fix block group leak when removing fails")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 51e26f90f0bb2..63b8812ba508a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10554,7 +10554,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto out_put_group;
+		goto out;
 	}
 
 	/*
@@ -10591,7 +10591,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		if (ret) {
 			btrfs_add_delayed_iput(inode);
-			goto out_put_group;
+			goto out;
 		}
 		clear_nlink(inode);
 		/* One for the block groups ref */
@@ -10614,13 +10614,13 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
 	if (ret < 0)
-		goto out_put_group;
+		goto out;
 	if (ret > 0)
 		btrfs_release_path(path);
 	if (ret == 0) {
 		ret = btrfs_del_item(trans, tree_root, path);
 		if (ret)
-			goto out_put_group;
+			goto out;
 		btrfs_release_path(path);
 	}
 
@@ -10629,6 +10629,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		 &fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
 
+	/* Once for the block groups rbtree */
+	btrfs_put_block_group(block_group);
+
 	if (fs_info->first_logical_byte == block_group->key.objectid)
 		fs_info->first_logical_byte = (u64)-1;
 	spin_unlock(&fs_info->block_group_cache_lock);
@@ -10778,10 +10781,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = remove_block_group_free_space(trans, fs_info, block_group);
 	if (ret)
-		goto out_put_group;
-
-	/* Once for the block groups rbtree */
-	btrfs_put_block_group(block_group);
+		goto out;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0)
@@ -10791,10 +10791,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_item(trans, root, path);
 
-out_put_group:
+out:
 	/* Once for the lookup reference */
 	btrfs_put_block_group(block_group);
-out:
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.25.1




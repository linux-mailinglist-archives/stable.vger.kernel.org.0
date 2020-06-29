Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE720D193
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgF2SmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:18 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60439 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729012AbgF2Slw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DE9B437B;
        Mon, 29 Jun 2020 07:00:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:00:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=krS+6t
        bR/bjuhma4xR21F7L6pcULvEZL989lLTNu0pQ=; b=StrkKPBhKaUPow7GXr2u2U
        pJ9zZ2DsCFUCetCUl07pEx+/E2DVPiFZeKZhoXpETDEj4zj9HjpMX+gO/nFSVEOq
        G5xYOWpo0+Nxnx4ERrlom7nIkMFS5nqUGRUI6BkXB1cslmgFt/UvZrycxKEL05bm
        nctkwOKBbMqDjAUNgeQaS7t2VAcv2SMC4l3I2sc0zUcT35XPy5OO86f2r12iWktF
        MtLE+bFSNVakOSAU8ppzqsG13lpF1lHBK5NvowFmvOuLhRbi7NeDNa9QTu4K9fXi
        aRWwTOZIxKJvsSmeXCH/DdazOkX9in6DzeJ0NJQwy+PjPI1tyi2ufYpSatiqs1pg
        ==
X-ME-Sender: <xms:5Mn5XqwEmTBap37AVXACTbEeBYdbJ1SzkNrSZYAtEW2IVDoTGOOt6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:5Mn5XmSh3-lEpPTgXCbggKecPbQ_nJjuwyLZxzn4kDSPz_tEshFLNw>
    <xmx:5Mn5XsXnx_YWeObD7EGFaLWYWmbfhgodFBXOnV8h-DDZvZy5tI2GcQ>
    <xmx:5Mn5XggZ2HEeHuLxOtkklGlXEtrm0NSiOV5Kk6qiL8aHkCdyeOTTfg>
    <xmx:5Mn5Xl495pWlkdaMsZB5NX37OCclz84YwtD4vm0iqkwK4xQKTjmquoZHwnc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A6173067BFE;
        Mon, 29 Jun 2020 07:00:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix a block group ref counter leak after failure to" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, anand.jain@oracle.com, dsterba@suse.com,
        nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:00:41 +0200
Message-ID: <15934284414749@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fecd13202f520f3f25d5b1c313adb740fe19773 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 1 Jun 2020 19:12:06 +0100
Subject: [PATCH] btrfs: fix a block group ref counter leak after failure to
 remove block group

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

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 176e8a292fd1..6462dd0b155c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -940,7 +940,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto out_put_group;
+		goto out;
 	}
 
 	/*
@@ -978,7 +978,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		if (ret) {
 			btrfs_add_delayed_iput(inode);
-			goto out_put_group;
+			goto out;
 		}
 		clear_nlink(inode);
 		/* One for the block groups ref */
@@ -1001,13 +1001,13 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
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
 
@@ -1016,6 +1016,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		 &fs_info->block_group_cache_tree);
 	RB_CLEAR_NODE(&block_group->cache_node);
 
+	/* Once for the block groups rbtree */
+	btrfs_put_block_group(block_group);
+
 	if (fs_info->first_logical_byte == block_group->start)
 		fs_info->first_logical_byte = (u64)-1;
 	spin_unlock(&fs_info->block_group_cache_lock);
@@ -1125,10 +1128,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = remove_block_group_free_space(trans, block_group);
 	if (ret)
-		goto out_put_group;
-
-	/* Once for the block groups rbtree */
-	btrfs_put_block_group(block_group);
+		goto out;
 
 	ret = remove_block_group_item(trans, path, block_group);
 	if (ret < 0)
@@ -1145,10 +1145,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		free_extent_map(em);
 	}
 
-out_put_group:
+out:
 	/* Once for the lookup reference */
 	btrfs_put_block_group(block_group);
-out:
 	if (remove_rsv)
 		btrfs_delayed_refs_rsv_release(fs_info, 1);
 	btrfs_free_path(path);


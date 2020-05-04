Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21341C3421
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgEDIPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:15:15 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:35199 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbgEDIPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:15:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E2E884E0;
        Mon,  4 May 2020 04:15:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KquRAL
        seky/elx2T2nmMGSjgSusKLHddnGbN/PIZfl0=; b=Ta3ANudps29W8V1/CJyxmq
        7EZ7q9Zu/lhuKuQUWTgkfD7C2FW6iJEIgCXDm4wUMNONYADM2C4aNOnbchuWab+E
        V+Zua6HRXQ9JBaf4MGwoRHgTZWtME4D9KN64WaobsgMJXdCw+M4u0i4N++dNT7ly
        Yljsakn4Viw9hilnlYxB8vdf5jAG3VPjLViohGOFYtkmcjCt/p3ndACB09C+AJCX
        1EYIq1B54wnY7TLvp80ebYcNwLRdQbiqJkatMvOV77/Sl7qykk55Uyg1hk49IWXP
        p8krjiVeoraSf17BiIF4mKaKAa3ddnT9vx6ZSKTsrDSXY5tDPon9QUEv/ys0XVuw
        ==
X-ME-Sender: <xms:Ec-vXjk1eSLt0jD_fPYwMJ9LNiMYrof1xnplNvkXOtQmdi_rbRaEaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejudetveeuve
    eludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhi
    iigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Ec-vXhnwJGqwnedvllE24kNSZuizoILNQISuqDMlykz-sdC2umjM4w>
    <xmx:Ec-vXoiAH3OwUAPCSmELITkGkTRhBWnuFGDS3jdNDVDbzXWVLc4Euw>
    <xmx:Ec-vXiVDjFs9maznu-GMyAwv3x7UFtFrQlhJ7cpkIYQAV546WX0cBw>
    <xmx:Ec-vXjNcDTX8P8X4dV2ArR6wFiu0n_qhD16-SkEBwC8KTkAzq2W-63-qAGU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2ACD6328005E;
        Mon,  4 May 2020 04:15:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix block group leak when removing fails" failed to apply to 4.4-stable tree
To:     xiyuyang19@fudan.edu.cn, dsterba@suse.com, tanxin.ctf@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:15:11 +0200
Message-ID: <158858011184189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6033c5e333238f299c3ae03fac8cc1365b23b77 Mon Sep 17 00:00:00 2001
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Tue, 21 Apr 2020 10:54:11 +0800
Subject: [PATCH] btrfs: fix block group leak when removing fails

btrfs_remove_block_group() invokes btrfs_lookup_block_group(), which
returns a local reference of the block group that contains the given
bytenr to "block_group" with increased refcount.

When btrfs_remove_block_group() returns, "block_group" becomes invalid,
so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in several exception handling paths
of btrfs_remove_block_group(). When those error scenarios occur such as
btrfs_alloc_path() returns NULL, the function forgets to decrease its
refcnt increased by btrfs_lookup_block_group() and will cause a refcnt
leak.

Fix this issue by jumping to "out_put_group" label and calling
btrfs_put_block_group() when those error scenarios occur.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index af9e9a008724..696f47103cfc 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -916,7 +916,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_put_group;
 	}
 
 	/*
@@ -954,7 +954,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		if (ret) {
 			btrfs_add_delayed_iput(inode);
-			goto out;
+			goto out_put_group;
 		}
 		clear_nlink(inode);
 		/* One for the block groups ref */
@@ -977,13 +977,13 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, tree_root, &key, path, -1, 1);
 	if (ret < 0)
-		goto out;
+		goto out_put_group;
 	if (ret > 0)
 		btrfs_release_path(path);
 	if (ret == 0) {
 		ret = btrfs_del_item(trans, tree_root, path);
 		if (ret)
-			goto out;
+			goto out_put_group;
 		btrfs_release_path(path);
 	}
 
@@ -1102,9 +1102,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 
 	ret = remove_block_group_free_space(trans, block_group);
 	if (ret)
-		goto out;
+		goto out_put_group;
 
-	btrfs_put_block_group(block_group);
+	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
@@ -1127,6 +1127,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 		/* once for the tree */
 		free_extent_map(em);
 	}
+
+out_put_group:
+	/* Once for the lookup reference */
+	btrfs_put_block_group(block_group);
 out:
 	if (remove_rsv)
 		btrfs_delayed_refs_rsv_release(fs_info, 1);


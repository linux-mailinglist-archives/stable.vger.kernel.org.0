Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0931C456C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgEDSPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbgEDR7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D226E20663;
        Mon,  4 May 2020 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615182;
        bh=W2Ffas+nZMrihNOOgOWnoqgXgERFK+vJJddkK6R9I/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxsGftKeIDNfbyxZZlRXe6xfIlgg/5bTC6s8sz/Aa+r2Ter+Oi6dxX7iqPOUPS4Ie
         RGysXUgopr5dLQBZbpjL3DekgydzzyGPnjUQm0qGI72ufQJgXvf9DTaWOxQT2pFooe
         FmyWvW9Cq5YdQNnXAXq8yAHjgi8xI/Cr6jtD3ECI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 05/18] btrfs: fix block group leak when removing fails
Date:   Mon,  4 May 2020 19:57:15 +0200
Message-Id: <20200504165443.251593903@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit f6033c5e333238f299c3ae03fac8cc1365b23b77 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10645,7 +10645,7 @@ int btrfs_remove_block_group(struct btrf
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_put_group;
 	}
 
 	/*
@@ -10684,7 +10684,7 @@ int btrfs_remove_block_group(struct btrf
 		ret = btrfs_orphan_add(trans, inode);
 		if (ret) {
 			btrfs_add_delayed_iput(inode);
-			goto out;
+			goto out_put_group;
 		}
 		clear_nlink(inode);
 		/* One for the block groups ref */
@@ -10707,13 +10707,13 @@ int btrfs_remove_block_group(struct btrf
 
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
 
@@ -10871,9 +10871,9 @@ int btrfs_remove_block_group(struct btrf
 
 	ret = remove_block_group_free_space(trans, root->fs_info, block_group);
 	if (ret)
-		goto out;
+		goto out_put_group;
 
-	btrfs_put_block_group(block_group);
+	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
@@ -10883,6 +10883,10 @@ int btrfs_remove_block_group(struct btrf
 		goto out;
 
 	ret = btrfs_del_item(trans, root, path);
+
+out_put_group:
+	/* Once for the lookup reference */
+	btrfs_put_block_group(block_group);
 out:
 	btrfs_free_path(path);
 	return ret;



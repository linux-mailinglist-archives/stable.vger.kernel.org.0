Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840141C454D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbgEDSAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbgEDSAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:00:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF6220721;
        Mon,  4 May 2020 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615248;
        bh=9PO4eLzEaxeDb9USrLBsYzA4tX35j8/SlZcCjclVEYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RlAtd80bqxGrSKRbLtd5uDU/E4n5FfHEe4SBPj5nbbQRFs9S/4CRuhK2L0SRTIom4
         WK8xALL0JxzFivGJr1uPUL3rp69MKYRrBzwJefOGtmXfBf0o4wd88Hui4MKeqsbj8d
         sIMWsX630F3FYGHk48k2SZpt79j7HI06/PxmbC00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 06/26] btrfs: fix block group leak when removing fails
Date:   Mon,  4 May 2020 19:57:20 +0200
Message-Id: <20200504165443.791496186@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
References: <20200504165442.494398840@linuxfoundation.org>
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
@@ -10554,7 +10554,7 @@ int btrfs_remove_block_group(struct btrf
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_put_group;
 	}
 
 	/*
@@ -10591,7 +10591,7 @@ int btrfs_remove_block_group(struct btrf
 		ret = btrfs_orphan_add(trans, BTRFS_I(inode));
 		if (ret) {
 			btrfs_add_delayed_iput(inode);
-			goto out;
+			goto out_put_group;
 		}
 		clear_nlink(inode);
 		/* One for the block groups ref */
@@ -10614,13 +10614,13 @@ int btrfs_remove_block_group(struct btrf
 
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
 
@@ -10778,9 +10778,9 @@ int btrfs_remove_block_group(struct btrf
 
 	ret = remove_block_group_free_space(trans, fs_info, block_group);
 	if (ret)
-		goto out;
+		goto out_put_group;
 
-	btrfs_put_block_group(block_group);
+	/* Once for the block groups rbtree */
 	btrfs_put_block_group(block_group);
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
@@ -10790,6 +10790,10 @@ int btrfs_remove_block_group(struct btrf
 		goto out;
 
 	ret = btrfs_del_item(trans, root, path);
+
+out_put_group:
+	/* Once for the lookup reference */
+	btrfs_put_block_group(block_group);
 out:
 	btrfs_free_path(path);
 	return ret;



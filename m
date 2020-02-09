Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4557F156A49
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgBIM7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:59:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40339 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBIM7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:59:47 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B412A21C1C;
        Sun,  9 Feb 2020 07:59:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lYYnYu
        zSqNvm1Vb8ILESI7jdV3Ri+3wn0Jl6u+WiWU4=; b=IULPF6n7r4CY1CCTDHwc3m
        DOM3584AJyFPriM3WXqniUHu1HDJMgZlmPNpqNbx77q9onV4TpBuANjkw1hGlXmU
        7NqHCFu3IZwJOUNiyqK4AJx9n4e3vu/D2oiofwwrz4mzRA4cGiXeEHQytVo4u/j9
        n4zCyZIjbh2XLC6fGeeQDvqon+wBL/mvQS9vbuF6lxrX6mm8ANSeKofiGO9mCjVQ
        9rr1kRRUz2BaBhtKHGuXh9ZuA1tIXnESpjr4TeDalRelo+hzHry09Nggc08VE4UY
        q/9jsyM7jPkj6WfvyZCTZ5OYpoLtxwiP0DMPEqdssdZfy2M9xPNFjOrfdKKQXrVQ
        ==
X-ME-Sender: <xms:QgJAXiBVhR4DX6PWltY9c5u_m70ySNDAhZ4SBpquOv1f8quORbFLfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepuddtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QgJAXgz05KP9qjKn6XqKe2lr-Rm_Wlp62n79Y4CJrXSt0Aidi9gdlA>
    <xmx:QgJAXgmeeaAx1Pi_uj5keARHrZcyorvyMp2b7tFKY4a1qzG1vl567A>
    <xmx:QgJAXlFpDyXNbU3PNOcCBmdyvI1ZCJLiAbTUmuPR3_yqRnXwbryD5A>
    <xmx:QgJAXjkqN4cMrmHqgngk4KcWCuZS9e0gcU4tve-W4Kuh2y8WlOZH8A>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A7C030606FB;
        Sun,  9 Feb 2020 07:59:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: free block groups after free'ing fs trees" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:30:45 +0100
Message-ID: <1581247845130211@kroah.com>
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

From 4e19443da1941050b346f8fc4c368aa68413bc88 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 21 Jan 2020 09:17:06 -0500
Subject: [PATCH] btrfs: free block groups after free'ing fs trees

Sometimes when running generic/475 we would trip the
WARN_ON(cache->reserved) check when free'ing the block groups on umount.
This is because sometimes we don't commit the transaction because of IO
errors and thus do not cleanup the tree logs until at umount time.

These blocks are still reserved until they are cleaned up, but they
aren't cleaned up until _after_ we do the free block groups work.  Fix
this by moving the free after free'ing the fs roots, that way all of the
tree logs are cleaned up and we have a properly cleaned fs.  A bunch of
loops of generic/475 confirmed this fixes the problem.

CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5ce2801f8388..aea48d6ddc0c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4030,11 +4030,18 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
-	btrfs_free_block_groups(fs_info);
-
 	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
 	free_root_pointers(fs_info, true);
 
+	/*
+	 * We must free the block groups after dropping the fs_roots as we could
+	 * have had an IO error and have left over tree log blocks that aren't
+	 * cleaned up until the fs roots are freed.  This makes the block group
+	 * accounting appear to be wrong because there's pending reserved bytes,
+	 * so make sure we do the block group cleanup afterwards.
+	 */
+	btrfs_free_block_groups(fs_info);
+
 	iput(fs_info->btree_inode);
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY


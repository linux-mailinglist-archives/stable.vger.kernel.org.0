Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D91156A48
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgBIM7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:59:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32837 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBIM7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:59:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7575B21AF2;
        Sun,  9 Feb 2020 07:59:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RtPbAf
        VsX6o818JerFgnL0SJ6HR5LIsv5UQ8CKxiT3s=; b=C20zqwj+nJu5w9wgD3I/1O
        J9VyreF45IvTEOLO5TBwCswIFfcpE/t/EJOiertNV0Yqd9kB1XkSrrs2Q59DmCmK
        a/OGr1slVoSYLhubtuGw2gb8zfRYlSRWSEXvlsoNRW4BhPi/0s2RYsZabgl95fRp
        zk3jXS1P6Oq//PGlP1pdgTuk5FTc9E6Eg8wKe9ZlL9GykT8Q9K3C/r1rWEBJ0zSx
        bcsetopkI6ThxxkHndcedE9PkZfFJOj+sYivtRWRP7Cerp+z+08DDw2j9h2lroMF
        ZBsp4un7zuBR1xKubeRW1K4pFffVm7gXS96os2Qw/xT8tRfVXSjZi3hF+LK5njqQ
        ==
X-ME-Sender: <xms:OgJAXkLzs6fg4N_hq6ocqa0MzYUsuokdSTBGSttQMwhkgrJZ5tOVMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepleenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OgJAXgfMrlLmBFsZXizbSpQ2ayA7I47Nhyg6qSae82G1wwnggUsEHA>
    <xmx:OgJAXncyLncDAdMa7HD6beAS6TQRCbfvFTxKEz4WXVc1U1GEPHFfwA>
    <xmx:OgJAXjMGStBsRWMaKhhxrK-FZGjoT1iGMCI3JjegKaQ24sVT7hkUBw>
    <xmx:OgJAXqLX65aSQyfbVGhePDQ-jVBRyEgvaL7YjtRQlT3ld5x3IwImCA>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC5093060701;
        Sun,  9 Feb 2020 07:59:35 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: free block groups after free'ing fs trees" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:30:44 +0100
Message-ID: <158124784447255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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


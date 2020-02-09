Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF5156A45
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBIM7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 07:59:14 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36811 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBIM7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 07:59:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E8FF21AA4;
        Sun,  9 Feb 2020 07:59:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 07:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=r7BBuk
        4uCDjUlKhip3pu8vKt4cSA4JwjczVzNqone3s=; b=vgcb3bCx6bTCKhHAZKBIIY
        nHqlDgYaKMj0+SDIIcMbLl3DAwR3V+NABSAzYkE5VyX/wk2HV3FdfYWNw0nGT52Y
        3BvHUvZJ2JEi7PUB/iuNuohyhyrOg+JVSz1LcF8kspe0fixUc4IZGWVESLphdvtU
        jiAprco846TTvRVKadIaS3Gq/yHuyzL+pgDTHOQWcxGXiA7r2Rx+7alB1LGsIQ8S
        EEVK8w6F1ua9IBh8mR26WhAluZsGd0OtF84fa4yr4964tFSVcbJr4ZEMQIEt363K
        WUGFUygd0kbIZzHxQfZbe/O6tRVnNPOD7I2PTO9FF8EXTX26PIOlJ1Fp0Tw0AjkQ
        ==
X-ME-Sender: <xms:IQJAXlujWUAyV8Zsv-weHLIME0N48cRVlStS1uksWbHlBhi0J6T54Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepjeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IQJAXtpqnUA6TUAp0tYo1rsLROjLmkyDymndPlc5JzV9-pZk6Z-1kw>
    <xmx:IQJAXrfFLzvd2bWb1dT-Ud9kxr1xoDVMXwo4mGutlM_BvBAW-_pt5A>
    <xmx:IQJAXlnS_t0-8pwpreeGV0E_f-3TdHAG13fZ34eVRzD70ISKz1eEjw>
    <xmx:IQJAXqQ7WLUPicwBvqVI4HGd_GX1A_9QhvlrE7s_9p8CNXDZBk2tug>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96B7E3280059;
        Sun,  9 Feb 2020 07:59:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: free block groups after free'ing fs trees" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:30:41 +0100
Message-ID: <1581247841121239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB2D40C45A
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhIOL0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhIOL0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 07:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE37461250;
        Wed, 15 Sep 2021 11:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631705130;
        bh=8sE4X4JF/foAnbzbmEMq7FW8h3NkvruVO5Gh2XEgZOo=;
        h=Subject:To:Cc:From:Date:From;
        b=aJkFBnHWn6iN0uJLZ5JJJKM6fnKWCJ5aEX4BdJwp6Z4TbEMLKlYBgbMzy0er/yUL1
         +8PcJUUdv29Wk8SfFE17+JdyQlMlFn+KnWSKrcmU/zpkR3bQdWzVmzOiIbchKQaqtL
         fLZQOrbHxanDHDN16JL8XQS7KHAGg7sGYKqh9Orc=
Subject: FAILED: patch "[PATCH] btrfs: fix upper limit for max_inline for page size 64K" failed to apply to 5.4-stable tree
To:     anand.jain@oracle.com, alexander.tsvetkov@oracle.com,
        dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 13:25:28 +0200
Message-ID: <1631705128101229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 6f93e834fa7c5faa0372e46828b4b2a966ac61d7 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Tue, 10 Aug 2021 23:23:44 +0800
Subject: [PATCH] btrfs: fix upper limit for max_inline for page size 64K

The mount option max_inline ranges from 0 to the sectorsize (which is
now equal to page size). But we parse the mount options too early and
before the actual sectorsize is read from the superblock. So the upper
limit of max_inline is unaware of the actual sectorsize and is limited
by the temporary sectorsize 4096, even on a system where the default
sectorsize is 64K.

Fix this by reading the superblock sectorsize before the mount option
parse.

Reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f9515dccce0..355ea88d5c5f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3314,6 +3314,30 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
+	/*
+	 * Flag our filesystem as having big metadata blocks if they are bigger
+	 * than the page size.
+	 */
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
+		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
+			btrfs_info(fs_info,
+				"flagging fs with big metadata feature");
+		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+	}
+
+	/* Set up fs_info before parsing mount options */
+	nodesize = btrfs_super_nodesize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = sectorsize;
+	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
+	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
+
+	fs_info->nodesize = nodesize;
+	fs_info->sectorsize = sectorsize;
+	fs_info->sectorsize_bits = ilog2(sectorsize);
+	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
+	fs_info->stripesize = stripesize;
+
 	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
 	if (ret) {
 		err = ret;
@@ -3340,30 +3364,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		btrfs_info(fs_info, "has skinny extents");
 
-	/*
-	 * flag our filesystem as having big metadata blocks if
-	 * they are bigger than the page size
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
-
-	nodesize = btrfs_super_nodesize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = sectorsize;
-	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
-	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
-
-	/* Cache block sizes */
-	fs_info->nodesize = nodesize;
-	fs_info->sectorsize = sectorsize;
-	fs_info->sectorsize_bits = ilog2(sectorsize);
-	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
-	fs_info->stripesize = stripesize;
-
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions


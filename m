Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC822592DF5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiHOLOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiHOLOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BD6183B5
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:14:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20154B80D27
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F4EC433C1;
        Mon, 15 Aug 2022 11:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660562074;
        bh=RzbItqJ/uk1iUHD/BnOS5ZK3AOGLruD1+peDlWJyx6U=;
        h=Subject:To:Cc:From:Date:From;
        b=zS7/4szadIw3q1mmYHarFFemFCG2WZi+fFJQgBkbOeWKxm9boFaJbbGePv2h6B17k
         WCiJ4RWccqOsN0Oy0g6+NQ3Kjb72LxVTo+5FPeqKFgcisDX6OLHfZXgiLP7RqkL/Ki
         y++ijusXo5B4FshFD5ZTv7FmTR29rY7twsChbjdg=
Subject: FAILED: patch "[PATCH] btrfs: properly flag filesystem with" failed to apply to 5.10-stable tree
To:     nborisov@suse.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:14:32 +0200
Message-ID: <1660562072164194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e26b04c4c91925dba57324db177a24e18e2d0013 Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Thu, 23 Jun 2022 10:55:47 +0300
Subject: [PATCH] btrfs: properly flag filesystem with
 BTRFS_FEATURE_INCOMPAT_BIG_METADATA

Commit 6f93e834fa7c seemingly inadvertently moved the code responsible
for flagging the filesystem as having BIG_METADATA to a place where
setting the flag was essentially lost. This means that
filesystems created with kernels containing this bug (starting with 5.15)
can potentially be mounted by older (pre-3.4) kernels. In reality
chances for this happening are low because there are other incompat
flags introduced in the mean time. Still the correct behavior is to set
INCOMPAT_BIG_METADATA flag and persist this in the superblock.

Fixes: 6f93e834fa7c ("btrfs: fix upper limit for max_inline for page size 64K")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 243bd7bd79cd..e12fd3abd689 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3484,16 +3484,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
-	/*
-	 * Flag our filesystem as having big metadata blocks if they are bigger
-	 * than the page size.
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
 
 	/* Set up fs_info before parsing mount options */
 	nodesize = btrfs_super_nodesize(disk_super);
@@ -3534,6 +3524,17 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		btrfs_info(fs_info, "has skinny extents");
 
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
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions


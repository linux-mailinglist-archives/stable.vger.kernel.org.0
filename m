Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F343CD0CE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhGSIsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:48:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235013AbhGSIsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:48:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 896446108B;
        Mon, 19 Jul 2021 09:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626686957;
        bh=948+EKyjttZXBCkpI+376sdsqQXaBCUAnuHlYq6Q448=;
        h=Subject:To:Cc:From:Date:From;
        b=jReIGqbR/g10jCtc20B46MBmJGyjT4p7c8r/3MDvDezY9T0BbogwplaOqSdtdbbPW
         rh6rQylj3SNIj1mi6cx9Ddum6foZ14oJUNzwMZ8bBOKTkd/vLr6dGTtP3PoWiweGTJ
         F2ZkWIa/yW5jRSBlk7RY06ocWWJNYAnQe7ZIFyXM=
Subject: FAILED: patch "[PATCH] btrfs: zoned: print unusable percentage when reclaiming block" failed to apply to 5.13-stable tree
To:     johannes.thumshirn@wdc.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 11:29:14 +0200
Message-ID: <1626686954179134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f93e776c6734cea989aeb4f2d6c97e521baa683 Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Tue, 29 Jun 2021 03:16:46 +0900
Subject: [PATCH] btrfs: zoned: print unusable percentage when reclaiming block
 groups

When we're automatically reclaiming a zone, because its zone_unusable
value is above the reclaim threshold, we're only logging how much
percent of the zone's capacity are used, but not how much of the
capacity is unusable.

Also print the percentage of the unusable space in the block group
before we're reclaiming it.

Example:

  BTRFS info (device sdg): reclaiming chunk 230686720 with 13% used 86% unusable

CC: stable@vger.kernel.org # 5.13
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index d4c8dc550889..fec7a34b27f3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1501,6 +1501,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 	mutex_lock(&fs_info->reclaim_bgs_lock);
 	spin_lock(&fs_info->unused_bgs_lock);
 	while (!list_empty(&fs_info->reclaim_bgs)) {
+		u64 zone_unusable;
 		int ret = 0;
 
 		bg = list_first_entry(&fs_info->reclaim_bgs,
@@ -1534,13 +1535,22 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 			goto next;
 		}
 
+		/*
+		 * Cache the zone_unusable value before turning the block group
+		 * to read only. As soon as the blog group is read only it's
+		 * zone_unusable value gets moved to the block group's read-only
+		 * bytes and isn't available for calculations anymore.
+		 */
+		zone_unusable = bg->zone_unusable;
 		ret = inc_block_group_ro(bg, 0);
 		up_write(&space_info->groups_sem);
 		if (ret < 0)
 			goto next;
 
-		btrfs_info(fs_info, "reclaiming chunk %llu with %llu%% used",
-				bg->start, div64_u64(bg->used * 100, bg->length));
+		btrfs_info(fs_info,
+			"reclaiming chunk %llu with %llu%% used %llu%% unusable",
+				bg->start, div_u64(bg->used * 100, bg->length),
+				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
 		if (ret)


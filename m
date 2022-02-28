Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE7B4C770B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiB1SLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241575AbiB1SKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:10:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A22B45B3;
        Mon, 28 Feb 2022 09:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58C4BB815C8;
        Mon, 28 Feb 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98C1C340F4;
        Mon, 28 Feb 2022 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070612;
        bh=lL3lN0XuoIi6Bn5fJ/V8NmTYlqd1b+uQ+x3AeGeE/Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1WOG46hZHGf+dpW3jokiWQWqpEJ5KB4NfwPtaZilQPbnN9eWbR8Cy7NX6Rg7EhhXu
         nv6fIUJkxbe8zs5e+eGIwicWEIaQhBfCuL6zXt2/gmy+8MvlvDxKyyvCcjtjoYCsS7
         jBGhm6bg1FvuDsEwSX4fUcbwGa5bCjiUitFx26WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 142/164] btrfs: defrag: allow defrag_one_cluster() to skip large extent which is not a target
Date:   Mon, 28 Feb 2022 18:25:04 +0100
Message-Id: <20220228172412.797687507@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 966d879bafaaf020c11a7cee9526f6dd823a4126 upstream.

In the rework of btrfs_defrag_file(), we always call
defrag_one_cluster() and increase the offset by cluster size, which is
only 256K.

But there are cases where we have a large extent (e.g. 128M) which
doesn't need to be defragged at all.

Before the refactor, we can directly skip the range, but now we have to
scan that extent map again and again until the cluster moves after the
non-target extent.

Fix the problem by allow defrag_one_cluster() to increase
btrfs_defrag_ctrl::last_scanned to the end of an extent, if and only if
the last extent of the cluster is not a target.

The test script looks like this:

	mkfs.btrfs -f $dev > /dev/null

	mount $dev $mnt

	# As btrfs ioctl uses 32M as extent_threshold
	xfs_io -f -c "pwrite 0 64M" $mnt/file1
	sync
	# Some fragemented range to defrag
	xfs_io -s -c "pwrite 65548k 4k" \
		  -c "pwrite 65544k 4k" \
		  -c "pwrite 65540k 4k" \
		  -c "pwrite 65536k 4k" \
		  $mnt/file1
	sync

	echo "=== before ==="
	xfs_io -c "fiemap -v" $mnt/file1
	echo "=== after ==="
	btrfs fi defrag $mnt/file1
	sync
	xfs_io -c "fiemap -v" $mnt/file1
	umount $mnt

With extra ftrace put into defrag_one_cluster(), before the patch it
would result tons of loops:

(As defrag_one_cluster() is inlined, the function name is its caller)

  btrfs-126062  [005] .....  4682.816026: btrfs_defrag_file: r/i=5/257 start=0 len=262144
  btrfs-126062  [005] .....  4682.816027: btrfs_defrag_file: r/i=5/257 start=262144 len=262144
  btrfs-126062  [005] .....  4682.816028: btrfs_defrag_file: r/i=5/257 start=524288 len=262144
  btrfs-126062  [005] .....  4682.816028: btrfs_defrag_file: r/i=5/257 start=786432 len=262144
  btrfs-126062  [005] .....  4682.816028: btrfs_defrag_file: r/i=5/257 start=1048576 len=262144
  ...
  btrfs-126062  [005] .....  4682.816043: btrfs_defrag_file: r/i=5/257 start=67108864 len=262144

But with this patch there will be just one loop, then directly to the
end of the extent:

  btrfs-130471  [014] .....  5434.029558: defrag_one_cluster: r/i=5/257 start=0 len=262144
  btrfs-130471  [014] .....  5434.029559: defrag_one_cluster: r/i=5/257 start=67108864 len=16384

CC: stable@vger.kernel.org # 5.16
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 9 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1174,8 +1174,10 @@ struct defrag_target_range {
 static int defrag_collect_targets(struct btrfs_inode *inode,
 				  u64 start, u64 len, u32 extent_thresh,
 				  u64 newer_than, bool do_compress,
-				  bool locked, struct list_head *target_list)
+				  bool locked, struct list_head *target_list,
+				  u64 *last_scanned_ret)
 {
+	bool last_is_target = false;
 	u64 cur = start;
 	int ret = 0;
 
@@ -1185,6 +1187,7 @@ static int defrag_collect_targets(struct
 		bool next_mergeable = true;
 		u64 range_len;
 
+		last_is_target = false;
 		em = defrag_lookup_extent(&inode->vfs_inode, cur, locked);
 		if (!em)
 			break;
@@ -1267,6 +1270,7 @@ static int defrag_collect_targets(struct
 		}
 
 add:
+		last_is_target = true;
 		range_len = min(extent_map_end(em), start + len) - cur;
 		/*
 		 * This one is a good target, check if it can be merged into
@@ -1310,6 +1314,17 @@ next:
 			kfree(entry);
 		}
 	}
+	if (!ret && last_scanned_ret) {
+		/*
+		 * If the last extent is not a target, the caller can skip to
+		 * the end of that extent.
+		 * Otherwise, we can only go the end of the specified range.
+		 */
+		if (!last_is_target)
+			*last_scanned_ret = max(cur, *last_scanned_ret);
+		else
+			*last_scanned_ret = max(start + len, *last_scanned_ret);
+	}
 	return ret;
 }
 
@@ -1368,7 +1383,8 @@ static int defrag_one_locked_target(stru
 }
 
 static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
-			    u32 extent_thresh, u64 newer_than, bool do_compress)
+			    u32 extent_thresh, u64 newer_than, bool do_compress,
+			    u64 *last_scanned_ret)
 {
 	struct extent_state *cached_state = NULL;
 	struct defrag_target_range *entry;
@@ -1414,7 +1430,7 @@ static int defrag_one_range(struct btrfs
 	 */
 	ret = defrag_collect_targets(inode, start, len, extent_thresh,
 				     newer_than, do_compress, true,
-				     &target_list);
+				     &target_list, last_scanned_ret);
 	if (ret < 0)
 		goto unlock_extent;
 
@@ -1449,7 +1465,8 @@ static int defrag_one_cluster(struct btr
 			      u64 start, u32 len, u32 extent_thresh,
 			      u64 newer_than, bool do_compress,
 			      unsigned long *sectors_defragged,
-			      unsigned long max_sectors)
+			      unsigned long max_sectors,
+			      u64 *last_scanned_ret)
 {
 	const u32 sectorsize = inode->root->fs_info->sectorsize;
 	struct defrag_target_range *entry;
@@ -1460,7 +1477,7 @@ static int defrag_one_cluster(struct btr
 	BUILD_BUG_ON(!IS_ALIGNED(CLUSTER_SIZE, PAGE_SIZE));
 	ret = defrag_collect_targets(inode, start, len, extent_thresh,
 				     newer_than, do_compress, false,
-				     &target_list);
+				     &target_list, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -1477,6 +1494,15 @@ static int defrag_one_cluster(struct btr
 			range_len = min_t(u32, range_len,
 				(max_sectors - *sectors_defragged) * sectorsize);
 
+		/*
+		 * If defrag_one_range() has updated last_scanned_ret,
+		 * our range may already be invalid (e.g. hole punched).
+		 * Skip if our range is before last_scanned_ret, as there is
+		 * no need to defrag the range anymore.
+		 */
+		if (entry->start + range_len <= *last_scanned_ret)
+			continue;
+
 		if (ra)
 			page_cache_sync_readahead(inode->vfs_inode.i_mapping,
 				ra, NULL, entry->start >> PAGE_SHIFT,
@@ -1489,7 +1515,8 @@ static int defrag_one_cluster(struct btr
 		 * accounting.
 		 */
 		ret = defrag_one_range(inode, entry->start, range_len,
-				       extent_thresh, newer_than, do_compress);
+				       extent_thresh, newer_than, do_compress,
+				       last_scanned_ret);
 		if (ret < 0)
 			break;
 		*sectors_defragged += range_len >>
@@ -1500,6 +1527,8 @@ out:
 		list_del_init(&entry->list);
 		kfree(entry);
 	}
+	if (ret >= 0)
+		*last_scanned_ret = max(*last_scanned_ret, start + len);
 	return ret;
 }
 
@@ -1585,6 +1614,7 @@ int btrfs_defrag_file(struct inode *inod
 
 	while (cur < last_byte) {
 		const unsigned long prev_sectors_defragged = sectors_defragged;
+		u64 last_scanned = cur;
 		u64 cluster_end;
 
 		/* The cluster size 256K should always be page aligned */
@@ -1614,8 +1644,8 @@ int btrfs_defrag_file(struct inode *inod
 			BTRFS_I(inode)->defrag_compress = compress_type;
 		ret = defrag_one_cluster(BTRFS_I(inode), ra, cur,
 				cluster_end + 1 - cur, extent_thresh,
-				newer_than, do_compress,
-				&sectors_defragged, max_to_defrag);
+				newer_than, do_compress, &sectors_defragged,
+				max_to_defrag, &last_scanned);
 
 		if (sectors_defragged > prev_sectors_defragged)
 			balance_dirty_pages_ratelimited(inode->i_mapping);
@@ -1623,7 +1653,7 @@ int btrfs_defrag_file(struct inode *inod
 		btrfs_inode_unlock(inode, 0);
 		if (ret < 0)
 			break;
-		cur = cluster_end + 1;
+		cur = max(cluster_end + 1, last_scanned);
 		if (ret > 0) {
 			ret = 0;
 			break;



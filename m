Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B15D4B1EA2
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 07:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbiBKGmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 01:42:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiBKGmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 01:42:05 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DFD108B;
        Thu, 10 Feb 2022 22:42:04 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 59B581F3A6;
        Fri, 11 Feb 2022 06:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644561723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5agpn8SSQ2ZS95w4adiIiliOAUBKioisCXUPuhLxlvo=;
        b=aPPy7FpLVnFhIWnoK2oq+VINCTzLrRgmMdoNiz0yqbGtymTaLAsTgWjQRhZtKHTUZLI3ZB
        JeNKx0XVCy5DcC7jKs4kFzLdeR67flJ1QXjSII7K/x9eLWu3EfSDJ0gsxkkQYKNFl0L79g
        McmpvrwWPj4Fiu5uidCyJxtkxYjfXok=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4ABA813345;
        Fri, 11 Feb 2022 06:42:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id AFTOBToFBmLmUAAAMHmgww
        (envelope-from <wqu@suse.com>); Fri, 11 Feb 2022 06:42:02 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v4 1/5] btrfs: defrag: allow defrag_one_cluster() to skip large extent which is not a target
Date:   Fri, 11 Feb 2022 14:41:39 +0800
Message-Id: <7eb1b68aa7fee656d18dc552c3557cc1be05be68.1644561438.git.wqu@suse.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <cover.1644561438.git.wqu@suse.com>
References: <cover.1644561438.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org # 5.16
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 50 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e7a284239393..fa4d29026275 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1204,9 +1204,11 @@ struct defrag_target_range {
  */
 static int defrag_collect_targets(struct btrfs_inode *inode,
 				  u64 start, u64 len, u32 extent_thresh,
-				  u64 newer_than, bool do_compress,
-				  bool locked, struct list_head *target_list)
+				  u64 newer_than, bool do_compress, bool locked,
+				  struct list_head *target_list,
+				  u64 *last_scanned_ret)
 {
+	bool last_is_target = false;
 	u64 cur = start;
 	int ret = 0;
 
@@ -1216,6 +1218,7 @@ static int defrag_collect_targets(struct btrfs_inode *inode,
 		bool next_mergeable = true;
 		u64 range_len;
 
+		last_is_target = false;
 		em = defrag_lookup_extent(&inode->vfs_inode, cur, locked);
 		if (!em)
 			break;
@@ -1298,6 +1301,7 @@ static int defrag_collect_targets(struct btrfs_inode *inode,
 		}
 
 add:
+		last_is_target = true;
 		range_len = min(extent_map_end(em), start + len) - cur;
 		/*
 		 * This one is a good target, check if it can be merged into
@@ -1341,6 +1345,17 @@ static int defrag_collect_targets(struct btrfs_inode *inode,
 			kfree(entry);
 		}
 	}
+	if (!ret && last_scanned_ret) {
+		/*
+		 * If the last extent is not a target, the caller can skip to
+		 * the end of that extent.
+		 * Otherwise, we can only go the end of the spcified range.
+		 */
+		if (!last_is_target)
+			*last_scanned_ret = max(cur, *last_scanned_ret);
+		else
+			*last_scanned_ret = max(start + len, *last_scanned_ret);
+	}
 	return ret;
 }
 
@@ -1400,7 +1415,8 @@ static int defrag_one_locked_target(struct btrfs_inode *inode,
 }
 
 static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
-			    u32 extent_thresh, u64 newer_than, bool do_compress)
+			    u32 extent_thresh, u64 newer_than, bool do_compress,
+			    u64 *last_scanned_ret)
 {
 	struct extent_state *cached_state = NULL;
 	struct defrag_target_range *entry;
@@ -1446,7 +1462,7 @@ static int defrag_one_range(struct btrfs_inode *inode, u64 start, u32 len,
 	 */
 	ret = defrag_collect_targets(inode, start, len, extent_thresh,
 				     newer_than, do_compress, true,
-				     &target_list);
+				     &target_list, last_scanned_ret);
 	if (ret < 0)
 		goto unlock_extent;
 
@@ -1481,7 +1497,8 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 			      u64 start, u32 len, u32 extent_thresh,
 			      u64 newer_than, bool do_compress,
 			      unsigned long *sectors_defragged,
-			      unsigned long max_sectors)
+			      unsigned long max_sectors,
+			      u64 *last_scanned_ret)
 {
 	const u32 sectorsize = inode->root->fs_info->sectorsize;
 	struct defrag_target_range *entry;
@@ -1491,7 +1508,7 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 
 	ret = defrag_collect_targets(inode, start, len, extent_thresh,
 				     newer_than, do_compress, false,
-				     &target_list);
+				     &target_list, NULL);
 	if (ret < 0)
 		goto out;
 
@@ -1508,6 +1525,15 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
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
@@ -1520,7 +1546,8 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 		 * accounting.
 		 */
 		ret = defrag_one_range(inode, entry->start, range_len,
-				       extent_thresh, newer_than, do_compress);
+				       extent_thresh, newer_than, do_compress,
+				       last_scanned_ret);
 		if (ret < 0)
 			break;
 		*sectors_defragged += range_len >>
@@ -1531,6 +1558,8 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
 		list_del_init(&entry->list);
 		kfree(entry);
 	}
+	if (ret >= 0)
+		*last_scanned_ret = max(*last_scanned_ret, start + len);
 	return ret;
 }
 
@@ -1616,6 +1645,7 @@ int btrfs_defrag_file(struct inode *inode, struct file_ra_state *ra,
 
 	while (cur < last_byte) {
 		const unsigned long prev_sectors_defragged = sectors_defragged;
+		u64 last_scanned = cur;
 		u64 cluster_end;
 
 		if (btrfs_defrag_cancelled(fs_info)) {
@@ -1642,8 +1672,8 @@ int btrfs_defrag_file(struct inode *inode, struct file_ra_state *ra,
 			BTRFS_I(inode)->defrag_compress = compress_type;
 		ret = defrag_one_cluster(BTRFS_I(inode), ra, cur,
 				cluster_end + 1 - cur, extent_thresh,
-				newer_than, do_compress,
-				&sectors_defragged, max_to_defrag);
+				newer_than, do_compress, &sectors_defragged,
+				max_to_defrag, &last_scanned);
 
 		if (sectors_defragged > prev_sectors_defragged)
 			balance_dirty_pages_ratelimited(inode->i_mapping);
@@ -1651,7 +1681,7 @@ int btrfs_defrag_file(struct inode *inode, struct file_ra_state *ra,
 		btrfs_inode_unlock(inode, 0);
 		if (ret < 0)
 			break;
-		cur = cluster_end + 1;
+		cur = max(cluster_end + 1, last_scanned);
 		if (ret > 0) {
 			ret = 0;
 			break;
-- 
2.35.0


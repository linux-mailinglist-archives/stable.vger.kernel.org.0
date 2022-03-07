Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0E74CF852
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238582AbiCGJws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240054AbiCGJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26DA73052;
        Mon,  7 Mar 2022 01:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A034B810B2;
        Mon,  7 Mar 2022 09:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0D4C340E9;
        Mon,  7 Mar 2022 09:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646240;
        bh=xALdneTlso1QEjaL6Uacxm+MI5zbasQ9+HURUtcCeQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrlKvgJ5RrunnA546Jc2VrPIq4cpbAhONvHvV3fq86g4Kr9i9nee7s8xIYTKSeSHj
         8pUWnV4NgkWy+EKyT6p4RhPd0u/DQM2YlhAN+xWO/SeLi4SgD0Wv5RDr9XasSklp0n
         g4tX18bRj0o2o9WuNboNfatFHbqmeuj5RntTZdnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.15 172/262] btrfs: fix ENOSPC failure when attempting direct IO write into NOCOW range
Date:   Mon,  7 Mar 2022 10:18:36 +0100
Message-Id: <20220307091707.277494732@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit f0bfa76a11e93d0fe2c896fcb566568c5e8b5d3f upstream.

When doing a direct IO write against a file range that either has
preallocated extents in that range or has regular extents and the file
has the NOCOW attribute set, the write fails with -ENOSPC when all of
the following conditions are met:

1) There are no data blocks groups with enough free space matching
   the size of the write;

2) There's not enough unallocated space for allocating a new data block
   group;

3) The extents in the target file range are not shared, neither through
   snapshots nor through reflinks.

This is wrong because a NOCOW write can be done in such case, and in fact
it's possible to do it using a buffered IO write, since when failing to
allocate data space, the buffered IO path checks if a NOCOW write is
possible.

The failure in direct IO write path comes from the fact that early on,
at btrfs_dio_iomap_begin(), we try to allocate data space for the write
and if it that fails we return the error and stop - we never check if we
can do NOCOW. But later, at btrfs_get_blocks_direct_write(), we check
if we can do a NOCOW write into the range, or a subset of the range, and
then release the previously reserved data space.

Fix this by doing the data reservation only if needed, when we must COW,
at btrfs_get_blocks_direct_write() instead of doing it at
btrfs_dio_iomap_begin(). This also simplifies a bit the logic and removes
the inneficiency of doing unnecessary data reservations.

The following example test script reproduces the problem:

  $ cat dio-nocow-enospc.sh
  #!/bin/bash

  DEV=/dev/sdj
  MNT=/mnt/sdj

  # Use a small fixed size (1G) filesystem so that it's quick to fill
  # it up.
  # Make sure the mixed block groups feature is not enabled because we
  # later want to not have more space available for allocating data
  # extents but still have enough metadata space free for the file writes.
  mkfs.btrfs -f -b $((1024 * 1024 * 1024)) -O ^mixed-bg $DEV
  mount $DEV $MNT

  # Create our test file with the NOCOW attribute set.
  touch $MNT/foobar
  chattr +C $MNT/foobar

  # Now fill in all unallocated space with data for our test file.
  # This will allocate a data block group that will be full and leave
  # no (or a very small amount of) unallocated space in the device, so
  # that it will not be possible to allocate a new block group later.
  echo
  echo "Creating test file with initial data..."
  xfs_io -c "pwrite -S 0xab -b 1M 0 900M" $MNT/foobar

  # Now try a direct IO write against file range [0, 10M[.
  # This should succeed since this is a NOCOW file and an extent for the
  # range was previously allocated.
  echo
  echo "Trying direct IO write over allocated space..."
  xfs_io -d -c "pwrite -S 0xcd -b 10M 0 10M" $MNT/foobar

  umount $MNT

When running the test:

  $ ./dio-nocow-enospc.sh
  (...)

  Creating test file with initial data...
  wrote 943718400/943718400 bytes at offset 0
  900 MiB, 900 ops; 0:00:01.43 (625.526 MiB/sec and 625.5265 ops/sec)

  Trying direct IO write over allocated space...
  pwrite: No space left on device

A test case for fstests will follow, testing both this direct IO write
scenario as well as the buffered IO write scenario to make it less likely
to get future regressions on the buffered IO case.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |  142 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 78 insertions(+), 64 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,8 +60,6 @@ struct btrfs_iget_args {
 };
 
 struct btrfs_dio_data {
-	u64 reserve;
-	loff_t length;
 	ssize_t submitted;
 	struct extent_changeset *data_reserved;
 };
@@ -7763,6 +7761,10 @@ static int btrfs_get_blocks_direct_write
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em = *map;
+	int type;
+	u64 block_start, orig_start, orig_block_len, ram_bytes;
+	bool can_nocow = false;
+	bool space_reserved = false;
 	int ret = 0;
 
 	/*
@@ -7777,9 +7779,6 @@ static int btrfs_get_blocks_direct_write
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
 	    ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) &&
 	     em->block_start != EXTENT_MAP_HOLE)) {
-		int type;
-		u64 block_start, orig_start, orig_block_len, ram_bytes;
-
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			type = BTRFS_ORDERED_PREALLOC;
 		else
@@ -7789,53 +7788,92 @@ static int btrfs_get_blocks_direct_write
 
 		if (can_nocow_extent(inode, start, &len, &orig_start,
 				     &orig_block_len, &ram_bytes, false) == 1 &&
-		    btrfs_inc_nocow_writers(fs_info, block_start)) {
-			struct extent_map *em2;
+		    btrfs_inc_nocow_writers(fs_info, block_start))
+			can_nocow = true;
+	}
 
-			em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
-						      orig_start, block_start,
-						      len, orig_block_len,
-						      ram_bytes, type);
+	if (can_nocow) {
+		struct extent_map *em2;
+
+		/* We can NOCOW, so only need to reserve metadata space. */
+		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
+		if (ret < 0) {
+			/* Our caller expects us to free the input extent map. */
+			free_extent_map(em);
+			*map = NULL;
 			btrfs_dec_nocow_writers(fs_info, block_start);
-			if (type == BTRFS_ORDERED_PREALLOC) {
-				free_extent_map(em);
-				*map = em = em2;
-			}
+			goto out;
+		}
+		space_reserved = true;
 
-			if (em2 && IS_ERR(em2)) {
-				ret = PTR_ERR(em2);
-				goto out;
-			}
-			/*
-			 * For inode marked NODATACOW or extent marked PREALLOC,
-			 * use the existing or preallocated extent, so does not
-			 * need to adjust btrfs_space_info's bytes_may_use.
-			 */
-			btrfs_free_reserved_data_space_noquota(fs_info, len);
-			goto skip_cow;
+		em2 = btrfs_create_dio_extent(BTRFS_I(inode), start, len,
+					      orig_start, block_start,
+					      len, orig_block_len,
+					      ram_bytes, type);
+		btrfs_dec_nocow_writers(fs_info, block_start);
+		if (type == BTRFS_ORDERED_PREALLOC) {
+			free_extent_map(em);
+			*map = em = em2;
 		}
-	}
 
-	/* this will cow the extent */
-	free_extent_map(em);
-	*map = em = btrfs_new_extent_direct(BTRFS_I(inode), start, len);
-	if (IS_ERR(em)) {
-		ret = PTR_ERR(em);
-		goto out;
+		if (IS_ERR(em2)) {
+			ret = PTR_ERR(em2);
+			goto out;
+		}
+	} else {
+		const u64 prev_len = len;
+
+		/* Our caller expects us to free the input extent map. */
+		free_extent_map(em);
+		*map = NULL;
+
+		/* We have to COW, so need to reserve metadata and data space. */
+		ret = btrfs_delalloc_reserve_space(BTRFS_I(inode),
+						   &dio_data->data_reserved,
+						   start, len);
+		if (ret < 0)
+			goto out;
+		space_reserved = true;
+
+		em = btrfs_new_extent_direct(BTRFS_I(inode), start, len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+		*map = em;
+		len = min(len, em->len - (start - em->start));
+		if (len < prev_len)
+			btrfs_delalloc_release_space(BTRFS_I(inode),
+						     dio_data->data_reserved,
+						     start + len, prev_len - len,
+						     true);
 	}
 
-	len = min(len, em->len - (start - em->start));
+	/*
+	 * We have created our ordered extent, so we can now release our reservation
+	 * for an outstanding extent.
+	 */
+	btrfs_delalloc_release_extents(BTRFS_I(inode), len);
 
-skip_cow:
 	/*
 	 * Need to update the i_size under the extent lock so buffered
 	 * readers will get the updated i_size when we unlock.
 	 */
 	if (start + len > i_size_read(inode))
 		i_size_write(inode, start + len);
-
-	dio_data->reserve -= len;
 out:
+	if (ret && space_reserved) {
+		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
+		if (can_nocow) {
+			btrfs_delalloc_release_metadata(BTRFS_I(inode), len, true);
+		} else {
+			btrfs_delalloc_release_space(BTRFS_I(inode),
+						     dio_data->data_reserved,
+						     start, len, true);
+			extent_changeset_free(dio_data->data_reserved);
+			dio_data->data_reserved = NULL;
+		}
+	}
 	return ret;
 }
 
@@ -7877,18 +7915,6 @@ static int btrfs_dio_iomap_begin(struct
 	if (!dio_data)
 		return -ENOMEM;
 
-	dio_data->length = length;
-	if (write) {
-		dio_data->reserve = round_up(length, fs_info->sectorsize);
-		ret = btrfs_delalloc_reserve_space(BTRFS_I(inode),
-				&dio_data->data_reserved,
-				start, dio_data->reserve);
-		if (ret) {
-			extent_changeset_free(dio_data->data_reserved);
-			kfree(dio_data);
-			return ret;
-		}
-	}
 	iomap->private = dio_data;
 
 
@@ -7981,14 +8007,8 @@ unlock_err:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			     &cached_state);
 err:
-	if (dio_data) {
-		btrfs_delalloc_release_space(BTRFS_I(inode),
-				dio_data->data_reserved, start,
-				dio_data->reserve, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), dio_data->reserve);
-		extent_changeset_free(dio_data->data_reserved);
-		kfree(dio_data);
-	}
+	kfree(dio_data);
+
 	return ret;
 }
 
@@ -8018,14 +8038,8 @@ static int btrfs_dio_iomap_end(struct in
 		ret = -ENOTBLK;
 	}
 
-	if (write) {
-		if (dio_data->reserve)
-			btrfs_delalloc_release_space(BTRFS_I(inode),
-					dio_data->data_reserved, pos,
-					dio_data->reserve, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), dio_data->length);
+	if (write)
 		extent_changeset_free(dio_data->data_reserved);
-	}
 out:
 	kfree(dio_data);
 	iomap->private = NULL;



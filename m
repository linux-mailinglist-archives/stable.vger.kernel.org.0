Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DD1404FC0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352264AbhIIMW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352440AbhIIMTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A231261207;
        Thu,  9 Sep 2021 11:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188220;
        bh=V+HxHlmf1wlr2xD5gyxUWjT5ND0YrtyERCOvWQexXhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rc2ar9GdgDObY869ZezYNRtBQcqPhfrdwpzK2DvqrP667OygyBo8StN9bGVBA1C1S
         bNu3looWcDGLrOUB7jFakQtucDIl0mjonPaOXgdqSiTxY7nEvNnoBy64Px6JJm7Gd9
         HsL+lpVNgJTiWlX0d7TilI4FBn+8zgcCAp6xYrRPGSrjvrw1+IWwzzhBtWGxbIk4AT
         KNoKEO8IT7j2y+jK1aqXhqHEWbC3ZQvJMXDO/rc02a+5xOusIYoswVwKID3gP4d8OO
         7Baie1dxxoza07e6V9liJVf9f5HtSW7TvYwSaA74czGzAWiGU/LS44rIk9UiXjYx2u
         Ji/xpwwpg6uLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 174/219] btrfs: subpage: fix false alert when relocating partial preallocated data extents
Date:   Thu,  9 Sep 2021 07:45:50 -0400
Message-Id: <20210909114635.143983-174-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit e3c62324e470c0a89df966603156b34fccd01708 ]

[BUG]
When relocating partial preallocated data extents (part of the
preallocated extent is written) for subpage, it can cause the following
false alert and make the relocation to fail:

  BTRFS info (device dm-3): balance: start -d
  BTRFS info (device dm-3): relocating block group 13631488 flags data
  BTRFS warning (device dm-3): csum failed root -9 ino 257 off 4096 csum 0x98757625 expected csum 0x00000000 mirror 1
  BTRFS error (device dm-3): bdev /dev/mapper/arm_nvme-test errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
  BTRFS warning (device dm-3): csum failed root -9 ino 257 off 4096 csum 0x98757625 expected csum 0x00000000 mirror 1
  BTRFS error (device dm-3): bdev /dev/mapper/arm_nvme-test errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
  BTRFS info (device dm-3): balance: ended with status: -5

The minimal script to reproduce looks like this:

  mkfs.btrfs -f -s 4k $dev
  mount $dev -o nospace_cache $mnt
  xfs_io -f -c "falloc 0 8k" $mnt/file
  xfs_io -f -c "pwrite 0 4k" $mnt/file
  btrfs balance start -d $mnt

[CAUSE]
Function btrfs_verify_data_csum() checks if the full range has
EXTENT_NODATASUM bit for data reloc inode, if *all* bytes of the range
have EXTENT_NODATASUM bit, then it skip the range.

This works pretty well for regular sectorsize, as in that case
btrfs_verify_data_csum() is called for each sector, thus no problem at
all.

But for subpage case, btrfs_verify_data_csum() is called on each bvec,
which can contain several sectors, and since it checks *all* bytes for
EXTENT_NODATASUM bit, if we have some range with csum, then we will
continue checking all the sectors.

For the preallocated sectors, it doesn't have any csum, thus obviously
the csum won't match and cause the false alert.

[FIX]
Move the EXTENT_NODATASUM check into the main loop, so that we can check
each sector for EXTENT_NODATASUM bit for subpage case.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1fd88137003..1477cd4f3eac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3276,19 +3276,24 @@ int btrfs_verify_data_csum(struct btrfs_io_bio *io_bio, u32 bio_offset,
 	if (!root->fs_info->csum_root)
 		return 0;
 
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
-	    test_range_bit(io_tree, start, end, EXTENT_NODATASUM, 1, NULL)) {
-		clear_extent_bits(io_tree, start, end, EXTENT_NODATASUM);
-		return 0;
-	}
-
 	ASSERT(page_offset(page) <= start &&
 	       end <= page_offset(page) + PAGE_SIZE - 1);
 	for (pg_off = offset_in_page(start);
 	     pg_off < offset_in_page(end);
 	     pg_off += sectorsize, bio_offset += sectorsize) {
+		u64 file_offset = pg_off + page_offset(page);
 		int ret;
 
+		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		    test_range_bit(io_tree, file_offset,
+				   file_offset + sectorsize - 1,
+				   EXTENT_NODATASUM, 1, NULL)) {
+			/* Skip the range without csum for data reloc inode */
+			clear_extent_bits(io_tree, file_offset,
+					  file_offset + sectorsize - 1,
+					  EXTENT_NODATASUM);
+			continue;
+		}
 		ret = check_data_csum(inode, io_bio, bio_offset, page, pg_off,
 				      page_offset(page) + pg_off);
 		if (ret < 0)
-- 
2.30.2


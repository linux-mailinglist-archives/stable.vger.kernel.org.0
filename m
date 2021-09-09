Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586F4404D0C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhIIMAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239669AbhIIL4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:56:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7013613C8;
        Thu,  9 Sep 2021 11:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187918;
        bh=Q7+PDq3PcKfGT0wocrGwCTzWvfRbCJ1Xva38avQb21A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8cIkzSflDmK/l7N0q06BZBUakJvGZ403/4zn2t75dWGT+LhjyZmV1uuJXaPM+a1r
         uLgcTr/kYkRMh7iIYCskpaqVWh5qiH8L8F6xza85rFUoK+PxeBy34br7nK2CQZGZVR
         Kh3pKZBu2Kwwp9gCwJd4nugqiDnsLsJW30qdKuwNEvBBK06K9BM+B57ivi5CYV50XJ
         BJ8VeBdZ2KZ/TBSLc+K3BW8Dy8j2OumKAFcYwGN/UeiLEJevaHOJ39GvrOcFOJF6Kg
         2jwlcGB3vdFg49/PJrGcXDxr73QtJ4Ry97LHgvJYR+/1eKq2EtjuugZo9ymgGAM74o
         AEF9tdArE3kFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 193/252] btrfs: grab correct extent map for subpage compressed extent read
Date:   Thu,  9 Sep 2021 07:40:07 -0400
Message-Id: <20210909114106.141462-193-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 557023ea9f06baf2659b232b08b8e8711f7001a6 ]

[BUG]
When subpage compressed read write support is enabled, btrfs/038 always
fails with EIO.

A simplified script can easily trigger the problem:

  mkfs.btrfs -f -s 4k $dev
  mount $dev $mnt -o compress=lzo

  xfs_io -f -c "truncate 118811" $mnt/foo
  xfs_io -c "pwrite -S 0x0d -b 39987 92267 39987" $mnt/foo > /dev/null

  sync
  btrfs subvolume snapshot -r $mnt $mnt/mysnap1

  xfs_io -c "pwrite -S 0x3e -b 80000 200000 80000" $mnt/foo > /dev/null
  sync

  xfs_io -c "pwrite -S 0xdc -b 10000 250000 10000" $mnt/foo > /dev/null
  xfs_io -c "pwrite -S 0xff -b 10000 300000 10000" $mnt/foo > /dev/null

  sync
  btrfs subvolume snapshot -r $mnt $mnt/mysnap2

  cat $mnt/mysnap2/foo
  # Above cat will fail due to EIO

[CAUSE]
The problem is in btrfs_submit_compressed_read().

When it tries to grab the extent map of the read range, it uses the
following call:

	em = lookup_extent_mapping(em_tree,
  				   page_offset(bio_first_page_all(bio)),
				   fs_info->sectorsize);

The problem is in the page_offset(bio_first_page_all(bio)) part.

The offending inode has the following file extent layout

        item 10 key (257 EXTENT_DATA 131072) itemoff 15639 itemsize 53
                generation 8 type 1 (regular)
                extent data disk byte 13680640 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 11 key (257 EXTENT_DATA 135168) itemoff 15586 itemsize 53
                generation 8 type 1 (regular)
                extent data disk byte 0 nr 0
        item 12 key (257 EXTENT_DATA 196608) itemoff 15533 itemsize 53
                generation 8 type 1 (regular)
                extent data disk byte 13676544 nr 4096
                extent data offset 0 nr 53248 ram 86016
                extent compression 2 (lzo)

And the bio passed in has the following parameters:

page_offset(bio_first_page_all(bio))	= 131072
bio_first_bvec_all(bio)->bv_offset	= 65536

If we use page_offset(bio_first_page_all(bio) without adding bv_offset,
we will get an extent map for file offset 131072, not 196608.

This means we read uncompressed data from disk, and later decompression
will definitely fail.

[FIX]
Take bv_offset into consideration when trying to grab an extent map.

And add an ASSERT() to ensure we're really getting a compressed extent.

Thankfully this won't affect anything but subpage, thus we only need to
ensure this patch get merged before we enabled basic subpage support.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 30d82cdf128c..ad700cf287c9 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -673,6 +673,7 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	struct page *page;
 	struct bio *comp_bio;
 	u64 cur_disk_byte = bio->bi_iter.bi_sector << 9;
+	u64 file_offset;
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
@@ -682,15 +683,17 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	em_tree = &BTRFS_I(inode)->extent_tree;
 
+	file_offset = bio_first_bvec_all(bio)->bv_offset +
+		      page_offset(bio_first_page_all(bio));
+
 	/* we need the actual starting offset of this extent in the file */
 	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree,
-				   page_offset(bio_first_page_all(bio)),
-				   fs_info->sectorsize);
+	em = lookup_extent_mapping(em_tree, file_offset, fs_info->sectorsize);
 	read_unlock(&em_tree->lock);
 	if (!em)
 		return BLK_STS_IOERR;
 
+	ASSERT(em->compress_type != BTRFS_COMPRESS_NONE);
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(fs_info, compressed_len), GFP_NOFS);
 	if (!cb)
-- 
2.30.2


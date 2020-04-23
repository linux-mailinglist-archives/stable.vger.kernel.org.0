Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819571B6982
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgDWXYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48302 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgDWXG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:29 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004a0-Vl; Fri, 24 Apr 2020 00:06:25 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-00E6fy-7p; Fri, 24 Apr 2020 00:06:24 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jeff Mahoney" <jeffm@suse.com>, "David Sterba" <dsterba@suse.com>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>
Date:   Fri, 24 Apr 2020 00:04:10 +0100
Message-ID: <lsq.1587683028.369014986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 023/245] btrfs: cleanup, stop casting for
 extent_map->lookup everywhere
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 95617d69326ce386c95e33db7aeb832b45ee9f8f upstream.

Overloading extent_map->bdev to struct map_lookup * might have started out
as a means to an end, but it's a pattern that's used all over the place
now. Let's get rid of the casting and just add a union instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: drop changes in
 btrfs_start_trans_remove_block_group(),
 btrfs_update_commit_device_bytes_used()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -614,7 +614,7 @@ static void btrfs_dev_replace_update_dev
 		em = lookup_extent_mapping(em_tree, start, (u64)-1);
 		if (!em)
 			break;
-		map = (struct map_lookup *)em->bdev;
+		map = em->map_lookup;
 		for (i = 0; i < map->num_stripes; i++)
 			if (srcdev == map->stripes[i].dev)
 				map->stripes[i].dev = tgtdev;
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -76,7 +76,7 @@ void free_extent_map(struct extent_map *
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
 		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
-			kfree(em->bdev);
+			kfree(em->map_lookup);
 		kmem_cache_free(extent_map_cache, em);
 	}
 }
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -32,7 +32,15 @@ struct extent_map {
 	u64 block_len;
 	u64 generation;
 	unsigned long flags;
-	struct block_device *bdev;
+	union {
+		struct block_device *bdev;
+
+		/*
+		 * used for chunk mappings
+		 * flags & EXTENT_FLAG_FS_MAPPING must be set
+		 */
+		struct map_lookup *map_lookup;
+	};
 	atomic_t refs;
 	unsigned int compress_type;
 	struct list_head list;
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2637,7 +2637,7 @@ static noinline_for_stack int scrub_chun
 	if (!em)
 		return -EINVAL;
 
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	if (em->start != chunk_offset)
 		goto out;
 
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1047,7 +1047,7 @@ static int contains_pending_extent(struc
 		struct map_lookup *map;
 		int i;
 
-		map = (struct map_lookup *)em->bdev;
+		map = em->map_lookup;
 		for (i = 0; i < map->num_stripes; i++) {
 			if (map->stripes[i].dev != device)
 				continue;
@@ -2533,7 +2533,7 @@ static int btrfs_relocate_chunk(struct b
 
 	BUG_ON(!em || em->start > chunk_offset ||
 	       em->start + em->len < chunk_offset);
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 
 	for (i = 0; i < map->num_stripes; i++) {
 		ret = btrfs_free_dev_extent(trans, map->stripes[i].dev,
@@ -4322,7 +4322,7 @@ static int __btrfs_alloc_chunk(struct bt
 		goto error;
 	}
 	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
-	em->bdev = (struct block_device *)map;
+	em->map_lookup = map;
 	em->start = start;
 	em->len = num_bytes;
 	em->block_start = 0;
@@ -4405,7 +4405,7 @@ int btrfs_finish_chunk_alloc(struct btrf
 		return -EINVAL;
 	}
 
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	item_size = btrfs_chunk_item_size(map->num_stripes);
 	stripe_size = em->orig_block_len;
 
@@ -4547,7 +4547,7 @@ int btrfs_chunk_readonly(struct btrfs_ro
 		return 0;
 	}
 
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	for (i = 0; i < map->num_stripes; i++) {
 		if (!map->stripes[i].dev->writeable) {
 			readonly = 1;
@@ -4613,7 +4613,7 @@ int btrfs_num_copies(struct btrfs_fs_inf
 		return 1;
 	}
 
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
@@ -4649,7 +4649,7 @@ unsigned long btrfs_full_stripe_len(stru
 	BUG_ON(!em);
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_RAID6)) {
 		len = map->stripe_len * nr_data_stripes(map);
@@ -4672,7 +4672,7 @@ int btrfs_is_parity_mirror(struct btrfs_
 	BUG_ON(!em);
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
 			 BTRFS_BLOCK_GROUP_RAID6))
 		ret = 1;
@@ -4794,7 +4794,7 @@ static int __btrfs_map_block(struct btrf
 		return -EINVAL;
 	}
 
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 	offset = logical - em->start;
 
 	stripe_len = map->stripe_len;
@@ -5321,7 +5321,7 @@ int btrfs_rmap_block(struct btrfs_mappin
 		free_extent_map(em);
 		return -EIO;
 	}
-	map = (struct map_lookup *)em->bdev;
+	map = em->map_lookup;
 
 	length = em->len;
 	rmap_len = map->stripe_len;
@@ -5846,7 +5846,7 @@ static int read_one_chunk(struct btrfs_r
 	}
 
 	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
-	em->bdev = (struct block_device *)map;
+	em->map_lookup = map;
 	em->start = logical;
 	em->len = length;
 	em->orig_start = 0;


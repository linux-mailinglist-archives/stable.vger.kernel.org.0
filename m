Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5D22900F7
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394579AbgJPJKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405654AbgJPJKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:10:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 547432145D;
        Fri, 16 Oct 2020 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839434;
        bh=Wm/q6CAFr4QdVuUWEWSNQ+kHkd8ppf0OErtXzGdKLFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFlj3CYg/Y0w44AObhZzdpfPkc3EzF/fcg5O6k9c7KOXYjPDUDPdpk/UlgUJnYjMU
         PiSevi/GJ0A2wJDp19qNR+AEnbJhdycwbCS9Iz3ziiqYpeCIaSToe4bsZJ+f//EUcx
         ZMf1h/Zd4FO87vjUvb4sO7BqkHGug+tphp4AdjWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/22] btrfs: take overcommit into account in inc_block_group_ro
Date:   Fri, 16 Oct 2020 11:07:31 +0200
Message-Id: <20201016090437.481307537@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit a30a3d2067536cbcce26c055e70cc3a6ae4fd45c upstream

inc_block_group_ro does a calculation to see if we have enough room left
over if we mark this block group as read only in order to see if it's ok
to mark the block group as read only.

The problem is this calculation _only_ works for data, where our used is
always less than our total.  For metadata we will overcommit, so this
will almost always fail for metadata.

Fix this by exporting btrfs_can_overcommit, and then see if we have
enough space to remove the remaining free space in the block group we
are trying to mark read only.  If we do then we can mark this block
group as read only.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 38 ++++++++++++++++++++++++++------------
 fs/btrfs/space-info.c  | 18 ++++++++++--------
 fs/btrfs/space-info.h  |  3 +++
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index b167649f5f5de..ace49a999ecec 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1186,7 +1186,6 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 {
 	struct btrfs_space_info *sinfo = cache->space_info;
 	u64 num_bytes;
-	u64 sinfo_used;
 	u64 min_allocable_bytes;
 	int ret = -ENOSPC;
 
@@ -1213,20 +1212,38 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 
 	num_bytes = cache->key.offset - cache->reserved - cache->pinned -
 		    cache->bytes_super - btrfs_block_group_used(&cache->item);
-	sinfo_used = btrfs_space_info_used(sinfo, true);
 
 	/*
-	 * sinfo_used + num_bytes should always <= sinfo->total_bytes.
-	 *
-	 * Here we make sure if we mark this bg RO, we still have enough
-	 * free space as buffer (if min_allocable_bytes is not 0).
+	 * Data never overcommits, even in mixed mode, so do just the straight
+	 * check of left over space in how much we have allocated.
 	 */
-	if (sinfo_used + num_bytes + min_allocable_bytes <=
-	    sinfo->total_bytes) {
+	if (force) {
+		ret = 0;
+	} else if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA) {
+		u64 sinfo_used = btrfs_space_info_used(sinfo, true);
+
+		/*
+		 * Here we make sure if we mark this bg RO, we still have enough
+		 * free space as buffer.
+		 */
+		if (sinfo_used + num_bytes <= sinfo->total_bytes)
+			ret = 0;
+	} else {
+		/*
+		 * We overcommit metadata, so we need to do the
+		 * btrfs_can_overcommit check here, and we need to pass in
+		 * BTRFS_RESERVE_NO_FLUSH to give ourselves the most amount of
+		 * leeway to allow us to mark this block group as read only.
+		 */
+		if (btrfs_can_overcommit(cache->fs_info, sinfo, num_bytes,
+					 BTRFS_RESERVE_NO_FLUSH))
+			ret = 0;
+	}
+
+	if (!ret) {
 		sinfo->bytes_readonly += num_bytes;
 		cache->ro++;
 		list_add_tail(&cache->ro_list, &sinfo->ro_bgs);
-		ret = 0;
 	}
 out:
 	spin_unlock(&cache->lock);
@@ -1235,9 +1252,6 @@ static int inc_block_group_ro(struct btrfs_block_group_cache *cache, int force)
 		btrfs_info(cache->fs_info,
 			"unable to make block group %llu ro",
 			cache->key.objectid);
-		btrfs_info(cache->fs_info,
-			"sinfo_used=%llu bg_num_bytes=%llu min_allocable=%llu",
-			sinfo_used, num_bytes, min_allocable_bytes);
 		btrfs_dump_space_info(cache->fs_info, cache->space_info, 0, 0);
 	}
 	return ret;
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index e19e538d05f93..90500b6c41fc6 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -160,9 +160,9 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
 	return (global->size << 1);
 }
 
-static int can_overcommit(struct btrfs_fs_info *fs_info,
-			  struct btrfs_space_info *space_info, u64 bytes,
-			  enum btrfs_reserve_flush_enum flush)
+int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
+			 struct btrfs_space_info *space_info, u64 bytes,
+			 enum btrfs_reserve_flush_enum flush)
 {
 	u64 profile;
 	u64 avail;
@@ -227,7 +227,8 @@ void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 
 		/* Check and see if our ticket can be satisified now. */
 		if ((used + ticket->bytes <= space_info->total_bytes) ||
-		    can_overcommit(fs_info, space_info, ticket->bytes, flush)) {
+		    btrfs_can_overcommit(fs_info, space_info, ticket->bytes,
+					 flush)) {
 			btrfs_space_info_update_bytes_may_use(fs_info,
 							      space_info,
 							      ticket->bytes);
@@ -647,13 +648,14 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 		return to_reclaim;
 
 	to_reclaim = min_t(u64, num_online_cpus() * SZ_1M, SZ_16M);
-	if (can_overcommit(fs_info, space_info, to_reclaim,
-			   BTRFS_RESERVE_FLUSH_ALL))
+	if (btrfs_can_overcommit(fs_info, space_info, to_reclaim,
+				 BTRFS_RESERVE_FLUSH_ALL))
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
 
-	if (can_overcommit(fs_info, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
+	if (btrfs_can_overcommit(fs_info, space_info, SZ_1M,
+				 BTRFS_RESERVE_FLUSH_ALL))
 		expected = div_factor_fine(space_info->total_bytes, 95);
 	else
 		expected = div_factor_fine(space_info->total_bytes, 90);
@@ -1045,7 +1047,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 */
 	if (!pending_tickets &&
 	    ((used + orig_bytes <= space_info->total_bytes) ||
-	     can_overcommit(fs_info, space_info, orig_bytes, flush))) {
+	     btrfs_can_overcommit(fs_info, space_info, orig_bytes, flush))) {
 		btrfs_space_info_update_bytes_may_use(fs_info, space_info,
 						      orig_bytes);
 		ret = 0;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 8b9a1d8fefcb7..b9cffc62cafac 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -129,6 +129,9 @@ int btrfs_reserve_metadata_bytes(struct btrfs_root *root,
 				 enum btrfs_reserve_flush_enum flush);
 void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 				struct btrfs_space_info *space_info);
+int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
+			 struct btrfs_space_info *space_info, u64 bytes,
+			 enum btrfs_reserve_flush_enum flush);
 
 static inline void btrfs_space_info_free_bytes_may_use(
 				struct btrfs_fs_info *fs_info,
-- 
2.25.1




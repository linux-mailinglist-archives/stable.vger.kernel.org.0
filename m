Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E6F261BEC
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730976AbgIHTKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731212AbgIHQFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7E9624672;
        Tue,  8 Sep 2020 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579565;
        bh=KL/RnWFdKMBOtqrl2VD04BYDPvj9MiMytGRWijMGInc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWko5L8RGYr50jiWd8B6lwYl4P3imRCKY8QB3FkTYjZuocuNG1WAAvcH67se7V61a
         172a3GUX3buZL7N4TEaSwOOE+AH7rPBmJd9b0TEmAA2jJN4hS0ZIizljuylt0oQHVX
         3CVodfbqtVrffEBg1iG1VhltDSZMC6KKKn+4ZR6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 130/186] btrfs: block-group: fix free-space bitmap threshold
Date:   Tue,  8 Sep 2020 17:24:32 +0200
Message-Id: <20200908152247.941811240@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit e3e39c72b99f93bbd0420d38c858e7c4a061bb63 upstream.

[BUG]
After commit 9afc66498a0b ("btrfs: block-group: refactor how we read one
block group item"), cache->length is being assigned after calling
btrfs_create_block_group_cache. This causes a problem since
set_free_space_tree_thresholds calculates the free-space threshold to
decide if the free-space tree should convert from extents to bitmaps.

The current code calls set_free_space_tree_thresholds with cache->length
being 0, which then makes cache->bitmap_high_thresh zero. This implies
the system will always use bitmap instead of extents, which is not
desired if the block group is not fragmented.

This behavior can be seen by a test that expects to repair systems
with FREE_SPACE_EXTENT and FREE_SPACE_BITMAP, but the current code only
created FREE_SPACE_BITMAP.

[FIX]
Call set_free_space_tree_thresholds after setting cache->length. There
is now a WARN_ON in set_free_space_tree_thresholds to help preventing
the same mistake to happen again in the future.

Link: https://github.com/kdave/btrfs-progs/issues/251
Fixes: 9afc66498a0b ("btrfs: block-group: refactor how we read one block group item")
CC: stable@vger.kernel.org # 5.8+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/block-group.c     |    4 +++-
 fs/btrfs/free-space-tree.c |    4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1814,7 +1814,6 @@ static struct btrfs_block_group *btrfs_c
 
 	cache->fs_info = fs_info;
 	cache->full_stripe_len = btrfs_full_stripe_len(fs_info, start);
-	set_free_space_tree_thresholds(cache);
 
 	cache->discard_index = BTRFS_DISCARD_INDEX_UNUSED;
 
@@ -1928,6 +1927,8 @@ static int read_one_block_group(struct b
 	if (ret < 0)
 		goto error;
 
+	set_free_space_tree_thresholds(cache);
+
 	if (need_clear) {
 		/*
 		 * When we mount with old space cache, we need to
@@ -2148,6 +2149,7 @@ int btrfs_make_block_group(struct btrfs_
 		return -ENOMEM;
 
 	cache->length = size;
+	set_free_space_tree_thresholds(cache);
 	cache->used = bytes_used;
 	cache->flags = type;
 	cache->last_byte_to_unpin = (u64)-1;
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -22,6 +22,10 @@ void set_free_space_tree_thresholds(stru
 	size_t bitmap_size;
 	u64 num_bitmaps, total_bitmap_size;
 
+	if (WARN_ON(cache->length == 0))
+		btrfs_warn(cache->fs_info, "block group %llu length is zero",
+			   cache->start);
+
 	/*
 	 * We convert to bitmaps when the disk space required for using extents
 	 * exceeds that required for using bitmaps.



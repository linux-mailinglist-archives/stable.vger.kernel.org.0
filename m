Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0C24D86C
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 17:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgHUPUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 11:20:24 -0400
Received: from gateway24.websitewelcome.com ([192.185.50.91]:28825 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727808AbgHUPUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 11:20:23 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 3A0F11FEA
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 09:54:53 -0500 (CDT)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id 98RRkEmaFdbRz98RRk7nEd; Fri, 21 Aug 2020 09:54:53 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7RQ2hKgl1ruA2bCIsl6ftQlYVMZxZwpcaDvYoUrDx50=; b=eZRxoRgkbHLqOMgEZ42qkSDvDX
        Q84Xi+NFCE1L8GeeK86Yi/YI8tAASiJ5znZICE9p+nR6IYHv/dQwh3YOu7olXZeBygrMewlguCjlZ
        hw3wLo0iyqTDXw8N4l7PyDHyR7bLRP0x710MbDnJQy4jliHJB6aXlgZwcNGWdwIGYf5gWUSwFgwM2
        NibsmONu0HJRUZCkhE95l3f2OelMjJb0wf90suj/uBDoUEp3B08mzWIu7ZyGW0nOZPzBoJtzoAiRN
        bCz0/x5pAIw7bXUI0EhIsv+ks/yN/w/v4L6nRff4HkZr4Tqkf4j6IzeslWDdkmNbmRW89mm86SKd9
        bxb4ZmKA==;
Received: from [191.248.104.145] (port=54152 helo=hephaestus.suse.de)
        by br540.hostgator.com.br with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <marcos@mpdesouza.com>)
        id 1k98RQ-001hcI-MA; Fri, 21 Aug 2020 11:54:53 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     linux-kernel@vger.kernel.org
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] btrfs: block-group: Fix free-space bitmap threshould
Date:   Fri, 21 Aug 2020 11:54:44 -0300
Message-Id: <20200821145444.25791-1-marcos@mpdesouza.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - br540.hostgator.com.br
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mpdesouza.com
X-BWhitelist: no
X-Source-IP: 191.248.104.145
X-Source-L: No
X-Exim-ID: 1k98RQ-001hcI-MA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (hephaestus.suse.de) [191.248.104.145]:54152
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 3
X-Source-Cap: bXBkZXNvNTM7bXBkZXNvNTM7YnI1NDAuaG9zdGdhdG9yLmNvbS5icg==
X-Local-Domain: yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[BUG]
After commit 9afc66498a0b ("btrfs: block-group: refactor how we read one
block group item"), cache->length is being assigned after calling
btrfs_create_block_group_cache. This causes a problem since
set_free_space_tree_thresholds is calculate the free-space threshould to
decide is the free-space tree should convert from extents to bitmaps.

The current code calls set_free_space_tree_thresholds with cache->length
being 0, which then makes cache->bitmap_high_thresh being zero. This
implies the system will always use bitmap instead of extents, which is
not desired if the block group is not fragmented.

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
---
 Changes from v2:
 * Add a WARN_ON and changed the warn message (Filipe)
 * Add a Reviewed-by tag from Filipe
 Changes from v1:
 * Add warn message (Qu)
 * Add a Reviewed-by tag from Qu

 fs/btrfs/block-group.c     | 4 +++-
 fs/btrfs/free-space-tree.c | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 44fdfa2eeb2e..01e8ba1da1d3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1798,7 +1798,6 @@ static struct btrfs_block_group *btrfs_create_block_group_cache(
 
 	cache->fs_info = fs_info;
 	cache->full_stripe_len = btrfs_full_stripe_len(fs_info, start);
-	set_free_space_tree_thresholds(cache);
 
 	cache->discard_index = BTRFS_DISCARD_INDEX_UNUSED;
 
@@ -1908,6 +1907,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 
 	read_block_group_item(cache, path, key);
 
+	set_free_space_tree_thresholds(cache);
+
 	if (need_clear) {
 		/*
 		 * When we mount with old space cache, we need to
@@ -2128,6 +2129,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 		return -ENOMEM;
 
 	cache->length = size;
+	set_free_space_tree_thresholds(cache);
 	cache->used = bytes_used;
 	cache->flags = type;
 	cache->last_byte_to_unpin = (u64)-1;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 8b1f5c8897b7..f072c106b82b 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -22,6 +22,10 @@ void set_free_space_tree_thresholds(struct btrfs_block_group *cache)
 	size_t bitmap_size;
 	u64 num_bitmaps, total_bitmap_size;
 
+	if (WARN_ON(cache->length == 0))
+		btrfs_warn(cache->fs_info, "block group %llu length is zero",
+						cache->start);
+
 	/*
 	 * We convert to bitmaps when the disk space required for using extents
 	 * exceeds that required for using bitmaps.
-- 
2.28.0


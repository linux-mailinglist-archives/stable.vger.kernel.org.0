Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DEE24D6E0
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgHUOEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 10:04:16 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.185]:45831 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgHUOEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 10:04:14 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 2700735BC4
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 08:17:36 -0500 (CDT)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id 96vIkdd1dOIGp96vIkG07Y; Fri, 21 Aug 2020 08:17:36 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xtc+G1DaWGkKbXWnUOWf167W2t+UmfSpww3W6XZ4cyc=; b=HragkfxhBd0z+dqJI5+YRh33ZA
        kivKYJyl1tgaSVr8mlekUBb3p4HffZx8hqOvByoQtqhk4qGcxPSZelLyjs/H5LykD8FJcZm7rC1I5
        zEYa2QpBb2DlvFzBunnHXpuYt69NTPNKitWfXcdyAnuPfRXE5m6GW/TEZ8QsE6dS3ct8VHEDomDFz
        n2wUW1BrE9sXSpqQXj8QrnPee3WN/mV236C5kYe/jt3Qwky/3X7s3gnKTsI7l9ysZaE34dI/L9DCQ
        V0HaGh8ZDep4VJp/f2ZCxVAtpECX3EW+IuwKkeL7rathVVhw/NFI3LdP051w8LTf2JdEcrBWwp1zi
        2ZO6VLnw==;
Received: from [191.248.104.145] (port=50474 helo=hephaestus.suse.de)
        by br540.hostgator.com.br with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <marcos@mpdesouza.com>)
        id 1k96vH-000ceu-ID; Fri, 21 Aug 2020 10:17:35 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     linux-kernel@vger.kernel.org
Cc:     dsterba@suse.com, wqu@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] btrfs: block-group: Fix free-space bitmap threshould
Date:   Fri, 21 Aug 2020 10:17:27 -0300
Message-Id: <20200821131727.6883-1-marcos@mpdesouza.com>
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
X-Exim-ID: 1k96vH-000ceu-ID
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (hephaestus.suse.de) [191.248.104.145]:50474
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 1
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
Call set_free_space_tree_thresholds after setting cache->length.

Link: https://github.com/kdave/btrfs-progs/issues/251
Fixes: 9afc66498a0b ("btrfs: block-group: refactor how we read one block group item")
CC: stable@vger.kernel.org # 5.8+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---

 Changes from v1:
 * Add a warning in set_free_space_tree_thresholds when bg->length is zero (Qu)

 fs/btrfs/block-group.c     | 4 +++-
 fs/btrfs/free-space-tree.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

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
index 8b1f5c8897b7..1d191fbc754b 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -22,6 +22,9 @@ void set_free_space_tree_thresholds(struct btrfs_block_group *cache)
 	size_t bitmap_size;
 	u64 num_bitmaps, total_bitmap_size;
 
+	if (cache->length == 0)
+		btrfs_warn(cache->fs_info, "block group length is zero");
+
 	/*
 	 * We convert to bitmaps when the disk space required for using extents
 	 * exceeds that required for using bitmaps.
-- 
2.28.0


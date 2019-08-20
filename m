Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF8096165
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbfHTNk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730237AbfHTNkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:40:53 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B587622DD3;
        Tue, 20 Aug 2019 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308452;
        bh=kXBUgL0Xmp8Au5PXKEfhptc9iWLrCWUwIQpyw62rx6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLUG7/3Z0w9jaKGiAvA64J4YDZu83sQ0w/ssMZevllU4geRqhVTP/CM0useKgU11P
         waUTU6Xj8pFwHskAxr1xy7frq7BOrfTLhk1yE8rRUvPPvzmx6o+5P8YfjPeM6Ajvtv
         3S4s0QVUz0TnDVfbnhUH32h/KUVu/dzK4VQA5HA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 22/44] btrfs: trim: Check the range passed into to prevent overflow
Date:   Tue, 20 Aug 2019 09:40:06 -0400
Message-Id: <20190820134028.10829-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 07301df7d2fc220d3de5f7ad804dcb941400cb00 ]

Normally the range->len is set to default value (U64_MAX), but when it's
not default value, we should check if the range overflows.

And if it overflows, return -EINVAL before doing anything.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5faf057f6f37f..b8f4720879021 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11226,6 +11226,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	struct btrfs_device *device;
 	struct list_head *devices;
 	u64 group_trimmed;
+	u64 range_end = U64_MAX;
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
@@ -11235,16 +11236,23 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	int dev_ret = 0;
 	int ret = 0;
 
+	/*
+	 * Check range overflow if range->len is set.
+	 * The default range->len is U64_MAX.
+	 */
+	if (range->len != U64_MAX &&
+	    check_add_overflow(range->start, range->len, &range_end))
+		return -EINVAL;
+
 	cache = btrfs_lookup_first_block_group(fs_info, range->start);
 	for (; cache; cache = next_block_group(cache)) {
-		if (cache->key.objectid >= (range->start + range->len)) {
+		if (cache->key.objectid >= range_end) {
 			btrfs_put_block_group(cache);
 			break;
 		}
 
 		start = max(range->start, cache->key.objectid);
-		end = min(range->start + range->len,
-				cache->key.objectid + cache->key.offset);
+		end = min(range_end, cache->key.objectid + cache->key.offset);
 
 		if (end - start >= range->minlen) {
 			if (!block_group_cache_done(cache)) {
-- 
2.20.1


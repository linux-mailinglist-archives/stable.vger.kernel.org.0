Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B4C3BB0D8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhGDXJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhGDXIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AACBA61364;
        Sun,  4 Jul 2021 23:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439963;
        bh=hF2Or2ggfZNj/iZ/CwzyC43xYr5V3icu8Dg9dnD9xV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u3hPidvl97zsUgD2rP3tx42skK1ZtWQbUKckKEYmPiHQKZs2PCdKW3AD4wXoMDaEs
         fkOVRX1ybd/lrQOXl4kqZjSFq1AllqSZRca/q4QSBk+yWv+FrAgaC4YptC7WtfYR+h
         1327Pfhr54T8tEWLeKcgZJCIPT1T0YMcWDQghg0B8rSkSg0DBS5mxHfUkFFPFl7WaK
         NdnXJAD0VnGeZRqYObySEupF+AwBgSZdkGXqf5H/guW+87/rNrzAs+WYgNjcOpB6uo
         0CQV6cXuy/yQit93LE5KOmRfPl1NVTYeCIWM6/jwg7o6psFBObDlueniKVWv1OnGg/
         XGuc8GI2pxkwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 76/85] btrfs: fix the filemap_range_has_page() call in btrfs_punch_hole_lock_range()
Date:   Sun,  4 Jul 2021 19:04:11 -0400
Message-Id: <20210704230420.1488358-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 0528476b6ac7832f31e2ed740a57ae31316b124e ]

[BUG]
With current subpage RW support, the following script can hang the fs
with 64K page size.

 # mkfs.btrfs -f -s 4k $dev
 # mount $dev -o nospace_cache $mnt
 # fsstress -w -n 50 -p 1 -s 1607749395 -d $mnt

The kernel will do an infinite loop in btrfs_punch_hole_lock_range().

[CAUSE]
In btrfs_punch_hole_lock_range() we:

- Truncate page cache range
- Lock extent io tree
- Wait any ordered extents in the range.

We exit the loop until we meet all the following conditions:

- No ordered extent in the lock range
- No page is in the lock range

The latter condition has a pitfall, it only works for sector size ==
PAGE_SIZE case.

While can't handle the following subpage case:

  0       32K     64K     96K     128K
  |       |///////||//////|       ||

lockstart=32K
lockend=96K - 1

In this case, although the range crosses 2 pages,
truncate_pagecache_range() will invalidate no page at all, but only zero
the [32K, 96K) range of the two pages.

Thus filemap_range_has_page(32K, 96K-1) will always return true, thus we
will never meet the loop exit condition.

[FIX]
Fix the problem by doing page alignment for the lock range.

Function filemap_range_has_page() has already handled lend < lstart
case, we only need to round up @lockstart, and round_down @lockend for
truncate_pagecache_range().

This modification should not change any thing for sector size ==
PAGE_SIZE case, as in that case our range is already page aligned.

Tested-by: Ritesh Harjani <riteshh@linux.ibm.com> # [ppc64]
Tested-by: Anand Jain <anand.jain@oracle.com> # [aarch64]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 55f68422061d..7e6ed97a6d08 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2483,6 +2483,17 @@ static int btrfs_punch_hole_lock_range(struct inode *inode,
 				       const u64 lockend,
 				       struct extent_state **cached_state)
 {
+	/*
+	 * For subpage case, if the range is not at page boundary, we could
+	 * have pages at the leading/tailing part of the range.
+	 * This could lead to dead loop since filemap_range_has_page()
+	 * will always return true.
+	 * So here we need to do extra page alignment for
+	 * filemap_range_has_page().
+	 */
+	const u64 page_lockstart = round_up(lockstart, PAGE_SIZE);
+	const u64 page_lockend = round_down(lockend + 1, PAGE_SIZE) - 1;
+
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
 		int ret;
@@ -2503,7 +2514,7 @@ static int btrfs_punch_hole_lock_range(struct inode *inode,
 		    (ordered->file_offset + ordered->num_bytes <= lockstart ||
 		     ordered->file_offset > lockend)) &&
 		     !filemap_range_has_page(inode->i_mapping,
-					     lockstart, lockend)) {
+					     page_lockstart, page_lockend)) {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
 			break;
-- 
2.30.2


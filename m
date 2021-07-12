Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8FC3C48C6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhGLGk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237935AbhGLGjq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B467611AD;
        Mon, 12 Jul 2021 06:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071747;
        bh=GlfDKcO4IErOnM+8k+Luy7qZxQgsMyBm+JYjVL2R3Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nFbj2870BV0P8i+xoKbXh81fuFR8kd0XHlrNtVWcvXuRzcHjHjIy73qU1/H885Xp
         F68ecbUDic1kPcy3BG5IP4Cpo65Q5j4NB0GzUUG1ijW5eAh1FggwXHmMVA7xLAuBXM
         GhDUu/lvE1AZxK1oh5GTpp5xwarYE4HXImWwzllM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.10 159/593] btrfs: dont clear page extent mapped if were not invalidating the full page
Date:   Mon, 12 Jul 2021 08:05:19 +0200
Message-Id: <20210712060900.537539015@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit bcd77455d590eaa0422a5e84ae852007cfce574a ]

[BUG]
With current btrfs subpage rw support, the following script can lead to
fs hang:

  $ mkfs.btrfs -f -s 4k $dev
  $ mount $dev -o nospace_cache $mnt
  $ fsstress -w -n 100 -p 1 -s 1608140256 -v -d $mnt

The fs will hang at btrfs_start_ordered_extent().

[CAUSE]
In above test case, btrfs_invalidate() will be called with the following
parameters:

  offset = 0 length = 53248 page dirty = 1 subpage dirty bitmap = 0x2000

Since @offset is 0, btrfs_invalidate() will try to invalidate the full
page, and finally call clear_page_extent_mapped() which will detach
subpage structure from the page.

And since the page no longer has subpage structure, the subpage dirty
bitmap will be cleared, preventing the dirty range from being written
back, thus no way to wake up the ordered extent.

[FIX]
Just follow other filesystems, only to invalidate the page if the range
covers the full page.

There are cases like truncate_setsize() which can call
btrfs_invalidatepage() with offset == 0 and length != 0 for the last
page of an inode.

Although the old code will still try to invalidate the full page, we are
still safe to just wait for ordered extent to finish.
So it shouldn't cause extra problems.

Tested-by: Ritesh Harjani <riteshh@linux.ibm.com> # [ppc64]
Tested-by: Anand Jain <anand.jain@oracle.com> # [aarch64]
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a03d3bad2139..4f21b8fbfd4b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8213,7 +8213,19 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 	 */
 	wait_on_page_writeback(page);
 
-	if (offset) {
+	/*
+	 * For subpage case, we have call sites like
+	 * btrfs_punch_hole_lock_range() which passes range not aligned to
+	 * sectorsize.
+	 * If the range doesn't cover the full page, we don't need to and
+	 * shouldn't clear page extent mapped, as page->private can still
+	 * record subpage dirty bits for other part of the range.
+	 *
+	 * For cases that can invalidate the full even the range doesn't
+	 * cover the full page, like invalidating the last page, we're
+	 * still safe to wait for ordered extent to finish.
+	 */
+	if (!(offset == 0 && length == PAGE_SIZE)) {
 		btrfs_releasepage(page, GFP_NOFS);
 		return;
 	}
-- 
2.30.2




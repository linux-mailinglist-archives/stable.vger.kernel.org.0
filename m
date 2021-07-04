Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D2D3BB395
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhGDXSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhGDXON (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA84961977;
        Sun,  4 Jul 2021 23:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440168;
        bh=rQ80Pd8jSZi7pRf0+k9IAkwTIRv0Y9XF0IEOvjTqhvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbqBMqUKsYJz0gYQAE5o5a+yBQfS6E0lPrcqc40rzIJ1wqiphcEFgFU0t/NeFtC/e
         NJYnPNc349wRZiWv1pZYe1niUI9FUzoTIWjFjkDeZkmMs5CYa/Aa5iIwORIRrSKDSK
         Yj5wGFkM1G2AlyI8f5BibHmcLEzipaoNZELjsrEIwPc7aiYneuxZ1x4/t6OMYDo0Ch
         eKXL4YkFAgGmXuJyFOGTAcoarzRFKXHjjr4pa/4a7qZzTnwV+IMBLf4FX+oAWDYmp7
         frgl3Bn/XO3TsRg6EpNtVmCOT0zGvtERNdhZAs1X49evSUmq99ADQhnr1k4RGXRYqI
         eJFa9mbG2Z9ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 63/70] btrfs: don't clear page extent mapped if we're not invalidating the full page
Date:   Sun,  4 Jul 2021 19:07:56 -0400
Message-Id: <20210704230804.1490078-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d0f38d2890a0..64274d3c4db5 100644
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


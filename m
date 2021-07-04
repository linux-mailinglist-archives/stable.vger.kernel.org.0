Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB793BB156
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhGDXLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhGDXKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FC4B6194A;
        Sun,  4 Jul 2021 23:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440074;
        bh=1jx+7YcbvDAyXame2rw2X+13M9LGtpeVrZ1GJRkwhn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6WdjNDVAxOqQjmBZh6bEYRZtQzpST8TDUBtCzJGMr7h9XDNdXiCpaMP8pNjUpv4m
         TCFT9muGbAU9K7p9EbUy+jM7NE3mnAhIwCu4fOd5QrpSGZwCEGAoS/SLk5vNpn8CVE
         GWRk42Vanp4RfGwuMBPaYE1QZ7jfOlEiCbeMQZc4o0N1J6wFYCxz3a8Q1KzU67bHeB
         5J5crl3/S0lpvmfIRp3QjAZ094speLmz0mBPmto5mabxH+6W9C/ECu56wI407CmqWw
         YVF1nsVKiUMOgccwC3LK4Cktv1sTlKDel3q+diSsPbvrHCmBT6TkokBPKEC8Uo17sF
         IG/0KeYO58MBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 73/80] btrfs: don't clear page extent mapped if we're not invalidating the full page
Date:   Sun,  4 Jul 2021 19:06:09 -0400
Message-Id: <20210704230616.1489200-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index d29451b839fb..454573a61132 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8386,7 +8386,19 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
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


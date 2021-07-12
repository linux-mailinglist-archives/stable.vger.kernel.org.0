Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAEE3C4C8D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242018AbhGLHGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241822AbhGLHEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:04:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59724611C2;
        Mon, 12 Jul 2021 07:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073278;
        bh=ntd7N4ODXfPVCqUQ2oiN/qWeyj26zTtzAKpfs5+tdR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQMaebmjUb1xlhW3EhVRLVmMovroRQs1E6AGzSfM/eGm/9oFGl1FTlIhGBuhd9jzT
         uWmF4sNE9CeshVLPMJu+1/2hb0F18qxPr5VhExqhB9du5Hlyb2xfH+x8U7dBvbjUsQ
         XF+aBde13RFL9u+NvcdeUE6XK+ZhjFUF7dcALPO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.12 187/700] btrfs: dont clear page extent mapped if were not invalidating the full page
Date:   Mon, 12 Jul 2021 08:04:30 +0200
Message-Id: <20210712060953.221916070@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 3e7173c7660d..1b22ded1a799 100644
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




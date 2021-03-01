Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B55328A58
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCASQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:16:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231902AbhCASIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0BAB6146D;
        Mon,  1 Mar 2021 17:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618921;
        bh=QIQVHHM5Fu68yLjLw+JJv0itefkFib+0J3GDb8j6Cd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9bf3+tqUfvolIbiO9RJyErGWwH+dLlI0X97Lf5GKDSOezGzKkLxI5tPpkr4bStF6
         KgAtuZEd91VDs5N8JvpsGrm44qSqu5NF9bcUFusaAlfYcgY/maoFoZiV6XkgIAgqY3
         +IVg1FtrCj7Xddw7yD+cBMVxzO+i4n90KteX3Hmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/663] btrfs: fix double accounting of ordered extent for subpage case in btrfs_invalidapge
Date:   Mon,  1 Mar 2021 17:07:54 +0100
Message-Id: <20210301161152.982526168@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 951c80f83d61bd4b21794c8aba829c3c1a45c2d0 ]

Commit dbfdb6d1b369 ("Btrfs: Search for all ordered extents that could
span across a page") make btrfs_invalidapage() to search all ordered
extents.

The offending code looks like this:

  again:
	  start = page_start;
	  ordered = btrfs_lookup_ordered_range(inode, start, page_end - start + 1);
	  if (ordred) {
		  end = min(page_end,
			    ordered->file_offset + ordered->num_bytes - 1);

		  /* Do the cleanup */

		  start = end + 1;
		  if (start < page_end)
			  goto again;
	  }

The behavior is indeed necessary for the incoming subpage support, but
when it iterates through all the ordered extents, it also resets the
search range @start.

This means, for the following cases, we can double account the ordered
extents, causing its bytes_left underflow:

	Page offset
	0		16K		32K
	|<--- OE 1  --->|<--- OE 2 ---->|

As the first iteration will find ordered extent (OE) 1, which doesn't
cover the full page, thus after cleanup code, we need to retry again.
But again label will reset start to page_start, and we got OE 1 again,
which causes double accounting on OE 1, and cause OE 1's byte_left to
underflow.

This problem can only happen for subpage case, as for regular sectorsize
== PAGE_SIZE case, we will always find a OE ends at or after page end,
thus no way to trigger the problem.

Move the again label after start = page_start.  There will be more
comprehensive rework to convert the open coded loop to a proper while
loop for subpage support.

Fixes: dbfdb6d1b369 ("Btrfs: Search for all ordered extents that could span across a page")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b536d21541a9f..4d85f3a6695d1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8207,8 +8207,9 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 	if (!inode_evicting)
 		lock_extent_bits(tree, page_start, page_end, &cached_state);
-again:
+
 	start = page_start;
+again:
 	ordered = btrfs_lookup_ordered_range(inode, start, page_end - start + 1);
 	if (ordered) {
 		end = min(page_end,
-- 
2.27.0




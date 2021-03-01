Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D30328E97
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241988AbhCATeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241704AbhCAT2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:28:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40EA364D99;
        Mon,  1 Mar 2021 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620841;
        bh=Q+bTeE3XrDdXjs5gx2nhKReqJz1aB39R9NdGzohYdo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qci1FR8XrQMPOcdtIHqypn/srTPAwJ2SKl3zGP5olr0rVQ8jjHFTmS5bUQbaK9//h
         0XYvjjrVDn6pk5eqn8Je/bUWRTm5f3JNzSiBiEBjmugZ0EDlcVv+sTH+lenmp+D+PR
         RYZM3vPP6Sx4oc73aEfQEhPe7jTXLS83Ps/erbAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 269/775] btrfs: fix double accounting of ordered extent for subpage case in btrfs_invalidapge
Date:   Mon,  1 Mar 2021 17:07:17 +0100
Message-Id: <20210301161214.923731286@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index a8e0a6b038d3e..ad34c5a09befc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8186,8 +8186,9 @@ static void btrfs_invalidatepage(struct page *page, unsigned int offset,
 
 	if (!inode_evicting)
 		lock_extent_bits(tree, page_start, page_end, &cached_state);
-again:
+
 	start = page_start;
+again:
 	ordered = btrfs_lookup_ordered_range(inode, start, page_end - start + 1);
 	if (ordered) {
 		found_ordered = true;
-- 
2.27.0




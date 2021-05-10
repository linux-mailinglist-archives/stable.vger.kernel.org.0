Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1CA3788CA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhEJLYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237305AbhEJLLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC2356192E;
        Mon, 10 May 2021 11:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644937;
        bh=m1/6NUWW1FDP/McTnMl3GIptawWKsdd2yROLn8Oi0kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbEF3hCKwrIXHmVUx5uFdVoPBWdLwTgv99uSw1ctpVYikia4M8efP1Rh0cC1/tgtX
         ZRbi8qvowDXBlbaaJKeQ4BU/IS82C8hK4oWrBZtq8+23JfuD62SVN+BCeGmm+ZKsEF
         eD3njFDqc/eJeU0tVBo/JV9y+2mOEjmzQlACvT+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robbie Ko <robbieko@synology.com>,
        Chung-Chiang Cheng <cccheng@synology.com>,
        Filipe Manana <fdmanana@suse.com>,
        BingJing Chang <bingjingc@synology.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 284/384] btrfs: fix a potential hole punching failure
Date:   Mon, 10 May 2021 12:21:13 +0200
Message-Id: <20210510102024.181662447@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: BingJing Chang <bingjingc@synology.com>

[ Upstream commit 3227788cd369d734d2d3cd94f8af7536b60fa552 ]

In commit d77815461f04 ("btrfs: Avoid trucating page or punching hole
in a already existed hole."), existing holes can be skipped by calling
find_first_non_hole() to adjust start and len. However, if the given len
is invalid and large, when an EXTENT_MAP_HOLE extent is found, len will
not be set to zero because (em->start + em->len) is less than
(start + len). Then the ret will be 1 but len will not be set to 0.
The propagated non-zero ret will result in fallocate failure.

In the while-loop of btrfs_replace_file_extents(), len is not updated
every time before it calls find_first_non_hole(). That is, after
btrfs_drop_extents() successfully drops the last non-hole file extent,
it may fail with ENOSPC when attempting to drop a file extent item
representing a hole. The problem can happen. After it calls
find_first_non_hole(), the cur_offset will be adjusted to be larger
than or equal to end. However, since the len is not set to zero, the
break-loop condition (ret && !len) will not be met. After it leaves the
while-loop, fallocate will return 1, which is an unexpected return
value.

We're not able to construct a reproducible way to let
btrfs_drop_extents() fail with ENOSPC after it drops the last non-hole
file extent but with remaining holes left. However, it's quite easy to
fix. We just need to update and check the len every time before we call
find_first_non_hole(). To make the while loop more readable, we also
pull the variable updates to the bottom of loop like this:
  while (cur_offset < end) {
	  ...
	  // update cur_offset & len
	  // advance cur_offset & len in hole-punching case if needed
  }

Reported-by: Robbie Ko <robbieko@synology.com>
Fixes: d77815461f04 ("btrfs: Avoid trucating page or punching hole in a already existed hole.")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Robbie Ko <robbieko@synology.com>
Reviewed-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: BingJing Chang <bingjingc@synology.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4130523a77c9..6eb72c9b15a7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2729,8 +2729,6 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 			extent_info->file_offset += replace_len;
 		}
 
-		cur_offset = drop_args.drop_end;
-
 		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
 		if (ret)
 			break;
@@ -2750,7 +2748,9 @@ int btrfs_replace_file_extents(struct inode *inode, struct btrfs_path *path,
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
 
-		if (!extent_info) {
+		cur_offset = drop_args.drop_end;
+		len = end - cur_offset;
+		if (!extent_info && len) {
 			ret = find_first_non_hole(BTRFS_I(inode), &cur_offset,
 						  &len);
 			if (unlikely(ret < 0))
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF55330187
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCGN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230488AbhCGN5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AB6E65100;
        Sun,  7 Mar 2021 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125468;
        bh=R5aDyV21ICJKjV1r2Yxt5F+o1GFEuhN6ZjNXDk7Hqhk=;
        h=From:To:Cc:Subject:Date:From;
        b=Nr9xEm9VjRvLqEgXD4dXDB+nJXWvCuP4jwGP9FTl17dmq8bqmRsum2WFwwi/rZAOK
         +oVEuYJGNAoyYtBmnbQQHqmrsEredDFldUrj0stuyjIzVhXI494SrVA4NbJ3uFnIb6
         CckJbOEE2RUqPh3FIeBV0Jr/NZmLLhLapnypJGOFj2AgEOflem7oCoUjOZ1bkPfEYG
         Xbk5n66hJeI5y4Co4o86bujDSIIF5ScpYTKCIdWh1vEIgV2YVjMN6ucAHKezLgQMPd
         IPWCP/q+JZyAGwQEcct3n5mOWwM4sBcEeYHZvXZfmLHlhViIzbUgdvBocKV6RvHo2R
         NBOdCIIPuHnQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 01/12] btrfs: avoid checking for RO block group twice during nocow writeback
Date:   Sun,  7 Mar 2021 08:57:35 -0500
Message-Id: <20210307135746.967418-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 20903032cd9f0260b99aeab92e6540f0350e4a23 ]

During the nocow writeback path, we currently iterate the rbtree of block
groups twice: once for checking if the target block group is RO with the
call to btrfs_extent_readonly()), and once again for getting a nocow
reference on the block group with a call to btrfs_inc_nocow_writers().

Since btrfs_inc_nocow_writers() already returns false when the target
block group is RO, remove the call to btrfs_extent_readonly(). Not only
we avoid searching the blocks group rbtree twice, it also helps reduce
contention on the lock that protects it (specially since it is a spin
lock and not a read-write lock). That may make a noticeable difference
on very large filesystems, with thousands of allocated block groups.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ad34c5a09bef..02c4bfa515fb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1657,9 +1657,6 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 			 */
 			btrfs_release_path(path);
 
-			/* If extent is RO, we must COW it */
-			if (btrfs_extent_readonly(fs_info, disk_bytenr))
-				goto out_check;
 			ret = btrfs_cross_ref_exist(root, ino,
 						    found_key.offset -
 						    extent_offset, disk_bytenr, false);
@@ -1706,6 +1703,7 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
 				WARN_ON_ONCE(freespace_inode);
 				goto out_check;
 			}
+			/* If the extent's block group is RO, we must COW */
 			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
 				goto out_check;
 			nocow = true;
-- 
2.30.1


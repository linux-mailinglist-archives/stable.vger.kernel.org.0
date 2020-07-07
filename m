Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F57421711D
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgGGPYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730074AbgGGPYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C969E207D0;
        Tue,  7 Jul 2020 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135457;
        bh=r04Y4mUiDsaVVGGSKtOVGu/kIzxHagWSP2D/OpDco4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1PutwLocey9VBF7Cs+nj2tAUIQfVrA0aOeD8VszGFtXHEqlV6ZC6I7tSsOz48Mzl
         w/StyYMQlusUPYSefW5hPWzQpfKC97HLAHrzATsVT0B+qzWuSXak5qYVGkbRPs2bsi
         oqF6Tmj2a1MqglqVhAJJvSJS420nSyCgt/Ajat/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 048/112] btrfs: fix RWF_NOWAIT writes blocking on extent locks and waiting for IO
Date:   Tue,  7 Jul 2020 17:16:53 +0200
Message-Id: <20200707145803.290182070@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5dbb75ed6900048e146247b6325742d92c892548 ]

A RWF_NOWAIT write is not supposed to wait on filesystem locks that can be
held for a long time or for ongoing IO to complete.

However when calling check_can_nocow(), if the inode has prealloc extents
or has the NOCOW flag set, we can block on extent (file range) locks
through the call to btrfs_lock_and_flush_ordered_range(). Such lock can
take a significant amount of time to be available. For example, a fiemap
task may be running, and iterating through the entire file range checking
all extents and doing backref walking to determine if they are shared,
or a readpage operation may be in progress.

Also at btrfs_lock_and_flush_ordered_range(), called by check_can_nocow(),
after locking the file range we wait for any existing ordered extent that
is in progress to complete. Another operation that can take a significant
amount of time and defeat the purpose of RWF_NOWAIT.

So fix this by trying to lock the file range and if it's currently locked
return -EAGAIN to user space. If we are able to lock the file range without
waiting and there is an ordered extent in the range, return -EAGAIN as
well, instead of waiting for it to complete. Finally, don't bother trying
to lock the snapshot lock of the root when attempting a RWF_NOWAIT write,
as that is only important for buffered writes.

Fixes: edf064e7c6fec3 ("btrfs: nowait aio support")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 52d565ff66e2d..93244934d4f92 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1541,7 +1541,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 }
 
 static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
-				    size_t *write_bytes)
+				    size_t *write_bytes, bool nowait)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_root *root = inode->root;
@@ -1549,27 +1549,43 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 	u64 num_bytes;
 	int ret;
 
-	if (!btrfs_drew_try_write_lock(&root->snapshot_lock))
+	if (!nowait && !btrfs_drew_try_write_lock(&root->snapshot_lock))
 		return -EAGAIN;
 
 	lockstart = round_down(pos, fs_info->sectorsize);
 	lockend = round_up(pos + *write_bytes,
 			   fs_info->sectorsize) - 1;
+	num_bytes = lockend - lockstart + 1;
 
-	btrfs_lock_and_flush_ordered_range(inode, lockstart,
-					   lockend, NULL);
+	if (nowait) {
+		struct btrfs_ordered_extent *ordered;
+
+		if (!try_lock_extent(&inode->io_tree, lockstart, lockend))
+			return -EAGAIN;
+
+		ordered = btrfs_lookup_ordered_range(inode, lockstart,
+						     num_bytes);
+		if (ordered) {
+			btrfs_put_ordered_extent(ordered);
+			ret = -EAGAIN;
+			goto out_unlock;
+		}
+	} else {
+		btrfs_lock_and_flush_ordered_range(inode, lockstart,
+						   lockend, NULL);
+	}
 
-	num_bytes = lockend - lockstart + 1;
 	ret = can_nocow_extent(&inode->vfs_inode, lockstart, &num_bytes,
 			NULL, NULL, NULL);
 	if (ret <= 0) {
 		ret = 0;
-		btrfs_drew_write_unlock(&root->snapshot_lock);
+		if (!nowait)
+			btrfs_drew_write_unlock(&root->snapshot_lock);
 	} else {
 		*write_bytes = min_t(size_t, *write_bytes ,
 				     num_bytes - pos + lockstart);
 	}
-
+out_unlock:
 	unlock_extent(&inode->io_tree, lockstart, lockend);
 
 	return ret;
@@ -1641,7 +1657,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
 			    check_can_nocow(BTRFS_I(inode), pos,
-					&write_bytes) > 0) {
+					    &write_bytes, false) > 0) {
 				/*
 				 * For nodata cow case, no need to reserve
 				 * data space.
@@ -1920,12 +1936,11 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		 */
 		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC)) ||
-		    check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes) <= 0) {
+		    check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes,
+				    true) <= 0) {
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
-		/* check_can_nocow() locks the snapshot lock on success */
-		btrfs_drew_write_unlock(&root->snapshot_lock);
 		/*
 		 * There are holes in the range or parts of the range that must
 		 * be COWed (shared extents, RO block groups, etc), so just bail
-- 
2.25.1




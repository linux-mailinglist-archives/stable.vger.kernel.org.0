Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27932E9AA9
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbhADQMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:12:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbhADP74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 10:59:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923AE224D4;
        Mon,  4 Jan 2021 15:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775966;
        bh=hSi3hFUwbPGdYk74ajVu6FCjtIgnPo70Msq7mJYicbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j50+I3I8s1GafxODJCbVSUceChCBgbqe0B4qPkTZ+ysbtFrlYA//hn5NPfkpuQMtC
         GZnh/mlnp+bDm972NAzk2n78kpPUtAINfptcF0hBriKlp+pvxWQ8wQOye6Mr/noeR0
         NpRq1+l1UrbFU57jABhQ1TF7LSZhqc59Ka1ubJpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/47] btrfs: fix race when defragmenting leads to unnecessary IO
Date:   Mon,  4 Jan 2021 16:57:09 +0100
Message-Id: <20210104155706.250001425@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7f458a3873ae94efe1f37c8b96c97e7298769e98 ]

When defragmenting we skip ranges that have holes or inline extents, so that
we don't do unnecessary IO and waste space. We do this check when calling
should_defrag_range() at btrfs_defrag_file(). However we do it without
holding the inode's lock. The reason we do it like this is to avoid
blocking other tasks for too long, that possibly want to operate on other
file ranges, since after the call to should_defrag_range() and before
locking the inode, we trigger a synchronous page cache readahead. However
before we were able to lock the inode, some other task might have punched
a hole in our range, or we may now have an inline extent there, in which
case we should not set the range for defrag anymore since that would cause
unnecessary IO and make us waste space (i.e. allocating extents to contain
zeros for a hole).

So after we locked the inode and the range in the iotree, check again if
we have holes or an inline extent, and if we do, just skip the range.

I hit this while testing my next patch that fixes races when updating an
inode's number of bytes (subject "btrfs: update the number of bytes used
by an inode atomically"), and it depends on this change in order to work
correctly. Alternatively I could rework that other patch to detect holes
and flag their range with the 'new delalloc' bit, but this itself fixes
an efficiency problem due a race that from a functional point of view is
not harmful (it could be triggered with btrfs/062 from fstests).

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f58e03d1775d8..8ed71b3b25466 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1256,6 +1256,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	u64 page_end;
 	u64 page_cnt;
 	u64 start = (u64)start_index << PAGE_SHIFT;
+	u64 search_start;
 	int ret;
 	int i;
 	int i_done;
@@ -1352,6 +1353,40 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
 			 page_start, page_end - 1, &cached_state);
+
+	/*
+	 * When defragmenting we skip ranges that have holes or inline extents,
+	 * (check should_defrag_range()), to avoid unnecessary IO and wasting
+	 * space. At btrfs_defrag_file(), we check if a range should be defragged
+	 * before locking the inode and then, if it should, we trigger a sync
+	 * page cache readahead - we lock the inode only after that to avoid
+	 * blocking for too long other tasks that possibly want to operate on
+	 * other file ranges. But before we were able to get the inode lock,
+	 * some other task may have punched a hole in the range, or we may have
+	 * now an inline extent, in which case we should not defrag. So check
+	 * for that here, where we have the inode and the range locked, and bail
+	 * out if that happened.
+	 */
+	search_start = page_start;
+	while (search_start < page_end) {
+		struct extent_map *em;
+
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, search_start,
+				      page_end - search_start, 0);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out_unlock_range;
+		}
+		if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
+			free_extent_map(em);
+			/* Ok, 0 means we did not defrag anything */
+			ret = 0;
+			goto out_unlock_range;
+		}
+		search_start = extent_map_end(em);
+		free_extent_map(em);
+	}
+
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
 			  EXTENT_DEFRAG, 0, 0, &cached_state);
@@ -1382,6 +1417,10 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return i_done;
+
+out_unlock_range:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+			     page_start, page_end - 1, &cached_state);
 out:
 	for (i = 0; i < i_done; i++) {
 		unlock_page(pages[i]);
-- 
2.27.0




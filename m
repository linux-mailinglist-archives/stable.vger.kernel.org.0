Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7142E3F9D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502261AbgL1O1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502253AbgL1O1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DBB622B2C;
        Mon, 28 Dec 2020 14:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165600;
        bh=0/3qRoxR9KL2kG9m6r72SRIejD0G7iMdTuCEwu+ey0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2ZH0bu8fPDm7Sd4/ekuWnrsFFDHgk/PMINg3FUbcr5lB/V7CFrOqDeyr7gxsFabt
         3jh14zyOCg1KhDhx39GEtSljjAGkfENIpzwfRNCJ0kzLrn6KSrpuGJUBW3TybI5V5a
         XwL5IY4i+qI1oiuGc/O48BH/GYDXYhq9rlkgCuqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 589/717] btrfs: fix race when defragmenting leads to unnecessary IO
Date:   Mon, 28 Dec 2020 13:49:47 +0100
Message-Id: <20201228125049.127499593@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 7f458a3873ae94efe1f37c8b96c97e7298769e98 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1275,6 +1275,7 @@ static int cluster_pages_for_defrag(stru
 	u64 page_end;
 	u64 page_cnt;
 	u64 start = (u64)start_index << PAGE_SHIFT;
+	u64 search_start;
 	int ret;
 	int i;
 	int i_done;
@@ -1371,6 +1372,40 @@ again:
 
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
+				      page_end - search_start);
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
@@ -1401,6 +1436,10 @@ again:
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



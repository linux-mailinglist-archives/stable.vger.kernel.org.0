Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83201720D0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgB0OpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:45:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730112AbgB0Nq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:46:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2DE2469F;
        Thu, 27 Feb 2020 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811217;
        bh=wUIufC8Wzip5suA+4iOfai1q2QIz8TaqzWm4SZxl3ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCh5wHaeRdDZU4h+F53QNkWdTPyJN8WdCCt5UtAa/AdhxGEUyYNAwWoEBgC9Weh+B
         qy3ilmi+jcx5SSEp+Xokb9cZMoFqiIhz5zLaiX2hu1Lx0HxokDh4pS+yvTuMhykEEK
         dKtLu/RNvyDiruZFsivZlXNbWSg3KzWM9+k2ODoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ryusuke1925 <st13s20@gm.ibaraki-ct.ac.jp>,
        Koki Mitani <koki.mitani.xg@hco.ntt.co.jp>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 010/165] Btrfs: fix race between using extent maps and merging them
Date:   Thu, 27 Feb 2020 14:34:44 +0100
Message-Id: <20200227132232.605448213@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ac05ca913e9f3871126d61da275bfe8516ff01ca upstream.

We have a few cases where we allow an extent map that is in an extent map
tree to be merged with other extents in the tree. Such cases include the
unpinning of an extent after the respective ordered extent completed or
after logging an extent during a fast fsync. This can lead to subtle and
dangerous problems because when doing the merge some other task might be
using the same extent map and as consequence see an inconsistent state of
the extent map - for example sees the new length but has seen the old start
offset.

With luck this triggers a BUG_ON(), and not some silent bug, such as the
following one in __do_readpage():

  $ cat -n fs/btrfs/extent_io.c
  3061  static int __do_readpage(struct extent_io_tree *tree,
  3062                           struct page *page,
  (...)
  3127                  em = __get_extent_map(inode, page, pg_offset, cur,
  3128                                        end - cur + 1, get_extent, em_cached);
  3129                  if (IS_ERR_OR_NULL(em)) {
  3130                          SetPageError(page);
  3131                          unlock_extent(tree, cur, end);
  3132                          break;
  3133                  }
  3134                  extent_offset = cur - em->start;
  3135                  BUG_ON(extent_map_end(em) <= cur);
  (...)

Consider the following example scenario, where we end up hitting the
BUG_ON() in __do_readpage().

We have an inode with a size of 8KiB and 2 extent maps:

  extent A: file offset 0, length 4KiB, disk_bytenr = X, persisted on disk by
            a previous transaction

  extent B: file offset 4KiB, length 4KiB, disk_bytenr = X + 4KiB, not yet
            persisted but writeback started for it already. The extent map
	    is pinned since there's writeback and an ordered extent in
	    progress, so it can not be merged with extent map A yet

The following sequence of steps leads to the BUG_ON():

1) The ordered extent for extent B completes, the respective page gets its
   writeback bit cleared and the extent map is unpinned, at that point it
   is not yet merged with extent map A because it's in the list of modified
   extents;

2) Due to memory pressure, or some other reason, the MM subsystem releases
   the page corresponding to extent B - btrfs_releasepage() is called and
   returns 1, meaning the page can be released as it's not dirty, not under
   writeback anymore and the extent range is not locked in the inode's
   iotree. However the extent map is not released, either because we are
   not in a context that allows memory allocations to block or because the
   inode's size is smaller than 16MiB - in this case our inode has a size
   of 8KiB;

3) Task B needs to read extent B and ends up __do_readpage() through the
   btrfs_readpage() callback. At __do_readpage() it gets a reference to
   extent map B;

4) Task A, doing a fast fsync, calls clear_em_loggin() against extent map B
   while holding the write lock on the inode's extent map tree - this
   results in try_merge_map() being called and since it's possible to merge
   extent map B with extent map A now (the extent map B was removed from
   the list of modified extents), the merging begins - it sets extent map
   B's start offset to 0 (was 4KiB), but before it increments the map's
   length to 8KiB (4kb + 4KiB), task A is at:

   BUG_ON(extent_map_end(em) <= cur);

   The call to extent_map_end() sees the extent map has a start of 0
   and a length still at 4KiB, so it returns 4KiB and 'cur' is 4KiB, so
   the BUG_ON() is triggered.

So it's dangerous to modify an extent map that is in the tree, because some
other task might have got a reference to it before and still using it, and
needs to see a consistent map while using it. Generally this is very rare
since most paths that lookup and use extent maps also have the file range
locked in the inode's iotree. The fsync path is pretty much the only
exception where we don't do it to avoid serialization with concurrent
reads.

Fix this by not allowing an extent map do be merged if if it's being used
by tasks other then the one attempting to merge the extent map (when the
reference count of the extent map is greater than 2).

Reported-by: ryusuke1925 <st13s20@gm.ibaraki-ct.ac.jp>
Reported-by: Koki Mitani <koki.mitani.xg@hco.ntt.co.jp>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206211
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_map.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -227,6 +227,17 @@ static void try_merge_map(struct extent_
 	struct extent_map *merge = NULL;
 	struct rb_node *rb;
 
+	/*
+	 * We can't modify an extent map that is in the tree and that is being
+	 * used by another task, as it can cause that other task to see it in
+	 * inconsistent state during the merging. We always have 1 reference for
+	 * the tree and 1 for this task (which is unpinning the extent map or
+	 * clearing the logging flag), so anything > 2 means it's being used by
+	 * other tasks too.
+	 */
+	if (atomic_read(&em->refs) > 2)
+		return;
+
 	if (em->start != 0) {
 		rb = rb_prev(&em->rb_node);
 		if (rb)



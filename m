Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A02C9D59
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389219AbgLAJWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389188AbgLAJIU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:08:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE04B221FD;
        Tue,  1 Dec 2020 09:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813658;
        bh=22KdzZISy68sad4AOo/a/N3cvbbwEEwJh/lt2rU8NKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWaRczCwB8L2NY9ZUSQXfGLStDs6KcP43kZBu3wRnkSqMP386EWTK6J16jaA++tma
         wPU9rOv9JJX7PhpHSNwkgZQERMUG9xqP3CbLKHQ2B8wXZSZbJfr6JhycwMEOD9WkDY
         fKQFDqk/PYQ9OE3PjbFc0JDa55041L1FPn7NrLUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 008/152] btrfs: fix missing delalloc new bit for new delalloc ranges
Date:   Tue,  1 Dec 2020 09:52:03 +0100
Message-Id: <20201201084712.921227826@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit c334730988ee07908ba4eb816ce78d3fe06fecaa upstream.

When doing a buffered write, through one of the write family syscalls, we
look for ranges which currently don't have allocated extents and set the
'delalloc new' bit on them, so that we can report a correct number of used
blocks to the stat(2) syscall until delalloc is flushed and ordered extents
complete.

However there are a few other places where we can do a buffered write
against a range that is mapped to a hole (no extent allocated) and where
we do not set the 'new delalloc' bit. Those places are:

- Doing a memory mapped write against a hole;

- Cloning an inline extent into a hole starting at file offset 0;

- Calling btrfs_cont_expand() when the i_size of the file is not aligned
  to the sector size and is located in a hole. For example when cloning
  to a destination offset beyond EOF.

So after such cases, until the corresponding delalloc range is flushed and
the respective ordered extents complete, we can report an incorrect number
of blocks used through the stat(2) syscall.

In some cases we can end up reporting 0 used blocks to stat(2), which is a
particular bad value to report as it may mislead tools to think a file is
completely sparse when its i_size is not zero, making them skip reading
any data, an undesired consequence for tools such as archivers and other
backup tools, as reported a long time ago in the following thread (and
other past threads):

  https://lists.gnu.org/archive/html/bug-tar/2016-07/msg00001.html

Example reproducer:

  $ cat reproducer.sh
  #!/bin/bash

  MNT=/mnt/sdi
  DEV=/dev/sdi

  mkfs.btrfs -f $DEV > /dev/null
  # mkfs.xfs -f $DEV > /dev/null
  # mkfs.ext4 -F $DEV > /dev/null
  # mkfs.f2fs -f $DEV > /dev/null
  mount $DEV $MNT

  xfs_io -f -c "truncate 64K"   \
      -c "mmap -w 0 64K"        \
      -c "mwrite -S 0xab 0 64K" \
      -c "munmap"               \
      $MNT/foo

  blocks_used=$(stat -c %b $MNT/foo)
  echo "blocks used: $blocks_used"

  if [ $blocks_used -eq 0 ]; then
      echo "ERROR: blocks used is 0"
  fi

  umount $DEV

  $ ./reproducer.sh
  blocks used: 0
  ERROR: blocks used is 0

So move the logic that decides to set the 'delalloc bit' bit into the
function btrfs_set_extent_delalloc(), since that is what we use for all
those missing cases as well as for the cases that currently work well.

This change is also preparatory work for an upcoming patch that fixes
other problems related to tracking and reporting the number of bytes used
by an inode.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c              |   57 ------------------------------------------
 fs/btrfs/inode.c             |   58 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/tests/inode-tests.c |   12 +++++---
 3 files changed, 66 insertions(+), 61 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -452,46 +452,6 @@ static void btrfs_drop_pages(struct page
 	}
 }
 
-static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
-					 const u64 start,
-					 const u64 len,
-					 struct extent_state **cached_state)
-{
-	u64 search_start = start;
-	const u64 end = start + len - 1;
-
-	while (search_start < end) {
-		const u64 search_len = end - search_start + 1;
-		struct extent_map *em;
-		u64 em_len;
-		int ret = 0;
-
-		em = btrfs_get_extent(inode, NULL, 0, search_start, search_len);
-		if (IS_ERR(em))
-			return PTR_ERR(em);
-
-		if (em->block_start != EXTENT_MAP_HOLE)
-			goto next;
-
-		em_len = em->len;
-		if (em->start < search_start)
-			em_len -= search_start - em->start;
-		if (em_len > search_len)
-			em_len = search_len;
-
-		ret = set_extent_bit(&inode->io_tree, search_start,
-				     search_start + em_len - 1,
-				     EXTENT_DELALLOC_NEW,
-				     NULL, cached_state, GFP_NOFS);
-next:
-		search_start = extent_map_end(em);
-		free_extent_map(em);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
 /*
  * after copy_from_user, pages need to be dirtied and we need to make
  * sure holes are created between the current EOF and the start of
@@ -528,23 +488,6 @@ int btrfs_dirty_pages(struct btrfs_inode
 			 EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			 0, 0, cached);
 
-	if (!btrfs_is_free_space_inode(inode)) {
-		if (start_pos >= isize &&
-		    !(inode->flags & BTRFS_INODE_PREALLOC)) {
-			/*
-			 * There can't be any extents following eof in this case
-			 * so just set the delalloc new bit for the range
-			 * directly.
-			 */
-			extra_bits |= EXTENT_DELALLOC_NEW;
-		} else {
-			err = btrfs_find_new_delalloc_bytes(inode, start_pos,
-							    num_bytes, cached);
-			if (err)
-				return err;
-		}
-	}
-
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
 					extra_bits, cached);
 	if (err)
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2262,11 +2262,69 @@ static noinline int add_pending_csums(st
 	return 0;
 }
 
+static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
+					 const u64 start,
+					 const u64 len,
+					 struct extent_state **cached_state)
+{
+	u64 search_start = start;
+	const u64 end = start + len - 1;
+
+	while (search_start < end) {
+		const u64 search_len = end - search_start + 1;
+		struct extent_map *em;
+		u64 em_len;
+		int ret = 0;
+
+		em = btrfs_get_extent(inode, NULL, 0, search_start, search_len);
+		if (IS_ERR(em))
+			return PTR_ERR(em);
+
+		if (em->block_start != EXTENT_MAP_HOLE)
+			goto next;
+
+		em_len = em->len;
+		if (em->start < search_start)
+			em_len -= search_start - em->start;
+		if (em_len > search_len)
+			em_len = search_len;
+
+		ret = set_extent_bit(&inode->io_tree, search_start,
+				     search_start + em_len - 1,
+				     EXTENT_DELALLOC_NEW,
+				     NULL, cached_state, GFP_NOFS);
+next:
+		search_start = extent_map_end(em);
+		free_extent_map(em);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state)
 {
 	WARN_ON(PAGE_ALIGNED(end));
+
+	if (start >= i_size_read(&inode->vfs_inode) &&
+	    !(inode->flags & BTRFS_INODE_PREALLOC)) {
+		/*
+		 * There can't be any extents following eof in this case so just
+		 * set the delalloc new bit for the range directly.
+		 */
+		extra_bits |= EXTENT_DELALLOC_NEW;
+	} else {
+		int ret;
+
+		ret = btrfs_find_new_delalloc_bytes(inode, start,
+						    end + 1 - start,
+						    cached_state);
+		if (ret)
+			return ret;
+	}
+
 	return set_extent_delalloc(&inode->io_tree, start, end, extra_bits,
 				   cached_state);
 }
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -986,7 +986,8 @@ static int test_extent_accounting(u32 se
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE >> 1,
 			       (BTRFS_MAX_EXTENT_SIZE >> 1) + sectorsize - 1,
-			       EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1053,7 +1054,8 @@ static int test_extent_accounting(u32 se
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree,
 			       BTRFS_MAX_EXTENT_SIZE + sectorsize,
 			       BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1,
-			       EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1085,7 +1087,8 @@ static int test_extent_accounting(u32 se
 
 	/* Empty */
 	ret = clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-			       EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+			       EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+			       EXTENT_UPTODATE, 0, 0, NULL);
 	if (ret) {
 		test_err("clear_extent_bit returned %d", ret);
 		goto out;
@@ -1100,7 +1103,8 @@ static int test_extent_accounting(u32 se
 out:
 	if (ret)
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-				 EXTENT_DELALLOC | EXTENT_UPTODATE, 0, 0, NULL);
+				 EXTENT_DELALLOC | EXTENT_DELALLOC_NEW |
+				 EXTENT_UPTODATE, 0, 0, NULL);
 	iput(inode);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);



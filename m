Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D5E171E2C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbgB0OZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388594AbgB0OKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:10:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9123E24697;
        Thu, 27 Feb 2020 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812648;
        bh=7C14fBJVfL8ckx4LyvL4nrA4ekCR7lDWGPs6KCsLP6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7vfL+V/ksTDOHCOI+lgec7bfJGeAECtCjds1r2FvntmKhup1QdaTI68CQAnCzI4N
         OT6rT2In6H+nfqMnmtF2eixy0iRQD3+KZvEX9peFJxCrVZdyJJX0k8OVuyrk2CE4mX
         RExqbjkBXNR80QlIf+K0hcCn1fJPOhMZd1wztA/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 097/135] Btrfs: fix race between shrinking truncate and fiemap
Date:   Thu, 27 Feb 2020 14:37:17 +0100
Message-Id: <20200227132243.804135072@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 28553fa992cb28be6a65566681aac6cafabb4f2d upstream.

When there is a fiemap executing in parallel with a shrinking truncate
we can end up in a situation where we have extent maps for which we no
longer have corresponding file extent items. This is generally harmless
and at the moment the only consequences are missing file extent items
representing holes after we expand the file size again after the
truncate operation removed the prealloc extent items, and stale
information for future fiemap calls (reporting extents that no longer
exist or may have been reallocated to other files for example).

Consider the following example:

1) Our inode has a size of 128KiB, one 128KiB extent at file offset 0
   and a 1MiB prealloc extent at file offset 128KiB;

2) Task A starts doing a shrinking truncate of our inode to reduce it to
   a size of 64KiB. Before it searches the subvolume tree for file
   extent items to delete, it drops all the extent maps in the range
   from 64KiB to (u64)-1 by calling btrfs_drop_extent_cache();

3) Task B starts doing a fiemap against our inode. When looking up for
   the inode's extent maps in the range from 128KiB to (u64)-1, it
   doesn't find any in the inode's extent map tree, since they were
   removed by task A.  Because it didn't find any in the extent map
   tree, it scans the inode's subvolume tree for file extent items, and
   it finds the 1MiB prealloc extent at file offset 128KiB, then it
   creates an extent map based on that file extent item and adds it to
   inode's extent map tree (this ends up being done by
   btrfs_get_extent() <- btrfs_get_extent_fiemap() <-
   get_extent_skip_holes());

4) Task A then drops the prealloc extent at file offset 128KiB and
   shrinks the 128KiB extent file offset 0 to a length of 64KiB. The
   truncation operation finishes and we end up with an extent map
   representing a 1MiB prealloc extent at file offset 128KiB, despite we
   don't have any more that extent;

After this the two types of problems we have are:

1) Future calls to fiemap always report that a 1MiB prealloc extent
   exists at file offset 128KiB. This is stale information, no longer
   correct;

2) If the size of the file is increased, by a truncate operation that
   increases the file size or by a write into a file offset > 64KiB for
   example, we end up not inserting file extent items to represent holes
   for any range between 128KiB and 128KiB + 1MiB, since the hole
   expansion function, btrfs_cont_expand() will skip hole insertion for
   any range for which an extent map exists that represents a prealloc
   extent. This causes fsck to complain about missing file extent items
   when not using the NO_HOLES feature.

The second issue could be often triggered by test case generic/561 from
fstests, which runs fsstress and duperemove in parallel, and duperemove
does frequent fiemap calls.

Essentially the problems happens because fiemap does not acquire the
inode's lock while truncate does, and fiemap locks the file range in the
inode's iotree while truncate does not. So fix the issue by making
btrfs_truncate_inode_items() lock the file range from the new file size
to (u64)-1, so that it serializes with fiemap.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4734,6 +4734,8 @@ int btrfs_truncate_inode_items(struct bt
 	u64 bytes_deleted = 0;
 	bool be_nice = false;
 	bool should_throttle = false;
+	const u64 lock_start = ALIGN_DOWN(new_size, fs_info->sectorsize);
+	struct extent_state *cached_state = NULL;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4750,6 +4752,9 @@ int btrfs_truncate_inode_items(struct bt
 		return -ENOMEM;
 	path->reada = READA_BACK;
 
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
+			 &cached_state);
+
 	/*
 	 * We want to drop from the next block forward in case this new size is
 	 * not block aligned since we will be keeping the last block of the
@@ -5016,6 +5021,9 @@ out:
 		btrfs_ordered_update_i_size(inode, last_size, NULL);
 	}
 
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
+			     &cached_state);
+
 	btrfs_free_path(path);
 	return ret;
 }



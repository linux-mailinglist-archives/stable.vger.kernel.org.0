Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1374439FE9
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhJYTZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235144AbhJYTX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:23:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3114F61078;
        Mon, 25 Oct 2021 19:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189664;
        bh=h38F0kS9/T8r3/lNg8duCtAx+YaLdgSJrsYFxxTIClM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wk3LnPM0kVbITXgTSbUJdsVNdSahv25qqfQjf0xxQgdmUshqRVd6Yr1ih65JJjdps
         N9eLAy2CGCyDhYFjXZ5aLAa1sFop/Tj3v7ARsSVgfA1Nz6WY6X2FO+fCDW6Li1GUDu
         jQuSoIHE+JzI+nPuYuv7qoCkDHTrYKbsguajcGSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 4.14 01/30] btrfs: always wait on ordered extents at fsync time
Date:   Mon, 25 Oct 2021 21:14:21 +0200
Message-Id: <20211025190923.166779214@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
References: <20211025190922.089277904@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

commit b5e6c3e170b77025b5f6174258c7ad71eed2d4de upstream.

There's a priority inversion that exists currently with btrfs fsync.  In
some cases we will collect outstanding ordered extents onto a list and
only wait on them at the very last second.  However this "very last
second" falls inside of a transaction handle, so if we are in a lower
priority cgroup we can end up holding the transaction open for longer
than needed, so if a high priority cgroup is also trying to fsync()
it'll see latency.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   56 ++++----------------------------------------------------
 1 file changed, 4 insertions(+), 52 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2102,53 +2102,12 @@ int btrfs_sync_file(struct file *file, l
 	atomic_inc(&root->log_batch);
 	full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			     &BTRFS_I(inode)->runtime_flags);
+
 	/*
-	 * We might have have had more pages made dirty after calling
-	 * start_ordered_ops and before acquiring the inode's i_mutex.
+	 * We have to do this here to avoid the priority inversion of waiting on
+	 * IO of a lower priority task while holding a transaciton open.
 	 */
-	if (full_sync) {
-		/*
-		 * For a full sync, we need to make sure any ordered operations
-		 * start and finish before we start logging the inode, so that
-		 * all extents are persisted and the respective file extent
-		 * items are in the fs/subvol btree.
-		 */
-		ret = btrfs_wait_ordered_range(inode, start, len);
-	} else {
-		/*
-		 * Start any new ordered operations before starting to log the
-		 * inode. We will wait for them to finish in btrfs_sync_log().
-		 *
-		 * Right before acquiring the inode's mutex, we might have new
-		 * writes dirtying pages, which won't immediately start the
-		 * respective ordered operations - that is done through the
-		 * fill_delalloc callbacks invoked from the writepage and
-		 * writepages address space operations. So make sure we start
-		 * all ordered operations before starting to log our inode. Not
-		 * doing this means that while logging the inode, writeback
-		 * could start and invoke writepage/writepages, which would call
-		 * the fill_delalloc callbacks (cow_file_range,
-		 * submit_compressed_extents). These callbacks add first an
-		 * extent map to the modified list of extents and then create
-		 * the respective ordered operation, which means in
-		 * tree-log.c:btrfs_log_inode() we might capture all existing
-		 * ordered operations (with btrfs_get_logged_extents()) before
-		 * the fill_delalloc callback adds its ordered operation, and by
-		 * the time we visit the modified list of extent maps (with
-		 * btrfs_log_changed_extents()), we see and process the extent
-		 * map they created. We then use the extent map to construct a
-		 * file extent item for logging without waiting for the
-		 * respective ordered operation to finish - this file extent
-		 * item points to a disk location that might not have yet been
-		 * written to, containing random data - so after a crash a log
-		 * replay will make our inode have file extent items that point
-		 * to disk locations containing invalid data, as we returned
-		 * success to userspace without waiting for the respective
-		 * ordered operation to finish, because it wasn't captured by
-		 * btrfs_get_logged_extents().
-		 */
-		ret = start_ordered_ops(inode, start, end);
-	}
+	ret = btrfs_wait_ordered_range(inode, start, len);
 	if (ret) {
 		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);
@@ -2283,13 +2242,6 @@ int btrfs_sync_file(struct file *file, l
 				goto out;
 			}
 		}
-		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start, len);
-			if (ret) {
-				btrfs_end_transaction(trans);
-				goto out;
-			}
-		}
 		ret = btrfs_commit_transaction(trans);
 	} else {
 		ret = btrfs_end_transaction(trans);



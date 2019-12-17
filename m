Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E101220B6
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfLQA5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:57:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34968 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbfLQAvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003Km-Hk; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0005Yb-Cl; Tue, 17 Dec 2019 00:51:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Filipe Manana" <fdmanana@suse.com>
Date:   Tue, 17 Dec 2019 00:46:49 +0000
Message-ID: <lsq.1576543535.611022098@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 075/136] Btrfs: check for the full sync flag while
 holding the inode lock during fsync
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit ba0b084ac309283db6e329785c1dc4f45fdbd379 upstream.

We were checking for the full fsync flag in the inode before locking the
inode, which is racy, since at that that time it might not be set but
after we acquire the inode lock some other task set it. One case where
this can happen is on a system low on memory and some concurrent task
failed to allocate an extent map and therefore set the full sync flag on
the inode, to force the next fsync to work in full mode.

A consequence of missing the full fsync flag set is hitting the problems
fixed by commit 0c713cbab620 ("Btrfs: fix race between ranged fsync and
writeback of adjacent ranges"), BUG_ON() when dropping extents from a log
tree, hitting assertion failures at tree-log.c:copy_items() or all sorts
of weird inconsistencies after replaying a log due to file extents items
representing ranges that overlap.

So just move the check such that it's done after locking the inode and
before starting writeback again.

Fixes: 0c713cbab620 ("Btrfs: fix race between ranged fsync and writeback of adjacent ranges")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 3.16:
 - Keep the "len" variable since we pass it to btrfs_wait_ordered_range()
   in two different places here
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1888,23 +1888,6 @@ int btrfs_sync_file(struct file *file, l
 	bool full_sync = 0;
 	u64 len;
 
-	/*
-	 * If the inode needs a full sync, make sure we use a full range to
-	 * avoid log tree corruption, due to hole detection racing with ordered
-	 * extent completion for adjacent ranges, and assertion failures during
-	 * hole detection.
-	 */
-	if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
-		     &BTRFS_I(inode)->runtime_flags)) {
-		start = 0;
-		end = LLONG_MAX;
-	}
-
-	/*
-	 * The range length can be represented by u64, we have to do the typecasts
-	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
-	 */
-	len = (u64)end - (u64)start + 1;
 	trace_btrfs_sync_file(file, datasync);
 
 	/*
@@ -1925,6 +1908,25 @@ int btrfs_sync_file(struct file *file, l
 	mutex_lock(&inode->i_mutex);
 
 	/*
+	 * If the inode needs a full sync, make sure we use a full range to
+	 * avoid log tree corruption, due to hole detection racing with ordered
+	 * extent completion for adjacent ranges, and assertion failures during
+	 * hole detection. Do this while holding the inode lock, to avoid races
+	 * with other tasks.
+	 */
+	if (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
+		     &BTRFS_I(inode)->runtime_flags)) {
+		start = 0;
+		end = LLONG_MAX;
+	}
+
+	/*
+	 * The range length can be represented by u64, we have to do the typecasts
+	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
+	 */
+	len = (u64)end - (u64)start + 1;
+
+	/*
 	 * We flush the dirty pages again to avoid some dirty pages in the
 	 * range being left.
 	 */


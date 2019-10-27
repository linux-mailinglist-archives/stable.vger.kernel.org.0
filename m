Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1249EE66EA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfJ0VQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730817AbfJ0VQY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:24 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47B4321848;
        Sun, 27 Oct 2019 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210983;
        bh=DVcNDmrMpYBkIjV95FVKgRjTNOk1MOJLcqQKx6BIxiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAcxBPCrHD5ocmYwF9hj8AaWH4gu2nVvvozea2s5irU+ilPIUxORJlutoOmQhlPyE
         ZDM9D8dqq0Hkjorr1zhr+0Q3xjoOKZKpeSLTZZHduHJ+7GarIZSP0sGrwx2nEdot2B
         iCnTDPrgMS0YO9iNqMTz2i1tXqgW72RTw4VBa4xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 86/93] Btrfs: check for the full sync flag while holding the inode lock during fsync
Date:   Sun, 27 Oct 2019 22:01:38 +0100
Message-Id: <20191027203315.174591110@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: stable@vger.kernel.org # 5.2+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2056,25 +2056,7 @@ int btrfs_sync_file(struct file *file, l
 	struct btrfs_trans_handle *trans;
 	struct btrfs_log_ctx ctx;
 	int ret = 0, err;
-	u64 len;
 
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
 
 	btrfs_init_log_ctx(&ctx, inode);
@@ -2101,6 +2083,19 @@ int btrfs_sync_file(struct file *file, l
 	atomic_inc(&root->log_batch);
 
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
 	 * Before we acquired the inode's lock, someone may have dirtied more
 	 * pages in the target range. We need to make sure that writeback for
 	 * any such pages does not start while we are logging the inode, because
@@ -2127,8 +2122,11 @@ int btrfs_sync_file(struct file *file, l
 	/*
 	 * We have to do this here to avoid the priority inversion of waiting on
 	 * IO of a lower priority task while holding a transaciton open.
+	 *
+	 * Also, the range length can be represented by u64, we have to do the
+	 * typecasts to avoid signed overflow if it's [0, LLONG_MAX].
 	 */
-	ret = btrfs_wait_ordered_range(inode, start, len);
+	ret = btrfs_wait_ordered_range(inode, start, (u64)end - (u64)start + 1);
 	if (ret) {
 		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);



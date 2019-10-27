Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797DDE6473
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfJ0RWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:22:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47665 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727280AbfJ0RWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 13:22:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3CEE622131;
        Sun, 27 Oct 2019 13:22:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 13:22:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NF8inI
        gLFhf8pvCRRMiflc6Bv+AjTWQdfHOZcM6QV/Q=; b=PA/HlSYEsni/vl5ryEfLnI
        ewcLLxEGKP3/rleubadKC1xyTDQXOz/5XIoWgsnlu3gi8Vsn92e+8EQS1SBl4tBM
        5QQ1WSvS1YTcrM0lomyFkjc71U5UohVMts5gh8VZS7znPN5OAEtqfxxEu+tpcZis
        bDyk4+rw9eO6igb3G2HVd1b9OmRMPHG2AItRuj9cJJxESFcVuNy6/2uYHOEbAaCp
        lQE2B5/KUHO93bl5+xOvCPqjQwAACS+kso+kPnI3eoxKCjz8YS94a07ifWsQm3P9
        kgCSMYKrZPeD085iL8NqYYif/9dcPzdPjOJeq9nX/saSLDC6Mpe4wQcL1ok+D0Zw
        ==
X-ME-Sender: <xms:a9K1XQpkRo57S_rwDWtuMHBU4qx9mfwaG0GiZTJiPFTxzacKJYOvUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleejgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeejjedrudehkedrhedtrddutddtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:a9K1XSGmWrYxpO3e54SwkuqlIudPTKdHZhRUxYeBJIt0n9_V9P2OKw>
    <xmx:a9K1XT6INyrhQfMZ9zdfUA-01zEkYIAe2_r1-yZw-otyoJRRKXlasw>
    <xmx:a9K1XVDl1pNN_4wuG5Ip1Huw1JV1vSF61miUeH9msHN4WJggwZLTTg>
    <xmx:bNK1XSyrq0vTy9uy818DiXQIcPixk0QlHrfKA0ZANKz6X4p_JQT6kg>
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        by mail.messagingengine.com (Postfix) with ESMTPA id 687C2D6005B;
        Sun, 27 Oct 2019 13:22:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Btrfs: check for the full sync flag while holding the inode" failed to apply to 4.14-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 16:47:16 +0100
Message-ID: <1572191236128114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba0b084ac309283db6e329785c1dc4f45fdbd379 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 16 Oct 2019 16:28:52 +0100
Subject: [PATCH] Btrfs: check for the full sync flag while holding the inode
 lock during fsync

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

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e955e7fa9201..435a502a3226 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2067,25 +2067,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
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
@@ -2111,6 +2093,19 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	atomic_inc(&root->log_batch);
 
+	/*
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
 	/*
 	 * Before we acquired the inode's lock, someone may have dirtied more
 	 * pages in the target range. We need to make sure that writeback for
@@ -2138,8 +2133,11 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	/*
 	 * We have to do this here to avoid the priority inversion of waiting on
 	 * IO of a lower priority task while holding a transaction open.
+	 *
+	 * Also, the range length can be represented by u64, we have to do the
+	 * typecasts to avoid signed overflow if it's [0, LLONG_MAX].
 	 */
-	ret = btrfs_wait_ordered_range(inode, start, len);
+	ret = btrfs_wait_ordered_range(inode, start, (u64)end - (u64)start + 1);
 	if (ret) {
 		up_write(&BTRFS_I(inode)->dio_sem);
 		inode_unlock(inode);


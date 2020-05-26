Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253D61C3423
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgEDIP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:15:56 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52005 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727878AbgEDIP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:15:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id CB8E85BB;
        Mon,  4 May 2020 04:15:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IaoY8T
        nfCukngkvWpb73suwAbGswegh4kw7U5/Q4Tk0=; b=w14K1AGGip47WgxiKfdrpy
        kKQD+hdtLgQHmqBE6z1CGQ/N3/0iqfAOMXIdTIlzNfQ/TOrM007CSCfLa6ZVv8hQ
        6/rHBH2o8w6+gg0XfQqIPJyWr42XV1Y4KjdPG1l8slhwRa0ov0nDsePoY9V9Tu0f
        4FCR6nqU9BKqupW5+N/q+V70xF7+nd5+vo83oTcau4j4Pl4ZFhPaMf/jokvHx4WC
        qR4BuxcthBFCiZvB2H4I+dd3qB5C/sPUOuMaHj488WpYgSerq1wPoJ7DedZjWDjv
        6743mTTameno5maxzaA6xUjGWnP4nmBJ9wrpDAe5HceLFeXoGz6TWsKZHDyeEzhw
        ==
X-ME-Sender: <xms:O8-vXgg5Fqp53U_SdplPVWQJ4N5KRhXNClT4ihCIB12LsYFTevg2ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejudetveeuve
    eludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhi
    iigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:O8-vXjmG_VPxL-3bPhIT--d81Wkm01PsVnzKkF7fPWTv1rs1HwGdbw>
    <xmx:O8-vXkpqNY1ijVtcP67OyJJHgRW5n4q70_HumeyRmB7VkvL08dfg3A>
    <xmx:O8-vXkHztfK3nQ1avZLBa7aWqkoZFsI8oQ3z70DObg9DtcKV5Y9bhQ>
    <xmx:O8-vXuL0-97TejDB_FpHHlw6c12-nbmRpNA0_EJu0r2StUmTTq2jSuXtmcg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D712328005D;
        Mon,  4 May 2020 04:15:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: transaction: Avoid deadlock due to bad initialization" failed to apply to 4.9-stable tree
To:     wqu@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:15:52 +0200
Message-ID: <1588580152176231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fcc99734d1d4ced30167eb02e17f656735cb9928 Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Mon, 27 Apr 2020 14:50:14 +0800
Subject: [PATCH] btrfs: transaction: Avoid deadlock due to bad initialization
 timing of fs_info::journal_info

[BUG]
One run of btrfs/063 triggered the following lockdep warning:
  ============================================
  WARNING: possible recursive locking detected
  5.6.0-rc7-custom+ #48 Not tainted
  --------------------------------------------
  kworker/u24:0/7 is trying to acquire lock:
  ffff88817d3a46e0 (sb_internal#2){.+.+}, at: start_transaction+0x66c/0x890 [btrfs]

  but task is already holding lock:
  ffff88817d3a46e0 (sb_internal#2){.+.+}, at: start_transaction+0x66c/0x890 [btrfs]

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(sb_internal#2);
    lock(sb_internal#2);

   *** DEADLOCK ***

   May be due to missing lock nesting notation

  4 locks held by kworker/u24:0/7:
   #0: ffff88817b495948 ((wq_completion)btrfs-endio-write){+.+.}, at: process_one_work+0x557/0xb80
   #1: ffff888189ea7db8 ((work_completion)(&work->normal_work)){+.+.}, at: process_one_work+0x557/0xb80
   #2: ffff88817d3a46e0 (sb_internal#2){.+.+}, at: start_transaction+0x66c/0x890 [btrfs]
   #3: ffff888174ca4da8 (&fs_info->reloc_mutex){+.+.}, at: btrfs_record_root_in_trans+0x83/0xd0 [btrfs]

  stack backtrace:
  CPU: 0 PID: 7 Comm: kworker/u24:0 Not tainted 5.6.0-rc7-custom+ #48
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
  Call Trace:
   dump_stack+0xc2/0x11a
   __lock_acquire.cold+0xce/0x214
   lock_acquire+0xe6/0x210
   __sb_start_write+0x14e/0x290
   start_transaction+0x66c/0x890 [btrfs]
   btrfs_join_transaction+0x1d/0x20 [btrfs]
   find_free_extent+0x1504/0x1a50 [btrfs]
   btrfs_reserve_extent+0xd5/0x1f0 [btrfs]
   btrfs_alloc_tree_block+0x1ac/0x570 [btrfs]
   btrfs_copy_root+0x213/0x580 [btrfs]
   create_reloc_root+0x3bd/0x470 [btrfs]
   btrfs_init_reloc_root+0x2d2/0x310 [btrfs]
   record_root_in_trans+0x191/0x1d0 [btrfs]
   btrfs_record_root_in_trans+0x90/0xd0 [btrfs]
   start_transaction+0x16e/0x890 [btrfs]
   btrfs_join_transaction+0x1d/0x20 [btrfs]
   btrfs_finish_ordered_io+0x55d/0xcd0 [btrfs]
   finish_ordered_fn+0x15/0x20 [btrfs]
   btrfs_work_helper+0x116/0x9a0 [btrfs]
   process_one_work+0x632/0xb80
   worker_thread+0x80/0x690
   kthread+0x1a3/0x1f0
   ret_from_fork+0x27/0x50

It's pretty hard to reproduce, only one hit so far.

[CAUSE]
This is because we're calling btrfs_join_transaction() without re-using
the current running one:

btrfs_finish_ordered_io()
|- btrfs_join_transaction()		<<< Call #1
   |- btrfs_record_root_in_trans()
      |- btrfs_reserve_extent()
	 |- btrfs_join_transaction()	<<< Call #2

Normally such btrfs_join_transaction() call should re-use the existing
one, without trying to re-start a transaction.

But the problem is, in btrfs_join_transaction() call #1, we call
btrfs_record_root_in_trans() before initializing current::journal_info.

And in btrfs_join_transaction() call #2, we're relying on
current::journal_info to avoid such deadlock.

[FIX]
Call btrfs_record_root_in_trans() after we have initialized
current::journal_info.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8cede6eb9843..2d5498136e5e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -662,10 +662,19 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	}
 
 got_it:
-	btrfs_record_root_in_trans(h, root);
-
 	if (!current->journal_info)
 		current->journal_info = h;
+
+	/*
+	 * btrfs_record_root_in_trans() needs to alloc new extents, and may
+	 * call btrfs_join_transaction() while we're also starting a
+	 * transaction.
+	 *
+	 * Thus it need to be called after current->journal_info initialized,
+	 * or we can deadlock.
+	 */
+	btrfs_record_root_in_trans(h, root);
+
 	return h;
 
 join_fail:


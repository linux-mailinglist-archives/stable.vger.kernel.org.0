Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0495328CAE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbhCAS5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240342AbhCASvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:51:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9476865249;
        Mon,  1 Mar 2021 17:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619662;
        bh=6gEh/z8HWDDvD8DeB9KdmWojXb+kCwZ1TjQ9xEDhDa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XsXWBUo5BPYzvYioOg+3sysNawxVnrm0PQVa9uM5HIQuadSsLNqIpFl3SZm8Ijki
         Hpp/7b2Cjwr2UbEiRdZfcvNb1C+6NF1fwZtpw81skD1Gnu/yDXQQdTiVlBO2SfhbTJ
         g22HedVQFH7xtRccDkJXOqrZpTI5ysDNUnWvP+Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 536/663] btrfs: splice remaining dirty_bgs onto the transaction dirty bg list
Date:   Mon,  1 Mar 2021 17:13:04 +0100
Message-Id: <20210301161208.373902981@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 938fcbfb0cbcf532a1869efab58e6009446b1ced upstream.

While doing error injection testing with my relocation patches I hit the
following assert:

  assertion failed: list_empty(&block_group->dirty_list), in fs/btrfs/block-group.c:3356
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3357!
  invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 0 PID: 24351 Comm: umount Tainted: G        W         5.10.0-rc3+ #193
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  RIP: 0010:assertfail.constprop.0+0x18/0x1a
  RSP: 0018:ffffa09b019c7e00 EFLAGS: 00010282
  RAX: 0000000000000056 RBX: ffff8f6492c18000 RCX: 0000000000000000
  RDX: ffff8f64fbc27c60 RSI: ffff8f64fbc19050 RDI: ffff8f64fbc19050
  RBP: ffff8f6483bbdc00 R08: 0000000000000000 R09: 0000000000000000
  R10: ffffa09b019c7c38 R11: ffffffff85d70928 R12: ffff8f6492c18100
  R13: ffff8f6492c18148 R14: ffff8f6483bbdd70 R15: dead000000000100
  FS:  00007fbfda4cdc40(0000) GS:ffff8f64fbc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007fbfda666fd0 CR3: 000000013cf66002 CR4: 0000000000370ef0
  Call Trace:
   btrfs_free_block_groups.cold+0x55/0x55
   close_ctree+0x2c5/0x306
   ? fsnotify_destroy_marks+0x14/0x100
   generic_shutdown_super+0x6c/0x100
   kill_anon_super+0x14/0x30
   btrfs_kill_super+0x12/0x20
   deactivate_locked_super+0x36/0xa0
   cleanup_mnt+0x12d/0x190
   task_work_run+0x5c/0xa0
   exit_to_user_mode_prepare+0x1b1/0x1d0
   syscall_exit_to_user_mode+0x54/0x280
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This happened because I injected an error in btrfs_cow_block() while
running the dirty block groups.  When we run the dirty block groups, we
splice the list onto a local list to process.  However if an error
occurs, we only cleanup the transactions dirty block group list, not any
pending block groups we have on our locally spliced list.

In fact if we fail to allocate a path in this function we'll also fail
to clean up the splice list.

Fix this by splicing the list back onto the transaction dirty block
group list so that the block groups are cleaned up.  Then add a 'out'
label and have the error conditions jump to out so that the errors are
handled properly.  This also has the side-effect of fixing a problem
where we would clear 'ret' on error because we unconditionally ran
btrfs_run_delayed_refs().

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2582,8 +2582,10 @@ again:
 
 	if (!path) {
 		path = btrfs_alloc_path();
-		if (!path)
-			return -ENOMEM;
+		if (!path) {
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	/*
@@ -2677,16 +2679,14 @@ again:
 			btrfs_put_block_group(cache);
 		if (drop_reserve)
 			btrfs_delayed_refs_rsv_release(fs_info, 1);
-
-		if (ret)
-			break;
-
 		/*
 		 * Avoid blocking other tasks for too long. It might even save
 		 * us from writing caches for block groups that are going to be
 		 * removed.
 		 */
 		mutex_unlock(&trans->transaction->cache_write_mutex);
+		if (ret)
+			goto out;
 		mutex_lock(&trans->transaction->cache_write_mutex);
 	}
 	mutex_unlock(&trans->transaction->cache_write_mutex);
@@ -2710,7 +2710,12 @@ again:
 			goto again;
 		}
 		spin_unlock(&cur_trans->dirty_bgs_lock);
-	} else if (ret < 0) {
+	}
+out:
+	if (ret < 0) {
+		spin_lock(&cur_trans->dirty_bgs_lock);
+		list_splice_init(&dirty, &cur_trans->dirty_bgs);
+		spin_unlock(&cur_trans->dirty_bgs_lock);
 		btrfs_cleanup_dirty_bgs(cur_trans, fs_info);
 	}
 



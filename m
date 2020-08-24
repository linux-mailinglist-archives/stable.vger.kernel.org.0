Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA58924F919
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgHXIpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgHXIpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:45:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1B321741;
        Mon, 24 Aug 2020 08:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258711;
        bh=M4z6on9r6wlNLY/GOUFNFqaR4s897OfOKj3P/Hay3bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlhZFwDKtETXx3owdv0XfuLbxhhsG1JFALJkdny9twp+xKQFRR3QmP8F76F6u7URz
         pmKXMKP0WG/YLWbt7SYoJMkZOfeDBnptZegY4ETY1FHTOeJChRlRdsPqCFX3hpq7Ss
         gKBZvefZ1WwPUOVy77uYnJ5iHpA9384vN0z3Jrxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 019/107] btrfs: return EROFS for BTRFS_FS_STATE_ERROR cases
Date:   Mon, 24 Aug 2020 10:29:45 +0200
Message-Id: <20200824082406.038630748@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

Eric reported seeing this message while running generic/475

  BTRFS: error (device dm-3) in btrfs_sync_log:3084: errno=-117 Filesystem corrupted

Full stack trace:

  BTRFS: error (device dm-0) in btrfs_commit_transaction:2323: errno=-5 IO failure (Error while writing out transaction)
  BTRFS info (device dm-0): forced readonly
  BTRFS warning (device dm-0): Skipping commit of aborted transaction.
  ------------[ cut here ]------------
  BTRFS: error (device dm-0) in cleanup_transaction:1894: errno=-5 IO failure
  BTRFS: Transaction aborted (error -117)
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6480 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6488 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6490 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c6498 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64a0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64a8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64b0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64b8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3555 rw 0,0 sector 0x1c64c0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3572 rw 0,0 sector 0x1b85e8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3572 rw 0,0 sector 0x1b85f0 len 4096 err no 10
  WARNING: CPU: 3 PID: 23985 at fs/btrfs/tree-log.c:3084 btrfs_sync_log+0xbc8/0xd60 [btrfs]
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d4288 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d4290 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d4298 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42a0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42a8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42b0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42b8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42c0 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42c8 len 4096 err no 10
  BTRFS warning (device dm-0): direct IO failed ino 3548 rw 0,0 sector 0x1d42d0 len 4096 err no 10
  CPU: 3 PID: 23985 Comm: fsstress Tainted: G        W    L    5.8.0-rc4-default+ #1181
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  RIP: 0010:btrfs_sync_log+0xbc8/0xd60 [btrfs]
  RSP: 0018:ffff909a44d17bd0 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
  RDX: ffff8f3be41cb940 RSI: ffffffffb0108d2b RDI: ffffffffb0108ff7
  RBP: ffff909a44d17e70 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000037988 R12: ffff8f3bd20e4000
  R13: ffff8f3bd20e4428 R14: 00000000ffffff8b R15: ffff909a44d17c70
  FS:  00007f6a6ed3fb80(0000) GS:ffff8f3c3dc00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f6a6ed3e000 CR3: 00000000525c0003 CR4: 0000000000160ee0
  Call Trace:
   ? finish_wait+0x90/0x90
   ? __mutex_unlock_slowpath+0x45/0x2a0
   ? lock_acquire+0xa3/0x440
   ? lockref_put_or_lock+0x9/0x30
   ? dput+0x20/0x4a0
   ? dput+0x20/0x4a0
   ? do_raw_spin_unlock+0x4b/0xc0
   ? _raw_spin_unlock+0x1f/0x30
   btrfs_sync_file+0x335/0x490 [btrfs]
   do_fsync+0x38/0x70
   __x64_sys_fsync+0x10/0x20
   do_syscall_64+0x50/0xe0
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f6a6ef1b6e3
  Code: Bad RIP value.
  RSP: 002b:00007ffd01e20038 EFLAGS: 00000246 ORIG_RAX: 000000000000004a
  RAX: ffffffffffffffda RBX: 000000000007a120 RCX: 00007f6a6ef1b6e3
  RDX: 00007ffd01e1ffa0 RSI: 00007ffd01e1ffa0 RDI: 0000000000000003
  RBP: 0000000000000003 R08: 0000000000000001 R09: 00007ffd01e2004c
  R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000009f
  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  irq event stamp: 0
  hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  hardirqs last disabled at (0): [<ffffffffb007fe0b>] copy_process+0x67b/0x1b00
  softirqs last  enabled at (0): [<ffffffffb007fe0b>] copy_process+0x67b/0x1b00
  softirqs last disabled at (0): [<0000000000000000>] 0x0
  ---[ end trace af146e0e38433456 ]---
  BTRFS: error (device dm-0) in btrfs_sync_log:3084: errno=-117 Filesystem corrupted

This ret came from btrfs_write_marked_extents().  If we get an aborted
transaction via EIO before, we'll see it in btree_write_cache_pages()
and return EUCLEAN, which gets printed as "Filesystem corrupted".

Except we shouldn't be returning EUCLEAN here, we need to be returning
EROFS because EUCLEAN is reserved for actual corruption, not IO errors.

We are inconsistent about our handling of BTRFS_FS_STATE_ERROR
elsewhere, but we want to use EROFS for this particular case.  The
original transaction abort has the real error code for why we ended up
with an aborted transaction, all subsequent actions just need to return
EROFS because they may not have a trans handle and have no idea about
the original cause of the abort.

After patch "btrfs: don't WARN if we abort a transaction with EROFS" the
stacktrace will not be dumped either.

Reported-by: Eric Sandeen <esandeen@redhat.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add full test stacktrace ]
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c   | 2 +-
 fs/btrfs/scrub.c       | 2 +-
 fs/btrfs/transaction.c | 5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 035ea5bc692ad..5707bf0575d43 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4073,7 +4073,7 @@ retry:
 	if (!test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
 		ret = flush_write_bio(&epd);
 	} else {
-		ret = -EUCLEAN;
+		ret = -EROFS;
 		end_write_bio(&epd, ret);
 	}
 	return ret;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index a7b043fd7a572..498b824148187 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3717,7 +3717,7 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
-		return -EIO;
+		return -EROFS;
 
 	/* Seed devices of a new filesystem has their own generation. */
 	if (scrub_dev->fs_devices != fs_info->fs_devices)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 54589e940f9af..465ddb297c381 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -873,7 +873,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (trans->aborted ||
 	    test_bit(BTRFS_FS_STATE_ERROR, &info->fs_state)) {
 		wake_up_process(info->transaction_kthread);
-		err = -EIO;
+		if (TRANS_ABORTED(trans))
+			err = trans->aborted;
+		else
+			err = -EROFS;
 	}
 
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
-- 
2.25.1




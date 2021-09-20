Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D9F411FA6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353039AbhITRne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346881AbhITRld (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B516162E;
        Mon, 20 Sep 2021 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157715;
        bh=uP+9oEiMHCyeSLzw6YU5rriqRkMUUSgMMK59kQq2p5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5el0D0fhkJxeFso8jOghupepWGk3apCoL6URaZF2JbvAIzb2TVljqLiyJCotl2Sp
         RGQp0fvRtAV8a2bSESkzl0IUrz57II/VVAsjjYBHR4rTm66vzxvUQU1x1lCq2iNHyw
         o45XSv17tQgHMpKaFcw1yndzIS5aVuOcZ5qhTKhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Subject: [PATCH 4.19 119/293] btrfs: reset replace target device to allocation state on close
Date:   Mon, 20 Sep 2021 18:41:21 +0200
Message-Id: <20210920163937.332373742@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit 0d977e0eba234e01a60bdde27314dc21374201b3 upstream.

This crash was observed with a failed assertion on device close:

  BTRFS: Transaction aborted (error -28)
  WARNING: CPU: 1 PID: 3902 at fs/btrfs/extent-tree.c:2150 btrfs_run_delayed_refs+0x1d2/0x1e0 [btrfs]
  Modules linked in: btrfs blake2b_generic libcrc32c crc32c_intel xor zstd_decompress zstd_compress xxhash lzo_compress lzo_decompress raid6_pq loop
  CPU: 1 PID: 3902 Comm: kworker/u8:4 Not tainted 5.14.0-rc5-default+ #1532
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
  RIP: 0010:btrfs_run_delayed_refs+0x1d2/0x1e0 [btrfs]
  RSP: 0018:ffffb7a5452d7d80 EFLAGS: 00010282
  RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: ffffffffabee13c4 RDI: 00000000ffffffff
  RBP: ffff97834176a378 R08: 0000000000000001 R09: 0000000000000001
  R10: 0000000000000000 R11: 0000000000000001 R12: ffff97835195d388
  R13: 0000000005b08000 R14: ffff978385484000 R15: 000000000000016c
  FS:  0000000000000000(0000) GS:ffff9783bd800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000056190d003fe8 CR3: 000000002a81e005 CR4: 0000000000170ea0
  Call Trace:
   flush_space+0x197/0x2f0 [btrfs]
   btrfs_async_reclaim_metadata_space+0x139/0x300 [btrfs]
   process_one_work+0x262/0x5e0
   worker_thread+0x4c/0x320
   ? process_one_work+0x5e0/0x5e0
   kthread+0x144/0x170
   ? set_kthread_struct+0x40/0x40
   ret_from_fork+0x1f/0x30
  irq event stamp: 19334989
  hardirqs last  enabled at (19334997): [<ffffffffab0e0c87>] console_unlock+0x2b7/0x400
  hardirqs last disabled at (19335006): [<ffffffffab0e0d0d>] console_unlock+0x33d/0x400
  softirqs last  enabled at (19334900): [<ffffffffaba0030d>] __do_softirq+0x30d/0x574
  softirqs last disabled at (19334893): [<ffffffffab0721ec>] irq_exit_rcu+0x12c/0x140
  ---[ end trace 45939e308e0dd3c7 ]---
  BTRFS: error (device vdd) in btrfs_run_delayed_refs:2150: errno=-28 No space left
  BTRFS info (device vdd): forced readonly
  BTRFS warning (device vdd): failed setting block group ro: -30
  BTRFS info (device vdd): suspending dev_replace for unmount
  assertion failed: !test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state), in fs/btrfs/volumes.c:1150
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3431!
  invalid opcode: 0000 [#1] PREEMPT SMP
  CPU: 1 PID: 3982 Comm: umount Tainted: G        W         5.14.0-rc5-default+ #1532
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  RIP: 0010:assertfail.constprop.0+0x18/0x1a [btrfs]
  RSP: 0018:ffffb7a5454c7db8 EFLAGS: 00010246
  RAX: 0000000000000068 RBX: ffff978364b91c00 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: ffffffffabee13c4 RDI: 00000000ffffffff
  RBP: ffff9783523a4c00 R08: 0000000000000001 R09: 0000000000000001
  R10: 0000000000000000 R11: 0000000000000001 R12: ffff9783523a4d18
  R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000000003
  FS:  00007f61c8f42800(0000) GS:ffff9783bd800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000056190cffa810 CR3: 0000000030b96002 CR4: 0000000000170ea0
  Call Trace:
   btrfs_close_one_device.cold+0x11/0x55 [btrfs]
   close_fs_devices+0x44/0xb0 [btrfs]
   btrfs_close_devices+0x48/0x160 [btrfs]
   generic_shutdown_super+0x69/0x100
   kill_anon_super+0x14/0x30
   btrfs_kill_super+0x12/0x20 [btrfs]
   deactivate_locked_super+0x2c/0xa0
   cleanup_mnt+0x144/0x1b0
   task_work_run+0x59/0xa0
   exit_to_user_mode_loop+0xe7/0xf0
   exit_to_user_mode_prepare+0xaf/0xf0
   syscall_exit_to_user_mode+0x19/0x50
   do_syscall_64+0x4a/0x90
   entry_SYSCALL_64_after_hwframe+0x44/0xae

This happens when close_ctree is called while a dev_replace hasn't
completed. In close_ctree, we suspend the dev_replace, but keep the
replace target around so that we can resume the dev_replace procedure
when we mount the root again. This is the call trace:

  close_ctree():
    btrfs_dev_replace_suspend_for_unmount();
    btrfs_close_devices():
      btrfs_close_fs_devices():
        btrfs_close_one_device():
          ASSERT(!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
                 &device->dev_state));

However, since the replace target sticks around, there is a device
with BTRFS_DEV_STATE_REPLACE_TGT set on close, and we fail the
assertion in btrfs_close_one_device.

To fix this, if we come across the replace target device when
closing, we should properly reset it back to allocation state. This
fix also ensures that if a non-target device has a corrupted state and
has the BTRFS_DEV_STATE_REPLACE_TGT bit set, the assertion will still
catch the error.

Reported-by: David Sterba <dsterba@suse.com>
Fixes: b2a616676839 ("btrfs: fix rw device counting in __btrfs_free_extra_devids")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1048,6 +1048,9 @@ static void btrfs_close_one_device(struc
 		fs_devices->rw_devices--;
 	}
 
+	if (device->devid == BTRFS_DEV_REPLACE_DEVID)
+		clear_bit(BTRFS_DEV_STATE_REPLACE_TGT, &device->dev_state);
+
 	if (test_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state))
 		fs_devices->missing_devices--;
 



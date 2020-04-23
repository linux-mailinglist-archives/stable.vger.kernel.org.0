Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115601B68A2
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDWXQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:16:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49468 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgDWXGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:44 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-0004iO-Bw; Fri, 24 Apr 2020 00:06:35 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvQ-00E6op-Tl; Fri, 24 Apr 2020 00:06:32 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Josef Bacik" <josef@toxicpanda.com>
Date:   Fri, 24 Apr 2020 00:05:49 +0100
Message-ID: <lsq.1587683028.582487781@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 122/245] btrfs: check rw_devices, not num_devices for
 balance
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit b35cf1f0bf1f2b0b193093338414b9bd63b29015 upstream.

The fstest btrfs/154 reports

  [ 8675.381709] BTRFS: Transaction aborted (error -28)
  [ 8675.383302] WARNING: CPU: 1 PID: 31900 at fs/btrfs/block-group.c:2038 btrfs_create_pending_block_groups+0x1e0/0x1f0 [btrfs]
  [ 8675.390925] CPU: 1 PID: 31900 Comm: btrfs Not tainted 5.5.0-rc6-default+ #935
  [ 8675.392780] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
  [ 8675.395452] RIP: 0010:btrfs_create_pending_block_groups+0x1e0/0x1f0 [btrfs]
  [ 8675.402672] RSP: 0018:ffffb2090888fb00 EFLAGS: 00010286
  [ 8675.404413] RAX: 0000000000000000 RBX: ffff92026dfa91c8 RCX: 0000000000000001
  [ 8675.406609] RDX: 0000000000000000 RSI: ffffffff8e100899 RDI: ffffffff8e100971
  [ 8675.408775] RBP: ffff920247c61660 R08: 0000000000000000 R09: 0000000000000000
  [ 8675.410978] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffe4
  [ 8675.412647] R13: ffff92026db74000 R14: ffff920247c616b8 R15: ffff92026dfbc000
  [ 8675.413994] FS:  00007fd5e57248c0(0000) GS:ffff92027d800000(0000) knlGS:0000000000000000
  [ 8675.416146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 8675.417833] CR2: 0000564aa51682d8 CR3: 000000006dcbc004 CR4: 0000000000160ee0
  [ 8675.419801] Call Trace:
  [ 8675.420742]  btrfs_start_dirty_block_groups+0x355/0x480 [btrfs]
  [ 8675.422600]  btrfs_commit_transaction+0xc8/0xaf0 [btrfs]
  [ 8675.424335]  reset_balance_state+0x14a/0x190 [btrfs]
  [ 8675.425824]  btrfs_balance.cold+0xe7/0x154 [btrfs]
  [ 8675.427313]  ? kmem_cache_alloc_trace+0x235/0x2c0
  [ 8675.428663]  btrfs_ioctl_balance+0x298/0x350 [btrfs]
  [ 8675.430285]  btrfs_ioctl+0x466/0x2550 [btrfs]
  [ 8675.431788]  ? mem_cgroup_charge_statistics+0x51/0xf0
  [ 8675.433487]  ? mem_cgroup_commit_charge+0x56/0x400
  [ 8675.435122]  ? do_raw_spin_unlock+0x4b/0xc0
  [ 8675.436618]  ? _raw_spin_unlock+0x1f/0x30
  [ 8675.438093]  ? __handle_mm_fault+0x499/0x740
  [ 8675.439619]  ? do_vfs_ioctl+0x56e/0x770
  [ 8675.441034]  do_vfs_ioctl+0x56e/0x770
  [ 8675.442411]  ksys_ioctl+0x3a/0x70
  [ 8675.443718]  ? trace_hardirqs_off_thunk+0x1a/0x1c
  [ 8675.445333]  __x64_sys_ioctl+0x16/0x20
  [ 8675.446705]  do_syscall_64+0x50/0x210
  [ 8675.448059]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [ 8675.479187] BTRFS: error (device vdb) in btrfs_create_pending_block_groups:2038: errno=-28 No space left

We now use btrfs_can_overcommit() to see if we can flip a block group
read only.  Before this would fail because we weren't taking into
account the usable un-allocated space for allocating chunks.  With my
patches we were allowed to do the balance, which is technically correct.

The test is trying to start balance on degraded mount.  So now we're
trying to allocate a chunk and cannot because we want to allocate a
RAID1 chunk, but there's only 1 device that's available for usage.  This
results in an ENOSPC.

But we shouldn't even be making it this far, we don't have enough
devices to restripe.  The problem is we're using btrfs_num_devices(),
that also includes missing devices. That's not actually what we want, we
need to use rw_devices.

The chunk_mutex is not needed here, rw_devices changes only in device
add, remove or replace, all are excluded by EXCL_OP mechanism.

Fixes: e4d8ec0f65b9 ("Btrfs: implement online profile changing")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add stacktrace, update changelog, drop chunk_mutex ]
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3248,7 +3248,11 @@ int btrfs_balance(struct btrfs_balance_c
 		}
 	}
 
-	num_devices = fs_info->fs_devices->num_devices;
+	/*
+	 * rw_devices will not change at the moment, device add/delete/replace
+	 * are excluded by EXCL_OP
+	 */
+	num_devices = fs_info->fs_devices->rw_devices;
 	btrfs_dev_replace_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
 		BUG_ON(num_devices < 1);


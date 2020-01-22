Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA0C14561C
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgAVNUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730075AbgAVNUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:53 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A77624689;
        Wed, 22 Jan 2020 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699252;
        bh=bPZ44sF9qIIGRnwcT22CJ2abw0+ZnFcmrYw1HnP6yPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whbY9gHnXL4JkwaLw+hvvcy3Raiaqwkb6W/mCjyqQoe2R+GExnfjnlBxS5Fkhm7pL
         DDealQqa76B3xeGzWWzbFybLBccsYznBONvwdqSKBtILoehexPxt3SZWGCQmtld3xK
         mn9cN9+wtimkhT8c6ZmxCpMVyRXvJsHgUDYd5fQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 088/222] btrfs: check rw_devices, not num_devices for balance
Date:   Wed, 22 Jan 2020 10:27:54 +0100
Message-Id: <20200122092840.022686074@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add stacktrace, update changelog, drop chunk_mutex ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4066,7 +4066,11 @@ int btrfs_balance(struct btrfs_fs_info *
 		}
 	}
 
-	num_devices = btrfs_num_devices(fs_info);
+	/*
+	 * rw_devices will not change at the moment, device add/delete/replace
+	 * are excluded by EXCL_OP
+	 */
+	num_devices = fs_info->fs_devices->rw_devices;
 
 	/*
 	 * SINGLE profile on-disk has no profile bit, but in-memory we have a



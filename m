Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDF12A5891
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgKCUqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:46:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731218AbgKCUqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:46:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C6620719;
        Tue,  3 Nov 2020 20:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436391;
        bh=HBlQ9LZsfl6/uypx/JWOg6euGZccDjx7Bv6yZdb66PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWbw1kZrPEozQ8kKlX4zMOS6SfTgJYW9qvYgmbZU7NuwN3KVg+mTBmYF7imdNJ6Zr
         kNPJeRSx8N32b5OIidbm7JHlnMj9SrVUQ2z6iOmdg4jmuIvuJhvDLt2gM02rX86g4r
         d1xiJMrfrJF6Di/zMk4WngyRFMiLWb4dFeFMG4SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 231/391] btrfs: reschedule when cloning lots of extents
Date:   Tue,  3 Nov 2020 21:34:42 +0100
Message-Id: <20201103203402.572794776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 6b613cc97f0ace77f92f7bc112b8f6ad3f52baf8 upstream.

We have several occurrences of a soft lockup from fstest's generic/175
testcase, which look more or less like this one:

  watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [xfs_io:10030]
  Kernel panic - not syncing: softlockup: hung tasks
  CPU: 0 PID: 10030 Comm: xfs_io Tainted: G             L    5.9.0-rc5+ #768
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   <IRQ>
   dump_stack+0x77/0xa0
   panic+0xfa/0x2cb
   watchdog_timer_fn.cold+0x85/0xa5
   ? lockup_detector_update_enable+0x50/0x50
   __hrtimer_run_queues+0x99/0x4c0
   ? recalibrate_cpu_khz+0x10/0x10
   hrtimer_run_queues+0x9f/0xb0
   update_process_times+0x28/0x80
   tick_handle_periodic+0x1b/0x60
   __sysvec_apic_timer_interrupt+0x76/0x210
   asm_call_on_stack+0x12/0x20
   </IRQ>
   sysvec_apic_timer_interrupt+0x7f/0x90
   asm_sysvec_apic_timer_interrupt+0x12/0x20
  RIP: 0010:btrfs_tree_unlock+0x91/0x1a0 [btrfs]
  RSP: 0018:ffffc90007123a58 EFLAGS: 00000282
  RAX: ffff8881cea2fbe0 RBX: ffff8881cea2fbe0 RCX: 0000000000000000
  RDX: ffff8881d23fd200 RSI: ffffffff82045220 RDI: ffff8881cea2fba0
  RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000032
  R10: 0000160000000000 R11: 0000000000001000 R12: 0000000000001000
  R13: ffff8882357fd5b0 R14: ffff88816fa76e70 R15: ffff8881cea2fad0
   ? btrfs_tree_unlock+0x15b/0x1a0 [btrfs]
   btrfs_release_path+0x67/0x80 [btrfs]
   btrfs_insert_replace_extent+0x177/0x2c0 [btrfs]
   btrfs_replace_file_extents+0x472/0x7c0 [btrfs]
   btrfs_clone+0x9ba/0xbd0 [btrfs]
   btrfs_clone_files.isra.0+0xeb/0x140 [btrfs]
   ? file_update_time+0xcd/0x120
   btrfs_remap_file_range+0x322/0x3b0 [btrfs]
   do_clone_file_range+0xb7/0x1e0
   vfs_clone_file_range+0x30/0xa0
   ioctl_file_clone+0x8a/0xc0
   do_vfs_ioctl+0x5b2/0x6f0
   __x64_sys_ioctl+0x37/0xa0
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7f87977fc247
  RSP: 002b:00007ffd51a2f6d8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f87977fc247
  RDX: 00007ffd51a2f710 RSI: 000000004020940d RDI: 0000000000000003
  RBP: 0000000000000004 R08: 00007ffd51a79080 R09: 0000000000000000
  R10: 00005621f11352f2 R11: 0000000000000206 R12: 0000000000000000
  R13: 0000000000000000 R14: 00005621f128b958 R15: 0000000080000000
  Kernel Offset: disabled
  ---[ end Kernel panic - not syncing: softlockup: hung tasks ]---

All of these lockup reports have the call chain btrfs_clone_files() ->
btrfs_clone() in common. btrfs_clone_files() calls btrfs_clone() with
both source and destination extents locked and loops over the source
extent to create the clones.

Conditionally reschedule in the btrfs_clone() loop, to give some time back
to other processes.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/reflink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -520,6 +520,8 @@ process_slot:
 			ret = -EINTR;
 			goto out;
 		}
+
+		cond_resched();
 	}
 	ret = 0;
 



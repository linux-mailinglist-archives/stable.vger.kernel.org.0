Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337983830FF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbhEQOdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240156AbhEQObk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE0D16188B;
        Mon, 17 May 2021 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260924;
        bh=kMn4RFNvDFdJL1/7yB5yKHhlMmK8ComZ7gjDYAWxfN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bjm9dkJsBO7pmYckDWPYvGtM6XKZicS1LnlAE4iDcwXurtH0NF6qgPbIZ5viDW18d
         ft+TtMtT1tB+Ua3KZ2DtbmEiI5ZCCE42Gd2XVuRG1r6E6B/eN1mEbmGwpCPDGoUZ9e
         /qnl0IyFgUN4uXia58QW4UEh3jacLJSfiCKadgrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 268/363] btrfs: zoned: sanity check zone type
Date:   Mon, 17 May 2021 16:02:14 +0200
Message-Id: <20210517140311.672780868@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 784daf2b9628f2d0117f1f0b578cfe5ab6634919 upstream.

The fstests test case generic/475 creates a dm-linear device that gets
changed to a dm-error device. This leads to errors in loading the block
group's zone information when running on a zoned file system, ultimately
resulting in a list corruption. When running on a kernel with list
debugging enabled this leads to the following crash.

 BTRFS: error (device dm-2) in cleanup_transaction:1953: errno=-5 IO failure
 kernel BUG at lib/list_debug.c:54!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 1 PID: 2433 Comm: umount Tainted: G        W         5.12.0+ #1018
 RIP: 0010:__list_del_entry_valid.cold+0x1d/0x47
 RSP: 0018:ffffc90001473df0 EFLAGS: 00010296
 RAX: 0000000000000054 RBX: ffff8881038fd000 RCX: ffffc90001473c90
 RDX: 0000000100001a31 RSI: 0000000000000003 RDI: 0000000000000003
 RBP: ffff888308871108 R08: 0000000000000003 R09: 0000000000000001
 R10: 3961373532383838 R11: 6666666620736177 R12: ffff888308871000
 R13: ffff8881038fd088 R14: ffff8881038fdc78 R15: dead000000000100
 FS:  00007f353c9b1540(0000) GS:ffff888627d00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f353cc2c710 CR3: 000000018e13c000 CR4: 00000000000006a0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  btrfs_free_block_groups+0xc9/0x310 [btrfs]
  close_ctree+0x2ee/0x31a [btrfs]
  ? call_rcu+0x8f/0x270
  ? mutex_lock+0x1c/0x40
  generic_shutdown_super+0x67/0x100
  kill_anon_super+0x14/0x30
  btrfs_kill_super+0x12/0x20 [btrfs]
  deactivate_locked_super+0x31/0x90
  cleanup_mnt+0x13e/0x1b0
  task_work_run+0x63/0xb0
  exit_to_user_mode_loop+0xd9/0xe0
  exit_to_user_mode_prepare+0x3e/0x60
  syscall_exit_to_user_mode+0x1d/0x50
  entry_SYSCALL_64_after_hwframe+0x44/0xae

As dm-error has no support for zones, btrfs will run it's zone emulation
mode on this device. The zone emulation mode emulates conventional zones,
so bail out if the zone bitmap that gets populated on mount sees the zone
as sequential while we're thinking it's a conventional zone when creating
a block group.

Note: this scenario is unlikely in a real wold application and can only
happen by this (ab)use of device-mapper targets.

CC: stable@vger.kernel.org # 5.12+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1126,6 +1126,11 @@ int btrfs_load_block_group_zone_info(str
 			goto out;
 		}
 
+		if (zone.type == BLK_ZONE_TYPE_CONVENTIONAL) {
+			ret = -EIO;
+			goto out;
+		}
+
 		switch (zone.cond) {
 		case BLK_ZONE_COND_OFFLINE:
 		case BLK_ZONE_COND_READONLY:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F522F164
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbgG0Obs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731521AbgG0OUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA73D2070A;
        Mon, 27 Jul 2020 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859613;
        bh=Gi/1matADbQoQnGQPaHeo0DvP+h85YZ9Z5NkcxJSnx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYhQ4BXwFqnEUXBlq53J4yKi5u8foItPSSSaBYaoeX5avgm/zAgonHrNX6XIXtyUF
         t3zxEWHhDm4eS9uBR4/j1B++Wf5fL0WJ7aW06BB2nbS/a4jKlyVjgJx/1Q7fRcStgv
         jSVgW4NXJxpix4RE2rzc08FXp+Nd7Xy/yf6DKsEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.7 038/179] btrfs: fix double free on ulist after backref resolution failure
Date:   Mon, 27 Jul 2020 16:03:33 +0200
Message-Id: <20200727134934.528531421@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 580c079b5766ac706f56eec5c79aee4bf929fef6 upstream.

At btrfs_find_all_roots_safe() we allocate a ulist and set the **roots
argument to point to it. However if later we fail due to an error returned
by find_parent_nodes(), we free that ulist but leave a dangling pointer in
the **roots argument. Upon receiving the error, a caller of this function
can attempt to free the same ulist again, resulting in an invalid memory
access.

One such scenario is during qgroup accounting:

btrfs_qgroup_account_extents()

 --> calls btrfs_find_all_roots() passes &new_roots (a stack allocated
     pointer) to btrfs_find_all_roots()

   --> btrfs_find_all_roots() just calls btrfs_find_all_roots_safe()
       passing &new_roots to it

     --> allocates ulist and assigns its address to **roots (which
         points to new_roots from btrfs_qgroup_account_extents())

     --> find_parent_nodes() returns an error, so we free the ulist
         and leave **roots pointing to it after returning

 --> btrfs_qgroup_account_extents() sees btrfs_find_all_roots() returned
     an error and jumps to the label 'cleanup', which just tries to
     free again the same ulist

Stack trace example:

 ------------[ cut here ]------------
 BTRFS: tree first key check failed
 WARNING: CPU: 1 PID: 1763215 at fs/btrfs/disk-io.c:422 btrfs_verify_level_key+0xe0/0x180 [btrfs]
 Modules linked in: dm_snapshot dm_thin_pool (...)
 CPU: 1 PID: 1763215 Comm: fsstress Tainted: G        W         5.8.0-rc3-btrfs-next-64 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:btrfs_verify_level_key+0xe0/0x180 [btrfs]
 Code: 28 5b 5d (...)
 RSP: 0018:ffffb89b473779a0 EFLAGS: 00010286
 RAX: 0000000000000000 RBX: ffff90397759bf08 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000000027 RDI: 00000000ffffffff
 RBP: ffff9039a419c000 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: ffffb89b43301000 R12: 000000000000005e
 R13: ffffb89b47377a2e R14: ffffb89b473779af R15: 0000000000000000
 FS:  00007fc47e1e1000(0000) GS:ffff9039ac200000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fc47e1df000 CR3: 00000003d9e4e001 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  read_block_for_search+0xf6/0x350 [btrfs]
  btrfs_next_old_leaf+0x242/0x650 [btrfs]
  resolve_indirect_refs+0x7cf/0x9e0 [btrfs]
  find_parent_nodes+0x4ea/0x12c0 [btrfs]
  btrfs_find_all_roots_safe+0xbf/0x130 [btrfs]
  btrfs_qgroup_account_extents+0x9d/0x390 [btrfs]
  btrfs_commit_transaction+0x4f7/0xb20 [btrfs]
  btrfs_sync_file+0x3d4/0x4d0 [btrfs]
  do_fsync+0x38/0x70
  __x64_sys_fdatasync+0x13/0x20
  do_syscall_64+0x5c/0xe0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fc47e2d72e3
 Code: Bad RIP value.
 RSP: 002b:00007fffa32098c8 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
 RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc47e2d72e3
 RDX: 00007fffa3209830 RSI: 00007fffa3209830 RDI: 0000000000000003
 RBP: 000000000000072e R08: 0000000000000001 R09: 0000000000000003
 R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000003e8
 R13: 0000000051eb851f R14: 00007fffa3209970 R15: 00005607c4ac8b50
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffffffb8eb5e85>] copy_process+0x755/0x1eb0
 softirqs last  enabled at (0): [<ffffffffb8eb5e85>] copy_process+0x755/0x1eb0
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 ---[ end trace 8639237550317b48 ]---
 BTRFS error (device sdc): tree first key mismatch detected, bytenr=62324736 parent_transid=94 key expected=(262,108,1351680) has=(259,108,1921024)
 general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6b6b: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
 CPU: 2 PID: 1763215 Comm: fsstress Tainted: G        W         5.8.0-rc3-btrfs-next-64 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:ulist_release+0x14/0x60 [btrfs]
 Code: c7 07 00 (...)
 RSP: 0018:ffffb89b47377d60 EFLAGS: 00010282
 RAX: 6b6b6b6b6b6b6b6b RBX: ffff903959b56b90 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000270024 RDI: ffff9036e2adc840
 RBP: ffff9036e2adc848 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff9036e2adc840
 R13: 0000000000000015 R14: ffff9039a419ccf8 R15: ffff90395d605840
 FS:  00007fc47e1e1000(0000) GS:ffff9039ac600000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f8c1c0a51c8 CR3: 00000003d9e4e004 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  ulist_free+0x13/0x20 [btrfs]
  btrfs_qgroup_account_extents+0xf3/0x390 [btrfs]
  btrfs_commit_transaction+0x4f7/0xb20 [btrfs]
  btrfs_sync_file+0x3d4/0x4d0 [btrfs]
  do_fsync+0x38/0x70
  __x64_sys_fdatasync+0x13/0x20
  do_syscall_64+0x5c/0xe0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fc47e2d72e3
 Code: Bad RIP value.
 RSP: 002b:00007fffa32098c8 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
 RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc47e2d72e3
 RDX: 00007fffa3209830 RSI: 00007fffa3209830 RDI: 0000000000000003
 RBP: 000000000000072e R08: 0000000000000001 R09: 0000000000000003
 R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000003e8
 R13: 0000000051eb851f R14: 00007fffa3209970 R15: 00005607c4ac8b50
 Modules linked in: dm_snapshot dm_thin_pool (...)
 ---[ end trace 8639237550317b49 ]---
 RIP: 0010:ulist_release+0x14/0x60 [btrfs]
 Code: c7 07 00 (...)
 RSP: 0018:ffffb89b47377d60 EFLAGS: 00010282
 RAX: 6b6b6b6b6b6b6b6b RBX: ffff903959b56b90 RCX: 0000000000000000
 RDX: 0000000000000001 RSI: 0000000000270024 RDI: ffff9036e2adc840
 RBP: ffff9036e2adc848 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff9036e2adc840
 R13: 0000000000000015 R14: ffff9039a419ccf8 R15: ffff90395d605840
 FS:  00007fc47e1e1000(0000) GS:ffff9039ad200000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f6a776f7d40 CR3: 00000003d9e4e002 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fix this by making btrfs_find_all_roots_safe() set *roots to NULL after
it frees the ulist.

Fixes: 8da6d5815c592b ("Btrfs: added btrfs_find_all_roots()")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/backref.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1465,6 +1465,7 @@ static int btrfs_find_all_roots_safe(str
 		if (ret < 0 && ret != -ENOENT) {
 			ulist_free(tmp);
 			ulist_free(*roots);
+			*roots = NULL;
 			return ret;
 		}
 		node = ulist_next(tmp, &uiter);



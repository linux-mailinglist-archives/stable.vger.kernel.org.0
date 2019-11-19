Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7B01012FC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfKSFVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfKSFVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26FE32231C;
        Tue, 19 Nov 2019 05:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140878;
        bh=vHpls6XfcsvAmlwFQd0CGoP/K3cqpMgU13xtUrYlKHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6YrAB+X8OpaQO9a4SGXp4L0ixyoRvaVps/7Sfh9gpIlVcv7jhznweL4kkzqzuZCF
         Lrr4yKp6JSVVxmOfMKkomOhQLbfKqNQ0kQJ86SVgjoF3LmKyhe+GKRx5IjJDRYdrwu
         6sG/1noMF3ocyz1gQspTMIq6dKwDiAIrT32n6+L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Su Yue <Damenly_Su@gmx.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 18/48] Btrfs: fix log context list corruption after rename exchange operation
Date:   Tue, 19 Nov 2019 06:19:38 +0100
Message-Id: <20191119051002.241077415@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit e6c617102c7e4ac1398cb0b98ff1f0727755b520 upstream.

During rename exchange we might have successfully log the new name in the
source root's log tree, in which case we leave our log context (allocated
on stack) in the root's list of log contextes. However we might fail to
log the new name in the destination root, in which case we fallback to
a transaction commit later and never sync the log of the source root,
which causes the source root log context to remain in the list of log
contextes. This later causes invalid memory accesses because the context
was allocated on stack and after rename exchange finishes the stack gets
reused and overwritten for other purposes.

The kernel's linked list corruption detector (CONFIG_DEBUG_LIST=y) can
detect this and report something like the following:

  [  691.489929] ------------[ cut here ]------------
  [  691.489947] list_add corruption. prev->next should be next (ffff88819c944530), but was ffff8881c23f7be4. (prev=ffff8881c23f7a38).
  [  691.489967] WARNING: CPU: 2 PID: 28933 at lib/list_debug.c:28 __list_add_valid+0x95/0xe0
  (...)
  [  691.489998] CPU: 2 PID: 28933 Comm: fsstress Not tainted 5.4.0-rc6-btrfs-next-62 #1
  [  691.490001] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
  [  691.490003] RIP: 0010:__list_add_valid+0x95/0xe0
  (...)
  [  691.490007] RSP: 0018:ffff8881f0b3faf8 EFLAGS: 00010282
  [  691.490010] RAX: 0000000000000000 RBX: ffff88819c944530 RCX: 0000000000000000
  [  691.490011] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffffa2c497e0
  [  691.490013] RBP: ffff8881f0b3fe68 R08: ffffed103eaa4115 R09: ffffed103eaa4114
  [  691.490015] R10: ffff88819c944000 R11: ffffed103eaa4115 R12: 7fffffffffffffff
  [  691.490016] R13: ffff8881b4035610 R14: ffff8881e7b84728 R15: 1ffff1103e167f7b
  [  691.490019] FS:  00007f4b25ea2e80(0000) GS:ffff8881f5500000(0000) knlGS:0000000000000000
  [  691.490021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  691.490022] CR2: 00007fffbb2d4eec CR3: 00000001f2a4a004 CR4: 00000000003606e0
  [  691.490025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [  691.490027] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [  691.490029] Call Trace:
  [  691.490058]  btrfs_log_inode_parent+0x667/0x2730 [btrfs]
  [  691.490083]  ? join_transaction+0x24a/0xce0 [btrfs]
  [  691.490107]  ? btrfs_end_log_trans+0x80/0x80 [btrfs]
  [  691.490111]  ? dget_parent+0xb8/0x460
  [  691.490116]  ? lock_downgrade+0x6b0/0x6b0
  [  691.490121]  ? rwlock_bug.part.0+0x90/0x90
  [  691.490127]  ? do_raw_spin_unlock+0x142/0x220
  [  691.490151]  btrfs_log_dentry_safe+0x65/0x90 [btrfs]
  [  691.490172]  btrfs_sync_file+0x9f1/0xc00 [btrfs]
  [  691.490195]  ? btrfs_file_write_iter+0x1800/0x1800 [btrfs]
  [  691.490198]  ? rcu_read_lock_any_held.part.11+0x20/0x20
  [  691.490204]  ? __do_sys_newstat+0x88/0xd0
  [  691.490207]  ? cp_new_stat+0x5d0/0x5d0
  [  691.490218]  ? do_fsync+0x38/0x60
  [  691.490220]  do_fsync+0x38/0x60
  [  691.490224]  __x64_sys_fdatasync+0x32/0x40
  [  691.490228]  do_syscall_64+0x9f/0x540
  [  691.490233]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [  691.490235] RIP: 0033:0x7f4b253ad5f0
  (...)
  [  691.490239] RSP: 002b:00007fffbb2d6078 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
  [  691.490242] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f4b253ad5f0
  [  691.490244] RDX: 00007fffbb2d5fe0 RSI: 00007fffbb2d5fe0 RDI: 0000000000000003
  [  691.490245] RBP: 000000000000000d R08: 0000000000000001 R09: 00007fffbb2d608c
  [  691.490247] R10: 00000000000002e8 R11: 0000000000000246 R12: 00000000000001f4
  [  691.490248] R13: 0000000051eb851f R14: 00007fffbb2d6120 R15: 00005635a498bda0

This started happening recently when running some test cases from fstests
like btrfs/004 for example, because support for rename exchange was added
last week to fsstress from fstests.

So fix this by deleting the log context for the source root from the list
if we have logged the new name in the source root.

Reported-by: Su Yue <Damenly_Su@gmx.com>
Fixes: d4682ba03ef618 ("Btrfs: sync log after logging new name")
CC: stable@vger.kernel.org # 4.19+
Tested-by: Su Yue <Damenly_Su@gmx.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9723,6 +9723,18 @@ out_fail:
 			commit_transaction = true;
 	}
 	if (commit_transaction) {
+		/*
+		 * We may have set commit_transaction when logging the new name
+		 * in the destination root, in which case we left the source
+		 * root context in the list of log contextes. So make sure we
+		 * remove it to avoid invalid memory accesses, since the context
+		 * was allocated in our stack frame.
+		 */
+		if (sync_log_root) {
+			mutex_lock(&root->log_mutex);
+			list_del_init(&ctx_root.list);
+			mutex_unlock(&root->log_mutex);
+		}
 		ret = btrfs_commit_transaction(trans);
 	} else {
 		int ret2;
@@ -9736,6 +9748,9 @@ out_notrans:
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
 
+	ASSERT(list_empty(&ctx_root.list));
+	ASSERT(list_empty(&ctx_dest.list));
+
 	return ret;
 }
 



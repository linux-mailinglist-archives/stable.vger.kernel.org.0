Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC726F288
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgIRC7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbgIRCGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C3C2388E;
        Fri, 18 Sep 2020 02:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394760;
        bh=OyqdvDmYpNYFuLdMZDjqakwuFP7f2e4gvxS8ALoPd/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsyT+2RuO0eCa+WcwACJBNXyNN6OiV+xMccc/Vd5HqyJ9HYEKJouAn1wxXF6zhOvn
         0MKWznr0dC/PBKKYMUDLtWKW269BYKyiaG8cgaZj7QGw0Qf9/mepqg7gJYjQhE0ALv
         89r+b2chPflJl46Eb6hol3zq4Pc3RYUX/rcv8UAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 237/330] btrfs: fix setting last_trans for reloc roots
Date:   Thu, 17 Sep 2020 21:59:37 -0400
Message-Id: <20200918020110.2063155-237-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit aec7db3b13a07d515c15ada752a7287a44a79ea0 ]

I made a mistake with my previous fix, I assumed that we didn't need to
mess with the reloc roots once we were out of the part of relocation where
we are actually moving the extents.

The subtle thing that I missed is that btrfs_init_reloc_root() also
updates the last_trans for the reloc root when we do
btrfs_record_root_in_trans() for the corresponding fs_root.  I've added a
comment to make sure future me doesn't make this mistake again.

This showed up as a WARN_ON() in btrfs_copy_root() because our
last_trans didn't == the current transid.  This could happen if we
snapshotted a fs root with a reloc root after we set
rc->create_reloc_tree = 0, but before we actually merge the reloc root.

Worth mentioning that the regression produced the following warning
when running snapshot creation and balance in parallel:

  BTRFS info (device sdc): relocating block group 30408704 flags metadata|dup
  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 12823 at fs/btrfs/ctree.c:191 btrfs_copy_root+0x26f/0x430 [btrfs]
  CPU: 0 PID: 12823 Comm: btrfs Tainted: G        W 5.6.0-rc7-btrfs-next-58 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
  RIP: 0010:btrfs_copy_root+0x26f/0x430 [btrfs]
  RSP: 0018:ffffb96e044279b8 EFLAGS: 00010202
  RAX: 0000000000000009 RBX: ffff9da70bf61000 RCX: ffffb96e04427a48
  RDX: ffff9da733a770c8 RSI: ffff9da70bf61000 RDI: ffff9da694163818
  RBP: ffff9da733a770c8 R08: fffffffffffffff8 R09: 0000000000000002
  R10: ffffb96e044279a0 R11: 0000000000000000 R12: ffff9da694163818
  R13: fffffffffffffff8 R14: ffff9da6d2512000 R15: ffff9da714cdac00
  FS:  00007fdeacf328c0(0000) GS:ffff9da735e00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000055a2a5b8a118 CR3: 00000001eed78002 CR4: 00000000003606f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   ? create_reloc_root+0x49/0x2b0 [btrfs]
   ? kmem_cache_alloc_trace+0xe5/0x200
   create_reloc_root+0x8b/0x2b0 [btrfs]
   btrfs_reloc_post_snapshot+0x96/0x5b0 [btrfs]
   create_pending_snapshot+0x610/0x1010 [btrfs]
   create_pending_snapshots+0xa8/0xd0 [btrfs]
   btrfs_commit_transaction+0x4c7/0xc50 [btrfs]
   ? btrfs_mksubvol+0x3cd/0x560 [btrfs]
   btrfs_mksubvol+0x455/0x560 [btrfs]
   __btrfs_ioctl_snap_create+0x15f/0x190 [btrfs]
   btrfs_ioctl_snap_create_v2+0xa4/0xf0 [btrfs]
   ? mem_cgroup_commit_charge+0x6e/0x540
   btrfs_ioctl+0x12d8/0x3760 [btrfs]
   ? do_raw_spin_unlock+0x49/0xc0
   ? _raw_spin_unlock+0x29/0x40
   ? __handle_mm_fault+0x11b3/0x14b0
   ? ksys_ioctl+0x92/0xb0
   ksys_ioctl+0x92/0xb0
   ? trace_hardirqs_off_thunk+0x1a/0x1c
   __x64_sys_ioctl+0x16/0x20
   do_syscall_64+0x5c/0x280
   entry_SYSCALL_64_after_hwframe+0x49/0xbe
  RIP: 0033:0x7fdeabd3bdd7

Fixes: 2abc726ab4b8 ("btrfs: do not init a reloc root if we aren't relocating")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ece53d2f55ae3..1bc57f7b91cfa 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1468,8 +1468,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	int clear_rsv = 0;
 	int ret;
 
-	if (!rc || !rc->create_reloc_tree ||
-	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+	if (!rc)
 		return 0;
 
 	/*
@@ -1479,12 +1478,28 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	if (reloc_root_is_dead(root))
 		return 0;
 
+	/*
+	 * This is subtle but important.  We do not do
+	 * record_root_in_transaction for reloc roots, instead we record their
+	 * corresponding fs root, and then here we update the last trans for the
+	 * reloc root.  This means that we have to do this for the entire life
+	 * of the reloc root, regardless of which stage of the relocation we are
+	 * in.
+	 */
 	if (root->reloc_root) {
 		reloc_root = root->reloc_root;
 		reloc_root->last_trans = trans->transid;
 		return 0;
 	}
 
+	/*
+	 * We are merging reloc roots, we do not need new reloc trees.  Also
+	 * reloc trees never need their own reloc tree.
+	 */
+	if (!rc->create_reloc_tree ||
+	    root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+		return 0;
+
 	if (!trans->reloc_reserved) {
 		rsv = trans->block_rsv;
 		trans->block_rsv = rc->block_rsv;
-- 
2.25.1


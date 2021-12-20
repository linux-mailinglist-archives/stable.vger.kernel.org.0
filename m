Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640CD47A727
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhLTJe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhLTJe7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:34:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26666C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 01:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E514DB80DA2
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 09:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36276C36AE8;
        Mon, 20 Dec 2021 09:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639992896;
        bh=z3Vywe8/CCBk/k/n02DtbReyx1uW+YDOaxYpSf3PVMw=;
        h=Subject:To:Cc:From:Date:From;
        b=bh5/QSXnv86+hP4Rcbx0hRizgSpLscsukRg+esi1fFzRTTYVmfsp0AX+Gnzr6FaWz
         NkNfQuhXwWAb9JjxccI5NydenPfSdxW7qu0AdddJQncbEA1/NPnXyRPlMlkGe3lLLR
         1w1Wmo7sxVXFe0pUWbpLTmNlJFXyA7Wstgl3xJfs=
Subject: FAILED: patch "[PATCH] btrfs: fix warning when freeing leaf after subvolume creation" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, nborisov@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 10:34:45 +0100
Message-ID: <16399928856180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 212a58fda9b9077e0efc20200a4feb76afacfd95 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 13 Dec 2021 08:45:13 +0000
Subject: [PATCH] btrfs: fix warning when freeing leaf after subvolume creation
 failure

When creating a subvolume, at ioctl.c:create_subvol(), if we fail to
insert the root item for the new subvolume into the root tree, we can
trigger the following warning:

[78961.741046] WARNING: CPU: 0 PID: 4079814 at fs/btrfs/extent-tree.c:3357 btrfs_free_tree_block+0x2af/0x310 [btrfs]
[78961.743344] Modules linked in:
[78961.749440]  dm_snapshot dm_thin_pool (...)
[78961.773648] CPU: 0 PID: 4079814 Comm: fsstress Not tainted 5.16.0-rc4-btrfs-next-108 #1
[78961.775198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[78961.777266] RIP: 0010:btrfs_free_tree_block+0x2af/0x310 [btrfs]
[78961.778398] Code: 17 00 48 85 (...)
[78961.781067] RSP: 0018:ffffaa4001657b28 EFLAGS: 00010202
[78961.781877] RAX: 0000000000000213 RBX: ffff897f8a796910 RCX: 0000000000000000
[78961.782780] RDX: 0000000000000000 RSI: 0000000011004000 RDI: 00000000ffffffff
[78961.783764] RBP: ffff8981f490e800 R08: 0000000000000001 R09: 0000000000000000
[78961.784740] R10: 0000000000000000 R11: 0000000000000001 R12: ffff897fc963fcc8
[78961.785665] R13: 0000000000000001 R14: ffff898063548000 R15: ffff898063548000
[78961.786620] FS:  00007f31283c6b80(0000) GS:ffff8982ace00000(0000) knlGS:0000000000000000
[78961.787717] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[78961.788598] CR2: 00007f31285c3000 CR3: 000000023fcc8003 CR4: 0000000000370ef0
[78961.789568] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[78961.790585] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[78961.791684] Call Trace:
[78961.792082]  <TASK>
[78961.792359]  create_subvol+0x5d1/0x9a0 [btrfs]
[78961.793054]  btrfs_mksubvol+0x447/0x4c0 [btrfs]
[78961.794009]  ? preempt_count_add+0x49/0xa0
[78961.794705]  __btrfs_ioctl_snap_create+0x123/0x190 [btrfs]
[78961.795712]  ? _copy_from_user+0x66/0xa0
[78961.796382]  btrfs_ioctl_snap_create_v2+0xbb/0x140 [btrfs]
[78961.797392]  btrfs_ioctl+0xd1e/0x35c0 [btrfs]
[78961.798172]  ? __slab_free+0x10a/0x360
[78961.798820]  ? rcu_read_lock_sched_held+0x12/0x60
[78961.799664]  ? lock_release+0x223/0x4a0
[78961.800321]  ? lock_acquired+0x19f/0x420
[78961.800992]  ? rcu_read_lock_sched_held+0x12/0x60
[78961.801796]  ? trace_hardirqs_on+0x1b/0xe0
[78961.802495]  ? _raw_spin_unlock_irqrestore+0x3e/0x60
[78961.803358]  ? kmem_cache_free+0x321/0x3c0
[78961.804071]  ? __x64_sys_ioctl+0x83/0xb0
[78961.804711]  __x64_sys_ioctl+0x83/0xb0
[78961.805348]  do_syscall_64+0x3b/0xc0
[78961.805969]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[78961.806830] RIP: 0033:0x7f31284bc957
[78961.807517] Code: 3c 1c 48 f7 d8 (...)

This is because we are calling btrfs_free_tree_block() on an extent
buffer that is dirty. Fix that by cleaning the extent buffer, with
btrfs_clean_tree_block(), before freeing it.

This was triggered by test case generic/475 from fstests.

Fixes: 67addf29004c5b ("btrfs: fix metadata extent leak after failure to create subvolume")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a7533416370a..8a442b59eee0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -618,10 +618,11 @@ static noinline int create_subvol(struct user_namespace *mnt_userns,
 		 * tree block so that we don't leak space and leave the
 		 * filesystem in an inconsistent state (an extent item in the
 		 * extent tree with a backreference for a root that does not
-		 * exists). Also no need to have the tree block locked since it
-		 * is not in any tree at this point, so no other task can find
-		 * it and use it.
+		 * exists).
 		 */
+		btrfs_tree_lock(leaf);
+		btrfs_clean_tree_block(leaf);
+		btrfs_tree_unlock(leaf);
 		btrfs_free_tree_block(trans, objectid, leaf, 0, 1);
 		free_extent_buffer(leaf);
 		goto fail;


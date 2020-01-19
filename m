Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672DD141ED7
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgASPVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:21:43 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57211 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727121AbgASPVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 10:21:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C844E432;
        Sun, 19 Jan 2020 10:21:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 10:21:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oJa8uD
        uz1sELLAqf2zBFxCRY4DiuaqtCLOHAkKU2LOk=; b=Q4a7eFJiC0rtDwNlCCDJIm
        Yh4CRSJ2fo51G3F9WWoQEmOklmztsTtfXLk4dolfiqgeQWspr1aWPS+renviq2O4
        ODKesn25krcGA/At+d4LvYUSuC7kuMl+rbT9OQRoU6uzptlMzTZdN/vt0wEq+yEa
        NYFsWDl+6M9/iCZT9+JaiEaH12A5rRDK7eDPFBCTeyqCOzSWb3p4VYIa3F23KGd8
        0wm5pTkvF7n5BdRz2xGaEZ2P4/Ks7DOC/FAtiQj3qadQzYxJSVe5noHInfSorpXH
        m4R2lX5L97YSQnWFhMjNJzxJoHF4UflTAYpz03V3w8IJptrbr4vGbUt0Qnvvi5hw
        ==
X-ME-Sender: <xms:BnQkXs1sdiWEYGBzjVx9aOiuR85sOZseVRVF7WG6l62oCkqnFVK4bA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepohhpvghnshhushgvrdhorhhgnecukfhppeekgedrvdeguddrud
    eljedrieejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:BnQkXpph3J49P5HXB1g_jWGExmBddoOWpb0ipn4QnWEHVWWiiEdbRg>
    <xmx:BnQkXoi_m7ACP3f728skTU-ls232SYP1JHfcZtf22hme_vEr_a_UWg>
    <xmx:BnQkXl9yUa_RwobU_qFgLtHyAdU3Qsia04l8ey3G_EHdSf2SLxCfbw>
    <xmx:BnQkXl4TQcug8eNfJvDvvq9_IpZlHU-iE0uTYLiukQOpATN1x3Q-gA>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0D343060ACE;
        Sun, 19 Jan 2020 10:21:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: check rw_devices, not num_devices for balance" failed to apply to 4.19-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 16:21:39 +0100
Message-ID: <15794472992359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From b35cf1f0bf1f2b0b193093338414b9bd63b29015 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 10 Jan 2020 11:11:24 -0500
Subject: [PATCH] btrfs: check rw_devices, not num_devices for balance

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

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a6d3f08bfff3..9b78e720c697 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3881,7 +3881,11 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
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


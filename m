Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02552416EC4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 11:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbhIXJV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 05:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244460AbhIXJV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 05:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3966360F43;
        Fri, 24 Sep 2021 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632475224;
        bh=8QiNpuNKn5Z0rgsRIZFN0FILZMZ3MuWPJa1WeWxOsCs=;
        h=Subject:To:Cc:From:Date:From;
        b=pU0NPH4W65rZ26VGgBNpK75QKPQryC6ROeQw4dj1+K4v2PMK5hYrEmj2BDFhwgBf6
         D57ontA+R24aF03yF1WfkxomkAzt/UcciNwwsiHdVeMdNdtIiVrZFe3M4hFK5eDqV5
         B9sgM9HHxkt02pIN7LYQiBwMT7avf26z6p/kY3ZY=
Subject: FAILED: patch "[PATCH] nilfs2: use refcount_dec_and_lock() to fix potential UAF" failed to apply to 4.4-stable tree
To:     thunder.leizhen@huawei.com, akpm@linux-foundation.org,
        konishi.ryusuke@gmail.com, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 24 Sep 2021 11:20:22 +0200
Message-ID: <163247522288100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98e2e409e76ef7781d8511f997359e9c504a95c1 Mon Sep 17 00:00:00 2001
From: Zhen Lei <thunder.leizhen@huawei.com>
Date: Tue, 7 Sep 2021 20:00:26 -0700
Subject: [PATCH] nilfs2: use refcount_dec_and_lock() to fix potential UAF

When the refcount is decreased to 0, the resource reclamation branch is
entered.  Before CPU0 reaches the race point (1), CPU1 may obtain the
spinlock and traverse the rbtree to find 'root', see
nilfs_lookup_root().

Although CPU1 will call refcount_inc() to increase the refcount, it is
obviously too late.  CPU0 will release 'root' directly, CPU1 then
accesses 'root' and triggers UAF.

Use refcount_dec_and_lock() to ensure that both the operations of
decrease refcount to 0 and link deletion are lock protected eliminates
this risk.

	     CPU0                      CPU1
	nilfs_put_root():
		    <-------- (1)
				spin_lock(&nilfs->ns_cptree_lock);
				rb_erase(&root->rb_node, &nilfs->ns_cptree);
				spin_unlock(&nilfs->ns_cptree_lock);

	kfree(root);
		    <-------- use-after-free

  refcount_t: underflow; use-after-free.
  WARNING: CPU: 2 PID: 9476 at lib/refcount.c:28 \
  refcount_warn_saturate+0x1cf/0x210 lib/refcount.c:28
  Modules linked in:
  CPU: 2 PID: 9476 Comm: syz-executor.0 Not tainted 5.10.45-rc1+ #3
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), ...
  RIP: 0010:refcount_warn_saturate+0x1cf/0x210 lib/refcount.c:28
  ... ...
  Call Trace:
     __refcount_sub_and_test include/linux/refcount.h:283 [inline]
     __refcount_dec_and_test include/linux/refcount.h:315 [inline]
     refcount_dec_and_test include/linux/refcount.h:333 [inline]
     nilfs_put_root+0xc1/0xd0 fs/nilfs2/the_nilfs.c:795
     nilfs_segctor_destroy fs/nilfs2/segment.c:2749 [inline]
     nilfs_detach_log_writer+0x3fa/0x570 fs/nilfs2/segment.c:2812
     nilfs_put_super+0x2f/0xf0 fs/nilfs2/super.c:467
     generic_shutdown_super+0xcd/0x1f0 fs/super.c:464
     kill_block_super+0x4a/0x90 fs/super.c:1446
     deactivate_locked_super+0x6a/0xb0 fs/super.c:335
     deactivate_super+0x85/0x90 fs/super.c:366
     cleanup_mnt+0x277/0x2e0 fs/namespace.c:1118
     __cleanup_mnt+0x15/0x20 fs/namespace.c:1125
     task_work_run+0x8e/0x110 kernel/task_work.c:151
     tracehook_notify_resume include/linux/tracehook.h:188 [inline]
     exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
     exit_to_user_mode_prepare+0x13c/0x170 kernel/entry/common.c:191
     syscall_exit_to_user_mode+0x16/0x30 kernel/entry/common.c:266
     do_syscall_64+0x45/0x80 arch/x86/entry/common.c:56
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

There is no reproduction program, and the above is only theoretical
analysis.

Link: https://lkml.kernel.org/r/1629859428-5906-1-git-send-email-konishi.ryusuke@gmail.com
Fixes: ba65ae4729bf ("nilfs2: add checkpoint tree to nilfs object")
Link: https://lkml.kernel.org/r/20210723012317.4146-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 8b7b01a380ce..c8bfc01da5d7 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -792,14 +792,13 @@ nilfs_find_or_create_root(struct the_nilfs *nilfs, __u64 cno)
 
 void nilfs_put_root(struct nilfs_root *root)
 {
-	if (refcount_dec_and_test(&root->count)) {
-		struct the_nilfs *nilfs = root->nilfs;
+	struct the_nilfs *nilfs = root->nilfs;
 
-		nilfs_sysfs_delete_snapshot_group(root);
-
-		spin_lock(&nilfs->ns_cptree_lock);
+	if (refcount_dec_and_lock(&root->count, &nilfs->ns_cptree_lock)) {
 		rb_erase(&root->rb_node, &nilfs->ns_cptree);
 		spin_unlock(&nilfs->ns_cptree_lock);
+
+		nilfs_sysfs_delete_snapshot_group(root);
 		iput(root->ifile);
 
 		kfree(root);


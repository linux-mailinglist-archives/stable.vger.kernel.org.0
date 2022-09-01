Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF365A99E8
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 16:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234626AbiIAORW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 10:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiIAORD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 10:17:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6387205C8
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 07:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D40CB826E2
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 14:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9C5C433C1;
        Thu,  1 Sep 2022 14:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662041791;
        bh=8B9wngONNWsDYy9JtPx5Zzu/JIgxs2x2rjNnb98q9As=;
        h=Subject:To:From:Date:From;
        b=I8IlzbIAVW7PMNy2K/Ihj1cNEFZrWJ+Wl/zMsvRCnKiCYTRV8m+h/0+vCRzpZxiEK
         sAQZtxq0cT3YBomiNe6UQIw2UgU9dJXZH8Ml81TWHlD39LjuKyySTpTW50gZyo+869
         PaCUK/qge+oUtf0XC8hpepKyu1lrx7AFwtwmLLLs=
Subject: patch "binder: fix alloc->vma_vm_mm null-ptr dereference" added to char-misc-linus
To:     cmllamas@google.com, Liam.Howlett@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        tkjos@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 01 Sep 2022 16:16:28 +0200
Message-ID: <166204178844166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    binder: fix alloc->vma_vm_mm null-ptr dereference

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1da52815d5f1b654c89044db0cdc6adce43da1f1 Mon Sep 17 00:00:00 2001
From: Carlos Llamas <cmllamas@google.com>
Date: Mon, 29 Aug 2022 20:12:48 +0000
Subject: binder: fix alloc->vma_vm_mm null-ptr dereference

Syzbot reported a couple issues introduced by commit 44e602b4e52f
("binder_alloc: add missing mmap_lock calls when using the VMA"), in
which we attempt to acquire the mmap_lock when alloc->vma_vm_mm has not
been initialized yet.

This can happen if a binder_proc receives a transaction without having
previously called mmap() to setup the binder_proc->alloc space in [1].
Also, a similar issue occurs via binder_alloc_print_pages() when we try
to dump the debugfs binder stats file in [2].

Sample of syzbot's crash report:
  ==================================================================
  KASAN: null-ptr-deref in range [0x0000000000000128-0x000000000000012f]
  CPU: 0 PID: 3755 Comm: syz-executor229 Not tainted 6.0.0-rc1-next-20220819-syzkaller #0
  syz-executor229[3755] cmdline: ./syz-executor2294415195
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
  RIP: 0010:__lock_acquire+0xd83/0x56d0 kernel/locking/lockdep.c:4923
  [...]
  Call Trace:
   <TASK>
   lock_acquire kernel/locking/lockdep.c:5666 [inline]
   lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
   down_read+0x98/0x450 kernel/locking/rwsem.c:1499
   mmap_read_lock include/linux/mmap_lock.h:117 [inline]
   binder_alloc_new_buf_locked drivers/android/binder_alloc.c:405 [inline]
   binder_alloc_new_buf+0xa5/0x19e0 drivers/android/binder_alloc.c:593
   binder_transaction+0x242e/0x9a80 drivers/android/binder.c:3199
   binder_thread_write+0x664/0x3220 drivers/android/binder.c:3986
   binder_ioctl_write_read drivers/android/binder.c:5036 [inline]
   binder_ioctl+0x3470/0x6d00 drivers/android/binder.c:5323
   vfs_ioctl fs/ioctl.c:51 [inline]
   __do_sys_ioctl fs/ioctl.c:870 [inline]
   __se_sys_ioctl fs/ioctl.c:856 [inline]
   __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd
   [...]
  ==================================================================

Fix these issues by setting up alloc->vma_vm_mm pointer during open()
and caching directly from current->mm. This guarantees we have a valid
reference to take the mmap_lock during scenarios described above.

[1] https://syzkaller.appspot.com/bug?extid=f7dc54e5be28950ac459
[2] https://syzkaller.appspot.com/bug?extid=a75ebe0452711c9e56d9

Fixes: 44e602b4e52f ("binder_alloc: add missing mmap_lock calls when using the VMA")
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com
Reported-by: syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20220829201254.1814484-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 1014beb12802..a61df6e1103a 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 	 */
 	if (vma) {
 		vm_start = vma->vm_start;
-		alloc->vma_vm_mm = vma->vm_mm;
 		mmap_assert_write_locked(alloc->vma_vm_mm);
 	} else {
 		mmap_assert_locked(alloc->vma_vm_mm);
@@ -792,7 +791,6 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	binder_insert_free_buffer(alloc, buffer);
 	alloc->free_async_space = alloc->buffer_size / 2;
 	binder_alloc_set_vma(alloc, vma);
-	mmgrab(alloc->vma_vm_mm);
 
 	return 0;
 
@@ -1080,6 +1078,8 @@ static struct shrinker binder_shrinker = {
 void binder_alloc_init(struct binder_alloc *alloc)
 {
 	alloc->pid = current->group_leader->pid;
+	alloc->vma_vm_mm = current->mm;
+	mmgrab(alloc->vma_vm_mm);
 	mutex_init(&alloc->mutex);
 	INIT_LIST_HEAD(&alloc->buffers);
 }
-- 
2.37.3



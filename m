Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4005C5AEABE
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiIFNuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiIFNrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ADD7393D;
        Tue,  6 Sep 2022 06:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20FD061539;
        Tue,  6 Sep 2022 13:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B1DC433C1;
        Tue,  6 Sep 2022 13:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471500;
        bh=O5R17pgkOIgcx4ARTJWVhg4HpP51vCwCpBj+tlMVaZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLPTkzf5mZbi6TkUu5aRRnsLAXU+NJGGrAyC7aimRyI80hvTR668XCzPBRSyc+y9X
         APWUhfvct51EV5BxsQKeM0GCaWGK/q6/jjyj0TbjQD7F4sJ/2TJNpY3EcMlquQ4Gzu
         nCQGzbaXUULWaErB4vCfB4Gl9WWV6X8c7phvspj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com,
        syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com,
        Todd Kjos <tkjos@google.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 047/107] binder: fix alloc->vma_vm_mm null-ptr dereference
Date:   Tue,  6 Sep 2022 15:30:28 +0200
Message-Id: <20220906132823.823260775@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Carlos Llamas <cmllamas@google.com>

commit 1da52815d5f1b654c89044db0cdc6adce43da1f1 upstream.

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
 drivers/android/binder_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(
 	 */
 	if (vma) {
 		vm_start = vma->vm_start;
-		alloc->vma_vm_mm = vma->vm_mm;
 		mmap_assert_write_locked(alloc->vma_vm_mm);
 	} else {
 		mmap_assert_locked(alloc->vma_vm_mm);
@@ -795,7 +794,6 @@ int binder_alloc_mmap_handler(struct bin
 	binder_insert_free_buffer(alloc, buffer);
 	alloc->free_async_space = alloc->buffer_size / 2;
 	binder_alloc_set_vma(alloc, vma);
-	mmgrab(alloc->vma_vm_mm);
 
 	return 0;
 
@@ -1095,6 +1093,8 @@ static struct shrinker binder_shrinker =
 void binder_alloc_init(struct binder_alloc *alloc)
 {
 	alloc->pid = current->group_leader->pid;
+	alloc->vma_vm_mm = current->mm;
+	mmgrab(alloc->vma_vm_mm);
 	mutex_init(&alloc->mutex);
 	INIT_LIST_HEAD(&alloc->buffers);
 }



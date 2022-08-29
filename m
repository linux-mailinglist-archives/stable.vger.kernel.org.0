Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864145A5561
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 22:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiH2UNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiH2UNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 16:13:02 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B43E985AB
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 13:13:00 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id r13-20020a17090a454d00b001f04dfc6195so3806846pjm.2
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 13:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=3+KFGw/lw7UFTEKp2QYuhuNuaZRNkMlHXcRjkBPuoco=;
        b=KkqpTJCgR/OwOt0P10HqU41mOPMq7h05KJQ8hIf3ml9CTTVyKhnxqp/+m8DAOkaCY2
         43sG7c898K8zn+G43oaYsEliwtvpg+P4fnkAoEiUqx5BgZ9x6ISVBEZBicoAQCPk0H8r
         DUDcNwOUbmUkYWavjrhf9jBWCM9uOv2pswrNF2bzpzJ+g83AY2GcZbl57oxt71J+h1jk
         gAUt97QPDVsv18kwENFVt23VNLI0umUyhF1C5qkb4IWNczrHytbnOvDdETBPkrQOYWY6
         VrDWWPk6yN7wnHoRlYEy85WySxqh8vxZwD3AakRc/hpFn952UZ3bLASzTcsjcAhzQD9O
         xH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=3+KFGw/lw7UFTEKp2QYuhuNuaZRNkMlHXcRjkBPuoco=;
        b=CrUms/aYhw6WA6YGE9cA5w8/xC6MlilyMuijoKdPLv1mse0DKRB24XvNAxKPEBdPAm
         wDJ57LgU5pGnRQA4CCM2M03JIWEsLOCPBT0Yur+s5979vV5SJ0zryKB75I9uEszMwQgl
         TJFYQiz99/VjwPSrtUR0x8Y7hkH/SjB3LafOzSo+U6E2rkjutoPzosu7XKqYj0Hz1Sst
         U2Ilw/wYkpSfeZ/dAuUQs8u8Nd2xKDA88hwPzzxj417C4r0XSyM0sEkwNSFGxpTZmlvG
         THz0KYDq5hfbIQJnxGfU1m1hg219rwBXtl5h7CqOG5lqYh27ZjkH3GQezOao849qh5ko
         TDrg==
X-Gm-Message-State: ACgBeo1TB3lnoO+6Dl5j17H9kKDicSIkzFM5O5TQBZQxSRaO6oEEA48s
        hPe+kzahS2zJ/+BPSliWusunsVerVt77uQ==
X-Google-Smtp-Source: AA6agR7q6tV50augbDBj5FI+PYqaTZLRyKhIvbXKaLDo74MAo4aCJqE/LL9Fp9trQj2FgsIlB5oC5YO5eTaJOA==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a17:90b:3e8a:b0:1fb:27a0:c39b with SMTP
 id rj10-20020a17090b3e8a00b001fb27a0c39bmr20500444pjb.155.1661803979977; Mon,
 29 Aug 2022 13:12:59 -0700 (PDT)
Date:   Mon, 29 Aug 2022 20:12:48 +0000
In-Reply-To: <20220829201254.1814484-1-cmllamas@google.com>
Mime-Version: 1.0
References: <20220829201254.1814484-1-cmllamas@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220829201254.1814484-2-cmllamas@google.com>
Subject: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?=" <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Carlos Llamas <cmllamas@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Howlett <liam.howlett@oracle.com>
Cc:     kernel-team@android.com,
        syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com,
        syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com,
        stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reported-by: syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com
Reported-by: syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org> # v5.15+
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/android/binder_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 51f4e1c5cd01..9b1778c00610 100644
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
@@ -795,7 +794,6 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
 	binder_insert_free_buffer(alloc, buffer);
 	alloc->free_async_space = alloc->buffer_size / 2;
 	binder_alloc_set_vma(alloc, vma);
-	mmgrab(alloc->vma_vm_mm);
 
 	return 0;
 
@@ -1091,6 +1089,8 @@ static struct shrinker binder_shrinker = {
 void binder_alloc_init(struct binder_alloc *alloc)
 {
 	alloc->pid = current->group_leader->pid;
+	alloc->vma_vm_mm = current->mm;
+	mmgrab(alloc->vma_vm_mm);
 	mutex_init(&alloc->mutex);
 	INIT_LIST_HEAD(&alloc->buffers);
 }
-- 
2.37.2.672.g94769d06f0-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688CF5A70D4
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 00:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiH3W2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 18:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiH3W1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 18:27:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C6B7C53B
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 15:26:19 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s7so1098915wro.2
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 15:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0f6hB5tHJiFW3ZRd3jKgstsOUHmlR+0wUHSt7U1ITeA=;
        b=WqP7hThwsG6t8OBPYZGYKqCfv12G8zOluZLWfdkYnxrXA7e0ZRuGhgI4p9RB2QcAfb
         t0jOGcYJLe7Jh5f43uz7Ev8NUR0zT68L4zKSQgEfb+16BCkv22qYyymTmTIo4EWiyU0F
         6a1JXzPhkpfQco6u3ZKWPGhUofQcKFi5eTs+J0DjyrMaLgKSSgoz9Q6pzqjbGWZGm2PW
         Pt5Osgv9coaS0tHFrMpZbKPcuPfNSJVytXCmnNWVO9OasLcmXzRIlsDBT+Og9/R7sWX0
         3gJwMgDlz5hUfdvJrU2g25K+ygUDV0JF91x3UTueZpImrFU1EEmcs5ZxGe0hQKoZ84aq
         M1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0f6hB5tHJiFW3ZRd3jKgstsOUHmlR+0wUHSt7U1ITeA=;
        b=KRc/WM5auWbuG3Gjykorp7aoJYHDY2jjY/V+DnsyZCh1/FuKpHGUL8JWilvSdYvUl8
         rL9utgMvw5zB2lAPWU0EPQBopnEROtY5feDpHvIeoCl7c0CgjHPpCmXOTC5NDtO1lfix
         yfE/CLoX+OIojZiQKIOgXV33vDVq6e3PXOre4fXpei0604B8HKo1irJJPvUq+5UnsNqr
         BtipGZ/On4bTl8cewYJH6JJOdHzeCYuRHvR5rrM68pdPRH2d4dJQ1Wg/YPm8B/2Fcfq9
         qjofG/Ji+8fk0ugAAuDxFzUSj+VF7I5jn6Fj5UVuR+Gru77GC77HwI3bW++MnCOBpwCt
         FyLg==
X-Gm-Message-State: ACgBeo1FHtkY4wsUo4DsgDgg8Up8eop66JAn0aCa+HOmLHap1EKVxsEI
        M1bzbSmJ4tjCIfLYPn/AxVF6MNfku20vGdZxoKqxxQ==
X-Google-Smtp-Source: AA6agR55os7W92JL2CziugLDx2F3MJYsfNPMYpZwsOAkoQwPChLr2SIvYzDEQ3XGysjoiy7KUYfWM8KmDKU0IeHEaL4=
X-Received: by 2002:adf:cf06:0:b0:226:bade:120a with SMTP id
 o6-20020adfcf06000000b00226bade120amr10551051wrj.297.1661898377939; Tue, 30
 Aug 2022 15:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220829201254.1814484-1-cmllamas@google.com> <20220829201254.1814484-2-cmllamas@google.com>
In-Reply-To: <20220829201254.1814484-2-cmllamas@google.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Tue, 30 Aug 2022 15:26:07 -0700
Message-ID: <CAHRSSEx1D+5OxMHxVGbYJR62Nv+pE48NYAS8LuWzi7Z1jfAdxQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] binder: fix alloc->vma_vm_mm null-ptr dereference
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        kernel-team@android.com,
        syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com,
        syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 1:13 PM 'Carlos Llamas' via kernel-team
<kernel-team@android.com> wrote:
>
> Syzbot reported a couple issues introduced by commit 44e602b4e52f
> ("binder_alloc: add missing mmap_lock calls when using the VMA"), in
> which we attempt to acquire the mmap_lock when alloc->vma_vm_mm has not
> been initialized yet.
>
> This can happen if a binder_proc receives a transaction without having
> previously called mmap() to setup the binder_proc->alloc space in [1].
> Also, a similar issue occurs via binder_alloc_print_pages() when we try
> to dump the debugfs binder stats file in [2].
>
> Sample of syzbot's crash report:
>   ==================================================================
>   KASAN: null-ptr-deref in range [0x0000000000000128-0x000000000000012f]
>   CPU: 0 PID: 3755 Comm: syz-executor229 Not tainted 6.0.0-rc1-next-20220819-syzkaller #0
>   syz-executor229[3755] cmdline: ./syz-executor2294415195
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
>   RIP: 0010:__lock_acquire+0xd83/0x56d0 kernel/locking/lockdep.c:4923
>   [...]
>   Call Trace:
>    <TASK>
>    lock_acquire kernel/locking/lockdep.c:5666 [inline]
>    lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
>    down_read+0x98/0x450 kernel/locking/rwsem.c:1499
>    mmap_read_lock include/linux/mmap_lock.h:117 [inline]
>    binder_alloc_new_buf_locked drivers/android/binder_alloc.c:405 [inline]
>    binder_alloc_new_buf+0xa5/0x19e0 drivers/android/binder_alloc.c:593
>    binder_transaction+0x242e/0x9a80 drivers/android/binder.c:3199
>    binder_thread_write+0x664/0x3220 drivers/android/binder.c:3986
>    binder_ioctl_write_read drivers/android/binder.c:5036 [inline]
>    binder_ioctl+0x3470/0x6d00 drivers/android/binder.c:5323
>    vfs_ioctl fs/ioctl.c:51 [inline]
>    __do_sys_ioctl fs/ioctl.c:870 [inline]
>    __se_sys_ioctl fs/ioctl.c:856 [inline]
>    __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>    do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
>    [...]
>   ==================================================================
>
> Fix these issues by setting up alloc->vma_vm_mm pointer during open()
> and caching directly from current->mm. This guarantees we have a valid
> reference to take the mmap_lock during scenarios described above.
>
> [1] https://syzkaller.appspot.com/bug?extid=f7dc54e5be28950ac459
> [2] https://syzkaller.appspot.com/bug?extid=a75ebe0452711c9e56d9
>
> Fixes: 44e602b4e52f ("binder_alloc: add missing mmap_lock calls when using the VMA")
> Reported-by: syzbot+f7dc54e5be28950ac459@syzkaller.appspotmail.com
> Reported-by: syzbot+a75ebe0452711c9e56d9@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> # v5.15+
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Acked-by: Todd Kjos <tkjos@google.com>

> ---
>  drivers/android/binder_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 51f4e1c5cd01..9b1778c00610 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -322,7 +322,6 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
>          */
>         if (vma) {
>                 vm_start = vma->vm_start;
> -               alloc->vma_vm_mm = vma->vm_mm;
>                 mmap_assert_write_locked(alloc->vma_vm_mm);
>         } else {
>                 mmap_assert_locked(alloc->vma_vm_mm);
> @@ -795,7 +794,6 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
>         binder_insert_free_buffer(alloc, buffer);
>         alloc->free_async_space = alloc->buffer_size / 2;
>         binder_alloc_set_vma(alloc, vma);
> -       mmgrab(alloc->vma_vm_mm);
>
>         return 0;
>
> @@ -1091,6 +1089,8 @@ static struct shrinker binder_shrinker = {
>  void binder_alloc_init(struct binder_alloc *alloc)
>  {
>         alloc->pid = current->group_leader->pid;
> +       alloc->vma_vm_mm = current->mm;
> +       mmgrab(alloc->vma_vm_mm);
>         mutex_init(&alloc->mutex);
>         INIT_LIST_HEAD(&alloc->buffers);
>  }
> --
> 2.37.2.672.g94769d06f0-goog
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>

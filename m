Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C263761A588
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiKDXS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiKDXS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:18:26 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653E11174
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 16:18:24 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id c1so7664719lfi.7
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 16:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SkG8a2lBXIEH4itkRiXpweNrm4NZYzs7qP31oMzUhE8=;
        b=WM97PY9JBtAaZsPZyJjHhUWu263g022qTT6fZRIZiJU5UZt56M/Jp+iT2APYuwopSo
         pELT0DUxjE84SGKr/BHZr+rkRihCLCm7jRTYnSb/L8FWnBzVeFk1Fh4DsiFjEhk6Xt6E
         dSTZXBKo1pB6ZwBZN3NwUIt/BmMMOKGpzG/Q+arf/MrRgS6Sx6ojn3HqXq9KPxpIw+r4
         rgRjdIrT+4b/gqW6s/PxDhfMuKq1fzYNXm5QXQ/dwRmFTI88aJ0eg7YrlZfuJ5o9siP4
         fKqBcIIPhspHc46Mc+t9dF9Sscv0Te7KggrOpQJw4PfeFx9jkogLyGkPQ4WShTraOutK
         Rl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkG8a2lBXIEH4itkRiXpweNrm4NZYzs7qP31oMzUhE8=;
        b=l2zhMvcy64W5YbDikj17sBIXb4a7IJC7UaNv4e5rPHQ5HUvvcOeEJBRLwwzF0SYKUP
         RCrYUTLyOyHpCUoR+CRQ+yC9fvLVI4FctqYttHoAedvMjvOU+gEq3jV1sD63C+YQtiRO
         PLBbIZKOYON/grHmmGNZ9KIQev5RWPlb+Lmlf/ktN8Va5P2cgyfTSsFX/UncU8QtEGzA
         fOvSmBscIwsVGTk9+KtgBzd63bqJ3TIuaIZsltSsWqR20Nyrm5rZDFnhYP2d2IU2hYRh
         XftJV4qAlnkxFfW2nP9h7YdIuoYfRPcCHQMt9EfnEiRzPdKMH34Ys5IsUzHheWwp83Io
         UYpw==
X-Gm-Message-State: ACrzQf2sEMW3SKpWOO7QmSDibGX/pQ7img1+x+XnUqXF3PF+4LKu1CsM
        NwmSTEwR1RKIMVgeOZ0trwbzv0q8NOpzle2mwgY4fDkbCgg=
X-Google-Smtp-Source: AMsMyM6/h36zo1ykZnsmGV12vfY3wMl22n1c5PxN/WqOdSKA+2Q5qATMApleKjgHaeoFHvy/aqEzRqJcHkRpp/k/ddo=
X-Received: by 2002:a05:6512:3ba0:b0:4a2:6e24:faae with SMTP id
 g32-20020a0565123ba000b004a26e24faaemr13763979lfv.505.1667603902568; Fri, 04
 Nov 2022 16:18:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221104175450.306810-1-cmllamas@google.com>
In-Reply-To: <20221104175450.306810-1-cmllamas@google.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 4 Nov 2022 16:18:11 -0700
Message-ID: <CAHRSSExkh_C1Bt5f+43kEwjY2_kBggOKFmQYM8KwpVB9obrPJg@mail.gmail.com>
Subject: Re: [PATCH 5.10] binder: fix UAF of alloc->vma in race with munmap()
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        kernel-team@android.com, Jann Horn <jannh@google.com>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Liam Howlett <liam.howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 4, 2022 at 10:55 AM Carlos Llamas <cmllamas@google.com> wrote:
>
> In commit 720c24192404 ("ANDROID: binder: change down_write to
> down_read") binder assumed the mmap read lock is sufficient to protect
> alloc->vma inside binder_update_page_range(). This used to be accurate
> until commit dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in
> munmap"), which now downgrades the mmap_lock after detaching the vma
> from the rbtree in munmap(). Then it proceeds to teardown and free the
> vma with only the read lock held.
>
> This means that accesses to alloc->vma in binder_update_page_range() now
> will race with vm_area_free() in munmap() and can cause a UAF as shown
> in the following KASAN trace:
>
>   ==================================================================
>   BUG: KASAN: use-after-free in vm_insert_page+0x7c/0x1f0
>   Read of size 8 at addr ffff16204ad00600 by task server/558
>
>   CPU: 3 PID: 558 Comm: server Not tainted 5.10.150-00001-gdc8dcf942daa #1
>   Hardware name: linux,dummy-virt (DT)
>   Call trace:
>    dump_backtrace+0x0/0x2a0
>    show_stack+0x18/0x2c
>    dump_stack+0xf8/0x164
>    print_address_description.constprop.0+0x9c/0x538
>    kasan_report+0x120/0x200
>    __asan_load8+0xa0/0xc4
>    vm_insert_page+0x7c/0x1f0
>    binder_update_page_range+0x278/0x50c
>    binder_alloc_new_buf+0x3f0/0xba0
>    binder_transaction+0x64c/0x3040
>    binder_thread_write+0x924/0x2020
>    binder_ioctl+0x1610/0x2e5c
>    __arm64_sys_ioctl+0xd4/0x120
>    el0_svc_common.constprop.0+0xac/0x270
>    do_el0_svc+0x38/0xa0
>    el0_svc+0x1c/0x2c
>    el0_sync_handler+0xe8/0x114
>    el0_sync+0x180/0x1c0
>
>   Allocated by task 559:
>    kasan_save_stack+0x38/0x6c
>    __kasan_kmalloc.constprop.0+0xe4/0xf0
>    kasan_slab_alloc+0x18/0x2c
>    kmem_cache_alloc+0x1b0/0x2d0
>    vm_area_alloc+0x28/0x94
>    mmap_region+0x378/0x920
>    do_mmap+0x3f0/0x600
>    vm_mmap_pgoff+0x150/0x17c
>    ksys_mmap_pgoff+0x284/0x2dc
>    __arm64_sys_mmap+0x84/0xa4
>    el0_svc_common.constprop.0+0xac/0x270
>    do_el0_svc+0x38/0xa0
>    el0_svc+0x1c/0x2c
>    el0_sync_handler+0xe8/0x114
>    el0_sync+0x180/0x1c0
>
>   Freed by task 560:
>    kasan_save_stack+0x38/0x6c
>    kasan_set_track+0x28/0x40
>    kasan_set_free_info+0x24/0x4c
>    __kasan_slab_free+0x100/0x164
>    kasan_slab_free+0x14/0x20
>    kmem_cache_free+0xc4/0x34c
>    vm_area_free+0x1c/0x2c
>    remove_vma+0x7c/0x94
>    __do_munmap+0x358/0x710
>    __vm_munmap+0xbc/0x130
>    __arm64_sys_munmap+0x4c/0x64
>    el0_svc_common.constprop.0+0xac/0x270
>    do_el0_svc+0x38/0xa0
>    el0_svc+0x1c/0x2c
>    el0_sync_handler+0xe8/0x114
>    el0_sync+0x180/0x1c0
>
>   [...]
>   ==================================================================
>
> To prevent the race above, revert back to taking the mmap write lock
> inside binder_update_page_range(). One might expect an increase of mmap
> lock contention. However, binder already serializes these calls via top
> level alloc->mutex. Also, there was no performance impact shown when
> running the binder benchmark tests.
>
> Note this patch is specific to stable branches 5.4 and 5.10. Since in
> newer kernel releases binder no longer caches a pointer to the vma.
> Instead, it has been refactored to use vma_lookup() which avoids the
> issue described here. This switch was introduced in commit a43cfc87caaf
> ("android: binder: stop saving a pointer to the VMA").
>
> Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
> Reported-by: Jann Horn <jannh@google.com>
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Acked-by: Todd Kjos <tkjos@google.com>

> ---
>  drivers/android/binder_alloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 95ca4f934d28..a77ed66425f2 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -212,7 +212,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
>                 mm = alloc->vma_vm_mm;
>
>         if (mm) {
> -               mmap_read_lock(mm);
> +               mmap_write_lock(mm);
>                 vma = alloc->vma;
>         }
>
> @@ -270,7 +270,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
>                 trace_binder_alloc_page_end(alloc, index);
>         }
>         if (mm) {
> -               mmap_read_unlock(mm);
> +               mmap_write_unlock(mm);
>                 mmput(mm);
>         }
>         return 0;
> @@ -303,7 +303,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
>         }
>  err_no_vma:
>         if (mm) {
> -               mmap_read_unlock(mm);
> +               mmap_write_unlock(mm);
>                 mmput(mm);
>         }
>         return vma ? -ENOMEM : -ESRCH;
> --
> 2.38.1.431.g37b22c650d-goog
>

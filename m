Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD11596086
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 18:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbiHPQnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 12:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbiHPQnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 12:43:32 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CD580F7B
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:43:24 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-3321c2a8d4cso113286517b3.5
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 09:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=FOpQGOCCCOeHXcTTEf2Jf8cH6crBmZD9kljFNdM3FZI=;
        b=MTj13ZQOudsv0Y/McakJDk6R1ExbHgwbtUeK89PeymxtSWo3zoC/Q+XY5F0T9OgxhA
         CzABOs9R7GE90wClbCdVOrcM6GRfOKwq+0a/5wfHvjtt6DYvaF1PRFQQ3M062sfAtwI4
         8UnQAo38spsmsPCYWMBFEbqgijBH+I/eJMfioC6BVTs7FJi2en4QOqZKHDlWzdImDdH+
         J6IVV754BSXjX/oT6ElqiIjwORuzURt2RgAmqdA3R9RHomDzCMQf2wRPzE28XTQv2ajt
         bB05KJTL9nz58MGwokLqh0fOH7HYqUj+tJgv4ZQMpboYpqVIKxfZcJykgQQFCFG6VrxU
         vPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=FOpQGOCCCOeHXcTTEf2Jf8cH6crBmZD9kljFNdM3FZI=;
        b=vZFnwy5DCV6hgQ+2ZlCD/eS25FzleLdaYOrqXgqykrA+jFYjGwTc8ex7GtTDXeXvNY
         cLYTx9724c7eGe0uKN/MXIfumw5r3whug1MLYR3q/xKg1xvAayemdxFfoio/oGqMxNdH
         T7rRnu7NpqpDICNqT6rCnQ/aQiW0cHNHOBC6fRXeN5pDYePYlVaMnKHKVXrWLmIbyrX9
         vB0g7pXAWMILtYXZs2YmY4GGACjBMrYRxkjfb0oICoTJ+IeaIf5I6xIMpC+Ig2Lcc18P
         TvRsedcQadP4z93lY3dZtMBEOWtD6aPMRXvL/lPk6BU35vYy22D3Fh0nX+s4Iw/pKloh
         E2JA==
X-Gm-Message-State: ACgBeo26vL4XkxBKIuyMf6VFllmqVJaamauYv9eVrDqv1dVgs0WmLZq4
        mbp6ZF1gfXjiGE0RVDR1EWcL16EmS3QHYd2ng2XipQ==
X-Google-Smtp-Source: AA6agR4FvwhB43vbINiId5VrN/UidMBLEc0XDLd20dewxucrXu77Ob4LcptLKymiABwR4E47RjbNq3rfNRF4Q3GtxXE=
X-Received: by 2002:a81:500a:0:b0:333:9bcd:8a41 with SMTP id
 e10-20020a81500a000000b003339bcd8a41mr2849801ywb.4.1660668202873; Tue, 16 Aug
 2022 09:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220816163641.2359996-1-elver@google.com>
In-Reply-To: <20220816163641.2359996-1-elver@google.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 16 Aug 2022 18:42:46 +0200
Message-ID: <CANpmjNP0TMenugBVCqCYLT4AGCTH80RafcmgQRN7X8SzGjoQ6g@mail.gmail.com>
Subject: Re: [PATCH 5.19.y] Revert "mm: kfence: apply kmemleak_ignore_phys on
 early allocated pool"
To:     elver@google.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Yee Lee <yee.lee@mediatek.com>,
        Max Schulze <max.schulze@online.de>
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

On Tue, 16 Aug 2022 at 18:37, Marco Elver <elver@google.com> wrote:
>
> This reverts commit 07313a2b29ed1079eaa7722624544b97b3ead84b.
>
> Commit 0c24e061196c21d5 ("mm: kmemleak: add rbtree and store physical
> address for objects allocated with PA") is not yet in 5.19 (but appears
> in 6.0). Without 0c24e061196c21d5, kmemleak still stores phys objects
> and non-phys objects in the same tree, and ignoring (instead of freeing)
> will cause insertions into the kmemleak object tree by the slab
> post-alloc hook to conflict with the pool object (see comment).
>
> Reports such as the following would appear on boot, and effectively
> disable kmemleak:
>
>  | kmemleak: Cannot insert 0xffffff806e24f000 into the object search tree (overlaps existing)
>  | CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.19.0-v8-0815+ #5
>  | Hardware name: Raspberry Pi Compute Module 4 Rev 1.0 (DT)
>  | Call trace:
>  |  dump_backtrace.part.0+0x1dc/0x1ec
>  |  show_stack+0x24/0x80
>  |  dump_stack_lvl+0x8c/0xb8
>  |  dump_stack+0x1c/0x38
>  |  create_object.isra.0+0x490/0x4b0
>  |  kmemleak_alloc+0x3c/0x50
>  |  kmem_cache_alloc+0x2f8/0x450
>  |  __proc_create+0x18c/0x400
>  |  proc_create_reg+0x54/0xd0
>  |  proc_create_seq_private+0x94/0x120
>  |  init_mm_internals+0x1d8/0x248
>  |  kernel_init_freeable+0x188/0x388
>  |  kernel_init+0x30/0x150
>  |  ret_from_fork+0x10/0x20
>  | kmemleak: Kernel memory leak detector disabled
>  | kmemleak: Object 0xffffff806e24d000 (size 2097152):
>  | kmemleak:   comm "swapper", pid 0, jiffies 4294892296
>  | kmemleak:   min_count = -1
>  | kmemleak:   count = 0
>  | kmemleak:   flags = 0x5
>  | kmemleak:   checksum = 0
>  | kmemleak:   backtrace:
>  |      kmemleak_alloc_phys+0x94/0xb0
>  |      memblock_alloc_range_nid+0x1c0/0x20c
>  |      memblock_alloc_internal+0x88/0x100
>  |      memblock_alloc_try_nid+0x148/0x1ac
>  |      kfence_alloc_pool+0x44/0x6c
>  |      mm_init+0x28/0x98
>  |      start_kernel+0x178/0x3e8
>  |      __primary_switched+0xc4/0xcc
>
> Reported-by: Max Schulze <max.schulze@online.de>
> Signed-off-by: Marco Elver <elver@google.com>

The discussion is:

Link: https://lore.kernel.org/all/b33b33bc-2d06-1bcd-2df7-43678962b728@online.de/

> ---
>  mm/kfence/core.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6aff49f6b79e..4b5e5a3d3a63 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -603,6 +603,14 @@ static unsigned long kfence_init_pool(void)
>                 addr += 2 * PAGE_SIZE;
>         }
>
> +       /*
> +        * The pool is live and will never be deallocated from this point on.
> +        * Remove the pool object from the kmemleak object tree, as it would
> +        * otherwise overlap with allocations returned by kfence_alloc(), which
> +        * are registered with kmemleak through the slab post-alloc hook.
> +        */
> +       kmemleak_free(__kfence_pool);
> +
>         return 0;
>  }
>
> @@ -615,16 +623,8 @@ static bool __init kfence_init_pool_early(void)
>
>         addr = kfence_init_pool();
>
> -       if (!addr) {
> -               /*
> -                * The pool is live and will never be deallocated from this point on.
> -                * Ignore the pool object from the kmemleak phys object tree, as it would
> -                * otherwise overlap with allocations returned by kfence_alloc(), which
> -                * are registered with kmemleak through the slab post-alloc hook.
> -                */
> -               kmemleak_ignore_phys(__pa(__kfence_pool));
> +       if (!addr)
>                 return true;
> -       }
>
>         /*
>          * Only release unprotected pages, and do not try to go back and change
> --
> 2.37.1.595.g718a3a8f04-goog
>

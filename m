Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D047F61A58A
	for <lists+stable@lfdr.de>; Sat,  5 Nov 2022 00:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiKDXTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 19:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKDXTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 19:19:13 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED084BCB6
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 16:19:08 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p8so9269241lfu.11
        for <stable@vger.kernel.org>; Fri, 04 Nov 2022 16:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fFiVSihEUlMiTEa4qZRcDjgGlUKpPk4pRBdbI5gNmN8=;
        b=R0Rf2/k53ktFa7mGQFPqnwqqbhSB2kXpLVeu/JkFXJTtFiVnq3shAL2s65gRFk+WWw
         JnXtfVSg26wEsBq5wpFQXdOyQzoLuockskHHBUkFYjIKPjwqx/OplomOc+85QsMzPHnL
         AabkMhtmTxBlNFY5bd2ZvKdGgZsa9+rCWhi3/emVTpJD/ULOZuvIpk3GdyiXZsOgEBUz
         oNGxfQgMUCaMyqM3Qe5w27WpsStxWmkbzoV9XFsXj2smVl+Cd6CRVkJGIfzKGlc8EhM+
         wh3sJlmnKxbpOLcPSQE7su3xMLL9EYJZTlvOoFkKL1W7ny0dnBRc/hwFUbsggY8vncPw
         n4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fFiVSihEUlMiTEa4qZRcDjgGlUKpPk4pRBdbI5gNmN8=;
        b=1EsYnHhZ/OihkxWJYoQfpSIyIRU1WkrSYP9lrpZmH4Mg8jdSqAWG+rEAL3d79yLPO3
         5LkcSRlYgHA06oJISjv1TlR+3vfNQgSp+9Q1Fh6xSllteRg3pw5FpsV5SMLGHNHQ/slC
         tayCXKK5MGLMHnk9oKU/IjEO0xgYAOV6cnoRvpUyLqqbLNj0jnaeh5pEle7KmImVFiIP
         lfSXh4TEBw0SMrPq3I139/8fTwOlHOsVjv6Fz1qx+WqYhg5V77Bu64IbGeEIMf/8aKyt
         E0lAuhmaJaI5mjNAyRaJ75BvMA1mZpUUfS+3pMbB2yPQ5IsaCcYU2FnhqcXkbwfT2cUW
         zC+A==
X-Gm-Message-State: ACrzQf34JfvlHUgS78O9bdNzJIR2c1nJf0M0L2+Xiu0v50IqjhgElcDB
        qlwbIoWGq6cbq6/4LeJZU3SHBgWDVFZLBIeWDlxFMg==
X-Google-Smtp-Source: AMsMyM7V/6PGyExz7FsQLlBkK39SUWkSoxDb9aI+jzbKCTWgNdPP/pdGPYlXBU5ppDCIOutJwdEt9j1QHNx2pK2ueWM=
X-Received: by 2002:a05:6512:158c:b0:4a2:5cf6:5338 with SMTP id
 bp12-20020a056512158c00b004a25cf65338mr14300108lfb.81.1667603947105; Fri, 04
 Nov 2022 16:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221104231235.348958-1-cmllamas@google.com>
In-Reply-To: <20221104231235.348958-1-cmllamas@google.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 4 Nov 2022 16:18:55 -0700
Message-ID: <CAHRSSEy4tfkFtnxSXrgX5PhUdj2xf+yrfC7Zujf-mvt2ekJe+Q@mail.gmail.com>
Subject: Re: [PATCH] binder: validate alloc->mm in ->mmap() handler
To:     Carlos Llamas <cmllamas@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
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

On Fri, Nov 4, 2022 at 4:12 PM Carlos Llamas <cmllamas@google.com> wrote:
>
> Since commit 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr
> dereference") binder caches a pointer to the current->mm during open().
> This fixes a null-ptr dereference reported by syzkaller. Unfortunately,
> it also opens the door for a process to update its mm after the open(),
> (e.g. via execve) making the cached alloc->mm pointer invalid.
>
> Things get worse when the process continues to mmap() a vma. From this
> point forward, binder will attempt to find this vma using an obsolete
> alloc->mm reference. Such as in binder_update_page_range(), where the
> wrong vma is obtained via vma_lookup(), yet binder proceeds to happily
> insert new pages into it.
>
> To avoid this issue fail the ->mmap() callback if we detect a mismatch
> between the vma->vm_mm and the original alloc->mm pointer. This prevents
> alloc->vm_addr from getting set, so that any subsequent vma_lookup()
> calls fail as expected.
>
> Fixes: 1da52815d5f1 ("binder: fix alloc->vma_vm_mm null-ptr dereference")
> Reported-by: Jann Horn <jannh@google.com>
> Cc: <stable@vger.kernel.org> # 5.15+
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Acked-by: Todd Kjos <tkjos@google.com>

> ---
>  drivers/android/binder_alloc.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 1c39cfce32fa..4ad42b0f75cd 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -739,6 +739,12 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
>         const char *failure_string;
>         struct binder_buffer *buffer;
>
> +       if (unlikely(vma->vm_mm != alloc->mm)) {
> +               ret = -EINVAL;
> +               failure_string = "invalid vma->vm_mm";
> +               goto err_invalid_mm;
> +       }
> +
>         mutex_lock(&binder_alloc_mmap_lock);
>         if (alloc->buffer_size) {
>                 ret = -EBUSY;
> @@ -785,6 +791,7 @@ int binder_alloc_mmap_handler(struct binder_alloc *alloc,
>         alloc->buffer_size = 0;
>  err_already_mapped:
>         mutex_unlock(&binder_alloc_mmap_lock);
> +err_invalid_mm:
>         binder_alloc_debug(BINDER_DEBUG_USER_ERROR,
>                            "%s: %d %lx-%lx %s failed %d\n", __func__,
>                            alloc->pid, vma->vm_start, vma->vm_end,
> --
> 2.38.1.431.g37b22c650d-goog
>

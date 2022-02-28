Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E02D4C6A48
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbiB1L0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 06:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiB1L0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 06:26:09 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC7A70F76
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 03:25:28 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2d07ae0b1c4so103876517b3.11
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 03:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p96IvP9fUv4h1PakADfoqUYPHYxVnqzVwq2/kj5L+eU=;
        b=KeqMjQGcDStWNcUS49dVbtvAJpxlSiOVErm61ZtH3VI5hAlAj0vQ1zcHquzneX3cK7
         neNjKRdIJoiS6BtbKzb2YPS5nMEe8m5YxMTC5lR8kyZFI3AO2veXAPK8lwntA20ztYMd
         KwUOA9e03fmOZ7HBoLWjb7t05sZeU/W4/KDzfTVTyKgA+MnDe1LSwmaphusTfs1ef6fK
         of3KNhlrrVLJq9O7wpEVW9QSv8MmTwUXBvSrPyyIb375h4xyL7mvnPWA5QyNw68S+Ep9
         h8+rf2NLd5Ip6RKVm7BOKl3zCDQHJWQQ+5s3ZGb3VbTOTSOB/sLncqcMr94bCvJDt0gD
         xv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p96IvP9fUv4h1PakADfoqUYPHYxVnqzVwq2/kj5L+eU=;
        b=P5L3KhNkmSrGTcpGXtcbkB2hwAdmkEUnJMRWGVDXFLcYlx+kT9DXI4HQt/UAG/kMrr
         uO495MgwICCnfr+ihtkVytztzjThXMG0s2pp3ZB9SZjxMfB837c1PoRLY0aEyYnvPRVE
         NxtFaPULxpxWK6wXSFnVvl/WWms3uURwtMCDnG5toY6VhPLXM3Cw47oWZQCJa/lwLLkB
         gpkLme87IwzmWiIsjUiUeivizgFo3Ag5qtNasBLH5hISg33vcXntjD2QvPlcjOWt6Sey
         afuJcN4Sm0GkdttISJF4UUxmucp6LQPyjYepLvtsE0MSEoqucL3AL2Z3N7UUdxNtG1j6
         iRzA==
X-Gm-Message-State: AOAM533JcQZK+BSheqbuCcwHz4mzYHWQ2Ij7a/mbrSiPUZB5Vtu4ZqFL
        tVknNXaRRL0Q0gl/DoQK9Qfk7hMMuRA9O73OLHWQRw==
X-Google-Smtp-Source: ABdhPJz54dXk6AW8cnKh1rdgLlHMk+YG/fbrfpJzpZACyNSQ2YmjarYCbN3mfTc15EcGKVu9pa7aHfMqg5A3HN7vpFE=
X-Received: by 2002:a81:7943:0:b0:2d0:c8bb:a45d with SMTP id
 u64-20020a817943000000b002d0c8bba45dmr18980716ywc.264.1646047527866; Mon, 28
 Feb 2022 03:25:27 -0800 (PST)
MIME-Version: 1.0
References: <20220225221625.3531852-1-keescook@chromium.org>
In-Reply-To: <20220225221625.3531852-1-keescook@chromium.org>
From:   Marco Elver <elver@google.com>
Date:   Mon, 28 Feb 2022 12:24:51 +0100
Message-ID: <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com>
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
To:     Kees Cook <keescook@chromium.org>
Cc:     llvm@lists.linux.dev, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Micay <danielmicay@gmail.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Feb 2022 at 23:16, Kees Cook <keescook@chromium.org> wrote:
>
> If ksize() is used on an allocation, the compiler cannot make any
> assumptions about its size any more (as hinted by __alloc_size). Force
> it to forget.
>
> One caller was using a container_of() construction that needed to be
> worked around.
>
> Cc: Marco Elver <elver@google.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: linux-mm@kvack.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1599
> Fixes: c37495d6254c ("slab: add __alloc_size attributes for better bounds checking")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> This appears to work for me, but I'm waiting for more feedback on
> the specific instance got tripped over in Android.
> ---
>  drivers/base/devres.c |  4 +++-
>  include/linux/slab.h  | 26 +++++++++++++++++++++++++-
>  mm/slab_common.c      | 19 +++----------------
>  3 files changed, 31 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index eaa9a5cd1db9..1a2645bd7234 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -855,6 +855,7 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
>         size_t total_new_size, total_old_size;
>         struct devres *old_dr, *new_dr;
>         unsigned long flags;
> +       void *allocation;
>
>         if (unlikely(!new_size)) {
>                 devm_kfree(dev, ptr);
> @@ -874,7 +875,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
>         if (!check_dr_size(new_size, &total_new_size))
>                 return NULL;
>
> -       total_old_size = ksize(container_of(ptr, struct devres, data));
> +       allocation = container_of(ptr, struct devres, data);
> +       total_old_size = ksize(allocation);
>         if (total_old_size == 0) {
>                 WARN(1, "Pointer doesn't point to dynamically allocated memory.");
>                 return NULL;
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 37bde99b74af..a14f3bfa2f44 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -182,8 +182,32 @@ int kmem_cache_shrink(struct kmem_cache *s);
>  void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
>  void kfree(const void *objp);
>  void kfree_sensitive(const void *objp);
> +
> +/**
> + * ksize - get the actual amount of memory allocated for a given object
> + * @objp: Pointer to the object
> + *
> + * kmalloc may internally round up allocations and return more memory
> + * than requested. ksize() can be used to determine the actual amount of
> + * memory allocated. The caller may use this additional memory, even though
> + * a smaller amount of memory was initially specified with the kmalloc call.
> + * The caller must guarantee that objp points to a valid object previously
> + * allocated with either kmalloc() or kmem_cache_alloc(). The object
> + * must not be freed during the duration of the call.
> + *
> + * Return: size of the actual memory used by @objp in bytes
> + */
> +#define ksize(objp) ({                                                 \
> +       /*                                                              \
> +        * Getting the actual allocation size means the __alloc_size    \
> +        * hints are no longer valid, and the compiler needs to         \
> +        * forget about them.                                           \
> +        */                                                             \
> +       OPTIMIZER_HIDE_VAR(objp);                                       \
> +       _ksize(objp);                                                   \
> +})

So per that ClangBuiltLinux issue I'm gleaning that the __alloc_size
annotations are actually causing the compiler to generate wrong code?
Possibly due to the compiler thinking that the accesses must stay
within some bound, and anything beyond that will be "undefined
behaviour"? Clearly, per the slab APIs, in particular with the
provision of ksize(), the compiler is wrong.

At first I thought this was only related to UBSAN bounds checking
generating false positives, in which case a simple workaround as you
present above would probably take care of most cases.

But if the real issue is the compiler suddenly doing more aggressive
compiler optimizations because it thinks accesses beyond the object
size (per __alloc_size) is UB, but UB can never happen, and thus does
crazy things [1], I think the answer (at least with what we have right
now) should be to find a different solution that is more reliable.

[1] https://lore.kernel.org/all/20220218131358.3032912-1-gregkh@linuxfoundation.org/

Because who's to say that there's not some code that does:

   foo = kmalloc(...);
   ...
   bar = foo;
   s = ksize(bar);
   ... makes access address-dependent on 's' and 'foo' (but not 'bar') ...

This doesn't look like code anyone would write, but I fear with enough
macro and inline function magic, it's not too unlikely.

I can see a few options:

1. Dropping __alloc_size.
2. Somehow statically computing the size-class's size (kmalloc_index()
might help here), removing __alloc_size from allocation functions and
instead use some wrapper.
3. Teaching the compiler to drop *all* object sizes upon encountering a ksize().

So I think #1 is probably not what you want. #2 seems quite
complicated, and in many cases likely too relaxed and would miss bugs,
so also not ideal. #3 would be the most reliable, but
OPTIMIZER_HIDE_VAR() doesn't cut it, and we need something stronger.
The downside of #3 is that it might pessimize code generation, but
given ksize() is used sparingly, might be ok.

Thanks,
-- Marco

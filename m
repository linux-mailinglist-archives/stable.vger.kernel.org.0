Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDF43376C8
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 16:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhCKPSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 10:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhCKPR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 10:17:56 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8373DC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 07:17:56 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id m1so1675119ote.10
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 07:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F5wgH+AYh/WyBJYoU8SW+a64FMCETkhDvGXcF7UG8O0=;
        b=aSWbR3Pvn7pX6f0WXhotBAv9D8NImhk+RaEESRDwAttp8xGG3gwuYCDghud8rWELsw
         79MvmcR+jdn5nrt8VgqML22BCf7v8lsIAk9mw0KGqViwIaC/GsBw3SNXzgS6Jzcd5pJj
         PL3xcLndwDvqe5k/ABaAWUV8c1zAkZ4N/gpxt9wYGplTZ4Ruls2t2MeSWmfufVKTZEQC
         Kxj2gIJWeHS/YGaWuiktzXee02XKUYgDcEEbiG3rymVUYJpc6fCg3tCSSOuUWOAQmBnY
         9TopooQdPXsXgbkbDlr/jBXhK6GGc/YBN/eKOxEYLHOzrWfkQ6ZYqZSRjCbMEj1bN7Aa
         O4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F5wgH+AYh/WyBJYoU8SW+a64FMCETkhDvGXcF7UG8O0=;
        b=mOSoKS0JTAH9Szs1mACQeuxKhjc0EdaQHVxVijqAvxCVR3uezqs3Pn/w7wPKTnZEzz
         ymS5PQuzKQTKL+xTNMANAS5ZNuYJigGWtv8pWOmopiYhRoLLxQyzeB3veXb+nfFjmYYd
         glLIi9sWS0cd75t2bxOtv6VtoaLOJfDAJrGuCqwYvo6wY3q5vBSRoW6o8aJDExnMXjrV
         f3kLf7OOIwQfz0JYv1g86SWeqpH4JZ0SAThNOWcO04np3SewibM3B6z79m9LgBwUEEpZ
         LS4rWVA9rm42Ipe1HGAfzvumqfk4uiBJMlV2CLO5PH19Tc115kFfFyvnAzSE8K0xVAxt
         Bpeg==
X-Gm-Message-State: AOAM531yp3e2WzBJCzLn/lixKeo90hclkhE/5h9w+ySFdSccQnZXIo7W
        6I6PXGJjGS/mlsfW2LiJ0Y05sH/LHflPuIxiWI3wWw==
X-Google-Smtp-Source: ABdhPJw3cPtdxfwVqx28rchxLZPHsrrsv1nJx4iEhEJqGOxeMh88fcv/Af+jTyyEoF4hNTCZ3KkZk1EsrX59z62M+qQ=
X-Received: by 2002:a9d:644a:: with SMTP id m10mr7491620otl.233.1615475875698;
 Thu, 11 Mar 2021 07:17:55 -0800 (PST)
MIME-Version: 1.0
References: <1a41abb11c51b264511d9e71c303bb16d5cb367b.1615475452.git.andreyknvl@google.com>
In-Reply-To: <1a41abb11c51b264511d9e71c303bb16d5cb367b.1615475452.git.andreyknvl@google.com>
From:   Marco Elver <elver@google.com>
Date:   Thu, 11 Mar 2021 16:17:43 +0100
Message-ID: <CANpmjNP4Uz4Kmr+8KE_reyjRLCTj9q0s3ncQ26Xay+1Xwxvgiw@mail.gmail.com>
Subject: Re: [PATCH] kasan: fix per-page tags for non-page_alloc pages
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Branislav Rankov <Branislav.Rankov@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Mar 2021 at 16:11, Andrey Konovalov <andreyknvl@google.com> wrote:
>
> To allow performing tag checks on page_alloc addresses obtained via
> page_address(), tag-based KASAN modes store tags for page_alloc
> allocations in page->flags.
>
> Currently, the default tag value stored in page->flags is 0x00.
> Therefore, page_address() returns a 0x00ffff... address for pages
> that were not allocated via page_alloc.
>
> This might cause problems. A particular case we encountered is a conflict
> with KFENCE. If a KFENCE-allocated slab object is being freed via
> kfree(page_address(page) + offset), the address passed to kfree() will
> get tagged with 0x00 (as slab pages keep the default per-page tags).
> This leads to is_kfence_address() check failing, and a KFENCE object
> ending up in normal slab freelist, which causes memory corruptions.
>
> This patch changes the way KASAN stores tag in page-flags: they are now
> stored xor'ed with 0xff. This way, KASAN doesn't need to initialize
> per-page flags for every created page, which might be slow.
>
> With this change, page_address() returns natively-tagged (with 0xff)
> pointers for pages that didn't have tags set explicitly.
>
> This patch fixes the encountered conflict with KFENCE and prevents more
> similar issues that can occur in the future.
>
> Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>

Reviewed-by: Marco Elver <elver@google.com>

Thank you!

> ---
>  include/linux/mm.h | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77e64e3eac80..c45c28f094a7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1440,16 +1440,28 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
>
>  #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
>
> +/*
> + * KASAN per-page tags are stored xor'ed with 0xff. This allows to avoid
> + * setting tags for all pages to native kernel tag value 0xff, as the default
> + * value 0x00 maps to 0xff.
> + */
> +
>  static inline u8 page_kasan_tag(const struct page *page)
>  {
> -       if (kasan_enabled())
> -               return (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
> -       return 0xff;
> +       u8 tag = 0xff;
> +
> +       if (kasan_enabled()) {
> +               tag = (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MASK;
> +               tag ^= 0xff;
> +       }
> +
> +       return tag;
>  }
>
>  static inline void page_kasan_tag_set(struct page *page, u8 tag)
>  {
>         if (kasan_enabled()) {
> +               tag ^= 0xff;
>                 page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
>                 page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
>         }
> --
> 2.31.0.rc2.261.g7f71774620-goog
>

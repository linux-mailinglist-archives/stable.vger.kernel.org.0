Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB3F96884
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbfHTSX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 14:23:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34985 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729639AbfHTSX3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 14:23:29 -0400
Received: by mail-pf1-f193.google.com with SMTP id d85so3884387pfd.2
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 11:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOFyNsed5rJiYxQ0MTC7KZVSzKzfGGoAHwsINBTkR8c=;
        b=RTgt2WBFYErhRUqHnDQpEac6HHvi9lJ/Y7KdUeeE6iLFn22BZvfnis5Y2t0G0k5QIv
         wfBfc9ypmkXQjiMGC7/xV0BwM/EldJ7OfcZMyjDWBlhyXPTlXoT9M7CT5shi3knBfzRR
         g0QOcAYoHouObhmxCgJOKRH3AHyLXaptg/qIW60hqCGCVLcB3FC/G8UMPkMKZDBRsjmV
         J2j2x1rdz3vofl0JvNYwnMx7XrZHZR7hwJO96VWMcsi6QI+Q77v06FO4llseMH3rg1yM
         b8WSEtd0HbvlTK1HyuHDjqy4IlwbP4Z97SYn10skLY5AvpckPs56c/a/yALL3+ZEjjkQ
         7LVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOFyNsed5rJiYxQ0MTC7KZVSzKzfGGoAHwsINBTkR8c=;
        b=OlF9o5i+uwjDe1NVdtVRxVbx0AemBdxbuIdg20YziCpwFsTNNFBj8yufZd5d7yotok
         LwOQYqB2BWbUQVrrHwea6EYMX595iUVngb3m/pxw8/EHt6wvgFW2wKjSoJUyMXpkj98a
         goSUlVYvM0ZcDlONou0Sj+biPfsZ9W0Xu+mRWN149Nqt3E/2dMDn+Boi+eWL6cycxXEk
         bsnfHOdcY7VmH8UmJpyTR2CzimkTEhJNDP7fxXewS60vwCPjlWYdgT+i48AFZ4jYTEgM
         6EF/Bj+dqnb7QRSOlbjGbdnFCX6nudqlHeW1vLi9BGSgPW99QwRXf6x80SmwsDKSmI4Q
         BIyQ==
X-Gm-Message-State: APjAAAV5/6DkQ5icnQsT5hVhyYLuKEgHjxzayB2WTTeATK++SOoNouw/
        VPk3zc1g2fFrdzSuhH2J1aVPg3ipg+SVG49uaOS/hg==
X-Google-Smtp-Source: APXvYqy8PLQYCo/xr+i9cPe8QscCmqNqVsHsPH7Fdu4ulHy26e9hF6RpbHf3y2AMkzxyGBDXSUMgQLMfwvvKkdaTDpc=
X-Received: by 2002:a17:90a:6581:: with SMTP id k1mr1293058pjj.47.1566325408133;
 Tue, 20 Aug 2019 11:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190819172540.19581-1-aryabinin@virtuozzo.com>
In-Reply-To: <20190819172540.19581-1-aryabinin@virtuozzo.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Tue, 20 Aug 2019 20:23:17 +0200
Message-ID: <CAAeHK+yhaZ07ojK4v-=iVTBiEunXOu=V3f9zvTr9P2wZzAq3Zw@mail.gmail.com>
Subject: Re: [PATCH] mm/kasan: Fix false positive invalid-free reports with CONFIG_KASAN_SW_TAGS=y
To:     Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Walter Wu <walter-zh.wu@mediatek.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Mark Rutland <mark.rutland@arm.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 19, 2019 at 7:26 PM Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
>
> The code like this:
>
>         ptr = kmalloc(size, GFP_KERNEL);
>         page = virt_to_page(ptr);
>         offset = offset_in_page(ptr);
>         kfree(page_address(page) + offset);
>
> may produce false-positive invalid-free reports on the kernel with
> CONFIG_KASAN_SW_TAGS=y.
>
> In the example above we loose the original tag assigned to 'ptr',
> so kfree() gets the pointer with 0xFF tag. In kfree() we check that
> 0xFF tag is different from the tag in shadow hence print false report.
>
> Instead of just comparing tags, do the following:
>  1) Check that shadow doesn't contain KASAN_TAG_INVALID. Otherwise it's
>     double-free and it doesn't matter what tag the pointer have.
>
>  2) If pointer tag is different from 0xFF, make sure that tag in the shadow
>     is the same as in the pointer.
>
> Fixes: 7f94ffbc4c6a ("kasan: add hooks implementation for tag-based mode")
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
> Reported-by: Mark Rutland <mark.rutland@arm.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Andrey Konovalov <andreyknvl@google.com>

> ---
>  mm/kasan/common.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 895dc5e2b3d5..3b8cde0cb5b2 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -406,8 +406,14 @@ static inline bool shadow_invalid(u8 tag, s8 shadow_byte)
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>                 return shadow_byte < 0 ||
>                         shadow_byte >= KASAN_SHADOW_SCALE_SIZE;
> -       else
> -               return tag != (u8)shadow_byte;
> +
> +       /* else CONFIG_KASAN_SW_TAGS: */
> +       if ((u8)shadow_byte == KASAN_TAG_INVALID)
> +               return true;
> +       if ((tag != KASAN_TAG_KERNEL) && (tag != (u8)shadow_byte))
> +               return true;
> +
> +       return false;
>  }
>
>  static bool __kasan_slab_free(struct kmem_cache *cache, void *object,
> --
> 2.21.0
>

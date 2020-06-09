Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0611F3727
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 11:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgFIJk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 05:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgFIJk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 05:40:27 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5CEC05BD1E;
        Tue,  9 Jun 2020 02:40:27 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h95so1165846pje.4;
        Tue, 09 Jun 2020 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0LmYuaLHDCX38AdTMp8CH5P20ueYkef1FJtYGuErWr0=;
        b=iZhInEofjFBEHtHE7GeJouMaefY9oGLHcssBL97Z6FJSy5q7sVksn7kHNPbXs5Fyme
         nvw1AygtgIRbGvSW3rcRriYX0/JkLCPSVsZ+qx9wtzi7+KUQ2fnnQcVz+ClqG1sHzwVu
         A1aRmBRVcxD5xcxl3bOa3z7t+zHOvWIbRgrzx/LI+DceWfXpmTOAByclcazEeUoA7xfV
         cpii/U189HXVjmYEZVsWgd9NOjMUbeTJqVwkCY8TWkVIH8cEhXNR3wIG5JgciwoF2F4u
         qkvTw9bQnmnpQiUt5f4AGAgi+WP+d8AQj7WdVpnBhxfJ805ZNhPNnQ35IrNS7ATVSxhG
         z6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0LmYuaLHDCX38AdTMp8CH5P20ueYkef1FJtYGuErWr0=;
        b=Dr6QLH3k2yKeDCagFcqs6OqDqQhkoKdFO6PRpM7hEQUr73JJ2szd9FtfgF2WxfdBOe
         JmmpFKAK1Y8UiCEN1+UZomVhRmvpDTlNTbLu4DCECDoW3Y/UAdMWugCgqZeiyCe+cQtz
         9dYO3jmuCff+32a7EkFZyxM/m6T8kGN5Uh78jHD6CidyiKQkKHzdY89uNPjh9LsOrJ55
         4WkQIdy7FY89h9/usUCpNxx6Y4XF1+168uA4sZLBxp+7g1IFx+PKb0VIbq9ys9XgH0Bh
         xrDLL2QK1GLdpOCUHHazGCagpVLIFDhEE8SvsKYfGQc/nwWxq1El3vEN9ZquM5qgZHAY
         Ouvw==
X-Gm-Message-State: AOAM530xROteKjng/Ay4hg5KHt6NLmzYuR2TopimZyeBH+6pQPRBndwC
        W8EmxuyPT741VI44I23NajrLX1GLBANfMCnGntE=
X-Google-Smtp-Source: ABdhPJy0K6qECWGfNW5IeQp2dojJSGnEuDI05pVZLiMXScl5O0mHGkrQQNfkcQE+ESO73iwWP1mndKwR/w/GayrSQws=
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr3962059pjq.228.1591695626571;
 Tue, 09 Jun 2020 02:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <1591634471-17647-1-git-send-email-agordeev@linux.ibm.com>
In-Reply-To: <1591634471-17647-1-git-send-email-agordeev@linux.ibm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 9 Jun 2020 12:40:14 +0300
Message-ID: <CAHp75Vf1G6bpVvOHdG598o5oOZ3=S=ecsct-GhkyK0e+=FE_DQ@mail.gmail.com>
Subject: Re: [PATCH v2] lib: fix bitmap_parse() on 64-bit big endian archs
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 8, 2020 at 8:47 PM Alexander Gordeev <agordeev@linux.ibm.com> wrote:
>
> Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not
> take into account order of halfwords on 64-bit big endian
> architectures. As result (at least) Receive Packet Steering,
> IRQ affinity masks and runtime kernel test "test_bitmap" get
> broken on s390.

LGTM (I would replace while loop, but it's style preference and one
can consider worse than infinite loop)

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

>
> Fixes: 2d6261583be0 ("lib: rework bitmap_parse()")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Amritha Nambiar <amritha.nambiar@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Miklos Szeredi <mszeredi@redhat.com>
> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: "Tobin C . Harding" <tobin@kernel.org>
> Cc: Vineet Gupta <vineet.gupta1@synopsys.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  lib/bitmap.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index 89260aa342d6..80d26b183248 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -739,6 +739,7 @@ int bitmap_parse(const char *start, unsigned int buflen,
>         const char *end = strnchrnul(start, buflen, '\n') - 1;
>         int chunks = BITS_TO_U32(nmaskbits);
>         u32 *bitmap = (u32 *)maskp;
> +       int chunk = 0;
>         int unset_bit;
>
>         while (1) {
> @@ -749,9 +750,14 @@ int bitmap_parse(const char *start, unsigned int buflen,
>                 if (!chunks--)
>                         return -EOVERFLOW;
>
> -               end = bitmap_get_x32_reverse(start, end, bitmap++);
> +#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
> +               end = bitmap_get_x32_reverse(start, end, &bitmap[chunk ^ 1]);
> +#else
> +               end = bitmap_get_x32_reverse(start, end, &bitmap[chunk]);
> +#endif
>                 if (IS_ERR(end))
>                         return PTR_ERR(end);
> +               chunk++;
>         }
>
>         unset_bit = (BITS_TO_U32(nmaskbits) - chunks) * 32;
> --
> 2.23.0
>


-- 
With Best Regards,
Andy Shevchenko

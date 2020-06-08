Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55321F1864
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgFHMDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgFHMDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 08:03:18 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36BBC08C5C2;
        Mon,  8 Jun 2020 05:03:18 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t16so6573384plo.7;
        Mon, 08 Jun 2020 05:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pM5X2YtapFWuSkDwXFYHOUc12hO3c2lItIisPiXHQGY=;
        b=hlaI/X2BEdu5DgSxAm6kB07OPe7M25Gvh52cfold8MS6AFOumejiu9RPBd5jcVPDTg
         2pt5Ihb8e+UJUm042qK+Wch8QmNHdF1RJQpe9lh6SVMe97OWd0QiduR/hXS+wWgyDOvP
         AKOvCNve69T9GXxz2aMRXRIozw8kkWrtRSipFStp5SYG5lO4K0oT9qFXsl/2jkBVKaU7
         OmOnFW/Pbaxgl/KZP1HzbQ4ArzR1YJLVihKRvjHD/SMJZNirBsrzJYMKCq13Eft5gsU/
         HTZ0E2/sgsj1TJbmiE68ZnMteRg0odb/O0fYprG6bWydeoH5IM+LEJjIFnvjK/3SfP+3
         y/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pM5X2YtapFWuSkDwXFYHOUc12hO3c2lItIisPiXHQGY=;
        b=e/zjVNw3g86UhG+Jcxg5DfpDWLT2+FKTh6a35H+vaQslaIHZ1bg3cvOcbNbMbE3/kK
         cPx3mpHETVj6utjl8GTaI/XP4Svwig64bU87+CBeBu94/WWdLHgz8tyV7v2Mu+GLRKhK
         0dMCsgfaM+F+fYTGw7y3a3mA5gSGX6HS+WUYs/W5KF58xbP92pw3tgVbmCZYFBCNmmAo
         h5MRIiej2GTZgGvakby505guTnbwyqI18zCYEeB15ct25mA769dEa0jGyCVyUDSuvj2T
         iFHY4Q2/cHR0vNeXYA5XBFjFxWVndDWUEZ4miqgAWnnNnGVaCo6C7zqdh8827Kk4hwHn
         RBTw==
X-Gm-Message-State: AOAM530bhfy9t+tjBMKBsMsX1Y5Fc7NUSI4w1ENI9ImbNRQg7j3UVD8F
        Ec03pLHym7X7qxvoFGWf144SLl7+3rmC49ogYJQ=
X-Google-Smtp-Source: ABdhPJzy6nnYdAQTRPWCex6+8jSc+Wso/vIgnHDy7gsVnQJzj+ADZ8ojZnrCRPnZO2B9QhUqv5R1pbDzd9PTeN79vlc=
X-Received: by 2002:a17:90a:ac05:: with SMTP id o5mr17147126pjq.228.1591617797903;
 Mon, 08 Jun 2020 05:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <1591611829-23071-1-git-send-email-agordeev@linux.ibm.com>
In-Reply-To: <1591611829-23071-1-git-send-email-agordeev@linux.ibm.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 8 Jun 2020 15:03:05 +0300
Message-ID: <CAHp75VcFdrvNMj0TL8ZHxShqqGDM31Hy8vitmn9HOPjZ6f9uYw@mail.gmail.com>
Subject: Re: [PATCH RESEND2] lib: fix bitmap_parse() on 64-bit big endian archs
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

On Mon, Jun 8, 2020 at 1:26 PM Alexander Gordeev <agordeev@linux.ibm.com> wrote:
>
> Commit 2d6261583be0 ("lib: rework bitmap_parse()") does not
> take into account order of halfwords on 64-bit big endian
> architectures. As result (at least) Receive Packet Steering,
> IRQ affinity masks and runtime kernel test "test_bitmap" get
> broken on s390.

...

> +#if defined(__BIG_ENDIAN) && defined(CONFIG_64BIT)

I think it's better to re-use existing patterns.

ipc/sem.c:1682:#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)

> +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> +{
> +       maskp += (chunk_idx / 2);
> +       ((u32 *)maskp)[(chunk_idx & 1) ^ 1] = chunk;
> +}
> +#else
> +static void save_x32_chunk(unsigned long *maskp, u32 chunk, int chunk_idx)
> +{
> +       ((u32 *)maskp)[chunk_idx] = chunk;
> +}
> +#endif

See below.

...

> -               end = bitmap_get_x32_reverse(start, end, bitmap++);
> +               end = bitmap_get_x32_reverse(start, end, &chunk);
>                 if (IS_ERR(end))
>                         return PTR_ERR(end);
> +
> +               save_x32_chunk(maskp, chunk, chunk_idx++);

Can't we simple do

        int chunk_index = 0;
        ...
        do {
#if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
               end = bitmap_get_x32_reverse(start, end,
bitmap[chunk_index ^ 1]);
#else
               end = bitmap_get_x32_reverse(start, end, bitmap[chunk_index]);
#endif
        ...
        } while (++chunk_index);

?

-- 
With Best Regards,
Andy Shevchenko

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0444348F233
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiANV65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiANV64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:58:56 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F459C061574;
        Fri, 14 Jan 2022 13:58:56 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id h30so9478519ila.12;
        Fri, 14 Jan 2022 13:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gmfAhubjEyaVBPWv1g0ex2hEpije68c3WmxI7HlJuIk=;
        b=QnmdCE3NJISxA+/1AWG4v/lMA6X1fAvApupya0G6ju2+yMwnUKhXgkISyblOky7wCH
         Iawa8V9VAsNgx7S12bZLNY6lIb2W7w9QALKSGmIeeDreHrmlrikiu3u5BRvdhqJ/6/Jo
         9xXq6H4H1OaymlUbwKpuC0Ak27BK0BjWEQNSuOnL4s0wNNsAVbkErr42oLIC4obma8EK
         SD+CzfoXgDV6Ckt2IPEvXWoMtxq/tE/IfTBCZM+JeocTf7KLSeXDK1GCPWowiCK9HmyK
         4HeERsvOmOvdEmNj2k2Tz2D3aXW35vtBPVw0DbFiTyBWSR018gqvECgwFQa9qLjl9bx7
         NEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gmfAhubjEyaVBPWv1g0ex2hEpije68c3WmxI7HlJuIk=;
        b=ESNX34cPkRJ9r300RgCIz28xpuKjbaJKIQvd/h8HqM4/nCFd7pvIDG/GFZXnQeMomm
         hXQPSQFxPpUdnRCrU67ejJmane9CK9MmK1l4J7YjUtGhfe4ndJoHJp1a9T/LX7UH1rTP
         KXxgHsuxTJN9DtVsvlZfk3u1jfIabfDa3BZKQJU178/xgO/7x07R7E1stzynLIjeTXUN
         upHmQhoA3OcFx0dSF4kxj3VmDkbNFFjs5ud0autA2iULOK1bFlo7HYXdmR+mv8aKh6Kd
         ImGHGZ3Du8XPWZea0lNv3o/S7CU2D5d1I+8/Hh34fF82RIdrDB88/vrT2b6hZfWD8cvk
         bwSA==
X-Gm-Message-State: AOAM531/Qq/MAt/B6wZXTZQo4I2z6BiNVf6O+Ulr0MDHgwjQrC2kjjSW
        4EJHMjzWmjHV7Yz5h8xuo/iFNhu2SbHFXAETv5M=
X-Google-Smtp-Source: ABdhPJyEqWk4kGHWNUxv/NqZeg5vXP4u/CwmwuwfG3M0oC96dClS8SejOQ80vW+AxDbzi+M3FzZQrmnQm0Ct0B6rL1U=
X-Received: by 2002:a92:1e0a:: with SMTP id e10mr5942316ile.28.1642197535952;
 Fri, 14 Jan 2022 13:58:55 -0800 (PST)
MIME-Version: 1.0
References: <20220113031434.464992-1-pcc@google.com>
In-Reply-To: <20220113031434.464992-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Sat, 15 Jan 2022 00:58:44 +0300
Message-ID: <CA+fCnZeckbw+Vv9TQaCNfaMBA9DkMGXeiQwcoHnwxoO6fCrzcA@mail.gmail.com>
Subject: Re: [PATCH] mm: use compare-exchange operation to set KASAN page tag
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 On Thu, Jan 13, 2022 at 6:14 AM Peter Collingbourne <pcc@google.com> wrote:
>
> It has been reported that the tag setting operation on newly-allocated
> pages can cause the page flags to be corrupted when performed
> concurrently with other flag updates as a result of the use of
> non-atomic operations.

Is it know how exactly this race happens? Why are flags for a newly
allocated page being accessed concurrently?

> Fix the problem by using a compare-exchange
> loop to update the tag.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
> Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
> Cc: stable@vger.kernel.org
> ---
>  include/linux/mm.h | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c768a7c81b0b..b544b0a9f537 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1531,11 +1531,17 @@ static inline u8 page_kasan_tag(const struct page *page)
>
>  static inline void page_kasan_tag_set(struct page *page, u8 tag)
>  {
> -       if (kasan_enabled()) {
> -               tag ^= 0xff;
> -               page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
> -               page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> -       }
> +       unsigned long old_flags, flags;
> +
> +       if (!kasan_enabled())
> +               return;
> +
> +       tag ^= 0xff;
> +       do {
> +               old_flags = flags = page->flags;

I guess this should be at least READ_ONCE(page->flags) if we care
about concurrency.

> +               flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
> +               flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> +       } while (unlikely(cmpxchg(&page->flags, old_flags, flags) != old_flags));
>  }
>
>  static inline void page_kasan_tag_reset(struct page *page)
> --
> 2.34.1.575.g55b058a8bb-goog
>

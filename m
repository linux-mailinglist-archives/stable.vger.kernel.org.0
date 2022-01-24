Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA98498685
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbiAXRWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244445AbiAXRWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:22:54 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DA7C06173B;
        Mon, 24 Jan 2022 09:22:54 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id v6so20379838iom.6;
        Mon, 24 Jan 2022 09:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8MQ4czb3ly2s0ZsHOR2X1HdMa1yeCdwsrvL3BnehgA=;
        b=Wg2tUc+O43y+Z/MoAaE+dIs/RaMYZg3sY5Qr5LVg3GlCgc4PYr2PKS5NFnGiQjW4/E
         Xg/e0p94De6lky+3hq+TVAtuI2D+mKpdkNvAAECOKSakxmY9LtOjYTMczIv9I47a0LC1
         HBjDdJc9vbqBUHUHY0DR75+K4I2j5K8eQpslOyIm1nTgTPcbtMj3NKddE4Wls/j+tgOA
         O8fIaLFeiXmzv4zKTd3GC1nagNriRzRL+urBT1QGxlw1swAIdBycI78zgT9zB5N1TvLn
         zmV0n3bSt1HC3AK81NOMCBIbYQ515Gh8IGvP1mqVXHCuT1K2x1pnh1a63Tub/P8o1R/I
         87wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8MQ4czb3ly2s0ZsHOR2X1HdMa1yeCdwsrvL3BnehgA=;
        b=N9jSq/+ZLoFnKZQspHm7O6uVybtOu4DRTHiXeL35cK93/0RxCIsGqZczEqpcr1eP2F
         dFWHDgJ4xpC+i0togHMp1ISR1404poS2COt9urjwlixNMZXTs5wDwRt+/qY8KadFf/xP
         SNq2p6h9l6NWb09THfh6X7gzvxA6lycy8gklDj7CqmJ+uHf3KAs4zsaxi3RrVfCMV60p
         ko88wDe6C8tTkDjQbqj5rmhhuH3SgwZygmWLaXmMLS/a1wcp8314d+8QaiPVzUOn73TV
         4vI4VYxshxCCvBotxc4UbLlbR5oiwc9fde1kc33AADR1e+WaLReqwA896lsXd6fH9Zya
         NLRg==
X-Gm-Message-State: AOAM5304ehYKzqhFCymlChTVQ7SsQRFC8DkYI7O/cUraceUoriXpbRvM
        5yZ96aRC+9gWVspzYT9CmcMGTww+i+AjYKyoinpXxSIbyKk=
X-Google-Smtp-Source: ABdhPJyQnGtfIbojLhJ7nOqwsG6cQ6YUdbeVqP4NbJ9FV0B/g8EYeQIMJZJ+MT74ICkdxcLPsKBJ+5Yw/kAAzmlA9CA=
X-Received: by 2002:a02:b382:: with SMTP id p2mr7731338jan.71.1643044973568;
 Mon, 24 Jan 2022 09:22:53 -0800 (PST)
MIME-Version: 1.0
References: <20220120020148.1632253-1-pcc@google.com>
In-Reply-To: <20220120020148.1632253-1-pcc@google.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Mon, 24 Jan 2022 18:22:42 +0100
Message-ID: <CA+fCnZeC5K+YoFbMg30Gasyq6AXp5WFCxagrsftkT+mJPuBZkQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: use compare-exchange operation to set KASAN page tag
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 20, 2022 at 3:02 AM Peter Collingbourne <pcc@google.com> wrote:
>
> It has been reported that the tag setting operation on newly-allocated
> pages can cause the page flags to be corrupted when performed
> concurrently with other flag updates as a result of the use of
> non-atomic operations. Fix the problem by using a compare-exchange
> loop to update the tag.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
> Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
> Cc: stable@vger.kernel.org
> ---
> v3:
> - use try_cmpxchg() as suggested by Peter Zijlstra on another
>   patch
>
> v2:
> - use READ_ONCE()
>
>  include/linux/mm.h | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c768a7c81b0b..87473fe52c3f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1531,11 +1531,18 @@ static inline u8 page_kasan_tag(const struct page *page)
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
> +       old_flags = READ_ONCE(page->flags);
> +       do {
> +               flags = old_flags;
> +               flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
> +               flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> +       } while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)));
>  }
>
>  static inline void page_kasan_tag_reset(struct page *page)
> --
> 2.34.1.703.g22d0c6ccf7-goog
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

FWIW, try_cmpxchg() doesn't seem to be doing annotated atomic accesses
when accessing old_flags, so using READ_ONCE() in page_kasan_tag_set()
seems pointless after all.

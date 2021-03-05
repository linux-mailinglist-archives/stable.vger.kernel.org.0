Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1666232F6F9
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 00:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCEXyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 18:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhCEXyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 18:54:44 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DB2C061760
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 15:54:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id i14so98803pjz.4
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 15:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNxGCp729OVTS5P6uQ6HNjJN45BugeibGn1RfeYppc4=;
        b=wOuK4AFFOQnE05XJqSetLQLZi5EwCXJ8MYXXz0KDuThxN+q9glQ/S+mGR55NmaH3BD
         xd9RGIGFImO+DqLtKHaqHCE9JHt/ny6mq2IzvpWiRs7QKX39AEdwOU13LIM4rCsjWmzK
         rxjbhSDzmiB8O4Xso24fXEXLmsacztDMLjCaziXu8xbPvaGlIz6RszVHxyc94VgyvA0D
         RLdhCFNbChqnCGNx/m5Qh3T5lAxc0qxAKndRcUULNvDiuZH9aYzHItbn/zFxjDXff4MF
         POH3we+QmiIe76xD0WrlD4t2U/ebUx6qO8PM3CJRVIJcPmyhtYxyBMq6IT4ZLaaVDIiz
         fztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNxGCp729OVTS5P6uQ6HNjJN45BugeibGn1RfeYppc4=;
        b=V82vCGQwVAjI1fpCpYJDl/wnEhHXORo4GVYa7Dwx91PeYETt81tcJtIbz4iwdzP6Z6
         svawCuHRgZzqLu0yYesrRr7eGenzuJLdhodGJWvaQdH1McYApY20j7m9I60Mnvmb3nxW
         j+k7BMV1V4GfDVBA9UMToogz7ZJNFmKp8ygPllztIj/I9j7J7A/JvaTNf5QU/F1cjKkH
         sXzhjyFxRF7ALUVvCyQrU2gJ3E4X+SRN5rcxWrgLVUMUe7kJOC8vsk2oEHbTUwm4VmSH
         s0QGrUIYxv1ApEsZ/a4Gv/Ffq5iQlMDdxZ13pujBfWatvPABYuEil9WfSkcgiycVdFBq
         PAsg==
X-Gm-Message-State: AOAM533rt9NxvQfmH/pvuTj/hHnxhN/aRGytdhUqnJDrFpPvYh1xM13H
        G1pf7lTCAmGNawxyQvkvFHlhYNxhrwcTH4YHKaUtVA==
X-Google-Smtp-Source: ABdhPJypgUPjzeO58PREZy1WSBz6aEuSQMeRIjsjpF1lfpSHzvzN6zb0fGOwDaKN1ZXxg5kD0/v/8UMO3nnDPYpFM2o=
X-Received: by 2002:a17:90b:350b:: with SMTP id ls11mr12605611pjb.166.1614988483675;
 Fri, 05 Mar 2021 15:54:43 -0800 (PST)
MIME-Version: 1.0
References: <24cd7db274090f0e5bc3adcdc7399243668e3171.1614987311.git.andreyknvl@google.com>
 <20210305154956.3bbfcedab3f549b708d5e2fa@linux-foundation.org>
In-Reply-To: <20210305154956.3bbfcedab3f549b708d5e2fa@linux-foundation.org>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Sat, 6 Mar 2021 00:54:32 +0100
Message-ID: <CAAeHK+yHf7p9H_EiPVfA9qadGU_6x0RrKwX-WjKrHEFz+xFEbg@mail.gmail.com>
Subject: Re: [PATCH v2] kasan, mm: fix crash with HW_TAGS and DEBUG_PAGEALLOC
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Marco Elver <elver@google.com>,
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

On Sat, Mar 6, 2021 at 12:50 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sat,  6 Mar 2021 00:36:33 +0100 Andrey Konovalov <andreyknvl@google.com> wrote:
>
> > Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
> > after debug_pagealloc_unmap_pages(). This causes a crash when
> > debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an
> > unmapped page.
> >
> > This patch puts kasan_free_nondeferred_pages() before
> > debug_pagealloc_unmap_pages() and arch_free_page(), which can also make
> > the page unavailable.
> >
> > ...
> >
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1304,6 +1304,12 @@ static __always_inline bool free_pages_prepare(struct page *page,
> >
> >       kernel_poison_pages(page, 1 << order);
> >
> > +     /*
> > +      * With hardware tag-based KASAN, memory tags must be set before the
> > +      * page becomes unavailable via debug_pagealloc or arch_free_page.
> > +      */
> > +     kasan_free_nondeferred_pages(page, order, fpi_flags);
> > +
> >       /*
> >        * arch_free_page() can make the page's contents inaccessible.  s390
> >        * does this.  So nothing which can access the page's contents should
> > @@ -1313,8 +1319,6 @@ static __always_inline bool free_pages_prepare(struct page *page,
> >
> >       debug_pagealloc_unmap_pages(page, 1 << order);
> >
> > -     kasan_free_nondeferred_pages(page, order, fpi_flags);
> > -
> >       return true;
> >  }
>
> kasan_free_nondeferred_pages() has only two args in current mainline.

Ah, yes, forgot to mention: this goes on top of:

kasan: initialize shadow to TAG_INVALID for SW_TAGS
mm, kasan: don't poison boot memory with tag-based modes

>
> I fixed that in the obvious manner...

Thanks!

If you changed this patch, you'll also need to change the other one though.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A25B32F6FB
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 00:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhCEXzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 18:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCEXzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 18:55:11 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6BCC06175F
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 15:55:11 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b15so108905pjb.0
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 15:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3poge5+rEFOPBLlgkkWAEUuEZq1vRObX8yBVeHFMs0=;
        b=dZN6rzdOx/xJ7q6PKT4IdLtFYJWm+GNWL6cQXPKYqkAZVzlXUa7dPkT8BfaARZvGN7
         Omg6wkBv45SPIOqc7yGgd87U6V5Q7qZ2oLpVXznKrtPWZW1PM2GZqEX2vtFeVEh6xEH5
         kD6JrAu6llI6Po/C1owIaG+HrMCUPLvv5fLqLV82Ewox4Fjh/kHzM/171Xm6Ho87xfgW
         gA70EqvpqFxLbqOGjNHILOhx0kBzNy0toMMPojOcPh+Nsu76EVaGYD3RjAs+nUh/nVeo
         Xq2gB6YPVHE28u+Mz9l64195jslRHp9rPbyhO8T3ylfUo7U4HR1H8S9+MCBftzwLzg2k
         9vcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3poge5+rEFOPBLlgkkWAEUuEZq1vRObX8yBVeHFMs0=;
        b=TxL1SEkVXx1dPqjRE7D1dk7gkUwjneN33ECVMwiC07SmDcfHdgaJrN3rwGSVAwtXH0
         OV+r8Tg45iIzTCE8oZ+dFUqqJAalk6xIpJEkXv/iy1n43c6Q7WEe2ywiPb9ZprqJSpmA
         b8I0QHzjqqe5i1BZnm4Ls5T6QBEOtVngFLtv5Nz20tctTfpyAkUJsqqpsR7qGHR7Cqh1
         +ZGo3iH8IEOEmjdf24AVG1Lgn291W52ARKINJ87ejnG2Ju75Nf8nLS4vgsNdLvqEoC17
         ljbvTPKelEEHFdN3UqjrlQOhCmMJiuPXqtPlpR3qZSoQki6ke1KjsGhkvp9qpvWqNHNI
         +y5A==
X-Gm-Message-State: AOAM533pLXQSgb39/bPQTX/2qlLxqKaKdK78x9AuJ9nxFu9AAckVn6Dx
        mQlZ3pjrI+s9G/PJmeOa7AeeHbx2NE3zCLXjxsmeOw==
X-Google-Smtp-Source: ABdhPJxsHOVKHkJsQgBmJ8MCE2TahFZc5ouI9vLx674RguitlqsK538zUjNntZM1amjxtos2fVSc+2XJiUPQyAMXTDA=
X-Received: by 2002:a17:903:31ca:b029:e6:65f:ca87 with SMTP id
 v10-20020a17090331cab02900e6065fca87mr1091669ple.85.1614988510448; Fri, 05
 Mar 2021 15:55:10 -0800 (PST)
MIME-Version: 1.0
References: <24cd7db274090f0e5bc3adcdc7399243668e3171.1614987311.git.andreyknvl@google.com>
 <20210305154956.3bbfcedab3f549b708d5e2fa@linux-foundation.org> <CAAeHK+yHf7p9H_EiPVfA9qadGU_6x0RrKwX-WjKrHEFz+xFEbg@mail.gmail.com>
In-Reply-To: <CAAeHK+yHf7p9H_EiPVfA9qadGU_6x0RrKwX-WjKrHEFz+xFEbg@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Sat, 6 Mar 2021 00:54:59 +0100
Message-ID: <CAAeHK+w3Xr8=xLP2og6A54f=wr=BvNj18yKR6ntno1-hbqroFw@mail.gmail.com>
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

On Sat, Mar 6, 2021 at 12:54 AM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> On Sat, Mar 6, 2021 at 12:50 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Sat,  6 Mar 2021 00:36:33 +0100 Andrey Konovalov <andreyknvl@google.com> wrote:
> >
> > > Currently, kasan_free_nondeferred_pages()->kasan_free_pages() is called
> > > after debug_pagealloc_unmap_pages(). This causes a crash when
> > > debug_pagealloc is enabled, as HW_TAGS KASAN can't set tags on an
> > > unmapped page.
> > >
> > > This patch puts kasan_free_nondeferred_pages() before
> > > debug_pagealloc_unmap_pages() and arch_free_page(), which can also make
> > > the page unavailable.
> > >
> > > ...
> > >
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1304,6 +1304,12 @@ static __always_inline bool free_pages_prepare(struct page *page,
> > >
> > >       kernel_poison_pages(page, 1 << order);
> > >
> > > +     /*
> > > +      * With hardware tag-based KASAN, memory tags must be set before the
> > > +      * page becomes unavailable via debug_pagealloc or arch_free_page.
> > > +      */
> > > +     kasan_free_nondeferred_pages(page, order, fpi_flags);
> > > +
> > >       /*
> > >        * arch_free_page() can make the page's contents inaccessible.  s390
> > >        * does this.  So nothing which can access the page's contents should
> > > @@ -1313,8 +1319,6 @@ static __always_inline bool free_pages_prepare(struct page *page,
> > >
> > >       debug_pagealloc_unmap_pages(page, 1 << order);
> > >
> > > -     kasan_free_nondeferred_pages(page, order, fpi_flags);
> > > -
> > >       return true;
> > >  }
> >
> > kasan_free_nondeferred_pages() has only two args in current mainline.
>
> Ah, yes, forgot to mention: this goes on top of:
>
> kasan: initialize shadow to TAG_INVALID for SW_TAGS
> mm, kasan: don't poison boot memory with tag-based modes
>
> >
> > I fixed that in the obvious manner...
>
> Thanks!
>
> If you changed this patch, you'll also need to change the other one though.

Nevermind, just realized that this should be a backportable fix :)

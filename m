Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB773A7425
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhFOCjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhFOCjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 22:39:06 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811F2C061767
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 19:37:02 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id m21so24277530lfg.13
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 19:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SFi/PESNY2XSZin92wkim2B0LZCDsgyMMnEnAZQIW7I=;
        b=mMeDPg+6+57U2DKhGXBPf7UuJ7VxGkYjJYFJsx1UEL7vvoJ78od1BcqWFXUJ//QZcB
         5eCSb3mpjkABlGvAfmdz3BFYfLJ6UkJkPB5bEqPXsAW3ZShbx4z2Hq5+j4XwLBbAFwd1
         puipJO5qVZwaq+C7ydPd60pNBaYwLIM08pYY/7E646HsgOXkaUC570FSj1y0C5INir+X
         LWd8ekf7FuAaPgqcOslVyJMHqu7LqgHftXlv00cJY7oAiqMEbbgs4qfZ8Ml2NnE5yZkC
         OJCo7xUvuIPUcZJPwSWpAG7tcN762iJNWKWmh8vZTTDJGgl22uO/JcrZjZJXfdf028m9
         HJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SFi/PESNY2XSZin92wkim2B0LZCDsgyMMnEnAZQIW7I=;
        b=miZ1fhtnq3dX3bnbmWeQpHrKMpQPOKoJ3EWQ7lMR9Jb1nvyS0yfxfWBXnowdC202Tn
         HHJadaKdAkTG4lOCpObl0zaJSr9IxCZcAJPhgbAetaImAhQAQted0CifwjqKEj58iEAa
         REgb60f0YrwPl2DoLgDjX9F00T6RfYUFNR0zrKV5+7+tl9OX1ZfLUrgLBLCntlhrfuL7
         LpvyxtopnLsx8AbtJiX9+IZw62txpaCKGY13orOMgP6CP2DgYT50iJxHd99FT6VyhmIM
         lX45euU5tW6wirrmkdpomYbfodmEW8zZYnOL83teh458wIU4I19hpd+S3UhqDtAIwlEy
         TKlg==
X-Gm-Message-State: AOAM533pIxmImzuGyM4OwK8MtlAk6jdvWRZ5gW7xFjZM+3QHB0K4xOnl
        zGHEMSx8nSvp54fQfUHtl2BqdMhBA/jsUSMy+KFe1g==
X-Google-Smtp-Source: ABdhPJyTuea2waJB0BHgIB73YI6EvHTUjvVxEYIOP4nb0whEZHOKept1JC0IVHGYiOzd0U5lI4PmZ3sz8MiNQK5TYXU=
X-Received: by 2002:a19:ef0a:: with SMTP id n10mr13670605lfh.352.1623724620645;
 Mon, 14 Jun 2021 19:37:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210615012014.1100672-1-jannh@google.com> <20210614190032.09d8b7ac530c8b14ace44b82@linux-foundation.org>
In-Reply-To: <20210614190032.09d8b7ac530c8b14ace44b82@linux-foundation.org>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 15 Jun 2021 04:36:34 +0200
Message-ID: <CAG48ez1nZcrJPO-hOLyE08g8HKSGEambCp6mNv6FNR2c9+6sJg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with split_huge_page()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 4:00 AM Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 15 Jun 2021 03:20:14 +0200 Jann Horn <jannh@google.com> wrote:
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -43,8 +43,25 @@ static void hpage_pincount_sub(struct page *page, int refs)
> >
> >       atomic_sub(refs, compound_pincount_ptr(page));
> >  }
> >
> > +/* Equivalent to calling put_page() @refs times. */
> > +static void put_page_refs(struct page *page, int refs)
> > +{
> > +#ifdef CONFIG_DEBUG_VM
> > +     if (VM_WARN_ON_ONCE_PAGE(page_ref_count(page) < refs, page))
> > +             return;
> > +#endif
>
> Well dang those ifdefs.
>
> With CONFIG_DEBUG_VM=n, this expands to
>
>         if (((void)(sizeof((__force long)(page_ref_count(page) < refs))))
>                 return;
>
> which will fail with "void value not ignored as it ought to be".
> Because VM_WARN_ON_ONCE_PAGE() is an rval with CONFIG_DEBUG_VM=y and is
> not an rval with CONFIG_DEBUG_VM=n.    So the ifdefs are needed.
>
> I know we've been around this loop before, but it still sucks!  Someone
> please remind me of the reasoning?
>
> Can we do
>
> #define VM_WARN_ON_ONCE_PAGE(cond, page) {
>         BUILD_BUG_ON_INVALID(cond);
>         cond;
> }
>
> ?

See also <https://lore.kernel.org/linux-mm/CAG48ez3Vb1BxaZ0EHhR9ctkjCCygMWOQqFMGqt-=Ea2yXrvKiw@mail.gmail.com/>.

I see basically two issues with your proposal:

1. Even if you use it without "if (...)", the compiler has to generate
code to evaluate the condition unless it can prove that the condition
has no side effects. (It can't prove that for stuff like atomic_read()
or READ_ONCE(), because those are volatile loads and C says you can't
eliminate those. There are compiler builtins that are more
fine-grained, but the kernel doesn't use those.)

2. The current version generates no code at all for !DEBUG_VM builds.
Your proposal would still have the conditional bailout even in
!DEBUG_VM builds - and if the compiler already has to evaluate the
condition and generate a conditional branch, I don't know whether
there is much of a point in omitting the code that prints a warning
under !DEBUG_VM (although I guess it could impact register spilling
and assignment).


If you don't like the ifdeffery in this patch, can you please merge
the v1 patch? It's not like I was adding a new BUG_ON(), I was just
refactoring an existing BUG_ON() into a helper function, so I wasn't
making things worse; and I don't want to think about how to best
design WARN/BUG macros for the VM subsystem in order to land this
bugfix.

(Also, this patch is intended for stable-backporting, so mixing in
more changes unrelated to the issue being fixed might make backporting
more annoying. This v2 patch will already require more fixup than the
v1 one, because VM_WARN_ON_ONCE_PAGE() was only added recently.)

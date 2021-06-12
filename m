Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C09C3A4C2B
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 03:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFLBxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 21:53:35 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:40755 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhFLBxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 21:53:34 -0400
Received: by mail-lf1-f48.google.com with SMTP id k40so11254315lfv.7
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 18:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DgJgazWwZm0ckWV47NnxvUxfq3HmV/tC3J+ues9bgWY=;
        b=WW2lJdYvuofDnZh5w550dcy8GMpYI9IhckSnmIxxkuBNem7Q0OEW33tDJvZEmTXCLu
         1ALyesAwRvJtyGFGSx3geqH7paIHx+//ODWMarr34VG4dIBcDcQl2GIkZtIwblVN77QO
         z260GdbH+lBBJ9VxwNGFvWUF1O8mwUc2JF5pw34IFHXQdpTVbZGrxRjPy86uTMbGdDQ/
         0zF78+L+uwQdrx+YsfzW7BkA1Bbp0iAwRoPO55h6bow9p5FO3Gw+8llkJhHLGiSot2wK
         D5cu25C69T6AYglJjVPQKLnEyzqxwbg7M3yaaTuTsvxkEgKTIokFCTJ8NeNeuc8XOST0
         DpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DgJgazWwZm0ckWV47NnxvUxfq3HmV/tC3J+ues9bgWY=;
        b=S9gzIeF63uQCTen52mNBzQw3TOga3U/qt9gUcWlFZaTY+Zfz6xgA5nI0PMHOYuSRBH
         WhfD/F0fZqKfY+2V6xlwH23VmG+QFf2cMSE5ZHMDo4kTUXVObdlhQB5+WGNpin99kM3M
         ym63mJSyohOPqaf+kP4uEDCR1mUsqBCy1mw14dTvCXC8Lqe6ouJrbYgMiCKMkrqLbcdT
         pL/D+hNNDzP8IvOasYUJGNHBr5waV72TVWTACdlHO7tl6faSkEFOzslLuD7yK+rgUQFV
         46C/U10hqTgka1wm2U5vo9Ln4u0PPWy4htz652e2ihcDKtKr6yrt2RKEG74wo0ojNgI2
         yNGw==
X-Gm-Message-State: AOAM532XAHI8/G4pUpgdNSxENrmYJC7ZAPIDzYrdreruz5OCsm9Vyapg
        T3U+BTgVhwIe5aSJ1EzrXGaA4dQtTWxkYyIqwbrUKA==
X-Google-Smtp-Source: ABdhPJwmAeFAI2/1QIPU5vaMZ1EtDuuYIQRqOvmFo5GQ1bmPA8XfQYh7lbkkpnNfNay5cEQGVaVuf7mi6/+5G/8fGxE=
X-Received: by 2002:a05:6512:754:: with SMTP id c20mr4359735lfs.356.1623462624060;
 Fri, 11 Jun 2021 18:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210611161545.998858-1-jannh@google.com> <20210611153624.65badf761078f86f76365ab9@linux-foundation.org>
In-Reply-To: <20210611153624.65badf761078f86f76365ab9@linux-foundation.org>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 12 Jun 2021 03:49:57 +0200
Message-ID: <CAG48ez3mjsf41Z2vCjmkuBaHe9XgoXbWDGvM4OJdUjqiCQbN4A@mail.gmail.com>
Subject: Re: [PATCH resend] mm/gup: fix try_grab_compound_head() race with split_huge_page()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 12, 2021 at 12:36 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 11 Jun 2021 18:15:45 +0200 Jann Horn <jannh@google.com> wrote:
> > +/* Equivalent to calling put_page() @refs times. */
> > +static void put_page_refs(struct page *page, int refs)
> > +{
> > +     VM_BUG_ON_PAGE(page_ref_count(page) < refs, page);
>
> I don't think there's a need to nuke the whole kernel in this case.
> Can we warn then simply leak the page?  That way we have a much better
> chance of getting a good bug report.

Ah, yeah, I guess that makes sense. I had just copied this over from
put_compound_head(), and figured it was fine to keep it as-is, but I
guess changing it would be reasonable. I'm not quite sure what the
best way to do that would be though.

I guess the check should go away in !DEBUG_VM builds?

Should I just explicitly put the check in an ifdef block? Like so:

#ifdef CONFIG_DEBUG_VM
if (VM_WARN_ON_ONCE_PAGE(...))
  return;
#endif

Or, since inline ifdeffery looks ugly, get rid of the explicit ifdef,
and change the !DEBUG_VM definition of VM_WARN_ON_ONCE_PAGE() as
follows so that the branch is compiled away?

#define VM_WARN_ON_ONCE_PAGE(cond, page)  (BUILD_BUG_ON_INVALID(cond), false)

That would look kinda neat, but it would be different from the
behavior of WARN_ON(), which still returns the original condition even
in !BUG builds, so that could be confusing...

> > +     /*
> > +      * Calling put_page() for each ref is unnecessarily slow. Only the last
> > +      * ref needs a put_page().
> > +      */
> > +     if (refs > 1)
> > +             page_ref_sub(page, refs - 1);
> > +     put_page(page);
> > +}
>

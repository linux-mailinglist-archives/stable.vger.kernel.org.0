Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C124930EA
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 23:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiARWif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 17:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbiARWie (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 17:38:34 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABF8C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:38:34 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id m90so1008379uam.2
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 14:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sFIPDwsDeRm81c05CD5S02oyUJN8DIpI+1GsvDMiep4=;
        b=Jfugtf9FbGJis6uBQ4CdXc/8nGduDpvhXy+a27fLvitVKGrLopKpViHKRTXSVXqewY
         cjAWMe19MPI2EVo2djGEGz3qllkZkYd9nbf6TEsLnVMTi+FdIzdmDADcm1tWu3ntoMqg
         vfgyvwacp89WuvL7BspNzyyBXpxQOeOTwYHhEvOq+me4IzdfiNkJtn7VmqCiMBwSxl9h
         j+jXpUvZ4pNBWhLTHMuNeOppkdgSynwqMWguZVWhdgyq3B6q2k8tEY0eCQNIA4A6BNni
         +wvxQlo2GGOJv9x2DtpxzkWVdwKdzQSbqFeGqcCgMHoL4pLIwsmJvkO3bhyzQMQqMe4Z
         BTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sFIPDwsDeRm81c05CD5S02oyUJN8DIpI+1GsvDMiep4=;
        b=fkREjGP0zMPLWdMinJC/fCUEXfJ0OTo3EjT23YHk2yVSOLy1bUQToaDIk6DPL9R+VN
         5XWjgYWeLFVkK10nvn250fzUpTl+2Zx9T0tW/RD6rlOzioXBBjYm/+jMWPE3suvfS6B8
         YF1VeT4qk7o0u/8wzI9/9qRwkvEBRgztTsuGogkSqhCY/qMo+geoKL9sWuLutHQRmmLw
         oNjGBnS7o4uhAUFsYvng2CFfg3gN3+HaZ99eeLjOn1F3YunWeSzXrASmFehoPUE1oOQC
         2gB+wmih54uVCgR7xtfngDLfbz7KEGdusEBls0YAmb+9Xk0PbOcJ6fy6tLn1UyhSyH9+
         BpPA==
X-Gm-Message-State: AOAM53077QKQen+J2bibXlNBuqOmGrm7zk8eKKa/acnFNmEeElV0tzy5
        3rWE92NkshSGUG2cPC5Q6Y1TgffM8kFkTp/YW3XggQ==
X-Google-Smtp-Source: ABdhPJxQh1t44Frfz/2XYxwpy7ZXI1lO+ncbRUGm6GBcUykDOdHTvp8gIOSQksTNoWrRHe66Sh+aumcYSnD4CXhOpo4=
X-Received: by 2002:a67:ebc2:: with SMTP id y2mr3183653vso.72.1642545513445;
 Tue, 18 Jan 2022 14:38:33 -0800 (PST)
MIME-Version: 1.0
References: <20220113031434.464992-1-pcc@google.com> <CA+fCnZeckbw+Vv9TQaCNfaMBA9DkMGXeiQwcoHnwxoO6fCrzcA@mail.gmail.com>
In-Reply-To: <CA+fCnZeckbw+Vv9TQaCNfaMBA9DkMGXeiQwcoHnwxoO6fCrzcA@mail.gmail.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 18 Jan 2022 14:38:22 -0800
Message-ID: <CAMn1gO7zBjaAU9f=qnKKhVBxuujmqzHDpuEdHQxtePDZVBgWMg@mail.gmail.com>
Subject: Re: [PATCH] mm: use compare-exchange operation to set KASAN page tag
To:     Andrey Konovalov <andreyknvl@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 1:58 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>
>  On Thu, Jan 13, 2022 at 6:14 AM Peter Collingbourne <pcc@google.com> wrote:
> >
> > It has been reported that the tag setting operation on newly-allocated
> > pages can cause the page flags to be corrupted when performed
> > concurrently with other flag updates as a result of the use of
> > non-atomic operations.
>
> Is it know how exactly this race happens? Why are flags for a newly
> allocated page being accessed concurrently?

In the report that we received, the race resulted in a crash in
kswapd. This may just be a symptom of the problem though.

I haven't closely audited all of the callers to page_kasan_tag_set()
to check whether they may be operating on already-visible pages, but
at least it doesn't appear to be unanticipated that there may be other
threads accessing the page flags concurrently with a call to
page_kasan_tag_set() (see the calls to smp_wmb() in
arch/arm64/kernel/mte.c, arch/arm64/mm/copypage.c and
arch/arm64/mm/mteswap.c).

> > Fix the problem by using a compare-exchange
> > loop to update the tag.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Link: https://linux-review.googlesource.com/id/I456b24a2b9067d93968d43b4bb3351c0cec63101
> > Fixes: 2813b9c02962 ("kasan, mm, arm64: tag non slab memory allocated via pagealloc")
> > Cc: stable@vger.kernel.org
> > ---
> >  include/linux/mm.h | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index c768a7c81b0b..b544b0a9f537 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1531,11 +1531,17 @@ static inline u8 page_kasan_tag(const struct page *page)
> >
> >  static inline void page_kasan_tag_set(struct page *page, u8 tag)
> >  {
> > -       if (kasan_enabled()) {
> > -               tag ^= 0xff;
> > -               page->flags &= ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
> > -               page->flags |= (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> > -       }
> > +       unsigned long old_flags, flags;
> > +
> > +       if (!kasan_enabled())
> > +               return;
> > +
> > +       tag ^= 0xff;
> > +       do {
> > +               old_flags = flags = page->flags;
>
> I guess this should be at least READ_ONCE(page->flags) if we care
> about concurrency.

Makes sense. I copied this code from page_cpupid_xchg_last() in
mm/mmzone.c which has the same problem. I'll send a patch to fix that
one as well.

Peter

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC8B3AA348
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 20:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhFPSnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 14:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhFPSnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 14:43:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE10BC061574;
        Wed, 16 Jun 2021 11:41:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id my49so5407175ejc.7;
        Wed, 16 Jun 2021 11:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFdiQI3qmnEyPxLcKXhVtU8Qc6gVzEZmvcKXtiv7pwA=;
        b=rCYk6IopIKVvTbBrdVu9tEpKZMkk+xOngtR5Y4tsgpcoBzFjKVkYrbSTxv+cuYY+69
         Z8ig6vEBX1rn57Gu0b86t36n4+pwXzXJMw3gUbUnp1xOqLhxCZm/HlyuuMrDm+K+xqrU
         Pb/7kzSFz4NnBlPMR7tI1S20OueZofIzOP+O/7+lcO+3Sz5mbVP2WwDHemXHAxP2yaeC
         X8afD2/hPmcpyrExmVwEoYkBo+BUN7rEjVLt8/4OnXrV/K3LinQYmWJsw3n4P9J8yPsH
         sg/UFIS+B+PWadlA/kO9t56jGyx0H/MLrRvvTf5fvVHfat2vtzNAG1LeDcJM8D1XdajX
         dSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFdiQI3qmnEyPxLcKXhVtU8Qc6gVzEZmvcKXtiv7pwA=;
        b=ZJPc6zPZdbh57k5z2YtEi5Z22Luj5C6gH4FehEZBiSZgIVLj2LA4R7C9Mgnsq6V6ie
         LTUg3ug5PtNciPvQkY1Fz+QlHMsNDoggWOYPZjhVFYa+Rz1nj67MgsL+VRhAR6WXRKJI
         2KAjCe68UAY9aSEWvViHwLKpVmU+dA/A03uQhl9bgb5TepB09MhdgbVVZcfULtpZVn+a
         905w6b/QchToYUrt6LNHcVDEI7eQex7gm6TY34IN4vZYA7bmTga+ll40jmwSQ7u2GAzG
         GHimtvoKBHY2uBDeYouC0GLvX8lD9wcKlWWvUe0UUUVBg6M7T1Eg+eawIfj/ZiPZJMha
         9xrw==
X-Gm-Message-State: AOAM5305GAyWVkTGsWiyGaRBl33dXfmgojJadR87eZkQrZdGv7yZPhlD
        ACB4vn/+50O6EIzxogCcpsn6Ui8M43nIZWRuYBc=
X-Google-Smtp-Source: ABdhPJzFcPdMo3Mt/oDcGJ2YhfBZ0Ag1Tb0F03O9be6WHHbSgHRNw4Nt7zYChxzQu0SnpFguR/o7Yf8eSiqDuSGMyvE=
X-Received: by 2002:a17:906:1691:: with SMTP id s17mr900783ejd.161.1623868862266;
 Wed, 16 Jun 2021 11:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210615012014.1100672-1-jannh@google.com> <50d828d1-2ce6-21b4-0e27-fb15daa77561@nvidia.com>
 <CAG48ez3Vbcvh4AisU7=ukeJeSjHGTKQVd0NOU6XOpRru7oP_ig@mail.gmail.com>
 <CAHbLzkomex+fgC8RyogXu-s5o2UrORMO6D2yTsSXW5Wo5z9WRA@mail.gmail.com> <6d21f8cb-4b72-bdec-386c-684ddbcdada1@suse.cz>
In-Reply-To: <6d21f8cb-4b72-bdec-386c-684ddbcdada1@suse.cz>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 16 Jun 2021 11:40:50 -0700
Message-ID: <CAHbLzkpa5MQBtYcRPWu4vNDn=Q8SKStQ-9wKYWogqRrMR3Aonw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with split_huge_page()
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Jann Horn <jannh@google.com>, John Hubbard <jhubbard@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 10:27 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 6/16/21 1:10 AM, Yang Shi wrote:
> > On Tue, Jun 15, 2021 at 5:10 AM Jann Horn <jannh@google.com> wrote:
> >>
> >> On Tue, Jun 15, 2021 at 8:37 AM John Hubbard <jhubbard@nvidia.com> wrote:
> >> > On 6/14/21 6:20 PM, Jann Horn wrote:
> >> > > try_grab_compound_head() is used to grab a reference to a page from
> >> > > get_user_pages_fast(), which is only protected against concurrent
> >> > > freeing of page tables (via local_irq_save()), but not against
> >> > > concurrent TLB flushes, freeing of data pages, or splitting of compound
> >> > > pages.
> >> [...]
> >> > Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> >>
> >> Thanks!
> >>
> >> [...]
> >> > > @@ -55,8 +72,23 @@ static inline struct page *try_get_compound_head(struct page *page, int refs)
> >> > >       if (WARN_ON_ONCE(page_ref_count(head) < 0))
> >> > >               return NULL;
> >> > >       if (unlikely(!page_cache_add_speculative(head, refs)))
> >> > >               return NULL;
> >> > > +
> >> > > +     /*
> >> > > +      * At this point we have a stable reference to the head page; but it
> >> > > +      * could be that between the compound_head() lookup and the refcount
> >> > > +      * increment, the compound page was split, in which case we'd end up
> >> > > +      * holding a reference on a page that has nothing to do with the page
> >> > > +      * we were given anymore.
> >> > > +      * So now that the head page is stable, recheck that the pages still
> >> > > +      * belong together.
> >> > > +      */
> >> > > +     if (unlikely(compound_head(page) != head)) {
> >> >
> >> > I was just wondering about what all could happen here. Such as: page gets split,
> >> > reallocated into a different-sized compound page, one that still has page pointing
> >> > to head. I think that's OK, because we don't look at or change other huge page
> >> > fields.
> >> >
> >> > But I thought I'd mention the idea in case anyone else has any clever ideas about
> >> > how this simple check might be insufficient here. It seems fine to me, but I
> >> > routinely lack enough imagination about concurrent operations. :)
> >>
> >> Hmmm... I think the scariest aspect here is probably the interaction
> >> with concurrent allocation of a compound page on architectures with
> >> store-store reordering (like ARM). *If* the page allocator handled
> >> compound pages with lockless, non-atomic percpu freelists, I think it
> >> might be possible that the zeroing of tail_page->compound_head in
> >> put_page() could be reordered after the page has been freed,
> >> reallocated and set to refcount 1 again?
> >>
> >> That shouldn't be possible at the moment, but it is still a bit scary.
> >
> > It might be possible after Mel's "mm/page_alloc: Allow high-order
> > pages to be stored on the per-cpu lists" patch
> > (https://patchwork.kernel.org/project/linux-mm/patch/20210611135753.GC30378@techsingularity.net/).
>
> Those would be percpu indeed, but not "lockless, non-atomic", no? They are
> protected by a local_lock.

The local_lock is *not* a lock on non-PREEMPT_RT kernel IIUC. It
disables preempt and IRQ. But preempt disable is no-op on non-preempt
kernel. IRQ disable can guarantee it is atomic context, but I'm not
sure if it is equivalent to "atomic freelists" in Jann's context.

>
> >>
> >>
> >> I think the lockless page cache code also has to deal with somewhat
> >> similar ordering concerns when it uses page_cache_get_speculative(),
> >> e.g. in mapping_get_entry() - first it looks up a page pointer with
> >> xas_load(), and any access to the page later on would be a _dependent
> >> load_, but if the page then gets freed, reallocated, and inserted into
> >> the page cache again before the refcount increment and the re-check
> >> using xas_reload(), then there would be no data dependency from
> >> xas_reload() to the following use of the page...
> >>
> >
>

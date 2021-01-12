Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7715A2F3D8D
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406674AbhALVhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436558AbhALUEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 15:04:46 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF93DC061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 12:04:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b2so3754809edm.3
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 12:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdxtVLMD51rvFAUy0uouYzv2JNuR8PLKzsDJKh3c7Cc=;
        b=CgpDpWy/pkuZnqaYJDLuySEgBXiA4xKvWHC6DDiTgu764C6H2UCvCPUgHrlwGCzNgn
         fUPc1JLbqFUNBeCqrSEzGK8bJsHxrYcGVhvWQ61okYi8XBqIFrRUo/7g7pMkXeEDHvCa
         MyeA+dDYsLk+ftkMn3+9QPWX7bV5ijeBGChWSoAyKPKc9q42zWa9VlQF0vBw0z2xw9f9
         vWDACqEUBquj/+PzQCjr+uwpecPRHxBT/oDEcZt5AzrxJ4HfTHhe46p36xDJ/Bp+lxM0
         /5mQZHjY9h9MRqM4jAEgXFCkH91me6ItJ+CUCFgE+bTMLqtnIHXlIxnl6dDyQksB2VhH
         vsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdxtVLMD51rvFAUy0uouYzv2JNuR8PLKzsDJKh3c7Cc=;
        b=bQiHt7EEXOHyCarx1/HRv2YOV5kC3GIX9OsBbJUMDbuLlYioS54hz39OAIbPZZyJLq
         MzKDRDSEqOcRCAclGMGbz329HffFQYaFxyMlPM1wYnd0QmL2ItT/RiRhyHg5fprLa4OZ
         FC84+rkzaCjSBoLXpsY9gsELbllH4dWmVvJ2tQMMj5uTDEcsqd0RMPeJtRd+s+sQYiEK
         ++PxHseG767XaXfZCIC8wIf8O5G1Df/oi9+Ys3/OSSCGIy/X+V1IV/8GMo7IyjeXZtPW
         dI73ECCG7qVYXw0snqD1DLGU0Iy3t3OCWkY4DMtqu+envwVdsty7+1iGpX/ecDggGWhh
         qhOw==
X-Gm-Message-State: AOAM5316QTcBlZNcTQerBce6oY5+VWBuAukTDL6i/cczFIhsfYuAQvGf
        4q+gr7CqoyutWP2xyTqQPaZr0qFWgFRrs3LUctlEIA==
X-Google-Smtp-Source: ABdhPJx9xG3m3PHJqgK6syqsFY+KpasjAjyzludTeiiipSmlClrjWTgEwzevdI3KyXO0/VPNMVZJDuulLjmGdX6Q/p0=
X-Received: by 2002:aa7:c2d8:: with SMTP id m24mr661543edp.300.1610481844483;
 Tue, 12 Jan 2021 12:04:04 -0800 (PST)
MIME-Version: 1.0
References: <161044407603.1482714.16630477578392768273.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161044409809.1482714.11965583624142790079.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210112095345.GA12534@linux>
In-Reply-To: <20210112095345.GA12534@linux>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 12 Jan 2021 12:03:55 -0800
Message-ID: <CAPcyv4gb3t+QDqYXacgL-5npQ3ieL8XG9PvmgBSjZ5cdr_hF+A@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] mm: Fix page reference leak in soft_offline_page()
To:     Oscar Salvador <osalvador@suse.de>
Cc:     Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        stable <stable@vger.kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 1:54 AM Oscar Salvador <osalvador@suse.de> wrote:
>
> On Tue, Jan 12, 2021 at 01:34:58AM -0800, Dan Williams wrote:
> > The conversion to move pfn_to_online_page() internal to
> > soft_offline_page() missed that the get_user_pages() reference needs to
> > be dropped when pfn_to_online_page() fails.
>
> I would be more specific here wrt. get_user_pages (madvise).
> soft_offline_page gets called from more places besides madvise_*.

Sure.

>
> > When soft_offline_page() is handed a pfn_valid() &&
> > !pfn_to_online_page() pfn the kernel hangs at dax-device shutdown due to
> > a leaked reference.
> >
> > Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> LGTM, thanks for catching this:
>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>
> A nit below.
>
> > ---
> >  mm/memory-failure.c |   20 ++++++++++++++++----
> >  1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 5a38e9eade94..78b173c7190c 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -1885,6 +1885,12 @@ static int soft_offline_free_page(struct page *page)
> >       return rc;
> >  }
> >
> > +static void put_ref_page(struct page *page)
> > +{
> > +     if (page)
> > +             put_page(page);
> > +}
>
> I am not sure this warrants a function.
> I would probably go with "if (ref_page).." in the two corresponding places,
> but not feeling strong here.

I'll take another look, it felt cluttered...

>
> > +
> >  /**
> >   * soft_offline_page - Soft offline a page.
> >   * @pfn: pfn to soft-offline
> > @@ -1910,20 +1916,26 @@ static int soft_offline_free_page(struct page *page)
> >  int soft_offline_page(unsigned long pfn, int flags)
> >  {
> >       int ret;
> > -     struct page *page;
> >       bool try_again = true;
> > +     struct page *page, *ref_page = NULL;
> > +
> > +     WARN_ON_ONCE(!pfn_valid(pfn) && (flags & MF_COUNT_INCREASED));
>
> Did you see any scenario where this could happen? I understand that you are
> adding this because we will leak a reference in case pfn is not valid anymore.
>

I did not, more future proofing / documenting against refactoring that
fails to consider that case.

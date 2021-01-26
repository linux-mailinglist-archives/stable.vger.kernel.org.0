Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D803044E3
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 18:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbhAZRRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbhAZGME (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 01:12:04 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D1C061573
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 22:11:16 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id jx18so1599308pjb.5
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 22:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ofSELr0g41+S/wAw3xUz/6AdS5ttG052FfoGVJVMa5Q=;
        b=bILGxlB47kIhXwRWllAtOsJDXq1D44Np3y2XBbrmDSS0huIuZvwiEMXPTWNx1d5sQK
         I8CMHgjfEPvlrsqswpl3e9Q/61LViVjIu9pWJGjaFv2O7S9UGqOe3fm2q2YIJ+lt5b9e
         98q/TYG+kyTRBNzl/chArtL/7111QjEBH7shEk9Eu1DYwBoK3JDDz4Uu12QMOmZgZ1GN
         3FqaDuRrSiEaHeLiAlv+uP78EjTyqsTunE1svH6sReSPMKyTv1/3kRmQaaskITmAenir
         MdgMILFDGAxPp2EkmKJjIRXEpR45HtXarB9maMuNLcIIRg9F/WG6zgm5moDwmLKIgBYg
         Vj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ofSELr0g41+S/wAw3xUz/6AdS5ttG052FfoGVJVMa5Q=;
        b=guok/GR864S3KTmSMm3H+5DcS9iTVobd+7TYtE1eNDhTsHEXiixXlPZ5EgzcGTsnRF
         MHemJQyhHhazymtRv8O5M9rXrvAtuNi09rAQhvkN258MY15wTJraSwCi4EyIi6bhO0SO
         ZoT0rDOwjkzD3VdySPxP7SJDtyKCPNCRXqQHGRB90qqT/PLVKBTBBASe+t7Do1ZEIZ22
         3RM44rWt6EPFrdcw0nIFoPLX/5Z1CfIDcJHLC7RXxo3tcz53W0F993XPrbbXFIK0ZfRL
         vEauu+yzcnrlNdPK0xvABG4dxuLPwp9+0VNJ3qm73AN1kX8mdPTqJOvYLpI64/d0vz0f
         FetA==
X-Gm-Message-State: AOAM533SMt5krJqjYm+2VN0YSWUOK16zLw5gi0DwrM4YMSOdJVjIKc6/
        CCTVPGHVQCRJ4kbK6qhd1k3IWK2CgQZnpnd6LqxtY8RKQPzrX6cG
X-Google-Smtp-Source: ABdhPJyLCHgfCC70u4HOxxVDs+uHV5Nmsr//xCGybvnz30Ufog35rQHYCZhHYjMe9eYjblkzVR3QBZOZUB+TUHb0W8c=
X-Received: by 2002:a17:90a:3e81:: with SMTP id k1mr4517001pjc.13.1611641476408;
 Mon, 25 Jan 2021 22:11:16 -0800 (PST)
MIME-Version: 1.0
References: <20210126031009.96266-1-songmuchun@bytedance.com> <f0388d4e-c72a-947f-6f12-8ae52d588543@oracle.com>
In-Reply-To: <f0388d4e-c72a-947f-6f12-8ae52d588543@oracle.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 26 Jan 2021 14:10:39 +0800
Message-ID: <CAMZfGtXqOXC8JTt5v-75Uumaj+eLSGn-xo5mnNvmm7ZtBKgboA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] mm: hugetlb: fix missing put_page in gather_surplus_pages()
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 12:31 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> On 1/25/21 7:10 PM, Muchun Song wrote:
> > The VM_BUG_ON_PAGE avoids the generation of any code, even if that
> > expression has side-effects when !CONFIG_DEBUG_VM.
> >
> > Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >  mm/hugetlb.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Thanks for finding and fixing this!  My bad for not noticing when the bug
> was introduced.
>
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index a6bad1f686c5..082ed643020b 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -2047,13 +2047,16 @@ static int gather_surplus_pages(struct hstate *h, long delta)
> >
> >       /* Free the needed pages to the hugetlb pool */
> >       list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> > +             int zeroed;
> > +
> >               if ((--needed) < 0)
> >                       break;
> >               /*
> >                * This page is now managed by the hugetlb allocator and has
> >                * no users -- drop the buddy allocator's reference.
> >                */
> > -             VM_BUG_ON_PAGE(!put_page_testzero(page), page);
> > +             zeroed = put_page_testzero(page);
> > +             VM_BUG_ON_PAGE(!zeroed, page);
> >               enqueue_huge_page(h, page);
>
> I was wondering why this was not causing any problems.  We are putting the
> hugetlb page on the free list with a count of 1.  There is no check in the
> enqueue code.  When we dequeue the page, set_page_refcounted() is used to
> set the count to 1 without looking at the current value.  And, all the other
> VM_DEBUG macros are off so we mostly do not notice the bug.

Yeah. You are right. I also thought about this question.
It is a very hidden bug.

>
> Thanks again,
>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
>
> --
> Mike Kravetz
>
> >       }
> >  free:
> >

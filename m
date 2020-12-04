Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0052CF06E
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 16:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgLDPLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 10:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgLDPLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 10:11:16 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35FBC061A4F
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 07:10:30 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id es6so2875037qvb.7
        for <stable@vger.kernel.org>; Fri, 04 Dec 2020 07:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kBeUn5P5wE5MCbsqxhOqI6oHNmGrXnrLIbqNK49mm0I=;
        b=FMZKxOrWV/Gw3vq3n73axTVe6lyEaokINiMM9qlxoM9F38QY6zzkdEhvyprzTWWyBi
         Meno/+YIx7OOOuYAgj6kt7vNHYaUDObhdq/nEKTSerjT/g4OMEjEQoKsrTyL1dnkomXN
         fE6Rz8mwWmYMzGXzFtHVZLrxa4n0/rni0C+aSsEG6sBvT38CoeBIX05SOV6JUEqLB6/9
         hHPEesYfv6QaxmBtUJY0c4LU28NqcmdzS+HemA9AIsxoUjgoa7pqcTrp40uHszaH1xga
         Eprc+Vy59MW0OaP5kAQdvWpkKF06KKbSLrwcMrwH82Ypht0vovxncPOhHfjMlpKUmSxE
         VbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kBeUn5P5wE5MCbsqxhOqI6oHNmGrXnrLIbqNK49mm0I=;
        b=d/1rhfXHTPCqNNjHAXl+34sv02rRaD2VftsZV7GgfoOEVd35X7fXI6aLwlylOFfQRt
         U4QEgbZwVuVh3TDkW4UJXEz9nr5AsV9rvIxqTz24Twp21nuZ6HkoILUwemIhe9INyeBy
         kMi/sYQ3J66PRqhSJ7DI7pmRH6bvN80BS7sCmDIhTLQa6VWkpW83dFn+ywXiBEtvb3Kz
         UhW3gqJNPRUmO0BImx8Ts0xnFX4pughFeGnpI8SeNTJ4hDqK0/mx7h1hLxHLvrmNi3Hs
         5h52GWu7sMDk6eIR3Rw+70r4e62bO+LVDNGW28r4DGAk5gkkmopi/ZYwaXn5DopR2egq
         ZUcw==
X-Gm-Message-State: AOAM531Xx3tjGA77qLmfpsB54ZH3sERzuk/oHB1QPrq0uymEN2aKFo+z
        yBdFC8Qh8hE6NQyhFI8TCgnB/Q8XmOqWBQ==
X-Google-Smtp-Source: ABdhPJxufNqV7sKpWrPaM1CPV1hhTtTtEsP4V5Ga0AZ4MKMdNca+YZDsulis5sl7uI/XxhICi8LS6Q==
X-Received: by 2002:a0c:bf0f:: with SMTP id m15mr5766682qvi.23.1607094629954;
        Fri, 04 Dec 2020 07:10:29 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id o9sm5206035qte.35.2020.12.04.07.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 07:10:29 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1klCj6-005uXv-6R; Fri, 04 Dec 2020 11:10:28 -0400
Date:   Fri, 4 Dec 2020 11:10:28 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Liu Zixian <liuzixian4@huawei.com>, akpm@linux-foundation.org,
        linmiaohe@huawei.com, louhongxiang@huawei.com, linux-mm@kvack.org,
        hushiyuan@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] fix mmap return value when vma is merged after
 call_mmap()
Message-ID: <20201204151028.GZ5487@ziepe.ca>
References: <20201203085350.22624-1-liuzixian4@huawei.com>
 <d59e9e5a-1d6e-e7dc-21ec-17777fe9f7a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d59e9e5a-1d6e-e7dc-21ec-17777fe9f7a2@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 04, 2020 at 03:11:54PM +0100, David Hildenbrand wrote:
> On 03.12.20 09:53, Liu Zixian wrote:
> > On success, mmap should return the begin address of newly mapped area,
> > but patch "mm: mmap: merge vma after call_mmap() if possible"
> > set vm_start of newly merged vma to return value addr.
> > Users of mmap will get wrong address if vma is merged after call_mmap().
> > We fix this by moving the assignment to addr before merging vma.
> > 
> > Fixes: d70cec898324 ("mm: mmap: merge vma after call_mmap() if possible")
> > Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
> > v2:
> > We want to do "addr = vma->vm_start;" unconditionally,
> > so move assignment to addr before if(unlikely) block.
> >  mm/mmap.c | 26 ++++++++++++--------------
> >  1 file changed, 12 insertions(+), 14 deletions(-)
> > 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index d91ecb00d38c..5c8b4485860d 100644
> > +++ b/mm/mmap.c
> > @@ -1808,6 +1808,17 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
> >  		if (error)
> >  			goto unmap_and_free_vma;
> >  
> > +		/* Can addr have changed??
> > +		 *
> > +		 * Answer: Yes, several device drivers can do it in their
> > +		 *         f_op->mmap method. -DaveM
> > +		 * Bug: If addr is changed, prev, rb_link, rb_parent should
> > +		 *      be updated for vma_link()
> > +		 */
> 
> 
> Why do we tolerate device drivers doing such stuff at all?
> WARN_ON_ONCE() is just as good as BUG_ON() in many environments. If we
> support it, then no warning. If we don't support it, then why tolerate it?

The commit that introduced this seemed pretty clear it is to catch
possibly wrong drivers. I suppose the idea was to give a migration
time where things would "work" and drivers could be fixed. Since it
has now been 8 years it should be either dropped or turned into:

 /* Drivers are not permitted to change vm_start */
 if (WARN_ON(addr != vma->vm_start)) {
     err = EINVAL
     goto unmap_and_free_vma
 }


commit 2897b4d29d9fca82a57b09b8a216a5d604966e4b
Author: Joonsoo Kim <js1304@gmail.com>
Date:   Wed Dec 12 13:51:53 2012 -0800

    mm: WARN_ON_ONCE if f_op->mmap() change vma's start address
    
    During reviewing the source code, I found a comment which mention that
    after f_op->mmap(), vma's start address can be changed.  I didn't verify
    that it is really possible, because there are so many f_op->mmap()
    implementation.  But if there are some mmap() which change vma's start
    address, it is possible error situation, because we already prepare prev
    vma, rb_link and rb_parent and these are related to original address.
    
    So add WARN_ON_ONCE for finding that this situtation really happens.

Jason

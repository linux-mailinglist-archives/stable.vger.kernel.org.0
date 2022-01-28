Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9C749F957
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 13:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiA1MZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 07:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiA1MZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 07:25:45 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0B9C061714;
        Fri, 28 Jan 2022 04:25:45 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id s127so12021137oig.2;
        Fri, 28 Jan 2022 04:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkpPxTgkOSWNuF9DGyEQ5Iu3HAuCNH96jO/vAxRqfQ0=;
        b=A7pNJ6XuH50tIg0Nw5Gdg+JIn0UC0p91lz+rB+D1RijVs0Jxhht4WbJXb0C7T8DYHV
         cgtXBsIqYk3P9Ki5TCh1JyrJiljy/AWD89S+jnfq5/Yoa4Uu1cKc995n2tAsb7ZrapsL
         3Vt9PSNfiWSb5+KM6RL/RWZ88f0uNf9kXBZr8bYWPIawKV/SXBkAXvDCDqAgu82c7iDO
         zge7KYPugNxRfHPV4csvAtETqqNw7TVlupkLLY0zyKz3qWcuSDNEMq4QpZmbKNgKFvYc
         7a1a9AgGMOwu/cGhBXRPBZ8DqoQtcFzguZlNe86JAR52LJD5nLq4WGTG/VO+/R2rpZA8
         GYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkpPxTgkOSWNuF9DGyEQ5Iu3HAuCNH96jO/vAxRqfQ0=;
        b=rzjs2eXBtp8YzLvjvnZJcfssx2fDgyCnBC6xrCkelRJP73/wsYn38NkZvqC+cZ/dJY
         dHDtnqwaaJMGR47iEvsNDcb0CEND+k3pft2K7kvY6qmeEylBEKGra8bu4z7NZUeabmzz
         5/YrjWk7/DkTLdK2evVs6PmDwjPWSgltYRLQdM0A1c+CBZF8FCazUV1arQpOge0sxlq+
         8oL+gpvN3nOBcf6gTLWA3wVE4mw6L8all7zbtXrDSHgExkKcJui/cJsmENGeBT/M/4hF
         zRhUigXMoMVFAevFEMFkZ65N0LmcbJVuDcX5awYAsX1nyAZVDcOojVooexfIZVhRqdEc
         eHGg==
X-Gm-Message-State: AOAM5308kh01yi6IS2d6PTK3BfBJJSKzWAqYdmKArtrdMWfzEL7ttC9N
        Sk9NsYmaPsdK9kwLEn6LFzhMTBMrCpkF+xvoSsY=
X-Google-Smtp-Source: ABdhPJxndR/QG1T25SoLU7nJf7n7EbCuNtEKNY5d8GA37y+rEh+w14Z8eagHst7EsNBDbtcNYjt78bOLIQ0j4lDpSdc=
X-Received: by 2002:aca:2304:: with SMTP id e4mr5417340oie.167.1643372744839;
 Fri, 28 Jan 2022 04:25:44 -0800 (PST)
MIME-Version: 1.0
References: <20220112131552.3329380-1-aisheng.dong@nxp.com>
 <20220112131552.3329380-3-aisheng.dong@nxp.com> <517e1ea1-f826-228b-16a0-da1dc76017cc@redhat.com>
In-Reply-To: <517e1ea1-f826-228b-16a0-da1dc76017cc@redhat.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Fri, 28 Jan 2022 20:20:03 +0800
Message-ID: <CAA+hA=SFCERXZWmxiraq6N044Np+YTO+JgQFyX65AQmCfyrPQw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: cma: try next MAX_ORDER_NR_PAGES during retry
To:     David Hildenbrand <david@redhat.com>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jason.hui.liu@nxp.com, leoyang.li@nxp.com, abel.vesa@nxp.com,
        shawnguo@kernel.org, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, shijie.qin@nxp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 12:33 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 12.01.22 14:15, Dong Aisheng wrote:
> > On an ARMv7 platform with 32M pageblock(MAX_ORDER 14), we observed a
>
> Did you actually intend to talk about pageblocks here (and below)?
>
> I assume you have to be clearer here that you talk about the maximum
> allocation granularity, which is usually bigger than actual pageblock size.
>

I'm talking about the ARM32 case where pageblock_order is equal to MAX_ORDER -1.
/* If huge pages are not used, group by MAX_ORDER_NR_PAGES */
#define pageblock_order         (MAX_ORDER-1)
In order to be clearer, maybe I can add this info into the commit message too.

> > huge number of repeat retries of CMA allocation (1k+) during booting
> > when allocating one page for each of 3 mmc instance probe.
> >
> > This is caused by CMA now supports cocurrent allocation since commit
> > a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock").
> > The pageblock or (MAX_ORDER -1) from which we are trying to allocate
> > memory may have already been acquired and isolated by others.
> > Current cma_alloc() will then retry the next area by the step of
> > bitmap_no + mask + 1 which are very likely within the same isolated range
> > and fail again. So when the pageblock or MAX_ORDER is big (e.g. 8192),
> > keep retrying in a small step become meaningless because it will be known
> > to fail at a huge number of times due to the pageblock has been isolated
> > by others, especially when allocating only one or two pages.
> >
> > Instread of looping in the same pageblock and wasting CPU mips a lot,
> > especially for big pageblock system (e.g. 16M or 32M),
> > we try the next MAX_ORDER_NR_PAGES directly.
> >
> > Doing this way can greatly mitigate the situtation.
> >
> > Below is the original error log during booting:
> > [    2.004804] cma: cma_alloc(cma (ptrval), count 1, align 0)
> > [    2.010318] cma: cma_alloc(cma (ptrval), count 1, align 0)
> > [    2.010776] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> > [    2.010785] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> > [    2.010793] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> > [    2.010800] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> > [    2.010807] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> > [    2.010814] cma: cma_alloc(): memory range at (ptrval) is busy, retrying
> > .... (+1K retries)
> >
> > After fix, the 1200+ reties can be reduced to 0.
> > Another test running 8 VPU decoder in parallel shows that 1500+ retries
> > dropped to ~145.
> >
> > IOW this patch can improve the CMA allocation speed a lot when there're
> > enough CMA memory by reducing retries significantly.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Lecopzer Chen <lecopzer.chen@mediatek.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > CC: stable@vger.kernel.org # 5.11+
> > Fixes: a4efc174b382 ("mm/cma.c: remove redundant cma_mutex lock")
> > Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
> > ---
> > v1->v2:
> >  * change to align with MAX_ORDER_NR_PAGES instead of pageblock_nr_pages
> > ---
> >  mm/cma.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/cma.c b/mm/cma.c
> > index 1c13a729d274..1251f65e2364 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -500,7 +500,9 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
> >               trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
> >                                          count, align);
> >               /* try again with a bit different memory target */
> > -             start = bitmap_no + mask + 1;
> > +             start = ALIGN(bitmap_no + mask + 1,
> > +                           MAX_ORDER_NR_PAGES >> cma->order_per_bit);
>
> Mind giving the reader a hint in the code why we went for
> MAX_ORDER_NR_PAGES?
>

Yes, good suggestion.
I could add one more line of code comments as follows:
"As alloc_contig_range() will isolate all pageblocks within the range
which are aligned
with max_t(MAX_ORDER_NR_PAGES, pageblock_nr_pages),
here we align with MAX_ORDER_NR_PAGES  which is usually bigger
than actual pageblock size"
Does this look ok to you?

> What would happen if the CMA granularity is bigger than
> MAX_ORDER_NR_PAGES? I'd assume no harm done, as we'd try aligning to 0.
>

I think yes.

Regards
Aisheng

> --
> Thanks,
>
> David / dhildenb
>

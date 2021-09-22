Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027244148A1
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 14:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhIVMS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 08:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhIVMS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 08:18:57 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4278DC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 05:17:27 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id x124so4066763oix.9
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 05:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=txaCaZgnU8hF6eiTgv8iBXfE/atHmjvy/RfH6H4YP9c=;
        b=bO0E2a79zNutjl+h2NtJKB+1OxpyUQmx9rg4dg/lTm1zUwyjJnyhuoY5Z583EKRUmf
         y6+PcWETq2urIn8Abz5JQJ0GNpgzgq0diBoPewZxr9fnN3ThGEx18oOEceFq5TJWCZxg
         TAzbKXfFPA7XpI7oKK55eYJX5TbESZMvhfQ9hZ3OAL32J3VQF6TbNDgINQu5qEj36DC2
         xlEvsdI8OvEO7QgtZ+zCdnABkI+2M2Y7A6ZvaExl1tzc2f467nsOukgtAhoNQyKEK7OD
         GvEvi860Ft4b+bTmdlVOdXqZWjuJsd9uDdDblmKRhY5QDi/L70Ip4qLon2CkLvPNPQKa
         ym5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=txaCaZgnU8hF6eiTgv8iBXfE/atHmjvy/RfH6H4YP9c=;
        b=XUR3d2/UCbvC0KhXOkHkA9XnyfmCKZbtATjKgoZ6ZM5wQAWY7gsCRxnVctCMOek35H
         mWA6hM/nnPgZ2dAvl2O5K5gOz1nM+F/kj4sb1NbVXcvFfrola/pr6QB7gwdum3ZTHx4k
         a5fvbzJ8uqCGjVp77NTzdrktBMTmf31eB7BXfIhy7ew70U5HDStzMh8ZdlX0sxLrCH9N
         Z/Kh0K2wegSaIWYtpwfYss8X1po5wJz7fhCn187iTRiO8TTPIJj5a7PQyijn/IHHRAkx
         0nf1sJDIGJbTHrs0kGubeR2BTBbJr1eulKsVCQfYcDSSp6Pyq2JqlhPIzaMM3IlWrvUG
         Efeg==
X-Gm-Message-State: AOAM531gvvjiCpKVVTky5Pr8mtfpKykDpUDejlNY8nd8PNZepyIjbyhx
        KdRW/yZS9pCI4mLmDp9wzDxgcI5yqzBySn/Ja3k=
X-Google-Smtp-Source: ABdhPJxXWrGXKOlvezOVbM/EBc39ASKfXe0zA1rSWoBlJd2sj8zbwnbqEYsgn3IGz00R84yaj4oYRo9nahw8iTsgIe4=
X-Received: by 2002:aca:645:: with SMTP id 66mr7851272oig.145.1632313046630;
 Wed, 22 Sep 2021 05:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210911112115.47202-1-cs.os.kernel@gmail.com>
 <YTyY6ZALBhCm47T6@kroah.com> <CA+1SViD_my-MPyqXcQ2T=zxF8014u6N-n2Fqcbi9BJPfo3KaTA@mail.gmail.com>
 <CA+1SViA9PN_uoykBtjukYGd-09=peWFCB147iSNnUMwtoT7b0w@mail.gmail.com>
In-Reply-To: <CA+1SViA9PN_uoykBtjukYGd-09=peWFCB147iSNnUMwtoT7b0w@mail.gmail.com>
From:   Cheng Chao <cs.os.kernel@gmail.com>
Date:   Wed, 22 Sep 2021 20:17:15 +0800
Message-ID: <CA+1SViDzyAsbQu7S+qKgLR7vS3wmA+MbQWZhV2rzdbLiFnxvsg@mail.gmail.com>
Subject: Re: [PATCH] [PATCH 4.9] staging: android: ion: fix page is NULL
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     labbott@redhat.com, Sumit Semwal <sumit.semwal@linaro.org>,
        arve@android.com, riandrews@android.com,
        devel@driverdev.osuosl.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I notice that v4.9.283 has released, but this patch is not merged.
It's exactly a bug.

On Sat, Sep 11, 2021 at 10:40 PM Cheng Chao <cs.os.kernel@gmail.com> wrote:
>
> the bug has been introduced by the patch:
>    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/staging/android/ion/ion_system_heap.c?h=v4.9.282&id=e7f63771b60e7802c5a9b437c5ab1a8e33a0bb35
>
> On Sat, Sep 11, 2021 at 10:20 PM Cheng Chao <cs.os.kernel@gmail.com> wrote:
> >
> > for longterm v4.4.283, the code has checked if (!page)
> >    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/staging/android/ion/ion_system_heap.c?h=v4.4.283
> >
> >
> > static struct page *alloc_buffer_page(struct ion_system_heap *heap,
> >      struct ion_buffer *buffer,
> >      unsigned long order)
> > {
> > ...
> > if (!cached) {
> > page = ion_page_pool_alloc(pool);
> > } else {
> > ...
> > page = alloc_pages(gfp_flags | __GFP_COMP, order);
> > if (!page)    <---
> >    return NULL; <---
> >
> > ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
> > ...
> > }
> >
> > ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> > for longterm v4.14.246, has no ion_pages_sync_for_device after
> > ion_page_pool_alloc
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/staging/android/ion/ion_system_heap.c?h=v4.14.246
> >
> >
> > static struct page *alloc_buffer_page(struct ion_system_heap *heap,
> >      struct ion_buffer *buffer,
> >      unsigned long order)
> > {
> > ...
> > if (!cached)
> > pool = heap->uncached_pools[order_to_index(order)];
> > else
> > pool = heap->cached_pools[order_to_index(order)];
> >
> > page = ion_page_pool_alloc(pool);
> >
> > return page;
> > }
> >
> > ----------------------------------------------------------------------------------------------------------------------------------------------------------
> > after longterm v4.19.206(include),
> >
> > static struct page *alloc_buffer_page(struct ion_system_heap *heap,
> >      struct ion_buffer *buffer,
> >      unsigned long order)
> > {
> > struct ion_page_pool *pool = heap->pools[order_to_index(order)];
> >
> > return ion_page_pool_alloc(pool);
> > }
> >
> > On Sat, Sep 11, 2021 at 7:54 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Sat, Sep 11, 2021 at 07:21:15PM +0800, Cheng Chao wrote:
> > > > kernel panic is here:
> > > >
> > > > Unable to handle kernel paging request at virtual address b0380000
> > > > pgd = d9d94000
> > > > [b0380000] *pgd=00000000
> > > > Internal error: Oops: 2805 [#1] PREEMPT SMP ARM
> > > > ...
> > > > task: daa2dd00 task.stack: da194000
> > > > PC is at v7_dma_clean_range+0x1c/0x34
> > > > LR is at arm_dma_sync_single_for_device+0x44/0x58
> > > > pc : [<c011aa0c>]    lr : [<c011645c>]    psr: 200f0013
> > > > sp : da195da0  ip : dc1f9000  fp : c1043dc4
> > > > r10: 00000000  r9 : c16f1f58  r8 : 00000001
> > > > r7 : c1621f94  r6 : c0116418  r5 : 00000000  r4 : c011aa58
> > > > r3 : 0000003f  r2 : 00000040  r1 : b0480000  r0 : b0380000
> > > > Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> > > > Control: 10c5383d  Table: 19d9406a  DAC: 00000051
> > > > ...
> > > > [<c011aa0c>] (v7_dma_clean_range) from [<c011645c>] (arm_dma_sync_single_for_device+0x44/0x58)
> > > > [<c011645c>] (arm_dma_sync_single_for_device) from [<c0117088>] (arm_dma_sync_sg_for_device+0x50/0x7c)
> > > > [<c0117088>] (arm_dma_sync_sg_for_device) from [<c0c033c4>] (ion_pages_sync_for_device+0xb0/0xec)
> > > > [<c0c033c4>] (ion_pages_sync_for_device) from [<c0c054ac>] (ion_system_heap_allocate+0x2a0/0x2e0)
> > > > [<c0c054ac>] (ion_system_heap_allocate) from [<c0c02c78>] (ion_alloc+0x12c/0x494)
> > > > [<c0c02c78>] (ion_alloc) from [<c0c03eac>] (ion_ioctl+0x510/0x63c)
> > > > [<c0c03eac>] (ion_ioctl) from [<c027c4b0>] (do_vfs_ioctl+0xa8/0x9b4)
> > > > [<c027c4b0>] (do_vfs_ioctl) from [<c027ce28>] (SyS_ioctl+0x6c/0x7c)
> > > > [<c027ce28>] (SyS_ioctl) from [<c0108a40>] (ret_fast_syscall+0x0/0x48)
> > > > Code: e3a02004 e1a02312 e2423001 e1c00003 (ee070f3a)
> > > > ---[ end trace 89278304932c0e87 ]---
> > > > Kernel panic - not syncing: Fatal exception
> > > >
> > > > Signed-off-by: Cheng Chao <cs.os.kernel@gmail.com>
> > > > ---
> > > >  drivers/staging/android/ion/ion_system_heap.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> > > > index 22c481f2ae4f..2a35b99cf628 100644
> > > > --- a/drivers/staging/android/ion/ion_system_heap.c
> > > > +++ b/drivers/staging/android/ion/ion_system_heap.c
> > > > @@ -75,7 +75,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
> > > >
> > > >       page = ion_page_pool_alloc(pool);
> > > >
> > > > -     if (cached)
> > > > +     if (page && cached)
> > > >               ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
> > > >                                         DMA_BIDIRECTIONAL);
> > > >       return page;
> > > > --
> > > > 2.26.3
> > > >
> > >
> > > Why is this just a 4.9 patch?  Ion didn't get removed until 5.11, so
> > > wouldn't this be an issue for anything 5.10 and older?
> > >
> > > thanks,
> > >
> > > greg k-h

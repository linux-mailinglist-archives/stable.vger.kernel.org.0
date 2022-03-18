Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3116C4DD3AF
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 04:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiCRDpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 23:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiCRDpM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 23:45:12 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4380D197522;
        Thu, 17 Mar 2022 20:43:54 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id p10-20020a056820044a00b00320d7d4af22so8881216oou.4;
        Thu, 17 Mar 2022 20:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ynjx2xasnK94IQoAMCxrHRqvLPi1opghMBMYP4yL6Dg=;
        b=CDWkqsSNir/188WzvASyO6XPoDgnFPxWVof8AUWQKUxpaNMK9VdzXIf9fCnMa42o7a
         EwZ7OL8VXjcbOh4FJFKKcPUCT921WV+vT4uEyVMdurp2oTGcBQDC2vG0F9nF0kkGWZoH
         aKrtO3bqwlRIm/joTFmNQYby4iHxjc7M0SGyXtohTVIzc4yVzAd8+KtPhMwRLrI9ktFh
         GA1aJkRWNLq4sX6trZP6VzwwyTv4Cu+umu59MumiNje5CFdkWVy5ahoRMLhHinqd2vrs
         QhL72BpyVLIN5FdSYg6IXWm+RnMd04wTYYqk0cE84cCtmBmN0AenyYGIM+WMFc+uoAD/
         yATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ynjx2xasnK94IQoAMCxrHRqvLPi1opghMBMYP4yL6Dg=;
        b=xSJACL7vZflZ4MM33EWTgfVmCPFwLqgkk5+sGgueVIcuHeOwqxZgNjVWquYjtFRi6F
         +FnrtU/G4oicxGB8979xO3SVTszkaGgYF7VSg4HOBUUWcqiOKeyMBHvcrDpr6oD1LEtF
         QWAXjNXTh0PXsqWh+fL0r2kSGJv3sNAZIKlOAsn7YVxXc+5zHb+HKZqTDMJdPWa6J3O+
         5O6ja7EG0bjA065GnE+KQ67iqwDQhPPRkaSWuEoWCjZPIM/lIJtRxcTnuvoFLT4LnKX5
         zAX31BvFc2lghp9WOkr216rReDrxlMp4h515gH+SbP3x31kA62sAUuCiUB+nzIHCb/Ag
         I4Kg==
X-Gm-Message-State: AOAM530cCnHozdnbN2B1z4a+iUqWpUsOkP2l1ralaMCTo+lTZmlCt9Ei
        qHJvqa5+tzkijp7wmJcW7BO7RCcQ42mVNtv4O1A=
X-Google-Smtp-Source: ABdhPJxREeoH+3sUFvHGU9oDcEPz/3E3yeiOqa5/ycYyHGvNDWSRtxBIiFS47ZRVUmnXPrYaUi2GwSRTXQwv3i9F5Qk=
X-Received: by 2002:a05:6870:538b:b0:d9:accf:8cf with SMTP id
 h11-20020a056870538b00b000d9accf08cfmr6575135oan.126.1647575033534; Thu, 17
 Mar 2022 20:43:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com> <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
 <CAA+hA=QzDJhFnntKK4nk-SMErk9J_mFPv0b7ZWuC8Ubz0BC+sg@mail.gmail.com> <YjNr+d2Un7F8c2DZ@google.com>
In-Reply-To: <YjNr+d2Un7F8c2DZ@google.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Fri, 18 Mar 2022 11:43:41 +0800
Message-ID: <CAA+hA=SBeCT+XkzNL3p07vC+58AZOTtoiLG=jVK0tX4wNFvrHA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
To:     Minchan Kim <minchan@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawnguo@kernel.org, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, shijie.qin@nxp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 1:12 AM Minchan Kim <minchan@kernel.org> wrote:
>
> On Thu, Mar 17, 2022 at 10:26:42PM +0800, Dong Aisheng wrote:
> > On Thu, Mar 17, 2022 at 6:55 PM David Hildenbrand <david@redhat.com> wrote:
> > >
> > > On 15.03.22 15:45, Dong Aisheng wrote:
> > > > When there're multiple process allocing dma memory in parallel
> > >
> > > s/allocing/allocating/
> > >
> > > > by calling dma_alloc_coherent(), it may fail sometimes as follows:
> > > >
> > > > Error log:
> > > > cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
> > > > cma: number of available pages:
> > > > 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
> > > > 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
> > > > 7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages
> > > >
> > > > When issue happened, we saw there were still 33161 pages (129M) free CMA
> > > > memory and a lot available free slots for 148 pages in CMA bitmap that we
> > > > want to allocate.
>
> Yes, I also have met the problem especially when the multiple threads
> compete cma allocation. Thanks for bringing up the issue.
>
> > > >
> > > > If dumping memory info, we found that there was also ~342M normal memory,
> > > > but only 1352K CMA memory left in buddy system while a lot of pageblocks
> > > > were isolated.
> > >
> > > s/If/When/
> > >
> >
> > Will fix them all, thanks.
> >
> > > >
> > > > Memory info log:
> > > > Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
> > > >           active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
> > > >           unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
> > > >           bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
> > > > Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
> > > >       36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
> > > >       8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> > > >
> > > > The root cause of this issue is that since commit a4efc174b382
> > > > ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> > > > memory allocation. It's possible that the memory range process A trying
> > > > to alloc has already been isolated by the allocation of process B during
> > > > memory migration.
> > > >
> > > > The problem here is that the memory range isolated during one allocation
> > > > by start_isolate_page_range() could be much bigger than the real size we
> > > > want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.
> > > >
> > > > Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
> > > > is big (e.g. 32M with max_order 14) and CMA memory is relatively small
> > > > (e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
> > > > all CMA memory may have already been isolated by other processes when
> > > > one trying to allocate memory using dma_alloc_coherent().
> > > > Since current CMA code will only scan one time of whole available CMA
> > > > memory, then dma_alloc_coherent() may easy fail due to contention with
> > > > other processes.
> > > >
> > > > This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> > > > error in case the target memory range may has been temporarily isolated
> > > > by others and released later.
> > >
> > > But you patch doesn't check for -EBUSY and instead might retry forever,
> > > on any allocation error, no?
> > >
> >
> > My patch seems not need check it because there's no chance to retry the loop
> > in case an non -EBUS error happened earlier.
> >
> > for (;;) {
> >         if (bitmap_no >= bitmap_maxno) {
> >                 retry_the_whole_loop;
> >         }
> >
> >         pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
> >         ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
> >                              GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
> >
> >         if (ret != -EBUSY)
> >                 break;
> > }
> >
> > > I'd really suggest letting alloc_contig_range() return -EAGAIN in case
> > > the isolation failed and handling -EAGAIN only in a special way instead.
> > >
> >
> > Yes, i guess that's another improvement and is applicable.
> >
> > > In addition, we might want to stop once we looped to often I assume.
> > >
> >
> > I wonder if really retried un-reasonably too often, we probably may
> > need figure out
> > what's going on inside alloc_contig_range() and fix it rather than
> > return EBUSY error to
> > users in case there're still a lot of avaiable memories.
> > So currently i didn't add a maximum retry loop outside.
> >
> > Additionaly, for a small CMA system (128M with 32M max_order pages),
> > the retry would
> > be frequently when multiple process allocating memory, it also depends
> > on system running
> > state, so it's hard to define a reasonable and stable maxinum retry count.
>
> IMO, when the CMA see the -EAGAIN, it should put the task into
> cma->wait_queue and then be woken up by other thread which finish
> work of the cma. So it's similar with cma_mutex but we don't need to
> synchronize for !EAGAIN cases and make the cma allocatoin fair.

Okay, that's another approach which is completely different from the
existing one.
Instead of blocking on the CMA memory range which we want to allocate,
the existing code will try the next available memory ranges.
The question is whether we need to change this behavior?
It looks to me both ways have pros and cons.

And for sleeping on -EAGAIN case, do we need an accurate wakeup?
IOW only wakes the sleeper when the exact memory range is released
which means we need create some more complicated code logic
to track different CMA memory range usage.
Otherwise, there will be possible false positive wakeups and the requester may
quickly sleep again.

I'm not sure if it's worth it. Might need to think a bit more.

Regards
Aisheng

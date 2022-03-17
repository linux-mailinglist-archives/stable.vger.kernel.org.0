Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144664DC8BD
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 15:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbiCQO2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 10:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiCQO2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 10:28:12 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C05200358;
        Thu, 17 Mar 2022 07:26:54 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id o106-20020a9d2273000000b005b21f46878cso3612406ota.3;
        Thu, 17 Mar 2022 07:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EAlRCIMWjDXzbxPdC5WTvZAtu9NYR/IsRzswXZ3C8KE=;
        b=ZhGsoMy5/FjhhAjhNmlce5Z7cUCKQd2HTTTU4SPhUOUXwIwLvNQ+KXs0zfhcoGdbkM
         xj4MxmE0ewSYWu/4K8hb3+MekPKajXS7B+FVT3zI5WvbhivDGO4429ZuSnLCxrMs2Csf
         O9nXFCz450zfAO9SGaHqfkKyv33G/YE5bXG7/lFHhjszw4gFMtJfMgjfk/uUzaxBQ5aZ
         JgRP6nQI4PfmY0dVNqhVf2NukGoLu2GI1821wTUlkTry4iZr2LisvuZ6pxIFD1lN4Rop
         MXwxen1AuVURzIhR+bjAo1+gXOkuOqEPF7ef+sYANlfsR8USE0broCnsmXmU2vJRSPel
         9Svg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EAlRCIMWjDXzbxPdC5WTvZAtu9NYR/IsRzswXZ3C8KE=;
        b=EIJiFa2gaTfsZNC0efLm4OgaGgL2VD3lxz2q486Iw/YeKGQ+IAZZR0Wm+0bmYgvS21
         6O1DvAwqj+epeBHiZCpL/2R6r7LkQiPCrPCaZLc2eovcHJBYoj9SlziLEBghvjGZr99Y
         tUXtyE6/7AiwlnviLbwcYYj5DXHVwHGCZmnsMsWUB4aE67xpph+oA0ozKmcaUYe6W+hz
         OV/dJx9FFHV6GldFbrKLq6fNCAZNxCOhJDYJh0Aq+uVrmvFmJiOK4QRSbdjtKB5HeLzQ
         RREi80ZNtueQjA85OMo/HN+GFi/DLduSUbj46cqAV2PWsUkvhuYzGoEfFgbtJ/irIzxO
         MP3A==
X-Gm-Message-State: AOAM533F1QdaQ9xPtOxq8+giny0HXNBSU4HpF6Aqf+7A6ii8UMXko4+j
        XEO80lQiRx0OS1qd+4j5Es9JbRHLVTT8BJuzxAA=
X-Google-Smtp-Source: ABdhPJwrS3+WSRToNLA9GzsUplO0rhWPo2cgeissZTYgTNA/5E4eM/rwlzDisIS0kbJWE364Csg6yqHr/7OCKvXlysw=
X-Received: by 2002:a05:6830:1394:b0:5af:6776:ea37 with SMTP id
 d20-20020a056830139400b005af6776ea37mr1639396otq.80.1647527213923; Thu, 17
 Mar 2022 07:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com> <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
In-Reply-To: <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Thu, 17 Mar 2022 22:26:42 +0800
Message-ID: <CAA+hA=QzDJhFnntKK4nk-SMErk9J_mFPv0b7ZWuC8Ubz0BC+sg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
To:     David Hildenbrand <david@redhat.com>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
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

On Thu, Mar 17, 2022 at 6:55 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 15.03.22 15:45, Dong Aisheng wrote:
> > When there're multiple process allocing dma memory in parallel
>
> s/allocing/allocating/
>
> > by calling dma_alloc_coherent(), it may fail sometimes as follows:
> >
> > Error log:
> > cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
> > cma: number of available pages:
> > 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
> > 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
> > 7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages
> >
> > When issue happened, we saw there were still 33161 pages (129M) free CMA
> > memory and a lot available free slots for 148 pages in CMA bitmap that we
> > want to allocate.
> >
> > If dumping memory info, we found that there was also ~342M normal memory,
> > but only 1352K CMA memory left in buddy system while a lot of pageblocks
> > were isolated.
>
> s/If/When/
>

Will fix them all, thanks.

> >
> > Memory info log:
> > Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
> >           active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
> >           unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
> >           bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
> > Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
> >       36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
> >       8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> >
> > The root cause of this issue is that since commit a4efc174b382
> > ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> > memory allocation. It's possible that the memory range process A trying
> > to alloc has already been isolated by the allocation of process B during
> > memory migration.
> >
> > The problem here is that the memory range isolated during one allocation
> > by start_isolate_page_range() could be much bigger than the real size we
> > want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.
> >
> > Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
> > is big (e.g. 32M with max_order 14) and CMA memory is relatively small
> > (e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
> > all CMA memory may have already been isolated by other processes when
> > one trying to allocate memory using dma_alloc_coherent().
> > Since current CMA code will only scan one time of whole available CMA
> > memory, then dma_alloc_coherent() may easy fail due to contention with
> > other processes.
> >
> > This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> > error in case the target memory range may has been temporarily isolated
> > by others and released later.
>
> But you patch doesn't check for -EBUSY and instead might retry forever,
> on any allocation error, no?
>

My patch seems not need check it because there's no chance to retry the loop
in case an non -EBUS error happened earlier.

for (;;) {
        if (bitmap_no >= bitmap_maxno) {
                retry_the_whole_loop;
        }

        pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
        ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
                             GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));

        if (ret != -EBUSY)
                break;
}

> I'd really suggest letting alloc_contig_range() return -EAGAIN in case
> the isolation failed and handling -EAGAIN only in a special way instead.
>

Yes, i guess that's another improvement and is applicable.

> In addition, we might want to stop once we looped to often I assume.
>

I wonder if really retried un-reasonably too often, we probably may
need figure out
what's going on inside alloc_contig_range() and fix it rather than
return EBUSY error to
users in case there're still a lot of avaiable memories.
So currently i didn't add a maximum retry loop outside.

Additionaly, for a small CMA system (128M with 32M max_order pages),
the retry would
be frequently when multiple process allocating memory, it also depends
on system running
state, so it's hard to define a reasonable and stable maxinum retry count.

Regards
Aisheng

> --
> Thanks,
>
> David / dhildenb
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D53549CB1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347165AbiFMTCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345425AbiFMTBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:01:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27FAA0D31;
        Mon, 13 Jun 2022 09:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65E7F6153B;
        Mon, 13 Jun 2022 16:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1529C3411C;
        Mon, 13 Jun 2022 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655137941;
        bh=/KQ4avZANuW/a1vawyxsqtceAy8vWzHJKM7FSDpEDE0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CRO3rNDWqZhKGr4aQHLjTeuRFW5RSt9ubBvyYxcc/oRg90s1EhUInLtA5NGYH4Yhn
         jcDQYGYqdu6UjHgcgHNaEQt/ZJA0VkzrzUQVbmBsr0rY/ENDsiTs22rr9GaIdCOz1P
         V6VBDg1MkjFGzrjyndssLgJ3toRWzTTo/guQxdBtcWByel19dAdcHB5uQiuOm7r4Df
         Hy3t9H84eQaACkzWaMH/Rps1eNA/XBAUZm5GemUcnXKjgjfIAtpNb0VHc5ShxpDioG
         ioU/mV2o0P0vd5q/lC1svKvhVf14Hyy1ceddYDG8JTCk260OSBHMrFqGDPlNJQEmoB
         FKiTiTeNdWxiQ==
Received: by mail-vs1-f54.google.com with SMTP id f1so6416161vsv.5;
        Mon, 13 Jun 2022 09:32:21 -0700 (PDT)
X-Gm-Message-State: AJIora+em77eO0Z4UJHS9mnw1q7Gm9bmmmkPR7n72Mr9+DjQyNfrQEsP
        UICjOM+chVTAZuzUsxMe7iOOS9LrFakZK09ETNE=
X-Google-Smtp-Source: AGRyM1tfN7ClzqlZh0CySrsdANEe6kYoaXK42AQPb7y+xZBud115bHG6pqdlowvl3n8yP0fu9ar3HNRATklqupla3mQ=
X-Received: by 2002:a05:6102:184:b0:34b:9e95:14cf with SMTP id
 r4-20020a056102018400b0034b9e9514cfmr97455vsq.59.1655137940769; Mon, 13 Jun
 2022 09:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com> <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
In-Reply-To: <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 14 Jun 2022 00:32:09 +0800
X-Gmail-Original-Message-ID: <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
Message-ID: <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the migratetype
To:     Zi Yan <ziy@nvidia.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, huanyi.xj@alibaba-inc.com,
        zjb194813@alibaba-inc.com, tianhu.hh@alibaba-inc.com,
        Hanjun Guo <guohanjun@huawei.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <labbott@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
>
> Hi Xianting,
>
> Thanks for your patch.
>
> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
>
> > Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its m=
igratetype.")
> > added buddy check code. But unfortunately, this fix isn't backported to
> > linux-5.17.y and the former stable branches. The reason is it added wro=
ng
> > fixes message:
> >      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallbackab=
le
> >                          pageblocks with others")
>
> No, the Fixes tag is right. The commit above does need to validate buddy.
I think Xianting is right. The =E2=80=9CFixes:" tag is not accurate and the
page_is_buddy() is necessary here.

This patch could be applied to the early version of the stable tree
(eg: Linux-5.10.y, not the master tree)

>
> > Actually, this issue is involved by commit:
> >      commit d9dddbf55667 ("mm/page_alloc: prevent merging between isola=
ted and other pageblocks")
> >
> > For RISC-V arch, the first 2M is reserved for sbi, so the start PFN is =
512,
> > but it got buddy PFN 0 for PFN 0x2000:
> >      0 =3D 0x2000 ^ (1 << 12)
> > With the illegal buddy PFN 0, it got an illegal buddy page, which cause=
d
> > crash in __get_pfnblock_flags_mask().
>
> It seems that the RISC-V arch reveals a similar bug from d9dddbf55667.
> Basically, this bug will only happen when PFN=3D0x2000 is merging up and
> there are some isolated pageblocks.
Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.

RISC-V's first 2MB RAM could reserve for opensbi, so it would have
riscv_pfn_base=3D512 and mem_map began with 512th PFN when
CONFIG_FLATMEM=3Dy.
(Also, csky has the same issue: a non-zero pfn_base in some scenarios.)

But __find_buddy_pfn algorithm thinks the start address is 0, it could
get 0 pfn or less than the pfn_base value. We need another check to
prevent that.

>
> BTW, what does first reserved 2MB imply? All 4KB pages from first 2MB are
> set to PageReserved?
>
> >
> > With the patch, it can avoid the calling of get_pageblock_migratetype()=
 if
> > it isn't buddy page.
>
> You might miss the __find_buddy_pfn() caller in unset_migratetype_isolate=
()
> from mm/page_isolation.c, if you are talking about linux-5.17.y and forme=
r
> version. There, page_is_buddy() is also not called and is_migrate_isolate=
_page()
> is called, which calls get_pageblock_migratetype() too.
>
> >
> > Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated a=
nd other pageblocks")
> > Cc: stable@vger.kernel.org
> > Reported-by: zjb194813@alibaba-inc.com
> > Reported-by: tianhu.hh@alibaba-inc.com
> > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > ---
> >  mm/page_alloc.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b1caa1c6c887..5b423caa68fd 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page *p=
age,
> >
> >                       buddy_pfn =3D __find_buddy_pfn(pfn, order);
> >                       buddy =3D page + (buddy_pfn - pfn);
> > +
> > +                     if (!page_is_buddy(page, buddy, order))
> > +                             goto done_merging;
> >                       buddy_mt =3D get_pageblock_migratetype(buddy);
> >
> >                       if (migratetype !=3D buddy_mt
> > --
> > 2.17.1
>
> --
> Best Regards,
> Yan, Zi



--=20
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/

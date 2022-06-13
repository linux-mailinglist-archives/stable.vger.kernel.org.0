Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1468F54A2EB
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 01:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiFMXrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 19:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiFMXrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 19:47:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EDA32EF2;
        Mon, 13 Jun 2022 16:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8015B8168D;
        Mon, 13 Jun 2022 23:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A224C341C4;
        Mon, 13 Jun 2022 23:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655164033;
        bh=ZZQG4WkdlLPvu79h3GXoHi484v8G5Ty5aPwNZxbhBbQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MGwXPpqZc/vkhX22aJDu3oivlC/Il2oQ4muNEDo11DHreWbSRnKtIup3VJIWJpMOt
         7RnwyciChi/9oVtNjUI2NgtM7ebfbBZYOMpm3XcqtgcEvPicIm9BMzRa9iSLL0pqLo
         bRJgbRmlAvCIpefnJo4aHvnM7ePiNh+kLupgo3s5oOPiIPmuq/WLxhfDBPfI/efKsK
         K9Zxll6RzV2KfVVn+ezG/0WIE+YZpoWHo/iTTaRNx5QteT/nMntgyXe2C2363tssSO
         IjyGHJvCGpj938g7ehCm5jdUE1+J8jZ5gd0kTXj7h3ZNY2t5hynjBZCdi0e7FtZyoM
         L9UWBambp1Kow==
Received: by mail-vs1-f46.google.com with SMTP id x9so7391385vsg.13;
        Mon, 13 Jun 2022 16:47:13 -0700 (PDT)
X-Gm-Message-State: AJIora+8QokR9jvuJki5moZuEqcQ3XmjOASQMeQj/MdZpCmLTU+5wvOI
        cMEJeWmOag/9l0b08L+QZYyl0xIL7yDMW8XmpYg=
X-Google-Smtp-Source: AGRyM1skuJQAfVrZw2mzL2D+3j5zatrbkCDTKbNDOEEEwoGo3Ub8RdzfU440q0wVUVR7cbP33umAs1B4VpH4mhzpU+0=
X-Received: by 2002:a05:6102:3562:b0:34b:9e99:1bfa with SMTP id
 bh2-20020a056102356200b0034b9e991bfamr759699vsb.51.1655164032340; Mon, 13 Jun
 2022 16:47:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com> <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
In-Reply-To: <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 14 Jun 2022 07:47:00 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
Message-ID: <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the migratetype
To:     Zi Yan <ziy@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
>
> On 13 Jun 2022, at 12:32, Guo Ren wrote:
>
> > On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> Hi Xianting,
> >>
> >> Thanks for your patch.
> >>
> >> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
> >>
> >>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check its=
 migratetype.")
> >>> added buddy check code. But unfortunately, this fix isn't backported =
to
> >>> linux-5.17.y and the former stable branches. The reason is it added w=
rong
> >>> fixes message:
> >>>      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallback=
able
> >>>                          pageblocks with others")
> >>
> >> No, the Fixes tag is right. The commit above does need to validate bud=
dy.
> > I think Xianting is right. The =E2=80=9CFixes:" tag is not accurate and=
 the
> > page_is_buddy() is necessary here.
> >
> > This patch could be applied to the early version of the stable tree
> > (eg: Linux-5.10.y, not the master tree)
>
> This is quite misleading. Commit 787af64d05cd applies does not mean it is
> intended to fix the preexisting bug. Also it does not apply cleanly
> to commit d9dddbf55667, there is a clear indentation mismatch. At best,
> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d9dddb=
f55667.
> There is no way you can apply 787af64d05cd to earlier trees and call it a=
 day.
>
> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and ther=
e is
> a similar bug in d9dddbf55667 that can be fixed in a similar way too. Say=
ing
> the fixes message is wrong just misleads people, making them think there =
is
> no bug in 1dd214b8f21c. We need to be clear about this.
First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The
origin fixes could cover the Linux-5.0.y tree if they give the
accurate commit number and that is the cause we want to point out.

Second, if the patch is for d9dddbf55667 then it could cover any tree
in the stable repo. Actually, we only know Linux-5.10.y has the
problem.

Maybe, Gregkh could help to direct us on how to deal with the issue:
(Fixup a bug which only belongs to the former stable branch.)

>
> Also, you will need to fix the mm/page_isolation.c code too to make this =
patch
> complete, unless you can show that PFN=3D0x1000 is never going to be enco=
untered
> in the mm/page_isolation.c code I mentioned below.
No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it had
pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prevent
buddy_pfn=3D0.
The root cause comes from __find_buddy_pfn():
return page_pfn ^ (1 << order);

When page_pfn is the same as the order size, it will return the
previous buddy not the next. That is the only exception for this
algorithm, right?




In fact, the bug is a very long time to reproduce and is not easy to
debug, so we want to contribute it to the community to prevent other
guys from wasting time. Although there is no new patch at all.

>
> >
> >>
> >>> Actually, this issue is involved by commit:
> >>>      commit d9dddbf55667 ("mm/page_alloc: prevent merging between iso=
lated and other pageblocks")
> >>>
> >>> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN i=
s 512,
> >>> but it got buddy PFN 0 for PFN 0x2000:
> >>>      0 =3D 0x2000 ^ (1 << 12)
> >>> With the illegal buddy PFN 0, it got an illegal buddy page, which cau=
sed
> >>> crash in __get_pfnblock_flags_mask().
> >>
> >> It seems that the RISC-V arch reveals a similar bug from d9dddbf55667.
> >> Basically, this bug will only happen when PFN=3D0x2000 is merging up a=
nd
> >> there are some isolated pageblocks.
> > Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.
> >
> > RISC-V's first 2MB RAM could reserve for opensbi, so it would have
> > riscv_pfn_base=3D512 and mem_map began with 512th PFN when
> > CONFIG_FLATMEM=3Dy.
> > (Also, csky has the same issue: a non-zero pfn_base in some scenarios.)
> >
> > But __find_buddy_pfn algorithm thinks the start address is 0, it could
> > get 0 pfn or less than the pfn_base value. We need another check to
> > prevent that.
> >
> >>
> >> BTW, what does first reserved 2MB imply? All 4KB pages from first 2MB =
are
> >> set to PageReserved?
> >>
> >>>
> >>> With the patch, it can avoid the calling of get_pageblock_migratetype=
() if
> >>> it isn't buddy page.
> >>
> >> You might miss the __find_buddy_pfn() caller in unset_migratetype_isol=
ate()
> >> from mm/page_isolation.c, if you are talking about linux-5.17.y and fo=
rmer
> >> version. There, page_is_buddy() is also not called and is_migrate_isol=
ate_page()
> >> is called, which calls get_pageblock_migratetype() too.
> >>
> >>>
> >>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated=
 and other pageblocks")
> >>> Cc: stable@vger.kernel.org
> >>> Reported-by: zjb194813@alibaba-inc.com
> >>> Reported-by: tianhu.hh@alibaba-inc.com
> >>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> >>> ---
> >>>  mm/page_alloc.c | 3 +++
> >>>  1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>> index b1caa1c6c887..5b423caa68fd 100644
> >>> --- a/mm/page_alloc.c
> >>> +++ b/mm/page_alloc.c
> >>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct page =
*page,
> >>>
> >>>                       buddy_pfn =3D __find_buddy_pfn(pfn, order);
> >>>                       buddy =3D page + (buddy_pfn - pfn);
> >>> +
> >>> +                     if (!page_is_buddy(page, buddy, order))
> >>> +                             goto done_merging;
> >>>                       buddy_mt =3D get_pageblock_migratetype(buddy);
> >>>
> >>>                       if (migratetype !=3D buddy_mt
> >>> --
> >>> 2.17.1
> >>
> >> --
> >> Best Regards,
> >> Yan, Zi
> >
> >
> >
> > --
> > Best Regards
> >  Guo Ren
> >
> > ML: https://lore.kernel.org/linux-csky/
>
> --
> Best Regards,
> Yan, Zi



--=20
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/

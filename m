Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C9D54A397
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 03:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347396AbiFNBUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 21:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiFNBUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 21:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547F6CE20;
        Mon, 13 Jun 2022 18:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC12AB81257;
        Tue, 14 Jun 2022 01:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D2AC3411E;
        Tue, 14 Jun 2022 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655169610;
        bh=nGsmIf2iGVXn6D2m1rZYEXj47zvQzyVE69iE45fMe/o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mpVdK4c0hOts7bV+2S41q01wHwHkJlGq1oSBQddy+6mvXEPr91rusCNIxdxfaO+5M
         +LdMUfWe32LBisU5+Xcu7WsSIJBiR8DZ33af5lIzq1vDwMBYPysx1kE64OJHN5ss89
         v8fdV0xN3P4YBWexTyTrR37G1sggjCnsaPCGJXjYpgqEZt6LDbCoKQLZu5SowhvNNc
         UY9+MlLHWBpwnldXnbqHyMRPI+PumFurThfYukG2ews0ZACTrIVNdKz/JOSpsjpAJX
         knqySK8mQu6DRYjnNX5VpiByi/EMNNAkuGjQ/UdX9cCjOHR3uGSNA31GJp09A4YL1Z
         r9yXBsIwwqhUA==
Received: by mail-vs1-f52.google.com with SMTP id q14so7530119vsr.12;
        Mon, 13 Jun 2022 18:20:10 -0700 (PDT)
X-Gm-Message-State: AJIora+7egNNkg8DTuGNDE6x+3Zj/P98mzg0Y8h1nxqC69xrHw9++N2a
        Qs45Gamgi1/Mfy6d8mSNkF6nOO4HcgeodfVEIxg=
X-Google-Smtp-Source: AGRyM1uQ4wwywJYKaCZxAb6HN5cXESM/yD5C08gLF7kys0e3nnaI6ql0eLDDQE06IDC5MZjeBGtoWi8ArdbngUhV/0I=
X-Received: by 2002:a05:6102:22c2:b0:34b:9163:c6ab with SMTP id
 a2-20020a05610222c200b0034b9163c6abmr1097894vsh.8.1655169609506; Mon, 13 Jun
 2022 18:20:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com> <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com> <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
 <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
In-Reply-To: <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 14 Jun 2022 09:19:58 +0800
X-Gmail-Original-Message-ID: <CAJF2gTT7=WOtp6z5TtmFk79ipeWd2KpPB4aGkqh=vhM=L6SXmQ@mail.gmail.com>
Message-ID: <CAJF2gTT7=WOtp6z5TtmFk79ipeWd2KpPB4aGkqh=vhM=L6SXmQ@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the migratetype
To:     Zi Yan <ziy@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
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

On Tue, Jun 14, 2022 at 8:14 AM Zi Yan <ziy@nvidia.com> wrote:
>
> On 13 Jun 2022, at 19:47, Guo Ren wrote:
>
> > On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 13 Jun 2022, at 12:32, Guo Ren wrote:
> >>
> >>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
> >>>>
> >>>> Hi Xianting,
> >>>>
> >>>> Thanks for your patch.
> >>>>
> >>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
> >>>>
> >>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before check i=
ts migratetype.")
> >>>>> added buddy check code. But unfortunately, this fix isn't backporte=
d to
> >>>>> linux-5.17.y and the former stable branches. The reason is it added=
 wrong
> >>>>> fixes message:
> >>>>>      Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non-fallba=
ckable
> >>>>>                          pageblocks with others")
> >>>>
> >>>> No, the Fixes tag is right. The commit above does need to validate b=
uddy.
> >>> I think Xianting is right. The =E2=80=9CFixes:" tag is not accurate a=
nd the
> >>> page_is_buddy() is necessary here.
> >>>
> >>> This patch could be applied to the early version of the stable tree
> >>> (eg: Linux-5.10.y, not the master tree)
> >>
> >> This is quite misleading. Commit 787af64d05cd applies does not mean it=
 is
> >> intended to fix the preexisting bug. Also it does not apply cleanly
> >> to commit d9dddbf55667, there is a clear indentation mismatch. At best=
,
> >> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixes d9d=
ddbf55667.
> >> There is no way you can apply 787af64d05cd to earlier trees and call i=
t a day.
> >>
> >> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c and t=
here is
> >> a similar bug in d9dddbf55667 that can be fixed in a similar way too. =
Saying
> >> the fixes message is wrong just misleads people, making them think the=
re is
> >> no bug in 1dd214b8f21c. We need to be clear about this.
> > First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. The
> > origin fixes could cover the Linux-5.0.y tree if they give the
> > accurate commit number and that is the cause we want to point out.
>
> Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fixes
> the issue introduced by d9dddbf55667. But my point is that 787af64d05cd
> is not intended to fix d9dddbf55667 and saying it has a wrong fixes
> message is misleading. This is the point I want to make.
>
> >
> > Second, if the patch is for d9dddbf55667 then it could cover any tree
> > in the stable repo. Actually, we only know Linux-5.10.y has the
> > problem.
>
> But it is not and does not apply to d9dddbf55667 cleanly.
>
> >
> > Maybe, Gregkh could help to direct us on how to deal with the issue:
> > (Fixup a bug which only belongs to the former stable branch.)
> >
>
> I think you just need to send this patch without saying =E2=80=9Ccommit
> 787af64d05cd fixes message is wrong=E2=80=9D would be a good start. You a=
lso
> need extra fix to mm/page_isolation.c for kernels between 5.15 and 5.17
> (inclusive). So there will need to be two patches:
>
> 1) your patch to stable tree prior to 5.15 and
>
> 2) your patch with an additional mm/page_isolation.c fix to stable tree
> between 5.15 and 5.17.
>
> >>
> >> Also, you will need to fix the mm/page_isolation.c code too to make th=
is patch
> >> complete, unless you can show that PFN=3D0x1000 is never going to be e=
ncountered
> >> in the mm/page_isolation.c code I mentioned below.
> > No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it had
> > pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prevent
> > buddy_pfn=3D0.
> > The root cause comes from __find_buddy_pfn():
> > return page_pfn ^ (1 << order);
>
> Right. But pfn_valid_within() was removed since 5.15. So your fix is
> required for kernels between 5.15 and 5.17 (inclusive).
>
> >
> > When page_pfn is the same as the order size, it will return the
> > previous buddy not the next. That is the only exception for this
> > algorithm, right?
> >
> >
> >
> >
> > In fact, the bug is a very long time to reproduce and is not easy to
> > debug, so we want to contribute it to the community to prevent other
> > guys from wasting time. Although there is no new patch at all.
>
> Thanks for your reporting and sending out the patch. I really
> appreciate it. We definitely need your inputs. Throughout the email
> thread, I am trying to help you clarify the bug and how to fix it
> properly:
>
> 1. The commit 787af64d05cd does not apply cleanly to commits
> d9dddbf55667, meaning you cannot just cherry-pick that commit to
> fix the issue. That is why we need your patch to fix the issue.
> And saying it has a wrong fixes message in this patch=E2=80=99s git log i=
s
> misleading.
Okay, seems we need to send some patches for the different stable
branches separately.

>
> 2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
> to mm/page_isolation.c is also needed, since pfn_valid_within() was
> removed since 5.15 and the issue can appear during page isolation.
Good point and we would take care of that.

>
> 3. For kernels before 5.15, this patch will apply.
Thx

>
> >
> >>
> >>>
> >>>>
> >>>>> Actually, this issue is involved by commit:
> >>>>>      commit d9dddbf55667 ("mm/page_alloc: prevent merging between i=
solated and other pageblocks")
> >>>>>
> >>>>> For RISC-V arch, the first 2M is reserved for sbi, so the start PFN=
 is 512,
> >>>>> but it got buddy PFN 0 for PFN 0x2000:
> >>>>>      0 =3D 0x2000 ^ (1 << 12)
> >>>>> With the illegal buddy PFN 0, it got an illegal buddy page, which c=
aused
> >>>>> crash in __get_pfnblock_flags_mask().
> >>>>
> >>>> It seems that the RISC-V arch reveals a similar bug from d9dddbf5566=
7.
> >>>> Basically, this bug will only happen when PFN=3D0x2000 is merging up=
 and
> >>>> there are some isolated pageblocks.
> >>> Not PFN=3D0x2000, it's PFN=3D0x1000, I guess.
> >>>
> >>> RISC-V's first 2MB RAM could reserve for opensbi, so it would have
> >>> riscv_pfn_base=3D512 and mem_map began with 512th PFN when
> >>> CONFIG_FLATMEM=3Dy.
> >>> (Also, csky has the same issue: a non-zero pfn_base in some scenarios=
.)
> >>>
> >>> But __find_buddy_pfn algorithm thinks the start address is 0, it coul=
d
> >>> get 0 pfn or less than the pfn_base value. We need another check to
> >>> prevent that.
> >>>
> >>>>
> >>>> BTW, what does first reserved 2MB imply? All 4KB pages from first 2M=
B are
> >>>> set to PageReserved?
> >>>>
> >>>>>
> >>>>> With the patch, it can avoid the calling of get_pageblock_migratety=
pe() if
> >>>>> it isn't buddy page.
> >>>>
> >>>> You might miss the __find_buddy_pfn() caller in unset_migratetype_is=
olate()
> >>>> from mm/page_isolation.c, if you are talking about linux-5.17.y and =
former
> >>>> version. There, page_is_buddy() is also not called and is_migrate_is=
olate_page()
> >>>> is called, which calls get_pageblock_migratetype() too.
> >>>>
> >>>>>
> >>>>> Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolat=
ed and other pageblocks")
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Reported-by: zjb194813@alibaba-inc.com
> >>>>> Reported-by: tianhu.hh@alibaba-inc.com
> >>>>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> >>>>> ---
> >>>>>  mm/page_alloc.c | 3 +++
> >>>>>  1 file changed, 3 insertions(+)
> >>>>>
> >>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>>> index b1caa1c6c887..5b423caa68fd 100644
> >>>>> --- a/mm/page_alloc.c
> >>>>> +++ b/mm/page_alloc.c
> >>>>> @@ -1129,6 +1129,9 @@ static inline void __free_one_page(struct pag=
e *page,
> >>>>>
> >>>>>                       buddy_pfn =3D __find_buddy_pfn(pfn, order);
> >>>>>                       buddy =3D page + (buddy_pfn - pfn);
> >>>>> +
> >>>>> +                     if (!page_is_buddy(page, buddy, order))
> >>>>> +                             goto done_merging;
> >>>>>                       buddy_mt =3D get_pageblock_migratetype(buddy)=
;
> >>>>>
> >>>>>                       if (migratetype !=3D buddy_mt
> >>>>> --
> >>>>> 2.17.1
> >>>>
> >>>> --
> >>>> Best Regards,
> >>>> Yan, Zi
> >>>
> >>>
> >>>
> >>> --
> >>> Best Regards
> >>>  Guo Ren
> >>>
> >>> ML: https://lore.kernel.org/linux-csky/
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

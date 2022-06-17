Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D236154EFA4
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 05:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiFQDRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 23:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiFQDRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 23:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F47720F53;
        Thu, 16 Jun 2022 20:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A3F561D60;
        Fri, 17 Jun 2022 03:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0824C3411C;
        Fri, 17 Jun 2022 03:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655435862;
        bh=8x6liXDdkpB75klnw3/vgwOZ5VjePIJsxbGKq8YeHKs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tYHMzLTAokUl9hFA1zgq7/ie7lmsqJ9skKkgBV8/d/w6t2I5cH7LdSVXDwYsvqiAB
         fzAgMjjSXzGNLBot+a9K80IOStIPRAtEWSnJDUhjWu2DfoXPa1ZO9IcnDyIGSk2eU+
         UUIDGxInywyrEfkUBWvNYsr+8o7HN6SgnA+MckcEvxCGJkzadB+P6Y1rR8Xdsw3wq1
         X8byMqwd+3k1Zt0eaYBWR+C5RT+Jb7x1NX7zE4LYhRA/n6B0J9rYt4gcGoRM+tAsBE
         H1/JxNS0LVUUgZI3b1/8Rcmwc+r1jnJVuf3tJ+W3PQlBOC/nv+59Du8grFcOmUFRiD
         XYBZjDuV8eHiQ==
Received: by mail-vk1-f181.google.com with SMTP id m30so1452516vkf.11;
        Thu, 16 Jun 2022 20:17:42 -0700 (PDT)
X-Gm-Message-State: AJIora+l9UfPCUmljiSXjVPES6Df+pD5pWjC69KW+SFdzGMarsRUEdKj
        RNgtCHY50Xdw+SyPTZLjaWd8b3dv9ciWKoe8Vh0=
X-Google-Smtp-Source: AGRyM1sgjAJTBFXSSpms3qQuIIgaKXWTXxGsnMUvIxnYQDVdP/ISYbTrmH4++uPSUKy+5RLEO+p28tzUWfWpZFHdc3M=
X-Received: by 2002:a1f:b292:0:b0:368:b49d:de17 with SMTP id
 b140-20020a1fb292000000b00368b49dde17mr3688756vkf.10.1655435861713; Thu, 16
 Jun 2022 20:17:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220613131046.3009889-1-xianting.tian@linux.alibaba.com>
 <0262A4FB-5A9B-47D3-8F1A-995509F56279@nvidia.com> <CAJF2gTQGXAubtas4wAzrg298dGQJntu38X48V2OzcK8xZ_vPJg@mail.gmail.com>
 <D667F530-E286-4E75-B7CE-63E120E440C8@nvidia.com> <CAJF2gTSsaaseds=T_y-Ddt5Np2rYhk3ENumzSZDZUSXFwT3u-g@mail.gmail.com>
 <435B45C3-E6A5-43B2-A5A2-318C748691FC@nvidia.com> <b65b9edd-ff3e-aa44-029a-49fa5ba66b47@linux.alibaba.com>
 <18330D9A-F433-4136-A226-F24173293BF3@nvidia.com> <5526fab6-c7e1-bddc-912b-e4d9b2769d4e@linux.alibaba.com>
 <417EC421-DC05-4B35-954B-35DF873A2C40@nvidia.com> <20f49e70-32e0-a141-907c-5f58c543d70b@redhat.com>
In-Reply-To: <20f49e70-32e0-a141-907c-5f58c543d70b@redhat.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 17 Jun 2022 11:17:30 +0800
X-Gmail-Original-Message-ID: <CAJF2gTS+u4RVDM5k8+pKpP6sr1F9zcucaET71MKwNGRKGPzbAg@mail.gmail.com>
Message-ID: <CAJF2gTS+u4RVDM5k8+pKpP6sr1F9zcucaET71MKwNGRKGPzbAg@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: page_alloc: validate buddy before check the migratetype
To:     David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David & Zi Yan


On Thu, Jun 16, 2022 at 11:04 PM David Hildenbrand <david@redhat.com> wrote=
:
>
> On 16.06.22 16:01, Zi Yan wrote:
> > On 15 Jun 2022, at 12:15, Xianting Tian wrote:
> >
> >> =E5=9C=A8 2022/6/15 =E4=B8=8B=E5=8D=889:55, Zi Yan =E5=86=99=E9=81=93:
> >>> On 15 Jun 2022, at 2:47, Xianting Tian wrote:
> >>>
> >>>> =E5=9C=A8 2022/6/14 =E4=B8=8A=E5=8D=888:14, Zi Yan =E5=86=99=E9=81=
=93:
> >>>>> On 13 Jun 2022, at 19:47, Guo Ren wrote:
> >>>>>
> >>>>>> On Tue, Jun 14, 2022 at 3:49 AM Zi Yan <ziy@nvidia.com> wrote:
> >>>>>>> On 13 Jun 2022, at 12:32, Guo Ren wrote:
> >>>>>>>
> >>>>>>>> On Mon, Jun 13, 2022 at 11:23 PM Zi Yan <ziy@nvidia.com> wrote:
> >>>>>>>>> Hi Xianting,
> >>>>>>>>>
> >>>>>>>>> Thanks for your patch.
> >>>>>>>>>
> >>>>>>>>> On 13 Jun 2022, at 9:10, Xianting Tian wrote:
> >>>>>>>>>
> >>>>>>>>>> Commit 787af64d05cd ("mm: page_alloc: validate buddy before ch=
eck its migratetype.")
> >>>>>>>>>> added buddy check code. But unfortunately, this fix isn't back=
ported to
> >>>>>>>>>> linux-5.17.y and the former stable branches. The reason is it =
added wrong
> >>>>>>>>>> fixes message:
> >>>>>>>>>>        Fixes: 1dd214b8f21c ("mm: page_alloc: avoid merging non=
-fallbackable
> >>>>>>>>>>                            pageblocks with others")
> >>>>>>>>> No, the Fixes tag is right. The commit above does need to valid=
ate buddy.
> >>>>>>>> I think Xianting is right. The =E2=80=9CFixes:" tag is not accur=
ate and the
> >>>>>>>> page_is_buddy() is necessary here.
> >>>>>>>>
> >>>>>>>> This patch could be applied to the early version of the stable t=
ree
> >>>>>>>> (eg: Linux-5.10.y, not the master tree)
> >>>>>>> This is quite misleading. Commit 787af64d05cd applies does not me=
an it is
> >>>>>>> intended to fix the preexisting bug. Also it does not apply clean=
ly
> >>>>>>> to commit d9dddbf55667, there is a clear indentation mismatch. At=
 best,
> >>>>>>> you can say the way of 787af64d05cd fixing 1dd214b8f21c also fixe=
s d9dddbf55667.
> >>>>>>> There is no way you can apply 787af64d05cd to earlier trees and c=
all it a day.
> >>>>>>>
> >>>>>>> You can mention 787af64d05cd that it fixes a bug in 1dd214b8f21c =
and there is
> >>>>>>> a similar bug in d9dddbf55667 that can be fixed in a similar way =
too. Saying
> >>>>>>> the fixes message is wrong just misleads people, making them thin=
k there is
> >>>>>>> no bug in 1dd214b8f21c. We need to be clear about this.
> >>>>>> First, d9dddbf55667 is earlier than 1dd214b8f21c in Linus tree. Th=
e
> >>>>>> origin fixes could cover the Linux-5.0.y tree if they give the
> >>>>>> accurate commit number and that is the cause we want to point out.
> >>>>> Yes, I got that d9dddbf55667 is earlier and commit 787af64d05cd fix=
es
> >>>>> the issue introduced by d9dddbf55667. But my point is that 787af64d=
05cd
> >>>>> is not intended to fix d9dddbf55667 and saying it has a wrong fixes
> >>>>> message is misleading. This is the point I want to make.
> >>>>>
> >>>>>> Second, if the patch is for d9dddbf55667 then it could cover any t=
ree
> >>>>>> in the stable repo. Actually, we only know Linux-5.10.y has the
> >>>>>> problem.
> >>>>> But it is not and does not apply to d9dddbf55667 cleanly.
> >>>>>
> >>>>>> Maybe, Gregkh could help to direct us on how to deal with the issu=
e:
> >>>>>> (Fixup a bug which only belongs to the former stable branch.)
> >>>>>>
> >>>>> I think you just need to send this patch without saying =E2=80=9Cco=
mmit
> >>>>> 787af64d05cd fixes message is wrong=E2=80=9D would be a good start.=
 You also
> >>>>> need extra fix to mm/page_isolation.c for kernels between 5.15 and =
5.17
> >>>>> (inclusive). So there will need to be two patches:
> >>>>>
> >>>>> 1) your patch to stable tree prior to 5.15 and
> >>>>>
> >>>>> 2) your patch with an additional mm/page_isolation.c fix to stable =
tree
> >>>>> between 5.15 and 5.17.
> >>>>>
> >>>>>>> Also, you will need to fix the mm/page_isolation.c code too to ma=
ke this patch
> >>>>>>> complete, unless you can show that PFN=3D0x1000 is never going to=
 be encountered
> >>>>>>> in the mm/page_isolation.c code I mentioned below.
> >>>>>> No, we needn't fix mm/page_isolation.c in linux-5.10.y, because it=
 had
> >>>>>> pfn_valid_within(buddy_pfn) check after __find_buddy_pfn() to prev=
ent
> >>>>>> buddy_pfn=3D0.
> >>>>>> The root cause comes from __find_buddy_pfn():
> >>>>>> return page_pfn ^ (1 << order);
> >>>>> Right. But pfn_valid_within() was removed since 5.15. So your fix i=
s
> >>>>> required for kernels between 5.15 and 5.17 (inclusive).
> >>>>>
> >>>>>> When page_pfn is the same as the order size, it will return the
> >>>>>> previous buddy not the next. That is the only exception for this
> >>>>>> algorithm, right?
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> In fact, the bug is a very long time to reproduce and is not easy =
to
> >>>>>> debug, so we want to contribute it to the community to prevent oth=
er
> >>>>>> guys from wasting time. Although there is no new patch at all.
> >>>>> Thanks for your reporting and sending out the patch. I really
> >>>>> appreciate it. We definitely need your inputs. Throughout the email
> >>>>> thread, I am trying to help you clarify the bug and how to fix it
> >>>>> properly:
> >>>>>
> >>>>> 1. The commit 787af64d05cd does not apply cleanly to commits
> >>>>> d9dddbf55667, meaning you cannot just cherry-pick that commit to
> >>>>> fix the issue. That is why we need your patch to fix the issue.
> >>>>> And saying it has a wrong fixes message in this patch=E2=80=99s git=
 log is
> >>>>> misleading.
> >>>>>
> >>>>> 2. For kernels between 5.15 and 5.17 (inclusive), an additional fix
> >>>>> to mm/page_isolation.c is also needed, since pfn_valid_within() was
> >>>>> removed since 5.15 and the issue can appear during page isolation.
> >>>>>
> >>>>> 3. For kernels before 5.15, this patch will apply.
> >>>> Zi Yan, Guo Ren,
> >>>>
> >>>> I think we still need some imporvemnt for MASTER branch, as we discu=
ssed above, we will get an illegal buddy page if buddy_pfn is 0,
> >>>>
> >>>> within page_is_buddy(), it still use the illegal buddy page to do th=
e check. I think in most of cases, page_is_buddy() can return false,  but i=
t still may return true with very low probablity.
> >>> Can you elaborate more on this? What kind of page can lead to page_is=
_buddy()
> >>> returning true? You said it is buddy_pfn is 0, but if the page is res=
erved,
> >>> if (!page_is_guard(buddy) && !PageBuddy(buddy)) should return false.
> >>> Maybe show us the dump_page() that offending page.
> >>>
> >>> Thanks.
> >>
> >> Let=E2=80=98s take the issue we met on RISC-V arch for example,
> >>
> >> pfn_base is 512 as we reserved 2M RAM for opensbi, mem_map's value is =
0xffffffe07e205000, which is the page address of PFN 512.
> >>
> >> __find_buddy_pfn() returned 0 for PFN 0x2000 with order 0xd.
> >> We know PFN 0 is not a valid pfn for buddy system, because 512 is the =
first PFN for buddy system.
> >>
> >> Then it use below code to get buddy page with buddy_pfn 0:
> >> buddy =3D page + (buddy_pfn - pfn);
> >> So buddy page address is:
> >> 0xffffffe07e1fe000 =3D (struct page*)0xffffffe07e26e000 + (0 - 0x2000)
> >>
> >> we can know this buddy page's address is less than mem_map(0xffffffe07=
e1fe000 < 0xffffffe07e205000),
> >> actually 0xffffffe07e1fe000 is not a valid page's address. If we use 0=
xffffffe07e1fe000
> >> as the page's address to extract the value of a member in 'struct page=
', we may get an uncertain value.
> >> That's why I say page_is_buddy() may return true with very low probabl=
ity.
> >>
> >> So I think we need to add the code the verify buddy_pfn in the first p=
lace:
> >>      pfn_valid(buddy_pfn)
> >>
> >
> > +DavidH on how memory section works.
> >
> > This 2MB RAM reservation does not sound right to me. How does it work i=
n sparsemem?
> > RISC-V has SECTION_SIZE_BITS=3D27, i.e., 128MB a section. All pages wit=
hin
> > a section should have their corresponding struct page (mem_map). So in =
this case,
> > the first 2MB pages should have mem_map and can be marked as PageReserv=
ed. As a
> > result, page_is_buddy() will return false.
Actually, we had a patch to fix that, have a look:
https://lore.kernel.org/linux-riscv/20211123015717.542631-2-guoren@kernel.o=
rg/
What do you think of the above patch?

A lot of arch maintainers do not recognize that the buddy system has
an implied limitation that the start of the phy ram address must align
with (1 << MAX_ORDER-1).

>
> Yes. Unless there is a BUG :)
>
> init_unavailable_range() is supposed to initialize the memap of
> unavailable ranges and mark it reserved.
>
> I wonder if we're missing a case in memmap_init(), to also initialize
> holes at the beginning of a section, before RAM (we do handle sections
> in a special way if the end of RAM falls in the middle of a section).
>
> If it's not initialized, it might contain garbage.
>
> --
> Thanks,
>
> David / dhildenb
>


--
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/

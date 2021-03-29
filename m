Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747E534D1C9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhC2Nts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231506AbhC2Ntb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 09:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA7D6193A;
        Mon, 29 Mar 2021 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617025771;
        bh=eWlMxJo0CB8ZN8+tpv24UjmWeH7ZtyFbqegk1ou+9YA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EeYeJ3u9wJ2VakJUX6mWEtNfXOIxQtEEC4PHmLwFfO7d+Jb82AsTkN2Z4GN3ja6IC
         CQ7mIzCIkEgwZvnrwxtg79OXoT6sBFARlLo8vsM1yhNHU06qBFWKFVk3W+jhlp2zuA
         sRWWoMJQ1vtgt+aIAeeANFu2rlx4dsTcbbglTXwrqhIZKMhGJuq2CCr3wPmOAsVjP6
         UuJ/XfVOu9CGb6COTxEgWisRU1PXdL8eC8l9bNR6I0BeTOuPWgj6a39vKc/Ja5sD67
         QDMGSYRzWbYHCF4dWATdko3qXVxMhhwCJgF/aLTPeEXKY493xq+R1NXxUUiywjCYg2
         k8eEegRfYcJtA==
Received: by mail-ot1-f53.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso12319593otq.3;
        Mon, 29 Mar 2021 06:49:31 -0700 (PDT)
X-Gm-Message-State: AOAM530iq+q+PODIU0vl2iiaWoHpQtHUGSN+maoJti00QhH49doQuMw6
        /dc5JV9Ll8hSy/dixcH0VxVdI8g5uobN+EGAhRY=
X-Google-Smtp-Source: ABdhPJztKxV324Sj/LOdmVqcQjFN69+JsLdAibSHWGgZ7BPboqAIxNOsOIGz2Vl5Tx8Q/Tmqc7S8e6pLAIQqbYl2dE8=
X-Received: by 2002:a9d:600a:: with SMTP id h10mr22425019otj.90.1617025770625;
 Mon, 29 Mar 2021 06:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075633.135869143@linuxfoundation.org> <20210329075640.480623043@linuxfoundation.org>
 <CA+G9fYvHsa0TAqPBvHwPhhe_0qt8syEWkGV_GPjOyEOAO9q5Sw@mail.gmail.com>
 <YGGoHdprUT/AscHa@kroah.com> <CAMj1kXEwMSbS1LC7sPSjSifLF8jYVyGcHvvkf9nfrf-fwo4d9w@mail.gmail.com>
 <YGHZRHgNJkFH+Eiq@kroah.com>
In-Reply-To: <YGHZRHgNJkFH+Eiq@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 29 Mar 2021 15:49:19 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFERgODEEmK-ohSErV5At6SJGKU1a6=9ZfeBnFE0ZJ-AA@mail.gmail.com>
Message-ID: <CAMj1kXFERgODEEmK-ohSErV5At6SJGKU1a6=9ZfeBnFE0ZJ-AA@mail.gmail.com>
Subject: Re: [PATCH 5.11 225/254] arm64/mm: define arch_get_mappable_range()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(+ Pavel)

On Mon, 29 Mar 2021 at 15:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 29, 2021 at 03:08:52PM +0200, Ard Biesheuvel wrote:
> > On Mon, 29 Mar 2021 at 12:12, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Mon, Mar 29, 2021 at 03:05:25PM +0530, Naresh Kamboju wrote:
> > > > On Mon, 29 Mar 2021 at 14:10, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > >
> > > > > [ Upstream commit 03aaf83fba6e5af08b5dd174c72edee9b7d9ed9b ]
> > > > >
> > > > > This overrides arch_get_mappable_range() on arm64 platform which will be
> > > > > used with recently added generic framework.  It drops
> > > > > inside_linear_region() and subsequent check in arch_add_memory() which are
> > > > > no longer required.  It also adds a VM_BUG_ON() check that would ensure
> > > > > that mhp_range_allowed() has already been called.
> > > > >
> > > > > Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
> > > > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > > Cc: Will Deacon <will@kernel.org>
> > > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > > Cc: Heiko Carstens <hca@linux.ibm.com>
> > > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > > Cc: Michal Hocko <mhocko@kernel.org>
> > > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > > Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > > > > Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > > > Cc: teawater <teawaterz@linux.alibaba.com>
> > > > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > > > Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  arch/arm64/mm/mmu.c | 15 +++++++--------
> > > > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > > > index 6f0648777d34..92b3be127796 100644
> > > > > --- a/arch/arm64/mm/mmu.c
> > > > > +++ b/arch/arm64/mm/mmu.c
> > > > > @@ -1443,16 +1443,19 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
> > > > >         free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
> > > > >  }
> > > > >
> > > > > -static bool inside_linear_region(u64 start, u64 size)
> > > > > +struct range arch_get_mappable_range(void)
> > > > >  {
> > > > > +       struct range mhp_range;
> > > > > +
> > > > >         /*
> > > > >          * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
> > > > >          * accommodating both its ends but excluding PAGE_END. Max physical
> > > > >          * range which can be mapped inside this linear mapping range, must
> > > > >          * also be derived from its end points.
> > > > >          */
> > > > > -       return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
> > > > > -              (start + size - 1) <= __pa(PAGE_END - 1);
> > > > > +       mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
> > > > > +       mhp_range.end =  __pa(PAGE_END - 1);
> > > > > +       return mhp_range;
> > > > >  }
> > > > >
> > > > >  int arch_add_memory(int nid, u64 start, u64 size,
> > > > > @@ -1460,11 +1463,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
> > > > >  {
> > > > >         int ret, flags = 0;
> > > > >
> > > > > -       if (!inside_linear_region(start, size)) {
> > > > > -               pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
> > > > > -               return -EINVAL;
> > > > > -       }
> > > > > -
> > > > > +       VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > > >         if (rodata_full || debug_pagealloc_enabled())
> > > > >                 flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
> > > >
> > > > The stable rc 5.10 and 5.11 builds failed for arm64 architecture
> > > > due to below warnings / errors,
> > > >
> > > > > Anshuman Khandual <anshuman.khandual@arm.com>
> > > > >     arm64/mm: define arch_get_mappable_range()
> > > >
> > > >
> > > >   arch/arm64/mm/mmu.c: In function 'arch_add_memory':
> > > >   arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
> > > > 'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
> > > > [-Werror=implicit-function-declaration]
> > > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > >                ^
> > > >   include/linux/build_bug.h:30:63: note: in definition of macro
> > > > 'BUILD_BUG_ON_INVALID'
> > > >    #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
> > > >                                                                  ^
> > > >   arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
> > > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > >     ^~~~~~~~~
> > > >
> > > > Build link,
> > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
> > > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull
> > >
> > > thanks, will go drop this, and the patch that was after it in the
> > > series, from both trees and will push out a -rc2.
> > >
> >
> > Why were these picked up in the first place? I don't see any fixes or
> > cc:stable tags, and the commit log clearly describes that the change
> > is preparatory work for enabling arm64 support into a recently
> > introduced generic framework.
>
> This was needed for a follow-on patch in the series that fixed an issue.
> Specifically it was commit ee7febce0519 ("arm64: mm: correct the inside
> linear map range during hotplug check")
>

Yeah, but during the discussion of that patch [0], we pointed out that
it needed to be rebased because of these new changes. So trying to
backport this rebased version is obviously not the right approach:
Pavel's original patch would be much more suitable for that.

Could we have annotated this patch in a better way to make this more obvious?


[0] https://lore.kernel.org/linux-arm-kernel/20210215192237.362706-2-pasha.tatashin@soleen.com/

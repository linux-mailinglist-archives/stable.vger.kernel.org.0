Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BB734D0FD
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhC2NJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231219AbhC2NJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 09:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EFD861938;
        Mon, 29 Mar 2021 13:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617023344;
        bh=0mW1Eac3+iXhHdHANgj2Bo8GzVviuR9JKoGTVZo/2WU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pKGRzpjtmgHZlWXjJZJFMQ0mEdk9Svhq6uglGW056CFeVUlGZ9UH9IVcG/KmbJnVi
         qiq5j3lrTKJQ21uk/nocfxb89lEh5jGQ2J4DDCwFB70B5gY69ndF+gLLZNv0d7GHO9
         JYVym3JgR06Ug4sVKa0C5q4qsG9G7Oxxf7bRFn2hC7HpJey+Rd/ZW5Yx6hIQdxmS6R
         dqeNauOx18BXfi7/ioWPI1697/UpfwmBYmshHE0CoB3nu1/ZjgmfbcJv5kSSGluygv
         uyOrKGcPpa8ItioTQ6743pq2ykPvDbfU+/PdBr+6LFEPtUfM8P4G7BhUsEvniugbzy
         mH1jVU3iH7sRQ==
Received: by mail-ot1-f47.google.com with SMTP id 68-20020a9d0f4a0000b02901b663e6258dso12145219ott.13;
        Mon, 29 Mar 2021 06:09:04 -0700 (PDT)
X-Gm-Message-State: AOAM532Lw1nsQH5qm1sXeM/iCEA1sRvRtZJH880KTb8b/HU0bDUbfBs9
        N9VlcXy0jJ4VHNIaKdIfB6WBD1/rL065ABF+VKs=
X-Google-Smtp-Source: ABdhPJwiDMXllU6nOARguspc345TOcgmm9MngH2fqOEhobZvVcPWGU1AW6rYHtU1Lp6iByYC2hr1mUz4pP9wEJZggYE=
X-Received: by 2002:a9d:7ccf:: with SMTP id r15mr11790905otn.108.1617023343628;
 Mon, 29 Mar 2021 06:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075633.135869143@linuxfoundation.org> <20210329075640.480623043@linuxfoundation.org>
 <CA+G9fYvHsa0TAqPBvHwPhhe_0qt8syEWkGV_GPjOyEOAO9q5Sw@mail.gmail.com> <YGGoHdprUT/AscHa@kroah.com>
In-Reply-To: <YGGoHdprUT/AscHa@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 29 Mar 2021 15:08:52 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEwMSbS1LC7sPSjSifLF8jYVyGcHvvkf9nfrf-fwo4d9w@mail.gmail.com>
Message-ID: <CAMj1kXEwMSbS1LC7sPSjSifLF8jYVyGcHvvkf9nfrf-fwo4d9w@mail.gmail.com>
Subject: Re: [PATCH 5.11 225/254] arm64/mm: define arch_get_mappable_range()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

On Mon, 29 Mar 2021 at 12:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Mar 29, 2021 at 03:05:25PM +0530, Naresh Kamboju wrote:
> > On Mon, 29 Mar 2021 at 14:10, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > >
> > > [ Upstream commit 03aaf83fba6e5af08b5dd174c72edee9b7d9ed9b ]
> > >
> > > This overrides arch_get_mappable_range() on arm64 platform which will be
> > > used with recently added generic framework.  It drops
> > > inside_linear_region() and subsequent check in arch_add_memory() which are
> > > no longer required.  It also adds a VM_BUG_ON() check that would ensure
> > > that mhp_range_allowed() has already been called.
> > >
> > > Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
> > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Heiko Carstens <hca@linux.ibm.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > Cc: Michal Hocko <mhocko@kernel.org>
> > > Cc: Oscar Salvador <osalvador@suse.de>
> > > Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > > Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > Cc: teawater <teawaterz@linux.alibaba.com>
> > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  arch/arm64/mm/mmu.c | 15 +++++++--------
> > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > index 6f0648777d34..92b3be127796 100644
> > > --- a/arch/arm64/mm/mmu.c
> > > +++ b/arch/arm64/mm/mmu.c
> > > @@ -1443,16 +1443,19 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
> > >         free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
> > >  }
> > >
> > > -static bool inside_linear_region(u64 start, u64 size)
> > > +struct range arch_get_mappable_range(void)
> > >  {
> > > +       struct range mhp_range;
> > > +
> > >         /*
> > >          * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
> > >          * accommodating both its ends but excluding PAGE_END. Max physical
> > >          * range which can be mapped inside this linear mapping range, must
> > >          * also be derived from its end points.
> > >          */
> > > -       return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
> > > -              (start + size - 1) <= __pa(PAGE_END - 1);
> > > +       mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
> > > +       mhp_range.end =  __pa(PAGE_END - 1);
> > > +       return mhp_range;
> > >  }
> > >
> > >  int arch_add_memory(int nid, u64 start, u64 size,
> > > @@ -1460,11 +1463,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
> > >  {
> > >         int ret, flags = 0;
> > >
> > > -       if (!inside_linear_region(start, size)) {
> > > -               pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
> > > -               return -EINVAL;
> > > -       }
> > > -
> > > +       VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > >         if (rodata_full || debug_pagealloc_enabled())
> > >                 flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
> >
> > The stable rc 5.10 and 5.11 builds failed for arm64 architecture
> > due to below warnings / errors,
> >
> > > Anshuman Khandual <anshuman.khandual@arm.com>
> > >     arm64/mm: define arch_get_mappable_range()
> >
> >
> >   arch/arm64/mm/mmu.c: In function 'arch_add_memory':
> >   arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
> > 'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
> > [-Werror=implicit-function-declaration]
> >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> >                ^
> >   include/linux/build_bug.h:30:63: note: in definition of macro
> > 'BUILD_BUG_ON_INVALID'
> >    #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
> >                                                                  ^
> >   arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
> >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> >     ^~~~~~~~~
> >
> > Build link,
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull
>
> thanks, will go drop this, and the patch that was after it in the
> series, from both trees and will push out a -rc2.
>

Why were these picked up in the first place? I don't see any fixes or
cc:stable tags, and the commit log clearly describes that the change
is preparatory work for enabling arm64 support into a recently
introduced generic framework.

-- 
Ard.

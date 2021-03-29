Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA2634CF30
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 13:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhC2LgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 07:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhC2Lfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 07:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8031561585;
        Mon, 29 Mar 2021 11:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617017736;
        bh=RyW3IR4mCZ4a1x3PuFB/Yem1Vg3KI5Vac0VJnYicrcY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnuuR9ps/wfdaziIYfDV66/p/SpzIJt7dpq9uAChS48I92kKbj3VO8NTQsZl1mkrM
         d+aZhENCQXOTtioj2o1/8HVjNv+8YxiRZxtJV1WbRME1h0/APeDEfdvH8JfNHGoMIp
         n5EBGTwFJxPcbAagb4J6zVrnspRAv8s4JGMlxk1Q=
Date:   Mon, 29 Mar 2021 13:35:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
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
Subject: Re: [PATCH 5.11 225/254] arm64/mm: define arch_get_mappable_range()
Message-ID: <YGG7hTYP2gGwuBCJ@kroah.com>
References: <20210329075633.135869143@linuxfoundation.org>
 <20210329075640.480623043@linuxfoundation.org>
 <CA+G9fYvHsa0TAqPBvHwPhhe_0qt8syEWkGV_GPjOyEOAO9q5Sw@mail.gmail.com>
 <YGGoHdprUT/AscHa@kroah.com>
 <CADYN=9K-rV+efCDBoF4a_rKbg77d1o-uWH1oTgjZ+v-4MUjo5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9K-rV+efCDBoF4a_rKbg77d1o-uWH1oTgjZ+v-4MUjo5Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 01:06:47PM +0200, Anders Roxell wrote:
> On Mon, 29 Mar 2021 at 12:13, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Mar 29, 2021 at 03:05:25PM +0530, Naresh Kamboju wrote:
> > > On Mon, 29 Mar 2021 at 14:10, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > > >
> > > > [ Upstream commit 03aaf83fba6e5af08b5dd174c72edee9b7d9ed9b ]
> > > >
> > > > This overrides arch_get_mappable_range() on arm64 platform which will be
> > > > used with recently added generic framework.  It drops
> > > > inside_linear_region() and subsequent check in arch_add_memory() which are
> > > > no longer required.  It also adds a VM_BUG_ON() check that would ensure
> > > > that mhp_range_allowed() has already been called.
> > > >
> > > > Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
> > > > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > Cc: Will Deacon <will@kernel.org>
> > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > Cc: Heiko Carstens <hca@linux.ibm.com>
> > > > Cc: Jason Wang <jasowang@redhat.com>
> > > > Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > > > Cc: Michal Hocko <mhocko@kernel.org>
> > > > Cc: Oscar Salvador <osalvador@suse.de>
> > > > Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> > > > Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> > > > Cc: teawater <teawaterz@linux.alibaba.com>
> > > > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > > > Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  arch/arm64/mm/mmu.c | 15 +++++++--------
> > > >  1 file changed, 7 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > > > index 6f0648777d34..92b3be127796 100644
> > > > --- a/arch/arm64/mm/mmu.c
> > > > +++ b/arch/arm64/mm/mmu.c
> > > > @@ -1443,16 +1443,19 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
> > > >         free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
> > > >  }
> > > >
> > > > -static bool inside_linear_region(u64 start, u64 size)
> > > > +struct range arch_get_mappable_range(void)
> > > >  {
> > > > +       struct range mhp_range;
> > > > +
> > > >         /*
> > > >          * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
> > > >          * accommodating both its ends but excluding PAGE_END. Max physical
> > > >          * range which can be mapped inside this linear mapping range, must
> > > >          * also be derived from its end points.
> > > >          */
> > > > -       return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
> > > > -              (start + size - 1) <= __pa(PAGE_END - 1);
> > > > +       mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
> > > > +       mhp_range.end =  __pa(PAGE_END - 1);
> > > > +       return mhp_range;
> > > >  }
> > > >
> > > >  int arch_add_memory(int nid, u64 start, u64 size,
> > > > @@ -1460,11 +1463,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
> > > >  {
> > > >         int ret, flags = 0;
> > > >
> > > > -       if (!inside_linear_region(start, size)) {
> > > > -               pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
> > > > -               return -EINVAL;
> > > > -       }
> > > > -
> > > > +       VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > > >         if (rodata_full || debug_pagealloc_enabled())
> > > >                 flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
> > >
> > > The stable rc 5.10 and 5.11 builds failed for arm64 architecture
> > > due to below warnings / errors,
> > >
> > > > Anshuman Khandual <anshuman.khandual@arm.com>
> > > >     arm64/mm: define arch_get_mappable_range()
> > >
> > >
> > >   arch/arm64/mm/mmu.c: In function 'arch_add_memory':
> > >   arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
> > > 'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
> > > [-Werror=implicit-function-declaration]
> > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > >                ^
> > >   include/linux/build_bug.h:30:63: note: in definition of macro
> > > 'BUILD_BUG_ON_INVALID'
> > >    #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
> > >                                                                  ^
> > >   arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
> > >     VM_BUG_ON(!mhp_range_allowed(start, size, true));
> > >     ^~~~~~~~~
> > >
> > > Build link,
> > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
> > > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull
> >
> > thanks, will go drop this, and the patch that was after it in the
> > series, from both trees and will push out a -rc2.
> >
> > Note, I used tuxbuild before doing this release, and it does not show
> > this error in the arm64 defconfigs. What config did you use to trigger
> > this?
> 
> We have a build with CONFIG_MEMORY_HOTPLUG=y enabled too.
> 
> This is a way to reproduce it locally:
> tuxmake --runtime podman --target-arch arm64 --toolchain gcc --kconfig
> defconfig --kconfig-add CONFIG_MEMORY_HOTPLUG=y

Ah, that wasn't expected, but makes sense, thanks.

Does 'allmodconfig' also trigger that?  Maybe I'll go add that to my
build tests for arm64...

thanks,

greg k-h

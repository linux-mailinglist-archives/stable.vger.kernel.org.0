Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6758D1A7DF2
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732019AbgDNN2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:28:15 -0400
Received: from foss.arm.com ([217.140.110.172]:55996 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732002AbgDNN2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 09:28:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 829A930E;
        Tue, 14 Apr 2020 06:27:55 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.30.4])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 467793F73D;
        Tue, 14 Apr 2020 06:27:54 -0700 (PDT)
Date:   Tue, 14 Apr 2020 14:27:51 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: vdso: don't free unallocated pages
Message-ID: <20200414132751.GF2486@C02TD0UTHF1T.local>
References: <20200414104252.16061-1-mark.rutland@arm.com>
 <20200414104252.16061-2-mark.rutland@arm.com>
 <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5596228-2685-abb3-5ab1-9519759e1f7a@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 01:50:38PM +0100, Vincenzo Frascino wrote:
> Hi Mark,
> 
> On 4/14/20 11:42 AM, Mark Rutland wrote:
> > The aarch32_vdso_pages[] array never has entries allocated in the C_VVAR
> > or C_VDSO slots, and as the array is zero initialized these contain
> > NULL.
> > 
> > However in __aarch32_alloc_vdso_pages() when
> > aarch32_alloc_kuser_vdso_page() fails we attempt to free the page whose
> > struct page is at NULL, which is obviously nonsensical.
> 
> Could you please explain why do you think that free(NULL) is "nonsensical"? 

Regardless of the below, can you please explain why it is sensical? I'm
struggling to follow your argument here.

* It serves no legitimate purpose. One cannot free a page without a
  corresponding struct page.

* It is redundant. Removing the code does not detract from the utility
  of the remainging code, or make that remaing code more complex.

* It hinders comprehension of the code. When a developer sees the
  free_page() they will assume that the page was allocated somewhere,
  but there is no corresponding allocation as the pointers are never
  assigned to. Even if the code in question is not harmful to the
  functional correctness of the code, it is an unnecessary burden to
  developers.

* page_to_virt(NULL) does not have a well-defined result, and
  page_to_virt() should only be called for a valid struct page pointer.
  The result of page_to_virt(NULL) may not be a pointer into the linear
  map as would be expected.

* free_page(x) calls free_pages(x, 0), which checks virt_addr_valid(x).
  As page_to_virt(NULL) is not a valid linear map address, this can
  trigger a VM_BUG_ON()

* Even if page_to_virt(virt_to_page(NULL)) is NULL, within
  __free_pages(NULL, 0) we'd call put_page_testzero(NULL) which will
  fault when dereferencing NULL to get at the fields in struct page.
  Likewise for everything under free_the_page(NULL, 0).

> And if this is causing a bug (according to the cover-letter), could
> you please provide a stack-trace?

I haven't triggered it, as I found it by inspection. As above the
behaviour is clearly erroneous and can trigger several failures to
occur.

Note that this only happens if aarch32_alloc_kuser_vdso_page() fails in
the boot path, which is unlikely.

Thanks,
Mark.

> > This patch removes the erroneous page freeing.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  arch/arm64/kernel/vdso.c | 13 +------------
> >  1 file changed, 1 insertion(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> > index 354b11e27c07..033a48f30dbb 100644
> > --- a/arch/arm64/kernel/vdso.c
> > +++ b/arch/arm64/kernel/vdso.c
> > @@ -260,18 +260,7 @@ static int __aarch32_alloc_vdso_pages(void)
> >  	if (ret)
> >  		return ret;
> >  
> > -	ret = aarch32_alloc_kuser_vdso_page();
> > -	if (ret) {
> > -		unsigned long c_vvar =
> > -			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VVAR]);
> > -		unsigned long c_vdso =
> > -			(unsigned long)page_to_virt(aarch32_vdso_pages[C_VDSO]);
> > -
> > -		free_page(c_vvar);
> > -		free_page(c_vdso);
> > -	}
> > -
> > -	return ret;
> > +	return aarch32_alloc_kuser_vdso_page();
> >  }
> >  #else
> >  static int __aarch32_alloc_vdso_pages(void)
> > 
> 
> -- 
> Regards,
> Vincenzo

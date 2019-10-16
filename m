Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11CF4D9457
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390685AbfJPOwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 10:52:43 -0400
Received: from foss.arm.com ([217.140.110.172]:42030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfJPOwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 10:52:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95525142F;
        Wed, 16 Oct 2019 07:52:42 -0700 (PDT)
Received: from arrakis.emea.arm.com (unknown [10.1.196.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F26FC3F68E;
        Wed, 16 Oct 2019 07:52:40 -0700 (PDT)
Date:   Wed, 16 Oct 2019 15:52:38 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <Vincenzo.Frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Subject: Re: ? FAIL: Test report for kernel 5.4.0-rc2-d6c2c23.cki
 (stable-next)
Message-ID: <20191016145238.GL49619@arrakis.emea.arm.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
 <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com>
 <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
 <20191016042933.bemrrurjbghuiw73@willie-the-truck>
 <20191016144422.GZ27757@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016144422.GZ27757@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 03:44:25PM +0100, Dave P Martin wrote:
> On Wed, Oct 16, 2019 at 05:29:33AM +0100, Will Deacon wrote:
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index b61b50bf68b1..c23c47360664 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -215,12 +215,18 @@ static inline unsigned long kaslr_offset(void)
> >   * up with a tagged userland pointer. Clear the tag to get a sane pointer to
> >   * pass on to access_ok(), for instance.
> >   */
> > -#define untagged_addr(addr)	\
> > +#define __untagged_addr(addr)	\
> >  	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
> >  
> > +#define untagged_addr(addr)	({					\
> 
> Having the same informal name ("untagged") for two different address
> representations seems like a recipe for confusion.  Can we rename one of
> them?  (Say, untagged_address_if_user()?)

I agree it's confusing. We can rename the __* one but the other is
spread around the kernel (it can be done, though as a subsequent
exercise; untagged_uaddr?).

> > +	__addr &= __untagged_addr(__addr);				\
> > +	(__force __typeof__(addr))__addr;				\
> > +})
> 
> Is there any reason why we can't just have
> 
> #define untagged_addr ((__force __typeof__(addr))(	\
> 	(__force u64)(addr) & GENMASK_ULL(63, 56)))

I guess you meant ~GENMASK_ULL(63,56) or GENMASK_ULL(55,0).

This changes the overflow case for mlock() which would return -ENOMEM
instead of -EINVAL (not sure we have a test for it though). Does it
matter?

-- 
Catalin

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A623C70F
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 11:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfFKJML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 05:12:11 -0400
Received: from elvis.franken.de ([193.175.24.41]:54846 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727642AbfFKJML (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 05:12:11 -0400
X-Greylist: delayed 2723 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2019 05:12:10 EDT
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1hac79-0005BB-00; Tue, 11 Jun 2019 10:26:43 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 95458C0408; Tue, 11 Jun 2019 10:19:47 +0200 (CEST)
Date:   Tue, 11 Jun 2019 10:19:47 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Paul Burton <paul.burton@mips.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Julien Cristau <jcristau@debian.org>,
        Yunqiang Su <ysu@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
Message-ID: <20190611081947.GA11513@alpha.franken.de>
References: <20190528170444.1557-1-paul.burton@mips.com>
 <9e5c6f1a-b4a9-dbae-6314-aeb08f31c8aa@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e5c6f1a-b4a9-dbae-6314-aeb08f31c8aa@hauke-m.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 01:41:21AM +0200, Hauke Mehrtens wrote:
> On 5/28/19 7:05 PM, Paul Burton wrote:
> > ---
> > 
> >  arch/mips/mm/mmap.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
> > index 2f616ebeb7e0..7755a1fad05a 100644
> > --- a/arch/mips/mm/mmap.c
> > +++ b/arch/mips/mm/mmap.c
> > @@ -203,6 +203,11 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
> >  
> >  int __virt_addr_valid(const volatile void *kaddr)
> >  {
> > +	unsigned long vaddr = (unsigned long)vaddr;

the second vaddr should be better kaddr

> > +
> > +	if ((vaddr < PAGE_OFFSET) || (vaddr >= MAP_BASE))
> > +		return 0;
> > +
> >  	return pfn_valid(PFN_DOWN(virt_to_phys(kaddr)));
> >  }
> >  EXPORT_SYMBOL_GPL(__virt_addr_valid);
> > 
> 
> Someone complained that this compiled to a constant "return 0" for him:
> https://bugs.openwrt.org/index.php?do=details&task_id=2305#comment6554
> 
> I just checked this on a unmodified 5.2-rc4 with the xway_defconfig and
> I get this:
> 
> 0001915c <__virt_addr_valid>:
>    1915c:       03e00008        jr      ra
>    19160:       00001025        move    v0,zero
> 
> Is this intended?

I don't think so. Interesting what the compiler decides to do here.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

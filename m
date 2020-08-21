Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0E224D1CB
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 11:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgHUJyc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 21 Aug 2020 05:54:32 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:57708 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727046AbgHUJya (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 05:54:30 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22195973-1500050 
        for multiple; Fri, 21 Aug 2020 10:54:23 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200821095129.GF3354@suse.de>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk> <20200821095129.GF3354@suse.de>
Subject: Re: [PATCH 1/4] mm: Export flush_vm_area() to sync the PTEs upon construction
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, stable@vger.kernel.org
To:     Joerg Roedel <jroedel@suse.de>
Date:   Fri, 21 Aug 2020 10:54:22 +0100
Message-ID: <159800366215.29194.8455636122843151159@build.alporthouse.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Joerg Roedel (2020-08-21 10:51:29)
> On Fri, Aug 21, 2020 at 09:50:08AM +0100, Chris Wilson wrote:
> > The alloc_vm_area() is another method for drivers to
> > vmap/map_kernel_range that uses apply_to_page_range() rather than the
> > direct vmalloc walkers. This is missing the page table modification
> > tracking, and the ability to synchronize the PTE updates afterwards.
> > Provide flush_vm_area() for the users of alloc_vm_area() that assumes
> > the worst and ensures that the page directories are correctly flushed
> > upon construction.
> > 
> > The impact is most pronounced on x86_32 due to the delayed set_pmd().
> > 
> > Reported-by: Pavel Machek <pavel@ucw.cz>
> > References: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
> > References: 86cf69f1d893 ("x86/mm/32: implement arch_sync_kernel_mappings()")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Joerg Roedel <jroedel@suse.de>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Cc: <stable@vger.kernel.org> # v5.8+
> > ---
> >  include/linux/vmalloc.h |  1 +
> >  mm/vmalloc.c            | 16 ++++++++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > index 0221f852a7e1..a253b27df0ac 100644
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -204,6 +204,7 @@ static inline void set_vm_flush_reset_perms(void *addr)
> >  
> >  /* Allocate/destroy a 'vmalloc' VM area. */
> >  extern struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes);
> > +extern void flush_vm_area(struct vm_struct *area);
> >  extern void free_vm_area(struct vm_struct *area);
> >  
> >  /* for /dev/kmem */
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index b482d240f9a2..c41934486031 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3078,6 +3078,22 @@ struct vm_struct *alloc_vm_area(size_t size, pte_t **ptes)
> >  }
> >  EXPORT_SYMBOL_GPL(alloc_vm_area);
> >  
> > +void flush_vm_area(struct vm_struct *area)
> > +{
> > +     unsigned long addr = (unsigned long)area->addr;
> > +
> > +     /* apply_to_page_range() doesn't track the damage, assume the worst */
> > +     if (ARCH_PAGE_TABLE_SYNC_MASK & (PGTBL_PTE_MODIFIED |
> > +                                      PGTBL_PMD_MODIFIED |
> > +                                      PGTBL_PUD_MODIFIED |
> > +                                      PGTBL_P4D_MODIFIED |
> > +                                      PGTBL_PGD_MODIFIED))
> > +             arch_sync_kernel_mappings(addr, addr + area->size);
> 
> This should happen in __apply_to_page_range() directly and look like
> this:

Ok. I thought it had to be after assigning the *ptep. If we apply the
sync first, do not have to worry about PGTBL_PTE_MODIFIED from the
*ptep?
-Chris

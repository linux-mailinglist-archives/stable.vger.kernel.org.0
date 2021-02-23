Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9C322895
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 11:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbhBWKIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 05:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhBWKHv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 05:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA91864E3F;
        Tue, 23 Feb 2021 10:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614074830;
        bh=ldsGlNDSWjObH//AcaVyVQQKhLO6Y4NGrLkEEk/X1Fw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RbK9+nibc62xkE6KYKhOYU2/DAkFZdXP5FAppKjVSO6+bAQ8rT49E2p0xz70sCeKg
         CanSZRBIKjopRCmoFauqzMQO0ahgfBqdp8OLhf0HTOKAW81Nxdxkhmue1lA1H/BzZR
         E1j2euU99oiLWUta8OltH4Yb/me+UivaK/b5Z8anO04LeWlMlYBTyz7lCOQHlMLBZC
         0w5Zuterro0K5aVcTIJMfrcLBv3ADFpNNDGovuYZjU8s5chhvSmiIX9eDYtKhoYAxY
         ywKIbb4g9ghAeaVChMmr7wxqQ1MGUc+a6/2DforsrqiCRDlnPOkdIUtmDFFHn1dJWs
         jbbpF1r2ITpww==
Date:   Tue, 23 Feb 2021 12:06:59 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v6 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210223100659.GJ1447004@kernel.org>
References: <20210222105728.28636-1-rppt@kernel.org>
 <a7f70da1-6733-967f-4d1d-92d23b95a753@redhat.com>
 <20210223094802.GI1447004@kernel.org>
 <aafa291d-ced4-2e4d-f9c4-be99e9394c0c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aafa291d-ced4-2e4d-f9c4-be99e9394c0c@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 10:49:44AM +0100, David Hildenbrand wrote:
> On 23.02.21 10:48, Mike Rapoport wrote:
> > On Tue, Feb 23, 2021 at 09:04:19AM +0100, David Hildenbrand wrote:
> > > On 22.02.21 11:57, Mike Rapoport wrote:
> > > > From: Mike Rapoport <rppt@linux.ibm.com>
> > > > 
> > > > There could be struct pages that are not backed by actual physical memory.
> > > > This can happen when the actual memory bank is not a multiple of
> > > > SECTION_SIZE or when an architecture does not register memory holes
> > > > reserved by the firmware as memblock.memory.
> > > > 
> > > > Such pages are currently initialized using init_unavailable_mem() function
> > > > that iterates through PFNs in holes in memblock.memory and if there is a
> > > > struct page corresponding to a PFN, the fields of this page are set to
> > > > default values and it is marked as Reserved.
> > > > 
> > > > init_unavailable_mem() does not take into account zone and node the page
> > > > belongs to and sets both zone and node links in struct page to zero.
> > > > 
> > > > Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> > > > rather that check each PFN") the holes inside a zone were re-initialized
> > > > during memmap_init() and got their zone/node links right. However, after
> > > > that commit nothing updates the struct pages representing such holes.
> > > > 
> > > > On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> > > > instance in a configuration below:
> > > > 
> > > > 	# grep -A1 E820 /proc/iomem
> > > > 	7a17b000-7a216fff : Unknown E820 type
> > > > 	7a217000-7bffffff : System RAM
> > > > 
> > > > unset zone link in struct page will trigger
> > > > 
> > > > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > > > 
> > > > because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> > > > in struct page) in the same pageblock.
> > > > 
> > > > Interleave initialization of the unavailable pages with the normal
> > > > initialization of memory map, so that zone and node information will be
> > > > properly set on struct pages that are not backed by the actual memory.
> > > > 
> > > > With this change the pages for holes inside a zone will get proper
> > > > zone/node links and the pages that are not spanned by any node will get
> > > > links to the adjacent zone/node.
> > > 
> > > Does this include pages in the last section has handled by ...
> > > ...
> > > > -	/*
> > > > -	 * Early sections always have a fully populated memmap for the whole
> > > > -	 * section - see pfn_valid(). If the last section has holes at the
> > > > -	 * end and that section is marked "online", the memmap will be
> > > > -	 * considered initialized. Make sure that memmap has a well defined
> > > > -	 * state.
> > > > -	 */
> > > > -	pgcnt += init_unavailable_range(PFN_DOWN(next),
> > > > -					round_up(max_pfn, PAGES_PER_SECTION));
> > > > -
> > > 
> > > ^ this code?
> > > 
> > > Or how is that case handled now?
> > 
> > Hmm, now it's clamped to node_end_pfn/zone_end_pfn, so in your funny example with
> > 
> >      -object memory-backend-ram,id=bmem0,size=4160M \
> >      -object memory-backend-ram,id=bmem1,size=4032M \
> > 
> > this is not handled :(
> > 
> > But it will be handled with this on top:
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 29bbd08b8e63..6c9b490f5a8b 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6350,9 +6350,12 @@ void __meminit __weak memmap_init_zone(struct zone *zone)
> >   		hole_pfn = end_pfn;
> >   	}
> > -	if (hole_pfn < zone_end_pfn)
> > -		pgcnt += init_unavailable_range(hole_pfn, zone_end_pfn,
> > +#ifdef CONFIG_SPARSEMEM
> > +	end_pfn = round_up(zone_end_pfn, PAGES_PER_SECTION);
> > +	if (hole_pfn < end_pfn)
> > +		pgcnt += init_unavailable_range(hole_pfn, end_pfn,
> >   						zone_id, nid);
> > +#endif
> >   	if (pgcnt)
> >   		pr_info("  %s zone: %lld pages in unavailable ranges\n",
> > 
> 
> 
> Also, just wondering, will PFN 0 still get initialized?

Yes, it gets 0,0 links, but it is still outside node/zone span.

-- 
Sincerely yours,
Mike.

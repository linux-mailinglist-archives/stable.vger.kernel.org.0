Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3465E3141B1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 22:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236349AbhBHV1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 16:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236257AbhBHV0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 16:26:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 023D364E6F;
        Mon,  8 Feb 2021 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612819538;
        bh=ibRblMMQB/f4N6UUddTxgf3Y0DdL2/6jIMsoXEp/dFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbeA5IstB6PsRvXyj6rFpshYxdeBcj7ak4hAm+xhqzO9/xK16bZnvJsymuZuJtfaU
         6C4vzGBY4ceak1voPKgvAzKTj1zqZqB4mXDsyht+FHrCYclZFOTikE/XisjmfEXoaN
         GYKLmW76MK5fY9SlAoS5leUt1F3HQxe9AU++M5qJwXQkISykZiJHQBGGq+cfFuli4h
         lMGYthqSk9gHiuxIosF7L/uqZRRbdyGLGpC/8C6KMgXJQmQIqHMhMS7drLlrrCYYmG
         iHatanR76Pk54PBvSG4VzKTs0W3yzCufp9S9+zEWTj8rkBoX5+AWPhx0sqV6LTkuh1
         NHdlFm3chD6YA==
Date:   Mon, 8 Feb 2021 23:25:26 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <20210208212526.GW242749@kernel.org>
References: <20210208110820.6269-1-rppt@kernel.org>
 <20210208131100.7273d249a5d00cac0d247fcf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208131100.7273d249a5d00cac0d247fcf@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 01:11:00PM -0800, Andrew Morton wrote:
> On Mon,  8 Feb 2021 13:08:20 +0200 Mike Rapoport <rppt@kernel.org> wrote:
> 
> > There could be struct pages that are not backed by actual physical memory.
> > This can happen when the actual memory bank is not a multiple of
> > SECTION_SIZE or when an architecture does not register memory holes
> > reserved by the firmware as memblock.memory.
> > 
> > Such pages are currently initialized using init_unavailable_mem() function
> > that iterates through PFNs in holes in memblock.memory and if there is a
> > struct page corresponding to a PFN, the fields of this page are set to
> > default values and it is marked as Reserved.
> > 
> > init_unavailable_mem() does not take into account zone and node the page
> > belongs to and sets both zone and node links in struct page to zero.
> > 
> > On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> > instance in a configuration below:
> > 
> > 	# grep -A1 E820 /proc/iomem
> > 	7a17b000-7a216fff : Unknown E820 type
> > 	7a217000-7bffffff : System RAM
> > 
> > unset zone link in struct page will trigger
> > 
> > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > 
> > because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> > in struct page) in the same pageblock.
> > 
> > ...
> >
> > 
> > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather
> > that check each PFN")
> 
> What are your thoughts on the priority of this (rather large!) fix? 
> Are such systems sufficiently common to warrant a 5.11 merge?  -stable?

I don't know how common are such systems, but the bug is exposed only for
builds with DEBUG_VM=y, so after problems with previous versions discovered
by various CI systems I'd say to hold it off till 5.11 is out.

If this time the fix works it'll make it to -stable anyway :)

-- 
Sincerely yours,
Mike.

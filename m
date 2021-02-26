Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAF6325DA9
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 07:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBZGnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 01:43:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhBZGnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 01:43:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 132F160238;
        Fri, 26 Feb 2021 06:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614321758;
        bh=hX4Qhz8Qgp1SzWBjSDDYOU56u7r54bsxVnDXREAgGN8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R25R6XdINokIbzL59wiY4Rkm7fp/nYt523xLNqSO0+TQ5gWmHqqUDlZEpbY5jiNIP
         YfzetFUC3HabYiPDRO+DwX3HrzfMbqYEB8cqbIelYbyk2KvtGQtLlyY1oZaJjr/cVI
         KxfBlbqWJS863wM/eXzhvONJqNtWukSRuusF3u8A=
Date:   Fri, 26 Feb 2021 07:42:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
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
Subject: Re: [PATCH v8 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <YDiYXPRr5v0MAQOe@kroah.com>
References: <20210225224351.7356-1-rppt@kernel.org>
 <20210225224351.7356-2-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225224351.7356-2-rppt@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 26, 2021 at 12:43:51AM +0200, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> There could be struct pages that are not backed by actual physical memory.
> This can happen when the actual memory bank is not a multiple of
> SECTION_SIZE or when an architecture does not register memory holes
> reserved by the firmware as memblock.memory.
> 
> Such pages are currently initialized using init_unavailable_mem() function
> that iterates through PFNs in holes in memblock.memory and if there is a
> struct page corresponding to a PFN, the fields of this page are set to
> default values and it is marked as Reserved.
> 
> init_unavailable_mem() does not take into account zone and node the page
> belongs to and sets both zone and node links in struct page to zero.
> 
> Before commit 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions
> rather that check each PFN") the holes inside a zone were re-initialized
> during memmap_init() and got their zone/node links right. However, after
> that commit nothing updates the struct pages representing such holes.
> 
> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> instance in a configuration below:
> 
> 	# grep -A1 E820 /proc/iomem
> 	7a17b000-7a216fff : Unknown E820 type
> 	7a217000-7bffffff : System RAM
> 
> unset zone link in struct page will trigger
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> in set_pfnblock_flags_mask() when called with a struct page from a range
> other than E820_TYPE_RAM because there are pages in the range of ZONE_DMA32
> but the unset zone link in struct page makes them appear as a part of
> ZONE_DMA.
> 
> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.
> 
> With this change the pages for holes inside a zone will get proper
> zone/node links and the pages that are not spanned by any node will get
> links to the adjacent zone/node. The holes between nodes will be prepended
> to the zone/node above the hole and the trailing pages in the last section
> that will be appended to the zone/node below.
> 
> Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Reported-by: Andrea Arcangeli <aarcange@redhat.com>
> Reviewed-by: Baoquan He <bhe@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/page_alloc.c | 158 +++++++++++++++++++++++-------------------------
>  1 file changed, 75 insertions(+), 83 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

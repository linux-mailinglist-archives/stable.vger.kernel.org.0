Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0577C319CB3
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 11:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhBLKe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 05:34:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:42456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhBLKeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 05:34:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613126010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FfObjgGx1kUN+XiaHjFPPNh76df2UzoGP5Po1j6Jimw=;
        b=N6Iwd2emtwpqfotywCiDnLn4/e5bC+kqeLBBWSzIDQ6HYQLuqYvlUbAFaOgKvahlymivwA
        FDnl0JNn9a5dT2l/yqgtLHLy4NMTDkQBZvj/aJ8aHJ2uacu9x89useMcdedNLQKy2J4JRo
        nqV85a7GKLpjAoWvieI4p5O5xJIN//Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D95E8AFF6;
        Fri, 12 Feb 2021 10:33:29 +0000 (UTC)
Date:   Fri, 12 Feb 2021 11:33:28 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <YCZZeAAC8VOCPhpU@dhcp22.suse.cz>
References: <20210208110820.6269-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208110820.6269-1-rppt@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 08-02-21 13:08:20, Mike Rapoport wrote:
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

IIUC the zone should be associated based on the pfn and architecture
constraines on zones. Node is then guessed based on the last existing
range, right?

> On a system that has firmware reserved holes in a zone above ZONE_DMA, for
> instance in a configuration below:
> 
> 	# grep -A1 E820 /proc/iomem
> 	7a17b000-7a216fff : Unknown E820 type
> 	7a217000-7bffffff : System RAM

I like the description here though. Thanks very useful.

> unset zone link in struct page will trigger
> 
> 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);

I guess you mean set_pfnblock_flags_mask, right? Is this bug on really
needed? Maybe we just need to skip over reserved pages?

> because there are pages in both ZONE_DMA32 and ZONE_DMA (unset zone link
> in struct page) in the same pageblock.
> 
> Moreover, it is possible that the lowest node and zone start is not aligned
> to the section boundarie, for example on x86:
> 
> [    0.078898] Zone ranges:
> [    0.078899]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> ...
> [    0.078910] Early memory node ranges
> [    0.078912]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
> [    0.078913]   node   0: [mem 0x0000000000100000-0x000000003fffffff]
> 
> and thus with SPARSEMEM memory model the beginning of the memory map will
> have struct pages that are not spanned by any node and zone.
> 
> Update detection of node boundaries in get_pfn_range_for_nid() so that the
> node range will be expanded to cover memory map section. Since zone spans
> are derived from the node span, there always will be a zone that covers the
> part of the memory map with unavailable pages.
> 
> Interleave initialization of the unavailable pages with the normal
> initialization of memory map, so that zone and node information will be
> properly set on struct pages that are not backed by the actual memory.

I have to digest this but my first impression is that this is more heavy
weight than it needs to. Pfn walkers should normally obey node range at
least. The first pfn is usually excluded but I haven't seen real
problems with that. The VM_BUG_ON blowing up is really bad but as said
above we can simply make it less offensive in presence of reserved pages
as those shouldn't reach that path AFAICS normally. Or we can just
remove it. It is not really clear to me whether it has any value beyond
debugging TBH.
-- 
Michal Hocko
SUSE Labs

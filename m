Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF902F1CF8
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 18:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbhAKRss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 12:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbhAKRss (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 12:48:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A0820738;
        Mon, 11 Jan 2021 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610387287;
        bh=7wIXPxD5IVGu+9rv9NhrRREI8qcEOjqL8eVN8Z60G+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=THXpXq1Q+1MLgQWZhsnvKohk2+EuTVRjXWdccAdsJmAhXyhdQK84raLtfzaO2Y3Le
         iH8X6o54B+fXrkGrWZZMV+BCAPj7QXmNUVRNOREBK67zH6qD7ldJjJEOTFY4WosfGT
         yzUc1FaGIkeiU8F/+crHRKGPbHn6jb1aEERyQRScO4hhZngASF55N5a5bJded2QTUr
         V6SCsAK+BCt+LX7TpjSp+rsqGvSRUCoNn05fGKJWB8ML7TqiT5tutV6s8jx+WLzNwN
         x6wU9XiGfJ1kjtz8GXoc1XYPaE+urwU9La8BlOyMLV8DXNUpqhjXf8OH3bJ5WM8W/G
         K6fdSQhX9iNyA==
Date:   Mon, 11 Jan 2021 19:47:58 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Qian Cai <qcai@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mm: fix initialization of struct page for holes
 in memory layout
Message-ID: <20210111174758.GE1106298@kernel.org>
References: <20201209214304.6812-1-rppt@kernel.org>
 <20201209214304.6812-3-rppt@kernel.org>
 <768cb57d6ef0989293b3f9fbe0af8e8851723ea1.camel@redhat.com>
 <20210105082403.GA1106298@kernel.org>
 <67ef893f27551f80ecf49ef78c0ebc05d3e41b46.camel@redhat.com>
 <20210106080553.GB1106298@kernel.org>
 <8171f5a5a8b407a1fcca56bab912555bde80d323.camel@redhat.com>
 <20210110153956.GD1106298@kernel.org>
 <782e710eac32b1ab3bf9713bcd6afcbc9483e16c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <782e710eac32b1ab3bf9713bcd6afcbc9483e16c.camel@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 10:06:43AM -0500, Qian Cai wrote:
> On Sun, 2021-01-10 at 17:39 +0200, Mike Rapoport wrote:
> > On Wed, Jan 06, 2021 at 04:04:21PM -0500, Qian Cai wrote:
> > > On Wed, 2021-01-06 at 10:05 +0200, Mike Rapoport wrote:
> > > > I think we trigger PF_POISONED_CHECK() in PageSlab(), then
> > > > fffffffffffffffe
> > > > is "accessed" from VM_BUG_ON_PAGE().
> > > > 
> > > > It seems to me that we are not initializing struct pages for holes at the
> > > > node
> > > > boundaries because zones are already clamped to exclude those holes.
> > > > 
> > > > Can you please try to see if the patch below will produce any useful info:
> > > 
> > > [    0.000000] init_unavailable_range: spfn: 8c, epfn: 9b, zone: DMA, node:
> > > 0
> > > [    0.000000] init_unavailable_range: spfn: 1f7be, epfn: 1f9fe, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 28784, epfn: 288e4, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 298b9, epfn: 298bd, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 29923, epfn: 29931, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 29933, epfn: 29941, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 29945, epfn: 29946, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 29ff9, epfn: 2a823, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 33a23, epfn: 33a53, zone:
> > > DMA32, node: 0
> > > [    0.000000] init_unavailable_range: spfn: 78000, epfn: 100000, zone:
> > > DMA32, node: 0
> > > ...
> > > [  572.222563][ T2302] kpagecount_read: pfn 47f380 is poisoned
> > ...
> > > [  590.570032][ T2302] kpagecount_read: pfn 47ffff is poisoned
> > > [  604.268653][ T2302] kpagecount_read: pfn 87ff80 is poisoned
> > ...
> > > [  604.611698][ T2302] kpagecount_read: pfn 87ffbc is poisoned
> > > [  617.484205][ T2302] kpagecount_read: pfn c7ff80 is poisoned
> > ...
> > > [  618.212344][ T2302] kpagecount_read: pfn c7ffff is poisoned
> > > [  633.134228][ T2302] kpagecount_read: pfn 107ff80 is poisoned
> > ...
> > > [  633.874087][ T2302] kpagecount_read: pfn 107ffff is poisoned
> > > [  647.686412][ T2302] kpagecount_read: pfn 147ff80 is poisoned
> > ...
> > > [  648.425548][ T2302] kpagecount_read: pfn 147ffff is poisoned
> > > [  663.692630][ T2302] kpagecount_read: pfn 187ff80 is poisoned
> > ...
> > > [  664.432671][ T2302] kpagecount_read: pfn 187ffff is poisoned
> > > [  675.462757][ T2302] kpagecount_read: pfn 1c7ff80 is poisoned
> > ...
> > > [  676.202548][ T2302] kpagecount_read: pfn 1c7ffff is poisoned
> > > [  687.121605][ T2302] kpagecount_read: pfn 207ff80 is poisoned
> > ...
> > > [  687.860981][ T2302] kpagecount_read: pfn 207ffff is poisoned
> > 
> > The e820 map has a hole near the end of each node and these holes are not
> > initialized with init_unavailable_range() after it was interleaved with
> > memmap initialization because such holes are not accounted by
> > zone->spanned_pages.
> > 
> > Yet, I'm still cannot really understand how this never triggered 
> > 
> > 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> > 
> > before v5.7 as all the struct pages for these holes would have zone=0 and
> > node=0 ... 
> > 
> > @Qian, can you please boot your system with memblock=debug and share the
> > logs?
> > 
> 
> http://people.redhat.com/qcai/memblock.txt

Thanks!

So, we have these large allocations for the memory maps:

memblock_alloc_exact_nid_raw: 266338304 bytes align=0x200000 nid=0 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x000000046f400000-0x000000047f1fffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=1 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x000000086fe00000-0x000000087fdfffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=2 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x0000000c6fe00000-0x0000000c7fdfffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=3 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x000000106fe00000-0x000000107fdfffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=4 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x000000146fe00000-0x000000147fdfffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=5 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x000000186fe00000-0x000000187fdfffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=6 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x0000001c6fe00000-0x0000001c7fdfffff] memblock_alloc_range_nid+0x108/0x1b6
memblock_alloc_exact_nid_raw: 268435456 bytes align=0x200000 nid=7 from=0x0000000001000000 max_addr=0x0000000000000000 sparse_init_nid+0x13b/0x519
memblock_reserve: [0x000000206fc00000-0x000000207fbfffff] memblock_alloc_range_nid+0x108/0x1b6

that will be always next to the end of each node and so the last several
pageblocks in a node will never be used by the page allocator.
That masks wrong zone=0 links in the pages corresponding to the holes near
each node and the VM_BUG_ON_PAGE(!zone_spans_pfn) never triggers.

I'm going to send v3 soon that should take better care of the zone links.

--
Sincerely yours,
Mike.

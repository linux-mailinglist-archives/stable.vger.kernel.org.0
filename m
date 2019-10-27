Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6058E6565
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 21:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfJ0UvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 16:51:09 -0400
Received: from outbound-smtp12.blacknight.com ([46.22.139.17]:54934 "EHLO
        outbound-smtp12.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727635AbfJ0UvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 16:51:08 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Oct 2019 16:51:07 EDT
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp12.blacknight.com (Postfix) with ESMTPS id F2ADF1C1F22
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 20:43:45 +0000 (GMT)
Received: (qmail 6436 invoked from network); 27 Oct 2019 20:43:45 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.19.210])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 27 Oct 2019 20:43:45 -0000
Date:   Sun, 27 Oct 2019 20:43:43 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm, meminit: Recalculate pcpu batch and high limits
 after init completes
Message-ID: <20191027204343.GG3016@techsingularity.net>
References: <20191021094808.28824-2-mgorman@techsingularity.net>
 <20191026131036.A7A5421655@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20191026131036.A7A5421655@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 26, 2019 at 01:10:35PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: 4.1+
> 
> The bot has tested the following trees: v5.3.7, v4.19.80, v4.14.150, v4.9.197, v4.4.197.
> 
> v5.3.7: Build OK!
> v4.19.80: Build failed! Errors:
> 
> v4.14.150: Failed to apply! Possible dependencies:
>     3c2c648842843 ("mm/page_alloc.c: fix typos in comments")
>     66e8b438bd5c7 ("mm/memblock.c: make the index explicit argument of for_each_memblock_type")
>     c9e97a1997fbf ("mm: initialize pages on demand during boot")
> 
> v4.9.197: Failed to apply! Possible dependencies:
>     3c2c648842843 ("mm/page_alloc.c: fix typos in comments")
>     66e8b438bd5c7 ("mm/memblock.c: make the index explicit argument of for_each_memblock_type")
>     c9e97a1997fbf ("mm: initialize pages on demand during boot")
> 
> v4.4.197: Failed to apply! Possible dependencies:
>     0a687aace3b8e ("mm,oom: do not loop !__GFP_FS allocation if the OOM killer is disabled")
>     0caeef63e6d2f ("libnvdimm: Add a poison list and export badblocks")
>     0e749e54244ee ("dax: increase granularity of dax_clear_blocks() operations")
>     34c0fd540e79f ("mm, dax, pmem: introduce pfn_t")
>     3c2c648842843 ("mm/page_alloc.c: fix typos in comments")
>     3da88fb3bacfa ("mm, oom: move GFP_NOFS check to out_of_memory")
>     4b94ffdc4163b ("x86, mm: introduce vmem_altmap to augment vmemmap_populate()")
>     5020e285856cb ("mm, oom: give __GFP_NOFAIL allocations access to memory reserves")
>     52db400fcd502 ("pmem, dax: clean up clear_pmem()")
>     66e8b438bd5c7 ("mm/memblock.c: make the index explicit argument of for_each_memblock_type")
>     7cf91a98e607c ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
>     87ba05dff3510 ("libnvdimm: don't fail init for full badblocks list")
>     8c9c1701c7c23 ("mm/memblock: introduce for_each_memblock_type()")
>     9476df7d80dfc ("mm: introduce find_dev_pagemap()")
>     ad9a8bde2cb19 ("libnvdimm, pmem: move definition of nvdimm_namespace_add_poison to nd.h")
>     b2e0d1625e193 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
>     b95f5f4391fad ("libnvdimm: convert to statically allocated badblocks")
>     ba6c19fd113a3 ("include/linux/memblock.h: Clean up code for several trivial details")
>     c9e97a1997fbf ("mm: initialize pages on demand during boot")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

What were the 4.19.80 build errors?

For the older kernels, it would have to be confirmed those kernels are
definietly affected. The test machines I tried fails to even boot on those
kernels so I need to find a NUMA machine that is old enough to boot those
kernels and confirmed affected by the bug before determining what the
backport needs to look like.

-- 
Mel Gorman
SUSE Labs

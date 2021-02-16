Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BACE31CF99
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhBPRuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 12:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhBPRuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Feb 2021 12:50:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE54F64E08;
        Tue, 16 Feb 2021 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613497765;
        bh=YI1K3YdFbvoFfZazxpp/W/h52AmPp8oWT+kgdF1i6VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRSpTgNUyXd8d0aOr8semRt7oBjZYxojgdsSVOVlJJggNybOxexkqWW7qjzcDRXRa
         yAIq8d3P7mH4KkPcSnLwhfNWj1bX/TCvsgDfr0Y+Sv+3TmfzC4mbO1RzrzZq4hkCwh
         jUb0LNHIMAC0kx5pVdAqjhn8qFoG/mqEYpkri80F4wFGZJQcUdOxjJX29w6usPPR2K
         mc9dseAR49XQMoIOx9xZ1BWcU2SdkR7GX8RaKLjCWZbDrYyHw0VijwDFg5jGUe5g29
         /Q14My3SDMkKcltXFPgIsexjgY/BuHu3KObM05BFQVFhxT+UZQsyu4yApucAqpx1Rs
         Jo7Xp40+XsIaQ==
Date:   Tue, 16 Feb 2021 19:49:14 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mike Rapoport <rppt@linux.ibm.com>, Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 1/1] mm: refactor initialization of struct page for
 holes in memory layout
Message-ID: <20210216174914.GD1307762@kernel.org>
References: <e5ce315f-64f7-75e3-b587-ad0062d5902c@redhat.com>
 <YCaAHI/rFp1upRLc@dhcp22.suse.cz>
 <20210214180016.GO242749@kernel.org>
 <YCo4Lyio1h2Heixh@dhcp22.suse.cz>
 <20210215212440.GA1307762@kernel.org>
 <YCuDUG89KwQNbsjA@dhcp22.suse.cz>
 <20210216110154.GB1307762@kernel.org>
 <b1302d8e-5380-18d1-0f55-2dfd61f470e6@suse.cz>
 <YCvEeWuU2tBUUNBG@dhcp22.suse.cz>
 <caeebbcc-b6c9-624b-3eeb-591bf59f28a6@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caeebbcc-b6c9-624b-3eeb-591bf59f28a6@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vlastimil,

On Tue, Feb 16, 2021 at 05:39:12PM +0100, Vlastimil Babka wrote:
> 
> 
> So, Andrea could you please check if this fixes the original
> fast_isolate_around() issue for you? With the VM_BUG_ON not removed, DEBUG_VM
> enabled, no changes to struct page initialization...
> It relies on pageblock_pfn_to_page as the rest of the compaction code.

Pardon my ignorance of compaction internals, but does this mean that with
your patch we'll never call set_pfnblock_flags_mask() for a pfn in a hole?
 
> Thanks!
> 
> ----8<----
> From f5c8d7bc77d2ec0b4cfec44820ce6f602fdb3a86 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Tue, 16 Feb 2021 17:32:34 +0100
> Subject: [PATCH] mm, compaction: make fast_isolate_around() robust against
>  pfns from a wrong zone
> 
> TBD
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/compaction.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 190ccdaa6c19..b75645e4678d 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1288,7 +1288,7 @@ static void
>  fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
>  {
>  	unsigned long start_pfn, end_pfn;
> -	struct page *page = pfn_to_page(pfn);
> +	struct page *page;
>  
>  	/* Do not search around if there are enough pages already */
>  	if (cc->nr_freepages >= cc->nr_migratepages)
> @@ -1300,7 +1300,11 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
>  
>  	/* Pageblock boundaries */
>  	start_pfn = pageblock_start_pfn(pfn);
> -	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone)) - 1;
> +	end_pfn = min(pageblock_end_pfn(pfn), zone_end_pfn(cc->zone));
> +
> +	page = pageblock_pfn_to_page(start_pfn, end_pfn, cc->zone);
> +	if (!page)
> +		return;
>  
>  	/* Scan before */
>  	if (start_pfn != pfn) {
> @@ -1486,7 +1490,7 @@ fast_isolate_freepages(struct compact_control *cc)
>  	}
>  
>  	cc->total_free_scanned += nr_scanned;
> -	if (!page)
> +	if (!page || page_zone(page) != cc->zone)
>  		return cc->free_pfn;
>  
>  	low_pfn = page_to_pfn(page);
> -- 
> 2.30.0
> 

-- 
Sincerely yours,
Mike.

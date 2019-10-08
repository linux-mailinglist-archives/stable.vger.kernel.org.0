Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E25ECFE4D
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfJHQAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 12:00:40 -0400
Received: from outbound-smtp26.blacknight.com ([81.17.249.194]:35060 "EHLO
        outbound-smtp26.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726066AbfJHQAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 12:00:40 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2019 12:00:39 EDT
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp26.blacknight.com (Postfix) with ESMTPS id E348BB8839
        for <stable@vger.kernel.org>; Tue,  8 Oct 2019 16:51:58 +0100 (IST)
Received: (qmail 5557 invoked from network); 8 Oct 2019 15:51:58 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.19.210])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 8 Oct 2019 15:51:58 -0000
Date:   Tue, 8 Oct 2019 16:51:56 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fw@deneb.enyo.de>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm, compaction: fix wrong pfn handling in
 __reset_isolation_pfn()
Message-ID: <20191008155156.GD3321@techsingularity.net>
References: <20191008152915.24704-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20191008152915.24704-1-vbabka@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 05:29:15PM +0200, Vlastimil Babka wrote:
> Florian and Dave reported [1] a NULL pointer dereference in
> __reset_isolation_pfn(). While the exact cause is unclear, staring at the code
> revealed two bugs, which might be related.
> 

I think the fix is a good fit. Even if the problem still occurs, it
eliminates an important possibility.

> One bug is that if zone starts in the middle of pageblock, block_page might
> correspond to different pfn than block_pfn, and then the pfn_valid_within()
> checks will check different pfn's than those accessed via struct page. This
> might result in acessing an unitialized page in CONFIG_HOLES_IN_ZONE configs.
> 

s/acessing/accessing/

Aside from HOLES_IN_ZONE, the patch addresses an issue if the start
of the zone is not pageblock-aligned. While this is common, it's not
guaranteed. I don't think this needs to be clarified in the changelog as
your example is valid. I'm commenting in case someone decides not to try
the patch because they feel HOLES_IN_ZONE is required.

> The other bug is that end_page refers to the first page of next pageblock and
> not last page of current pageblock. The online and valid check is then wrong
> and with sections, the while (page < end_page) loop might wander off actual
> struct page arrays.
> 
> [1] https://lore.kernel.org/linux-xfs/87o8z1fvqu.fsf@mid.deneb.enyo.de/
> 
> Reported-by: Florian Weimer <fw@deneb.enyo.de>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Fixes: 6b0868c820ff ("mm/compaction.c: correct zone boundary handling when resetting pageblock skip hints")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@techsingularity.net>

Just one minor irrelevant note below.

> ---
>  mm/compaction.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index ce08b39d85d4..672d3c78c6ab 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -270,14 +270,15 @@ __reset_isolation_pfn(struct zone *zone, unsigned long pfn, bool check_source,
>  
>  	/* Ensure the start of the pageblock or zone is online and valid */
>  	block_pfn = pageblock_start_pfn(pfn);
> -	block_page = pfn_to_online_page(max(block_pfn, zone->zone_start_pfn));
> +	block_pfn = max(block_pfn, zone->zone_start_pfn);
> +	block_page = pfn_to_online_page(block_pfn);
>  	if (block_page) {
>  		page = block_page;
>  		pfn = block_pfn;
>  	}
>  
>  	/* Ensure the end of the pageblock or zone is online and valid */
> -	block_pfn += pageblock_nr_pages;
> +	block_pfn = pageblock_end_pfn(pfn) - 1;
>  	block_pfn = min(block_pfn, zone_end_pfn(zone) - 1);
>  	end_page = pfn_to_online_page(block_pfn);
>  	if (!end_page)

This is fine and is definetly fixing a potential issue.

> @@ -303,7 +304,7 @@ __reset_isolation_pfn(struct zone *zone, unsigned long pfn, bool check_source,
>  
>  		page += (1 << PAGE_ALLOC_COSTLY_ORDER);
>  		pfn += (1 << PAGE_ALLOC_COSTLY_ORDER);
> -	} while (page < end_page);
> +	} while (page <= end_page);
>  
>  	return false;
>  }

I think this is also ok as it's appropriate for PFN walkers in general of
this style. However, I think it's unlikely to fix anything given that we
are walking in steps of (1 << PAGE_ALLOC_COSTLY_ORDER) and the final page
is not necessarily aligned on that boundary. Still, it's an improvement.

Thanks

-- 
Mel Gorman
SUSE Labs

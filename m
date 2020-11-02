Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8796D2A2B2B
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgKBNEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:04:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:50450 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgKBNEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 08:04:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C106ABAE;
        Mon,  2 Nov 2020 13:03:59 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] mm/compaction: count pages and stop correctly
 during page isolation.
To:     Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201030183809.3616803-1-zi.yan@sent.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <839ec612-1494-c341-302e-585056b2abae@suse.cz>
Date:   Mon, 2 Nov 2020 14:03:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030183809.3616803-1-zi.yan@sent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/30/20 7:38 PM, Zi Yan wrote:
> From: Zi Yan <ziy@nvidia.com>
> 
> In isolate_migratepages_block, when cc->alloc_contig is true, we are
> able to isolate compound pages, nr_migratepages and nr_isolated did not
> count compound pages correctly, causing us to isolate more pages than we
> thought. Count compound pages as the number of base pages they contain.
> Otherwise, we might be trapped in too_many_isolated while loop,
> since the actual isolated pages can go up to
> COMPACT_CLUSTER_MAX*512=16384, where COMPACT_CLUSTER_MAX is 32,
> since we stop isolation after cc->nr_migratepages reaches to
> COMPACT_CLUSTER_MAX.
> 
> In addition, after we fix the issue above, cc->nr_migratepages could
> never be equal to COMPACT_CLUSTER_MAX if compound pages are isolated,
> thus page isolation could not stop as we intended. Change the isolation
> stop condition to >=.
> 
> The issue can be triggered as follows:
> In a system with 16GB memory and an 8GB CMA region reserved by
> hugetlb_cma, if we first allocate 10GB THPs and mlock them
> (so some THPs are allocated in the CMA region and mlocked), reserving
> 6 1GB hugetlb pages via
> /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages will get stuck
> (looping in too_many_isolated function) until we kill either task.
> With the patch applied, oom will kill the application with 10GB THPs and
> let hugetlb page reservation finish.
> 
> Fixes: 1da2f328fa64 (“mm,thp,compaction,cma: allow THP migration for CMA allocations”)
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/compaction.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index ee1f8439369e..3e834ac402f1 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1012,8 +1012,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>   
>   isolate_success:
>   		list_add(&page->lru, &cc->migratepages);
> -		cc->nr_migratepages++;
> -		nr_isolated++;
> +		cc->nr_migratepages += compound_nr(page);
> +		nr_isolated += compound_nr(page);
>   
>   		/*
>   		 * Avoid isolating too much unless this block is being
> @@ -1021,7 +1021,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>   		 * or a lock is contended. For contention, isolate quickly to
>   		 * potentially remove one source of contention.
>   		 */
> -		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX &&
> +		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX &&
>   		    !cc->rescan && !cc->contended) {
>   			++low_pfn;
>   			break;
> @@ -1132,7 +1132,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
>   		if (!pfn)
>   			break;
>   
> -		if (cc->nr_migratepages == COMPACT_CLUSTER_MAX)
> +		if (cc->nr_migratepages >= COMPACT_CLUSTER_MAX)
>   			break;
>   	}
>   
> 


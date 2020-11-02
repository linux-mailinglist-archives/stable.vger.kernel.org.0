Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FB02A2B34
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 14:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgKBNHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 08:07:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:54462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728359AbgKBNHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 08:07:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4E233B810;
        Mon,  2 Nov 2020 13:07:14 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] mm/compaction: stop isolation if too many pages
 are isolated and we have pages to migrate.
To:     Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Rik van Riel <riel@surriel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201030183809.3616803-1-zi.yan@sent.com>
 <20201030183809.3616803-2-zi.yan@sent.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <ea9c8972-9166-49bb-4b33-900e58cf1c8c@suse.cz>
Date:   Mon, 2 Nov 2020 14:07:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030183809.3616803-2-zi.yan@sent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/30/20 7:38 PM, Zi Yan wrote:
> From: Zi Yan <ziy@nvidia.com>
> 
> In isolate_migratepages_block, if we have too many isolated pages and
> nr_migratepages is not zero, we should try to migrate what we have
> without wasting time on isolating.

As you CC stable, there should be a stronger reason (strictly speaking the 
problem should have been observed in practice, but this is a simple patch, so 
they could accept it), so I suggest Andrew adds the following paragraph:

In theory it's possible that multiple parallel compactions will cause 
too_many_isolated() to become true even if each has isolated less than 
COMPACT_CLUSTER_MAX, and loop forever in the while loop. Bailing immediately 
prevents that.

> Fixes: 1da2f328fa64 (“mm,thp,compaction,cma: allow THP migration for CMA allocations”)
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/compaction.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 3e834ac402f1..4d237a7c3830 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -817,6 +817,10 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>   	 * delay for some time until fewer pages are isolated
>   	 */
>   	while (unlikely(too_many_isolated(pgdat))) {
> +		/* stop isolation if there are still pages not migrated */
> +		if (cc->nr_migratepages)
> +			return 0;
> +
>   		/* async migration should just abort */
>   		if (cc->mode == MIGRATE_ASYNC)
>   			return 0;
> 


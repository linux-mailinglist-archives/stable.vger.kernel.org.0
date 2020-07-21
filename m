Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8379C22801B
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 14:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGUMjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 08:39:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:49242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbgGUMjC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 08:39:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 55666B182;
        Tue, 21 Jul 2020 12:39:07 +0000 (UTC)
Subject: Re: [PATCH] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
To:     Matthew Wilcox <willy@infradead.org>, js1304@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@lge.com,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
References: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20200721120533.GD15516@casper.infradead.org>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <4c484ce0-cfed-0c50-7a20-d1474ce9afee@suse.cz>
Date:   Tue, 21 Jul 2020 14:38:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721120533.GD15516@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/21/20 2:05 PM, Matthew Wilcox wrote:
> On Tue, Jul 21, 2020 at 12:28:49PM +0900, js1304@gmail.com wrote:
>> +static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
>> +					unsigned int alloc_flags)
>> +{
>> +#ifdef CONFIG_CMA
>> +	unsigned int pflags = current->flags;
>> +
>> +	if (!(pflags & PF_MEMALLOC_NOCMA) &&
>> +		gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
>> +		alloc_flags |= ALLOC_CMA;
> 
> Please don't indent by one tab when splitting a line because it looks like
> the second line and third line are part of the same block.  Either do
> this:
> 
> 	if (!(pflags & PF_MEMALLOC_NOCMA) &&
> 	    gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> 		alloc_flags |= ALLOC_CMA;
> 
> or this:
> 	if (!(pflags & PF_MEMALLOC_NOCMA) &&
> 			gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> 		alloc_flags |= ALLOC_CMA;

Ah, good point.

>> @@ -4619,8 +4631,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  		wake_all_kswapds(order, gfp_mask, ac);
>>  
>>  	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
>> -	if (reserve_flags)
>> +	if (reserve_flags) {
>>  		alloc_flags = reserve_flags;
>> +		alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
>> +	}
> 
> Is this right?  Shouldn't you be passing reserve_flags to
> current_alloc_flags() here?  Also, there's no need to add { } here.

Note the "alloc_flags = reserve_flags;" line is not being deleted here. But if
it was, your points would be true, and yeah it would be a bit more tidy.

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6312227F90
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 14:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUMFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 08:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgGUMFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 08:05:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B928C061794;
        Tue, 21 Jul 2020 05:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GCuQhEEo8GEQbOaZxwL8t/Vh128zAUVl6nyPuwjgwzQ=; b=OthHJd4Bgck5c0QD7mGU1EWZmD
        goOXq0I1zCXHkr6wJ0kB6UMQXXO4pm6v4scGHQaN7AeeV+w32z06HpnWiLO+TsEfQhBXh5R0oHfhX
        9miu46C6dSnClAK3MApHDZ3VMElnGeh2OXiW3uH1ZBjjwreH62IY3cRuzYcjvgbHH2S2gbck1xbi4
        iWt1cH74w2TiGwcXSrTfi+KMz9n+7GEchsbDBFbXS/096k27ycmHX1I6++xPb8SzHHUp9Z1/ASPIy
        S61ANqf8wXP0FmuF83ifHEVFLhhWV+/Oo0W55RkxbSV/z/UX76ABJl5RHPkMC1mXqNf4GjpQd4+R3
        aUa7UqUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxr1Z-0001Eb-Vz; Tue, 21 Jul 2020 12:05:34 +0000
Date:   Tue, 21 Jul 2020 13:05:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     js1304@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
Message-ID: <20200721120533.GD15516@casper.infradead.org>
References: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 21, 2020 at 12:28:49PM +0900, js1304@gmail.com wrote:
> +static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
> +					unsigned int alloc_flags)
> +{
> +#ifdef CONFIG_CMA
> +	unsigned int pflags = current->flags;
> +
> +	if (!(pflags & PF_MEMALLOC_NOCMA) &&
> +		gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> +		alloc_flags |= ALLOC_CMA;

Please don't indent by one tab when splitting a line because it looks like
the second line and third line are part of the same block.  Either do
this:

	if (!(pflags & PF_MEMALLOC_NOCMA) &&
	    gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
		alloc_flags |= ALLOC_CMA;

or this:
	if (!(pflags & PF_MEMALLOC_NOCMA) &&
			gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
		alloc_flags |= ALLOC_CMA;

> @@ -4619,8 +4631,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		wake_all_kswapds(order, gfp_mask, ac);
>  
>  	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
> -	if (reserve_flags)
> +	if (reserve_flags) {
>  		alloc_flags = reserve_flags;
> +		alloc_flags = current_alloc_flags(gfp_mask, alloc_flags);
> +	}

Is this right?  Shouldn't you be passing reserve_flags to
current_alloc_flags() here?  Also, there's no need to add { } here.


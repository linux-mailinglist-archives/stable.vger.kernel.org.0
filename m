Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575A322072A
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 10:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgGOI2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 04:28:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41079 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730058AbgGOI2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 04:28:17 -0400
Received: by mail-ed1-f66.google.com with SMTP id e22so958605edq.8;
        Wed, 15 Jul 2020 01:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oZ21mSnPalCDyZJRBXz6beFTnZl6MlEpDn98/WJ6aVk=;
        b=HLjDK7sUUFheiKuhwwiyk5o4LlkpxLALWX+wvcKGvQY+5NUyhvnD9ApM2T2ESyIY8S
         U2Y823w+LbjjVCHwhUcYmftqJY2KUszVygdetrYJ8/G4mhghq5NSpbcaLbksIpQ/m7p0
         oH8rbhZpKw3WEAV3YzJ6nVTTnmn0bIMHUCjMjHyv4grTNT1918xEuF/PwQN6qesG7eJq
         kNyUc7MMPUPJtYpV1lbgjhWtJ8Ml/SPtTPQLsjDEBmy/butbjumYt6GlKHblpGbu6KC0
         O6yXNMqeJRvP627bTufHSjyFW6qfWA6cl5oiXn5LkfUKQfU7aFDT4IxqHCVUrXcsBreM
         usFg==
X-Gm-Message-State: AOAM533SS24sv9nusOxFsqqA0M+W+b8sXZAayTfb2AXgzHcb7P/k/03l
        CRmJI3SlOAvfQOFtCK9lMlQ=
X-Google-Smtp-Source: ABdhPJx2NyCCKKPhJFFeXgZeW596eU5ArCMhpEYnf1D02xQP3M2UhZ/zPOfS+KfAap43eDl6NHVlFQ==
X-Received: by 2002:a05:6402:a58:: with SMTP id bt24mr8754330edb.333.1594801694308;
        Wed, 15 Jul 2020 01:28:14 -0700 (PDT)
Received: from localhost (ip-37-188-169-187.eurotel.cz. [37.188.169.187])
        by smtp.gmail.com with ESMTPSA id w24sm1452324edt.28.2020.07.15.01.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 01:28:13 -0700 (PDT)
Date:   Wed, 15 Jul 2020 10:28:12 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     js1304@gmail.com
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
Message-ID: <20200715082812.GD5451@dhcp22.suse.cz>
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 15-07-20 14:05:26, Joonsoo Kim wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Currently, preventing cma area in page allocation is implemented by using
> current_gfp_context(). However, there are two problems of this
> implementation.
> 
> First, this doesn't work for allocation fastpath. In the fastpath,
> original gfp_mask is used since current_gfp_context() is introduced in
> order to control reclaim and it is on slowpath.
> Second, clearing __GFP_MOVABLE has a side effect to exclude the memory
> on the ZONE_MOVABLE for allocation target.

This can be especially a problem with movable_node configurations where
a large portion of the memory is in movable zones.

> To fix these problems, this patch changes the implementation to exclude
> cma area in page allocation. Main point of this change is using the
> alloc_flags. alloc_flags is mainly used to control allocation so it fits
> for excluding cma area in allocation.

The approach is sensible and the patch makes sense to me from a quick
glance but I am not really familiar with all subtle details about cma
integration with the allocator so I do not feel confident to provide my
ack.

Thanks!

> Fixes: d7fefcc (mm/cma: add PF flag to force non cma alloc)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  include/linux/sched/mm.h |  4 ----
>  mm/page_alloc.c          | 27 +++++++++++++++------------
>  2 files changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 44ad5b7..a73847a 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -191,10 +191,6 @@ static inline gfp_t current_gfp_context(gfp_t flags)
>  			flags &= ~(__GFP_IO | __GFP_FS);
>  		else if (pflags & PF_MEMALLOC_NOFS)
>  			flags &= ~__GFP_FS;
> -#ifdef CONFIG_CMA
> -		if (pflags & PF_MEMALLOC_NOCMA)
> -			flags &= ~__GFP_MOVABLE;
> -#endif
>  	}
>  	return flags;
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6416d08..cd53894 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2791,7 +2791,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
>  	 * allocating from CMA when over half of the zone's free memory
>  	 * is in the CMA area.
>  	 */
> -	if (migratetype == MIGRATE_MOVABLE &&
> +	if (alloc_flags & ALLOC_CMA &&
>  	    zone_page_state(zone, NR_FREE_CMA_PAGES) >
>  	    zone_page_state(zone, NR_FREE_PAGES) / 2) {
>  		page = __rmqueue_cma_fallback(zone, order);
> @@ -2802,7 +2802,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
>  retry:
>  	page = __rmqueue_smallest(zone, order, migratetype);
>  	if (unlikely(!page)) {
> -		if (migratetype == MIGRATE_MOVABLE)
> +		if (alloc_flags & ALLOC_CMA)
>  			page = __rmqueue_cma_fallback(zone, order);
>  
>  		if (!page && __rmqueue_fallback(zone, order, migratetype,
> @@ -3502,11 +3502,9 @@ static inline long __zone_watermark_unusable_free(struct zone *z,
>  	if (likely(!alloc_harder))
>  		unusable_free += z->nr_reserved_highatomic;
>  
> -#ifdef CONFIG_CMA
>  	/* If allocation can't use CMA areas don't use free CMA pages */
> -	if (!(alloc_flags & ALLOC_CMA))
> +	if (IS_ENABLED(CONFIG_CMA) && !(alloc_flags & ALLOC_CMA))
>  		unusable_free += zone_page_state(z, NR_FREE_CMA_PAGES);
> -#endif
>  
>  	return unusable_free;
>  }
> @@ -3693,6 +3691,16 @@ alloc_flags_nofragment(struct zone *zone, gfp_t gfp_mask)
>  	return alloc_flags;
>  }
>  
> +static inline void current_alloc_flags(gfp_t gfp_mask,
> +				unsigned int *alloc_flags)
> +{
> +	unsigned int pflags = READ_ONCE(current->flags);
> +
> +	if (!(pflags & PF_MEMALLOC_NOCMA) &&
> +		gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> +		*alloc_flags |= ALLOC_CMA;
> +}
> +
>  /*
>   * get_page_from_freelist goes through the zonelist trying to allocate
>   * a page.
> @@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  	struct pglist_data *last_pgdat_dirty_limit = NULL;
>  	bool no_fallback;
>  
> +	current_alloc_flags(gfp_mask, &alloc_flags);
> +
>  retry:
>  	/*
>  	 * Scan zonelist, looking for a zone with enough free.
> @@ -4339,10 +4349,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	} else if (unlikely(rt_task(current)) && !in_interrupt())
>  		alloc_flags |= ALLOC_HARDER;
>  
> -#ifdef CONFIG_CMA
> -	if (gfp_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> -		alloc_flags |= ALLOC_CMA;
> -#endif
>  	return alloc_flags;
>  }
>  
> @@ -4808,9 +4814,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>  	if (should_fail_alloc_page(gfp_mask, order))
>  		return false;
>  
> -	if (IS_ENABLED(CONFIG_CMA) && ac->migratetype == MIGRATE_MOVABLE)
> -		*alloc_flags |= ALLOC_CMA;
> -
>  	return true;
>  }
>  
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs

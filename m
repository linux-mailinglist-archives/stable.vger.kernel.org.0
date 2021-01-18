Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80722F9CC9
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389321AbhARKZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:25:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:44980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388469AbhARJQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 04:16:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610961195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TIs9165iCorzmEcQWytRwIHXViQ6pxNq4y3V5axegtY=;
        b=Fy0FIfVZdFog/+GWXunGYBE6uVXNtg7HLeKc+uqZEHnCnh1lanDoJ24o6pE7z73y4PeyMx
        8h+QmtIgAx1muHQeJAV8wUOAcS5kAuphvccAQ/L61YilIAEwYhQRJFbLNslqa+175fGHyr
        YESWYE6WAZ1bG8FkfRmG6gOLRFv6d3U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 787F8ACF4;
        Mon, 18 Jan 2021 09:13:15 +0000 (UTC)
Date:   Mon, 18 Jan 2021 10:13:14 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v6 3/5] mm: hugetlb: fix a race between freeing and
 dissolving the page
Message-ID: <20210118091314.GB14336@dhcp22.suse.cz>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
 <20210115124942.46403-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115124942.46403-4-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 15-01-21 20:49:40, Muchun Song wrote:
> There is a race condition between __free_huge_page()
> and dissolve_free_huge_page().
> 
> CPU0:                         CPU1:
> 
> // page_count(page) == 1
> put_page(page)
>   __free_huge_page(page)
>                               dissolve_free_huge_page(page)
>                                 spin_lock(&hugetlb_lock)
>                                 // PageHuge(page) && !page_count(page)
>                                 update_and_free_page(page)
>                                 // page is freed to the buddy
>                                 spin_unlock(&hugetlb_lock)
>     spin_lock(&hugetlb_lock)
>     clear_page_huge_active(page)
>     enqueue_huge_page(page)
>     // It is wrong, the page is already freed
>     spin_unlock(&hugetlb_lock)
> 
> The race windows is between put_page() and dissolve_free_huge_page().
> 
> We should make sure that the page is already on the free list
> when it is dissolved.
> 
> As a result __free_huge_page would corrupt page(s) already in the buddy
> allocator.
> 
> Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: stable@vger.kernel.org

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/hugetlb.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4741d60f8955..b99fe4a2b435 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -79,6 +79,21 @@ DEFINE_SPINLOCK(hugetlb_lock);
>  static int num_fault_mutexes;
>  struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
>  
> +static inline bool PageHugeFreed(struct page *head)
> +{
> +	return page_private(head + 4) == -1UL;
> +}
> +
> +static inline void SetPageHugeFreed(struct page *head)
> +{
> +	set_page_private(head + 4, -1UL);
> +}
> +
> +static inline void ClearPageHugeFreed(struct page *head)
> +{
> +	set_page_private(head + 4, 0);
> +}
> +
>  /* Forward declaration */
>  static int hugetlb_acct_memory(struct hstate *h, long delta);
>  
> @@ -1028,6 +1043,7 @@ static void enqueue_huge_page(struct hstate *h, struct page *page)
>  	list_move(&page->lru, &h->hugepage_freelists[nid]);
>  	h->free_huge_pages++;
>  	h->free_huge_pages_node[nid]++;
> +	SetPageHugeFreed(page);
>  }
>  
>  static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
> @@ -1044,6 +1060,7 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
>  
>  		list_move(&page->lru, &h->hugepage_activelist);
>  		set_page_refcounted(page);
> +		ClearPageHugeFreed(page);
>  		h->free_huge_pages--;
>  		h->free_huge_pages_node[nid]--;
>  		return page;
> @@ -1504,6 +1521,7 @@ static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
>  	spin_lock(&hugetlb_lock);
>  	h->nr_huge_pages++;
>  	h->nr_huge_pages_node[nid]++;
> +	ClearPageHugeFreed(page);
>  	spin_unlock(&hugetlb_lock);
>  }
>  
> @@ -1754,6 +1772,7 @@ int dissolve_free_huge_page(struct page *page)
>  {
>  	int rc = -EBUSY;
>  
> +retry:
>  	/* Not to disrupt normal path by vainly holding hugetlb_lock */
>  	if (!PageHuge(page))
>  		return 0;
> @@ -1770,6 +1789,26 @@ int dissolve_free_huge_page(struct page *page)
>  		int nid = page_to_nid(head);
>  		if (h->free_huge_pages - h->resv_huge_pages == 0)
>  			goto out;
> +
> +		/*
> +		 * We should make sure that the page is already on the free list
> +		 * when it is dissolved.
> +		 */
> +		if (unlikely(!PageHugeFreed(head))) {
> +			spin_unlock(&hugetlb_lock);
> +			cond_resched();
> +
> +			/*
> +			 * Theoretically, we should return -EBUSY when we
> +			 * encounter this race. In fact, we have a chance
> +			 * to successfully dissolve the page if we do a
> +			 * retry. Because the race window is quite small.
> +			 * If we seize this opportunity, it is an optimization
> +			 * for increasing the success rate of dissolving page.
> +			 */
> +			goto retry;
> +		}
> +
>  		/*
>  		 * Move PageHWPoison flag from head page to the raw error page,
>  		 * which makes any subpages rather than the error page reusable.
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBD92F61D2
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbhANNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 08:21:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:42714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbhANNVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 08:21:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610630437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mrq5I+QVlJUh9/9A4rAlfhWdMxXwrp+yU+zELor8u74=;
        b=O7imhw2XH9Wm0AmsDJ5+YI+xkcS6y4614S0zj6i5hTSBUELK/M1Ctkelsfzc5kZK/mYW6D
        0Djtx9FUfm+ZXamewmTQPbIzx63fdOeZZx8hBCVYr2nBN/idBttPkldPeHUqrf5OT89S5T
        Ir4cxxxpbVWts+p91kd3BwR3Gl9fahE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83A9FACB0;
        Thu, 14 Jan 2021 13:20:37 +0000 (UTC)
Date:   Thu, 14 Jan 2021 14:20:36 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5 3/5] mm: hugetlb: fix a race between freeing and
 dissolving the page
Message-ID: <20210114132036.GA27777@dhcp22.suse.cz>
References: <20210114103515.12955-1-songmuchun@bytedance.com>
 <20210114103515.12955-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114103515.12955-4-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 14-01-21 18:35:13, Muchun Song wrote:
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

Please describe user visible effects as suggested in
http://lkml.kernel.org/r/20210113093134.GU22493@dhcp22.suse.cz

> Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/hugetlb.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
[...]
> +retry:
>  	/* Not to disrupt normal path by vainly holding hugetlb_lock */
>  	if (!PageHuge(page))
>  		return 0;
> @@ -1770,6 +1789,28 @@ int dissolve_free_huge_page(struct page *page)
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
> +
> +			/*
> +			 * Theoretically, we should return -EBUSY when we
> +			 * encounter this race. In fact, we have a chance
> +			 * to successfully dissolve the page if we do a
> +			 * retry. Because the race window is quite small.
> +			 * If we seize this opportunity, it is an optimization
> +			 * for increasing the success rate of dissolving page.
> +			 */
> +			while (PageHeadHuge(head) && !PageHugeFreed(head))
> +				cond_resched();

Sorry, I should have raised that when replying to the previous version
already but we have focused more on other things. Is there any special
reason that you didn't simply
	if (!PageHugeFreed(head)) {
		spin_unlock(&hugetlb_lock);
		cond_resched();
		goto retry;
	}

This would be less code and a very slight advantage would be that the
waiter might get blocked on the spin lock while the concurrent freeing
is happening. But maybe you wanted to avoid exactly this contention?
Please put your thinking into the changelog.

> +
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

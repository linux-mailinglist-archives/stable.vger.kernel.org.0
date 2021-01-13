Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746882F47A0
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 10:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAMJcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 04:32:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:51220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbhAMJcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 04:32:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610530296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0TE8MKnmDo3Q30xN4tt6yxvQ6N8u1DSzcLaJ0wteucg=;
        b=C/YeCjaaeIBE95MvMP4f4ySuRAHJt8gowjXdlmD3OggLBLDDC/Dj8qjKtuvAzYQgNHynjX
        ptGwSuKrTH0NIZX7mODXgrPoX+rR3GBCptU9G+cNUkq1DcPWfDEJUnjXvNyygh/Iba/yTn
        5HMQQPhcEo+mj1OKKUQ5Qi32vso+2Ns=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 390CAAA6F;
        Wed, 13 Jan 2021 09:31:36 +0000 (UTC)
Date:   Wed, 13 Jan 2021 10:31:34 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 3/6] mm: hugetlb: fix a race between freeing and
 dissolving the page
Message-ID: <20210113093134.GU22493@dhcp22.suse.cz>
References: <20210113052209.75531-1-songmuchun@bytedance.com>
 <20210113052209.75531-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113052209.75531-4-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 13-01-21 13:22:06, Muchun Song wrote:
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

Please describe the effect of the bug.
"
As a result __free_huge_page would corrupt page(s) already in the buddy
allocator.
"

> 
> Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: stable@vger.kernel.org
[...]
> @@ -1770,6 +1788,14 @@ int dissolve_free_huge_page(struct page *page)
>  		int nid = page_to_nid(head);
>  		if (h->free_huge_pages - h->resv_huge_pages == 0)
>  			goto out;
> +
> +		/*
> +		 * We should make sure that the page is already on the free list
> +		 * when it is dissolved.
> +		 */
> +		if (unlikely(!PageHugeFreed(head)))
> +			goto out;

I believe we have agreed to retry for this temporary state.

> +
>  		/*
>  		 * Move PageHWPoison flag from head page to the raw error page,
>  		 * which makes any subpages rather than the error page reusable.
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs

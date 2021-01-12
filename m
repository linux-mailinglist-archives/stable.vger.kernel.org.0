Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016B42F2C1F
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389970AbhALKDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:03:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:39930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbhALKDB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 05:03:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610445734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0e07reIw7pfBWC0dCUh19wGPbV2A6U8xOjmqLsJlu84=;
        b=Qs3+4OQLR00NPBx3Vdha7HwXchsh0j72zCaXmAxMya+cD50z9gAXHh73TnKr16LH1RWHpJ
        +YmZYLtkWintwq6bs5OTWzVVp2SKLbTWsaNADNJjhArZ3OboQCNP4dS8/mgnYYVWdb/bMv
        nqcp2gTxIz7D9IosvTiDDda9cvHZoCA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0D8FBAF19;
        Tue, 12 Jan 2021 10:02:14 +0000 (UTC)
Date:   Tue, 12 Jan 2021 11:02:13 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 3/6] mm: hugetlb: fix a race between freeing and
 dissolving the page
Message-ID: <20210112100213.GK22493@dhcp22.suse.cz>
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110124017.86750-4-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 10-01-21 20:40:14, Muchun Song wrote:
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
> +

Do you really want to report EBUSY in this case? This doesn't make much
sense to me TBH. I believe you want to return 0 same as when you race
and the page is no longer PageHuge.

>  		/*
>  		 * Move PageHWPoison flag from head page to the raw error page,
>  		 * which makes any subpages rather than the error page reusable.
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs

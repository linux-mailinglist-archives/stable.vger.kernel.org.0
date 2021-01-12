Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B862F2B96
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 10:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbhALJqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 04:46:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:56478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730148AbhALJqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 04:46:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610444749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dA3k4t4NuRzP2rImbNYwbp5ThBFOnm8mec1oBsfxQUQ=;
        b=BUaJWqP9XW/TSzwKi8DEekpPSmcyhrX/viSiS/h2epyh/76Bogh/dVC18jHfq//hUYmGuk
        e3OFgU9dA4MOaGd5JZE8V1pLDxMq2PikOzCKeTZ2Wd9v9gpLZQD/es06UmOjMFaIiJRpaT
        hvN+7+NocU82RowqSurESFkl8SrepjA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C232BAD19;
        Tue, 12 Jan 2021 09:45:49 +0000 (UTC)
Date:   Tue, 12 Jan 2021 10:45:49 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/6] mm: hugetlbfs: fix cannot migrate the fallocated
 HugeTLB page
Message-ID: <20210112094549.GJ22493@dhcp22.suse.cz>
References: <20210110124017.86750-1-songmuchun@bytedance.com>
 <20210110124017.86750-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110124017.86750-3-songmuchun@bytedance.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 10-01-21 20:40:13, Muchun Song wrote:
> If a new hugetlb page is allocated during fallocate it will not be
> marked as active (set_page_huge_active) which will result in a later
> isolate_huge_page failure when the page migration code would like to
> move that page. Such a failure would be unexpected and wrong.
> 
> Only export set_page_huge_active, just leave clear_page_huge_active
> as static. Because there are no external users.
> 
> Fixes: 70c3547e36f5 (hugetlbfs: add hugetlbfs_fallocate())
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: stable@vger.kernel.org

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  fs/hugetlbfs/inode.c    | 3 ++-
>  include/linux/hugetlb.h | 2 ++
>  mm/hugetlb.c            | 2 +-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index b5c109703daa..21c20fd5f9ee 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -735,9 +735,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  
>  		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>  
> +		set_page_huge_active(page);
>  		/*
>  		 * unlock_page because locked by add_to_page_cache()
> -		 * page_put due to reference from alloc_huge_page()
> +		 * put_page() due to reference from alloc_huge_page()
>  		 */
>  		unlock_page(page);
>  		put_page(page);
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index ebca2ef02212..b5807f23caf8 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -770,6 +770,8 @@ static inline void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
>  }
>  #endif
>  
> +void set_page_huge_active(struct page *page);
> +
>  #else	/* CONFIG_HUGETLB_PAGE */
>  struct hstate {};
>  
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1f3bf1710b66..4741d60f8955 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1348,7 +1348,7 @@ bool page_huge_active(struct page *page)
>  }
>  
>  /* never called for tail page */
> -static void set_page_huge_active(struct page *page)
> +void set_page_huge_active(struct page *page)
>  {
>  	VM_BUG_ON_PAGE(!PageHeadHuge(page), page);
>  	SetPagePrivate(&page[1]);
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs

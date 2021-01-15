Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B782F7C71
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbhAONWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:22:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:40810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732113AbhAONWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 08:22:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 606C5AD18;
        Fri, 15 Jan 2021 13:22:16 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:22:13 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 3/5] mm: hugetlb: fix a race between freeing and
 dissolving the page
Message-ID: <20210115132209.GA10102@linux>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
 <20210115124942.46403-4-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115124942.46403-4-songmuchun@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 08:49:40PM +0800, Muchun Song wrote:
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

LGTM,

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE L3

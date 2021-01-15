Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB77E2F7C9B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbhAON1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:27:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:46762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730617AbhAON1Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 08:27:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE98FAC8F;
        Fri, 15 Jan 2021 13:27:00 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:26:58 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v6 4/5] mm: hugetlb: fix a race between isolating and
 freeing page
Message-ID: <20210115132658.GB10102@linux>
References: <20210115124942.46403-1-songmuchun@bytedance.com>
 <20210115124942.46403-5-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115124942.46403-5-songmuchun@bytedance.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 08:49:41PM +0800, Muchun Song wrote:
> There is a race between isolate_huge_page() and __free_huge_page().
> 
> CPU0:                                       CPU1:
> 
> if (PageHuge(page))
>                                             put_page(page)
>                                               __free_huge_page(page)
>                                                   spin_lock(&hugetlb_lock)
>                                                   update_and_free_page(page)
>                                                     set_compound_page_dtor(page,
>                                                       NULL_COMPOUND_DTOR)
>                                                   spin_unlock(&hugetlb_lock)
>   isolate_huge_page(page)
>     // trigger BUG_ON
>     VM_BUG_ON_PAGE(!PageHead(page), page)
>     spin_lock(&hugetlb_lock)
>     page_huge_active(page)
>       // trigger BUG_ON
>       VM_BUG_ON_PAGE(!PageHuge(page), page)
>     spin_unlock(&hugetlb_lock)
> 
> When we isolate a HugeTLB page on CPU0. Meanwhile, we free it to the
> buddy allocator on CPU1. Then, we can trigger a BUG_ON on CPU0. Because
> it is already freed to the buddy allocator.
> 
> Fixes: c8721bbbdd36 ("mm: memory-hotplug: enable memory hotplug to handle hugepage")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3

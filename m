Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E1D4D1974
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347181AbiCHNou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347183AbiCHNos (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:44:48 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DCB49C86;
        Tue,  8 Mar 2022 05:43:51 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KCc1t73BrzBrPS;
        Tue,  8 Mar 2022 21:41:54 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 21:43:49 +0800
Subject: Re: [PATCH] hugetlb: do not demote poisoned hugetlb pages
To:     Mike Kravetz <mike.kravetz@oracle.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
CC:     HORIGUCHI NAOYA <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>
References: <20220307215707.50916-1-mike.kravetz@oracle.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6ba788b3-901e-d740-2575-bc652461187b@huawei.com>
Date:   Tue, 8 Mar 2022 21:43:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220307215707.50916-1-mike.kravetz@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/3/8 5:57, Mike Kravetz wrote:
> It is possible for poisoned hugetlb pages to reside on the free lists.
> The huge page allocation routines which dequeue entries from the free
> lists make a point of avoiding poisoned pages.  There is no such check
> and avoidance in the demote code path.
> 
> If a hugetlb page on the is on a free list, poison will only be set in
> the head page rather then the page with the actual error.  If such a
> page is demoted, then the poison flag may follow the wrong page.  A page
> without error could have poison set, and a page with poison could not
> have the flag set.
> 
> Check for poison before attempting to demote a hugetlb page.  Also,
> return -EBUSY to the caller if only poisoned pages are on the free list.
> 
> Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/hugetlb.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index b34f50156f7e..f8ca7cca3c1a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3475,7 +3475,6 @@ static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
>  {
>  	int nr_nodes, node;
>  	struct page *page;
> -	int rc = 0;
>  
>  	lockdep_assert_held(&hugetlb_lock);
>  
> @@ -3486,15 +3485,19 @@ static int demote_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
>  	}
>  
>  	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
> -		if (!list_empty(&h->hugepage_freelists[node])) {
> -			page = list_entry(h->hugepage_freelists[node].next,
> -					struct page, lru);
> -			rc = demote_free_huge_page(h, page);
> -			break;
> +		list_for_each_entry(page, &h->hugepage_freelists[node], lru) {
> +			if (PageHWPoison(page))
> +				continue;
> +
> +			return demote_free_huge_page(h, page);

It seems this patch is not ideal. Memory failure can hit the hugetlb page anytime without
holding the hugetlb_lock. So the page might become HWPoison just after the check. But this
patch should have handled the common case. Many thanks for your work. :)

>  		}
>  	}
>  
> -	return rc;
> +	/*
> +	 * Only way to get here is if all pages on free lists are poisoned.
> +	 * Return -EBUSY so that caller will not retry.
> +	 */
> +	return -EBUSY;
>  }
>  
>  #define HSTATE_ATTR_RO(_name) \
> 


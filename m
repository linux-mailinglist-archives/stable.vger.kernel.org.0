Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3615B9373
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 06:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIOEEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 00:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIOEEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 00:04:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 422817969C;
        Wed, 14 Sep 2022 21:04:21 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17FC11682;
        Wed, 14 Sep 2022 21:04:27 -0700 (PDT)
Received: from [10.162.43.6] (unknown [10.162.43.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 105FB3F71A;
        Wed, 14 Sep 2022 21:04:17 -0700 (PDT)
Message-ID: <a6df1028-51e0-365d-c296-2896a3846c5d@arm.com>
Date:   Thu, 15 Sep 2022 09:34:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] mm/hugetlb: correct demote page offset logic
Content-Language: en-US
To:     Doug Berger <opendmb@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220914190917.3517663-1-opendmb@gmail.com>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20220914190917.3517663-1-opendmb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/15/22 00:39, Doug Berger wrote:
> With gigantic pages it may not be true that struct page structures
> are contiguous across the entire gigantic page. The nth_page macro
> is used here in place of direct pointer arithmetic to correct for
> this.
> 
> Fixes: 8531fc6f52f5 ("hugetlb: add hugetlb demote page support")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/hugetlb.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e070b8593b37..0bdfc7e1c933 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3420,6 +3420,7 @@ static int demote_free_huge_page(struct hstate *h, struct page *page)
>  {
>  	int i, nid = page_to_nid(page);
>  	struct hstate *target_hstate;
> +	struct page *subpage;
>  	int rc = 0;
>  
>  	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
> @@ -3453,15 +3454,16 @@ static int demote_free_huge_page(struct hstate *h, struct page *page)
>  	mutex_lock(&target_hstate->resize_lock);
>  	for (i = 0; i < pages_per_huge_page(h);
>  				i += pages_per_huge_page(target_hstate)) {
> +		subpage = nth_page(page, i);
>  		if (hstate_is_gigantic(target_hstate))
> -			prep_compound_gigantic_page_for_demote(page + i,
> +			prep_compound_gigantic_page_for_demote(subpage,
>  							target_hstate->order);
>  		else
> -			prep_compound_page(page + i, target_hstate->order);
> -		set_page_private(page + i, 0);
> -		set_page_refcounted(page + i);
> -		prep_new_huge_page(target_hstate, page + i, nid);
> -		put_page(page + i);
> +			prep_compound_page(subpage, target_hstate->order);
> +		set_page_private(subpage, 0);
> +		set_page_refcounted(subpage);
> +		prep_new_huge_page(target_hstate, subpage, nid);
> +		put_page(subpage);
>  	}
>  	mutex_unlock(&target_hstate->resize_lock);
>  

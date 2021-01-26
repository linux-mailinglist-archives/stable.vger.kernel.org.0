Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217DC30367B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 07:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbhAZGZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 01:25:59 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11877 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732496AbhAZGVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 01:21:12 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPxQG71Q8z7b5G;
        Tue, 26 Jan 2021 14:19:02 +0800 (CST)
Received: from [10.174.179.117] (10.174.179.117) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 14:20:10 +0800
Subject: Re: [PATCH] mm: hugetlb: fix missing put_page in
 gather_surplus_pages()
To:     Muchun Song <songmuchun@bytedance.com>
CC:     <sh_def@163.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <mike.kravetz@oracle.com>, <akpm@linux-foundation.org>
References: <20210126031009.96266-1-songmuchun@bytedance.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <becc96f8-9abd-21e1-337f-22b1cd7a9c96@huawei.com>
Date:   Tue, 26 Jan 2021 14:20:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210126031009.96266-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi:
On 2021/1/26 11:10, Muchun Song wrote:
> The VM_BUG_ON_PAGE avoids the generation of any code, even if that
> expression has side-effects when !CONFIG_DEBUG_VM.
> 
> Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/hugetlb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a6bad1f686c5..082ed643020b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2047,13 +2047,16 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  
>  	/* Free the needed pages to the hugetlb pool */
>  	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> +		int zeroed;
> +
>  		if ((--needed) < 0)
>  			break;
>  		/*
>  		 * This page is now managed by the hugetlb allocator and has
>  		 * no users -- drop the buddy allocator's reference.
>  		 */
> -		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
> +		zeroed = put_page_testzero(page);
> +		VM_BUG_ON_PAGE(!zeroed, page);
>  		enqueue_huge_page(h, page);
>  	}
>  free:
> 

Good Catch! Thanks.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

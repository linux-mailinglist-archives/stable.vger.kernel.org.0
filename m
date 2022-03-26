Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5454E7FD2
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 08:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiCZHuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 03:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiCZHue (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 03:50:34 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEFE3E5D8;
        Sat, 26 Mar 2022 00:48:56 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KQWFg0ZySz9swd;
        Sat, 26 Mar 2022 15:44:55 +0800 (CST)
Received: from [10.174.177.76] (10.174.177.76) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 15:48:53 +0800
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
To:     Rik van Riel <riel@surriel.com>
CC:     <linux-mm@kvack.org>, <kernel-team@fb.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20220325161428.5068d97e@imladris.surriel.com>
From:   Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e6aa40b9-1cd8-b13f-555b-5f8ad863f196@huawei.com>
Date:   Sat, 26 Mar 2022 15:48:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220325161428.5068d97e@imladris.surriel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.76]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

On 2022/3/26 4:14, Rik van Riel wrote:
> In some cases it appears the invalidation of a hwpoisoned page
> fails because the page is still mapped in another process. This
> can cause a program to be continuously restarted and die when
> it page faults on the page that was not invalidated. Avoid that
> problem by unmapping the hwpoisoned page when we find it.
> 
> Another issue is that sometimes we end up oopsing in finish_fault,
> if the code tries to do something with the now-NULL vmf->page.
> I did not hit this error when submitting the previous patch because
> there are several opportunities for alloc_set_pte to bail out before
> accessing vmf->page, and that apparently happened on those systems,
> and most of the time on other systems, too.
> 
> However, across several million systems that error does occur a
> handful of times a day. It can be avoided by returning VM_FAULT_NOPAGE
> which will cause do_read_fault to return before calling finish_fault.
> 
> Fixes: e53ac7374e64 ("mm: invalidate hwpoison page cache page in fault path")
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org
> ---
>  mm/memory.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index be44d0b36b18..76e3af9639d9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3918,14 +3918,18 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>  		return ret;
>  
>  	if (unlikely(PageHWPoison(vmf->page))) {
> +		struct page *page = vmf->page;
>  		vm_fault_t poisonret = VM_FAULT_HWPOISON;
>  		if (ret & VM_FAULT_LOCKED) {
> +			if (page_mapped(page))
> +				unmap_mapping_pages(page_mapping(page),
> +						    page->index, 1, false);

It seems this unmap_mapping_pages also helps the success rate of the below invalidate_inode_page.

>  			/* Retry if a clean page was removed from the cache. */
> -			if (invalidate_inode_page(vmf->page))
> -				poisonret = 0;
> -			unlock_page(vmf->page);
> +			if (invalidate_inode_page(page))
> +				poisonret = VM_FAULT_NOPAGE;
> +			unlock_page(page);
>  		}
> -		put_page(vmf->page);
> +		put_page(page);

Do we use page instead of vmf->page just for simplicity? Or there is some other concern?

>  		vmf->page = NULL;

We return either VM_FAULT_NOPAGE or VM_FAULT_HWPOISON with vmf->page = NULL. If any case,
finish_fault won't be called later. So I think your fix is right.

>  		return poisonret;
>  	}
> 

Many thanks for your patch.

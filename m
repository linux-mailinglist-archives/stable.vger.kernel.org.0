Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E7314154C
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 01:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgARA6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 19:58:00 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58802 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbgARA57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 19:57:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0To-chkr_1579309064;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0To-chkr_1579309064)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Jan 2020 08:57:54 +0800
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since this
 will not happen
To:     Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com
Cc:     cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        rientjes@google.com, stable@vger.kernel.org
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <e73272a8-87e9-5e22-4f78-588b640f4fc4@linux.alibaba.com>
Date:   Fri, 17 Jan 2020 16:57:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200117233836.3434-1-richardw.yang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/17/20 3:38 PM, Wei Yang wrote:
> If compound is true, this means it is a PMD mapped THP. Which implies
> the page is not linked to any defer list. So the first code chunk will
> not be executed.
>
> Also with this reason, it would not be proper to add this page to a
> defer list. So the second code chunk is not correct.
>
> Based on this, we should remove the defer list related code.
>
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
>
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: <stable@vger.kernel.org>    [5.4+]
>
> ---
> v4:
>    * finally we identified the related code is not necessary and not
>      correct, just remove it
>    * thanks to Kirill T first spot some problem

Thanks for debugging and figuring this out. Acked-by: Yang Shi 
<yang.shi@linux.alibaba.com>

> v3:
>    * remove all review/ack tag since rewrite the changelog
>    * use deferred_split_huge_page as the example of race
>    * add cc stable 5.4+ tag as suggested by David Rientjes
>
> v2:
>    * move check on compound outside suggested by Alexander
>    * an example of the race condition, suggested by Michal
> ---
>   mm/memcontrol.c | 18 ------------------
>   1 file changed, 18 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6c83cf4ed970..27c231bf4565 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5340,14 +5340,6 @@ static int mem_cgroup_move_account(struct page *page,
>   		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
>   	}
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && !list_empty(page_deferred_list(page))) {
> -		spin_lock(&from->deferred_split_queue.split_queue_lock);
> -		list_del_init(page_deferred_list(page));
> -		from->deferred_split_queue.split_queue_len--;
> -		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> -	}
> -#endif
>   	/*
>   	 * It is safe to change page->mem_cgroup here because the page
>   	 * is referenced, charged, and isolated - we can't race with
> @@ -5357,16 +5349,6 @@ static int mem_cgroup_move_account(struct page *page,
>   	/* caller should have done css_get */
>   	page->mem_cgroup = to;
>   
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (compound && list_empty(page_deferred_list(page))) {
> -		spin_lock(&to->deferred_split_queue.split_queue_lock);
> -		list_add_tail(page_deferred_list(page),
> -			      &to->deferred_split_queue.split_queue);
> -		to->deferred_split_queue.split_queue_len++;
> -		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> -	}
> -#endif
> -
>   	spin_unlock_irqrestore(&from->move_lock, flags);
>   
>   	ret = 0;


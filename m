Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5349014068E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgAQJm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:42:26 -0500
Received: from relay.sw.ru ([185.231.240.75]:50194 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgAQJmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 04:42:25 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1isNtV-0005s1-FT; Fri, 17 Jan 2020 12:26:21 +0300
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
To:     Michal Hocko <mhocko@kernel.org>,
        David Rientjes <rientjes@google.com>
Cc:     Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <b67fe2bb-e7a6-29fe-925e-dd1ae176cc4b@virtuozzo.com>
Date:   Fri, 17 Jan 2020 12:26:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200117091002.GM19428@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.01.2020 12:10, Michal Hocko wrote:
> On Thu 16-01-20 14:01:59, David Rientjes wrote:
>> On Thu, 16 Jan 2020, Kirill Tkhai wrote:
>>
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index c5b5f74cfd4d..6450bbe394e2 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -5360,10 +5360,12 @@ static int 	(struct page *page,
>>>>  	}
>>>>  
>>>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> -	if (compound && !list_empty(page_deferred_list(page))) {
>>>> +	if (compound) {
>>>>  		spin_lock(&from->deferred_split_queue.split_queue_lock);
>>>> -		list_del_init(page_deferred_list(page));
>>>> -		from->deferred_split_queue.split_queue_len--;
>>>> +		if (!list_empty(page_deferred_list(page))) {
>>>> +			list_del_init(page_deferred_list(page));
>>>> +			from->deferred_split_queue.split_queue_len--;
>>>> +		}
>>>>  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>>>>  	}
>>>>  #endif
>>>> @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
>>>>  	page->mem_cgroup = to;
>>>>  
>>>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> -	if (compound && list_empty(page_deferred_list(page))) {
>>>> +	if (compound) {
>>>>  		spin_lock(&to->deferred_split_queue.split_queue_lock);
>>>> -		list_add_tail(page_deferred_list(page),
>>>> -			      &to->deferred_split_queue.split_queue);
>>>> -		to->deferred_split_queue.split_queue_len++;
>>>> +		if (list_empty(page_deferred_list(page))) {
>>>> +			list_add_tail(page_deferred_list(page),
>>>> +				      &to->deferred_split_queue.split_queue);
>>>> +			to->deferred_split_queue.split_queue_len++;
>>>> +		}
>>>>  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
>>>>  	}
>>>>  #endif
>>>
>>> The patch looks OK for me. But there is another question. I forget, why we unconditionally
>>> add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
>>> it was initially in the list? Something like:
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index d4394ae4e5be..0be0136adaa6 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
>>>  	struct pglist_data *pgdat;
>>>  	unsigned long flags;
>>>  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
>>> +	bool split = false;
>>>  	int ret;
>>>  	bool anon;
>>>  
>>> @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
>>>  		if (!list_empty(page_deferred_list(page))) {
>>>  			list_del_init(page_deferred_list(page));
>>>  			from->deferred_split_queue.split_queue_len--;
>>> +			split = true;
>>>  		}
>>>  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>>>  	}
>>> @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
>>>  	page->mem_cgroup = to;
>>>  
>>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> -	if (compound) {
>>> +	if (compound && split) {
>>>  		spin_lock(&to->deferred_split_queue.split_queue_lock);
>>>  		if (list_empty(page_deferred_list(page))) {
>>>  			list_add_tail(page_deferred_list(page),
>>>
>>
>> I think that's a good point, especially considering that the current code 
>> appears to unconditionally place any compound page on the deferred split 
>> queue of the destination memcg.  The correct list that it should appear 
>> on, I believe, depends on whether the pmd has been split for the process 
>> being moved: note the MC_TARGET_PAGE caveat in 
>> mem_cgroup_move_charge_pte_range() that does not move the charge for 
>> compound pages with split pmds.  So when mem_cgroup_move_account() is 
>> called with compound == true, we're moving the charge of the entire 
>> compound page: why would it appear on that memcg's deferred split queue?
> 
> I believe Kirill asked how do we know that the page should be actually
> added to the deferred list just from the list_empty check. In other
> words what if the page hasn't been split at all?

Yes, I'm talking about this. Function mem_cgroup_move_account() adds every
huge page to the deferred list, while we need to do that only for pages,
which are queued for splitting...

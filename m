Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D399140119
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732701AbgAQAr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 19:47:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:37145 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgAQAr3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 19:47:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 16:47:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,327,1574150400"; 
   d="scan'208";a="306066002"
Received: from unknown (HELO localhost) ([10.239.159.54])
  by orsmga001.jf.intel.com with ESMTP; 16 Jan 2020 16:47:24 -0800
Date:   Fri, 17 Jan 2020 08:47:35 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     David Rientjes <rientjes@google.com>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        yang.shi@linux.alibaba.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Message-ID: <20200117004735.GA16207@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 02:01:59PM -0800, David Rientjes wrote:
>On Thu, 16 Jan 2020, Kirill Tkhai wrote:
>
>> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > index c5b5f74cfd4d..6450bbe394e2 100644
>> > --- a/mm/memcontrol.c
>> > +++ b/mm/memcontrol.c
>> > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
>> >  	}
>> >  
>> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> > -	if (compound && !list_empty(page_deferred_list(page))) {
>> > +	if (compound) {
>> >  		spin_lock(&from->deferred_split_queue.split_queue_lock);
>> > -		list_del_init(page_deferred_list(page));
>> > -		from->deferred_split_queue.split_queue_len--;
>> > +		if (!list_empty(page_deferred_list(page))) {
>> > +			list_del_init(page_deferred_list(page));
>> > +			from->deferred_split_queue.split_queue_len--;
>> > +		}
>> >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>> >  	}
>> >  #endif
>> > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
>> >  	page->mem_cgroup = to;
>> >  
>> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> > -	if (compound && list_empty(page_deferred_list(page))) {
>> > +	if (compound) {
>> >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
>> > -		list_add_tail(page_deferred_list(page),
>> > -			      &to->deferred_split_queue.split_queue);
>> > -		to->deferred_split_queue.split_queue_len++;
>> > +		if (list_empty(page_deferred_list(page))) {
>> > +			list_add_tail(page_deferred_list(page),
>> > +				      &to->deferred_split_queue.split_queue);
>> > +			to->deferred_split_queue.split_queue_len++;
>> > +		}
>> >  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
>> >  	}
>> >  #endif
>> 
>> The patch looks OK for me. But there is another question. I forget, why we unconditionally
>> add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
>> it was initially in the list? Something like:
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index d4394ae4e5be..0be0136adaa6 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
>>  	struct pglist_data *pgdat;
>>  	unsigned long flags;
>>  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
>> +	bool split = false;
>>  	int ret;
>>  	bool anon;
>>  
>> @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
>>  		if (!list_empty(page_deferred_list(page))) {
>>  			list_del_init(page_deferred_list(page));
>>  			from->deferred_split_queue.split_queue_len--;
>> +			split = true;
>>  		}
>>  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>>  	}
>> @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
>>  	page->mem_cgroup = to;
>>  
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	if (compound) {
>> +	if (compound && split) {
>>  		spin_lock(&to->deferred_split_queue.split_queue_lock);
>>  		if (list_empty(page_deferred_list(page))) {
>>  			list_add_tail(page_deferred_list(page),
>> 
>
>I think that's a good point, especially considering that the current code 
>appears to unconditionally place any compound page on the deferred split 
>queue of the destination memcg.  The correct list that it should appear 
>on, I believe, depends on whether the pmd has been split for the process 
>being moved: note the MC_TARGET_PAGE caveat in 
>mem_cgroup_move_charge_pte_range() that does not move the charge for 
>compound pages with split pmds.  So when mem_cgroup_move_account() is 
>called with compound == true, we're moving the charge of the entire 
>compound page: why would it appear on that memcg's deferred split queue?

Well, Kirill's change is easy to understand, while your statement here is a
bit hard for me. Seems I lack some knowledge about cgroup. I am sorry about
this. :-(

-- 
Wei Yang
Help you, Help me

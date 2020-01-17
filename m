Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389D4141402
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 23:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgAQWU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 17:20:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:16792 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbgAQWU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 17:20:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 14:18:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="424631108"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jan 2020 14:18:48 -0800
Date:   Sat, 18 Jan 2020 06:18:59 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Message-ID: <20200117221859.GA29229@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001170125350.20618@chino.kir.corp.google.com>
 <20200117153839.pcnfomzuaha3dafh@box>
 <4d117021-da90-6069-1991-4df2249567f8@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d117021-da90-6069-1991-4df2249567f8@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 11:17:38AM -0800, Yang Shi wrote:
>
>
>On 1/17/20 7:38 AM, Kirill A. Shutemov wrote:
>> On Fri, Jan 17, 2020 at 01:31:50AM -0800, David Rientjes wrote:
>> > On Fri, 17 Jan 2020, Michal Hocko wrote:
>> > 
>> > > On Thu 16-01-20 14:01:59, David Rientjes wrote:
>> > > > On Thu, 16 Jan 2020, Kirill Tkhai wrote:
>> > > > 
>> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > > > > > index c5b5f74cfd4d..6450bbe394e2 100644
>> > > > > > --- a/mm/memcontrol.c
>> > > > > > +++ b/mm/memcontrol.c
>> > > > > > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
>> > > > > >   	}
>> > > > > >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> > > > > > -	if (compound && !list_empty(page_deferred_list(page))) {
>> > > > > > +	if (compound) {
>> > > > > >   		spin_lock(&from->deferred_split_queue.split_queue_lock);
>> > > > > > -		list_del_init(page_deferred_list(page));
>> > > > > > -		from->deferred_split_queue.split_queue_len--;
>> > > > > > +		if (!list_empty(page_deferred_list(page))) {
>> > > > > > +			list_del_init(page_deferred_list(page));
>> > > > > > +			from->deferred_split_queue.split_queue_len--;
>> > > > > > +		}
>> > > > > >   		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>> > > > > >   	}
>> > > > > >   #endif
>> > > > > > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
>> > > > > >   	page->mem_cgroup = to;
>> > > > > >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> > > > > > -	if (compound && list_empty(page_deferred_list(page))) {
>> > > > > > +	if (compound) {
>> > > > > >   		spin_lock(&to->deferred_split_queue.split_queue_lock);
>> > > > > > -		list_add_tail(page_deferred_list(page),
>> > > > > > -			      &to->deferred_split_queue.split_queue);
>> > > > > > -		to->deferred_split_queue.split_queue_len++;
>> > > > > > +		if (list_empty(page_deferred_list(page))) {
>> > > > > > +			list_add_tail(page_deferred_list(page),
>> > > > > > +				      &to->deferred_split_queue.split_queue);
>> > > > > > +			to->deferred_split_queue.split_queue_len++;
>> > > > > > +		}
>> > > > > >   		spin_unlock(&to->deferred_split_queue.split_queue_lock);
>> > > > > >   	}
>> > > > > >   #endif
>> > > > > The patch looks OK for me. But there is another question. I forget, why we unconditionally
>> > > > > add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
>> > > > > it was initially in the list? Something like:
>> > > > > 
>> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > > > > index d4394ae4e5be..0be0136adaa6 100644
>> > > > > --- a/mm/memcontrol.c
>> > > > > +++ b/mm/memcontrol.c
>> > > > > @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
>> > > > >   	struct pglist_data *pgdat;
>> > > > >   	unsigned long flags;
>> > > > >   	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
>> > > > > +	bool split = false;
>> > > > >   	int ret;
>> > > > >   	bool anon;
>> > > > > @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
>> > > > >   		if (!list_empty(page_deferred_list(page))) {
>> > > > >   			list_del_init(page_deferred_list(page));
>> > > > >   			from->deferred_split_queue.split_queue_len--;
>> > > > > +			split = true;
>> > > > >   		}
>> > > > >   		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>> > > > >   	}
>> > > > > @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
>> > > > >   	page->mem_cgroup = to;
>> > > > >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> > > > > -	if (compound) {
>> > > > > +	if (compound && split) {
>> > > > >   		spin_lock(&to->deferred_split_queue.split_queue_lock);
>> > > > >   		if (list_empty(page_deferred_list(page))) {
>> > > > >   			list_add_tail(page_deferred_list(page),
>> > > > > 
>> > > > I think that's a good point, especially considering that the current code
>> > > > appears to unconditionally place any compound page on the deferred split
>> > > > queue of the destination memcg.  The correct list that it should appear
>> > > > on, I believe, depends on whether the pmd has been split for the process
>> > > > being moved: note the MC_TARGET_PAGE caveat in
>> > > > mem_cgroup_move_charge_pte_range() that does not move the charge for
>> > > > compound pages with split pmds.  So when mem_cgroup_move_account() is
>> > > > called with compound == true, we're moving the charge of the entire
>> > > > compound page: why would it appear on that memcg's deferred split queue?
>> > > I believe Kirill asked how do we know that the page should be actually
>> > > added to the deferred list just from the list_empty check. In other
>> > > words what if the page hasn't been split at all?
>> > > 
>> > Right, and I don't think that it necessarily is and the second
>> > conditional in Wei's patch will always succeed unless we have raced.  That
>> > patch is for a lock concern but I think Kirill's question has uncovered
>> > something more interesting.
>> > 
>> > Kirill S would definitely be best to answer Kirill T's question, but from
>> > my understanding when mem_cgroup_move_account() is called with
>> > compound == true that we always have an intact pmd (we never migrate
>> > partial page charges for pages on the deferred split queue with the
>> > current charge migration implementation) and thus the underlying page is
>> > not eligible to be split and shouldn't be on the deferred split queue.
>> > 
>> > In other words, a page being on the deferred split queue for a memcg
>> > should only happen when it is charged to that memcg.  (This wasn't the
>> > case when we only had per-node split queues.)  I think that's currently
>> > broken in mem_cgroup_move_account() before Wei's patch.
>> Right. It's broken indeed.
>
>Hmm... Yes, definitely. I wasn't realized this at the first place.
>
>> 
>> We are dealing with anon page here. And it cannot be on deferred list as
>> long as it's mapped with PMD. We cannot get compound == true &&
>> !list_empty() on the (first) enter to the function. Any PMD-mapped page
>> will be put onto deferred by the function. This is wrong.
>> 
>> The fix is not obvious.
>> 
>> This comment got in mem_cgroup_move_charge_pte_range() my attention:
>> 
>> 			/*
>> 			 * We can have a part of the split pmd here. Moving it
>> 			 * can be done but it would be too convoluted so simply
>> 			 * ignore such a partial THP and keep it in original
>> 			 * memcg. There should be somebody mapping the head.
>> 			 */
>> 
>> That's exactly the case we care about: PTE-mapped THP that has to be split
>> under load. We don't move charge of them between memcgs and therefore we
>> should not move the page to different memcg.
>> 
>> I guess this will do the trick :P
>
>It seems correct to me. In addition, memcg move charge just move PMD mapped
>THP, the THP should be never on the deferred split queue of "from" if it is
>PMD mapped, so actually we don't have to move it to the deferred split queue
>of "to".
>

Well, I got the point.

Since Kirill S found the correct solution, should I prepare v3 or Kirill will
send it?

>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c5b5f74cfd4d..e87ee4c10f6e 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5359,14 +5359,6 @@ static int mem_cgroup_move_account(struct page *page,
>>   		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
>>   	}
>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	if (compound && !list_empty(page_deferred_list(page))) {
>> -		spin_lock(&from->deferred_split_queue.split_queue_lock);
>> -		list_del_init(page_deferred_list(page));
>> -		from->deferred_split_queue.split_queue_len--;
>> -		spin_unlock(&from->deferred_split_queue.split_queue_lock);
>> -	}
>> -#endif
>>   	/*
>>   	 * It is safe to change page->mem_cgroup here because the page
>>   	 * is referenced, charged, and isolated - we can't race with
>> @@ -5376,16 +5368,6 @@ static int mem_cgroup_move_account(struct page *page,
>>   	/* caller should have done css_get */
>>   	page->mem_cgroup = to;
>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	if (compound && list_empty(page_deferred_list(page))) {
>> -		spin_lock(&to->deferred_split_queue.split_queue_lock);
>> -		list_add_tail(page_deferred_list(page),
>> -			      &to->deferred_split_queue.split_queue);
>> -		to->deferred_split_queue.split_queue_len++;
>> -		spin_unlock(&to->deferred_split_queue.split_queue_lock);
>> -	}
>> -#endif
>> -
>>   	spin_unlock_irqrestore(&from->move_lock, flags);
>>   	ret = 0;

-- 
Wei Yang
Help you, Help me

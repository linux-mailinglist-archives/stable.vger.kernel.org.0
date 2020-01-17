Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849DB140646
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgAQJhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:37:32 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46263 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgAQJhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:37:32 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so20751446ilm.13
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 01:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=QA3liVZQ//A8v0S8gslClqjh5Qy88hxNQ2Z93K52ofg=;
        b=vs5R2hhwKO56EZKTxJZ5z0B18rX5CF/+KxhBFMGO4SJt8OdMwZ5ykw+ezhdfR4nDfq
         DxvVcHVIhvEWOmWtzZkS/Hqfl+9Wthba8RgOKCDsjtdaBCySD4N0tMtho22a+3YIXTB6
         B1vV29o/GYIBpXxdayIK/bot6FhJFJ1quM3w/sA2sWfktLsoUXDeQX/sFRA4OOLm/TlK
         /vRbVTiTUnsUUzFjvxrmgXuvqAOjCHonzvjxWAFMiF0Dzf2fmARMOlhTyXXVNAGJQVn+
         5Q/BOy+nvcDlWxXwIpqI8pZBjlGv0BvJgdw+/OAT09SraxZ0Ogn28wnB97xXgVXkgKfa
         5VGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=QA3liVZQ//A8v0S8gslClqjh5Qy88hxNQ2Z93K52ofg=;
        b=SWdysDK4qzyuaTVkQ+XZeEl3cU7weqJSK77neKgGJL9iRhBnAiCMPn49Pnb+t+edWT
         m0cy+AJJX7Z8nSBH9lZwPO3Fsd5rzCLxZkOHlKgrt1b1oNTE9/pVl8gHaEHYPpCWNIc/
         8Ngyky+De0DZek8ZIuZotb4hkE1Zv2Mu3sbQc5shyp2QnWJQIhYqqqasAbNVDi/nJ83l
         BcRH/8KW8yTwMqSpSVTSlRQDmGbahfnkGA6GltQDqUuxfKXkCBr1o+8rhvJ/f74AhAhb
         gtqlnkO5v/nqbRXu7D16Ypu1oG/MPFUFjk4mTmStxkAsxbNq/GR7m8B8CUIGI+TXoFRA
         lYUQ==
X-Gm-Message-State: APjAAAWnQHyN0tnzC9di1i7ZkVAlYFTQd7qRjbvJ8UipiinCxs08gWmY
        zM4j0t9/xTVovJx2981/maqcWfBBV78=
X-Google-Smtp-Source: APXvYqwz3HekrbkmdtcEbR1VmpXsc0SwALfwaNRL0wyMGU2wkWobLlXrFQo7CpzHaSoY4qb9QPl5gQ==
X-Received: by 2002:a63:1106:: with SMTP id g6mr43863751pgl.13.1579253512065;
        Fri, 17 Jan 2020 01:31:52 -0800 (PST)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id w187sm29499070pfw.62.2020.01.17.01.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:31:51 -0800 (PST)
Date:   Fri, 17 Jan 2020 01:31:50 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Michal Hocko <mhocko@kernel.org>
cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer
 list
In-Reply-To: <20200117091002.GM19428@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.21.2001170125350.20618@chino.kir.corp.google.com>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com> <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com> <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com> <20200117091002.GM19428@dhcp22.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 17 Jan 2020, Michal Hocko wrote:

> On Thu 16-01-20 14:01:59, David Rientjes wrote:
> > On Thu, 16 Jan 2020, Kirill Tkhai wrote:
> > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index c5b5f74cfd4d..6450bbe394e2 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
> > > >  	}
> > > >  
> > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > -	if (compound && !list_empty(page_deferred_list(page))) {
> > > > +	if (compound) {
> > > >  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> > > > -		list_del_init(page_deferred_list(page));
> > > > -		from->deferred_split_queue.split_queue_len--;
> > > > +		if (!list_empty(page_deferred_list(page))) {
> > > > +			list_del_init(page_deferred_list(page));
> > > > +			from->deferred_split_queue.split_queue_len--;
> > > > +		}
> > > >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> > > >  	}
> > > >  #endif
> > > > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
> > > >  	page->mem_cgroup = to;
> > > >  
> > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > -	if (compound && list_empty(page_deferred_list(page))) {
> > > > +	if (compound) {
> > > >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > > > -		list_add_tail(page_deferred_list(page),
> > > > -			      &to->deferred_split_queue.split_queue);
> > > > -		to->deferred_split_queue.split_queue_len++;
> > > > +		if (list_empty(page_deferred_list(page))) {
> > > > +			list_add_tail(page_deferred_list(page),
> > > > +				      &to->deferred_split_queue.split_queue);
> > > > +			to->deferred_split_queue.split_queue_len++;
> > > > +		}
> > > >  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> > > >  	}
> > > >  #endif
> > > 
> > > The patch looks OK for me. But there is another question. I forget, why we unconditionally
> > > add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
> > > it was initially in the list? Something like:
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index d4394ae4e5be..0be0136adaa6 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
> > >  	struct pglist_data *pgdat;
> > >  	unsigned long flags;
> > >  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
> > > +	bool split = false;
> > >  	int ret;
> > >  	bool anon;
> > >  
> > > @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
> > >  		if (!list_empty(page_deferred_list(page))) {
> > >  			list_del_init(page_deferred_list(page));
> > >  			from->deferred_split_queue.split_queue_len--;
> > > +			split = true;
> > >  		}
> > >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> > >  	}
> > > @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
> > >  	page->mem_cgroup = to;
> > >  
> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	if (compound) {
> > > +	if (compound && split) {
> > >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > >  		if (list_empty(page_deferred_list(page))) {
> > >  			list_add_tail(page_deferred_list(page),
> > > 
> > 
> > I think that's a good point, especially considering that the current code 
> > appears to unconditionally place any compound page on the deferred split 
> > queue of the destination memcg.  The correct list that it should appear 
> > on, I believe, depends on whether the pmd has been split for the process 
> > being moved: note the MC_TARGET_PAGE caveat in 
> > mem_cgroup_move_charge_pte_range() that does not move the charge for 
> > compound pages with split pmds.  So when mem_cgroup_move_account() is 
> > called with compound == true, we're moving the charge of the entire 
> > compound page: why would it appear on that memcg's deferred split queue?
> 
> I believe Kirill asked how do we know that the page should be actually
> added to the deferred list just from the list_empty check. In other
> words what if the page hasn't been split at all?
> 

Right, and I don't think that it necessarily is and the second 
conditional in Wei's patch will always succeed unless we have raced.  That 
patch is for a lock concern but I think Kirill's question has uncovered 
something more interesting.

Kirill S would definitely be best to answer Kirill T's question, but from 
my understanding when mem_cgroup_move_account() is called with 
compound == true that we always have an intact pmd (we never migrate 
partial page charges for pages on the deferred split queue with the 
current charge migration implementation) and thus the underlying page is 
not eligible to be split and shouldn't be on the deferred split queue.

In other words, a page being on the deferred split queue for a memcg 
should only happen when it is charged to that memcg.  (This wasn't the 
case when we only had per-node split queues.)  I think that's currently 
broken in mem_cgroup_move_account() before Wei's patch.

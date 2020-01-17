Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9131405D9
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgAQJKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:10:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52798 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgAQJKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:10:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so6644131wmc.2;
        Fri, 17 Jan 2020 01:10:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qOAMOjVIT0Dy7HI3yT3GvFvQG+nWIqkGdWAkQAANxIs=;
        b=i3VC2hk3c7Q3umUhqRHyLDAyLAgkubw4cZCh4mKyXs61HhZD1+5VQ3YTpUu236ei0Z
         SKQHO6whSmioWOc3uUnzFp1/1pLdx//nOGxriKznClIeyHUjHOiKJs7nOD3IryBDu1Wm
         28jxbHcQdOY4uLODGBSBGBy3rfSxnFMFyBqp/z3qdPrWmDwXWEHcwsPNcHUqmRyl0c+6
         D8rNUWZauarKWpNJ8QJhaF3o5I258UQKQZ4Nb8GRhWpGutoO5pThxchuBFtC2g/8fQZ4
         JloFRzFtEw8/V9tLLAMP+O6qmY/JzYAi8PaYGd6SwG6+0NjInFCWAA9BGOf/vXe9r+92
         EPyA==
X-Gm-Message-State: APjAAAUgWwxA98muPFLoYFTWX7D198/tpo30uCMbrEqTD86xHV2qcKy4
        2U5wwi/ijU2UsrwR6evUAQg=
X-Google-Smtp-Source: APXvYqxXrq0ijHEf/PD9PkyhW0nrCXshQ4ZYmw0U20Dw/jgMjbfIqhSoiXZ5+/XBrR3qI7+rqI7Ndg==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr3683767wmj.117.1579252204153;
        Fri, 17 Jan 2020 01:10:04 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id x132sm2683366wmg.0.2020.01.17.01.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:10:03 -0800 (PST)
Date:   Fri, 17 Jan 2020 10:10:02 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     David Rientjes <rientjes@google.com>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Message-ID: <20200117091002.GM19428@dhcp22.suse.cz>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 16-01-20 14:01:59, David Rientjes wrote:
> On Thu, 16 Jan 2020, Kirill Tkhai wrote:
> 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index c5b5f74cfd4d..6450bbe394e2 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
> > >  	}
> > >  
> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	if (compound && !list_empty(page_deferred_list(page))) {
> > > +	if (compound) {
> > >  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> > > -		list_del_init(page_deferred_list(page));
> > > -		from->deferred_split_queue.split_queue_len--;
> > > +		if (!list_empty(page_deferred_list(page))) {
> > > +			list_del_init(page_deferred_list(page));
> > > +			from->deferred_split_queue.split_queue_len--;
> > > +		}
> > >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> > >  	}
> > >  #endif
> > > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
> > >  	page->mem_cgroup = to;
> > >  
> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > -	if (compound && list_empty(page_deferred_list(page))) {
> > > +	if (compound) {
> > >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > > -		list_add_tail(page_deferred_list(page),
> > > -			      &to->deferred_split_queue.split_queue);
> > > -		to->deferred_split_queue.split_queue_len++;
> > > +		if (list_empty(page_deferred_list(page))) {
> > > +			list_add_tail(page_deferred_list(page),
> > > +				      &to->deferred_split_queue.split_queue);
> > > +			to->deferred_split_queue.split_queue_len++;
> > > +		}
> > >  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> > >  	}
> > >  #endif
> > 
> > The patch looks OK for me. But there is another question. I forget, why we unconditionally
> > add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
> > it was initially in the list? Something like:
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d4394ae4e5be..0be0136adaa6 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
> >  	struct pglist_data *pgdat;
> >  	unsigned long flags;
> >  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
> > +	bool split = false;
> >  	int ret;
> >  	bool anon;
> >  
> > @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
> >  		if (!list_empty(page_deferred_list(page))) {
> >  			list_del_init(page_deferred_list(page));
> >  			from->deferred_split_queue.split_queue_len--;
> > +			split = true;
> >  		}
> >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> >  	}
> > @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
> >  	page->mem_cgroup = to;
> >  
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > -	if (compound) {
> > +	if (compound && split) {
> >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> >  		if (list_empty(page_deferred_list(page))) {
> >  			list_add_tail(page_deferred_list(page),
> > 
> 
> I think that's a good point, especially considering that the current code 
> appears to unconditionally place any compound page on the deferred split 
> queue of the destination memcg.  The correct list that it should appear 
> on, I believe, depends on whether the pmd has been split for the process 
> being moved: note the MC_TARGET_PAGE caveat in 
> mem_cgroup_move_charge_pte_range() that does not move the charge for 
> compound pages with split pmds.  So when mem_cgroup_move_account() is 
> called with compound == true, we're moving the charge of the entire 
> compound page: why would it appear on that memcg's deferred split queue?

I believe Kirill asked how do we know that the page should be actually
added to the deferred list just from the list_empty check. In other
words what if the page hasn't been split at all?

-- 
Michal Hocko
SUSE Labs

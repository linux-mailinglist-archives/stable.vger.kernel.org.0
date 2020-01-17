Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7099F140E00
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 16:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAQPir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 10:38:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38358 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbgAQPio (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 10:38:44 -0500
Received: by mail-lf1-f66.google.com with SMTP id r14so18686962lfm.5
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 07:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5CjcNzOgQBmyIcnlhVOCHh9LmCSADzB4xHyoB2q1Vjs=;
        b=1+vrAV7y4/yxDZYqJkvlHyCZRpYBgGdFyxJ7KIeKbpHtoUPDOyPX6e7BIM7zwU4DLL
         0EM5K9CR2K6Im20ZKgF3p8ZeRE4e83kp+T4XK2JgU3GSOqJok0G8UfPYz3hNQaunRGVr
         MfEDAbb74mdg+cUIdfYnA/gHmah0ng091NQv3qNjxB4tir/aLyyRHdqkg1qNfMMv/5af
         ZWfu7kcfP8Vu3FPEFUh5Y8bPghSo/bgWGg9OihgLXVvh7uLAghuBEhYcCgDKoE50EINe
         xUpPhsJ41KiezPUpHha861faGDxWqLfPdKcK5VpstLgrSvF2edmeSkakgXNRFIMoTvGJ
         4anQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5CjcNzOgQBmyIcnlhVOCHh9LmCSADzB4xHyoB2q1Vjs=;
        b=EFNu7F0NSbbcaoVhnEn2AksV3rwpdWFdhEZeSL4RfdnCXiMNKdEQwJnY7oE+D7SV5m
         mueaipVOYCsdkftVa6YmeHVGh1qP2bXoRmJwgDb83F5EX8ltXizfplL9AlqvsuIur/hy
         MT78U6XqE1ImCzXYuI1e4M0VWBsSgEc9X1h1j23yL08kdBQ98jmMnEAXDyrAW4I7YP4y
         9QsonXCn5lqNVC30S0Q5Z3ehN55NOFLGneuiHWrLGYlNESRmrE1UKU8lv5scsiRtISMG
         6FnUrLSg+IREnHt+pqi5xiPhBvIEdhS3+isB69XeXjRPJ07Om5O/8t17PmpLhmmB1K7p
         nSbg==
X-Gm-Message-State: APjAAAVkE3M61M9TkXJ+1bAxBJPrqw4BGn8usySGyqJy3ogHdrfbhjhG
        12l1r9d8XXO+7NXQV9fAwQ/IDg==
X-Google-Smtp-Source: APXvYqxeLCT+DVj/bGz04HP9ZT+9/kuBFxjk65y0imKgWabVrU4gDpiUO1q9DXMYRGZMlCOv/mu48Q==
X-Received: by 2002:ac2:5310:: with SMTP id c16mr5840165lfh.102.1579275521366;
        Fri, 17 Jan 2020 07:38:41 -0800 (PST)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id h19sm12546149ljl.57.2020.01.17.07.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 07:38:40 -0800 (PST)
Received: by box.localdomain (Postfix, from userid 1000)
        id A58C1100CFF; Fri, 17 Jan 2020 18:38:39 +0300 (+03)
Date:   Fri, 17 Jan 2020 18:38:39 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     David Rientjes <rientjes@google.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v3] mm: thp: grab the lock before manipulation defer list
Message-ID: <20200117153839.pcnfomzuaha3dafh@box>
References: <20200116013100.7679-1-richardw.yang@linux.intel.com>
 <0bb34c4a-97c7-0b3c-cf43-8af6cf9c4396@virtuozzo.com>
 <alpine.DEB.2.21.2001161357240.109233@chino.kir.corp.google.com>
 <20200117091002.GM19428@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001170125350.20618@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001170125350.20618@chino.kir.corp.google.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 01:31:50AM -0800, David Rientjes wrote:
> On Fri, 17 Jan 2020, Michal Hocko wrote:
> 
> > On Thu 16-01-20 14:01:59, David Rientjes wrote:
> > > On Thu, 16 Jan 2020, Kirill Tkhai wrote:
> > > 
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index c5b5f74cfd4d..6450bbe394e2 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
> > > > >  	}
> > > > >  
> > > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > > -	if (compound && !list_empty(page_deferred_list(page))) {
> > > > > +	if (compound) {
> > > > >  		spin_lock(&from->deferred_split_queue.split_queue_lock);
> > > > > -		list_del_init(page_deferred_list(page));
> > > > > -		from->deferred_split_queue.split_queue_len--;
> > > > > +		if (!list_empty(page_deferred_list(page))) {
> > > > > +			list_del_init(page_deferred_list(page));
> > > > > +			from->deferred_split_queue.split_queue_len--;
> > > > > +		}
> > > > >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> > > > >  	}
> > > > >  #endif
> > > > > @@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
> > > > >  	page->mem_cgroup = to;
> > > > >  
> > > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > > -	if (compound && list_empty(page_deferred_list(page))) {
> > > > > +	if (compound) {
> > > > >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > > > > -		list_add_tail(page_deferred_list(page),
> > > > > -			      &to->deferred_split_queue.split_queue);
> > > > > -		to->deferred_split_queue.split_queue_len++;
> > > > > +		if (list_empty(page_deferred_list(page))) {
> > > > > +			list_add_tail(page_deferred_list(page),
> > > > > +				      &to->deferred_split_queue.split_queue);
> > > > > +			to->deferred_split_queue.split_queue_len++;
> > > > > +		}
> > > > >  		spin_unlock(&to->deferred_split_queue.split_queue_lock);
> > > > >  	}
> > > > >  #endif
> > > > 
> > > > The patch looks OK for me. But there is another question. I forget, why we unconditionally
> > > > add a page with empty deferred list to deferred_split_queue. Shouldn't we also check that
> > > > it was initially in the list? Something like:
> > > > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index d4394ae4e5be..0be0136adaa6 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -5289,6 +5289,7 @@ static int mem_cgroup_move_account(struct page *page,
> > > >  	struct pglist_data *pgdat;
> > > >  	unsigned long flags;
> > > >  	unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
> > > > +	bool split = false;
> > > >  	int ret;
> > > >  	bool anon;
> > > >  
> > > > @@ -5346,6 +5347,7 @@ static int mem_cgroup_move_account(struct page *page,
> > > >  		if (!list_empty(page_deferred_list(page))) {
> > > >  			list_del_init(page_deferred_list(page));
> > > >  			from->deferred_split_queue.split_queue_len--;
> > > > +			split = true;
> > > >  		}
> > > >  		spin_unlock(&from->deferred_split_queue.split_queue_lock);
> > > >  	}
> > > > @@ -5360,7 +5362,7 @@ static int mem_cgroup_move_account(struct page *page,
> > > >  	page->mem_cgroup = to;
> > > >  
> > > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > -	if (compound) {
> > > > +	if (compound && split) {
> > > >  		spin_lock(&to->deferred_split_queue.split_queue_lock);
> > > >  		if (list_empty(page_deferred_list(page))) {
> > > >  			list_add_tail(page_deferred_list(page),
> > > > 
> > > 
> > > I think that's a good point, especially considering that the current code 
> > > appears to unconditionally place any compound page on the deferred split 
> > > queue of the destination memcg.  The correct list that it should appear 
> > > on, I believe, depends on whether the pmd has been split for the process 
> > > being moved: note the MC_TARGET_PAGE caveat in 
> > > mem_cgroup_move_charge_pte_range() that does not move the charge for 
> > > compound pages with split pmds.  So when mem_cgroup_move_account() is 
> > > called with compound == true, we're moving the charge of the entire 
> > > compound page: why would it appear on that memcg's deferred split queue?
> > 
> > I believe Kirill asked how do we know that the page should be actually
> > added to the deferred list just from the list_empty check. In other
> > words what if the page hasn't been split at all?
> > 
> 
> Right, and I don't think that it necessarily is and the second 
> conditional in Wei's patch will always succeed unless we have raced.  That 
> patch is for a lock concern but I think Kirill's question has uncovered 
> something more interesting.
> 
> Kirill S would definitely be best to answer Kirill T's question, but from 
> my understanding when mem_cgroup_move_account() is called with 
> compound == true that we always have an intact pmd (we never migrate 
> partial page charges for pages on the deferred split queue with the 
> current charge migration implementation) and thus the underlying page is 
> not eligible to be split and shouldn't be on the deferred split queue.
> 
> In other words, a page being on the deferred split queue for a memcg 
> should only happen when it is charged to that memcg.  (This wasn't the 
> case when we only had per-node split queues.)  I think that's currently 
> broken in mem_cgroup_move_account() before Wei's patch.

Right. It's broken indeed.

We are dealing with anon page here. And it cannot be on deferred list as
long as it's mapped with PMD. We cannot get compound == true &&
!list_empty() on the (first) enter to the function. Any PMD-mapped page
will be put onto deferred by the function. This is wrong.

The fix is not obvious.

This comment got in mem_cgroup_move_charge_pte_range() my attention:

			/*
			 * We can have a part of the split pmd here. Moving it
			 * can be done but it would be too convoluted so simply
			 * ignore such a partial THP and keep it in original
			 * memcg. There should be somebody mapping the head.
			 */

That's exactly the case we care about: PTE-mapped THP that has to be split
under load. We don't move charge of them between memcgs and therefore we
should not move the page to different memcg.

I guess this will do the trick :P

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5b5f74cfd4d..e87ee4c10f6e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5359,14 +5359,6 @@ static int mem_cgroup_move_account(struct page *page,
 		__mod_lruvec_state(to_vec, NR_WRITEBACK, nr_pages);
 	}
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
-		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
-		spin_unlock(&from->deferred_split_queue.split_queue_lock);
-	}
-#endif
 	/*
 	 * It is safe to change page->mem_cgroup here because the page
 	 * is referenced, charged, and isolated - we can't race with
@@ -5376,16 +5368,6 @@ static int mem_cgroup_move_account(struct page *page,
 	/* caller should have done css_get */
 	page->mem_cgroup = to;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
-		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
-		spin_unlock(&to->deferred_split_queue.split_queue_lock);
-	}
-#endif
-
 	spin_unlock_irqrestore(&from->move_lock, flags);
 
 	ret = 0;
-- 
 Kirill A. Shutemov

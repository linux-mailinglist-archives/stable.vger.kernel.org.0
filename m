Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C553C2CB693
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 09:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgLBIQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 03:16:00 -0500
Received: from relay.sw.ru ([185.231.240.75]:34110 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728833AbgLBIQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 03:16:00 -0500
Received: from [192.168.15.15]
        by relay3.sw.ru with esmtp (Exim 4.94)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1kkNHu-00BNnE-5V; Wed, 02 Dec 2020 11:14:58 +0300
Subject: Re: [v3 PATCH] mm: list_lru: set shrinker map bit when child nr_items
 is not zero
To:     Yang Shi <shy828301@gmail.com>, guro@fb.com,
        vdavydov.dev@gmail.com, shakeelb@google.com,
        akpm@linux-foundation.org
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20201201212553.52164-1-shy828301@gmail.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <18b7b2d4-7d51-ce84-b8f7-e61af8dcb92f@virtuozzo.com>
Date:   Wed, 2 Dec 2020 11:15:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201201212553.52164-1-shy828301@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.12.2020 00:25, Yang Shi wrote:
> When investigating a slab cache bloat problem, significant amount of
> negative dentry cache was seen, but confusingly they neither got shrunk
> by reclaimer (the host has very tight memory) nor be shrunk by dropping
> cache.  The vmcore shows there are over 14M negative dentry objects on lru,
> but tracing result shows they were even not scanned at all.  The further
> investigation shows the memcg's vfs shrinker_map bit is not set.  So the
> reclaimer or dropping cache just skip calling vfs shrinker.  So we have
> to reboot the hosts to get the memory back.
> 
> I didn't manage to come up with a reproducer in test environment, and the
> problem can't be reproduced after rebooting.  But it seems there is race
> between shrinker map bit clear and reparenting by code inspection.  The
> hypothesis is elaborated as below.
> 
> The memcg hierarchy on our production environment looks like:
>                 root
>                /    \
>           system   user
> 
> The main workloads are running under user slice's children, and it creates
> and removes memcg frequently.  So reparenting happens very often under user
> slice, but no task is under user slice directly.
> 
> So with the frequent reparenting and tight memory pressure, the below
> hypothetical race condition may happen:
> 
>        CPU A                            CPU B
> reparent
>     dst->nr_items == 0
>                                  shrinker:
>                                      total_objects == 0
>     add src->nr_items to dst
>     set_bit
>                                      retrun SHRINK_EMPTY
>                                      clear_bit
> child memcg offline
>     replace child's kmemcg_id to
>     parent's (in memcg_offline_kmem())
>                                   list_lru_del() between shrinker runs
>                                      see parent's kmemcg_id
>                                      dec dst->nr_items
> reparent again
>     dst->nr_items may go negative
>     due to concurrent list_lru_del()
> 
>                                  The second run of shrinker:
>                                      read nr_items without any
>                                      synchronization, so it may
>                                      see intermediate negative
>                                      nr_items then total_objects
>                                      may return 0 conincidently
> 
>                                      keep the bit cleared
>     dst->nr_items != 0
>     skip set_bit
>     add scr->nr_item to dst
> 
> After this point dst->nr_item may never go zero, so reparenting will not
> set shrinker_map bit anymore.  And since there is no task under user
> slice directly, so no new object will be added to its lru to set the
> shrinker map bit either.  That bit is kept cleared forever.
> 
> How does list_lru_del() race with reparenting?  It is because
> reparenting replaces childen's kmemcg_id to parent's without protecting
> from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
> actually deleting items from child's lru, but dec'ing parent's nr_items,
> so the parent's nr_items may go negative as commit
> 2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
> free kmemcg_id on css offline") says.
> 
> Since it is impossible that dst->nr_items goes negative and
> src->nr_items goes zero at the same time, so it seems we could set the
> shrinker map bit iff src->nr_items != 0.  We could synchronize
> list_lru_count_one() and reparenting with nlru->lock, but it seems
> checking src->nr_items in reparenting is the simplest and avoids lock
> contention.
> 
> Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
> Suggested-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Roman Gushchin <guro@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org> v4.19+
> Signed-off-by: Yang Shi <shy828301@gmail.com>

Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> ---
> v3: * Revised commit log per Roman's suggestion
>     * Added Roman's reviewed-by tag
> v2: * Incorporated Roman's suggestion
>     * Incorporated Kirill's suggestion
>     * Changed the subject of patch to get align with the new fix
>     * Added fixes tag
> 
>  mm/list_lru.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 5aa6e44bc2ae..fe230081690b 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -534,7 +534,6 @@ static void memcg_drain_list_lru_node(struct list_lru *lru, int nid,
>  	struct list_lru_node *nlru = &lru->node[nid];
>  	int dst_idx = dst_memcg->kmemcg_id;
>  	struct list_lru_one *src, *dst;
> -	bool set;
>  
>  	/*
>  	 * Since list_lru_{add,del} may be called under an IRQ-safe lock,
> @@ -546,11 +545,12 @@ static void memcg_drain_list_lru_node(struct list_lru *lru, int nid,
>  	dst = list_lru_from_memcg_idx(nlru, dst_idx);
>  
>  	list_splice_init(&src->list, &dst->list);
> -	set = (!dst->nr_items && src->nr_items);
> -	dst->nr_items += src->nr_items;
> -	if (set)
> +
> +	if (src->nr_items) {
> +		dst->nr_items += src->nr_items;
>  		memcg_set_shrinker_bit(dst_memcg, nid, lru_shrinker_id(lru));
> -	src->nr_items = 0;
> +		src->nr_items = 0;
> +	}
>  
>  	spin_unlock_irq(&nlru->lock);
>  }
> 


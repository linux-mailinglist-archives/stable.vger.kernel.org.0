Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A656CBF2
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389577AbfGRJbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:31:08 -0400
Received: from relay.sw.ru ([185.231.240.75]:54274 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727474AbfGRJbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 05:31:08 -0400
Received: from [172.16.25.169]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1ho2ke-0005VV-9n; Thu, 18 Jul 2019 12:31:00 +0300
Subject: Re: [PATCH] mm: vmscan: check if mem cgroup is disabled or not before
 calling memcg slab shrinker
To:     Yang Shi <yang.shi@linux.alibaba.com>, shakeelb@google.com,
        vdavydov.dev@gmail.com, hannes@cmpxchg.org, mhocko@suse.com,
        guro@fb.com, hughd@google.com, cai@lca.pw,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
Cc:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <fca59732-cd98-7e44-8c92-49ebafc6f41c@virtuozzo.com>
Date:   Thu, 18 Jul 2019 12:30:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.07.2019 20:45, Yang Shi wrote:
> Shakeel Butt reported premature oom on kernel with
> "cgroup_disable=memory" since mem_cgroup_is_root() returns false even
> though memcg is actually NULL.  The drop_caches is also broken.
> 
> It is because commit aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab()
> calls in shrink_node()") removed the !memcg check before
> !mem_cgroup_is_root().  And, surprisingly root memcg is allocated even
> though memory cgroup is disabled by kernel boot parameter.
> 
> Add mem_cgroup_disabled() check to make reclaimer work as expected.
> 
> Fixes: aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab() calls in shrink_node()")
> Reported-by: Shakeel Butt <shakeelb@google.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: stable@vger.kernel.org  4.19+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

Surprise really.

We have mem_cgroup as not early inited, so all of these boundary
cases and checks has to be supported. But it looks like it's not
possible to avoid that in any way.

> ---
>  mm/vmscan.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f8e3dcd..c10dc02 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -684,7 +684,14 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>  	unsigned long ret, freed = 0;
>  	struct shrinker *shrinker;
>  
> -	if (!mem_cgroup_is_root(memcg))
> +	/*
> +	 * The root memcg might be allocated even though memcg is disabled
> +	 * via "cgroup_disable=memory" boot parameter.  This could make
> +	 * mem_cgroup_is_root() return false, then just run memcg slab
> +	 * shrink, but skip global shrink.  This may result in premature
> +	 * oom.
> +	 */
> +	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
>  		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
>  
>  	if (!down_read_trylock(&shrinker_rwsem))
> 


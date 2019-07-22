Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAF06FF22
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfGVMAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 08:00:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:45998 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728269AbfGVMAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 08:00:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 905F2B048;
        Mon, 22 Jul 2019 12:00:19 +0000 (UTC)
Date:   Mon, 22 Jul 2019 14:00:18 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     shakeelb@google.com, vdavydov.dev@gmail.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, guro@fb.com, hughd@google.com, cai@lca.pw,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: check if mem cgroup is disabled or not
 before calling memcg slab shrinker
Message-ID: <20190722120018.GZ30461@dhcp22.suse.cz>
References: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 18-07-19 01:45:26, Yang Shi wrote:
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

Acked-by: Michal Hocko <mhocko@suse.com>

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
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs

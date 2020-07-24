Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C56F22C6DD
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 15:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgGXNlN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 09:41:13 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:35990 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726235AbgGXNlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 09:41:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0U3g0eqJ_1595598069;
Received: from IT-FVFX43SYHV2H.lan(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0U3g0eqJ_1595598069)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Jul 2020 21:41:10 +0800
Subject: Re: [patch 06/15] mm/memcg: fix refcount error while moving and
 swapping
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
References: <20200724041524.eAqB5zPs6%akpm@linux-foundation.org>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <e22a1ccb-6b5a-d448-e3ff-3045e93e4f09@linux.alibaba.com>
Date:   Fri, 24 Jul 2020 21:41:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200724041524.eAqB5zPs6%akpm@linux-foundation.org>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ÔÚ 2020/7/24 ÏÂÎç12:15, Andrew Morton Ð´µÀ:
> From: Hugh Dickins <hughd@google.com>
> Subject: mm/memcg: fix refcount error while moving and swapping
> 
> It was hard to keep a test running, moving tasks between memcgs with
> move_charge_at_immigrate, while swapping: mem_cgroup_id_get_many()'s
> refcount is discovered to be 0 (supposedly impossible), so it is then
> forced to REFCOUNT_SATURATED, and after thousands of warnings in quick
> succession, the test is at last put out of misery by being OOM killed.
> 
> This is because of the way moved_swap accounting was saved up until the
> task move gets completed in __mem_cgroup_clear_mc(), deferred from when
> mem_cgroup_move_swap_account() actually exchanged old and new ids. 
> Concurrent activity can free up swap quicker than the task is scanned,
> bringing id refcount down 0 (which should only be possible when
> offlining).
> 
> Just skip that optimization: do that part of the accounting immediately.
> 
> Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2007071431050.4726@eggly.anvils
> Fixes: 615d66c37c75 ("mm: memcontrol: fix memcg id ref counter on swap charge move")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>

> 
>  mm/memcontrol.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/memcontrol.c~mm-memcg-fix-refcount-error-while-moving-and-swapping
> +++ a/mm/memcontrol.c
> @@ -5669,7 +5669,6 @@ static void __mem_cgroup_clear_mc(void)
>  		if (!mem_cgroup_is_root(mc.to))
>  			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
>  
> -		mem_cgroup_id_get_many(mc.to, mc.moved_swap);
>  		css_put_many(&mc.to->css, mc.moved_swap);
>  
>  		mc.moved_swap = 0;
> @@ -5860,7 +5859,8 @@ put:			/* get_mctgt_type() gets the page
>  			ent = target.ent;
>  			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
>  				mc.precharge--;
> -				/* we fixup refcnts and charges later. */
> +				mem_cgroup_id_get_many(mc.to, 1);
> +				/* we fixup other refcnts and charges later. */
>  				mc.moved_swap++;
>  			}
>  			break;
> _
> 

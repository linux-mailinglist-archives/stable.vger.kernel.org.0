Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA4F1A828F
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390844AbgDNPXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:23:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46383 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390828AbgDNPXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 11:23:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id f13so14771597wrm.13
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 08:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aRl47KEui4dF8Bv2ab+oDq4Uv6Xo4dlPMMcD3meGqy0=;
        b=T1QfQpA6lncN6R5XQYG60TPEZ0RcfUsZEV2T/qZU1kWiwzW100/1KehINsrZnGkB+k
         37QMXs0lTpNTGSCp93kxusfYI+qg2VcxEqbtJLOkEh1KrA7X1wJADuMPnXdfPLK/Jh68
         3QfYO7pV0Spuwr+GmbtHrcWVBOqDXkb9/doNFU81OecYUKa3/Fow9SjeKN2QBSexA4ky
         LhlH/jQfrz+usjWrWpx8ngT6qn0B/Oa8f+LLSD4lJ7gRnKPUKJAwwx9SCeZxncmQlzMc
         wj1qiZ1i8TrLm9nJD9cLWOmrywQoz7ntSWoB9RjB2X2bjBpPUBBXls9XdRyugMfxtkP0
         yIkg==
X-Gm-Message-State: AGi0Puau2up2vzRRqBGor2EiQkF4cmTlQMImvkT3EaSZG0UsO+dFmh17
        SRSZYaida0knTd5hdumaeFY=
X-Google-Smtp-Source: APiQypIjAiphk9o29ryxVXZ1u8bQd9lJKb2OizBfNvqVBtOGgnIg0hqhpoCHGCZfLop8rjshbX0HGg==
X-Received: by 2002:a5d:4286:: with SMTP id k6mr12142875wrq.222.1586877780296;
        Tue, 14 Apr 2020 08:23:00 -0700 (PDT)
Received: from localhost (ip-37-188-180-223.eurotel.cz. [37.188.180.223])
        by smtp.gmail.com with ESMTPSA id v21sm18563208wmj.8.2020.04.14.08.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:22:58 -0700 (PDT)
Date:   Tue, 14 Apr 2020 17:22:57 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     shakeelb@google.com, chris@chrisdown.name, hannes@cmpxchg.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm, memcg: fix inconsistent oom event behavior
Message-ID: <20200414152257.GP4629@dhcp22.suse.cz>
References: <20200414015952.3590-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414015952.3590-1-laoar.shao@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 13-04-20 21:59:52, Yafang Shao wrote:
> A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> memory.events") changes the behavior of memcg events, which will
> consider subtrees in memory.events. But oom_kill event is a special one
> as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> in memory.oom_control. The file memory.oom_control is in both root memcg
> and non root memcg, that is different with memory.event as it only in
> non-root memcg. That commit is okay for cgroup2, but it is not okay for
> cgroup1 as it will cause inconsistent behavior between root memcg and
> non-root memcg.
> 
> Here's an example on why this behavior is inconsistent in cgroup1.
>      root memcg
>      /
>   memcg foo
>    /
> memcg bar
> 
> Suppose there's an oom_kill in memcg bar, then the oon_kill will be
> 
>      root memcg : memory.oom_control(oom_kill)  0
>      /
>   memcg foo : memory.oom_control(oom_kill)  1
>    /
> memcg bar : memory.oom_control(oom_kill)  1
> 
> For the non-root memcg, its memory.oom_control(oom_kill) includes its
> descendants' oom_kill, but for root memcg, it doesn't include its
> descendants' oom_kill. That means, memory.oom_control(oom_kill) has
> different meanings in different memcgs. That is inconsistent. Then the user
> has to know whether the memcg is root or not.
> 
> If we can't fully support it in cgroup1, for example by adding
> memory.events.local into cgroup1 as well, then let's don't touch
> its original behavior. So let's recover the original behavior for cgroup1.

Wthe localevents was mostly cgroup v2 feature. I do not think there was
an intention to have side effects on the legacy hierarchy. I thought
this would be the case but it is not apparently. Would it make more
sense to have CGRP_ROOT_MEMORY_LOCAL_EVENTS for legacy hierarchy by
default rather than special casing it somewhere quite deep in the code?

> Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/memcontrol.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8c340e6b347f..a0ae080a67d1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
>  		atomic_long_inc(&memcg->memory_events[event]);
>  		cgroup_file_notify(&memcg->events_file);
>  
> -		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> +		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> +		    !cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  			break;
>  	} while ((memcg = parent_mem_cgroup(memcg)) &&
>  		 !mem_cgroup_is_root(memcg));
> -- 
> 2.18.2

-- 
Michal Hocko
SUSE Labs

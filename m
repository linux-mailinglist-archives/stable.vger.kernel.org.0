Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE651A6AF6
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 19:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgDMRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 13:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732482AbgDMRGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 13:06:10 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CF0C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:06:09 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m8so9483496lji.1
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 10:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1WLaWqL0M37vBrpN7C6PrqvMLwn/+QFDXA/NRDK7/EA=;
        b=ii3fa08G20l3r6Bnmsy1LjaB0fkVBkRi/3Wcc6oJSmk/83TFxqHc+95zJEDqkA02Ic
         8DpBSs0CeBk+yV540Z/jFw09mBYejuPAb5Z3yvVTD8OED4OXEATSSlTbunJXDWGxJja5
         hBlsSARsW3+uG8Gl5Csg8uSYT3GLeqK6mw8aVoFYM/1MnuK9Z9B40brKTDAWqkh2ksRU
         gOGkniDvMgQMhVXlhNQG042jxQDqo4cGTfn10Oex022JmBllLcs7PD1VrTs/BtH8cOF/
         uQipbULMsuN6ii6aKdeMfhMctPxd04tJsfssRYjxYeFNvkZWpLKm2OqxiKbhQWrDscuv
         F9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1WLaWqL0M37vBrpN7C6PrqvMLwn/+QFDXA/NRDK7/EA=;
        b=jzmZHtgqa1URmzTThE01ibgt+yobm/Xjg/qutkxWy8icXYob7NGeOH21jdJTtBUHhr
         iGFzRSXa+ijVz4PTsO/2bpFTKy0j4FsrqfDuHsrwg33qGbk6Y+OYtpqpZEgaivi6++C5
         xzZy1mlyaWgodsgXKlsuqDZz/VKiEjFYYtJehhvRWZ3OFguU3L2x0vCKpz5CbqYvqO5y
         cd8McPGreC3fQX9Kuz7tFN5qd/0dv+LiH2NzP4mYF1JAGqVCTFbPro4aKoo1ADHGJKgR
         Z+j2eD+T6QEutrsL2D6K+gmqQDgr/FWDaanH1ecpVTYPHAQAXxzLYBMSiURISaCpkUaZ
         GLhw==
X-Gm-Message-State: AGi0PuYGYZIVCD78DD5tzBVDWmyeaz8LASyK8vOY1IracdtxwBcv/EYV
        owM2aHPEjjhushDxmM+rsXmYTMzGxwE2f0HnRQx6T0z29mY=
X-Google-Smtp-Source: APiQypIBgpGiWLXQZUe7pzFncf/ozTjOFnRtp36ZENdP6NPyLLadnkxUaJca0qGchAEjLjIhQWvykNqkb1Ad4roz9yQ=
X-Received: by 2002:a2e:9ac9:: with SMTP id p9mr10987422ljj.222.1586797568017;
 Mon, 13 Apr 2020 10:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com>
In-Reply-To: <20200412140427.6732-1-laoar.shao@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 13 Apr 2020 10:05:56 -0700
Message-ID: <CALvZod56skzRJNAmtXo=VxtoVAgkamZekEh0K0SBV=D96BA7Yg@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Chris Down <chris@chrisdown.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 12, 2020 at 7:04 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> memory.events") changes the behavior of memcg events, which will
> consider subtrees in memory.events. But oom_kill event is a special one
> as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> in memory.oom_control. The file memory.oom_control is in both root memcg
> and non root memcg, that is different with memory.event as it only in
> non-root memcg. That commit is okay for cgroup2, but it is not okay for
> cgroup1 as it will cause inconsistent behavior between root memcg and
> non-root memcg.

I still couldn't understand the cgroup v1's root vs non_root behavior
change. The behavior change I see is the hierarchical one i.e.
MEMCG_OOM_KILL event in the descendant will cause the notification and
count increment in the ancestors even in the cgroup v1. I suppose we
don't want that behavior change in v1.

> Let's recover the original behavior for cgroup1.
>
> Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: stable@vger.kernel.org
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
>                 atomic_long_inc(&memcg->memory_events[event]);
>                 cgroup_file_notify(&memcg->events_file);
>
> -               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> +               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> +                   !cgroup_subsys_on_dfl(memory_cgrp_subsys))
>                         break;
>         } while ((memcg = parent_mem_cgroup(memcg)) &&
>                  !mem_cgroup_is_root(memcg));
> --
> 2.18.2
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1091F1A83F6
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 17:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391193AbgDNP6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 11:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391187AbgDNP63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 11:58:29 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505C1C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 08:58:28 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id o127so13801651iof.0
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 08:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOCtsrn3qUAvQV1DSgy+ggH7l1wMb2vM5ji+K4tU+WQ=;
        b=KrfIY15c2OYUbUw1C6FUFymF+e9KufI0jHf5KIsHyRT3cunayI9ZrqAjsls5MOI6o9
         98Dw2OQwODJ9+DiOsaaN/FUJupbNwtbSopxfwS6HCWph7lnGz6ENH0rlapwYbZ3l4Nt7
         17s1T65sTAaJh5HbwpoaqBImUo3P0sQ7GPa6fXo/Um9XriCftiqSzEbTAQGNggwsfJzs
         Jg9semUlwphmYm7vc0jo/pljDoS9wLW46qHaj9glWyqjQ9WdySxr8zRaNb4fvstCgS5d
         8hIberMIh7QAW0uBSzKvhNEBUAksKmbRXz6GLbfSvU0TcER02dwYiKdlFWChbi+aNY8G
         9/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOCtsrn3qUAvQV1DSgy+ggH7l1wMb2vM5ji+K4tU+WQ=;
        b=RP7qDYAgY99V/bI3eDFY7/GOVxAqugBlFiMLcE9VTGotae73ZuuPUH0R4naXT4tKjV
         JfeGAV1YUdTTqZPSsVkIfGRxBjUYSiHdtZbn71DJ792je+dMYht9kZITO5z5ypLu4T1m
         FFxdXPvyeA9O3a7JwBqjLkk6EUikNSnY1dqIi1GieOOz85aBACdlbul6kPIj5mVWtZvQ
         LXgexWC1fsCJXNcEKclictmzTVfyT++8Ydqxmv+E8uGUTUY2cIO4MObIFf61pixq0vR9
         zDRpO1no7l2iw02FESD18yV7wxqK6yTeSgaD5BBRWBcNTZCJjGW+JZ0awx9IysOZQELZ
         WHhA==
X-Gm-Message-State: AGi0PuaE/wVm+2xApAv5o9rdXHZ0CSWdxmpmaLa36MfcCHmc3WNmFO+b
        JEq7F3WQyJANPiICIpKgniz9axS1ivPp5hvj5Ck=
X-Google-Smtp-Source: APiQypK9AOnQx6A8YzI31U2aDBtP4+zNADXnuqueTIIhWJbCGsIBfTv5hgJkozCyPHE9vc+8dha9yZ3bQQ+YNu1KLHU=
X-Received: by 2002:a05:6638:1187:: with SMTP id f7mr20392077jas.94.1586879907639;
 Tue, 14 Apr 2020 08:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200414015952.3590-1-laoar.shao@gmail.com> <20200414152257.GP4629@dhcp22.suse.cz>
In-Reply-To: <20200414152257.GP4629@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 14 Apr 2020 23:57:51 +0800
Message-ID: <CALOAHbCkE3Pb9r0xz_YGYzaO2sAgjM0ybiK827kvf41Y18E-GQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm, memcg: fix inconsistent oom event behavior
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Chris Down <chris@chrisdown.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 11:23 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 13-04-20 21:59:52, Yafang Shao wrote:
> > A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> > memory.events") changes the behavior of memcg events, which will
> > consider subtrees in memory.events. But oom_kill event is a special one
> > as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> > in memory.oom_control. The file memory.oom_control is in both root memcg
> > and non root memcg, that is different with memory.event as it only in
> > non-root memcg. That commit is okay for cgroup2, but it is not okay for
> > cgroup1 as it will cause inconsistent behavior between root memcg and
> > non-root memcg.
> >
> > Here's an example on why this behavior is inconsistent in cgroup1.
> >      root memcg
> >      /
> >   memcg foo
> >    /
> > memcg bar
> >
> > Suppose there's an oom_kill in memcg bar, then the oon_kill will be
> >
> >      root memcg : memory.oom_control(oom_kill)  0
> >      /
> >   memcg foo : memory.oom_control(oom_kill)  1
> >    /
> > memcg bar : memory.oom_control(oom_kill)  1
> >
> > For the non-root memcg, its memory.oom_control(oom_kill) includes its
> > descendants' oom_kill, but for root memcg, it doesn't include its
> > descendants' oom_kill. That means, memory.oom_control(oom_kill) has
> > different meanings in different memcgs. That is inconsistent. Then the user
> > has to know whether the memcg is root or not.
> >
> > If we can't fully support it in cgroup1, for example by adding
> > memory.events.local into cgroup1 as well, then let's don't touch
> > its original behavior. So let's recover the original behavior for cgroup1.
>
> Wthe localevents was mostly cgroup v2 feature. I do not think there was
> an intention to have side effects on the legacy hierarchy. I thought
> this would be the case but it is not apparently. Would it make more
> sense to have CGRP_ROOT_MEMORY_LOCAL_EVENTS for legacy hierarchy by
> default rather than special casing it somewhere quite deep in the code?
>

I had thought about setting CGRP_ROOT_MEMORY_LOCAL_EVENTS by defualt
for cgroup1, but I was not sure whether we should  also expose
memory_localevents in cgroup1_show_options().

> > Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> > Cc: Chris Down <chris@chrisdown.name>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/memcontrol.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 8c340e6b347f..a0ae080a67d1 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
> >               atomic_long_inc(&memcg->memory_events[event]);
> >               cgroup_file_notify(&memcg->events_file);
> >
> > -             if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > +             if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> > +                 !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> >                       break;
> >       } while ((memcg = parent_mem_cgroup(memcg)) &&
> >                !mem_cgroup_is_root(memcg));
> > --
> > 2.18.2
>
> --
> Michal Hocko
> SUSE Labs



Thanks
Yafang

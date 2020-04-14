Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963281A7061
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 02:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbgDNA6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 20:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgDNA6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 20:58:07 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D0EC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:58:06 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t11so10448134ils.1
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZqkrksRk7re0hRKtlrZsF+grvKJamkQFapywAZ5fzpc=;
        b=GvkbuAgeOz28xqq0UJPQu4JetE/PfJfqENsy5eWn12Ek5xdUUuy3+/T6pr4Or2uAYh
         dxL8dQoqLBv6c96xJnxsSFIIYDk4UeeOhuP849acvuxCHicA68jjh50uOx4AgNvlMcQ3
         OnXimnNXBsyyIQ3Q9p7w8jYtsMRhl0IPyhyCLyybYGxxG3ZNZvZqNZf6Iw1QBLCCauLZ
         7JwjcQX6/R9uEdsHGvbWkyM0+Qmx6qPZQ0g21/Lu0uUTDZSnY5XkZSmdpWzgG+jsa2BS
         UVNruvli0rQ4mQSNK/yvDlQk0CRJcSsWdF60nSWcouOBZ5ozh/joo8dLzmQCgFrGiFt7
         nQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZqkrksRk7re0hRKtlrZsF+grvKJamkQFapywAZ5fzpc=;
        b=AUtMgj9iWRLBHiBzop1Q+b9v7qJMrn2YED2M81HuTi2XC9Y16JVFRd2X/rgNef7I3D
         r7xjmqoeeUHFfUg3jH9fVQAcNcNmwXazuSujhLN9Ls9drMv+Pv52XMgA8wSQX9ElTE0z
         VD92s6tHHD5fcMjsFtI2hQ4PxszI5NGI+D37sDs84jf2t62yyPjhL43he1pHbA1uig5W
         FxiyFFR6ZR+EqFacMAnRWLnq1X0iuKqLShl+NVlvRkUH0Ht+hLKmWgHkSWODXq4uhxSl
         qG3m6+okREHIZtcDMnR1VA6kCz/STB2J9+bjJRGWpUKUkGAKTdTt9kmM8/Uc4DOS/KAF
         1v8A==
X-Gm-Message-State: AGi0Pua8mEC73zmSiWSCtjMPivqVzEJNTVCjG7rgOEMzzCWSeo9XqO2y
        jkk8gBgEFRyNni7vKCeh3VFrXGe7g8gI/EeUaF8=
X-Google-Smtp-Source: APiQypIdnHdErTdJX57nLG+N5KtUzADwXiXWt/43gqS68PA7gakqAq3jo/XEBtImfNc8Eg1jxHR7jp1DfyaGur1ZUwQ=
X-Received: by 2002:a92:5c57:: with SMTP id q84mr6475898ilb.203.1586825885499;
 Mon, 13 Apr 2020 17:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com> <CALvZod56skzRJNAmtXo=VxtoVAgkamZekEh0K0SBV=D96BA7Yg@mail.gmail.com>
 <CALOAHbDa4BO2btFoMpqqPg6GQF47RSii=f+ZH6ONAqhQA=Z8KA@mail.gmail.com> <CALvZod5Jc6u4XGjSwfNi2teoVrSJjRGB304Vf2u41dS71buULg@mail.gmail.com>
In-Reply-To: <CALvZod5Jc6u4XGjSwfNi2teoVrSJjRGB304Vf2u41dS71buULg@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 14 Apr 2020 08:57:29 +0800
Message-ID: <CALOAHbAdOeYMR3DcLtf8S-tBXyb8xUjLfUYB1CxSFyKAAYFABg@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
To:     Shakeel Butt <shakeelb@google.com>
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

On Tue, Apr 14, 2020 at 8:53 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Mon, Apr 13, 2020 at 5:36 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > On Tue, Apr 14, 2020 at 1:06 AM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Sun, Apr 12, 2020 at 7:04 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > >
> > > > A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> > > > memory.events") changes the behavior of memcg events, which will
> > > > consider subtrees in memory.events. But oom_kill event is a special one
> > > > as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> > > > in memory.oom_control. The file memory.oom_control is in both root memcg
> > > > and non root memcg, that is different with memory.event as it only in
> > > > non-root memcg. That commit is okay for cgroup2, but it is not okay for
> > > > cgroup1 as it will cause inconsistent behavior between root memcg and
> > > > non-root memcg.
> > >
> > > I still couldn't understand the cgroup v1's root vs non_root behavior
> > > change. The behavior change I see is the hierarchical one i.e.
> > > MEMCG_OOM_KILL event in the descendant will cause the notification and
> > > count increment in the ancestors even in the cgroup v1.
> >
> > For the non-root memcg, its memory.oom_control(oom_kill) includes its
> > descendants' oom_kill, but for root memcg, it doesn't include its
> > descendants' oom_kill. That means, memory.oom_control(oom_kill) has
> > different meanings in different memcgs. That is inconsistent.
> >
> > [snip]
> > > I suppose we
> > > don't want that behavior change in v1.
> > >
> >
> > That is another topic. I think this feature is welcomed to cgroup1, if
> > we can fully support it, for example by adding memory.events.local
> > into cgroup1 as well, but as far as I know the cgroup1 is frozen.
> >
>
> Please note that after your patch the non-root memcg's
> memory.oom_control(oom_kill) will not include the descendant's
> oom_kill anymore. The non-root and root memcg's
> memory.oom_control(oom_kill) will not be hierarchical anymore but
> consistent. I think that was the intention of the patch, right?
>

Right. If we can't fully support it in cgroup1, then let's don't touch
its original behavior.

> > > > Let's recover the original behavior for cgroup1.
> > > >
> > > > Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> > > > Cc: Chris Down <chris@chrisdown.name>
> > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > Cc: Shakeel Butt <shakeelb@google.com>
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  include/linux/memcontrol.h | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > index 8c340e6b347f..a0ae080a67d1 100644
> > > > --- a/include/linux/memcontrol.h
> > > > +++ b/include/linux/memcontrol.h
> > > > @@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
> > > >                 atomic_long_inc(&memcg->memory_events[event]);
> > > >                 cgroup_file_notify(&memcg->events_file);
> > > >
> > > > -               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > > > +               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> > > > +                   !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > >                         break;
> > > >         } while ((memcg = parent_mem_cgroup(memcg)) &&
> > > >                  !mem_cgroup_is_root(memcg));
> > > > --
> > > > 2.18.2
> > > >
> >
> >


Thanks
Yafang

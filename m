Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A501A7054
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 02:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbgDNAx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390599AbgDNAx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 20:53:58 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B981C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:53:58 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r24so10701374ljd.4
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8xNayC7YcuUcaurWUeJhCdSpydLb0VGHQawugkx5xU=;
        b=BX7abmlWFd3qhTcmL/fw5xelrl/8ISjbDRDIyxmcGV7ndT9PS8tIwl87ZDfEq62XEg
         DjYfzR5v7VbWD2x4nxw+wykU8paIU4Fe9GA8MY7n90C8oyIjZxbkkuNKjIbEinSseLXs
         dj4wgOBjMdFq7RK6O4f18JwIsdsXT+BgpuK/u8uMVdL/0LFhh8381OvGBAQtYNp54bF4
         yNdCg1aOTtsmRK4QEOIh5wMy+wfLNrIZQdVsp1/erHXHAVAt3DJ78AES4V/PTdz0+87A
         zZvm1R7mT1dXFpUtjCFKQ3nxndJ76+2No6JegzVfii2bXsMB2ijhFJfxSnhKsRzYUccq
         cJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8xNayC7YcuUcaurWUeJhCdSpydLb0VGHQawugkx5xU=;
        b=Kj1eDhTa1LzY9p/Tp6/WqHjP6vMOfN9BGVn+ntu3tEWd7UDsCdVY28JZIGwAToOo3P
         VUb6UkC4FxVgvU2lU6L+smBdJhithOixgs42XqTix63WvFmxghleBAapDvsVgp4U2hQU
         Flhe5Ip2UHxiXwZlcxs0upkEWfNG+i0wkE4mqLKuBP2GCT0Z097xnPt9j9aK8vXKgqOW
         0xRt3SRo4vCSBelc2DgFBooE+hsmP+gE5nJmcn7S8u+B1gv0GnCR1rQcNxS9g52sbcgt
         Ck9KwIHDfWFzhnbLy3EalgfLjJbbcUVrKNvY2u+54wFRcbQoz74B3sUU015mM5qattRU
         2BRw==
X-Gm-Message-State: AGi0PuYvMwiWMKgstY8ki3NS92av5f5P3KKHkdZ2t+ku3W8CMy3awzb6
        /yYqDgYLP2TRwf1/zc2TirR7HwyHzgFViFHkAKjpaA==
X-Google-Smtp-Source: APiQypLHkgobWqPrkThizFCIWPFgRkjLlwlQebgNYVDJX0w4/t3UC77n+Q151fiL7bn5D5MxJhjRRJ++91meeqdmr9E=
X-Received: by 2002:a2e:b6cf:: with SMTP id m15mr2422420ljo.168.1586825636460;
 Mon, 13 Apr 2020 17:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com> <CALvZod56skzRJNAmtXo=VxtoVAgkamZekEh0K0SBV=D96BA7Yg@mail.gmail.com>
 <CALOAHbDa4BO2btFoMpqqPg6GQF47RSii=f+ZH6ONAqhQA=Z8KA@mail.gmail.com>
In-Reply-To: <CALOAHbDa4BO2btFoMpqqPg6GQF47RSii=f+ZH6ONAqhQA=Z8KA@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 13 Apr 2020 17:53:45 -0700
Message-ID: <CALvZod5Jc6u4XGjSwfNi2teoVrSJjRGB304Vf2u41dS71buULg@mail.gmail.com>
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

On Mon, Apr 13, 2020 at 5:36 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Tue, Apr 14, 2020 at 1:06 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Sun, Apr 12, 2020 at 7:04 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> > > memory.events") changes the behavior of memcg events, which will
> > > consider subtrees in memory.events. But oom_kill event is a special one
> > > as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> > > in memory.oom_control. The file memory.oom_control is in both root memcg
> > > and non root memcg, that is different with memory.event as it only in
> > > non-root memcg. That commit is okay for cgroup2, but it is not okay for
> > > cgroup1 as it will cause inconsistent behavior between root memcg and
> > > non-root memcg.
> >
> > I still couldn't understand the cgroup v1's root vs non_root behavior
> > change. The behavior change I see is the hierarchical one i.e.
> > MEMCG_OOM_KILL event in the descendant will cause the notification and
> > count increment in the ancestors even in the cgroup v1.
>
> For the non-root memcg, its memory.oom_control(oom_kill) includes its
> descendants' oom_kill, but for root memcg, it doesn't include its
> descendants' oom_kill. That means, memory.oom_control(oom_kill) has
> different meanings in different memcgs. That is inconsistent.
>
> [snip]
> > I suppose we
> > don't want that behavior change in v1.
> >
>
> That is another topic. I think this feature is welcomed to cgroup1, if
> we can fully support it, for example by adding memory.events.local
> into cgroup1 as well, but as far as I know the cgroup1 is frozen.
>

Please note that after your patch the non-root memcg's
memory.oom_control(oom_kill) will not include the descendant's
oom_kill anymore. The non-root and root memcg's
memory.oom_control(oom_kill) will not be hierarchical anymore but
consistent. I think that was the intention of the patch, right?

> > > Let's recover the original behavior for cgroup1.
> > >
> > > Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> > > Cc: Chris Down <chris@chrisdown.name>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: Shakeel Butt <shakeelb@google.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >  include/linux/memcontrol.h | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 8c340e6b347f..a0ae080a67d1 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
> > >                 atomic_long_inc(&memcg->memory_events[event]);
> > >                 cgroup_file_notify(&memcg->events_file);
> > >
> > > -               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > > +               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> > > +                   !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > >                         break;
> > >         } while ((memcg = parent_mem_cgroup(memcg)) &&
> > >                  !mem_cgroup_is_root(memcg));
> > > --
> > > 2.18.2
> > >
>
>
> Thanks
> Yafang

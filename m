Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BD91A7034
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 02:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390533AbgDNAgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 20:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390530AbgDNAgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 20:36:02 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7DEC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:36:02 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w1so11429292iot.7
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 17:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OEbRxfVNnC3F8F9BB/v68cNb4um6sbV0P/8UYr2B5QE=;
        b=lhDUuiONwPgVb0UFhv85NDZzitWYfs1GBStt89GKOEfGT/VCS/+FdcAEVLdpk27YJY
         Oo39lmKt0T7T0VoZU3mX5kiSdLhwPMVLgwnNf7+2RfO/0j8ecnPcun/spcosu3FjTEmS
         13UstQmWHrsRrrj7/1iAU9wKGS/BHJSQ6JagoBU3znwq4rnC8f72K+bNOJ/VyvIt/wi2
         8TuLiLLShhcjuJGMeyLW9CWFDk5APBmzoUdSiuxMf3qMuE+i5pejVhtKC1IsizybSS3l
         eySm/kMRdyNGG/UL63bmskX+JZKjrI6OoGZrW4ge5SDfnKj9ByFwpgZtgFTK6eNf6Ucc
         BuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEbRxfVNnC3F8F9BB/v68cNb4um6sbV0P/8UYr2B5QE=;
        b=MnbOsN+6GVURFJGsReYNT0N8NYR6nWJpCjxbxqBLxnTYyXBCy+mqaipFtoeU4BTBvm
         exmBZKJs1NqkHGtyTqsOsEKoBncq6RS2ZR7gA6lb+V6kKjkGXLo7b5mIC3Wj3pe9zQzk
         LphuUtcdJsdA5/Kk2JwRGXdCZO7tE0hrcNqPQwRfvZq0UTaCgzb67YDZT5u46qNmj8z9
         2mRzfmEkn1o7s66uPZZkvrwTHsv2shlUPvomv0dZbjLFxP7t5t8E/q/FJ9InasqWrRSJ
         07zxXkR36uMILuu2xm3ye5yHg77xr6ckKMgwSWUOdVdEYdDZubWUynUH1Uu7+14qYUg5
         /TIg==
X-Gm-Message-State: AGi0PubXb+hYjQqGEcDC86X5bFF1FhbTvthkPTJcvYtDzz384BB2Hxfg
        cP4IZieYrFuF6eWrMOQYIkYHVCyssjxwmZGIMNw=
X-Google-Smtp-Source: APiQypL3aRsV/4MioL76gsoXTg/IiONe1cFdzbKLhzD+sRH5wIsVSzxTNslaZSK1ezeG4Ek+lRwhKUqWzYBlWQoOmnM=
X-Received: by 2002:a05:6602:199:: with SMTP id m25mr18921125ioo.13.1586824561716;
 Mon, 13 Apr 2020 17:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com> <CALvZod56skzRJNAmtXo=VxtoVAgkamZekEh0K0SBV=D96BA7Yg@mail.gmail.com>
In-Reply-To: <CALvZod56skzRJNAmtXo=VxtoVAgkamZekEh0K0SBV=D96BA7Yg@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 14 Apr 2020 08:35:25 +0800
Message-ID: <CALOAHbDa4BO2btFoMpqqPg6GQF47RSii=f+ZH6ONAqhQA=Z8KA@mail.gmail.com>
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

On Tue, Apr 14, 2020 at 1:06 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Sun, Apr 12, 2020 at 7:04 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> > memory.events") changes the behavior of memcg events, which will
> > consider subtrees in memory.events. But oom_kill event is a special one
> > as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> > in memory.oom_control. The file memory.oom_control is in both root memcg
> > and non root memcg, that is different with memory.event as it only in
> > non-root memcg. That commit is okay for cgroup2, but it is not okay for
> > cgroup1 as it will cause inconsistent behavior between root memcg and
> > non-root memcg.
>
> I still couldn't understand the cgroup v1's root vs non_root behavior
> change. The behavior change I see is the hierarchical one i.e.
> MEMCG_OOM_KILL event in the descendant will cause the notification and
> count increment in the ancestors even in the cgroup v1.

For the non-root memcg, its memory.oom_control(oom_kill) includes its
descendants' oom_kill, but for root memcg, it doesn't include its
descendants' oom_kill. That means, memory.oom_control(oom_kill) has
different meanings in different memcgs. That is inconsistent.

[snip]
> I suppose we
> don't want that behavior change in v1.
>

That is another topic. I think this feature is welcomed to cgroup1, if
we can fully support it, for example by adding memory.events.local
into cgroup1 as well, but as far as I know the cgroup1 is frozen.

> > Let's recover the original behavior for cgroup1.
> >
> > Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> > Cc: Chris Down <chris@chrisdown.name>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: stable@vger.kernel.org
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
> >                 atomic_long_inc(&memcg->memory_events[event]);
> >                 cgroup_file_notify(&memcg->events_file);
> >
> > -               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > +               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> > +                   !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> >                         break;
> >         } while ((memcg = parent_mem_cgroup(memcg)) &&
> >                  !mem_cgroup_is_root(memcg));
> > --
> > 2.18.2
> >


Thanks
Yafang

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9A51612B2
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 14:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgBQNIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 08:08:49 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36913 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgBQNIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 08:08:48 -0500
Received: by mail-io1-f65.google.com with SMTP id k24so5880072ioc.4
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 05:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5k0CW/O9VwTug2M57XkNepE9FePRARZ1edCnvLHy4x4=;
        b=kwfkUqm6nGLxf0EwmDS8p1+jEIzRIon3BgGzYw3g2yUlqMqCcPga52IqvblMhJT0/V
         ceiea9vuw+1OUnN+w9Tvfnr962gk2VKn2a6/Zi9ZqrL9VW3uV7AlUIBrIZyJHOAYEOxq
         B4+1BYjQHcBN9TSxg0GvpBxiv8199Sm7P8/Xia/wsAjx+/o2/xXlOuMw5mdgOE2Zl3gu
         et8X/YnxZmot3pwvn7DT3Hjl9VG9ezPKc4yIwW5IyOaZcI6Jl9P2+lI/2a5ErOJZ9rq2
         3zYNAWLgc/jqlEsnJRK40xzgTHBDkWPel8MpAs/73GImjdYq6b6GCwjq5I+8JnNuLkwZ
         DzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5k0CW/O9VwTug2M57XkNepE9FePRARZ1edCnvLHy4x4=;
        b=OqNmnwu9l81nq8zzMvrWY+x2wH+Iss0zeG+TH3x2pKmIL4kqmcn55m9pZLrjWYICHb
         DAN8dM63hBCVMcSVunLcI3YUU0S3QE0ybqC5bhH5R7/IWaj5otFgO4uSp9z3gg9uuhNJ
         Lk18VJu2Um+YguGyUNVnhliKcEdEdT9rEtPtYe5kKW+Em/6FZKbr1I/BwogOx2ZtofK8
         IGVcvoTVjcAUp2u3u3wcvAmEjTd+hLeFaBu2J4SKQliAOlURbGT2vLYhyc8PcxM2yrzH
         JsnPZSXRMUhfL5AC4V0d+32qh0K35vlSjreiw1Cd5aivn/aBakh1I9tm2AwTppZ3GDfK
         sJ6w==
X-Gm-Message-State: APjAAAUYcpSozFskcZBf560mPJMTnsY7ct2sWKa/S2miR8gX8WXGC3eS
        grrM+I+y1Egf/7iaOt0QyDE6Hmue7KfVsOSZMqQ=
X-Google-Smtp-Source: APXvYqzqRq2U9pSKI7zZCy1R30c56tMyvW9JDsp7e5Y3QIhmtZ58cXM7DJlh8fhC7zxmZwyc6CkRd+Pcx9vPe2x8rR0=
X-Received: by 2002:a02:856a:: with SMTP id g97mr12252745jai.97.1581944928134;
 Mon, 17 Feb 2020 05:08:48 -0800 (PST)
MIME-Version: 1.0
References: <20200216145249.6900-1-laoar.shao@gmail.com> <20200217092459.GG31531@dhcp22.suse.cz>
In-Reply-To: <20200217092459.GG31531@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 17 Feb 2020 21:08:12 +0800
Message-ID: <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > them won't be changed until next recalculation in this function. After
> > either or both of them are set, the next reclaimer to relcaim this memcg
> > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > the old values of them will be used to calculate scan count, that is not
> > proper. We should reset them to zero in this case.
> >
> > Here's an example of this issue.
> >
> >     root_mem_cgroup
> >          /
> >         A   memory.max=1024M memory.min=512M memory.current=800M
> >
> > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > this A, and it will assign memory.emin of A with 512M.
> > After that, A may reach its hard limit(memory.max), and then it will
> > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > not calculate its memory.emin. So the memory.emin is the old value
> > 512M, and then this old value will be used in
> > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > That is not proper.
>
> Please document user visible effects of this patch. What does it mean
> that this is not proper behavior?

In the memcg reclaim, if the target memcg is the root of the reclaimer,
the reclaimer should scan this memcg's all page cache pages in the LRU,
but now as the old memcg.{emin, elow} value are still there, it will get
a wrong protection value,
and the reclaimer can't reclaim the page cache pages protected by this
wrong protection.

> What happens if we have concurrent
> reclaimers at different levels of the hierarchy how that would affect
> the resulting protection?
>

Well, I thought the synchronization mechanisms have already existed ?
Otherwise there must be concurrent issue in the original code of
setting the memcg.{emin, elow} as well.
(Because memcg->memory.{emin, elow} are also set at the end of the
function mem_cgroup_protected())



> > Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Acked-by: Roman Gushchin <guro@fb.com>
> > Cc: Chris Down <chris@chrisdown.name>
> > Cc: stable@vger.kernel.org
> > ---
> >  mm/memcontrol.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6f6dc8712e39..df7fedbfc211 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6250,8 +6250,17 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> >
> >       if (!root)
> >               root = root_mem_cgroup;
> > -     if (memcg == root)
> > +     if (memcg == root) {
> > +             /*
> > +              * Reset memory.(emin, elow) for reclaiming the memcg
> > +              * itself.
> > +              */
> > +             if (memcg != root_mem_cgroup) {
> > +                     memcg->memory.emin = 0;
> > +                     memcg->memory.elow = 0;
> > +             }
> >               return MEMCG_PROT_NONE;
> > +     }
> >
> >       usage = page_counter_read(&memcg->memory);
> >       if (!usage)
> > --
> > 2.14.1
>
> --
> Michal Hocko
> SUSE Labs



--
Yafang Shao
DiDi

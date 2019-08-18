Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206B6913CA
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 02:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHRAaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Aug 2019 20:30:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37935 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfHRAaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Aug 2019 20:30:52 -0400
Received: by mail-io1-f67.google.com with SMTP id j6so13667645ioa.5;
        Sat, 17 Aug 2019 17:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7TCNFB9IApthvRti5TuZchHBScOrRK3vIeUZCqgFKMI=;
        b=tj8HYYpVDjnt1qYAUFi8njHti8RuQcSWkQtHtqD1We3t+PxlKqxbB/qfwaPyA8nHhp
         lbZyujDvxpi9CAG9wKs23piBQucNB9PmSt9q5SgWO1Ifod75spKzLsEFXAWix5Ko8yxe
         dspmNumSio874P0gjjGD3oUC9rtbsiwnVl/cvqgzUtEqgTPY4qP76oeDFzxU/hrh7rVt
         XqFc2BdsP2K3/J9KKWm4n1JmisYMrtA7po/sepEUkpaEUCpFsv27YDqC0U8WaFTWjh5v
         utYJ2ffXqr54hNV12WHdRG65pgSnutp5gHjWsPyzCyaaTxYwvPj54xTMw1BrvXuSnorO
         XyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7TCNFB9IApthvRti5TuZchHBScOrRK3vIeUZCqgFKMI=;
        b=g2bUT3uPr4qeRn064pyDo03dEoisyilr9IVvAU+lsYjg5s6J3/koGZgA0rOG/JeLaa
         kQM/SHnrcYIwOgwX6ccpL6nd9oH0Z2Ter4H6gCEhfy3oQz7vBGdXHXyQ158UvEmNkcAf
         ceTiqXtVEy9T8xCpFRJYViz1nk7KkbYmtRsT495THC2Wx7FrMLr9qURlge5RI2fbseFQ
         Kn2S+0wdp9ttDpWXekFcGQZeXLT3ELQZQLf4ZY1riVKjL+6tnVamFiPZxyh25aoypeYv
         WC/VBtLZU9vOwxKOmQo5xXZwEB0kZn7UIXHgbTiODyHk1crEhK+kfWcvc43odSfpsbZc
         w7ww==
X-Gm-Message-State: APjAAAWBp4HRqBl2IPx85pHHyHAWaYGL8Kfb3+zHaSGGOGeBwa08q5Be
        72zau09OBB0VwYYAusXpaJHeEij7E++IFWoyacc=
X-Google-Smtp-Source: APXvYqw1qG48u3XtTNYDfqmoOH9rsc/UNf1NeLz1rj1kTjqIKQY9w3co5mCGqjVQJYxMGCTLXpee08DDnt3uvuATBKs=
X-Received: by 2002:a02:1981:: with SMTP id b123mr18589621jab.72.1566088251625;
 Sat, 17 Aug 2019 17:30:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190817004726.2530670-1-guro@fb.com> <CALOAHbBsMNLN6jZn83zx6EWM_092s87zvDQ7p-MZpY+HStk-1Q@mail.gmail.com>
 <20190817191419.GA11125@castle>
In-Reply-To: <20190817191419.GA11125@castle>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 18 Aug 2019 08:30:15 +0800
Message-ID: <CALOAHbA-Z-1QDSgQ6H6QhPaPwAGyqfpd3Gbq-KLnoO=ZZxWnrw@mail.gmail.com>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 3:14 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Sat, Aug 17, 2019 at 11:33:57AM +0800, Yafang Shao wrote:
> > On Sat, Aug 17, 2019 at 8:47 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
> > > with the hierarchical ones") effectively decreased the precision of
> > > per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.
> > >
> > > That's good for displaying in memory.stat, but brings a serious regression
> > > into the reclaim process.
> > >
> > > One issue I've discovered and debugged is the following:
> > > lruvec_lru_size() can return 0 instead of the actual number of pages
> > > in the lru list, preventing the kernel to reclaim last remaining
> > > pages. Result is yet another dying memory cgroups flooding.
> > > The opposite is also happening: scanning an empty lru list
> > > is the waste of cpu time.
> > >
> > > Also, inactive_list_is_low() can return incorrect values, preventing
> > > the active lru from being scanned and freed. It can fail both because
> > > the size of active and inactive lists are inaccurate, and because
> > > the number of workingset refaults isn't precise. In other words,
> > > the result is pretty random.
> > >
> > > I'm not sure, if using the approximate number of slab pages in
> > > count_shadow_number() is acceptable, but issues described above
> > > are enough to partially revert the patch.
> > >
> > > Let's keep per-memcg vmstat_local batched (they are only used for
> > > displaying stats to the userspace), but keep lruvec stats precise.
> > > This change fixes the dead memcg flooding on my setup.
> > >
> >
> > That will make some misunderstanding if the local counters are not in
> > sync with the hierarchical ones
> > (someone may doubt whether there're something leaked.).
>
> Sure, but the actual leakage is a much more serious issue.
>
> > If we have to do it like this, I think we should better document this behavior.
>
> Lru size calculations can be done using per-zone counters, which is
> actually cheaper, because the number of zones is usually smaller than
> the number of cpus. I'll send a corresponding patch on Monday.
>

Looks like a good idea.

> Maybe other use cases can also be converted?

We'd better keep the behavior the same across counters. I think you
can have a try.

Thanks
Yafang

>
> Thanks!
>
> >
> > > Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > >  mm/memcontrol.c | 8 +++-----
> > >  1 file changed, 3 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 249187907339..3429340adb56 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -746,15 +746,13 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
> > >         /* Update memcg */
> > >         __mod_memcg_state(memcg, idx, val);
> > >
> > > +       /* Update lruvec */
> > > +       __this_cpu_add(pn->lruvec_stat_local->count[idx], val);
> > > +
> > >         x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
> > >         if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
> > >                 struct mem_cgroup_per_node *pi;
> > >
> > > -               /*
> > > -                * Batch local counters to keep them in sync with
> > > -                * the hierarchical ones.
> > > -                */
> > > -               __this_cpu_add(pn->lruvec_stat_local->count[idx], x);
> > >                 for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
> > >                         atomic_long_add(x, &pi->lruvec_stat[idx]);
> > >                 x = 0;
> > > --
> > > 2.21.0
> > >

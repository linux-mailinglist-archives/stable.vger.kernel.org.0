Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E3A12BC86
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 05:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfL1EZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 23:25:24 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:45759 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbfL1EZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 23:25:23 -0500
Received: by mail-io1-f67.google.com with SMTP id i11so27258537ioi.12
        for <stable@vger.kernel.org>; Fri, 27 Dec 2019 20:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXfmeRc/DQT5QGa1Zzbtx9o4jNhOuYwsMdwRlk0Js5M=;
        b=GTKc39d0iw1a15PKXNPr7Jd6cxtvSBt+DRNzU3lY/gBh8hvBIun4zoBDNiyb8DCBmL
         F8gWouRte74ylQVLeDPtaw0gKifYndcQleu+YQdRlYnVgZH1c0ynqPvr0wPuY7pkU3Mc
         dqN5Jk1ZarFxAwVPMn/aaSQ+9i/PdKjORSz0w2M9EwmJIhteZQ85OZwPsC14wmRefE+M
         gcu4cTIUKmL0v4WFrO3se+kshYslA9F/xe0Y1LJZmDi5vPJPCrNT7fhFcEyXJMjZY8QD
         13FPuVcokBT3QeYinmMUMauhl8MN6AnY5O5HSLYE1+r0so7j9aFCzc0zbfM5XcPgm+qZ
         wRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXfmeRc/DQT5QGa1Zzbtx9o4jNhOuYwsMdwRlk0Js5M=;
        b=T0lPXF+PhxPA5Vj2gEXyzoSv3ib4tmioDHRyu5LgSBTLM/KJ9TyxQcfcOjzPAGT5xY
         YAsm3Uvsgce5HaevDmpJJlQv2SbcsSiep7+AWT6/VBMhaqEq/sV0XtmUQpynY+M68/U+
         lX1TuxzeRupklkwcComWI81+D8Fq8zlIZA/069EF5J7a7KAvt6FRtFNlGgx4MlhMMJTs
         37tQlm/03onEuBmLcZaaMcVwQWxN47p8o1KPQakHp7ky4pZRTuy33zNF4zbGBtpJ7z8t
         WLA6757wHZHxTJAh2qDCq4hHxFxFRExic8jlYmGtKUMzDnq4ymUDwGib0QVYTJALCxWh
         fb5A==
X-Gm-Message-State: APjAAAUGYWbrOro7KRM3EFqQKHY3mulKSfDgQQkVZZSHUZTPopBp33A3
        EQHHJXq9F4eA2TQAmPkbSHrElv/3XMXSQC25pIM=
X-Google-Smtp-Source: APXvYqxmEscC1lOiABwtiQ2kw0O4KaI818nJjTvvIHGJhczhXbW1y1TKp8bfZbirOWUo0WYmbm5Sf9I6/TNQEJhJWsg=
X-Received: by 2002:a02:856a:: with SMTP id g97mr43201900jai.97.1577507123172;
 Fri, 27 Dec 2019 20:25:23 -0800 (PST)
MIME-Version: 1.0
References: <1577450633-2098-1-git-send-email-laoar.shao@gmail.com>
 <1577450633-2098-2-git-send-email-laoar.shao@gmail.com> <20191227234913.GA6742@localhost.localdomain>
 <CALOAHbC_ifYcWsNqJ4889nHFeyasruaapO+0LM9UPDsSWiNA9Q@mail.gmail.com> <20191228025951.GA8425@localhost.localdomain>
In-Reply-To: <20191228025951.GA8425@localhost.localdomain>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 28 Dec 2019 12:24:47 +0800
Message-ID: <CALOAHbBhPgh3WEuLu2B6e2vj1J8K=gGOyCKzb8tKWmDqFs-rfQ@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: reset memcg's memory.{min, low} for reclaiming itself
To:     Roman Gushchin <guro@fb.com>
Cc:     "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 28, 2019 at 11:00 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Sat, Dec 28, 2019 at 09:45:11AM +0800, Yafang Shao wrote:
> > On Sat, Dec 28, 2019 at 7:49 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Fri, Dec 27, 2019 at 07:43:53AM -0500, Yafang Shao wrote:
> > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > them won't be changed until next recalculation in this function. After
> > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > the old values of them will be used to calculate scan count, that is not
> > > > proper. We should reset them to zero in this case.
> > > >
> > > > Here's an example of this issue.
> > > >
> > > >     root_mem_cgroup
> > > >          /
> > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > >
> > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > this A, and it will assign memory.emin of A with 512M.
> > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > 512M, and then this old value will be used in
> > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > That is not proper.
> > > >
> > > > Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > Cc: Chris Down <chris@chrisdown.name>
> > > > Cc: Roman Gushchin <guro@fb.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  mm/memcontrol.c | 11 ++++++++++-
> > > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 601405b..bb3925d 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -6287,8 +6287,17 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
> > > >
> > > >       if (!root)
> > > >               root = root_mem_cgroup;
> > > > -     if (memcg == root)
> > > > +     if (memcg == root) {
> > > > +             /*
> > > > +              * Reset memory.(emin, elow) for reclaiming the memcg
> > > > +              * itself.
> > > > +              */
> > > > +             if (memcg != root_mem_cgroup) {
> > > > +                     memcg->memory.emin = 0;
> > > > +                     memcg->memory.elow = 0;
> > > > +             }
> > >
> > > I'm sorry, that didn't bring it from scratch, but I doubt that zeroing effecting
> > > protection is correct. Imagine a simple config: a large cgroup subtree with memory.max
> > > set on the top level. Reaching this limit doesn't mean that all protection
> > > configuration inside the tree can be ignored.
> > >
> >
> > No, they won't be ignored.
> > Pls. see the logic in mem_cgroup_protected(), it will re-calculate all
> > its children's effective min and low.
>
> Ah, you're right. I forgot about this
>     if (parent == root)
>         goto exit;
>
> which saves elow/emin from being truncated to 0. Sorry.
>
> Please, feel free to add
> Acked-by: Roman Gushchin <guro@fb.com>
>

Thanks for your review.

Thanks
Yafang

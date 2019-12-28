Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4F12BC24
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 02:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfL1Bps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 20:45:48 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:43083 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfL1Bpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 20:45:47 -0500
Received: by mail-io1-f68.google.com with SMTP id n21so25557823ioo.10
        for <stable@vger.kernel.org>; Fri, 27 Dec 2019 17:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=drwHJ94pXoTF//+PeeIPAkd05VOj9HKC05blpLwcwf4=;
        b=C3BmuWHQULFXgjqb2SK2C5ro12YuMYmBsNH7MBhZhsHywK/2KHTyO89rHyOrvy9RR/
         xjlEcPplsUQ2D0POZLgmR1vC+HPOG9FuDAoX0+dNHzGLn3V3h7JPPgUZzOC9S+gFIoGH
         IBR6HvTGCoQ/M+YquF9sKGwZg7ZvjVYnI8kfwkUg+ZeSpPvSB9PcZzT3dEA9wcnL0Qe3
         zHxD3zdWu7Ne42JuJvRB+TAfR3Ciq7Bj0rK9+miUu8Jdsbppr8avN97xXf/jIJ++5Lzg
         HkAHywh/Kkyi3w3XELHiPpzzdNWqqT4ZY01lAZPvSqF1rZzZZCYWyLddWOTU7E8WwQDy
         Ycow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=drwHJ94pXoTF//+PeeIPAkd05VOj9HKC05blpLwcwf4=;
        b=MD49yj54p4gLL9MmwtAtRH3GbnnbSTzGqOYK0J5gL/rviNekNXfcQmuta+yQnkds7p
         +DQFeRJAYZQv0Yh7126qIZStO8pWjG1+FR1iJu9NopdUtW3IbLHCZiFKLfZJO7FWJy22
         Cm6KTClQkjBasfxmgqLzqcNbJd5RarOTM3Ei856RsFe613EILsAlxqlIa5AeoDkH4uQW
         HtAvB1DU26JI8YgSeMdj8Cmhv8shF0BeWEclGs8b1tb52TESt/Tjyq3/YTPUfACnaDXD
         86wtsWHF++CApsbQ05aUHRqYcAUKSYCWWtUWDWqzxSZs0BkuBLNZQYrqDHKQS35iwHSX
         idCQ==
X-Gm-Message-State: APjAAAWmOkmkI43KakkBzv/sRDLGFVn0NDB+62fW9vQhpFsV/KLHkKtU
        PjyY4pDsgSG/YIYOZayFPksMHy/9+4GvFBKCftk=
X-Google-Smtp-Source: APXvYqwDe7uqQxHdE8LyE0nbjmCs7p2H8JNOEA+7ICWIIXzeOy+ccEJyvxPbdbmgZAgpoXEA8i9eJ5kkMgSn3K66M+8=
X-Received: by 2002:a5d:8b96:: with SMTP id p22mr36061364iol.93.1577497547152;
 Fri, 27 Dec 2019 17:45:47 -0800 (PST)
MIME-Version: 1.0
References: <1577450633-2098-1-git-send-email-laoar.shao@gmail.com>
 <1577450633-2098-2-git-send-email-laoar.shao@gmail.com> <20191227234913.GA6742@localhost.localdomain>
In-Reply-To: <20191227234913.GA6742@localhost.localdomain>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 28 Dec 2019 09:45:11 +0800
Message-ID: <CALOAHbC_ifYcWsNqJ4889nHFeyasruaapO+0LM9UPDsSWiNA9Q@mail.gmail.com>
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

On Sat, Dec 28, 2019 at 7:49 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Fri, Dec 27, 2019 at 07:43:53AM -0500, Yafang Shao wrote:
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
> >
> > Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Chris Down <chris@chrisdown.name>
> > Cc: Roman Gushchin <guro@fb.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  mm/memcontrol.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 601405b..bb3925d 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6287,8 +6287,17 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
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
>
> I'm sorry, that didn't bring it from scratch, but I doubt that zeroing effecting
> protection is correct. Imagine a simple config: a large cgroup subtree with memory.max
> set on the top level. Reaching this limit doesn't mean that all protection
> configuration inside the tree can be ignored.
>

No, they won't be ignored.
Pls. see the logic in mem_cgroup_protected(), it will re-calculate all
its children's effective min and low.

> Instead we should respect memory.low/max set by a user on this level
> (look at the parent == root case), maybe clamped by memory.high/max.
>

Let's look at the parent == root case.
What if the parent is the root_mem_cgroup?
The memory.{emin, elow} of root_mem_cgroup is always 0 right ?
So what's your problem ?

Thanks
Yafang

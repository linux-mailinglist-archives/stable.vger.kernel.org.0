Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2772A1B6A51
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 02:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgDXAa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 20:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgDXAa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 20:30:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B9EC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:30:26 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id 19so8555672ioz.10
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 17:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MZDVazeGniMieWldqbSW2FtSsYHG/33tp3Tf9oRY5R8=;
        b=EOEONrQS4/T3DJI2+IKxpQXOiE51/2pTXot8WZLUTwshdDXOFSDfRBBwGXwAJcxEwG
         geSeHfe0x+N4z6RYp/apFt7/SfEcwMswAHxNRJdoRYCjnOppjruXM44lujQoxQdSAqnV
         CbbATX+78HEWZV1nbm7K+pLDvpqca6PCQwflQlqVsVy7sAdJvRpQFI2GGzpxhn57CYYm
         aL+EzN8MSFRSBQF4rTDQiQlrs9A756/mNRHChrt4E/RRgTO7hnOnF/5Oc9y+bTKa7UjG
         dnK7NBweFH5vA67rM5mvRAoBLxvrQnyLOHBJiRRltxOr9RotV6yjIQnM+OXNVYMCIsK0
         6wSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MZDVazeGniMieWldqbSW2FtSsYHG/33tp3Tf9oRY5R8=;
        b=DoDkTMpE2ChyZSt4/ZZFplMO4JDoh86BCP3ed6kq3PQj+0ZxKmuggArSUtNfqQiT0C
         eF/q5vt9ZXYSpQyxIJk3yEtVcR8RKbaXjUb9PBuP+a4amNTSi/cj0r0kOuybfLmFD2Cq
         WpofR31XxZRxY5bGwjz2wV0jsjCzorgD0QRF8KJsqVvkZJWDnNmYMWZ8BZaccXqsaQDG
         eo5+WqeIYStY9W3bep0BxDScVJclVYu5pqXy9T/kuHJaeaA5IDeKRyx+08DE90G00Kag
         frqkogm8MtNw0TUAuLt66TErnCqJ+WUIAAbL3FlN+/PVqE4wrVof3lwGFkxij4FPuTTV
         5n1w==
X-Gm-Message-State: AGi0PuZE8rcu0Om0a2vyopOTBEByvE/l0oeLCZgiSxXWqbaZcrNYmOyb
        5XWKztEn0E5SsNe7AgrvD6rjmMtUXp9npFE1ugVw5gmx
X-Google-Smtp-Source: APiQypIfBdphbg7tchwEL7rJI9D343ge4ubTf5XHAXR9hw6N5d4yakkgpYvFl+F+DqR1FZjcs00YEIqZ+oBOPKLU3UY=
X-Received: by 2002:a5d:9042:: with SMTP id v2mr6140520ioq.81.1587688226100;
 Thu, 23 Apr 2020 17:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200423210604.GB83398@carbon.DHCP.thefacebook.com>
In-Reply-To: <20200423210604.GB83398@carbon.DHCP.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 Apr 2020 08:29:50 +0800
Message-ID: <CALOAHbCn5VhNK55Agf=fotyA-ETovwaeJb5DYrgCBe-91FQ2BA@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 5:06 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > This patch is an improvement of a previous version[1], as the previous
> > version is not easy to understand.
> > This issue persists in the newest kernel, I have to resend the fix. As
> > the implementation is changed, I drop Roman's ack from the previous
> > version.
> >
> > Here's the explanation of this issue.
> > memory.{low,min} won't take effect if the to-be-reclaimed memcg is the
> > sc->target_mem_cgroup, that can also be proved by the implementation in
> > mem_cgroup_protected(), see bellow,
> >       mem_cgroup_protected
> >               if (memcg == root) [2]
> >                       return MEMCG_PROT_NONE;
> >
> > But this rule is ignored in mem_cgroup_protection(), which will read
> > memory.{emin, elow} as the protection whatever the memcg is.
> >
> > How would this issue happen?
> > Because in mem_cgroup_protected() we forget to clear the
> > memory.{emin, elow} if the memcg is target_mem_cgroup [2].
> >
> > An example to illustrate this issue.
> >    root_mem_cgroup
> >          /
> >         A   memory.max: 1024M
> >             memory.min: 512M
> >             memory.current: 800M ('current' must be greater than 'min')
> > Once kswapd starts to reclaim memcg A, it assigns 512M to memory.emin of A.
> > Then kswapd stops.
> > As a result of it, the memory values of A will be,
> >    root_mem_cgroup
> >          /
> >         A   memory.max: 1024M
> >             memory.min: 512M
> >             memory.current: 512M (approximately)
> >             memory.emin: 512M
> >
> > Then a new workload starts to run in memcg A, and it will trigger memcg
> > relcaim in A soon. As memcg A is the target_mem_cgroup of this
> > reclaimer, so it return directly without touching memory.{emin, elow}.[2]
> > The memory values of A will be,
> >    root_mem_cgroup
> >          /
> >         A   memory.max: 1024M
> >             memory.min: 512M
> >             memory.current: 1024M (approximately)
> >             memory.emin: 512M
> > Then this memory.emin will be used in mem_cgroup_protection() to get the
> > scan count, which is obvoiusly a wrong scan count.
> >
> > [1]. https://lore.kernel.org/linux-mm/20200216145249.6900-1-laoar.shao@gmail.com/
> >
> > Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > Cc: Chris Down <chris@chrisdown.name>
> > Cc: Roman Gushchin <guro@fb.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/memcontrol.h | 13 +++++++++++--
> >  mm/vmscan.c                |  4 ++--
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index d275c72c4f8e..114cfe06bf60 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -344,12 +344,20 @@ static inline bool mem_cgroup_disabled(void)
> >       return !cgroup_subsys_enabled(memory_cgrp_subsys);
> >  }
> >
> > -static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
> > +static inline unsigned long mem_cgroup_protection(struct mem_cgroup *root,
> > +                                               struct mem_cgroup *memcg,
> >                                                 bool in_low_reclaim)
>
> I'd rename "root" to "target", maybe it will make the whole thing more clear.
>

That would make it better.  I will change it.

> I'll think a bit more about it, but at the first glance the patch looks sane to me.
>
> Thanks!



-- 
Thanks
Yafang

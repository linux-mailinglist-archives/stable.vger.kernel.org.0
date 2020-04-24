Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE051B7AFB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDXQBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgDXQBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:01:38 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9C1C09B046
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:01:38 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i3so10833292ioo.13
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6A+MhonSmWKJ8vta63r2FLDB2sShhaIfgrK791Ii/3c=;
        b=vHzZe0VLo9zZ+RkgHSb7I8G+nRlecaRckFxQPxzX8eKctjij/W8MLszd6t+8J9pkdr
         0GfLOrJ6NaJd3Up2o8n+v90lX9jHFQTs6nbyTQs/YDiPq8A5y2tYuYIA4T8njSbfDxC5
         fkQLOvq6IJhh25CowZRgNFWXxkMkp9AU5KfNIKmq4h95Nwx0pH/4hcCjdHMSIpr6lERa
         5Z4yTg6JUmMLgE52QusXd28/Gx7QUsoajT1Xu2hwqck4T9kcuBNYZiIVz0rj5LWh6n3G
         fWAEQI5OCY/CC63iBHZMDYv0GUgTJy87sAAWTEJT33uh/GY5c0+0J+zAHpEfDR96O87h
         bLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6A+MhonSmWKJ8vta63r2FLDB2sShhaIfgrK791Ii/3c=;
        b=cgiXuQmzD2pGF5dACHBr9IpONQANS8ehZfoVqVbqoMigZpKZcLf80RiWhY8bzsiHGK
         ji+6fzLYoB+NSh10aHpYPGolBfZj/Az6d5KNJW88VefSoJZscXLY25p9y/TNwrKq1eS7
         8lSg01pPo5hI2WIUThEHJb6CLVl/ySZpNiOItuMuQPc3IFXNR2fA5Hpu9Vy0ut2JWKkC
         6uO4BSVXO0dPy/cNUAjMDcxvhCthkc5flYc2Pr7WfQANMavH2PcUqp9ItpqWr9vk1/pX
         cMbt76F1Hodby0Gyh3tKbqPIqZy+JEqz1a2brKe1ZUwUjlfaR5qg5MWFqLrQKTC1jduO
         115Q==
X-Gm-Message-State: AGi0Pua41DOqKsQcnB4yYRdnBTb7nAPJjcbwB9hYr9FygmC7rKmlam6V
        XyLFc3XQI/rXyaCNXlIW2EEgxXtwRH7gEU+Si8w=
X-Google-Smtp-Source: APiQypKc+iUtIXqoiu/p/CcQmYzyVG9ADART+Z2kJVsA4Lm9bbq2f/YaeX0LDezDL2+0kZ/LOdoP8Di2Vg4UN3EU6hU=
X-Received: by 2002:a02:5184:: with SMTP id s126mr8780707jaa.81.1587744097389;
 Fri, 24 Apr 2020 09:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200424131450.GA495720@cmpxchg.org>
In-Reply-To: <20200424131450.GA495720@cmpxchg.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 25 Apr 2020 00:00:59 +0800
Message-ID: <CALOAHbAVPH0RdByskQ2TMgfF4DMp9PdyxBG969QFnizhfN1mOQ@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix wrong mem cgroup protection
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 9:14 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Thu, Apr 23, 2020 at 02:16:29AM -0400, Yafang Shao wrote:
> > This patch is an improvement of a previous version[1], as the previous
> > version is not easy to understand.
> > This issue persists in the newest kernel, I have to resend the fix. As
> > the implementation is changed, I drop Roman's ack from the previous
> > version.
>
> Now that I understand the problem, I much prefer the previous version.
>

Great news that this issue is understood by one more reviewer.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 745697906ce3..2bf91ae1e640 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6332,8 +6332,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>
>         if (!root)
>                 root = root_mem_cgroup;
> -       if (memcg == root)
> +       if (memcg == root) {
> +               /*
> +                * The cgroup is the reclaim root in this reclaim
> +                * cycle, and therefore not protected. But it may have
> +                * stale effective protection values from previous
> +                * cycles in which it was not the reclaim root - for
> +                * example, global reclaim followed by limit reclaim.
> +                * Reset these values for mem_cgroup_protection().
> +                */
> +               memcg->memory.emin = 0;
> +               memcg->memory.elow = 0;
>                 return MEMCG_PROT_NONE;
> +       }
>
>         usage = page_counter_read(&memcg->memory);
>         if (!usage)
>
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
>
> As others have noted, it's fairly hard to understand the problem from
> the above changelog. How about the following:
>
> A cgroup can have both memory protection and a memory limit to isolate
> it from its siblings in both directions - for example, to prevent it
> from being shrunk below 2G under high pressure from outside, but also
> from growing beyond 4G under low pressure.
>
> 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> implemented proportional scan pressure so that multiple siblings in
> excess of their protection settings don't get reclaimed equally but
> instead in accordance to their unprotected portion.
>
> During limit reclaim, this proportionality shouldn't apply of course:
> there is no competition, all pressure is from within the cgroup and
> should be applied as such. Reclaim should operate at full efficiency.
>
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim
> cycle in which the cgroup did have siblings.
>
> When this happens, reclaim is unnecessarily hesitant and potentially
> slow to meet the desired limit. In theory this could lead to premature
> OOM kills, although it's not obvious this has occurred in practice.

Thanks a lot for your improvement on the change log.

--
Thanks
Yafang

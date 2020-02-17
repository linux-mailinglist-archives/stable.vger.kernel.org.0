Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F151613F4
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 14:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgBQNwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 08:52:00 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:44446 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgBQNwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 08:52:00 -0500
Received: by mail-io1-f65.google.com with SMTP id z16so18472071iod.11
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 05:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sCJ+p0Vb+K6tWMUVo+6NRjb+ZnIa1bhM/VCrHSW9Fpw=;
        b=UIl3TVdL/RKWxNBloWs1txJrtWy+iMo502sWyMwSwjwss3T5MzKecu70L8rSr/GHoY
         bIYkJG09In0dDU5/WbAgdOIMAG6FNxXXhnBef1k/s3DA8Ju8/Vuqo4JkUqZtS1jOPI3X
         C+9iRiNhPr9kx/BlmZ4RvhADMg1kOAlObxTb8Pfo5NXK9W/77FB0kY7L9UB/h9LJ5YEs
         7Wwk1Taz4nHjejo2rKAB4jtrL4hXpW2AEqWVpCzJhTGYcq9i29g7EbtKOI1lmkgMJM1P
         f43MPDXPKXJmBrGpSXJJNfQx2LPuHfirKNqxaXzM5gmhGb7IHmgcOuogyL0Z+2J+8KuU
         pZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sCJ+p0Vb+K6tWMUVo+6NRjb+ZnIa1bhM/VCrHSW9Fpw=;
        b=E55S4cTBO4oEQgZMjqp6Hdyqh5IixQa8YTJvPf7olYcWpbP3XugFruJq+sRQadFVPk
         dWTwwwl385fto/+f7pl/d1+cAOjcVYkvmsx5pKCgsj+HlRhw2qgcZZPrEqfr5xiA8/Ed
         fnnbnc1Ov+SyBxYGiNYDsVPTX97Wfn4YA7ztSeX5X7GfPgxTqOBSUUv6GsyzzzrpepJV
         6UcY/1ERZy6uQGSP8s9s66lh+jqdtUQj4XH1VPSfXts6cAKUtbxahf+vKXDfZsJzKoAa
         nutzJST8Q+7k0BPLYUadRyIK0O5Oy2d3VHOj6/822UjQqQ8z5RKUIXR721XLpRgfmwsb
         XYrw==
X-Gm-Message-State: APjAAAUUW5pgCkAy4GIQwHU605OHWaNEej4uqmkLudNmgGXhOlNlf0oB
        cn7ZfOmmD+xialApMfc28AESOcKMjlR7cwhRjO8=
X-Google-Smtp-Source: APXvYqwn0NEa/g+vhhWyeD6jEsb7IyCXqAt/zRbG60ECxntPpclt31tC0QlBX0tdn6+ho8SY4UifdLx7FcNbJ7oXqzE=
X-Received: by 2002:a02:b615:: with SMTP id h21mr12223540jam.109.1581947519359;
 Mon, 17 Feb 2020 05:51:59 -0800 (PST)
MIME-Version: 1.0
References: <20200216145249.6900-1-laoar.shao@gmail.com> <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com> <20200217132443.GM31531@dhcp22.suse.cz>
In-Reply-To: <20200217132443.GM31531@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 17 Feb 2020 21:51:23 +0800
Message-ID: <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
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

On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
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
> > >
> > > Please document user visible effects of this patch. What does it mean
> > > that this is not proper behavior?
> >
> > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > but now as the old memcg.{emin, elow} value are still there, it will get
> > a wrong protection value,
> > and the reclaimer can't reclaim the page cache pages protected by this
> > wrong protection.
>
> Could you be more specific please. Your example above says that emin is
> not going to be recalculated and stays at 512M even for a potential max
> limit reclaim. The min limit is still 512M so why is this value wrong?
>

Because the relcaimers are changed or the root the relcaimer is changed.

Kswapd begins to relcaim memcg-A.
kswapd
  |
calculate the {emin, elow} for memcg-A
 |
stores {emin, elow} in memory.{emin, elow} of memcg-A
|
This memory.{emin, elow} will protect the page cache pages in memcg-A
(See get_scan_count->mem_cgroup_protection)
|
exit
(And it won't relcaim memcg-A for a long time)


Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
and the root of this new reclaimer is memcg-A.

This memcg relcaimer begins to reclaim memcg-A.
memcg relcaimer
      |
As the root of the relcaimer is memcg-A, it won't calculate emin, elow
for memcg-A.
(See if (memcg == root) in mem_cgroup_protected())
     |
The old memory.{emin, elow} will protect the page cache pages in memcg-A
(SO WE SHOULD CLEAR THE OLD VALUE)
    |
exit

I try my best to illustrate it. Hope it could clarify.



> > > What happens if we have concurrent
> > > reclaimers at different levels of the hierarchy how that would affect
> > > the resulting protection?
> > >
> >
> > Well, I thought the synchronization mechanisms have already existed ?
> > Otherwise there must be concurrent issue in the original code of
> > setting the memcg.{emin, elow} as well.
> > (Because memcg->memory.{emin, elow} are also set at the end of the
> > function mem_cgroup_protected())
>
> This function is documented to be racy and I believe this is OK because
> it doesn't really have to be precise and concurrent updates are not
> going to change values much. But does the same apply to reseting the
> effective values? Maybe yes. Make sure to document this in the changelog
> please.

Sure. I will document it.


--
Yafang Shao
DiDi

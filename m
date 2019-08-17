Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9890C6C
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 05:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfHQDec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 23:34:32 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44355 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfHQDec (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 23:34:32 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so10226427iop.11;
        Fri, 16 Aug 2019 20:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nun2JfC7ez1tC7LAJQflPI3bnSU4+ToyXIlxSOxQrz4=;
        b=Kf9pb5KBMGYwgI+0kzbxt2Tw9l6jQWED1EcMLYyVY9p34X5qI//6NfdUJ85bl7UOut
         s1N3104WhhoYDJvZFKiKARuM87iDLNA4pJuptcvX3bGp/zAfRIuCUa4tAdo074Gq613V
         tglnLRUXVHX8JtqjPJCijkaatL+EPounGC6BYhLQupL9WRhwWXRcZL0i+ZezrRkfKN+T
         PIPDD1tCGtkTa8zYTSrFkUoBuqhW+V6di30HWLUuRb+iDI3lIsoER3611C9RIdxarQnM
         IFo1RFast19nI6unyTFpAhrOD8obVtGWU/r2hJUiGxGaKTy+lnm+IERqecSNwfOHOsW8
         +vSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nun2JfC7ez1tC7LAJQflPI3bnSU4+ToyXIlxSOxQrz4=;
        b=NCvfjQRDd/A8QBVyxz2c7fpjjLaODQ2ijMmv8WfxP6rGJUYjGrzL97zC0NMm7ThWSs
         eoT+Ns2XmV8cOBFiU7ufOaJc4VZ9mMFsPutpnf0WCc6go3tQzQDTVrJiG0CmzJ8TbyEp
         rtvF9/F18rtojrdgvXWRsvv9g2SBYdwzFrVRDHP3tUMy6vszpLS5vpUV9KzyKKCc2gTl
         vt0oc0x2VgdXUwvAaEMl8R+ksHWGw++h2vjNUoZVzqmPSh4e+D9hNCCA4SpxlA6zFwRl
         g8mj1CEIQ3dS3rH0pAPeUih6or9GHMhII8vK7rcSyIhDkVGc9zGW6sOwy/z4B1Ax1Oev
         9yKA==
X-Gm-Message-State: APjAAAXdsUM0hgMbshX9XyV3FijND4nJkPBQVJypcQdc2Omkkr8bQaLc
        vLqAy7ozSPmTkD6qEnbJLUycQd6nEGHYezTKKWk=
X-Google-Smtp-Source: APXvYqwKthZbb7+MUn8RPnltggGx9a7JJBQSw9zRiBoG31/estvuzXvHwglOzdIzPIn//6QYp4qH7ybz63LJFbuNxdQ=
X-Received: by 2002:a02:54c1:: with SMTP id t184mr15032478jaa.10.1566012871360;
 Fri, 16 Aug 2019 20:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190817004726.2530670-1-guro@fb.com>
In-Reply-To: <20190817004726.2530670-1-guro@fb.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 17 Aug 2019 11:33:57 +0800
Message-ID: <CALOAHbBsMNLN6jZn83zx6EWM_092s87zvDQ7p-MZpY+HStk-1Q@mail.gmail.com>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 17, 2019 at 8:47 AM Roman Gushchin <guro@fb.com> wrote:
>
> Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
> with the hierarchical ones") effectively decreased the precision of
> per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.
>
> That's good for displaying in memory.stat, but brings a serious regression
> into the reclaim process.
>
> One issue I've discovered and debugged is the following:
> lruvec_lru_size() can return 0 instead of the actual number of pages
> in the lru list, preventing the kernel to reclaim last remaining
> pages. Result is yet another dying memory cgroups flooding.
> The opposite is also happening: scanning an empty lru list
> is the waste of cpu time.
>
> Also, inactive_list_is_low() can return incorrect values, preventing
> the active lru from being scanned and freed. It can fail both because
> the size of active and inactive lists are inaccurate, and because
> the number of workingset refaults isn't precise. In other words,
> the result is pretty random.
>
> I'm not sure, if using the approximate number of slab pages in
> count_shadow_number() is acceptable, but issues described above
> are enough to partially revert the patch.
>
> Let's keep per-memcg vmstat_local batched (they are only used for
> displaying stats to the userspace), but keep lruvec stats precise.
> This change fixes the dead memcg flooding on my setup.
>

That will make some misunderstanding if the local counters are not in
sync with the hierarchical ones
(someone may doubt whether there're something leaked.).
If we have to do it like this, I think we should better document this behavior.

> Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Yafang Shao <laoar.shao@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 249187907339..3429340adb56 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -746,15 +746,13 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>         /* Update memcg */
>         __mod_memcg_state(memcg, idx, val);
>
> +       /* Update lruvec */
> +       __this_cpu_add(pn->lruvec_stat_local->count[idx], val);
> +
>         x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
>         if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
>                 struct mem_cgroup_per_node *pi;
>
> -               /*
> -                * Batch local counters to keep them in sync with
> -                * the hierarchical ones.
> -                */
> -               __this_cpu_add(pn->lruvec_stat_local->count[idx], x);
>                 for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
>                         atomic_long_add(x, &pi->lruvec_stat[idx]);
>                 x = 0;
> --
> 2.21.0
>

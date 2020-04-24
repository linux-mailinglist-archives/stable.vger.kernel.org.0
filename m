Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8831B7B1F
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDXQJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgDXQJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:09:18 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDECC09B046
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:09:18 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r2so9760788ilo.6
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 09:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UsWMYKkrDkOQbtsHGozhmdLBVJ2HR7o3td5AsSj8Ooo=;
        b=hVx5ME2cl3wqVtYwDU7hc9fb8HnT8Ghl1gSJgIavqHYnGV4dJT88CW3TOv9rANUe82
         9/nZ3fVzXM8fZMBa735q+1TJfoQSSmBg+ozuN8B03UUHShVK/Q/VgJNG1vN+0MgPR76a
         h1fSAFukJXC0QgNe1iTWqO+WXc4Rmx/ichTjHUJqJFX0vvrn17hu7KQgwgdkSuBlCki7
         tAPfHxzZDx5ILTEfpwXFNXMhOb8bUC3Hm40vTvWOIip/8h9oeKHjQOwvt6Gs9O4no+yg
         xq/MGoKIQZmkW/VkU1n3RAM/kkE6H+SHE9lnwXTjw7JCd5uBh+s5wKuHCupUF2xUQYLF
         rhtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UsWMYKkrDkOQbtsHGozhmdLBVJ2HR7o3td5AsSj8Ooo=;
        b=S4TxBloP48tZiU+05h2Yp77Xi5XAK9s4VL+l6ZbNXJcttSnXIneC/Z6Fdw1IKSJvmY
         te6wDN0xH1FvcQhvgc6+lLT6Yfhyx4coBWvTgp3HAzIQolFPLKPNSMu2E7mMAGKR7KMg
         fc9Xz9c3HqvEFgrBiVN5rJ8nmA9hDAkFOJvZ1Fehp+6bXjsDSnXuU3dyrH6oGse3N0ki
         DmEofY2KJa0aylrVgq5b0vCmBp5Lof6EzQlQa4VhlTAZ0u56lbN4XHisnaY4yZixcg1a
         EA2yZ7ghWHvqtwb84D7E1UOPTlssiMRpnWDK9IjbHvqeL70SxiAUvJyBl9NO5cQisvZe
         hLQQ==
X-Gm-Message-State: AGi0PuZHn/zCTJ02+aWhbiZJXvE0Jz+TXNKHGdOvrsMvmVpuThrpcrlD
        Ss52EzAcFviM2MFZeQnm2HSm5PVEeJAB2+QOkPI=
X-Google-Smtp-Source: APiQypIeTxVmg6JO2iVMzmoVMcLH7YmiNH/ZlHttKBpbcrvkFqm1c7j+GsdDnw3m+h7ip3zo8h3tc/71AB81cjK0yDw=
X-Received: by 2002:a92:5c57:: with SMTP id q84mr9568753ilb.203.1587744557899;
 Fri, 24 Apr 2020 09:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200423061629.24185-1-laoar.shao@gmail.com> <20200424131450.GA495720@cmpxchg.org>
 <20200424134438.GA496852@cmpxchg.org>
In-Reply-To: <20200424134438.GA496852@cmpxchg.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 25 Apr 2020 00:08:41 +0800
Message-ID: <CALOAHbCAH4ZPziC72zZgokZKiz4GWd+6XcZt4tjyLCJm0DvPNQ@mail.gmail.com>
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

On Fri, Apr 24, 2020 at 9:44 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Fri, Apr 24, 2020 at 09:14:52AM -0400, Johannes Weiner wrote:
> > However, mem_cgroup_protected() never expected anybody to look at the
> > effective protection values when it indicated that the cgroup is above
> > its protection. As a result, a query during limit reclaim may return
> > stale protection values that were calculated by a previous reclaim
> > cycle in which the cgroup did have siblings.
>
> Btw, I think there is opportunity to make this a bit less error prone.
>
> We have a mem_cgroup_protected() that returns yes or no, essentially,
> but protection isn't a binary state anymore.
>
> It's also been a bit iffy that it looks like a simple predicate
> function, but it indeed needs to run procedurally for each cgroup in
> order for the calculations throughout the tree to be correct.
>
> It might be better to have a
>
>         mem_cgroup_calculate_protection()
>
> that runs for every cgroup we visit and sets up the internal state;
> then have more self-explanatory query functions on top of that:
>
>         mem_cgroup_below_min()
>         mem_cgroup_below_low()
>         mem_cgroup_protection()
>
> What do you guys think?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e0f502b5fca6..dbd3f75d39b9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2615,14 +2615,15 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>                 unsigned long reclaimed;
>                 unsigned long scanned;
>
> -               switch (mem_cgroup_protected(target_memcg, memcg)) {
> -               case MEMCG_PROT_MIN:
> +               mem_cgroup_calculate_protection(target_memcg, memcg);
> +
> +               if (mem_cgroup_below_min(memcg)) {
>                         /*
>                          * Hard protection.
>                          * If there is no reclaimable memory, OOM.
>                          */
>                         continue;
> -               case MEMCG_PROT_LOW:
> +               } else if (mem_cgroup_below_low(memcg)) {
>                         /*
>                          * Soft protection.
>                          * Respect the protection only as long as
> @@ -2634,16 +2635,6 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>                                 continue;
>                         }
>                         memcg_memory_event(memcg, MEMCG_LOW);
> -                       break;
> -               case MEMCG_PROT_NONE:
> -                       /*
> -                        * All protection thresholds breached. We may
> -                        * still choose to vary the scan pressure
> -                        * applied based on by how much the cgroup in
> -                        * question has exceeded its protection
> -                        * thresholds (see get_scan_count).
> -                        */
> -                       break;
>                 }
>
>                 reclaimed = sc->nr_reclaimed;


After my revist of the memcg protection. I have another idea.

The emin and elow is not decided by the memcg(struct mem_cgroup), but
they are really decided by the reclaim context(struct srhink_control).
So they should not be bound into struct  mem_cgroup, while they are
really should be bound into struct srhink_control.
IOW, we should move emin and elow from struct mem_cgroup into struct
srhink_control.
And they two members in shrink_control will be updated when a new
memcg is to be shrinked.
I haven't thought it deeply, but I think this should be the right thing to do.

Thanks
Yafang



-- 
Thanks
Yafang

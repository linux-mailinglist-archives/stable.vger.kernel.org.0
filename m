Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8883131DB92
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 15:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhBQOka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 09:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbhBQOk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 09:40:28 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554BCC061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 06:39:48 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id h125so2577614lfd.7
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 06:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6gl9Lo83ig+3r4SImbYtQt6vySMRjFSrOz26uq39p6I=;
        b=kvF5qvdWbmtuDAi3w2Kg+NNfVsdfwf87iXRY1trRkLcBsxe1I7L9eHwAcMqQjkvBt/
         igbGwBJXwuL8LVixBG0H3Ga0WuVgpOjF6bRg/rr9hCMM7HdXN0mcb7LfTEPWOBIQfLDX
         RsLVz13eQ9XcTpDBSC1dbZ1/wnp6mIOI6ueT7wtNw9eALH3L6GzVQsj6jYxwUp4fU+2y
         b/Iz474n68GLZDQdoXdC8EuBlrLtqN8ZdAWbvRKpdHsLOsLI00HaI1TE5hIoTzxXEBRl
         WIjjduMCs7iYlLx3JNC0Sg9N8Elxxf3umztqoem/aMWH92Rj+XzvEqSLbgIHw7+XUViR
         OJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6gl9Lo83ig+3r4SImbYtQt6vySMRjFSrOz26uq39p6I=;
        b=lcG3DpVBzuVdUMaZGolvuuXMb+UEz6rLXPEwlTzA94gjhQpBpifN99BzF1YylAmBkn
         1gbCmtcoonXMVSl5knLM0mJ1+sagDglKEaIZ0H2LVEB24Qz+Xi1dSbDvZ1O9Jm7YLlwr
         wEByVuJ0Z8Zb5t961WYypsjlZ8+hXgF+v99Q9bIha0LJncd+NPZyfDOmJclWlWQO5cld
         Mfn0yi4SWWj59qcevqnVrawcSpVZIWzu3wgxcihtinoSAqqi8H/30Yg4JThc7IumFTww
         jkGYvZgybsRHbYUu75dd0P+Dk9vDYeO8P3InPtfc7bDqYZCLxiYRxIxsiagF+Po0BVVq
         vaiw==
X-Gm-Message-State: AOAM5333aMRN7m85FTIEHTRMsbUsfdPUzfukNhMaJzGUT5z3HHQUf5/c
        8leS0FVt7KGl+J/0yaYP+PB6BHZzJbYBLh6eJxyCmQ==
X-Google-Smtp-Source: ABdhPJzjqO+/Q77KhJ+T53fnfmaPnOhExjZ+VnYdF+kYd4PXk7zk75RGHIrYUEdFHNnQQZXXCI5Y1dX1d5fX3tWilv0=
X-Received: by 2002:a05:6512:200a:: with SMTP id a10mr7450509lfb.358.1613572786280;
 Wed, 17 Feb 2021 06:39:46 -0800 (PST)
MIME-Version: 1.0
References: <20210217110907.85120-1-songmuchun@bytedance.com>
In-Reply-To: <20210217110907.85120-1-songmuchun@bytedance.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 17 Feb 2021 06:39:34 -0800
Message-ID: <CALvZod7XLwmjDWQmUxOBoA6LB8N3ZtB507VAmXjsM4goQiVkrA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: memcontrol: fix swap undercounting in cgroup2
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 3:09 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> When pages are swapped in, the VM may retain the swap copy to avoid
> repeated writes in the future. It's also retained if shared pages are
> faulted back in some processes, but not in others. During that time we
> have an in-memory copy of the page, as well as an on-swap copy. Cgroup1
> and cgroup2 handle these overlapping lifetimes slightly differently
> due to the nature of how they account memory and swap:
>
> Cgroup1 has a unified memory+swap counter that tracks a data page
> regardless whether it's in-core or swapped out. On swapin, we transfer
> the charge from the swap entry to the newly allocated swapcache page,
> even though the swap entry might stick around for a while. That's why
> we have a mem_cgroup_uncharge_swap() call inside mem_cgroup_charge().
>
> Cgroup2 tracks memory and swap as separate, independent resources and
> thus has split memory and swap counters. On swapin, we charge the
> newly allocated swapcache page as memory, while the swap slot in turn
> must remain charged to the swap counter as long as its allocated too.
>
> The cgroup2 logic was broken by commit 2d1c498072de ("mm: memcontrol:
> make swap tracking an integral part of memory control"), because it
> accidentally removed the do_memsw_account() check in the branch inside
> mem_cgroup_uncharge() that was supposed to tell the difference between
> the charge transfer in cgroup1 and the separate counters in cgroup2.
>
> As a result, cgroup2 currently undercounts retained swap to varying
> degrees: swap slots are cached up to 50% of the configured limit or
> total available swap space; partially faulted back shared pages are
> only limited by physical capacity. This in turn allows cgroups to
> significantly overconsume their alloted swap space.
>
> Add the do_memsw_account() check back to fix this problem.
>
> Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Cc: stable@vger.kernel.org # 5.8+
> ---
>  v2:
>  - update commit log and add a comment to the code. Very thanks to Johannes.
>
>  mm/memcontrol.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ed5cc78a8dbf..2efbb4f71d5f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6771,7 +6771,19 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
>         memcg_check_events(memcg, page);
>         local_irq_enable();
>
> -       if (PageSwapCache(page)) {
> +       /*
> +        * Cgroup1's unified memory+swap counter has been charged with the
> +        * new swapcache page, finish the transfer by uncharging the swap
> +        * slot. The swap slot would also get uncharged when it dies, but
> +        * it can stick around indefinitely and we'd count the page twice
> +        * the entire time.
> +        *
> +        * Cgroup2 has separate resource counters for memory and swap,
> +        * so this is a non-issue here. Memory and swap charge lifetimes
> +        * correspond 1:1 to page and swap slot lifetimes: we charge the
> +        * page to memory here, and uncharge swap when the slot is freed.
> +        */
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && PageSwapCache(page)) {

do_memsw_account() instead of !cgroup_subsys_on_dfl(memory_cgrp_subsys).

>                 swp_entry_t entry = { .val = page_private(page) };
>                 /*
>                  * The swap entry might not get freed for a long time,
> --
> 2.11.0
>

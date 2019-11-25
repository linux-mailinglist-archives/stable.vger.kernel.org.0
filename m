Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E77109422
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 20:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfKYTUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 14:20:49 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41627 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfKYTUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 14:20:49 -0500
Received: by mail-oi1-f196.google.com with SMTP id e9so14203094oif.8
        for <stable@vger.kernel.org>; Mon, 25 Nov 2019 11:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHLgwwWlJiLxr2ARt5GzYa5qJrBUsXgP8lqORrP4CBI=;
        b=GGHZW0/qHglQhTKyr9FT7LArU+/8B2MJwt0ERTENNILqCOR0zSFG5JQ6h85doOjbHk
         LNTaVuVoX5VDHXd8l/o9UYnIYvh/r+ZYOrUr5VcbqzY5DTyQcIBl8NEIu14TmaCYYAgZ
         ZnSf0kNazLgPtrS24ssoKF1aJsxWI9Zq6ekt/og/UomfWjhdflUN4vEMEdysBkgO69Y4
         EVt2jwQQPfU3MiCLeXDPHG+YExP3K/V9K2RFxGeSFVhn+jx8YiIme2BQGVOb39YkP0sx
         2lZYa0h6a6oKnzbtw/sWu3CYSjSwSo00Kj79t7uQCCl0rrg0l2PegD6+hLz2pQMm/P3h
         nQUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHLgwwWlJiLxr2ARt5GzYa5qJrBUsXgP8lqORrP4CBI=;
        b=M0vnY13Y5P1GNI7DN2wssa7wS5GQtbUGGLx5rg0MOgUfFJN4yc8f5U/m/FIUm0X40c
         BucnwVnXnUZxd7arCeUYBfUPRd0gR2ZFUz/DnjxqVxZNlcoQ9dTyoaLCoNmnjld4nZh5
         22S5tYRUVEWwHeZ2ysAbL+60XDk2wL8usxZEoo222aAizN88QeVOEGspYIgW89m9Svi2
         DL3RW7PPHLOFxHdnFvAJegheRygX1boKFfokc3ftLz2bTeQUHYyFmQYhUw9V16feGiIf
         MN4e32p1M6ZnDY7pnU/Dkf0yEf5FA20oLqz/TI6TexF1awWTOanl5U4Mi512O2wIxlou
         4m9g==
X-Gm-Message-State: APjAAAXjmFjYFkdBRLQw7gTx19RVQ0zvde0WYB+NPMSryYYMkrEb5kit
        AN2K5hfiWEEE101oUwEM9Ag607QE3OdP2OC1aKY7pg==
X-Google-Smtp-Source: APXvYqyD4ah9bhyn/it46CSx9F7IM1K0Q0W5H77mtH0vZkSgt3LuPykHUgPh/okw2tgZ2UWF30HMQ8MfxqKfhIhCQB0=
X-Received: by 2002:aca:4f58:: with SMTP id d85mr403850oib.142.1574709647312;
 Mon, 25 Nov 2019 11:20:47 -0800 (PST)
MIME-Version: 1.0
References: <20191125185453.278468-1-guro@fb.com>
In-Reply-To: <20191125185453.278468-1-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 25 Nov 2019 11:20:35 -0800
Message-ID: <CALvZod7bsZcHZpd5i8ahAdKOhOCRxdLTrXCf78vg4_OENqUL9Q@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
To:     Roman Gushchin <guro@fb.com>
Cc:     Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 25, 2019 at 10:55 AM Roman Gushchin <guro@fb.com> wrote:
>
> Christian reported a warning like the following obtained during running some
> KVM-related tests on s390:
>
> WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x50/0x58
> Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_na>
> CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
> Hardware name: IBM 2964 NC9 712 (LPAR)
> Workqueue: events sysfs_slab_remove_workfn
> Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 0036008100000000
>            0000001f00000000 0035008100000000 0000001fb3573ab8 0000000000000000
>            0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb3573b00
>            0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e009263cd0
> Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2046,0
>            0000001529746848: 47000700            bc         0,1792
>           #000000152974684c: a7f40001            brc        15,152974684e
>           >0000001529746850: a7f4fff2            brc        15,1529746834
>            0000001529746854: 0707                bcr        0,%r7
>            0000001529746856: 0707                bcr        0,%r7
>            0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%r15)
>            000000152974685e: a738ffff            lhi        %r3,-1
> Call Trace:
> ([<000003e009263d00>] 0x3e009263d00)
>  [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70
>  [<0000001529b04882>] kobject_put+0xaa/0xe8
>  [<000000152918cf28>] process_one_work+0x1e8/0x428
>  [<000000152918d1b0>] worker_thread+0x48/0x460
>  [<00000015291942c6>] kthread+0x126/0x160
>  [<0000001529b22344>] ret_from_fork+0x28/0x30
>  [<0000001529b2234c>] kernel_thread_starter+0x0/0x10
> Last Breaking-Event-Address:
>  [<000000152974684c>] percpu_ref_exit+0x4c/0x58
> ---[ end trace b035e7da5788eb09 ]---
>
> The problem occurs because kmem_cache_destroy() is called immediately
> after deleting of a memcg, so it races with the memcg kmem_cache
> deactivation.
>
> flush_memcg_workqueue() at the beginning of kmem_cache_destroy()
> is supposed to guarantee that all deactivation processes are finished,
> but failed to do so. It waits for an rcu grace period, after which all
> children kmem_caches should be deactivated. During the deactivation
> percpu_ref_kill() is called for non root kmem_cache refcounters,
> but it requires yet another rcu grace period to finish the transition
> to the atomic (dead) state.
>
> So in a rare case when not all children kmem_caches are destroyed
> at the moment when the root kmem_cache is about to be gone, we need
> to wait another rcu grace period before destroying the root
> kmem_cache.
>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
> Signed-off-by: Roman Gushchin <guro@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

> Cc: stable@vger.kernel.org
> ---
>  mm/slab_common.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 8afa188f6e20..f0ab6d4ceb4c 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -904,6 +904,18 @@ static void flush_memcg_workqueue(struct kmem_cache *s)
>          * previous workitems on workqueue are processed.
>          */
>         flush_workqueue(memcg_kmem_cache_wq);
> +
> +       /*
> +        * If we're racing with children kmem_cache deactivation, it might
> +        * take another rcu grace period to complete their destruction.
> +        * At this moment the corresponding percpu_ref_kill() call should be
> +        * done, but it might take another rcu grace period to complete
> +        * switching to the atomic mode.
> +        * Please, note that we check without grabbing the slab_mutex. It's safe
> +        * because at this moment the children list can't grow.
> +        */
> +       if (!list_empty(&s->memcg_params.children))
> +               rcu_barrier();
>  }
>  #else
>  static inline int shutdown_memcg_caches(struct kmem_cache *s)
> --
> 2.23.0
>

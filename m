Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A463E2B7D
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 15:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344106AbhHFNh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 09:37:59 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:47021 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243524AbhHFNh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 09:37:59 -0400
Received: by mail-oi1-f182.google.com with SMTP id o185so12085399oih.13;
        Fri, 06 Aug 2021 06:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WBz3yCwovYGiUJQyt7oAsv1t5Ex82kjmh1q1MQXkgNQ=;
        b=gfDlHBJjLwVc/+42dsdLYWGVZ//LJ1v4WBd2Nli/c+tjaXmr5o6rD7VwNLHLKfnEDY
         NwUGuT0s3s5h/vBMI/JL5LtXgp1beVY3++6/alIH3qmhX0O5XRX1Yg37Gl0Nk1XNKgZh
         cumKLPPXq6jXwTRA62WH7XA0yVjFC8j3UZ6SDpZFrhbXWIop+o9z5+auiYSbxPfPuk6I
         Uo6J58CwFdUebi744oDfcXGXrzT1FbnQ0YvXdtnhXZa9CFbgTU7ItVoK27rjBn/cUvHy
         qahkQf1lVYOocoExnhmD09nD2vzmV+3o8WharQv7F3zoY2t8n+J24sKnEaOuQxmGkdS2
         v6YA==
X-Gm-Message-State: AOAM533RhRk2x8YXsCjFreSfem6iFUk/R3JGTLwjgwjKnm8eHr8LHD88
        IaG1fuGBUagnxSBmbCGkQ6XeCUO8N43suHwFrw4=
X-Google-Smtp-Source: ABdhPJwIEWeMHn6ZahOrVey+k37ofDhI6ttbToCchd2fppgEyqJYg1/obs+8u3udRwYNUmSYoaugqBbGz0j5eOjwWCw=
X-Received: by 2002:aca:c416:: with SMTP id u22mr578501oif.71.1628257063251;
 Fri, 06 Aug 2021 06:37:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210805072917.8762-1-haokexin@gmail.com> <20210805073516.qzpzifjoqluqfwhy@vireshk-i7>
In-Reply-To: <20210805073516.qzpzifjoqluqfwhy@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 6 Aug 2021 15:37:32 +0200
Message-ID: <CAJZ5v0ht4v9ch9ZKY28v4B0JKQ0tOgwd3SpwHZGBwuiYSJjh8g@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: schedutil: Use kobject release() method to
 free sugov_tunables
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        Kevin Hao <haokexin@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 5, 2021 at 9:35 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On 05-08-21, 15:29, Kevin Hao wrote:
> > The struct sugov_tunables is protected by the kobject, so we can't free
> > it directly. Otherwise we would get a call trace like this:
> >   ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x30
> >   WARNING: CPU: 3 PID: 720 at lib/debugobjects.c:505 debug_print_object+0xb8/0x100
> >   Modules linked in:
> >   CPU: 3 PID: 720 Comm: a.sh Tainted: G        W         5.14.0-rc1-next-20210715-yocto-standard+ #507
> >   Hardware name: Marvell OcteonTX CN96XX board (DT)
> >   pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> >   pc : debug_print_object+0xb8/0x100
> >   lr : debug_print_object+0xb8/0x100
> >   sp : ffff80001ecaf910
> >   x29: ffff80001ecaf910 x28: ffff00011b10b8d0 x27: ffff800011043d80
> >   x26: ffff00011a8f0000 x25: ffff800013cb3ff0 x24: 0000000000000000
> >   x23: ffff80001142aa68 x22: ffff800011043d80 x21: ffff00010de46f20
> >   x20: ffff800013c0c520 x19: ffff800011d8f5b0 x18: 0000000000000010
> >   x17: 6e6968207473696c x16: 5f72656d6974203a x15: 6570797420746365
> >   x14: 6a626f2029302065 x13: 303378302f307830 x12: 2b6e665f72656d69
> >   x11: ffff8000124b1560 x10: ffff800012331520 x9 : ffff8000100ca6b0
> >   x8 : 000000000017ffe8 x7 : c0000000fffeffff x6 : 0000000000000001
> >   x5 : ffff800011d8c000 x4 : ffff800011d8c740 x3 : 0000000000000000
> >   x2 : ffff0001108301c0 x1 : ab3c90eedf9c0f00 x0 : 0000000000000000
> >   Call trace:
> >    debug_print_object+0xb8/0x100
> >    __debug_check_no_obj_freed+0x1c0/0x230
> >    debug_check_no_obj_freed+0x20/0x88
> >    slab_free_freelist_hook+0x154/0x1c8
> >    kfree+0x114/0x5d0
> >    sugov_exit+0xbc/0xc0
> >    cpufreq_exit_governor+0x44/0x90
> >    cpufreq_set_policy+0x268/0x4a8
> >    store_scaling_governor+0xe0/0x128
> >    store+0xc0/0xf0
> >    sysfs_kf_write+0x54/0x80
> >    kernfs_fop_write_iter+0x128/0x1c0
> >    new_sync_write+0xf0/0x190
> >    vfs_write+0x2d4/0x478
> >    ksys_write+0x74/0x100
> >    __arm64_sys_write+0x24/0x30
> >    invoke_syscall.constprop.0+0x54/0xe0
> >    do_el0_svc+0x64/0x158
> >    el0_svc+0x2c/0xb0
> >    el0t_64_sync_handler+0xb0/0xb8
> >    el0t_64_sync+0x198/0x19c
> >   irq event stamp: 5518
> >   hardirqs last  enabled at (5517): [<ffff8000100cbd7c>] console_unlock+0x554/0x6c8
> >   hardirqs last disabled at (5518): [<ffff800010fc0638>] el1_dbg+0x28/0xa0
> >   softirqs last  enabled at (5504): [<ffff8000100106e0>] __do_softirq+0x4d0/0x6c0
> >   softirqs last disabled at (5483): [<ffff800010049548>] irq_exit+0x1b0/0x1b8
> >
> > So split the original sugov_tunables_free() into two functions,
> > sugov_clear_global_tunables() is just used to clear the global_tunables
> > and the new sugov_tunables_free() is used as kobj_type::release to
> > release the sugov_tunables safely.
> >
> > Fixes: 9bdcb44e391d ("cpufreq: schedutil: New governor based on scheduler utilization data")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > ---
> > v2: Introduce sugov_clear_global_tunables() as suggested by Rafael.
> >
> >  kernel/sched/cpufreq_schedutil.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > index 57124614363d..e7af18857371 100644
> > --- a/kernel/sched/cpufreq_schedutil.c
> > +++ b/kernel/sched/cpufreq_schedutil.c
> > @@ -537,9 +537,17 @@ static struct attribute *sugov_attrs[] = {
> >  };
> >  ATTRIBUTE_GROUPS(sugov);
> >
> > +static void sugov_tunables_free(struct kobject *kobj)
> > +{
> > +     struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
> > +
> > +     kfree(to_sugov_tunables(attr_set));
> > +}
> > +
> >  static struct kobj_type sugov_tunables_ktype = {
> >       .default_groups = sugov_groups,
> >       .sysfs_ops = &governor_sysfs_ops,
> > +     .release = &sugov_tunables_free,
> >  };
> >
> >  /********************** cpufreq governor interface *********************/
> > @@ -639,12 +647,10 @@ static struct sugov_tunables *sugov_tunables_alloc(struct sugov_policy *sg_polic
> >       return tunables;
> >  }
> >
> > -static void sugov_tunables_free(struct sugov_tunables *tunables)
> > +static void sugov_clear_global_tunables(void)
> >  {
> >       if (!have_governor_per_policy())
> >               global_tunables = NULL;
> > -
> > -     kfree(tunables);
> >  }
> >
> >  static int sugov_init(struct cpufreq_policy *policy)
> > @@ -707,7 +713,7 @@ static int sugov_init(struct cpufreq_policy *policy)
> >  fail:
> >       kobject_put(&tunables->attr_set.kobj);
> >       policy->governor_data = NULL;
> > -     sugov_tunables_free(tunables);
> > +     sugov_clear_global_tunables();
> >
> >  stop_kthread:
> >       sugov_kthread_stop(sg_policy);
> > @@ -734,7 +740,7 @@ static void sugov_exit(struct cpufreq_policy *policy)
> >       count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
> >       policy->governor_data = NULL;
> >       if (!count)
> > -             sugov_tunables_free(tunables);
> > +             sugov_clear_global_tunables();
> >
> >       mutex_unlock(&global_tunables_lock);
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied as 5.15 material.

However, since I'm on vacation next week, it will show up in
linux-next after -rc6.

Thanks!

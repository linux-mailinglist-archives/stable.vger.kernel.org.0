Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE0BCEF9A
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 01:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJGX3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 19:29:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36723 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbfJGX3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 19:29:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so1173793wmc.1
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 16:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=piaZbYWTjNBhZkZDmofwj+4KxlQj6g4yPVECpKaNgh0=;
        b=NiANENA7BMEGBVN9ysemZd4hhOVcXGa8kHkzWeYSeDhzNZCOHOhkUkatxk11rSm62q
         XIsUc5VDV6Hngd0MAiclj+ZLPhCH+hL8R2j48Dy+o99nvOA5sOq6I7fA9oTVoMNfuOBk
         q0vo9i5FfaabitzQm7e4G4yU0jFasD+DQJeuCtHtuWs80eV00OAccDAsdfeKJ5Pl6LD6
         ylv/gjadfyppKGzMNpI4Hb6VG4kMO4QFNKgPm5RXpSCdlYOW6YwaDyxJ/wMSJwNLAXHy
         kPujoEKk6uKMMY6SGvqL47k9ASnc5Ujov5yflMax3t77c9duswCG5Gb6Mc0n0mXNDomU
         UmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=piaZbYWTjNBhZkZDmofwj+4KxlQj6g4yPVECpKaNgh0=;
        b=X0Kbt6gAC6aHp6q3ljoEy7KipHNO5U+gJ2uAXhk6SyaccCnUewf12Y4uHAwFg5mg1Q
         O5jNSYbWU3cLkyqzkVWadgDtXxAhNen0CA3JWuwzuDWYagfGWhA/veiBQ+Q2xv1oLwHO
         xgW6UVherTSbWPZyu1ujcN/5++kDl533lDV5VqZgSowbzCFvnXZHI8122QoE86MhzK9N
         D+7HAYZ4kUduS5vTHHS9dHYy4ggsphAFxAI7icRrruH4rojsGtjApM3ionqOREI6tSh2
         wjyPLLKQgImMAzm1gEsHnarO1jiBB/hRQK8V5mXTY2SUWZgTFe+CLAuHpgadT3TMpJw1
         eOpg==
X-Gm-Message-State: APjAAAV8HsmdbPw2tNXUDvlFuX762yPXP7UTxfyg4LpA2g0fNxw0SO1e
        bZm6rHrVrlHVkHpirMVTsSBC7pWb+WHSPuti/B3SLw==
X-Google-Smtp-Source: APXvYqz1rRP6Dq0sqy2os+gMYJxDYbuP41FyEHm7il/rYBtc6impu4RdlVLaJHWyKhxmS+lup4gs+XOJnCQ5bJfB8zU=
X-Received: by 2002:a1c:3182:: with SMTP id x124mr1385909wmx.168.1570490953213;
 Mon, 07 Oct 2019 16:29:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191004001243.140897-1-xueweiz@google.com> <20191007151425.GD22412@pauld.bos.csb>
In-Reply-To: <20191007151425.GD22412@pauld.bos.csb>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Mon, 7 Oct 2019 16:29:01 -0700
Message-ID: <CAPtwhKq7Asr2L04im84HbhRVtYJrJT2zu_rydB7YiTG=fxSSNg@mail.gmail.com>
Subject: Re: [PATCH] sched/fair: scale quota and period without losing
 quota/period ratio precision
To:     Phil Auld <pauld@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        trivial@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 7, 2019 at 8:14 AM Phil Auld <pauld@redhat.com> wrote:
>
> On Thu, Oct 03, 2019 at 05:12:43PM -0700 Xuewei Zhang wrote:
> > quota/period ratio is used to ensure a child task group won't get more
> > bandwidth than the parent task group, and is calculated as:
> > normalized_cfs_quota() = [(quota_us << 20) / period_us]
> >
> > If the quota/period ratio was changed during this scaling due to
> > precision loss, it will cause inconsistency between parent and child
> > task groups. See below example:
> > A userspace container manager (kubelet) does three operations:
> > 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
> > 2) Create a few children cgroups.
> > 3) Set quota to 1,000us and period to 10,000us on a child cgroup.
> >
> > These operations are expected to succeed. However, if the scaling of
> > 147/128 happens before step 3), quota and period of the parent cgroup
> > will be changed:
> > new_quota: 1148437ns, 1148us
> > new_period: 11484375ns, 11484us
> >
> > And when step 3) comes in, the ratio of the child cgroup will be 104857,
> > which will be larger than the parent cgroup ratio (104821), and will
> > fail.
> >
> > Scaling them by a factor of 2 will fix the problem.
> >
> > Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> > Signed-off-by: Xuewei Zhang <xueweiz@google.com>
>
>
> I managed to get it to trigger the second case. It took 50,000 children (20x my initial tests).
>
> [ 1367.850630] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 4340, cfs_quota_us = 250000)
> [ 1370.390832] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 8680, cfs_quota_us = 500000)
> [ 1372.914689] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 17360, cfs_quota_us = 1000000)
> [ 1375.447431] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 34720, cfs_quota_us = 2000000)
> [ 1377.982785] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 69440, cfs_quota_us = 4000000)
> [ 1380.481702] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 138880, cfs_quota_us = 8000000)
> [ 1382.894692] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 277760, cfs_quota_us = 16000000)
> [ 1385.264872] cfs_period_timer[cpu11]: period too short, scaling up (new cfs_period_us = 555520, cfs_quota_us = 32000000)
> [ 1393.965140] cfs_period_timer[cpu11]: period too short, but cannot scale up without losing precision (cfs_period_us = 555520, cfs_quota_us = 32000000)
>
> I suspect going higher could cause the original lockup, but that'd be the case with the old code as well.
> And this also gets us out of it faster.
>
>
> Tested-by: Phil Auld <pauld@redhat.com>

Thanks a lot for the review and experiment+test Phil! Really appreciate it.

To other scheduler maintainers: Could someone help review and approve
the patch? I'm happy to fix any defect in it :)

Best regards,
Xuewei

>
>
> Cheers,
> Phil
>
>
> > ---
> >  kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
> >  1 file changed, 22 insertions(+), 14 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 83ab35e2374f..b3d3d0a231cd 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4926,20 +4926,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> >               if (++count > 3) {
> >                       u64 new, old = ktime_to_ns(cfs_b->period);
> >
> > -                     new = (old * 147) / 128; /* ~115% */
> > -                     new = min(new, max_cfs_quota_period);
> > -
> > -                     cfs_b->period = ns_to_ktime(new);
> > -
> > -                     /* since max is 1s, this is limited to 1e9^2, which fits in u64 */
> > -                     cfs_b->quota *= new;
> > -                     cfs_b->quota = div64_u64(cfs_b->quota, old);
> > -
> > -                     pr_warn_ratelimited(
> > -     "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
> > -                             smp_processor_id(),
> > -                             div_u64(new, NSEC_PER_USEC),
> > -                             div_u64(cfs_b->quota, NSEC_PER_USEC));
> > +                     /*
> > +                      * Grow period by a factor of 2 to avoid lossing precision.
> > +                      * Precision loss in the quota/period ratio can cause __cfs_schedulable
> > +                      * to fail.
> > +                      */
> > +                     new = old * 2;
> > +                     if (new < max_cfs_quota_period) {
> > +                             cfs_b->period = ns_to_ktime(new);
> > +                             cfs_b->quota *= 2;
> > +
> > +                             pr_warn_ratelimited(
> > +     "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> > +                                     smp_processor_id(),
> > +                                     div_u64(new, NSEC_PER_USEC),
> > +                                     div_u64(cfs_b->quota, NSEC_PER_USEC));
> > +                     } else {
> > +                             pr_warn_ratelimited(
> > +     "cfs_period_timer[cpu%d]: period too short, but cannot scale up without losing precision (cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> > +                                     smp_processor_id(),
> > +                                     div_u64(old, NSEC_PER_USEC),
> > +                                     div_u64(cfs_b->quota, NSEC_PER_USEC));
> > +                     }
> >
> >                       /* reset count so we don't come right back in here */
> >                       count = 0;
> > --
> > 2.23.0.581.g78d2f28ef7-goog
> >
>
> --

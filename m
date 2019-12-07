Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7B5115A7D
	for <lists+stable@lfdr.de>; Sat,  7 Dec 2019 02:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfLGBHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 20:07:31 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42650 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfLGBHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 20:07:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so9662701wrf.9
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 17:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onZcJeDYb3FjdAan1fVAUhFPGrNAAhgjak9w90j8KVE=;
        b=pStCmsVUg66/Ygd6PfhsDLAPnKmOgUN0mZGu8FCRxplkB+wvOP0EutRwuPlXbPct2a
         DeXcZShWPqttlbq6FDzKwg5p9Q4iq92NwcLB3FpCpZUK81GhOYWo8SOEO+slQB/PYBml
         W7acsdpnCg1V7ST65UQX3WCd203uOZRzTvVvLcD8lp5y6AM0s25i9kXX+D6aXG9vde6T
         BL/KxNOrMJyVYtH4FfSSMrFccIU5LYGEL5lI1OQ4c3RxVItRCgxt7CfNv7W+fhOajGXz
         H/qy2L4Vij+4TrpIXidBYOyJlXCd9YS7oUIl96gsURSuTa1aS0j9yCFFq1c6E7n7TC1f
         lpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onZcJeDYb3FjdAan1fVAUhFPGrNAAhgjak9w90j8KVE=;
        b=PhDNZA0aGQX3vxXgRjwHHPfWNCo5CbPFuEsnVge8IdkpFiJnd+MEokdyMUewuvqWtM
         +0qmOi1zgOkPqboOCCYlBvgnGszoQkj6hbgViUzq0Nk/9muefvPHTmjtqrf6SueFU2Xu
         P0lNZXIODM/1PHbmkt185oMc27DQ66yWfVeNoDN0mcDn/X+am3R2f4WB1ygr5DJlY5fA
         frXmaJguSoZ5fXJ8F47ZyW77AGfG23X4HwE01WNRC5A4t0CKKrEB+9+I0MB8/EXczmNb
         YPa4+5qL/LIjKkoQ2zhiTnG/19xPnBKkchRhfbv+XUpvsghsnfvlrnVoVugC3z45zb6N
         /3mQ==
X-Gm-Message-State: APjAAAVAoqAp5Om/FN9af0rd1JmRjf4ABTZTq91DLSdDuQ8ltRlxUUSK
        zXnCMP/qEeYtlWg0XsMWTEt2dRT+24Po1P/4jgsnBQ==
X-Google-Smtp-Source: APXvYqxg5Z8tt8j625w1RADTHf6wAnG02LAen1XMKSBYnxVr0v/pW7Kx3Wxe7heOtD2meyg5xtRaz/7/abSKPSQvsGU=
X-Received: by 2002:adf:dfc1:: with SMTP id q1mr17835457wrn.155.1575680847957;
 Fri, 06 Dec 2019 17:07:27 -0800 (PST)
MIME-Version: 1.0
References: <20191207010443.111374-1-xueweiz@google.com>
In-Reply-To: <20191207010443.111374-1-xueweiz@google.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Fri, 6 Dec 2019 17:07:16 -0800
Message-ID: <CAPtwhKqjkm-XN3+c27XVPqUJKpx7cMR2kDtf3p10bKW3-3HP-g@mail.gmail.com>
Subject: Re: [PATCH v4.19] sched/fair: Scale bandwidth quota and period
 without losing quota/period ratio precision
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 6, 2019 at 5:04 PM Xuewei Zhang <xueweiz@google.com> wrote:

Sorry. I forgot to add the upstream line:
"commit 4929a4e6faa0f13289a67cae98139e727f0d4a97 upstream."

Sending a new patch. Please ignore this one. Sorry about that.

>
> The quota/period ratio is used to ensure a child task group won't get
> more bandwidth than the parent task group, and is calculated as:
>
>   normalized_cfs_quota() = [(quota_us << 20) / period_us]
>
> If the quota/period ratio was changed during this scaling due to
> precision loss, it will cause inconsistency between parent and child
> task groups.
>
> See below example:
>
> A userspace container manager (kubelet) does three operations:
>
>  1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
>  2) Create a few children cgroups.
>  3) Set quota to 1,000us and period to 10,000us on a child cgroup.
>
> These operations are expected to succeed. However, if the scaling of
> 147/128 happens before step 3, quota and period of the parent cgroup
> will be changed:
>
>   new_quota: 1148437ns,   1148us
>  new_period: 11484375ns, 11484us
>
> And when step 3 comes in, the ratio of the child cgroup will be
> 104857, which will be larger than the parent cgroup ratio (104821),
> and will fail.
>
> Scaling them by a factor of 2 will fix the problem.
>
> Tested-by: Phil Auld <pauld@redhat.com>
> Signed-off-by: Xuewei Zhang <xueweiz@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Acked-by: Phil Auld <pauld@redhat.com>
> Cc: Anton Blanchard <anton@ozlabs.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> Link: https://lkml.kernel.org/r/20191004001243.140897-1-xueweiz@google.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f77fcd37b226..f0abb8fe0ae9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4868,20 +4868,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
>                 if (++count > 3) {
>                         u64 new, old = ktime_to_ns(cfs_b->period);
>
> -                       new = (old * 147) / 128; /* ~115% */
> -                       new = min(new, max_cfs_quota_period);
> -
> -                       cfs_b->period = ns_to_ktime(new);
> -
> -                       /* since max is 1s, this is limited to 1e9^2, which fits in u64 */
> -                       cfs_b->quota *= new;
> -                       cfs_b->quota = div64_u64(cfs_b->quota, old);
> -
> -                       pr_warn_ratelimited(
> -        "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
> -                               smp_processor_id(),
> -                               div_u64(new, NSEC_PER_USEC),
> -                                div_u64(cfs_b->quota, NSEC_PER_USEC));
> +                       /*
> +                        * Grow period by a factor of 2 to avoid losing precision.
> +                        * Precision loss in the quota/period ratio can cause __cfs_schedulable
> +                        * to fail.
> +                        */
> +                       new = old * 2;
> +                       if (new < max_cfs_quota_period) {
> +                               cfs_b->period = ns_to_ktime(new);
> +                               cfs_b->quota *= 2;
> +
> +                               pr_warn_ratelimited(
> +       "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> +                                       smp_processor_id(),
> +                                       div_u64(new, NSEC_PER_USEC),
> +                                       div_u64(cfs_b->quota, NSEC_PER_USEC));
> +                       } else {
> +                               pr_warn_ratelimited(
> +       "cfs_period_timer[cpu%d]: period too short, but cannot scale up without losing precision (cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> +                                       smp_processor_id(),
> +                                       div_u64(old, NSEC_PER_USEC),
> +                                       div_u64(cfs_b->quota, NSEC_PER_USEC));
> +                       }
>
>                         /* reset count so we don't come right back in here */
>                         count = 0;
> --
> 2.24.0.393.g34dc348eaf-goog
>

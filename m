Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF742CC6E9
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 02:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbfJEA2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 20:28:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54361 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEA2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 20:28:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so7384750wmp.4
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 17:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PJwesKN0Is219mNF64hfY/kw11eEsy/0j8tNwxs1DJA=;
        b=AnMhXUJF8+z1tHPJ/FIGM3DCjkcy+X4PJ54beMEF9AtkwdC/DOMI9laxGlWaZjqVTN
         nIeyLmUvn9iIzav2DU2x8LrjJGxKQOxnCLfMklyirLjaCI0136T+RdNhWeeQYwLvvHHM
         StsrTa3d9+RVd7wSzgkdKdoFELxUUI9DV09w3FnFj2p734jyEFyT8CoveJIXLPbPU7T8
         McaSLpA1fc167vTehFKxoIzA+b8j4FniXKBKAyfYRPWhxBdTKptpE8NO9UPeTCFxyQJL
         nEl0WjnEwzafQc4JYmjgnczf9A/gaqRTJCMfVFms4Mcnpf5e3YyhaM8SSr0UAmR+kzV2
         +JIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PJwesKN0Is219mNF64hfY/kw11eEsy/0j8tNwxs1DJA=;
        b=ewj7lbOCQF4quI64RJILZwIawtzlB4sOJO8+h1pWIFUtmW3bm+sDR9yv6r87ktoaSx
         NmN3SuZCbNWmrsh83i8xNKPHZn5Ey3SO7gdMFRazkHzL5MX0Mz/6r/v22Dz+oT5tk3Ox
         nFi8NL9jjfHsMWHXnA9E6eZ5Lji2klRSQWv0+B7FY5/T12btYnoxnqVhQ+gBHV8cjkqn
         KmCWdxX2tmULkUVGif6pdQn6RxkTzude6zs1HZv3H5PSKqQd6NuZTRBNHnJetPaLMtHH
         pzBwq3wHH28tCgfHvd2RdgQSPFYAeYQSu1DPnUP2t0Pu6rYo30nRknnb1TKRzwEWMyeT
         Ix2Q==
X-Gm-Message-State: APjAAAWkxg3LEvz9GRRJwQMiLUETNvk8ILF+/hWwP9f/w4GidTiS3FpF
        nQjgeFKAcJaajEku7iFjaI2s3UazccTBVwlsJvnIfQ==
X-Google-Smtp-Source: APXvYqzI0rIG0wqXAwtaDOJKrCcsCfXxfx+Mka86mIDcf7oXXqxJStAEgz+oeCVqpjtjJlqjXM+ugYQ+pd6SDyI5+Bc=
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr12087632wmi.108.1570235306479;
 Fri, 04 Oct 2019 17:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191004001243.140897-1-xueweiz@google.com> <20191004005423.GA19076@lorien.usersys.redhat.com>
 <CAPtwhKrswHQ1Ue2YO2hJi7h-Dsk6eGPiQ2UmLCq1AxGxMoHr2w@mail.gmail.com> <20191004131432.GA9498@pauld.bos.csb>
In-Reply-To: <20191004131432.GA9498@pauld.bos.csb>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Fri, 4 Oct 2019 17:28:15 -0700
Message-ID: <CAPtwhKo1YND6VG1u8brj8ZRpn33p2xH1cdSRBs-cBSEm78V=Lw@mail.gmail.com>
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
        trivial@kernel.org, Neel Natu <neelnatu@google.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 4, 2019 at 6:14 AM Phil Auld <pauld@redhat.com> wrote:
>
> On Thu, Oct 03, 2019 at 07:05:56PM -0700 Xuewei Zhang wrote:
> > +cc neelnatu@google.com and haoluo@google.com, they helped a lot
> > for this issue. Sorry I forgot to include them when sending out the patch.
> >
> > On Thu, Oct 3, 2019 at 5:55 PM Phil Auld <pauld@redhat.com> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, Oct 03, 2019 at 05:12:43PM -0700 Xuewei Zhang wrote:
> > > > quota/period ratio is used to ensure a child task group won't get more
> > > > bandwidth than the parent task group, and is calculated as:
> > > > normalized_cfs_quota() = [(quota_us << 20) / period_us]
> > > >
> > > > If the quota/period ratio was changed during this scaling due to
> > > > precision loss, it will cause inconsistency between parent and child
> > > > task groups. See below example:
> > > > A userspace container manager (kubelet) does three operations:
> > > > 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
> > > > 2) Create a few children cgroups.
> > > > 3) Set quota to 1,000us and period to 10,000us on a child cgroup.
> > > >
> > > > These operations are expected to succeed. However, if the scaling of
> > > > 147/128 happens before step 3), quota and period of the parent cgroup
> > > > will be changed:
> > > > new_quota: 1148437ns, 1148us
> > > > new_period: 11484375ns, 11484us
> > > >
> > > > And when step 3) comes in, the ratio of the child cgroup will be 104857,
> > > > which will be larger than the parent cgroup ratio (104821), and will
> > > > fail.
> > > >
> > > > Scaling them by a factor of 2 will fix the problem.
> > >
> > > I have no issues with the concept. We went around a bit about the actual
> > > numbers and made it an approximation.
> > >
> > > >
> > > > Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> > > > Signed-off-by: Xuewei Zhang <xueweiz@google.com>
> > > > ---
> > > >  kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
> > > >  1 file changed, 22 insertions(+), 14 deletions(-)
> > > >
> > > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > > > index 83ab35e2374f..b3d3d0a231cd 100644
> > > > --- a/kernel/sched/fair.c
> > > > +++ b/kernel/sched/fair.c
> > > > @@ -4926,20 +4926,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> > > >               if (++count > 3) {
> > > >                       u64 new, old = ktime_to_ns(cfs_b->period);
> > > >
> > > > -                     new = (old * 147) / 128; /* ~115% */
> > > > -                     new = min(new, max_cfs_quota_period);
> > > > -
> > > > -                     cfs_b->period = ns_to_ktime(new);
> > > > -
> > > > -                     /* since max is 1s, this is limited to 1e9^2, which fits in u64 */
> > > > -                     cfs_b->quota *= new;
> > > > -                     cfs_b->quota = div64_u64(cfs_b->quota, old);
> > > > -
> > > > -                     pr_warn_ratelimited(
> > > > -     "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
> > > > -                             smp_processor_id(),
> > > > -                             div_u64(new, NSEC_PER_USEC),
> > > > -                             div_u64(cfs_b->quota, NSEC_PER_USEC));
> > > > +                     /*
> > > > +                      * Grow period by a factor of 2 to avoid lossing precision.
> > > > +                      * Precision loss in the quota/period ratio can cause __cfs_schedulable
> > > > +                      * to fail.
> > > > +                      */
> > > > +                     new = old * 2;
> > > > +                     if (new < max_cfs_quota_period) {
> > >
> > > I don't like this part as much. There may be a value between
> > > max_cfs_quota_period/2 and max_cfs_quota_period that would get us out of
> > > the loop. Possibly in practice it won't matter but here you trigger the
> > > warning and take no action to keep it from continuing.
> > >
> > > Also, if you are actually hitting this then you might want to just start at
> > > a higher but proportional quota and period.
> >
> > I'd like to do what you suggested. A quick idea would be to scale period to
> > max_cfs_quota_period, and scale quota proportionally. However the naive
> > implementation won't work under this edge case:
> > original:
> > quota: 500,000us  period: 570,000us
> > after scaling:
> > quota: 877,192us  period: 1,000,000us
> > original ratio: 919803
> > new ratio: 919802
> >
> > To do this right, the code would have to keep an eye out on the precision loss,
> > and increase quota by 1us sometimes to cancel out the precision loss.
> >
> > Also, I think this case is not that important. Because if we are
> > hitting this case, that
> > suggests the period is already >0.5s. And if we are still hitting
> > timeouts with a 0.5s
> > period, scaling it to 1s probably won't help much.
> > When this happens, I'd imagine the parent cgroup would have a LOT of child
> > cgroups. It might make sense for the userspace to create the parent cgroup with
> > 1s period.
> >
> > If you think automatically scaling 0.5s+ to 1s is still important, I'm
> > happy to stash
> > this patch, and send in another one that handles the 0.5+s -> 1s
> > scaling the right
> > way. :) Thanks!
>
> First let me understand your use case better. I was thinking about this more last
> night and it doesn't make sense.
>
> You are setting a small quota and period on the parent cgroup and then setting the
> same small quota and period on the child. As you say to keep the child from getting
> more quota than the parent. But that should already be the case simply by setting
> it on the parent. The child can't get more quota than the parent.   All this does
> is make the kernel do more work handling more period timers and such.

Sorry for not being clear enough. Let me provide a bit more additional context:

kubelet [1] is the userspace program setting the cfs quota and period.
kubelet is essentially a container manager for the end user. The end user
can specify any attainable configurations for a pod (which contains multiple
containers).

The user interface of kubelet allows end user to specify the amount of CPU
granted to any pod or container (in the form of mCPU). And then kubelet will
convert the spec to quota/period accepted by cgroup fs, using this rule:
the period of any pod/container will be set to 100000us
the quota of the pod/container will be calculated using the allowed mCPU

And kubelet simply then writes the calculated period and quota to cgroup fs.

It's very common to specify a pod with multiple containers, and setting
different quota for the child containers: some granted with 5-50% of the
bandwidth available to the parent, while some other granted with 100%. For
simplicity, kubelet writes quota/period to cgroup fs for all pods and
containers.

----
Now back to our discussion. :)

You see, the reason that kubelet write identical quota and period to parent and
child cgroup, is not because it want to enforce that child doesn't get more
quota than parent. It is simply because kubelet needs to manage the quota for
all containers and pods, and it's more convenenient to just set the quota and
period for all of them (because in many cases, child cgroups actually gets less
bandwidth than the parent, and has to be set specifically).

I agree that your suggestion would work. If a child cgroup is set to the same
bandwidth of the parent cgroup, we could change the userspace program, and ask
it to skip setting the child cgroup bandwidth.
However, this logic would be a special case, and will require significant logic
change to the userspace container managers.


This issue is affecting many Kubernetes users, see this open issue:
https://github.com/kubernetes/kubernetes/issues/72878
kubelet on their machines are doing the three operations mentioned in the patch.
I also explained them in more detail in this doc:
https://docs.google.com/document/d/13KLD__6A935igLXpTFFomqfclATC89nAkhPOxsuKA0I/edit?usp=sharing

Basically, Kubernetes is operating on the below assumption of kernel today:
Setting the cpu quota/period of a child cgroup should not be rejected unless
the bandwidth is exceeding what the quota/period set for the parent cgroup.

I think this assumption is fair. Please let me know if you think otherwise. And
if so, since the kernel broke this assumption today, I don't think it's the
responsibility for the userspace to deal with the problem that kernel may change
the quota/period ratio at any time.

[1] https://github.com/kubernetes/kubernetes/tree/master/pkg/kubelet

>
> Setting the child quota/period only makes sense when setting it smaller than
> the parent.

As mentioned above, in the use case of kublet, it's much easier to always
set the child quota/period, than to only set it when it is different
(i.e. smaller)
than the parent.

>
> Also, in order to hit this problem you need to have many hundreds of children, in
> my experience. In that case it makes even less sense to write the same quota/preiod
> as the parent into each of the children.

Here is a problematic scenario:
The parent cgroup have 1000 children with a small quota/period, and after a
few minutes, kubelet wants to add one additional child with the same
quota/period.
This bug could prevent kubelet from setting that one additional child
successfully.


Thanks a lot for taking time reviewing and responding the patch Phil!
Really appreciate it.

Best regards,
Xuewei

>
> Or there is something else causing the timer to take too long to run...
>
>
> I agree that if we are taking > 1/2s to run do_sched_cfs_period_timer() it may
> not matter, as I said above.
>
>
> Cheers,
> Phil
>
> >
> > Best regards,
> > Xuewei
> >
> > >
> > >
> > > Cheers,
> > > Phil
> > >
> > > > +                             cfs_b->period = ns_to_ktime(new);
> > > > +                             cfs_b->quota *= 2;
> > > > +
> > > > +                             pr_warn_ratelimited(
> > > > +     "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> > > > +                                     smp_processor_id(),
> > > > +                                     div_u64(new, NSEC_PER_USEC),
> > > > +                                     div_u64(cfs_b->quota, NSEC_PER_USEC));
> > > > +                     } else {
> > > > +                             pr_warn_ratelimited(
> > > > +     "cfs_period_timer[cpu%d]: period too short, but cannot scale up without losing precision (cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> > > > +                                     smp_processor_id(),
> > > > +                                     div_u64(old, NSEC_PER_USEC),
> > > > +                                     div_u64(cfs_b->quota, NSEC_PER_USEC));
> > > > +                     }
> > > >
> > > >                       /* reset count so we don't come right back in here */
> > > >                       count = 0;
> > > > --
> > > > 2.23.0.581.g78d2f28ef7-goog
> > > >
> > >
> > > --
>
> --

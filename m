Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED25CE27B
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 15:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfJGNCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 09:02:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfJGNCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 09:02:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6BE3D18CB8E2;
        Mon,  7 Oct 2019 13:02:41 +0000 (UTC)
Received: from pauld.bos.csb (dhcp-17-51.bos.redhat.com [10.18.17.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 961F1600C1;
        Mon,  7 Oct 2019 13:02:36 +0000 (UTC)
Date:   Mon, 7 Oct 2019 09:02:34 -0400
From:   Phil Auld <pauld@redhat.com>
To:     Xuewei Zhang <xueweiz@google.com>
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
Subject: Re: [PATCH] sched/fair: scale quota and period without losing
 quota/period ratio precision
Message-ID: <20191007130234.GA22412@pauld.bos.csb>
References: <20191004001243.140897-1-xueweiz@google.com>
 <20191004005423.GA19076@lorien.usersys.redhat.com>
 <CAPtwhKrswHQ1Ue2YO2hJi7h-Dsk6eGPiQ2UmLCq1AxGxMoHr2w@mail.gmail.com>
 <20191004131432.GA9498@pauld.bos.csb>
 <CAPtwhKo1YND6VG1u8brj8ZRpn33p2xH1cdSRBs-cBSEm78V=Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPtwhKo1YND6VG1u8brj8ZRpn33p2xH1cdSRBs-cBSEm78V=Lw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Mon, 07 Oct 2019 13:02:41 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Xuewei,

On Fri, Oct 04, 2019 at 05:28:15PM -0700 Xuewei Zhang wrote:
> On Fri, Oct 4, 2019 at 6:14 AM Phil Auld <pauld@redhat.com> wrote:
> >
> > On Thu, Oct 03, 2019 at 07:05:56PM -0700 Xuewei Zhang wrote:
> > > +cc neelnatu@google.com and haoluo@google.com, they helped a lot
> > > for this issue. Sorry I forgot to include them when sending out the patch.
> > >
> > > On Thu, Oct 3, 2019 at 5:55 PM Phil Auld <pauld@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Thu, Oct 03, 2019 at 05:12:43PM -0700 Xuewei Zhang wrote:
> > > > > quota/period ratio is used to ensure a child task group won't get more
> > > > > bandwidth than the parent task group, and is calculated as:
> > > > > normalized_cfs_quota() = [(quota_us << 20) / period_us]
> > > > >
> > > > > If the quota/period ratio was changed during this scaling due to
> > > > > precision loss, it will cause inconsistency between parent and child
> > > > > task groups. See below example:
> > > > > A userspace container manager (kubelet) does three operations:
> > > > > 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
> > > > > 2) Create a few children cgroups.
> > > > > 3) Set quota to 1,000us and period to 10,000us on a child cgroup.
> > > > >
> > > > > These operations are expected to succeed. However, if the scaling of
> > > > > 147/128 happens before step 3), quota and period of the parent cgroup
> > > > > will be changed:
> > > > > new_quota: 1148437ns, 1148us
> > > > > new_period: 11484375ns, 11484us
> > > > >
> > > > > And when step 3) comes in, the ratio of the child cgroup will be 104857,
> > > > > which will be larger than the parent cgroup ratio (104821), and will
> > > > > fail.
> > > > >
> > > > > Scaling them by a factor of 2 will fix the problem.
> > > >
> > > > I have no issues with the concept. We went around a bit about the actual
> > > > numbers and made it an approximation.
> > > >
> > > > >
> > > > > Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop to avoid hard lockup")
> > > > > Signed-off-by: Xuewei Zhang <xueweiz@google.com>
> > > > > ---
> > > > >  kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
> > > > >  1 file changed, 22 insertions(+), 14 deletions(-)
> > > > >
> > > > > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > > > > index 83ab35e2374f..b3d3d0a231cd 100644
> > > > > --- a/kernel/sched/fair.c
> > > > > +++ b/kernel/sched/fair.c
> > > > > @@ -4926,20 +4926,28 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
> > > > >               if (++count > 3) {
> > > > >                       u64 new, old = ktime_to_ns(cfs_b->period);
> > > > >
> > > > > -                     new = (old * 147) / 128; /* ~115% */
> > > > > -                     new = min(new, max_cfs_quota_period);
> > > > > -
> > > > > -                     cfs_b->period = ns_to_ktime(new);
> > > > > -
> > > > > -                     /* since max is 1s, this is limited to 1e9^2, which fits in u64 */
> > > > > -                     cfs_b->quota *= new;
> > > > > -                     cfs_b->quota = div64_u64(cfs_b->quota, old);
> > > > > -
> > > > > -                     pr_warn_ratelimited(
> > > > > -     "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us %lld, cfs_quota_us = %lld)\n",
> > > > > -                             smp_processor_id(),
> > > > > -                             div_u64(new, NSEC_PER_USEC),
> > > > > -                             div_u64(cfs_b->quota, NSEC_PER_USEC));
> > > > > +                     /*
> > > > > +                      * Grow period by a factor of 2 to avoid lossing precision.
> > > > > +                      * Precision loss in the quota/period ratio can cause __cfs_schedulable
> > > > > +                      * to fail.
> > > > > +                      */
> > > > > +                     new = old * 2;
> > > > > +                     if (new < max_cfs_quota_period) {
> > > >
> > > > I don't like this part as much. There may be a value between
> > > > max_cfs_quota_period/2 and max_cfs_quota_period that would get us out of
> > > > the loop. Possibly in practice it won't matter but here you trigger the
> > > > warning and take no action to keep it from continuing.
> > > >
> > > > Also, if you are actually hitting this then you might want to just start at
> > > > a higher but proportional quota and period.
> > >
> > > I'd like to do what you suggested. A quick idea would be to scale period to
> > > max_cfs_quota_period, and scale quota proportionally. However the naive
> > > implementation won't work under this edge case:
> > > original:
> > > quota: 500,000us  period: 570,000us
> > > after scaling:
> > > quota: 877,192us  period: 1,000,000us
> > > original ratio: 919803
> > > new ratio: 919802
> > >
> > > To do this right, the code would have to keep an eye out on the precision loss,
> > > and increase quota by 1us sometimes to cancel out the precision loss.
> > >
> > > Also, I think this case is not that important. Because if we are
> > > hitting this case, that
> > > suggests the period is already >0.5s. And if we are still hitting
> > > timeouts with a 0.5s
> > > period, scaling it to 1s probably won't help much.
> > > When this happens, I'd imagine the parent cgroup would have a LOT of child
> > > cgroups. It might make sense for the userspace to create the parent cgroup with
> > > 1s period.
> > >
> > > If you think automatically scaling 0.5s+ to 1s is still important, I'm
> > > happy to stash
> > > this patch, and send in another one that handles the 0.5+s -> 1s
> > > scaling the right
> > > way. :) Thanks!
> >
> > First let me understand your use case better. I was thinking about this more last
> > night and it doesn't make sense.
> >
> > You are setting a small quota and period on the parent cgroup and then setting the
> > same small quota and period on the child. As you say to keep the child from getting
> > more quota than the parent. But that should already be the case simply by setting
> > it on the parent. The child can't get more quota than the parent.   All this does
> > is make the kernel do more work handling more period timers and such.
> 
> Sorry for not being clear enough. Let me provide a bit more additional context:
> 
> kubelet [1] is the userspace program setting the cfs quota and period.
> kubelet is essentially a container manager for the end user. The end user
> can specify any attainable configurations for a pod (which contains multiple
> containers).
> 
> The user interface of kubelet allows end user to specify the amount of CPU
> granted to any pod or container (in the form of mCPU). And then kubelet will
> convert the spec to quota/period accepted by cgroup fs, using this rule:
> the period of any pod/container will be set to 100000us
> the quota of the pod/container will be calculated using the allowed mCPU
> 
> And kubelet simply then writes the calculated period and quota to cgroup fs.
> 
> It's very common to specify a pod with multiple containers, and setting
> different quota for the child containers: some granted with 5-50% of the
> bandwidth available to the parent, while some other granted with 100%. For
> simplicity, kubelet writes quota/period to cgroup fs for all pods and
> containers.
> 

Thanks for the details :)


> ----
> Now back to our discussion. :)
> 
> You see, the reason that kubelet write identical quota and period to parent and
> child cgroup, is not because it want to enforce that child doesn't get more
> quota than parent. It is simply because kubelet needs to manage the quota for
> all containers and pods, and it's more convenenient to just set the quota and
> period for all of them (because in many cases, child cgroups actually gets less
> bandwidth than the parent, and has to be set specifically).
> 
> I agree that your suggestion would work. If a child cgroup is set to the same
> bandwidth of the parent cgroup, we could change the userspace program, and ask
> it to skip setting the child cgroup bandwidth.
> However, this logic would be a special case, and will require significant logic
> change to the userspace container managers.
> 
> 
> This issue is affecting many Kubernetes users, see this open issue:
> https://github.com/kubernetes/kubernetes/issues/72878
> kubelet on their machines are doing the three operations mentioned in the patch.
> I also explained them in more detail in this doc:
> https://docs.google.com/document/d/13KLD__6A935igLXpTFFomqfclATC89nAkhPOxsuKA0I/edit?usp=sharing
> 
> Basically, Kubernetes is operating on the below assumption of kernel today:
> Setting the cpu quota/period of a child cgroup should not be rejected unless
> the bandwidth is exceeding what the quota/period set for the parent cgroup.
> 
> I think this assumption is fair. Please let me know if you think otherwise. And
> if so, since the kernel broke this assumption today, I don't think it's the
> responsibility for the userspace to deal with the problem that kernel may change
> the quota/period ratio at any time.
> 
> [1] https://github.com/kubernetes/kubernetes/tree/master/pkg/kubelet
> 

Okay. I'm on board with this. At your starting values you'll get 1,2,4,800ms before 
hitting max. That should be enough. I'm a little surprised you're hitting it even
at 100ms but it sounds like you have a lot of children. And if they have their own 
settings that could be taking longer. I suspect contention on the cfs_b->lock could
be adding to it.

I do think that setup is wasting kernel cpu cycles but that's a somewhat orthagonal
discussion :)


> >
> > Setting the child quota/period only makes sense when setting it smaller than
> > the parent.
> 
> As mentioned above, in the use case of kublet, it's much easier to always
> set the child quota/period, than to only set it when it is different
> (i.e. smaller)
> than the parent.
> 
> >
> > Also, in order to hit this problem you need to have many hundreds of children, in
> > my experience. In that case it makes even less sense to write the same quota/preiod
> > as the parent into each of the children.
> 
> Here is a problematic scenario:
> The parent cgroup have 1000 children with a small quota/period, and after a
> few minutes, kubelet wants to add one additional child with the same
> quota/period.
> This bug could prevent kubelet from setting that one additional child
> successfully.
> 
> 
> Thanks a lot for taking time reviewing and responding the patch Phil!
> Really appreciate it.
> 

Sure thing. Thanks for tracking it down. I'll try to test this on my original 
reproducer when I have a chance. I don't foresee any issues though, so for now:

Acked-by: Phil Auld <pauld@redhat.com>



Cheers,
Phil

> Best regards,
> Xuewei
> 
> >
> > Or there is something else causing the timer to take too long to run...
> >
> >
> > I agree that if we are taking > 1/2s to run do_sched_cfs_period_timer() it may
> > not matter, as I said above.
> >
> >
> > Cheers,
> > Phil
> >
> > >
> > > Best regards,
> > > Xuewei
> > >
> > > >
> > > >
> > > > Cheers,
> > > > Phil
> > > >
> > > > > +                             cfs_b->period = ns_to_ktime(new);
> > > > > +                             cfs_b->quota *= 2;
> > > > > +
> > > > > +                             pr_warn_ratelimited(
> > > > > +     "cfs_period_timer[cpu%d]: period too short, scaling up (new cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> > > > > +                                     smp_processor_id(),
> > > > > +                                     div_u64(new, NSEC_PER_USEC),
> > > > > +                                     div_u64(cfs_b->quota, NSEC_PER_USEC));
> > > > > +                     } else {
> > > > > +                             pr_warn_ratelimited(
> > > > > +     "cfs_period_timer[cpu%d]: period too short, but cannot scale up without losing precision (cfs_period_us = %lld, cfs_quota_us = %lld)\n",
> > > > > +                                     smp_processor_id(),
> > > > > +                                     div_u64(old, NSEC_PER_USEC),
> > > > > +                                     div_u64(cfs_b->quota, NSEC_PER_USEC));
> > > > > +                     }
> > > > >
> > > > >                       /* reset count so we don't come right back in here */
> > > > >                       count = 0;
> > > > > --
> > > > > 2.23.0.581.g78d2f28ef7-goog
> > > > >
> > > >
> > > > --
> >
> > --

-- 

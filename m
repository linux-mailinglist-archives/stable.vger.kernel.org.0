Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41BE7F007
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbfHBJLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:11:09 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:45246 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbfHBJLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 05:11:09 -0400
Received: from 79.184.255.110.ipv4.supernova.orange.pl (79.184.255.110) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.275)
 id 1e8abed56eccc6b2; Fri, 2 Aug 2019 11:11:02 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "'Rafael J. Wysocki'" <rafael@kernel.org>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Linux PM' <linux-pm@vger.kernel.org>,
        'Vincent Guittot' <vincent.guittot@linaro.org>,
        'Joel Fernandes' <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Fri, 02 Aug 2019 11:11:01 +0200
Message-ID: <1599417.3YyTWY6lWL@kreacher>
In-Reply-To: <20190802034819.vywlces7rxzfy33f@vireshk-i7>
References: <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com> <000001d54892$a25b86b0$e7129410$@net> <20190802034819.vywlces7rxzfy33f@vireshk-i7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Friday, August 2, 2019 5:48:19 AM CEST Viresh Kumar wrote:
> On 01-08-19, 10:57, Doug Smythies wrote:
> > On 2019.07.31 23:17 Viresh Kumar wrote:
> > > On 31-07-19, 17:20, Doug Smythies wrote:
> > >> Summary:
> > >> 
> > >> The old way, using UINT_MAX had two purposes: first,
> > >> as a "need to do a frequency update" flag; but also second, to
> > >> force any subsequent old/new frequency comparison to NOT be "the same,
> > >> so why bother actually updating" (see: sugov_update_next_freq). All
> > >> patches so far have been dealing with the flag, but only partially
> > >> the comparisons. In a busy system, and when schedutil.c doesn't actually
> > >> know the currently set system limits, the new frequency is dominated by
> > >> values the same as the old frequency. So, when sugov_fast_switch calls 
> > >> sugov_update_next_freq, false is usually returned.
> > >
> > > And finally we know "Why" :)
> > >
> > > Good work Doug. Thanks for taking it to the end.
> > >
> > >> However, if we move the resetting of the flag and add another condition
> > >> to the "no need to actually update" decision, then perhaps this patch
> > >> version 1 will be O.K. It seems to be. (see way later in this e-mail).
> > >
> > >> With all this new knowledge, how about going back to
> > >> version 1 of this patch, and then adding this:
> > >> 
> > >> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > >> index 808d32b..f9156db 100644
> > >> --- a/kernel/sched/cpufreq_schedutil.c
> > >> +++ b/kernel/sched/cpufreq_schedutil.c
> > >> @@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
> > >>  static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
> > >>                                    unsigned int next_freq)
> > >>  {
> > >> -       if (sg_policy->next_freq == next_freq)
> > >> +       /*
> > >> +        * Always force an update if the flag is set, regardless.
> > >> +        * In some implementations (intel_cpufreq) the frequency is clamped
> > >> +        * further downstream, and might not actually be different here.
> > >> +        */
> > >> +       if (sg_policy->next_freq == next_freq && !sg_policy->need_freq_update)
> > >>                 return false;
> > >
> > > This is not correct because this is an optimization we have in place
> > > to make things more efficient. And it was working by luck earlier and
> > > my patch broke it for good :)
> > 
> > Disagree.
> > All I did was use a flag where it used to be set to UNIT_MAX, to basically
> > implement the same thing.
> 
> And the earlier code wasn't fully correct as well, that's why we tried
> to fix it earlier.

Your argument seems to be "There was an earlier problem related to this, which
was fixed, so it is fragile and I'd rather avoid it".  Still, you are claiming that the
code was in fact incorrect and you are not giving convincing arguments to
support that.

> So introducing the UINT_MAX thing again would be
> wrong, even if it fixes the problem for you.

Would it be wrong, because it would reintroduce the fragile code, or would it
be wrong, because it would re-introduce a bug?  What bug if so?

> Also this won't fix the issue for rest of the governors but just
> schedutil. Because this is a driver only problem and there is no point
> trying to fix that in a governor.

Well, I'm not convinced that this is a driver problem yet.




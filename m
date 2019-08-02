Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74F87EAC7
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 05:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbfHBDsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 23:48:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45208 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbfHBDsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 23:48:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so35260379pfq.12
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 20:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e3nNO84ahDYR/dViJfyAWC9AC10Ntg+TsFPmCTzRmhY=;
        b=ZrM7B5iHofoaI9Q2kR59Z0innFVRllgpyZcnOGy+LZYGsdtGyfBPGef7QeiCbMOCxa
         trgAqL7vzabhdgR4YsgMWsEzGLMk1EJmNa1jcXq4ylc+PihXVubipE+WtgnDxY8iK/Ij
         lkl99ZFf/jYk21BFAvExrXO0PQuL/1v/8vOlSUm3BwC/jCIY5ywgwiR6O/NVpioPQzEu
         t9gt3GORwXYV5njIBJJ665ZwodkEQszh1O5oivLZsPh8PGgcUF0llUH1DuNPRDsLiA7i
         0vmXzFow8jW2TAnSaaIOSt1MK16JJsP16sPDW0xHimBpdYO5Pz2Ou0/fPEmX60vNtYUs
         mqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e3nNO84ahDYR/dViJfyAWC9AC10Ntg+TsFPmCTzRmhY=;
        b=sQOdN79VAPdg/r+ZdzXGMIkHzPTyERstvXM0lJP3KPlvE1Rzj1o7a+aYeYbn3AaSUH
         xrMVv488WoIfWxapDZ1uw7+9xOqUdxgZ7hsyAvuo7NRdwL/Omq5kvZCuImr3yIJQC8VE
         +Lfiz8U4Zs5v9i+tUbwMUEqiU+Lmezi7nWB4TiGzq6zKnefaJe1ys9wGmP+fshpZuF1E
         ypOyAGU76UyG01fJqnDFiEuULMRx0hqB9fRjeqbLw+kqhrnBP7cFwAklcAW7kfbM8cOA
         WuX2iU9eZVGY6DYSZEgbr548TpmTiJkF9lUO+VvCJmWlZ7lrP9zGL+pDr9cSNdbftTTK
         SLVQ==
X-Gm-Message-State: APjAAAUZwKNzfnhZkoUZBhhyGmmniVSf8dQbNJFDw284pCRtTcZuQyH8
        QxXcW5a0Cqod+DX3b1FP8rz43Q==
X-Google-Smtp-Source: APXvYqzNJTMOlGc4WYRFfpf9VtIHjxXRwoA8yYaFXKekL+kgkw1Ct7zpkzYwZxT8VK1Rl+AvvB/VAg==
X-Received: by 2002:a62:82c1:: with SMTP id w184mr58247791pfd.8.1564717702076;
        Thu, 01 Aug 2019 20:48:22 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id l189sm88469572pfl.7.2019.08.01.20.48.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 20:48:21 -0700 (PDT)
Date:   Fri, 2 Aug 2019 09:18:19 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "'Rafael J. Wysocki'" <rafael@kernel.org>,
        'Rafael Wysocki' <rjw@rjwysocki.net>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Linux PM' <linux-pm@vger.kernel.org>,
        'Vincent Guittot' <vincent.guittot@linaro.org>,
        'Joel Fernandes' <joel@joelfernandes.org>,
        "'v4 . 18+'" <stable@vger.kernel.org>,
        'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits
 change
Message-ID: <20190802034819.vywlces7rxzfy33f@vireshk-i7>
References: <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
 <000c01d542fc$703ff850$50bfe8f0$@net>
 <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
 <000001d545e3$047d9750$0d78c5f0$@net>
 <20190729083219.fe4xxq4ugmetzntm@vireshk-i7>
 <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com>
 <000b01d547fe$e7b51fd0$b71f5f70$@net>
 <20190801061700.dl33rtilvg44obzu@vireshk-i7>
 <000001d54892$a25b86b0$e7129410$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d54892$a25b86b0$e7129410$@net>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-08-19, 10:57, Doug Smythies wrote:
> On 2019.07.31 23:17 Viresh Kumar wrote:
> > On 31-07-19, 17:20, Doug Smythies wrote:
> >> Summary:
> >> 
> >> The old way, using UINT_MAX had two purposes: first,
> >> as a "need to do a frequency update" flag; but also second, to
> >> force any subsequent old/new frequency comparison to NOT be "the same,
> >> so why bother actually updating" (see: sugov_update_next_freq). All
> >> patches so far have been dealing with the flag, but only partially
> >> the comparisons. In a busy system, and when schedutil.c doesn't actually
> >> know the currently set system limits, the new frequency is dominated by
> >> values the same as the old frequency. So, when sugov_fast_switch calls 
> >> sugov_update_next_freq, false is usually returned.
> >
> > And finally we know "Why" :)
> >
> > Good work Doug. Thanks for taking it to the end.
> >
> >> However, if we move the resetting of the flag and add another condition
> >> to the "no need to actually update" decision, then perhaps this patch
> >> version 1 will be O.K. It seems to be. (see way later in this e-mail).
> >
> >> With all this new knowledge, how about going back to
> >> version 1 of this patch, and then adding this:
> >> 
> >> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> >> index 808d32b..f9156db 100644
> >> --- a/kernel/sched/cpufreq_schedutil.c
> >> +++ b/kernel/sched/cpufreq_schedutil.c
> >> @@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
> >>  static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
> >>                                    unsigned int next_freq)
> >>  {
> >> -       if (sg_policy->next_freq == next_freq)
> >> +       /*
> >> +        * Always force an update if the flag is set, regardless.
> >> +        * In some implementations (intel_cpufreq) the frequency is clamped
> >> +        * further downstream, and might not actually be different here.
> >> +        */
> >> +       if (sg_policy->next_freq == next_freq && !sg_policy->need_freq_update)
> >>                 return false;
> >
> > This is not correct because this is an optimization we have in place
> > to make things more efficient. And it was working by luck earlier and
> > my patch broke it for good :)
> 
> Disagree.
> All I did was use a flag where it used to be set to UNIT_MAX, to basically
> implement the same thing.

And the earlier code wasn't fully correct as well, that's why we tried
to fix it earlier. So introducing the UINT_MAX thing again would be
wrong, even if it fixes the problem for you.

Also this won't fix the issue for rest of the governors but just
schedutil. Because this is a driver only problem and there is no point
trying to fix that in a governor.

> > Things need to get a bit more synchronized and something like this may
> > help (completely untested):
> >
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index cc27d4c59dca..2d84361fbebc 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -2314,6 +2314,18 @@ static int intel_cpufreq_target(struct cpufreq_policy *policy,
> >        return 0;
> > }
> > 
> > +static unsigned int intel_cpufreq_resolve_freq(struct cpufreq_policy *policy,
> > +                                              unsigned int target_freq)
> > +{
> > +       struct cpudata *cpu = all_cpu_data[policy->cpu];
> > +       int target_pstate;
> > +
> > +       target_pstate = DIV_ROUND_UP(target_freq, cpu->pstate.scaling);
> > +       target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
> > +
> > +       return target_pstate * cpu->pstate.scaling;
> > +}
> > +
> >  static unsigned int intel_cpufreq_fast_switch(struct cpufreq_policy *policy,
> >                                               unsigned int target_freq)
> >  {
> > @@ -2350,6 +2362,7 @@ static struct cpufreq_driver intel_cpufreq = {
> >         .verify         = intel_cpufreq_verify_policy,
> >         .target         = intel_cpufreq_target,
> >         .fast_switch    = intel_cpufreq_fast_switch,
> > +       .resolve_freq   = intel_cpufreq_resolve_freq,
> >         .init           = intel_cpufreq_cpu_init,
> >         .exit           = intel_pstate_cpu_exit,
> >         .stop_cpu       = intel_cpufreq_stop_cpu,
> > 
> > -------------------------8<-------------------------
> >
> > Please try this with my patch 2.
> 
> O.K.
> 
> > We need patch 2 instead of 1 because
> > of another race condition Rafael noticed.
> 
> Disagree.
> Notice that my modifications to your patch1 addresses
> that condition by moving the clearing of "need_freq_update"
> to sometime later.

As I said above, that isn't the right way of fixing a driver issue in
governor.
 
> > cpufreq_schedutil calls driver specific resolve_freq() to find the new
> > target frequency and this is where the limits should get applied IMO.
> 
> Oh! I didn't know. But yes, that makes sense.

The thing is that the governors, schedutil or others, need to get the
frequency limits from cpufreq core and the core tries to get it using
resolve_freq() in this particular case. If you don't have that
implemented, all the governors may end up having this issue.

> > Rafael can help with reviewing this diff but it would be great if you
> > can give this a try Doug.
> 
> Anyway, I added the above code (I am calling it patch3) to patch2, as
> you asked, and it does work. I also added it to my modified patch1,
> additionally removing the extra condition check that I added
> (i.e. all that remains of my patch1 modifications is the moved
> clearing of "need_freq_update") That kernel also worked for both
> intel_cpufreq/schedutil and acpi-cpufreq/schedutil.

Great, thanks.

> Again, I do not know how to test the original issue that led
> to the change away from UINT_MAX in the first place,
> ecd2884291261e3fddbc7651ee11a20d596bb514, which should be
> tested in case of some introduced regression.

The problem then was with overriding next_freq with UINT_MAX and since
we aren't going that path again, there is no need to test it again.

I will send the two patches to be applied now. Your tested-by would be
helpful to get them merged.

-- 
viresh

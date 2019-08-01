Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A597D6BF
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfHAHz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:55:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36645 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHAHz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 03:55:57 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so33566586pfl.3
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 00:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4/tIHbAVspQ7tb+i3R1jpcOr2OfCcE8cs80Va5VgOMk=;
        b=foI75pjJCZ7OQ4gv4EDZjxtg3XzzdhiWy4PAl52Hln8gYzgJDanD6QfpT1oSiwLBR2
         trQGCG9DBsVQ/pdfzgvVdHWuFr2RhCMEtvJ10UWZOQ4aFny681l1InQrd+6WCz7VxDGJ
         v4DnSWB9w8UNHR7POjvADGmm5YeW0CxL+JqHN8LbYPUJUBszNzwszMEpaZ052q+MCy17
         S8Wx77EIRG4GBDvd62HN4qwpFA2ekHxQ5w6Abr6k+IhgSIkl+yaW7vaEEttvYIQBbEMf
         ChXARUwjKD1H26VFbZjZHYGcQ3Zf2H2PU06YnctqxNEf5pBXK7PbGX0MR7fSTBv92fIb
         VHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4/tIHbAVspQ7tb+i3R1jpcOr2OfCcE8cs80Va5VgOMk=;
        b=cAqZklSgd+jaYAj3+Kyhy/a5nx4S2Hg29kWvV7PxnBaS5EvE3Xr5wItwDoyuC421gZ
         W/vj/FsWm6l//K8qf+PXNkSbHfEEZ9Mpwo6KXk/a/QKMsGA09DvW1RCSV1C8St9e0+uf
         1k1MhiDw2pa2rJ6YxrdFQNueMwZBgWgd7l11WwF2YUnlS1S43ijjXKEJkK2+q7+mO4RO
         DRbrFXHyEo5kbPcKWeVPqOzkX87okNfmzAmIQsNxJhoPDTwmB6PiZNL6f1QPy3sir65a
         Aw8HK9X8TH6XYbC4Nz40txspJVCvcQH797KbWEKfUni5J5l+rdvXMXoCcOyWFEr+BJ4Q
         GpAQ==
X-Gm-Message-State: APjAAAVqAM83AW7PQF2QBHWmvXF8lafcOnAbFzPVrN2twqCANsOWnHE6
        bFRwzzkgW/ckJ9l38cIhrF4srA==
X-Google-Smtp-Source: APXvYqykUy8A33+0QAA/r+xLhtkymplAzX3AYi87a2JVR2oWBpoqcjwLpw/DrJOKv2zCIySbXdbYdw==
X-Received: by 2002:a63:f959:: with SMTP id q25mr117160756pgk.357.1564646156404;
        Thu, 01 Aug 2019 00:55:56 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id j6sm10315836pjd.19.2019.08.01.00.55.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 00:55:55 -0700 (PDT)
Date:   Thu, 1 Aug 2019 13:25:54 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Doug Smythies <dsmythies@telus.net>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits
 change
Message-ID: <20190801075554.ml6m7pqxsfdhiqom@vireshk-i7>
References: <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
 <000c01d542fc$703ff850$50bfe8f0$@net>
 <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
 <000001d545e3$047d9750$0d78c5f0$@net>
 <20190729083219.fe4xxq4ugmetzntm@vireshk-i7>
 <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com>
 <000b01d547fe$e7b51fd0$b71f5f70$@net>
 <20190801061700.dl33rtilvg44obzu@vireshk-i7>
 <CAJZ5v0h7GPT3Z_oWz=WfJon=wg3bgS3KVMOATEYvdTM2ywuHOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0h7GPT3Z_oWz=WfJon=wg3bgS3KVMOATEYvdTM2ywuHOA@mail.gmail.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01-08-19, 09:47, Rafael J. Wysocki wrote:
> On Thu, Aug 1, 2019 at 8:17 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >
> > On 31-07-19, 17:20, Doug Smythies wrote:
> > > Hi Viresh,
> > >
> > > Summary:
> > >
> > > The old way, using UINT_MAX had two purposes: first,
> > > as a "need to do a frequency update" flag; but also second, to
> > > force any subsequent old/new frequency comparison to NOT be "the same,
> > > so why bother actually updating" (see: sugov_update_next_freq). All
> > > patches so far have been dealing with the flag, but only partially
> > > the comparisons. In a busy system, and when schedutil.c doesn't actually
> > > know the currently set system limits, the new frequency is dominated by
> > > values the same as the old frequency. So, when sugov_fast_switch calls
> > > sugov_update_next_freq, false is usually returned.
> >
> > And finally we know "Why" :)
> >
> > Good work Doug. Thanks for taking it to the end.
> >
> > > However, if we move the resetting of the flag and add another condition
> > > to the "no need to actually update" decision, then perhaps this patch
> > > version 1 will be O.K. It seems to be. (see way later in this e-mail).
> >
> > > With all this new knowledge, how about going back to
> > > version 1 of this patch, and then adding this:
> > >
> > > diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > > index 808d32b..f9156db 100644
> > > --- a/kernel/sched/cpufreq_schedutil.c
> > > +++ b/kernel/sched/cpufreq_schedutil.c
> > > @@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
> > >  static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
> > >                                    unsigned int next_freq)
> > >  {
> > > -       if (sg_policy->next_freq == next_freq)
> > > +       /*
> > > +        * Always force an update if the flag is set, regardless.
> > > +        * In some implementations (intel_cpufreq) the frequency is clamped
> > > +        * further downstream, and might not actually be different here.
> > > +        */
> > > +       if (sg_policy->next_freq == next_freq && !sg_policy->need_freq_update)
> > >                 return false;
> >
> > This is not correct because this is an optimization we have in place
> > to make things more efficient. And it was working by luck earlier and
> > my patch broke it for good :)
> 
> OK, so since we know why it was wrong now, why don't we just revert
> it?  Plus maybe add some comment explaining the rationale in there?

Because the patch [1] which caused these issues was almost correct,
just that it missed the busy accounting for single CPU case.

The main idea behind the original patch [1] was to avoid any
unwanted/hidden side-affects by overriding the value of next_freq.
What we see above is exactly the case for that. Because we override
the value of next_freq, we made intel-pstate work by chance,
unintentionally. Which is wrong. And who knows what other side affects
it had, we already found two (this one and the one fixed by [1]).

I would strongly suggest that we don't override the value of next_freq
with special meaning, as it is used at so many places we don't know
what it may result in.

-- 
viresh

[1] ecd288429126 cpufreq: schedutil: Don't set next_freq to UINT_MAX

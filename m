Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5B67D69F
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfHAHrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:47:42 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35870 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfHAHrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 03:47:41 -0400
Received: by mail-ot1-f66.google.com with SMTP id r6so73251076oti.3;
        Thu, 01 Aug 2019 00:47:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KPtUl6S9pUeshVpKYc9UCS01HVobV6JcVnU/2QSDqPc=;
        b=f2ONRf58b6ZWfesYK5hQ0jz8+ztB2jh5WvXhwcJe68Bcxk6ujzaDvJGenYRH6t9jIJ
         OD3yXnADZa4hckjU+iwr5JlvNmyYcmjGiJaBlco7cFRPtNp2hsnO0vTz+jPWl5Ksn/se
         0QOpqK3CXCBBjXk839WBkwE2qyQOEqlndPiCDWnYIeP3PTXxhlccIMOiuqEiCBrUU0CF
         jjnlRFdBhx6xY0vuSZzlURjtUPSYOxieaJOpfL9Ab+tDLbNWCuUrnUQrJMWZJAWNMkOY
         rlD0Hrg6Fgp+JxGKEQNY5S7WMlir5bLoGGue9av4Sb/qk2h0CrLJtdA1h92egkdkgCfz
         gqoA==
X-Gm-Message-State: APjAAAXtJOAKBXDvKPwm9eyeGkE8FO5tGpC9j1NgYbDMwog4e0MiAHb7
        b5vNrZkPTG8VTf/v3+6wOZC6RgBNDUYy1RkAAVw=
X-Google-Smtp-Source: APXvYqyOoGop7nNIW0gxv/BXKVx0ZDyUU00QkD4MjF1j+GibHaV/XXvlJMuSY2wsXN0O90V0xRQQPN1cek+Cmtf9elo=
X-Received: by 2002:a9d:7a51:: with SMTP id z17mr8066393otm.266.1564645660565;
 Thu, 01 Aug 2019 00:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <001201d54125$a6a82350$f3f869f0$@net> <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
 <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <20190724114327.apmx35c7a4tv3qt5@vireshk-i7> <000c01d542fc$703ff850$50bfe8f0$@net>
 <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7> <000001d545e3$047d9750$0d78c5f0$@net>
 <20190729083219.fe4xxq4ugmetzntm@vireshk-i7> <CAJZ5v0gaW=ujtsDmewrVXL7V8K0YZysNqwu=qKLw+kPC86ydqA@mail.gmail.com>
 <000b01d547fe$e7b51fd0$b71f5f70$@net> <20190801061700.dl33rtilvg44obzu@vireshk-i7>
In-Reply-To: <20190801061700.dl33rtilvg44obzu@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 1 Aug 2019 09:47:28 +0200
Message-ID: <CAJZ5v0h7GPT3Z_oWz=WfJon=wg3bgS3KVMOATEYvdTM2ywuHOA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 1, 2019 at 8:17 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On 31-07-19, 17:20, Doug Smythies wrote:
> > Hi Viresh,
> >
> > Summary:
> >
> > The old way, using UINT_MAX had two purposes: first,
> > as a "need to do a frequency update" flag; but also second, to
> > force any subsequent old/new frequency comparison to NOT be "the same,
> > so why bother actually updating" (see: sugov_update_next_freq). All
> > patches so far have been dealing with the flag, but only partially
> > the comparisons. In a busy system, and when schedutil.c doesn't actually
> > know the currently set system limits, the new frequency is dominated by
> > values the same as the old frequency. So, when sugov_fast_switch calls
> > sugov_update_next_freq, false is usually returned.
>
> And finally we know "Why" :)
>
> Good work Doug. Thanks for taking it to the end.
>
> > However, if we move the resetting of the flag and add another condition
> > to the "no need to actually update" decision, then perhaps this patch
> > version 1 will be O.K. It seems to be. (see way later in this e-mail).
>
> > With all this new knowledge, how about going back to
> > version 1 of this patch, and then adding this:
> >
> > diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > index 808d32b..f9156db 100644
> > --- a/kernel/sched/cpufreq_schedutil.c
> > +++ b/kernel/sched/cpufreq_schedutil.c
> > @@ -100,7 +100,12 @@ static bool sugov_should_update_freq(struct sugov_policy *sg_policy, u64 time)
> >  static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
> >                                    unsigned int next_freq)
> >  {
> > -       if (sg_policy->next_freq == next_freq)
> > +       /*
> > +        * Always force an update if the flag is set, regardless.
> > +        * In some implementations (intel_cpufreq) the frequency is clamped
> > +        * further downstream, and might not actually be different here.
> > +        */
> > +       if (sg_policy->next_freq == next_freq && !sg_policy->need_freq_update)
> >                 return false;
>
> This is not correct because this is an optimization we have in place
> to make things more efficient. And it was working by luck earlier and
> my patch broke it for good :)

OK, so since we know why it was wrong now, why don't we just revert
it?  Plus maybe add some comment explaining the rationale in there?

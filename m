Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C835D7876C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 10:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfG2IcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 04:32:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42315 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfG2IcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 04:32:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so27859783pgb.9
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 01:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WHaq3M20Ot3yD9q3jZA3bbH8rV0oyCs/pORTq+gdhH8=;
        b=uqUejA0EH3kemF6NQ6pGhsU3Fq5FM7C9tWduTlyp50Arft+zEDFwvJfgv4M9KyxDVk
         QotJv/qGvVG+jrZDBltv5Bd5N2+FZ7+HmXF8vhosQ6OBZYK73ALBO7JDlM1mrRCcwXL7
         LOlRNhdUR7xEYzv3QoUU/eYQUWRu4ZkuSaXnBJGek/fFzyTsxA8r7gE2BQ1O9x4ka3Mk
         JqIniR93f3FS2lD8S4uvyYRpN2tBUo2gZRAUsgqBrtFI9KPhqMyAQ6Apl0Ias1A2UygP
         tGR7X7TwWVYG55o2+0neApQS1t6PFXuBOELuYts9QDxbIzoiPmDRafs+mULeY9z7aCxX
         P++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WHaq3M20Ot3yD9q3jZA3bbH8rV0oyCs/pORTq+gdhH8=;
        b=rdlVHucL6Kg+ejKVcOTqOHZpR/3j2ux1Lstm0qi3G00fEWI+qSqV94MrZfBAeZbweA
         7pk5kfuOUjk/nbZL6VJD1CX5L1RSY2VuTWW6Supq+C4ybvZw/nRG+tddzJdoJGdiK4K8
         OoLQNJCPlfIfgCrcAZdApRSPf4jd4iUylTGnOcKeVmfLeq7Y3bc9hjSK6jmUbi5ll/Dn
         fJ3G1tgg6rBMTPH6tmM26sjsBflVbTfmnXQqC6YaNU+Rv7drRR00nF5TD32yXujYLYEW
         6t5s1QrUIIXUQxw8U/1QeaDNAllumnZGei7kG+m0XZdiOBNCSlSr2kJKn+PHsCgfuNlo
         8XAg==
X-Gm-Message-State: APjAAAWrflH7m7dawowIyyhRvZyB+7gyUs0GjTcdayCbTRThIsoPpxzi
        00S0AL8sZmJZz4HerrZ6RHUVWA==
X-Google-Smtp-Source: APXvYqxAXHJpPry35tSmqF6jbpYEQWXwhy4sIUOj/N1AeysW+OUR+W6jO4UTLm2BRDHFjzS2FJLunw==
X-Received: by 2002:a62:642:: with SMTP id 63mr35593651pfg.257.1564389143416;
        Mon, 29 Jul 2019 01:32:23 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id q21sm46580020pgb.48.2019.07.29.01.32.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 01:32:21 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:02:19 +0530
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
Message-ID: <20190729083219.fe4xxq4ugmetzntm@vireshk-i7>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net>
 <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
 <001201d54125$a6a82350$f3f869f0$@net>
 <20190723091551.nchopfpqlmdmzvge@vireshk-i7>
 <CAJZ5v0ji+ksapJ4kc2m5UM_O+AShAvJWmYhTQHiXiHnpTq+xRg@mail.gmail.com>
 <20190724114327.apmx35c7a4tv3qt5@vireshk-i7>
 <000c01d542fc$703ff850$50bfe8f0$@net>
 <20190726065739.xjvyvqpkb3o6m4ty@vireshk-i7>
 <000001d545e3$047d9750$0d78c5f0$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d545e3$047d9750$0d78c5f0$@net>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29-07-19, 00:55, Doug Smythies wrote:
> On 2019.07.25 23:58 Viresh Kumar wrote:
> > Hmm, so I tried to reproduce your setup on my ARM board.
> > - booted only with CPU0 so I hit the sugov_update_single() routine
> > - And applied below diff to make CPU look permanently busy:
> >
> > -------------------------8<-------------------------
> >diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> > index 2f382b0959e5..afb47490e5dc 100644
> > --- a/kernel/sched/cpufreq_schedutil.c
> > +++ b/kernel/sched/cpufreq_schedutil.c
> > @@ -121,6 +121,7 @@ static void sugov_fast_switch(struct sugov_policy *sg_policy, u64 time,
> >         if (!sugov_update_next_freq(sg_policy, time, next_freq))
> >                return;
> > 
> > +       pr_info("%s: %d: %u\n", __func__, __LINE__, freq);
> 
> ?? there is no "freq" variable here, and so this doesn't compile. However this works:
> 
> +       pr_info("%s: %d: %u\n", __func__, __LINE__, next_freq);

There are two paths we can take to change the frequency, normal
sleep-able path (sugov_work) or fast path. Only one of them is taken
by any driver ever. In your case it is the fast path always and in
mine it was the slow path.

I only tested the diff with slow-path and copy pasted to fast path
while giving out to you and so the build issue. Sorry about that.

Also make sure that the print is added after sugov_update_next_freq()
is called, not before it.

> >         next_freq = cpufreq_driver_fast_switch(policy, next_freq);
> >        if (!next_freq)
> >                return;
> > @@ -424,14 +425,10 @@ static unsigned long sugov_iowait_apply(struct sugov_cpu *sg_cpu, u64 time,
> > #ifdef CONFIG_NO_HZ_COMMON
> > static bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu)
> > {
> > -       unsigned long idle_calls = tick_nohz_get_idle_calls_cpu(sg_cpu->cpu);
> > -       bool ret = idle_calls == sg_cpu->saved_idle_calls;
> > -
> > -       sg_cpu->saved_idle_calls = idle_calls;
> > -       return ret;
> > +       return true;
> >  }
> >  #else
> > -static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return false; }
> > +static inline bool sugov_cpu_is_busy(struct sugov_cpu *sg_cpu) { return true; }
> > #endif /* CONFIG_NO_HZ_COMMON */
> > 
> >  /*
> > @@ -565,6 +562,7 @@ static void sugov_work(struct kthread_work *work)
> >         sg_policy->work_in_progress = false;
> >         raw_spin_unlock_irqrestore(&sg_policy->update_lock, flags);
> > 
> > +       pr_info("%s: %d: %u\n", __func__, __LINE__, freq);
> >         mutex_lock(&sg_policy->work_lock);
> >         __cpufreq_driver_target(sg_policy->policy, freq, CPUFREQ_RELATION_L);
> >         mutex_unlock(&sg_policy->work_lock);
> > 
> > -------------------------8<-------------------------
> >
> > Now, the frequency never gets down and so gets set to the maximum
> > possible after a bit.
> >
> > - Then I did:
> >
> > echo <any-low-freq-value> > /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
> >
> > Without my patch applied:
> >        The print never gets printed and so frequency doesn't go down.
> >
> > With my patch applied:
> >        The print gets printed immediately from sugov_work() and so
> >        the frequency reduces.
> > 
> > Can you try with this diff along with my Patch2 ? I suspect there may
> > be something wrong with the intel_cpufreq driver as the patch fixes
> > the only path we have in the schedutil governor which takes busyness
> > of a CPU into account.
> 
> With this diff along with your patch2 There is never a print message
> from sugov_work. There are from sugov_fast_switch.

Which is okay. sugov_work won't get hit in your case as I explained
above.

> Note that for the intel_cpufreq CPU scaling driver and the schedutil
> governor I adjust the maximum clock frequency this way:
> 
> echo <any-low-percent> > /sys/devices/system/cpu/intel_pstate/max_perf_pct

This should eventually call sugov_limits() in schedutil governor, this
can be easily checked with another print message.

> I also applied the pr_info messages to the reverted kernel, and re-did
> my tests (where everything works as expected). There is never a print
> message from sugov_work. There are from sugov_fast_switch.

that's fine.

> Notes:
> 
> I do not know if:
> /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq
> /sys/devices/system/cpu/cpufreq/policy*/scaling_min_freq
> Need to be accurate when using the intel_pstate driver in passive mode.
> They are not.
> The commit comment for 9083e4986124389e2a7c0ffca95630a4983887f0
> suggests that they might need to be representative.
> I wonder if something similar to that commit is needed
> for other global changes, such as max_perf_pct and min_perf_pct?

We are already calling intel_pstate_update_policies() in that case, so
it should be fine I believe.

> intel_cpufreq/ondemand doesn't work properly on the reverted kernel.

reverted kernel ? The patch you reverted was only for schedutil and it
shouldn't have anything to do with ondemand.

> (just discovered, not investigated)
> I don't know about other governors.

When you do:

echo <any-low-percent> > /sys/devices/system/cpu/intel_pstate/max_perf_pct

How soon does the print from sugov_fast_switch() gets printed ?
Immediately ? Check with both the kernels, with my patch and with the
reverted patch.

Also see if there is any difference in the next_freq value in both the
kernels when you change max_perf_pct.

FWIW, we now know the difference between intel-pstate and
acpi-cpufreq/my testcase and why we see differences here. In the cases
where my patch fixed the issue (acpi/ARM), we were really changing the
limits, i.e. policy->min/max. This happened because we touched
scaling_max_freq directly.

For the case of intel-pstate, you are changing max_perf_pct which
doesn't change policy->max directly. I am not very sure how all of it
work really, but at least schedutil will not see policy->max changing.

@Rafael: Do you understand why things don't work properly with
intel_cpufreq driver ?

-- 
viresh

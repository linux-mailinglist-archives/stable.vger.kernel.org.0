Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CC44CAE05
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 20:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242663AbiCBTB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 14:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbiCBTBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 14:01:54 -0500
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CA945041;
        Wed,  2 Mar 2022 11:01:09 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2dc28791ecbso15844947b3.4;
        Wed, 02 Mar 2022 11:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5PpeEeirWTSadoNgEuhRAx2ihhDr+8mxj+IOeP0NzTM=;
        b=R6y5P4TQ5dqHAPUQMgtXeuxTipXNEyIT+pnfTORT//sSJStgz9US/hD98vIF4m9fTH
         5yxdreVTDX+TKwTFcjy4IZSzRY1Am5/70v22uSjFdrWM3GBl9F6Cy5Am1FmMFDbvKV0m
         CMCIWsQobVl9QKPrHLXCcC/vmFCm5q8xSlUEqkj46tItUjL2uyIb6BfUYOxfEjG1yqK4
         sdOUb8yROTB0Ml2nERV0p16V1M43x3q4bT6szQOr6+2g8sfIYPMha+pCPXfwpkuynhMp
         r/069HUIGG/fLsl9ILBuMac3+IbM3mBeqmKIB3/r6K4uPA3T7K29Zj1fZvfoB/8oKMbV
         XXpw==
X-Gm-Message-State: AOAM530mhHvmJE5kLYd/K9XGqElxmTB4+62ZhIOPR9Q1W41gkPWqThGR
        nCMaomiLxEbe/hVPmzqWhCeXRuYHcEirWnxLEZg=
X-Google-Smtp-Source: ABdhPJzt4f19a74QjDbFwYDBMmKjWZdBaDr3QbSHR7Nti7AzL5hO8fHu89mVMFt1GcwLPlBxql/I1tOB2o0QQ6vs8QM=
X-Received: by 2002:a81:bd0:0:b0:2dc:184b:e936 with SMTP id
 199-20020a810bd0000000b002dc184be936mr3135794ywl.7.1646247668186; Wed, 02 Mar
 2022 11:01:08 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com> <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
In-Reply-To: <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 2 Mar 2022 20:00:56 +0100
Message-ID: <CAJZ5v0iOOmRY3uC1-ZGQ30VysMuAjGum=Lt4tkqNUjop+ikqZw@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 2, 2022 at 5:06 AM Doug Smythies <dsmythies@telus.net> wrote:
>
> On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Tue, Mar 1, 2022 at 6:18 PM Doug Smythies <dsmythies@telus.net> wrote:
> > > On Tue, Mar 1, 2022 at 3:58 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > > On Tue, Mar 1, 2022 at 6:53 AM Feng Tang <feng.tang@intel.com> wrote:
> > > > > On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
> > > ...
> > > > > >
> > > > > > However, it was a bit racy, so maybe it's good that it was not complete.
> > > > > >
> > > > > > Below is a new version.
> > > > >
> > > > > Thanks for the new version. I just gave it a try,  and the occasional
> > > > > long delay of cpufreq auto-adjusting I have seen can not be reproduced
> > > > > after applying it.
> > > >
> > > > OK, thanks!
> > > >
> > > > I'll wait for feedback from Dough, though.
> > >
> > > Hi Rafael,
> > >
> > > Thank you for your version 2 patch.
> > > I screwed up an overnight test and will have to re-do it.
> > > However, I do have some results.
> >
> > Thanks for testing it!
> >
> > > From reading the patch code, one worry was the
> > > potential to drive down the desired/required CPU
> > > frequency for the main periodic workflow, causing
> > > overruns, or inability of the task to complete its
> > > work before the next period.
> >
> > It is not clear to me why you worried about that just from reading the
> > patch?  Can you explain, please?
>
> It is already covered below. And a couple of further tests
> directly contradict my thinking.
>
> > > I have always had overrun
> > > information, but it has never been relevant before.
> > >
> > > The other worry was if the threshold of
> > > turbo/not turbo frequency is enough.
> >
> > Agreed.
>
> Just as an easy example and test I did this on
> top of this patch ("rjw-3"):
>
> doug@s19:~/kernel/linux$ git diff
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index f878a4545eee..5cbdd7e479e8 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -1980,7 +1980,7 @@ static void intel_pstate_update_perf_ctl(struct
> cpudata *cpu)
>          * P-states to prevent them from getting back to the high frequency
>          * right away after getting out of deep idle.
>          */
> -       cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);
> +       cpuidle_update_retain_tick(pstate > (cpu->pstate.max_pstate >> 1));

OK, but cpu->pstate.max_pstate / 2 may be almost
cpu->pstate.min_pstate which would be better to use here IMO.

Or something like (cpu->pstate.max_pstate + cpu->pstate.min_pstate) /
2.  Can you try this one in particular?

>         wrmsrl(MSR_IA32_PERF_CTL, pstate_funcs.get_val(cpu, pstate));
>  }
>
> > > I do not know how to test any final solution
> > > thoroughly, as so far I have simply found a
> > > good enough problematic example.
> > > We have so many years of experience with
> > > the convenient multi second NMI forcing
> > > lingering high pstate clean up. I'd keep it
> > > deciding within it if the TSC stuff needs to be
> > > executed or not.
> > >
> > > Anyway...
> > >
> > > Base Kernel 5.17-rc3.
> > > "stock" : unmodified.
> > > "revert" : with commit b50db7095fe reverted
> > > "rjw-2" : with this version2 patch added.
> > >
> > > Test 1 (as before. There is no test 2, yet.):
> > > 347 Hertz work/sleep frequency on one CPU while others do
> > > virtually no load but enough to increase the requested pstate,
> > > but at around 0.02 hertz aggregate.
> > >
> > > It is important to note the main load is approximately
> > > 38.6% @ 2.422 GHz, or 100% at 0.935 GHz.
> > > and almost exclusively uses idle state 2 (of
> > > 4 total idle states)
> > >
> > > /sys/devices/system/cpu/cpu7/cpuidle/state0/name:POLL
> > > /sys/devices/system/cpu/cpu7/cpuidle/state1/name:C1_ACPI
> > > /sys/devices/system/cpu/cpu7/cpuidle/state2/name:C2_ACPI
> > > /sys/devices/system/cpu/cpu7/cpuidle/state3/name:C3_ACPI
> > >
> > > Turbostat was used. ~10 samples at 300 seconds per.
> > > Processor package power (Watts):
> > >
> > > Workflow was run for 1 hour each time or 1249201 loops.
> > >
> > > revert:
> > > ave: 3.00
> > > min: 2.89
> > > max: 3.08
> >
> > I'm not sure what the above three numbers are.
>
> Processor package power, Watts.

OK

> > > ave freq: 2.422 GHz.
> > > overruns: 1.
> > > max overrun time: 113 uSec.
> > >
> > > stock:
> > > ave: 3.63 (+21%)
> > > min: 3.28
> > > max: 3.99
> > > ave freq: 2.791 GHz.
> > > overruns: 2.
> > > max overrun time: 677 uSec.
> > >
> > > rjw-2:
> > > ave: 3.14 (+5%)
> > > min: 2.97
> > > max: 3.28
> > > ave freq: 2.635 GHz
> >
> > I guess the numbers above could be reduced still by using a P-state
> > below the max non-turbo one as a limit.
>
> Yes, and for a test I did "rjw-3".
>
> > > overruns: 1042.
> > > max overrun time: 9,769 uSec.
> >
> > This would probably get worse then, though.
>
> Yes, that was my expectation, but not what happened.
>
> rjw-3:
> ave: 3.09 watts
> min: 3.01 watts
> max: 31.7 watts

Did you mean 3.17 here?  It would be hard to get the average of 3.09
if the max was over 30 W.

> ave freq: 2.42 GHz.
> overruns: 12. (I did not expect this.)
> Max overruns time: 621 uSec.
>
> Note 1: IRQ's increased by 74%. i.e. it was going in
> and out of idle a lot more.

That's because the scheduler tick is allowed to run a lot more often
in the given workload with the changed test above.

> Note 2: We know that processor package power
> is highly temperature dependent. I forgot to let my
> coolant cool adequately after the kernel compile,
> and so had to throw out the first 4 power samples
> (20 minutes).
>
> I retested both rjw-2 and rjw-3, but shorter tests
> and got 0 overruns in both cases.
>
> > ATM I'm not quite sure why this happens, but you seem to have some
> > insight into it, so it would help if you shared it.
>
> My insight seems questionable.
>
> My thinking was that one can not decide if the pstate needs to go
> down or not based on such a localized look. The risk being that the
> higher periodic load might suffer overruns. Since my first test did exactly
> that, I violated my own "repeat all tests 3 times before reporting rule".
> Now, I am not sure what is going on.
> I will need more time to acquire traces and dig into it.

It looks like the workload's behavior depends on updating the CPU
performance scaling governor sufficiently often.

Previously, that happened through the watchdog workflow that is gone
now.  The rjw-2/3 patch is attempting to make up for that by letting
the tick run more often.

Admittedly, it is somewhat unclear to me why there are not so many
overruns in the "stock" kernel test.  Perhaps that's because the CPUs
generally run fast enough in that case, so the P-state governor need
not be updated so often for the CPU frequency to stay high and that's
what determines the performance (and in turn that decides whether or
not there are overruns and how often they occur).  The other side of
the coin is that the updates don't occur often enough for the power
draw to be reasonable, though.

Presumably, when the P-state governor gets updated more often (via the
scheduler tick), but not often enough, it effectively causes the
frequency (and consequently the performance) to drop over relatively
long time intervals (and hence the increased occurrence of overruns).
If it gets updated even more often (like in rjw-3), though, it causes
the CPU frequency to follow the utilization more precisely and so the
CPUs don't run "too fast" or "too slowly" for too long.

> I also did a 1 hour intel_pstate_tracer test, with rjw-2, on an idle system
> and saw several long durations. This was expected as this patch set
> wouldn't change durations by more than a few jiffies.
> 755 long durations (>6.1 seconds), and 327.7 seconds longest.

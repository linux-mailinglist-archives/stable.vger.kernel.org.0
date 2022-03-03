Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406094CBD47
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 13:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiCCMC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 07:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiCCMC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 07:02:58 -0500
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B0516DAD8;
        Thu,  3 Mar 2022 04:02:13 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id h126so9779182ybc.1;
        Thu, 03 Mar 2022 04:02:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32FralHK6OdbF03yEnvC3Xx70gtmb8yjdU3QeWiprYk=;
        b=SQzQSoEho0LprsrC/KMQy5lYAQLTUZGd9vf2H6s93osqMvBzzpCNB5wC237qbXsKrn
         r1Z3GoXkGrEZhQjMG5u+FeqZprFshZ/XvR1kCZzkcSlGIDVyNcvWspo4FSAWK3cUVjeY
         LSutvVhDPapBNrNZpiq/bBBTul0rDXAY6XMieN4Vp6ibg0f280ODmYOdNyOni2mMlO4U
         OKVbzQcMMA2PdErsuhd8QNDqMGJb6V55Ecr7kKYMusIIBqKU7d9UPT59ZTPVenBXnv67
         4WHgykGBaUf/dy3rBZL3/9p69Y+fQNw1IrqrwW2KO5U/1q8Gph6aHY9DttnaKZSynj7d
         PayQ==
X-Gm-Message-State: AOAM532cX2SkHCZBaIBT4w1mpO2MS1U4vgaOMxzap4Tqf7ZwkmUeWbeH
        k51UInLLeMSOSVLE5oAKYFn8bBLPeMMbLzxNWO8=
X-Google-Smtp-Source: ABdhPJwaRDIlDyRfF5CCqVQQKjoo9HRseoELBlWTKmsL78Eq0D6jXhgHDxc8pUENx/jI3i8VB+okkR139GTj2Cz5Ld8=
X-Received: by 2002:a25:4052:0:b0:628:cdca:afb7 with SMTP id
 n79-20020a254052000000b00628cdcaafb7mr1045425yba.81.1646308932372; Thu, 03
 Mar 2022 04:02:12 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com> <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
 <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com> <20220303052727.GM4548@shbuild999.sh.intel.com>
In-Reply-To: <20220303052727.GM4548@shbuild999.sh.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 3 Mar 2022 13:02:01 +0100
Message-ID: <CAJZ5v0h0yqP2qThX6KbQT-6zG=YfxkAbH+uGV8aZCgZX0tSPpw@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Feng Tang <feng.tang@intel.com>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 3, 2022 at 6:27 AM Feng Tang <feng.tang@intel.com> wrote:
>
> On Tue, Mar 01, 2022 at 08:06:24PM -0800, Doug Smythies wrote:
> > On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > I guess the numbers above could be reduced still by using a P-state
> > > below the max non-turbo one as a limit.
> >
> > Yes, and for a test I did "rjw-3".
> >
> > > > overruns: 1042.
> > > > max overrun time: 9,769 uSec.
> > >
> > > This would probably get worse then, though.
> >
> > Yes, that was my expectation, but not what happened.
> >
> > rjw-3:
> > ave: 3.09 watts
> > min: 3.01 watts
> > max: 31.7 watts
> > ave freq: 2.42 GHz.
> > overruns: 12. (I did not expect this.)
> > Max overruns time: 621 uSec.
> >
> > Note 1: IRQ's increased by 74%. i.e. it was going in
> > and out of idle a lot more.
> >
> > Note 2: We know that processor package power
> > is highly temperature dependent. I forgot to let my
> > coolant cool adequately after the kernel compile,
> > and so had to throw out the first 4 power samples
> > (20 minutes).
> >
> > I retested both rjw-2 and rjw-3, but shorter tests
> > and got 0 overruns in both cases.
>
> One thought is can we consider trying the previous debug patch of
> calling the util_update when entering idle (time limited).
>
> In current code, the RT/CFS/Deadline class all have places to call
> cpufreq_update_util(), the patch will make sure it is called in all
> four classes, also it follows the principle of 'schedutil' of not
> introducing more system cost. And surely I could be missing some
> details here.
>
> Following is a cleaner version of the patch, and the code could be
> moved down to the internal loop of
>
>         while (!need_resched()) {
>
>         }
>
> Which will make it get called more frequently.

It will, but it's not necessary in all cases.  It only is necessary if
the tick is going to be stopped (because the tick will update the
P-state governor anyway if it runs).  However, at this point you don't
know what's going to happen to the tick.

Moreover, updating the P-state governor before going idle doesn't
really help, because the P-state programmed by it at this point may
very well be stale after getting out of the idle state, so instead of
doing a full update at this point, it should force a low P-state on
the way from idle.

> ---
>
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index d17b0a5ce6ac..e12688036725 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -258,15 +258,23 @@ static void cpuidle_idle_call(void)
>   *
>   * Called with polling cleared.
>   */
> +DEFINE_PER_CPU(u64, last_util_update_time);    /* in jiffies */
>  static void do_idle(void)
>  {
>         int cpu = smp_processor_id();
> +       u64 expire;
>
>         /*
>          * Check if we need to update blocked load
>          */
>         nohz_run_idle_balance(cpu);
>
> +       expire = __this_cpu_read(last_util_update_time) + HZ * 3;
> +       if (unlikely(time_is_before_jiffies((unsigned long)expire))) {
> +               cpufreq_update_util(this_rq(), 0);

And quite frankly I'm not sure if running cpufreq_update_util() from
here is safe.

> +               __this_cpu_write(last_util_update_time, get_jiffies_64());
> +       }
> +
>         /*
>          * If the arch has a polling bit, we maintain an invariant:
>          *
>

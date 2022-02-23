Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C844C1529
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 15:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiBWOMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 09:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiBWOMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 09:12:18 -0500
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AE72C128;
        Wed, 23 Feb 2022 06:11:50 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id j12so48230435ybh.8;
        Wed, 23 Feb 2022 06:11:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WAcN4FazET79pruCSPhT3sv9cGUKvAUX9j17qg416gg=;
        b=0h/mP5duYiyh4xhKZ9wAbKTY57Y2IaEhEPGwCk/5lFGeqGJfq39VEyRH1cMYOfl1mA
         iKogQTN4LlIjJHEY0nsggyeog7TAqVxbYDEWIejAFriLrMa87E5KKX9l4SDR1u3ESWOv
         db7X7aza78rfzUAPq2KxPWdcksT77TFCb/mMCdzZhowTMK5odM75xr91Aett02Reev8A
         S49SWdoymCqQJFzWSAXfM0I4Z7/3ZL7WeItWlpganwcGyjikUWx8Ie42gL7FDB5rg3/9
         oIk/Zgf8l27L2++vXbgbM2bmdhadPHi5WmurwQ4xJ2TEq/pyUFhpTyTnvbGymal2Je5v
         nnLQ==
X-Gm-Message-State: AOAM532Xw9xuTCLU9GyT76wNuL51iV7F7NCL2M3DwLqlXMSicj9LVx+K
        7OxBMFdM34B9raAHoBbirUd52zkbl2uBSK8O3qc=
X-Google-Smtp-Source: ABdhPJwc6VL/LLTMFzii/EOIPcbOXn6+dTgKRw07Uqd7opeBi9GaJix3ipeqi3r3wfMS/Ib4jBgeLBWgucB5gWPj/Kk=
X-Received: by 2002:a25:378f:0:b0:61d:8e8b:6cf5 with SMTP id
 e137-20020a25378f000000b0061d8e8b6cf5mr26763820yba.622.1645625509225; Wed, 23
 Feb 2022 06:11:49 -0800 (PST)
MIME-Version: 1.0
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net> <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com> <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com> <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
 <20220222073435.GB78951@shbuild999.sh.intel.com> <CAJZ5v0iXQ=qXiZoF_qb1hdBh=yfZ13-of3y3LFu2m6gZh9peTw@mail.gmail.com>
 <20220223024930.GB4548@shbuild999.sh.intel.com>
In-Reply-To: <20220223024930.GB4548@shbuild999.sh.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 23 Feb 2022 15:11:37 +0100
Message-ID: <CAJZ5v0jauqQhMFG8ymeXN6a7o4PbRovxqnOrMWNGN4EAPddStw@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Feng Tang <feng.tang@intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        Doug Smythies <dsmythies@telus.net>,
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

On Wed, Feb 23, 2022 at 3:49 AM Feng Tang <feng.tang@intel.com> wrote:
>
> Hi Rafael,
>
> On Tue, Feb 22, 2022 at 07:04:32PM +0100, Rafael J. Wysocki wrote:
> > On Tue, Feb 22, 2022 at 8:41 AM Feng Tang <feng.tang@intel.com> wrote:
> > >
> > > On Mon, Feb 14, 2022 at 07:17:24AM -0800, srinivas pandruvada wrote:
> > > > Hi Doug,
> > > >
> > > > I think you use CONFIG_NO_HZ_FULL.
> > > > Here we are getting callback from scheduler. Can we check that if
> > > > scheduler woke up on those CPUs?
> > > > We can run "trace-cmd -e sched" and check in kernel shark if there is
> > > > similar gaps in activity.
> > >
> > > Srinivas analyzed the scheduler trace data from trace-cmd, and thought is
> > > related with the cpufreq callback is not called timeley from scheduling
> > > events:
> > >
> > > "
> > > I mean we ignore the callback when the target CPU is not a local CPU as
> > > we have to do IPI to adjust MSRs.
> > > This will happen many times when sched_wake will wake up a new CPU for
> > > the thread (we will get a callack for the target) but once the remote
> > > thread start executing "sched_switch", we will get a callback on local
> > > CPU, so we will adjust frequencies (provided 10ms interval from the
> > > last call).
> > >
> > > >From the trace file I see the scenario where it took 72sec between two
> > > updates:
> > > CPU 2
> > > 34412.597161    busy=78         freq=3232653
> > > 34484.450725    busy=63         freq=2606793
> > >
> > > There is periodic activity in between, related to active load balancing
> > > in scheduler (since last frequency was higher these small work will
> > > also run at higher frequency). But those threads are not CFS class, so
> > > scheduler callback will not be called for them.
> > >
> > > So removing the patch removed a trigger which would have caused a
> > > sched_switch to a CFS task and call a cpufreq/intel_pstate callback.
> >
> > And so this behavior needs to be restored for the time being which
> > means reverting the problematic commit for 5.17 if possible.
> >
> > It is unlikely that we'll get a proper fix before -rc7 and we still
> > need to test it properly.
>
> Thanks for checking this!
>
> I understand the time limit as we are approaching the close of 5.17,
> but still I don't think reverting commit b50db7095fe0 is the best
> solution as:
>
> * b50db7095fe0 is not just an optimization, but solves some real
>   problems found in servers from big CSP (Cloud Service Provider)
>   and data center's server room.
>
> * IMHO, b50db7095fe0 itself hasn't done anything wrong.
>
> * This problem found by Doug is a rarely happened case, though
>   it is an expected thing as shown in existing comments of
>   cfs_rq_util_change():
>
>         /*
>          * There are a few boundary cases this might miss but it should
>          * get called often enough that that should (hopefully) not be
>          * a real problem.
>          *
>          * It will not get called when we go idle, because the idle
>          * thread is a different class (!fair), nor will the utilization
>          * number include things like RT tasks.
>          *
>          * As is, the util number is not freq-invariant (we'd have to
>          * implement arch_scale_freq_capacity() for that).
>          *
>          * See cpu_util_cfs().
>          */
>         cpufreq_update_util(rq, flags);
>
> As this happens with HWP-disabled case and a very calm system, can we
> find a proper solution in 5.17/5.18 or later, and cc stable?

We can.

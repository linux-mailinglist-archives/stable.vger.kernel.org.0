Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5FA4C8B2E
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 12:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbiCAL7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 06:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbiCAL7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 06:59:14 -0500
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFE319C05;
        Tue,  1 Mar 2022 03:58:33 -0800 (PST)
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-2dbd8777564so26716257b3.0;
        Tue, 01 Mar 2022 03:58:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A/qyIuOQFc+5Oiw6APjOzNbn2V6KNSLGl7+wUhPGEhg=;
        b=KibNUAutmkI9lRylfk2wdD2rVkD/LeXnAwT+TMYaElpANUPK952R9be6UJPgG+7RO4
         L2CECX155t8/RuBeHrIKGt+okFaF3jgFEOEWXIFHq90D1XBAxiP3lDqpxBlEM8SXYGYP
         rBOFWtIUXGIX3SOFvGiqA9NHRFdA65JtkLZIyGFI05HhN2G14dhT/WSXm0L+ipG5Td2p
         0whlICjHGeNwa5pbQ8+FoYM9p4mHunPT7W0Aa8OMr8e1LW9WrLqXjazN9mHaT1IW+87G
         WhCxcc+TNaU9xxpTAkCW5o02ap1aKBXyXk3T76n2fgSQbqCC9Un7cbNHYYLNlM1NJqVN
         wU2w==
X-Gm-Message-State: AOAM53376Y44B5h7aki9yvIH6IFUReLk26tmA2Wwe1lTQ/KYp24ro/c6
        pzBPv9wSK2oVnpSvt2K1po0XPUp1Z02D4I97RXY=
X-Google-Smtp-Source: ABdhPJxfwWc5XOlIAl4ikhr+R/swVp/xFdJpL13TXoVN+ulkbXule/Hw8MPWANRbl5US2vaaZMLHkgESDlWFyjTE1ps=
X-Received: by 2002:a81:1611:0:b0:2d6:3290:9bd3 with SMTP id
 17-20020a811611000000b002d632909bd3mr24746769yww.19.1646135912425; Tue, 01
 Mar 2022 03:58:32 -0800 (PST)
MIME-Version: 1.0
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com> <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com>
In-Reply-To: <20220301055255.GI4548@shbuild999.sh.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 1 Mar 2022 12:58:19 +0100
Message-ID: <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
Subject: Re: CPU excessively long times between frequency scaling driver calls
 - bisected
To:     Feng Tang <feng.tang@intel.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
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

On Tue, Mar 1, 2022 at 6:53 AM Feng Tang <feng.tang@intel.com> wrote:
>
> On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 28, 2022 5:12:28 AM CET Feng Tang wrote:
> > > On Fri, Feb 25, 2022 at 04:36:53PM -0800, Doug Smythies wrote:
> > > > On Fri, Feb 25, 2022 at 9:46 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > > >
> > > > > On Thursday, February 24, 2022 9:08:30 AM CET Feng Tang wrote:
> > > > ...
> > > > > > > So it looks like a new mechanism is needed for that.
> > > > > >
> > > > > > If you think idle class is not the right place to solve it, I can
> > > > > > also help testing new patches.
> > > > >
> > > > > So I have the appended experimental patch to address this issue that's not
> > > > > been tested at all.  Caveat emptor.
> > > >
> > > > Hi Rafael,
> > > >
> > > > O.K., you gave fair warning.
> > > >
> > > > The patch applied fine.
> > > > It does not compile for me.
> > > > The function cpuidle_update_retain_tick does not exist.
> > > > Shouldn't it be somewhere in cpuidle.c?
> > > > I used the function cpuidle_disable_device as a template
> > > > for searching and comparing.
> > > >
> > > > Because all of my baseline results are with kernel 5.17-rc3,
> > > > that is what I am still using.
> > > >
> > > > Error:
> > > > ld: drivers/cpufreq/intel_pstate.o: in function `intel_pstate_update_perf_ctl':
> > > > intel_pstate.c:(.text+0x2520): undefined reference to
> > > > `cpuidle_update_retain_tick'
> > >
> > > Same here, seems the cpuidle_update_retain_tick()'s implementation
> > > is missing.
> >
> > That's a patch generation issue on my part, sorry.
> >
> > However, it was a bit racy, so maybe it's good that it was not complete.
> >
> > Below is a new version.
>
> Thanks for the new version. I just gave it a try,  and the occasional
> long delay of cpufreq auto-adjusting I have seen can not be reproduced
> after applying it.

OK, thanks!

I'll wait for feedback from Dough, though.

> As my test is a rough one which can't reproduce what Doug has seen
> (including the power meter data), it's better to wait for his test result.
>
> And one minor question for the code.
>
> > ---
> >  drivers/cpufreq/intel_pstate.c     |   40 ++++++++++++++++++++++++++++---------
> >  drivers/cpuidle/governor.c         |   23 +++++++++++++++++++++
> >  drivers/cpuidle/governors/ladder.c |    6 +++--
> >  drivers/cpuidle/governors/menu.c   |    2 +
> >  drivers/cpuidle/governors/teo.c    |    3 ++
> >  include/linux/cpuidle.h            |    4 +++
> >  6 files changed, 67 insertions(+), 11 deletions(-)
> >
> [SNIP]
>
> > Index: linux-pm/drivers/cpufreq/intel_pstate.c
> > ===================================================================
> > --- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> > +++ linux-pm/drivers/cpufreq/intel_pstate.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/list.h>
> >  #include <linux/cpu.h>
> >  #include <linux/cpufreq.h>
> > +#include <linux/cpuidle.h>
> >  #include <linux/sysfs.h>
> >  #include <linux/types.h>
> >  #include <linux/fs.h>
> > @@ -1970,6 +1971,30 @@ static inline void intel_pstate_cppc_set
> >  }
> >  #endif /* CONFIG_ACPI_CPPC_LIB */
> >
> > +static void intel_pstate_update_perf_ctl(struct cpudata *cpu)
> > +{
> > +     int pstate = cpu->pstate.current_pstate;
> > +
> > +     /*
> > +      * Avoid stopping the scheduler tick from cpuidle on CPUs in turbo
> > +      * P-states to prevent them from getting back to the high frequency
> > +      * right away after getting out of deep idle.
> > +      */
> > +     cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);
>
> In our test, the workload will make CPU go to highest frequency before
> going to idle, but should we also consider that the case that the
> high but not highest cupfreq?

This covers the entire turbo range (max_pstate is the highest non-turbo one).

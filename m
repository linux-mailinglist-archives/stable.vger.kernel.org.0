Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD504C8385
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 06:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiCAFxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 00:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiCAFxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 00:53:40 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D8B49918;
        Mon, 28 Feb 2022 21:52:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646113979; x=1677649979;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JnnbU/d6cXWbEAqVaQNOqxnDTLm4ze+n0qaW1u4m1Y4=;
  b=W535zw4FDszQfKOtU2RDHV0SC6vBEagoMTTyMBbqkQYVXgM3OEjwoOLr
   1HzFjJ/sBT+6WedGcboQ43TfvzFyGDUV/cdOLS0M3hn8PYERtgm4pCrdB
   oVLAkNLV3m4NFP5hOI1btQfAIBnfu4vZk2j70PgTLrt/E08ZYEFF0nku+
   g8Wc/AUkg9DD5PStWnXTWtemvAIwj4Ptui5PAQ9rlm/+2jVCWj0E3aVN7
   TXsZ2gbLMtnX8cLLq4ecbah/ajByl67GQmBHBiskh9bDk9+QvZGWtH89d
   ICNmau1xpWRKKy3VhHYYfDsRVL/Jf5hbuRDdnvdmVL/P8jzTuSpAMMvSO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236573947"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236573947"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 21:52:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="534766317"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2022 21:52:56 -0800
Date:   Tue, 1 Mar 2022 13:52:55 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220301055255.GI4548@shbuild999.sh.intel.com>
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com>
 <11956019.O9o76ZdvQC@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11956019.O9o76ZdvQC@kreacher>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 08:36:03PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 28, 2022 5:12:28 AM CET Feng Tang wrote:
> > On Fri, Feb 25, 2022 at 04:36:53PM -0800, Doug Smythies wrote:
> > > On Fri, Feb 25, 2022 at 9:46 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > >
> > > > On Thursday, February 24, 2022 9:08:30 AM CET Feng Tang wrote:
> > > ...
> > > > > > So it looks like a new mechanism is needed for that.
> > > > >
> > > > > If you think idle class is not the right place to solve it, I can
> > > > > also help testing new patches.
> > > >
> > > > So I have the appended experimental patch to address this issue that's not
> > > > been tested at all.  Caveat emptor.
> > > 
> > > Hi Rafael,
> > > 
> > > O.K., you gave fair warning.
> > > 
> > > The patch applied fine.
> > > It does not compile for me.
> > > The function cpuidle_update_retain_tick does not exist.
> > > Shouldn't it be somewhere in cpuidle.c?
> > > I used the function cpuidle_disable_device as a template
> > > for searching and comparing.
> > > 
> > > Because all of my baseline results are with kernel 5.17-rc3,
> > > that is what I am still using.
> > > 
> > > Error:
> > > ld: drivers/cpufreq/intel_pstate.o: in function `intel_pstate_update_perf_ctl':
> > > intel_pstate.c:(.text+0x2520): undefined reference to
> > > `cpuidle_update_retain_tick'
> >  
> > Same here, seems the cpuidle_update_retain_tick()'s implementation
> > is missing.
> 
> That's a patch generation issue on my part, sorry.
> 
> However, it was a bit racy, so maybe it's good that it was not complete.
> 
> Below is a new version.
 
Thanks for the new version. I just gave it a try,  and the occasional
long delay of cpufreq auto-adjusting I have seen can not be reproduced
after applying it.

As my test is a rough one which can't reproduce what Doug has seen
(including the power meter data), it's better to wait for his test result. 

And one minor question for the code.

> ---
>  drivers/cpufreq/intel_pstate.c     |   40 ++++++++++++++++++++++++++++---------
>  drivers/cpuidle/governor.c         |   23 +++++++++++++++++++++
>  drivers/cpuidle/governors/ladder.c |    6 +++--
>  drivers/cpuidle/governors/menu.c   |    2 +
>  drivers/cpuidle/governors/teo.c    |    3 ++
>  include/linux/cpuidle.h            |    4 +++
>  6 files changed, 67 insertions(+), 11 deletions(-)
>
[SNIP]

> Index: linux-pm/drivers/cpufreq/intel_pstate.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/intel_pstate.c
> +++ linux-pm/drivers/cpufreq/intel_pstate.c
> @@ -19,6 +19,7 @@
>  #include <linux/list.h>
>  #include <linux/cpu.h>
>  #include <linux/cpufreq.h>
> +#include <linux/cpuidle.h>
>  #include <linux/sysfs.h>
>  #include <linux/types.h>
>  #include <linux/fs.h>
> @@ -1970,6 +1971,30 @@ static inline void intel_pstate_cppc_set
>  }
>  #endif /* CONFIG_ACPI_CPPC_LIB */
>  
> +static void intel_pstate_update_perf_ctl(struct cpudata *cpu)
> +{
> +	int pstate = cpu->pstate.current_pstate;
> +
> +	/*
> +	 * Avoid stopping the scheduler tick from cpuidle on CPUs in turbo
> +	 * P-states to prevent them from getting back to the high frequency
> +	 * right away after getting out of deep idle.
> +	 */
> +	cpuidle_update_retain_tick(pstate > cpu->pstate.max_pstate);

In our test, the workload will make CPU go to highest frequency before
going to idle, but should we also consider that the case that the
high but not highest cupfreq?

Thanks,
Feng

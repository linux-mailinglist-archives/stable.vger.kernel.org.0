Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F61CBA72
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbfJDMad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:30:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:45768 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfJDMad (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:30:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 05:30:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="204292357"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by orsmga002.jf.intel.com with SMTP; 04 Oct 2019 05:30:27 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 04 Oct 2019 15:30:26 +0300
Date:   Fri, 4 Oct 2019 15:30:26 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] cpufreq: Fix RCU reboot regression on x86 PIC machines
Message-ID: <20191004123026.GU1208@intel.com>
References: <20191003140828.14801-1-ville.syrjala@linux.intel.com>
 <2393023.mJgu6cDs6C@kreacher>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2393023.mJgu6cDs6C@kreacher>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 05:05:28PM +0200, Rafael J. Wysocki wrote:
> On Thursday, October 3, 2019 4:08:28 PM CEST Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > Since 4.20-rc1 my PIC machines no longer reboot/shutdown.
> > I bisected this down to commit 45975c7d21a1 ("rcu: Define RCU-sched
> > API in terms of RCU for Tree RCU PREEMPT builds").
> > 
> > I traced the hang into
> > -> cpufreq_suspend()
> >  -> cpufreq_stop_governor()
> >   -> cpufreq_dbs_governor_stop()
> >    -> gov_clear_update_util()
> >     -> synchronize_sched()
> >      -> synchronize_rcu()
> > 
> > Only PREEMPT=y is affected for obvious reasons. The problem
> > is limited to PIC machines since they mask off interrupts
> > in i8259A_shutdown() (syscore_ops.shutdown() registered
> > from device_initcall()).
> 
> Let me treat this as a fresh bug report. :-)
> 
> > I reported this long ago but no better fix has surfaced,
> 
> So I don't recall seeing the original report or if I did, I had not understood
> the problem then.
> 
> > hence sending out my initial workaround which I've been
> > carrying around ever since. I just move cpufreq_core_init()
> > to late_initcall() so the syscore_ops get registered in the
> > oppsite order and thus the .shutdown() hooks get executed
> > in the opposite order as well. Not 100% convinced this is
> > safe (especially moving the cpufreq_global_kobject creation
> > to late_initcall()) but I've not had any problems with it
> > at least.
> 
> The problem is a bug in cpufreq that shouldn't point its syscore shutdown
> callback pointer to cpufreq_suspend(), because the syscore stage is generally
> too lat to call that function and I'm not sure why this has not been causing
> any other issues to trigger (or maybe it did, but they were not reported).
> 
> Does the patch below work for you?

It does. Thanks.

Feel free to slap on
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

if you want to go with that.

> 
> ---
>  drivers/base/core.c       |    3 +++
>  drivers/cpufreq/cpufreq.c |   10 ----------
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> Index: linux-pm/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> +++ linux-pm/drivers/cpufreq/cpufreq.c
> @@ -2737,14 +2737,6 @@ int cpufreq_unregister_driver(struct cpu
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
>  
> -/*
> - * Stop cpufreq at shutdown to make sure it isn't holding any locks
> - * or mutexes when secondary CPUs are halted.
> - */
> -static struct syscore_ops cpufreq_syscore_ops = {
> -	.shutdown = cpufreq_suspend,
> -};
> -
>  struct kobject *cpufreq_global_kobject;
>  EXPORT_SYMBOL(cpufreq_global_kobject);
>  
> @@ -2756,8 +2748,6 @@ static int __init cpufreq_core_init(void
>  	cpufreq_global_kobject = kobject_create_and_add("cpufreq", &cpu_subsys.dev_root->kobj);
>  	BUG_ON(!cpufreq_global_kobject);
>  
> -	register_syscore_ops(&cpufreq_syscore_ops);
> -
>  	return 0;
>  }
>  module_param(off, int, 0444);
> Index: linux-pm/drivers/base/core.c
> ===================================================================
> --- linux-pm.orig/drivers/base/core.c
> +++ linux-pm/drivers/base/core.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/acpi.h>
> +#include <linux/cpufreq.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/fwnode.h>
> @@ -3179,6 +3180,8 @@ void device_shutdown(void)
>  	wait_for_device_probe();
>  	device_block_probing();
>  
> +	cpufreq_suspend();
> +
>  	spin_lock(&devices_kset->list_lock);
>  	/*
>  	 * Walk the devices list backward, shutting down each in turn.
> 
> 

-- 
Ville Syrjälä
Intel

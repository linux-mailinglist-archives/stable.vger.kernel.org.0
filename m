Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D804ACF06
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 03:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbiBHCkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 21:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346011AbiBHCjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 21:39:45 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6543FC061355;
        Mon,  7 Feb 2022 18:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644287984; x=1675823984;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FPiMScmKrrYrSMCiVZJ/GItd2crt5fT7a6jcSBmyeZc=;
  b=VJg63bpTKrCh1/QZW5AuezJ9xxnVz9ZQi5fTdsrKdPiIR/XTMUpAVtsa
   lnsNHRJU9035az2p7Vjj2s0VNzZUWhXC3mvlK9nLU7s0OIH8CKbr7NZiW
   7bbI65VzhZW951Xq2Rwr08ESE0++Y6I5/ZcDNE2EPoKB5JoQOEcktMaQm
   ywqpuWwFwZaDNPsFzcys8SiiHyMj99kE7JcLMr7lQY1FNRWYAChbomJRD
   DgWokrSwxM0yA8/6q+PqtJeHWwDhhRjSaO/VzDC4YOJV+hilU7re3AjL3
   r7yXo5RL6cwy6lX80zjqheANfi/57AQ9htDRWjeYEap1iTYMNUpmY504f
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="309600262"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="309600262"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 18:39:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="540398347"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2022 18:39:41 -0800
Date:   Tue, 8 Feb 2022 10:39:40 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     'Thomas Gleixner' <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        'srinivas pandruvada' <srinivas.pandruvada@linux.intel.com>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220208023940.GA5558@shbuild999.sh.intel.com>
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Doug,

Thanks for the report.

On Tue, Feb 08, 2022 at 09:40:14AM +0800, Doug Smythies wrote:
> Hi All,
> 
> Note before: I do not know If I have the e-mail address list correct,
> nor am I actually a member of the x86 distribution list. I am on
> the linux-pm email list.
> 
> When using the intel_pstate CPU frequency scaling driver with HWP disabled,
> active mode, powersave scaling governor, the times between calls to the driver
> have never exceeded 10 seconds.
> 
> Since kernel 5.16-rc4 and commit: b50db7095fe002fa3e16605546cba66bf1b68a3e
> " x86/tsc: Disable clocksource watchdog for TSC on qualified platorms"
> 
> There are now occasions where times between calls to the driver can be
> over 100's of seconds and can result in the CPU frequency being left
> unnecessarily high for extended periods.
> 
> >From the number of clock cycles executed between these long
> durations one can tell that the CPU has been running code, but
> the driver never got called.
> 
> Attached are some graphs from some trace data acquired using
> intel_pstate_tracer.py where one can observe an idle system between
> about 42 and well over 200 seconds elapsed time, yet CPU10 never gets
> called, which would have resulted in reducing it's pstate request, until
> an elapsed time of 167.616 seconds, 126 seconds since the last call. The
> CPU frequency never does go to minimum.
> 
> For reference, a similar CPU frequency graph is also attached, with
> the commit reverted. The CPU frequency drops to minimum,
> over about 10 or 15 seconds.


commit b50db7095fe0 essentially disables the clocksource watchdog, 
which literally doesn't have much to do with cpufreq code. 

One thing I can think of is, without the patch, there is a periodic
clocksource timer running every 500 ms, and it loops to run on
all CPUs in turn. For your HW, it has 12 CPUs (from the graph),
so each CPU will get a timer (HW timer interrupt backed) every 6
seconds. Could this affect the cpufreq governor's work flow (I just
quickly read some cpufreq code, and seem there is irq_work/workqueue
involved).

Can you try one test that keep all the current setting and change
the irq affinity of disk/network-card to 0xfff to let interrupts
from them be distributed to all CPUs?

Thanks,
Feng


> Processor: Intel(R) Core(TM) i5-10600K CPU @ 4.10GHz
> 
> Why this particular configuration, i.e. no-hwp, active, powersave?
> Because it is, by far, the easiest to observe what is going on.
> 
> ... Doug
> 






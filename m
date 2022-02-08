Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C69B4AD47D
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 10:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353384AbiBHJPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 04:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353379AbiBHJP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 04:15:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C55AC0401F0;
        Tue,  8 Feb 2022 01:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644311729; x=1675847729;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+nQm3JqfyT6UX5XNN1I8alaxk1U2NNNQ9rmrYYPq2jQ=;
  b=FyozD2ZbaS1c6CJR8alF2E/1eQDgR7oM7HG0rV1Eyz82sbnA/7XSFkKh
   WjRSZRrfnoqGlm3B6T9ofCfDaA97CX+wyCsu/OavWLGHu09SjteU94XP9
   dSd7Z4pOo0+Gqfe54Mn6Fot5F64DT4pwDL6lTYU/6yGGsy9Io4Kbrbs9o
   uq2JXlGqgZC2UjDA1isJ3lZ/U58UBnuOY9/Gxi/KBQmFT/3HSDG8EdH1+
   rzMqs2JhqKfZ7enTDlJKw7MsPE9+Ym0hDWShfEP8T9KcPUwbDdpEVYExD
   y1oAVoKc4EtHbW+jpbieOecVLQuYYNjalqR/idMSmvfuL4mfOYDmAc3Wl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="273436190"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="273436190"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 01:15:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="700780123"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2022 01:15:26 -0800
Date:   Tue, 8 Feb 2022 17:15:25 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220208091525.GA7898@shbuild999.sh.intel.com>
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
 <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 11:13:00PM -0800, Doug Smythies wrote:
> > >
> > > Since kernel 5.16-rc4 and commit: b50db7095fe002fa3e16605546cba66bf1b68a3e
> > > " x86/tsc: Disable clocksource watchdog for TSC on qualified platorms"
> > >
> > > There are now occasions where times between calls to the driver can be
> > > over 100's of seconds and can result in the CPU frequency being left
> > > unnecessarily high for extended periods.
> > >
> > > From the number of clock cycles executed between these long
> > > durations one can tell that the CPU has been running code, but
> > > the driver never got called.
> > >
> > > Attached are some graphs from some trace data acquired using
> > > intel_pstate_tracer.py where one can observe an idle system between
> > > about 42 and well over 200 seconds elapsed time, yet CPU10 never gets
> > > called, which would have resulted in reducing it's pstate request, until
> > > an elapsed time of 167.616 seconds, 126 seconds since the last call. The
> > > CPU frequency never does go to minimum.
> > >
> > > For reference, a similar CPU frequency graph is also attached, with
> > > the commit reverted. The CPU frequency drops to minimum,
> > > over about 10 or 15 seconds.,
> >
> > commit b50db7095fe0 essentially disables the clocksource watchdog,
> > which literally doesn't have much to do with cpufreq code.
> >
> > One thing I can think of is, without the patch, there is a periodic
> > clocksource timer running every 500 ms, and it loops to run on
> > all CPUs in turn. For your HW, it has 12 CPUs (from the graph),
> > so each CPU will get a timer (HW timer interrupt backed) every 6
> > seconds. Could this affect the cpufreq governor's work flow (I just
> > quickly read some cpufreq code, and seem there is irq_work/workqueue
> > involved).
> 
> 6 Seconds is the longest duration I have ever seen on this
> processor before commit b50db7095fe0.
> 
> I said "the times between calls to the driver have never
> exceeded 10 seconds" originally, but that involved other processors.
> 
> I also did longer, 9000 second tests:
> 
> For a reverted kernel the driver was called 131,743,
> and 0 times the duration was longer than 6.1 seconds.
> 
> For a non-reverted kernel the driver was called 110,241 times,
> and 1397 times the duration was longer than 6.1 seconds,
> and the maximum duration was 303.6 seconds
 
Thanks for the data, which shows it is related to the removal of
clocksource watchdog timers. And under this specific configurations,
the cpufreq work flow has some dependence on that watchdog timers.  

Also could you share you kernel config, boot message and some
system settings like for tickless mode, so that other people can
try to reproduce? thanks

> > Can you try one test that keep all the current setting and change
> > the irq affinity of disk/network-card to 0xfff to let interrupts
> > from them be distributed to all CPUs?
> 
> I am willing to do the test, but I do not know how to change the
> irq affinity.

I might say that too soon. I used to "echo fff > /proc/irq/xxx/smp_affinity"
(xx is the irq number of a device) to let interrupts be distributed
to all CPUs long time ago, but it doesn't work on my 2 desktops at hand.
Seems it only support one-cpu irq affinity in recent kernel.

You can still try that command, though it may not work.

Thanks,
Feng



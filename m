Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2996F4CB660
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 06:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiCCF2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 00:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCCF2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 00:28:16 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770632647;
        Wed,  2 Mar 2022 21:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646285251; x=1677821251;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pxddg53G+ZCAuaY9a1hb9kOAxJ3j/gHnEYBaTCjFBNg=;
  b=K9r4Vi2ICYmrF4bilrfcGJIBJMNLSMFkFo+wJxWauGM9cFSuT5UUozpB
   K5K5Qh+lGIFSJEL8tfchxhnjsojEDcJnbforaXil/qabadm1+jU2LtrnA
   eyjJ0bZDZiO6nrTro+MiHoBVJMNSCE0Ubk2/GS4vNJjCM3PGrt+AQ0Vk9
   hj5Y8x/QO6sDH4H8cKaXQLs7V4KpdgeHs0MG2iHdDm6fkBiGR53ingQRM
   a+aLV1QwwlEg447WGTyLBPfBJMDawNTybRkAmn/ya9uuPgTs+zhizyev2
   PUIscRw4eoogmnrfylSUUwmfPZC5FoN20Jf5r7zsnFp4s2Ahe5lYLi7n1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="237092809"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="237092809"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 21:27:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="630655736"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Mar 2022 21:27:27 -0800
Date:   Thu, 3 Mar 2022 13:27:27 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Doug Smythies <dsmythies@telus.net>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        srinivas pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220303052727.GM4548@shbuild999.sh.intel.com>
References: <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <CAAYoRsW4LqNvSZ3Et5fqeFcHQ9j9-0u9Y-LN9DmpCS3wG3+NWg@mail.gmail.com>
 <20220228041228.GH4548@shbuild999.sh.intel.com>
 <11956019.O9o76ZdvQC@kreacher>
 <20220301055255.GI4548@shbuild999.sh.intel.com>
 <CAJZ5v0jWUR__zn0=SDDecFct86z-=Y6v5fi37mMyW+zOBi7oWw@mail.gmail.com>
 <CAAYoRsVLOcww0z4mp9TtGCKdrgeEiL_=FgrUO=rwkZAok4sQdg@mail.gmail.com>
 <CAJZ5v0hK4zoOtgNQNFkJHC0XOiGsPGUPphHU5og44e_K4kGU9g@mail.gmail.com>
 <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYoRsWN-h+fBAoocGmUFHDkOv2PL+6U59_ASBYH74j0orHaCQ@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 08:06:24PM -0800, Doug Smythies wrote:
> On Tue, Mar 1, 2022 at 9:34 AM Rafael J. Wysocki <rafael@kernel.org> wrote:
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
> ave freq: 2.42 GHz.
> overruns: 12. (I did not expect this.)
> Max overruns time: 621 uSec.
> 
> Note 1: IRQ's increased by 74%. i.e. it was going in
> and out of idle a lot more.
> 
> Note 2: We know that processor package power
> is highly temperature dependent. I forgot to let my
> coolant cool adequately after the kernel compile,
> and so had to throw out the first 4 power samples
> (20 minutes).
> 
> I retested both rjw-2 and rjw-3, but shorter tests
> and got 0 overruns in both cases.
 
One thought is can we consider trying the previous debug patch of
calling the util_update when entering idle (time limited).

In current code, the RT/CFS/Deadline class all have places to call
cpufreq_update_util(), the patch will make sure it is called in all
four classes, also it follows the principle of 'schedutil' of not
introducing more system cost. And surely I could be missing some
details here.

Following is a cleaner version of the patch, and the code could be
moved down to the internal loop of

	while (!need_resched()) {

	}

Which will make it get called more frequently.

---

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d17b0a5ce6ac..e12688036725 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -258,15 +258,23 @@ static void cpuidle_idle_call(void)
  *
  * Called with polling cleared.
  */
+DEFINE_PER_CPU(u64, last_util_update_time);	/* in jiffies */
 static void do_idle(void)
 {
 	int cpu = smp_processor_id();
+	u64 expire;
 
 	/*
 	 * Check if we need to update blocked load
 	 */
 	nohz_run_idle_balance(cpu);
 
+	expire = __this_cpu_read(last_util_update_time) + HZ * 3;
+	if (unlikely(time_is_before_jiffies((unsigned long)expire))) {
+		cpufreq_update_util(this_rq(), 0);
+		__this_cpu_write(last_util_update_time, get_jiffies_64());
+	}
+
 	/*
 	 * If the arch has a polling bit, we maintain an invariant:
 	 *

Thanks,
Feng

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
> 
> I also did a 1 hour intel_pstate_tracer test, with rjw-2, on an idle system
> and saw several long durations. This was expected as this patch set
> wouldn't change durations by more than a few jiffies.
> 755 long durations (>6.1 seconds), and 327.7 seconds longest.
> 
> ... Doug

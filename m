Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2C54BF2CE
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 08:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiBVHmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 02:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiBVHmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 02:42:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1F7D5DF2;
        Mon, 21 Feb 2022 23:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645515279; x=1677051279;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X1Tz+BAoBcxBBkGR1Lq3UkI+KuWFDfPTdFcRVZ6Nc9s=;
  b=nxBHRnVtnwXwhzs0fOD5Sec1NiVa1ConBHWYGdzBfcDWMdZQq7SE3uzi
   lBQCrAm/tQ98yTjOWSY6iWqQsjqTEQkqaXyqV/T7RU3dbjlr7YXYDtacg
   u0rIoBp4bBRnSjQXrozg/yj7piaISpq0HtGSrBdISkO2pKhQXm1fWmphg
   Pyb24lOW0KGRyPNxlfqdO5NUd/6G8iI22l6cs3Ytk1HIzoNrtAz9Rgiqx
   TCGFZ0M887ztEID00HBRt/fpGHTnqxpl6KYbweAxL8+ki8KHwgdzs/GS8
   jEhuOtZWnkphBi3XRYbGT26LLJsRrtyhuSoD6SKflBUxO318LSHl77sj8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251399474"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="251399474"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 23:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="591210229"
Received: from shbuild999.sh.intel.com (HELO localhost) ([10.239.146.189])
  by fmsmga008.fm.intel.com with ESMTP; 21 Feb 2022 23:34:36 -0800
Date:   Tue, 22 Feb 2022 15:34:35 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: CPU excessively long times between frequency scaling driver
 calls - bisected
Message-ID: <20220222073435.GB78951@shbuild999.sh.intel.com>
References: <003f01d81c8c$d20ee3e0$762caba0$@telus.net>
 <20220208023940.GA5558@shbuild999.sh.intel.com>
 <CAAYoRsXrwOQgzAcED+JfVG0=JQNEXuyGcSGghL4Z5xnFgkp+TQ@mail.gmail.com>
 <20220208091525.GA7898@shbuild999.sh.intel.com>
 <CAAYoRsXkyWf0vmEE2HvjF6pzCC4utxTF=7AFx1PJv4Evh=C+Ow@mail.gmail.com>
 <e185b89fb97f47758a5e10239fc3eed0@intel.com>
 <CAAYoRsXbBJtvJzh91nTXATLL1eb2EKbTVb8vEWa3Y6DfCWhZeg@mail.gmail.com>
 <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaace653f12b79336b6f986ef5c4f9471445372a.camel@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 07:17:24AM -0800, srinivas pandruvada wrote:
> Hi Doug,
> 
> I think you use CONFIG_NO_HZ_FULL.
> Here we are getting callback from scheduler. Can we check that if
> scheduler woke up on those CPUs?
> We can run "trace-cmd -e sched" and check in kernel shark if there is
> similar gaps in activity.

Srinivas analyzed the scheduler trace data from trace-cmd, and thought is
related with the cpufreq callback is not called timeley from scheduling
events:

" 
I mean we ignore the callback when the target CPU is not a local CPU as
we have to do IPI to adjust MSRs.
This will happen many times when sched_wake will wake up a new CPU for
the thread (we will get a callack for the target) but once the remote
thread start executing "sched_switch", we will get a callback on local
CPU, so we will adjust frequencies (provided 10ms interval from the
last call).

>From the trace file I see the scenario where it took 72sec between two
updates:
CPU 2
34412.597161    busy=78         freq=3232653
34484.450725    busy=63         freq=2606793

There is periodic activity in between, related to active load balancing
in scheduler (since last frequency was higher these small work will
also run at higher frequency). But those threads are not CFS class, so
scheduler callback will not be called for them.

So removing the patch removed a trigger which would have caused a
sched_switch to a CFS task and call a cpufreq/intel_pstate callback.
But calling for every class, will be too many callbacks and not sure we
can even call for "stop" class, which these migration threads are
using.
"

Following this direction, I made a hacky debug patch which should help
to restore the previous behavior.

Doug, could you help to try it? thanks

It basically tries to make sure the cpufreq-update-util be called timely
even for a silent system with very few interrupts (even from tick).

Thanks,
Feng

From 6be5f5da66a847860b0b9924fbb09f93b2e2d6e6 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Tue, 22 Feb 2022 22:59:00 +0800
Subject: [PATCH] idle/intel-pstate: hacky debug patch to make sure the
 cpufreq_update_util callback being called timely in silent system

---
 kernel/sched/idle.c  | 10 ++++++++++
 kernel/sched/sched.h | 13 +++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index d17b0a5ce6ac..cc538acb3f1a 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -258,15 +258,25 @@ static void cpuidle_idle_call(void)
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
 
+#ifdef CONFIG_X86_INTEL_PSTATE
+	expire = __this_cpu_read(last_util_update_time) + HZ * 3;
+	if (unlikely(time_is_before_jiffies(expire))) {
+		idle_update_util();
+		__this_cpu_write(last_util_update_time, get_jiffies_64());
+	}
+#endif
+
 	/*
 	 * If the arch has a polling bit, we maintain an invariant:
 	 *
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0e66749486e7..2a8d87988d1f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2809,6 +2809,19 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags)
 	if (data)
 		data->func(data, rq_clock(rq), flags);
 }
+
+static inline void idle_update_util(void)
+{
+	struct update_util_data *data;
+	struct rq *rq = cpu_rq(raw_smp_processor_id());
+
+	data = rcu_dereference_sched(*per_cpu_ptr(&cpufreq_update_util_data,
+						  cpu_of(rq)));
+	if (data)
+		data->func(data, rq_clock(rq), 0);
+}
+
+
 #else
 static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #endif /* CONFIG_CPU_FREQ */
-- 
2.25.1





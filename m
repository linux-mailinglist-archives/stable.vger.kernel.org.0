Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704657F131
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfHBJgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404180AbfHBJgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:36:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 622952087E;
        Fri,  2 Aug 2019 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738590;
        bh=tMP1iJw4R/ilJTuPZrzm0aasosLSjSN9Pf7iVjwKK30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9SFx8jrmJC2i41Pi3T4UXdR9umRL005R8lf9i3VI+Jw9jcmdZlMX1FoNNmQdfiNb
         3qA5slOU29VX+SCwxdK7uFbawK28/Ivk65mX4NFTb1uZomk7pc5etkaX10Ve9JrTcV
         1olInAV+E6hWEYM1mOLv+BXhDgzX0VatugNtjFis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Wagner <wagi@monom.org>
Subject: [PATCH 4.4 149/158] mm, vmstat: make quiet_vmstat lighter
Date:   Fri,  2 Aug 2019 11:29:30 +0200
Message-Id: <20190802092232.534784882@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit f01f17d3705bb6081c9e5728078f64067982be36 upstream.

Mike has reported a considerable overhead of refresh_cpu_vm_stats from
the idle entry during pipe test:

    12.89%  [kernel]       [k] refresh_cpu_vm_stats.isra.12
     4.75%  [kernel]       [k] __schedule
     4.70%  [kernel]       [k] mutex_unlock
     3.14%  [kernel]       [k] __switch_to

This is caused by commit 0eb77e988032 ("vmstat: make vmstat_updater
deferrable again and shut down on idle") which has placed quiet_vmstat
into cpu_idle_loop.  The main reason here seems to be that the idle
entry has to get over all zones and perform atomic operations for each
vmstat entry even though there might be no per cpu diffs.  This is a
pointless overhead for _each_ idle entry.

Make sure that quiet_vmstat is as light as possible.

First of all it doesn't make any sense to do any local sync if the
current cpu is already set in oncpu_stat_off because vmstat_update puts
itself there only if there is nothing to do.

Then we can check need_update which should be a cheap way to check for
potential per-cpu diffs and only then do refresh_cpu_vm_stats.

The original patch also did cancel_delayed_work which we are not doing
here.  There are two reasons for that.  Firstly cancel_delayed_work from
idle context will blow up on RT kernels (reported by Mike):

  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.5.0-rt3 #7
  Hardware name: MEDION MS-7848/MS-7848, BIOS M7848W08.20C 09/23/2013
  Call Trace:
    dump_stack+0x49/0x67
    ___might_sleep+0xf5/0x180
    rt_spin_lock+0x20/0x50
    try_to_grab_pending+0x69/0x240
    cancel_delayed_work+0x26/0xe0
    quiet_vmstat+0x75/0xa0
    cpu_idle_loop+0x38/0x3e0
    cpu_startup_entry+0x13/0x20
    start_secondary+0x114/0x140

And secondly, even on !RT kernels it might add some non trivial overhead
which is not necessary.  Even if the vmstat worker wakes up and preempts
idle then it will be most likely a single shot noop because the stats
were already synced and so it would end up on the oncpu_stat_off anyway.
We just need to teach both vmstat_shepherd and vmstat_update to stop
scheduling the worker if there is nothing to do.

[mgalbraith@suse.de: cancel pending work of the cpu_stat_off CPU]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Daniel Wagner <wagi@monom.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmstat.c |   68 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 22 deletions(-)

--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1395,10 +1395,15 @@ static void vmstat_update(struct work_st
 		 * Counters were updated so we expect more updates
 		 * to occur in the future. Keep on running the
 		 * update worker thread.
+		 * If we were marked on cpu_stat_off clear the flag
+		 * so that vmstat_shepherd doesn't schedule us again.
 		 */
-		queue_delayed_work_on(smp_processor_id(), vmstat_wq,
-			this_cpu_ptr(&vmstat_work),
-			round_jiffies_relative(sysctl_stat_interval));
+		if (!cpumask_test_and_clear_cpu(smp_processor_id(),
+						cpu_stat_off)) {
+			queue_delayed_work_on(smp_processor_id(), vmstat_wq,
+				this_cpu_ptr(&vmstat_work),
+				round_jiffies_relative(sysctl_stat_interval));
+		}
 	} else {
 		/*
 		 * We did not update any counters so the app may be in
@@ -1416,18 +1421,6 @@ static void vmstat_update(struct work_st
  * until the diffs stay at zero. The function is used by NOHZ and can only be
  * invoked when tick processing is not active.
  */
-void quiet_vmstat(void)
-{
-	if (system_state != SYSTEM_RUNNING)
-		return;
-
-	do {
-		if (!cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
-			cancel_delayed_work(this_cpu_ptr(&vmstat_work));
-
-	} while (refresh_cpu_vm_stats(false));
-}
-
 /*
  * Check if the diffs for a certain cpu indicate that
  * an update is needed.
@@ -1451,6 +1444,30 @@ static bool need_update(int cpu)
 	return false;
 }
 
+void quiet_vmstat(void)
+{
+	if (system_state != SYSTEM_RUNNING)
+		return;
+
+	/*
+	 * If we are already in hands of the shepherd then there
+	 * is nothing for us to do here.
+	 */
+	if (cpumask_test_and_set_cpu(smp_processor_id(), cpu_stat_off))
+		return;
+
+	if (!need_update(smp_processor_id()))
+		return;
+
+	/*
+	 * Just refresh counters and do not care about the pending delayed
+	 * vmstat_update. It doesn't fire that often to matter and canceling
+	 * it would be too expensive from this path.
+	 * vmstat_shepherd will take care about that for us.
+	 */
+	refresh_cpu_vm_stats(false);
+}
+
 
 /*
  * Shepherd worker thread that checks the
@@ -1468,18 +1485,25 @@ static void vmstat_shepherd(struct work_
 
 	get_online_cpus();
 	/* Check processors whose vmstat worker threads have been disabled */
-	for_each_cpu(cpu, cpu_stat_off)
-		if (need_update(cpu) &&
-			cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
-
-			queue_delayed_work_on(cpu, vmstat_wq,
-				&per_cpu(vmstat_work, cpu), 0);
+	for_each_cpu(cpu, cpu_stat_off) {
+		struct delayed_work *dw = &per_cpu(vmstat_work, cpu);
 
+		if (need_update(cpu)) {
+			if (cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
+				queue_delayed_work_on(cpu, vmstat_wq, dw, 0);
+		} else {
+			/*
+			 * Cancel the work if quiet_vmstat has put this
+			 * cpu on cpu_stat_off because the work item might
+			 * be still scheduled
+			 */
+			cancel_delayed_work(dw);
+		}
+	}
 	put_online_cpus();
 
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
-
 }
 
 static void __init start_shepherd_timer(void)



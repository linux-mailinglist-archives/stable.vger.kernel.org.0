Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031B92E3BC6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406390AbgL1Nyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407439AbgL1Nyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8526220715;
        Mon, 28 Dec 2020 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163660;
        bh=YT7+HbX/GYzXvsvKuK71lscfC63cT+JCkfN89vDvxwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wigpvxcbuwfz7UJGQc+3cp7OoAy2qrx7OA4Kj9jDdynCk2748GUlKMUAOb5CdCnBo
         c0MhgQOGoHhj2h/bw0oNz6Z/NJIQ2ifDHVkz83GRtrcHSTK21zOCKm24yPehZbEgOm
         nApTQ1NEVAo4wVc/jsMinARZj2dMfsxUOHc1JkCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.4 363/453] cpuset: fix race between hotplug work and later CPU offline
Date:   Mon, 28 Dec 2020 13:49:59 +0100
Message-Id: <20201228124954.670955584@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 406100f3da08066c00105165db8520bbc7694a36 upstream.

One of our machines keeled over trying to rebuild the scheduler domains.
Mainline produces the same splat:

  BUG: unable to handle page fault for address: 0000607f820054db
  CPU: 2 PID: 149 Comm: kworker/1:1 Not tainted 5.10.0-rc1-master+ #6
  Workqueue: events cpuset_hotplug_workfn
  RIP: build_sched_domains
  Call Trace:
   partition_sched_domains_locked
   rebuild_sched_domains_locked
   cpuset_hotplug_workfn

It happens with cgroup2 and exclusive cpusets only.  This reproducer
triggers it on an 8-cpu vm and works most effectively with no
preexisting child cgroups:

  cd $UNIFIED_ROOT
  mkdir cg1
  echo 4-7 > cg1/cpuset.cpus
  echo root > cg1/cpuset.cpus.partition

  # with smt/control reading 'on',
  echo off > /sys/devices/system/cpu/smt/control

RIP maps to

  sd->shared = *per_cpu_ptr(sdd->sds, sd_id);

from sd_init().  sd_id is calculated earlier in the same function:

  cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
  sd_id = cpumask_first(sched_domain_span(sd));

tl->mask(cpu), which reads cpu_sibling_map on x86, returns an empty mask
and so cpumask_first() returns >= nr_cpu_ids, which leads to the bogus
value from per_cpu_ptr() above.

The problem is a race between cpuset_hotplug_workfn() and a later
offline of CPU N.  cpuset_hotplug_workfn() updates the effective masks
when N is still online, the offline clears N from cpu_sibling_map, and
then the worker uses the stale effective masks that still have N to
generate the scheduling domains, leading the worker to read
N's empty cpu_sibling_map in sd_init().

rebuild_sched_domains_locked() prevented the race during the cgroup2
cpuset series up until the Fixes commit changed its check.  Make the
check more robust so that it can detect an offline CPU in any exclusive
cpuset's effective mask, not just the top one.

Fixes: 0ccea8feb980 ("cpuset: Make generate_sched_domains() work with partition")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201112171711.639541-1-daniel.m.jordan@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cpuset.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -981,25 +981,48 @@ partition_and_rebuild_sched_domains(int
  */
 static void rebuild_sched_domains_locked(void)
 {
+	struct cgroup_subsys_state *pos_css;
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
+	struct cpuset *cs;
 	int ndoms;
 
 	lockdep_assert_cpus_held();
 	percpu_rwsem_assert_held(&cpuset_rwsem);
 
 	/*
-	 * We have raced with CPU hotplug. Don't do anything to avoid
+	 * If we have raced with CPU hotplug, return early to avoid
 	 * passing doms with offlined cpu to partition_sched_domains().
-	 * Anyways, hotplug work item will rebuild sched domains.
+	 * Anyways, cpuset_hotplug_workfn() will rebuild sched domains.
+	 *
+	 * With no CPUs in any subpartitions, top_cpuset's effective CPUs
+	 * should be the same as the active CPUs, so checking only top_cpuset
+	 * is enough to detect racing CPU offlines.
 	 */
 	if (!top_cpuset.nr_subparts_cpus &&
 	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
 		return;
 
-	if (top_cpuset.nr_subparts_cpus &&
-	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
-		return;
+	/*
+	 * With subpartition CPUs, however, the effective CPUs of a partition
+	 * root should be only a subset of the active CPUs.  Since a CPU in any
+	 * partition root could be offlined, all must be checked.
+	 */
+	if (top_cpuset.nr_subparts_cpus) {
+		rcu_read_lock();
+		cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
+			if (!is_partition_root(cs)) {
+				pos_css = css_rightmost_descendant(pos_css);
+				continue;
+			}
+			if (!cpumask_subset(cs->effective_cpus,
+					    cpu_active_mask)) {
+				rcu_read_unlock();
+				return;
+			}
+		}
+		rcu_read_unlock();
+	}
 
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);



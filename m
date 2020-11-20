Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF792BAA41
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgKTMeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgKTMeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:34:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A337C0613CF;
        Fri, 20 Nov 2020 04:34:11 -0800 (PST)
Date:   Fri, 20 Nov 2020 12:34:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605875649;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jLnTUfu5q7HFGMcvp9gG1DICGNnnjhFJ/HglxpNjIk=;
        b=XYxZbx8aNirOJGDWuvhf+dR7KqCHeDhrx35HPbYVhVMCbSLMoNz45cYDcmlO7Ub1N4kTpZ
        jRMYqWPFkWip9X229WBkpcnMLQVbKC/vgLNRRUftGMdIlI121MZ2XMHUdeB3ga2T1QOKSS
        i3I7ttwpAwW9C+DIYFi6JATBXVfZJKmgLY1uIntoyzM18dxgaO5fDDoCex2uz0El4iC/ib
        XlJQxT4BVUkO4bN77Ejaqp/dUYo7QBQuP5FDOY17KRFQBC9YUDlQorB6FwgHC72UgCTcoQ
        HAKOmrlaz+tXk1FbHEw2pzGF6LkGgkX9g2WUvEVrQlzN05tPz0BfXgdE9OSnhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605875649;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jLnTUfu5q7HFGMcvp9gG1DICGNnnjhFJ/HglxpNjIk=;
        b=vhEY7q3J+2XcxyOBfuizQG6slQmYZJgm5tRnHxgFTC7XN+7jAD6Hsg6DSaSyCUr4fVQbEE
        qo3HdvYIHKgQWSBQ==
From:   "tip-bot2 for Daniel Jordan" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: sched/core] cpuset: fix race between hotplug work and later CPU offline
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20201112171711.639541-1-daniel.m.jordan@oracle.com>
References: <20201112171711.639541-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Message-ID: <160587564863.11244.11496515259891440886.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the sched/core branch of tip:

Commit-ID:     406100f3da08066c00105165db8520bbc7694a36
Gitweb:        https://git.kernel.org/tip/406100f3da08066c00105165db8520bbc7694a36
Author:        Daniel Jordan <daniel.m.jordan@oracle.com>
AuthorDate:    Thu, 12 Nov 2020 12:17:11 -05:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Thu, 19 Nov 2020 11:25:45 +01:00

cpuset: fix race between hotplug work and later CPU offline

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
---
 kernel/cgroup/cpuset.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 57b5b5d..53c70c4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -983,25 +983,48 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
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

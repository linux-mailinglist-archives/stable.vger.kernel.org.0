Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF12B3ADBA9
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 22:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhFSU37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Jun 2021 16:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhFSU36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Jun 2021 16:29:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADFFC061574;
        Sat, 19 Jun 2021 13:27:45 -0700 (PDT)
Date:   Sat, 19 Jun 2021 20:27:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624134461;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JqcS98Guu8A/M7cu0Wkz0xvE48EQ/O7AvUv++fOEzr4=;
        b=pKhSvM1Vyg/ygFlhkdF5RFv+n33s7N0AlNZnDe8+6gqOg6Mnmx6VDBds6sHJJ9vq/G3n97
        gCwNXv2YzqcTOPxP4Mq/PLnn74dYZrgr/Z2ANenOsLChcBxn8BeF81JThaXy8mTxVeWYtf
        kOZRBLEU7Nf/f0aHNw3FqjQTdO6U/4bea9RFcW2UnJh86c1IRi8pz3R+Eojdj4/rqjw0Pb
        YKTlUhEjlacpfAv6RV5fgRAihxFgzQk45QfwX5GsJrCCrgEMPG3sQGmX/HhotufcVY2KKa
        4PSrBtHauydASV5UAD/kttgn/8sxDOuNmY9gj+9C+MIcEHLQYvrKJjt3sfdPKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624134461;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JqcS98Guu8A/M7cu0Wkz0xvE48EQ/O7AvUv++fOEzr4=;
        b=vv7d/0J60Y4hAGbcRvB6wKr0ibLB9IlHhoaAkICizzLnSexFkH5Vq8ibTiY+REaXF2kc+3
        MF29XDbxA6pKldDA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: smp/urgent] cpu/hotplug: Cure the cpusets trainwreck
Cc:     Alexey Klimov <aklimov@redhat.com>,
        Joshua Baker <jobaker@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87tuowcnv3.ffs@nanos.tec.linutronix.de>
References: <87tuowcnv3.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <162413446009.19906.7301964706858048310.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the smp/urgent branch of tip:

Commit-ID:     64c71be97c02c3d3f24dea7c290912ad300538b9
Gitweb:        https://git.kernel.org/tip/64c71be97c02c3d3f24dea7c290912ad300538b9
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Sat, 27 Mar 2021 22:01:36 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 19 Jun 2021 22:26:07 +02:00

cpu/hotplug: Cure the cpusets trainwreck

Alexey and Joshua tried to solve a cpusets related hotplug problem which is
user space visible and results in unexpected behaviour for some time after
a CPU has been plugged in and the corresponding uevent was delivered.

cpusets delegate the hotplug work (rebuilding cpumasks etc.) to a
workqueue. This is done because the cpusets code has already a lock
nesting of cgroups_mutex -> cpu_hotplug_lock. A synchronous callback or
waiting for the work to finish with cpu_hotplug_lock held can and will
deadlock because that results in the reverse lock order.

As a consequence the uevent can be delivered before cpusets have consistent
state which means that a user space invocation of sched_setaffinity() to
move a task to the plugged CPU fails up to the point where the scheduled
work has been processed.

The same is true for CPU unplug, but that does not create user observable
failure (yet).

It's still inconsistent to claim that an operation is finished before it
actually is and that's the real issue at hand. uevents just make it
reliably observable.

Obviously the problem should be fixed in cpusets/cgroups, but untangling
that is pretty much impossible because according to the changelog of the
commit which introduced this 8 years ago:

 3a5a6d0c2b03("cpuset: don't nest cgroup_mutex inside get_online_cpus()")

the lock order cgroups_mutex -> cpu_hotplug_lock is a design decision and
the whole code is built around that.

So bite the bullet and invoke the relevant cpuset function, which waits for
the work to finish, in _cpu_up/down() after dropping cpu_hotplug_lock and
only when tasks are not frozen by suspend/hibernate because that would
obviously wait forever.

Waiting there with cpu_add_remove_lock, which is protecting the present
and possible CPU maps, held is not a problem at all because neither work
queues nor cpusets/cgroups have any lockchains related to that lock.

Waiting in the hotplug machinery is not problematic either because there
are already state callbacks which wait for hardware queues to drain. It
makes the operations slightly slower, but hotplug is slow anyway.

This ensures that state is consistent before returning from a hotplug
up/down operation. It's still inconsistent during the operation, but that's
a different story.

Add a large comment which explains why this is done and why this is not a
dump ground for the hack of the day to work around half thought out locking
schemes. Document also the implications vs. hotplug operations and
serialization or the lack of it.

Thanks to Alexy and Joshua for analyzing why this temporary
sched_setaffinity() failure happened.

Fixes: 3a5a6d0c2b03("cpuset: don't nest cgroup_mutex inside get_online_cpus()")
Reported-by: Alexey Klimov <aklimov@redhat.com>
Reported-by: Joshua Baker <jobaker@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Alexey Klimov <aklimov@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87tuowcnv3.ffs@nanos.tec.linutronix.de
---
 kernel/cpu.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index e538518..eccc8cf 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -32,6 +32,7 @@
 #include <linux/relay.h>
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/cpuset.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -919,6 +920,52 @@ void clear_tasks_mm_cpumask(int cpu)
 	rcu_read_unlock();
 }
 
+/*
+ *
+ * Serialize hotplug trainwrecks outside of the cpu_hotplug_lock
+ * protected region.
+ *
+ * The operation is still serialized against concurrent CPU hotplug via
+ * cpu_add_remove_lock, i.e. CPU map protection.  But it is _not_
+ * serialized against other hotplug related activity like adding or
+ * removing of state callbacks and state instances, which invoke either the
+ * startup or the teardown callback of the affected state.
+ *
+ * This is required for subsystems which are unfixable vs. CPU hotplug and
+ * evade lock inversion problems by scheduling work which has to be
+ * completed _before_ cpu_up()/_cpu_down() returns.
+ *
+ * Don't even think about adding anything to this for any new code or even
+ * drivers. It's only purpose is to keep existing lock order trainwrecks
+ * working.
+ *
+ * For cpu_down() there might be valid reasons to finish cleanups which are
+ * not required to be done under cpu_hotplug_lock, but that's a different
+ * story and would be not invoked via this.
+ */
+static void cpu_up_down_serialize_trainwrecks(bool tasks_frozen)
+{
+	/*
+	 * cpusets delegate hotplug operations to a worker to "solve" the
+	 * lock order problems. Wait for the worker, but only if tasks are
+	 * _not_ frozen (suspend, hibernate) as that would wait forever.
+	 *
+	 * The wait is required because otherwise the hotplug operation
+	 * returns with inconsistent state, which could even be observed in
+	 * user space when a new CPU is brought up. The CPU plug uevent
+	 * would be delivered and user space reacting on it would fail to
+	 * move tasks to the newly plugged CPU up to the point where the
+	 * work has finished because up to that point the newly plugged CPU
+	 * is not assignable in cpusets/cgroups. On unplug that's not
+	 * necessarily a visible issue, but it is still inconsistent state,
+	 * which is the real problem which needs to be "fixed". This can't
+	 * prevent the transient state between scheduling the work and
+	 * returning from waiting for it.
+	 */
+	if (!tasks_frozen)
+		cpuset_wait_for_hotplug();
+}
+
 /* Take this CPU down. */
 static int take_cpu_down(void *_param)
 {
@@ -1108,6 +1155,7 @@ out:
 	 */
 	lockup_detector_cleanup();
 	arch_smt_update();
+	cpu_up_down_serialize_trainwrecks(tasks_frozen);
 	return ret;
 }
 
@@ -1302,6 +1350,7 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen, enum cpuhp_state target)
 out:
 	cpus_write_unlock();
 	arch_smt_update();
+	cpu_up_down_serialize_trainwrecks(tasks_frozen);
 	return ret;
 }
 

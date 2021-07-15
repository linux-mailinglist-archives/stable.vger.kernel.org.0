Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE1E3CA64F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhGOSrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237813AbhGOSrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BEAB613D7;
        Thu, 15 Jul 2021 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374652;
        bh=8HxbaUTbOikjyur6SKi0GwtLVzTUkwwupYDAx0RjGss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8VDZcrdhfAYo9UkiYdSlUHsjvEd95fRj2RVr+w6qeSXeI+viWZSzsQBQZqqdbOBE
         tXBe2cNgWT9k+UMDPDD41P/olSB87MjNPr2RiOTN9gqb7gO84f0EUfD5USA9ppjvaJ
         m41jUDPHGknKyd/K+6ykdrABDZFCqZwUdKQoqr5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Klimov <aklimov@redhat.com>,
        Joshua Baker <jobaker@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.4 090/122] cpu/hotplug: Cure the cpusets trainwreck
Date:   Thu, 15 Jul 2021 20:38:57 +0200
Message-Id: <20210715182515.131800309@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit b22afcdf04c96ca58327784e280e10288cfd3303 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cpu.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -32,6 +32,7 @@
 #include <linux/relay.h>
 #include <linux/slab.h>
 #include <linux/percpu-rwsem.h>
+#include <linux/cpuset.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -814,6 +815,52 @@ void __init cpuhp_threads_init(void)
 	kthread_unpark(this_cpu_read(cpuhp_state.thread));
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
 #ifdef CONFIG_HOTPLUG_CPU
 #ifndef arch_clear_mm_cpumask_cpu
 #define arch_clear_mm_cpumask_cpu(cpu, mm) cpumask_clear_cpu(cpu, mm_cpumask(mm))
@@ -1051,6 +1098,7 @@ out:
 	 */
 	lockup_detector_cleanup();
 	arch_smt_update();
+	cpu_up_down_serialize_trainwrecks(tasks_frozen);
 	return ret;
 }
 
@@ -1186,6 +1234,7 @@ static int _cpu_up(unsigned int cpu, int
 out:
 	cpus_write_unlock();
 	arch_smt_update();
+	cpu_up_down_serialize_trainwrecks(tasks_frozen);
 	return ret;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71081A9DD7
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897584AbgDOLrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897576AbgDOLqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:46:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D2420768;
        Wed, 15 Apr 2020 11:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951214;
        bh=ReiwWY5DS7R9ZcBugP7lliqJr2hem4U0KmNLfZYzg2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNTmdoaVKt0OtVqUF6LY8DonqEOpcsfeBEVRvVnBo0yXO04KdOxPWERAhaiwlWiVw
         ahXoeIXsMp4P+9BEoGhJ6DM00o5MwCqeEhM7Qz5StD762/3O4g0Ge/qrqbuzrhdA7P
         +gVuGq3t37gO/sZpb1p9kUyUdzOrWDyMhktLQgJs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Borislav Petkov <bp@suse.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 4.19 26/40] x86: ACPI: fix CPU hotplug deadlock
Date:   Wed, 15 Apr 2020 07:46:09 -0400
Message-Id: <20200415114623.14972-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 696ac2e3bf267f5a2b2ed7d34e64131f2287d0ad ]

Similar to commit 0266d81e9bf5 ("acpi/processor: Prevent cpu hotplug
deadlock") except this is for acpi_processor_ffh_cstate_probe():

"The problem is that the work is scheduled on the current CPU from the
hotplug thread associated with that CPU.

It's not required to invoke these functions via the workqueue because
the hotplug thread runs on the target CPU already.

Check whether current is a per cpu thread pinned on the target CPU and
invoke the function directly to avoid the workqueue."

 WARNING: possible circular locking dependency detected
 ------------------------------------------------------
 cpuhp/1/15 is trying to acquire lock:
 ffffc90003447a28 ((work_completion)(&wfc.work)){+.+.}-{0:0}, at: __flush_work+0x4c6/0x630

 but task is already holding lock:
 ffffffffafa1c0e8 (cpuidle_lock){+.+.}-{3:3}, at: cpuidle_pause_and_lock+0x17/0x20

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (cpu_hotplug_lock){++++}-{0:0}:
 cpus_read_lock+0x3e/0xc0
 irq_calc_affinity_vectors+0x5f/0x91
 __pci_enable_msix_range+0x10f/0x9a0
 pci_alloc_irq_vectors_affinity+0x13e/0x1f0
 pci_alloc_irq_vectors_affinity at drivers/pci/msi.c:1208
 pqi_ctrl_init+0x72f/0x1618 [smartpqi]
 pqi_pci_probe.cold.63+0x882/0x892 [smartpqi]
 local_pci_probe+0x7a/0xc0
 work_for_cpu_fn+0x2e/0x50
 process_one_work+0x57e/0xb90
 worker_thread+0x363/0x5b0
 kthread+0x1f4/0x220
 ret_from_fork+0x27/0x50

 -> #0 ((work_completion)(&wfc.work)){+.+.}-{0:0}:
 __lock_acquire+0x2244/0x32a0
 lock_acquire+0x1a2/0x680
 __flush_work+0x4e6/0x630
 work_on_cpu+0x114/0x160
 acpi_processor_ffh_cstate_probe+0x129/0x250
 acpi_processor_evaluate_cst+0x4c8/0x580
 acpi_processor_get_power_info+0x86/0x740
 acpi_processor_hotplug+0xc3/0x140
 acpi_soft_cpu_online+0x102/0x1d0
 cpuhp_invoke_callback+0x197/0x1120
 cpuhp_thread_fun+0x252/0x2f0
 smpboot_thread_fn+0x255/0x440
 kthread+0x1f4/0x220
 ret_from_fork+0x27/0x50

 other info that might help us debug this:

 Chain exists of:
 (work_completion)(&wfc.work) --> cpuhp_state-up --> cpuidle_lock

 Possible unsafe locking scenario:

 CPU0                    CPU1
 ----                    ----
 lock(cpuidle_lock);
                         lock(cpuhp_state-up);
                         lock(cpuidle_lock);
 lock((work_completion)(&wfc.work));

 *** DEADLOCK ***

 3 locks held by cpuhp/1/15:
 #0: ffffffffaf51ab10 (cpu_hotplug_lock){++++}-{0:0}, at: cpuhp_thread_fun+0x69/0x2f0
 #1: ffffffffaf51ad40 (cpuhp_state-up){+.+.}-{0:0}, at: cpuhp_thread_fun+0x69/0x2f0
 #2: ffffffffafa1c0e8 (cpuidle_lock){+.+.}-{3:3}, at: cpuidle_pause_and_lock+0x17/0x20

 Call Trace:
 dump_stack+0xa0/0xea
 print_circular_bug.cold.52+0x147/0x14c
 check_noncircular+0x295/0x2d0
 __lock_acquire+0x2244/0x32a0
 lock_acquire+0x1a2/0x680
 __flush_work+0x4e6/0x630
 work_on_cpu+0x114/0x160
 acpi_processor_ffh_cstate_probe+0x129/0x250
 acpi_processor_evaluate_cst+0x4c8/0x580
 acpi_processor_get_power_info+0x86/0x740
 acpi_processor_hotplug+0xc3/0x140
 acpi_soft_cpu_online+0x102/0x1d0
 cpuhp_invoke_callback+0x197/0x1120
 cpuhp_thread_fun+0x252/0x2f0
 smpboot_thread_fn+0x255/0x440
 kthread+0x1f4/0x220
 ret_from_fork+0x27/0x50

Signed-off-by: Qian Cai <cai@lca.pw>
Tested-by: Borislav Petkov <bp@suse.de>
[ rjw: Subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/acpi/cstate.c       | 3 ++-
 drivers/acpi/processor_throttling.c | 7 -------
 include/acpi/processor.h            | 8 ++++++++
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 158ad1483c435..92539a1c3e317 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -133,7 +133,8 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 
 	/* Make sure we are running on right CPU */
 
-	retval = work_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx);
+	retval = call_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx,
+			     false);
 	if (retval == 0) {
 		/* Use the hint in CST */
 		percpu_entry->states[cx->index].eax = cx->address;
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index fbc936cf2025c..62c0fe9ef4124 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -910,13 +910,6 @@ static long __acpi_processor_get_throttling(void *data)
 	return pr->throttling.acpi_processor_get_throttling(pr);
 }
 
-static int call_on_cpu(int cpu, long (*fn)(void *), void *arg, bool direct)
-{
-	if (direct || (is_percpu_thread() && cpu == smp_processor_id()))
-		return fn(arg);
-	return work_on_cpu(cpu, fn, arg);
-}
-
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
 	if (!pr)
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 1194a4c78d557..5b9eab15a1e6c 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -293,6 +293,14 @@ static inline void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx
 }
 #endif
 
+static inline int call_on_cpu(int cpu, long (*fn)(void *), void *arg,
+			      bool direct)
+{
+	if (direct || (is_percpu_thread() && cpu == smp_processor_id()))
+		return fn(arg);
+	return work_on_cpu(cpu, fn, arg);
+}
+
 /* in processor_perflib.c */
 
 #ifdef CONFIG_CPU_FREQ
-- 
2.20.1


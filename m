Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA83F20C31
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfEPQCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42812 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zu-Ja; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Pg-Pb; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.626986316@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 42/86] sched: Add sched_smt_active()
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Add the sched_smt_active() function needed for some x86 speculation
mitigations.  This was introduced upstream by commits 1b568f0aabf2
"sched/core: Optimize SCHED_SMT", ba2591a5993e "sched/smt: Update
sched_smt_present at runtime", c5511d03ec09 "sched/smt: Make
sched_smt_present track topology", and 321a874a7ef8 "sched/smt: Expose
sched_smt_present static key".  The upstream implementation uses the
static_key_{disable,enable}_cpuslocked() functions, which aren't
practical to backport.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/sched/smt.h |   18 ++++++++++++++++++
 kernel/sched/core.c       |   19 +++++++++++++++++++
 kernel/sched/sched.h      |    1 +
 3 files changed, 38 insertions(+)

--- /dev/null
+++ b/include/linux/sched/smt.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SCHED_SMT_H
+#define _LINUX_SCHED_SMT_H
+
+#include <linux/atomic.h>
+
+#ifdef CONFIG_SCHED_SMT
+extern atomic_t sched_smt_present;
+
+static __always_inline bool sched_smt_active(void)
+{
+	return atomic_read(&sched_smt_present);
+}
+#else
+static inline bool sched_smt_active(void) { return false; }
+#endif
+
+#endif
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5210,6 +5210,10 @@ static void __cpuinit set_cpu_rq_start_t
 	rq->age_stamp = sched_clock_cpu(cpu);
 }
 
+#ifdef CONFIG_SCHED_SMT
+atomic_t sched_smt_present = ATOMIC_INIT(0);
+#endif
+
 static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
@@ -5226,6 +5230,13 @@ static int sched_cpu_active(struct notif
 		 * Thus, fall-through and help the starting CPU along.
 		 */
 	case CPU_DOWN_FAILED:
+#ifdef CONFIG_SCHED_SMT
+		/*
+		 * When going up, increment the number of cores with SMT present.
+		 */
+		if (cpumask_weight(cpu_smt_mask((long)hcpu)) == 2)
+			atomic_inc(&sched_smt_present);
+#endif
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
 	default:
@@ -5243,6 +5254,14 @@ static int sched_cpu_inactive(struct not
 	case CPU_DOWN_PREPARE:
 		set_cpu_active(cpu, false);
 
+#ifdef CONFIG_SCHED_SMT
+		/*
+		 * When going down, decrement the number of cores with SMT present.
+		 */
+		if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
+			atomic_dec(&sched_smt_present);
+#endif
+
 		/* explicitly allow suspend */
 		if (!(action & CPU_TASKS_FROZEN)) {
 			struct dl_bw *dl_b = dl_bw_of(cpu);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/smt.h>
 #include <linux/sched/deadline.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>


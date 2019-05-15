Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3761EDAE
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfEOLMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729744AbfEOLMS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1080D2166E;
        Wed, 15 May 2019 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918737;
        bh=bvmCFZAcCNHnBodtaxWi016DoRHs+DDGWr67rN5v8I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5FwYXV9HZT3aSYUPgQuFeYtULg0xt7uGX3We3boCLOBrf3+w2DpD72buaPS0tiyn
         UK+kOvb2C5z9fHaUqHQZGqw+PIz4vH7HrCfpvuWGLSXf2Kl+0LiHaZdA5BUPzQyXBV
         jxBJ8ViuZwUL2uyi923PVGz11cvCtq16hWY3jY2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4.4 209/266] sched: Add sched_smt_active()
Date:   Wed, 15 May 2019 12:55:16 +0200
Message-Id: <20190515090730.037812794@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/smt.h |   18 ++++++++++++++++++
 kernel/sched/core.c       |   24 ++++++++++++++++++++++++
 kernel/sched/sched.h      |    1 +
 3 files changed, 43 insertions(+)
 create mode 100644 include/linux/sched/smt.h

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
@@ -5610,6 +5610,10 @@ static void set_cpu_rq_start_time(void)
 	rq->age_stamp = sched_clock_cpu(cpu);
 }
 
+#ifdef CONFIG_SCHED_SMT
+atomic_t sched_smt_present = ATOMIC_INIT(0);
+#endif
+
 static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
@@ -5626,11 +5630,23 @@ static int sched_cpu_active(struct notif
 		 * set_cpu_online(). But it might not yet have marked itself
 		 * as active, which is essential from here on.
 		 */
+#ifdef CONFIG_SCHED_SMT
+		/*
+		 * When going up, increment the number of cores with SMT present.
+		 */
+		if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
+			atomic_inc(&sched_smt_present);
+#endif
 		set_cpu_active(cpu, true);
 		stop_machine_unpark(cpu);
 		return NOTIFY_OK;
 
 	case CPU_DOWN_FAILED:
+#ifdef CONFIG_SCHED_SMT
+		/* Same as for CPU_ONLINE */
+		if (cpumask_weight(cpu_smt_mask(cpu)) == 2)
+			atomic_inc(&sched_smt_present);
+#endif
 		set_cpu_active(cpu, true);
 		return NOTIFY_OK;
 
@@ -5645,7 +5661,15 @@ static int sched_cpu_inactive(struct not
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
 		set_cpu_active((long)hcpu, false);
+#ifdef CONFIG_SCHED_SMT
+		/*
+		 * When going down, decrement the number of cores with SMT present.
+		 */
+		if (cpumask_weight(cpu_smt_mask((long)hcpu)) == 2)
+			atomic_dec(&sched_smt_present);
+#endif
 		return NOTIFY_OK;
+
 	default:
 		return NOTIFY_DONE;
 	}
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



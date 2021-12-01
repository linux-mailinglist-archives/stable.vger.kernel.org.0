Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F934659F0
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 00:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353847AbhLAXu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 18:50:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44080 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353824AbhLAXu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 18:50:28 -0500
Date:   Wed, 01 Dec 2021 23:47:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638402425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UZW5YmBZqJbojMvF/ejvNn2IwF4kXk5VTaNUGceK7FA=;
        b=1pDTfp+L8DVkhGJzqZTyjAD87ZyZ2ktkHzphUq9hQq14rk7wUU2Sdh4RLqbVNxkHNv3YQ3
        1jqooiAD7dOG4QZAxQ6B+dLzCopF/9Zwd64zKvkHvAkVQ6RG7MWNpatVB73zkjaOAyXlzr
        4QpuWqqWrWowr3dIKH50hP7d0xtyHLLeUWjBQqwqW7k1JIm684Mw+aEIZhqpZQYjb79acz
        1pLik6MZ3HCEm+Z565AGMJiUgP44elcccWf5b0AIWZF29pjNPommyKe4wMvOJMfesddOlU
        FibZ5eLco4nLYH7g/KJ2W0USyGlhsDmkibWNA3J59GoKYms3vtU14REnSBSHng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638402425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UZW5YmBZqJbojMvF/ejvNn2IwF4kXk5VTaNUGceK7FA=;
        b=aJqaaxhAfSBKwWdq8lOMevTQzxtygHPiX1sFIR8JXL68rqFlxZAtvyHU4vDB+i/ZyvBB3I
        Fr2LDxm4hhjoj6BQ==
From:   "tip-bot2 for Feng Tang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/tsc: Add a timer to make sure TSC_adjust is
 always checked
Cc:     Feng Tang <feng.tang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211117023751.24190-1-feng.tang@intel.com>
References: <20211117023751.24190-1-feng.tang@intel.com>
MIME-Version: 1.0
Message-ID: <163840242483.11128.8915758153074569974.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     c7719e79347803b8e3b6b50da8c6db410a3012b5
Gitweb:        https://git.kernel.org/tip/c7719e79347803b8e3b6b50da8c6db410a3012b5
Author:        Feng Tang <feng.tang@intel.com>
AuthorDate:    Wed, 17 Nov 2021 10:37:50 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 02 Dec 2021 00:40:35 +01:00

x86/tsc: Add a timer to make sure TSC_adjust is always checked

The TSC_ADJUST register is checked every time a CPU enters idle state, but
Thomas Gleixner mentioned there is still a caveat that a system won't enter
idle [1], either because it's too busy or configured purposely to not enter
idle.

Setup a periodic timer (every 10 minutes) to make sure the check is
happening on a regular base.

[1] https://lore.kernel.org/lkml/875z286xtk.fsf@nanos.tec.linutronix.de/

Fixes: 6e3cd95234dc ("x86/hpet: Use another crystalball to evaluate HPET usability")
Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211117023751.24190-1-feng.tang@intel.com

---
 arch/x86/kernel/tsc_sync.c | 41 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 50a4515..9452dc9 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -30,6 +30,7 @@ struct tsc_adjust {
 };
 
 static DEFINE_PER_CPU(struct tsc_adjust, tsc_adjust);
+static struct timer_list tsc_sync_check_timer;
 
 /*
  * TSC's on different sockets may be reset asynchronously.
@@ -77,6 +78,46 @@ void tsc_verify_tsc_adjust(bool resume)
 	}
 }
 
+/*
+ * Normally the tsc_sync will be checked every time system enters idle
+ * state, but there is still caveat that a system won't enter idle,
+ * either because it's too busy or configured purposely to not enter
+ * idle.
+ *
+ * So setup a periodic timer (every 10 minutes) to make sure the check
+ * is always on.
+ */
+
+#define SYNC_CHECK_INTERVAL		(HZ * 600)
+
+static void tsc_sync_check_timer_fn(struct timer_list *unused)
+{
+	int next_cpu;
+
+	tsc_verify_tsc_adjust(false);
+
+	/* Run the check for all onlined CPUs in turn */
+	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
+	if (next_cpu >= nr_cpu_ids)
+		next_cpu = cpumask_first(cpu_online_mask);
+
+	tsc_sync_check_timer.expires += SYNC_CHECK_INTERVAL;
+	add_timer_on(&tsc_sync_check_timer, next_cpu);
+}
+
+static int __init start_sync_check_timer(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_TSC_ADJUST) || tsc_clocksource_reliable)
+		return 0;
+
+	timer_setup(&tsc_sync_check_timer, tsc_sync_check_timer_fn, 0);
+	tsc_sync_check_timer.expires = jiffies + SYNC_CHECK_INTERVAL;
+	add_timer(&tsc_sync_check_timer);
+
+	return 0;
+}
+late_initcall(start_sync_check_timer);
+
 static void tsc_sanitize_first_cpu(struct tsc_adjust *cur, s64 bootval,
 				   unsigned int cpu, bool bootcpu)
 {

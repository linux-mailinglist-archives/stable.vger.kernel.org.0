Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE3469C5D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347119AbhLFPV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358228AbhLFPTk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDDFC061A83;
        Mon,  6 Dec 2021 07:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB18DB810F1;
        Mon,  6 Dec 2021 15:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9904C341C2;
        Mon,  6 Dec 2021 15:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803627;
        bh=cwI1ZwbZE7VKKji52lZh54wwQGyBEHxScIYPIyWCq94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWaPqbZ79wR4HIxncR3Vgb16M2jVlveMaj56joCJiG2o90syPjrYV+HecqJH+3o7A
         dJZqfwQlhW5W5OBnrY08QkGUds7eBX/a5Wr2r7P8mk9BA/aDAHVm4Sl6EaGKhnQL5w
         2mfReG7f22qydg3vl0FAwaRr1yuX/1YPFBi7SG/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.4 59/70] x86/tsc: Add a timer to make sure TSC_adjust is always checked
Date:   Mon,  6 Dec 2021 15:57:03 +0100
Message-Id: <20211206145553.963479164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145551.909846023@linuxfoundation.org>
References: <20211206145551.909846023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

commit c7719e79347803b8e3b6b50da8c6db410a3012b5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/tsc_sync.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

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



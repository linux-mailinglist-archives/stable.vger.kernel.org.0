Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C868469E26
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348618AbhLFPge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388367AbhLFPci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DFCC09B108;
        Mon,  6 Dec 2021 07:19:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B3B6132E;
        Mon,  6 Dec 2021 15:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BFFC341C1;
        Mon,  6 Dec 2021 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803984;
        bh=cwI1ZwbZE7VKKji52lZh54wwQGyBEHxScIYPIyWCq94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgrjt9bdXu0aeo2z0s3Lm3IP5aFUICjQ74DCh0a+zcJBmeA79/DfyU0o9QBlCkJcw
         P0OSMb6rfHZ8c1USAHfX0Go1xvicOs0ByyyKU0bceDX9Bx+TEgfvtyWOGHx3QjZZ1t
         ayLoBnYefmvR2c/QSZ2xYaOmgD1PBTv/nuwtaXcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.10 117/130] x86/tsc: Add a timer to make sure TSC_adjust is always checked
Date:   Mon,  6 Dec 2021 15:57:14 +0100
Message-Id: <20211206145603.695884949@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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



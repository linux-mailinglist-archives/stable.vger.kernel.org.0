Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9172B469C20
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348828AbhLFPVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50776 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354485AbhLFPSJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:18:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33219B8114D;
        Mon,  6 Dec 2021 15:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C2C341C1;
        Mon,  6 Dec 2021 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803677;
        bh=z/nOj10xIM3AXepIf3/jMblab51StdRinc/fePrheQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0CP+s93dG1ZgCqXbE+iaoFJgOOAt1nrYTIGKfmP0UwmW/fdkQi6ewot8h/Kv+9lK
         9lb+8hzRMtbfZ/XvVc0zbtdKMCHjnLX2t/aKS6S3L7/l0Tbl4SKH91Hk1WXNldak0L
         3JaaPvPtB5VDXKGTb5jHOjkxsvIAevzYmNLtX694=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.4 60/70] x86/tsc: Disable clocksource watchdog for TSC on qualified platorms
Date:   Mon,  6 Dec 2021 15:57:04 +0100
Message-Id: <20211206145553.994509372@linuxfoundation.org>
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

commit b50db7095fe002fa3e16605546cba66bf1b68a3e upstream.

There are cases that the TSC clocksource is wrongly judged as unstable by
the clocksource watchdog mechanism which tries to validate the TSC against
HPET, PM_TIMER or jiffies. While there is hardly a general reliable way to
check the validity of a watchdog, Thomas Gleixner proposed [1]:

"I'm inclined to lift that requirement when the CPU has:

    1) X86_FEATURE_CONSTANT_TSC
    2) X86_FEATURE_NONSTOP_TSC
    3) X86_FEATURE_NONSTOP_TSC_S3
    4) X86_FEATURE_TSC_ADJUST
    5) At max. 4 sockets

 After two decades of horrors we're finally at a point where TSC seems
 to be halfway reliable and less abused by BIOS tinkerers. TSC_ADJUST
 was really key as we can now detect even small modifications reliably
 and the important point is that we can cure them as well (not pretty
 but better than all other options)."

As feature #3 X86_FEATURE_NONSTOP_TSC_S3 only exists on several generations
of Atom processorz, and is always coupled with X86_FEATURE_CONSTANT_TSC
and X86_FEATURE_NONSTOP_TSC, skip checking it, and also be more defensive
to use maximal 2 sockets.

The check is done inside tsc_init() before registering 'tsc-early' and
'tsc' clocksources, as there were cases that both of them had been
wrongly judged as unreliable.

For more background of tsc/watchdog, there is a good summary in [2]

[tglx} Update vs. jiffies:

  On systems where the only remaining clocksource aside of TSC is jiffies
  there is no way to make this work because that creates a circular
  dependency. Jiffies accuracy depends on not missing a periodic timer
  interrupt, which is not guaranteed. That could be detected by TSC, but as
  TSC is not trusted this cannot be compensated. The consequence is a
  circulus vitiosus which results in shutting down TSC and falling back to
  the jiffies clocksource which is even more unreliable.

[1]. https://lore.kernel.org/lkml/87eekfk8bd.fsf@nanos.tec.linutronix.de/
[2]. https://lore.kernel.org/lkml/87a6pimt1f.ffs@nanos.tec.linutronix.de/

[ tglx: Refine comment and amend changelog ]

Fixes: 6e3cd95234dc ("x86/hpet: Use another crystalball to evaluate HPET usability")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211117023751.24190-2-feng.tang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/tsc.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1162,6 +1162,12 @@ void mark_tsc_unstable(char *reason)
 
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
+static void __init tsc_disable_clocksource_watchdog(void)
+{
+	clocksource_tsc_early.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+	clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+}
+
 static void __init check_system_tsc_reliable(void)
 {
 #if defined(CONFIG_MGEODEGX1) || defined(CONFIG_MGEODE_LX) || defined(CONFIG_X86_GENERIC)
@@ -1178,6 +1184,23 @@ static void __init check_system_tsc_reli
 #endif
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
 		tsc_clocksource_reliable = 1;
+
+	/*
+	 * Disable the clocksource watchdog when the system has:
+	 *  - TSC running at constant frequency
+	 *  - TSC which does not stop in C-States
+	 *  - the TSC_ADJUST register which allows to detect even minimal
+	 *    modifications
+	 *  - not more than two sockets. As the number of sockets cannot be
+	 *    evaluated at the early boot stage where this has to be
+	 *    invoked, check the number of online memory nodes as a
+	 *    fallback solution which is an reasonable estimate.
+	 */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+	    boot_cpu_has(X86_FEATURE_TSC_ADJUST) &&
+	    nr_online_nodes <= 2)
+		tsc_disable_clocksource_watchdog();
 }
 
 /*
@@ -1369,9 +1392,6 @@ static int __init init_tsc_clocksource(v
 	if (tsc_unstable)
 		goto unreg;
 
-	if (tsc_clocksource_reliable || no_tsc_watchdog)
-		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
-
 	if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
 		clocksource_tsc.flags |= CLOCK_SOURCE_SUSPEND_NONSTOP;
 
@@ -1506,7 +1526,7 @@ void __init tsc_init(void)
 	}
 
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
-		clocksource_tsc_early.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+		tsc_disable_clocksource_watchdog();
 
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1972C4659F3
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 00:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353854AbhLAXu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 18:50:29 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44084 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353823AbhLAXu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 18:50:28 -0500
Date:   Wed, 01 Dec 2021 23:47:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638402425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s59PtGQGPD2YRyZrbVk1TXoitco8b8rZhZ3+gHWGsqo=;
        b=R7FM6oweFSDPD4+wcBd2I8YecZZ0bmCgiV5+l8nfno5ONgilLItrUyasfdusa7HEBkG1cV
        hVpuKVggrTq6xBeUdDTs60+u6FIjCCy5tAyoVPcIqMXW+jxgeBzxwETVRKha7exOYVD5Iq
        icstY4PYqbNVsgIHi7W1RO9rdS3ibUqKIHdhlHJaNvBNE5qfZWRMwgwxSXg1Qdpk0KFFYZ
        1842eP9kr3CsA66vIbfXf6aoxPfQ36+tvNYW7s5BhosTQUnQCQpbh+v42DT9IuTVTmUTmB
        b+7/rQbdkEE+SvcpO2wil8MVHWIScAK8MBXpz2wISzXDD7ahHEJXWknlS1+tGA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638402425;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s59PtGQGPD2YRyZrbVk1TXoitco8b8rZhZ3+gHWGsqo=;
        b=Esk/omZLuT1/MG7r0zzjbiQye4XjD/PQutCW9M+BLqeFOWYF8KuQ0FYZ64l86rvyfTwr7p
        4j5D/ckHQbkLwXBQ==
From:   "tip-bot2 for Feng Tang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/tsc: Disable clocksource watchdog for TSC on
 qualified platorms
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211117023751.24190-2-feng.tang@intel.com>
References: <20211117023751.24190-2-feng.tang@intel.com>
MIME-Version: 1.0
Message-ID: <163840242372.11128.2601584703913368347.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b50db7095fe002fa3e16605546cba66bf1b68a3e
Gitweb:        https://git.kernel.org/tip/b50db7095fe002fa3e16605546cba66bf1b68a3e
Author:        Feng Tang <feng.tang@intel.com>
AuthorDate:    Wed, 17 Nov 2021 10:37:51 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 02 Dec 2021 00:40:36 +01:00

x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

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

---
 arch/x86/kernel/tsc.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 2e076a4..a698196 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1180,6 +1180,12 @@ void mark_tsc_unstable(char *reason)
 
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
@@ -1196,6 +1202,23 @@ static void __init check_system_tsc_reliable(void)
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
@@ -1387,9 +1410,6 @@ static int __init init_tsc_clocksource(void)
 	if (tsc_unstable)
 		goto unreg;
 
-	if (tsc_clocksource_reliable || no_tsc_watchdog)
-		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
-
 	if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
 		clocksource_tsc.flags |= CLOCK_SOURCE_SUSPEND_NONSTOP;
 
@@ -1527,7 +1547,7 @@ void __init tsc_init(void)
 	}
 
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
-		clocksource_tsc_early.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+		tsc_disable_clocksource_watchdog();
 
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();

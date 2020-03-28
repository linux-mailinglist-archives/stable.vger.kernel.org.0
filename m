Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6C1196524
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 11:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgC1KsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 06:48:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55476 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgC1KsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Mar 2020 06:48:19 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jI90g-0003T6-0F; Sat, 28 Mar 2020 11:48:14 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 932E11C03A9;
        Sat, 28 Mar 2020 11:48:13 +0100 (CET)
Date:   Sat, 28 Mar 2020 10:48:13 -0000
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: smp/core] cpu/hotplug: Ignore pm_wakeup_pending() for
 disable_nonboot_cpus()
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <874kuaxdiz.fsf@nanos.tec.linutronix.de>
References: <874kuaxdiz.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <158539249320.28353.17099278442328307370.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the smp/core branch of tip:

Commit-ID:     e98eac6ff1b45e4e73f2e6031b37c256ccb5d36b
Gitweb:        https://git.kernel.org/tip/e98eac6ff1b45e4e73f2e6031b37c256ccb5d36b
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 27 Mar 2020 12:06:44 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 28 Mar 2020 11:42:55 +01:00

cpu/hotplug: Ignore pm_wakeup_pending() for disable_nonboot_cpus()

A recent change to freeze_secondary_cpus() which added an early abort if a
wakeup is pending missed the fact that the function is also invoked for
shutdown, reboot and kexec via disable_nonboot_cpus().

In case of disable_nonboot_cpus() the wakeup event needs to be ignored as
the purpose is to terminate the currently running kernel.

Add a 'suspend' argument which is only set when the freeze is in context of
a suspend operation. If not set then an eventually pending wakeup event is
ignored.

Fixes: a66d955e910a ("cpu/hotplug: Abort disabling secondary CPUs if wakeup is pending")
Reported-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/874kuaxdiz.fsf@nanos.tec.linutronix.de


---
 include/linux/cpu.h | 12 +++++++++---
 kernel/cpu.c        |  4 ++--
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 9ead281..beaed2d 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -144,12 +144,18 @@ static inline void get_online_cpus(void) { cpus_read_lock(); }
 static inline void put_online_cpus(void) { cpus_read_unlock(); }
 
 #ifdef CONFIG_PM_SLEEP_SMP
-extern int freeze_secondary_cpus(int primary);
+int __freeze_secondary_cpus(int primary, bool suspend);
+static inline int freeze_secondary_cpus(int primary)
+{
+	return __freeze_secondary_cpus(primary, true);
+}
+
 static inline int disable_nonboot_cpus(void)
 {
-	return freeze_secondary_cpus(0);
+	return __freeze_secondary_cpus(0, false);
 }
-extern void enable_nonboot_cpus(void);
+
+void enable_nonboot_cpus(void);
 
 static inline int suspend_disable_secondary_cpus(void)
 {
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 3084849..12ae636 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1327,7 +1327,7 @@ void bringup_nonboot_cpus(unsigned int setup_max_cpus)
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
 
-int freeze_secondary_cpus(int primary)
+int __freeze_secondary_cpus(int primary, bool suspend)
 {
 	int cpu, error = 0;
 
@@ -1352,7 +1352,7 @@ int freeze_secondary_cpus(int primary)
 		if (cpu == primary)
 			continue;
 
-		if (pm_wakeup_pending()) {
+		if (suspend && pm_wakeup_pending()) {
 			pr_info("Wakeup pending. Abort CPU freeze\n");
 			error = -EBUSY;
 			break;

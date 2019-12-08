Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB6F11623F
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfLHNyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:54:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59946 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbfLHNyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:40 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0007dF-3l; Sun, 08 Dec 2019 13:54:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1A-0002L7-JU; Sun, 08 Dec 2019 13:54:36 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Grzegorz Halat" <ghalat@redhat.com>,
        "Don Zickus" <dzickus@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Sun, 08 Dec 2019 13:52:53 +0000
Message-ID: <lsq.1575813165.85081378@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/72] x86/reboot: Always use NMI fallback when
 shutdown via reboot vector IPI fails
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Halat <ghalat@redhat.com>

commit 747d5a1bf293dcb33af755a6d285d41b8c1ea010 upstream.

A reboot request sends an IPI via the reboot vector and waits for all other
CPUs to stop. If one or more CPUs are in critical regions with interrupts
disabled then the IPI is not handled on those CPUs and the shutdown hangs
if native_stop_other_cpus() is called with the wait argument set.

Such a situation can happen when one CPU was stopped within a lock held
section and another CPU is trying to acquire that lock with interrupts
disabled. There are other scenarios which can cause such a lockup as well.

In theory the shutdown should be attempted by an NMI IPI after the timeout
period elapsed. Though the wait loop after sending the reboot vector IPI
prevents this. It checks the wait request argument and the timeout. If wait
is set, which is true for sys_reboot() then it won't fall through to the
NMI shutdown method after the timeout period has finished.

This was an oversight when the NMI shutdown mechanism was added to handle
the 'reboot IPI is not working' situation. The mechanism was added to deal
with stuck panic shutdowns, which do not have the wait request set, so the
'wait request' case was probably not considered.

Remove the wait check from the post reboot vector IPI wait loop and enforce
that the wait loop in the NMI fallback path is invoked even if NMI IPIs are
disabled or the registration of the NMI handler fails. That second wait
loop will then hang if not all CPUs shutdown and the wait argument is set.

[ tglx: Avoid the hard to parse line break in the NMI fallback path,
  	add comments and massage the changelog ]

Fixes: 7d007d21e539 ("x86/reboot: Use NMI to assist in shutting down if IRQ fails")
Signed-off-by: Grzegorz Halat <ghalat@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Don Zickus <dzickus@redhat.com>
Link: https://lkml.kernel.org/r/20190628122813.15500-1-ghalat@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/smp.c | 46 +++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -178,6 +178,12 @@ asmlinkage __visible void smp_reboot_int
 	irq_exit();
 }
 
+static int register_stop_handler(void)
+{
+	return register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
+				    NMI_FLAG_FIRST, "smp_stop");
+}
+
 static void native_stop_other_cpus(int wait)
 {
 	unsigned long flags;
@@ -211,39 +217,41 @@ static void native_stop_other_cpus(int w
 		apic->send_IPI_allbutself(REBOOT_VECTOR);
 
 		/*
-		 * Don't wait longer than a second if the caller
-		 * didn't ask us to wait.
+		 * Don't wait longer than a second for IPI completion. The
+		 * wait request is not checked here because that would
+		 * prevent an NMI shutdown attempt in case that not all
+		 * CPUs reach shutdown state.
 		 */
 		timeout = USEC_PER_SEC;
-		while (num_online_cpus() > 1 && (wait || timeout--))
+		while (num_online_cpus() > 1 && timeout--)
 			udelay(1);
 	}
-	
-	/* if the REBOOT_VECTOR didn't work, try with the NMI */
-	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
-		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-					 NMI_FLAG_FIRST, "smp_stop"))
-			/* Note: we ignore failures here */
-			/* Hope the REBOOT_IRQ is good enough */
-			goto finish;
-
-		/* sync above data before sending IRQ */
-		wmb();
 
-		pr_emerg("Shutting down cpus with NMI\n");
+	/* if the REBOOT_VECTOR didn't work, try with the NMI */
+	if (num_online_cpus() > 1) {
+		/*
+		 * If NMI IPI is enabled, try to register the stop handler
+		 * and send the IPI. In any case try to wait for the other
+		 * CPUs to stop.
+		 */
+		if (!smp_no_nmi_ipi && !register_stop_handler()) {
+			/* Sync above data before sending IRQ */
+			wmb();
 
-		apic->send_IPI_allbutself(NMI_VECTOR);
+			pr_emerg("Shutting down cpus with NMI\n");
 
+			apic->send_IPI_allbutself(NMI_VECTOR);
+		}
 		/*
-		 * Don't wait longer than a 10 ms if the caller
-		 * didn't ask us to wait.
+		 * Don't wait longer than 10 ms if the caller didn't
+		 * reqeust it. If wait is true, the machine hangs here if
+		 * one or more CPUs do not reach shutdown state.
 		 */
 		timeout = USEC_PER_MSEC * 10;
 		while (num_online_cpus() > 1 && (wait || timeout--))
 			udelay(1);
 	}
 
-finish:
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);


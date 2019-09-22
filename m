Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E1BA81C
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395306AbfIVTBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395296AbfIVTBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 15:01:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9FFB214D9;
        Sun, 22 Sep 2019 19:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178876;
        bh=/KhXoajcaFdtR7vR0vC+wUAKUGLFw6dl2D8gkPyfZZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMNwZLRYZl1dvrazlErEHU/hdMK3iW/Kr9NKPNWO96b0OZALbpmje8MIW42sShYWi
         9fePjy5s/0S6eMvdj10z5Bmi9nWhER3NUeQd+RDX8/Rn8yX6NOou13hks2jq3iXGAz
         WAgFJvsOOg3I1xZhDK3IgnNuL5ubpDLCliGADRAo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grzegorz Halat <ghalat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Don Zickus <dzickus@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 09/44] x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails
Date:   Sun, 22 Sep 2019 15:00:27 -0400
Message-Id: <20190922190103.4906-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Halat <ghalat@redhat.com>

[ Upstream commit 747d5a1bf293dcb33af755a6d285d41b8c1ea010 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/smp.c | 46 +++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 12c8286206ce2..6a0ba9d09b0ed 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -176,6 +176,12 @@ asmlinkage __visible void smp_reboot_interrupt(void)
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
@@ -209,39 +215,41 @@ static void native_stop_other_cpus(int wait)
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
 	mcheck_cpu_clear(this_cpu_ptr(&cpu_info));
-- 
2.20.1


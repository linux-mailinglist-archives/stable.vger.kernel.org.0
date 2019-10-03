Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05325CA1D6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfJCP7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731364AbfJCP7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:59:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939AF21783;
        Thu,  3 Oct 2019 15:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118378;
        bh=/KhXoajcaFdtR7vR0vC+wUAKUGLFw6dl2D8gkPyfZZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTLS8nEc8MKEysQ3SKXwcNkguTIVpV2D+CbXdPb8TAIpyfbPooFc7AZpRQVrnsOEH
         OcnHojNZicvfDlDGOB19zAnPk7igUcF68iH7CUeWr//x/Q14Ir7wN6o4aoKI070pVD
         7tPzt60T1VIyGsbD9m3LW4YlMQKk4UrG3ZpLg1xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Halat <ghalat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Don Zickus <dzickus@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 41/99] x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails
Date:   Thu,  3 Oct 2019 17:53:04 +0200
Message-Id: <20191003154315.752475207@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




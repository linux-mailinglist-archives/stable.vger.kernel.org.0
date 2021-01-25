Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F65D304ACB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbhAZE5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbhAYStH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED764224D4;
        Mon, 25 Jan 2021 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600502;
        bh=tXLQSIHnS4d+/iqfYlvP75/xWHWSLHLa+wtd3ubTVM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa/WgvPQ649HzzgPanJEatfW80v5R6Nih16jxx38qVDsRDmtEAXklThUMIcxYZ6P1
         CAX09zUPhSvRuatAgy0I+ZjkC0vveQGD/Ryx/PvaS2RUMP1mLPSgxGCC4AIGR0dLhW
         6XNZcGsJ05M8/sD8dMMkfnvbMdkxCzrClyOAKtEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/199] x86/hyperv: Fix kexec panic/hang issues
Date:   Mon, 25 Jan 2021 19:37:42 +0100
Message-Id: <20210125183217.936237180@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit dfe94d4086e40e92b1926bddcefa629b791e9b28 ]

Currently the kexec kernel can panic or hang due to 2 causes:

1) hv_cpu_die() is not called upon kexec, so the hypervisor corrupts the
old VP Assist Pages when the kexec kernel runs. The same issue is fixed
for hibernation in commit 421f090c819d ("x86/hyperv: Suspend/resume the
VP assist page for hibernation"). Now fix it for kexec.

2) hyperv_cleanup() is called too early. In the kexec path, the other CPUs
are stopped in hv_machine_shutdown() -> native_machine_shutdown(), so
between hv_kexec_handler() and native_machine_shutdown(), the other CPUs
can still try to access the hypercall page and cause panic. The workaround
"hv_hypercall_pg = NULL;" in hyperv_cleanup() is unreliabe. Move
hyperv_cleanup() to a better place.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20201222065541.24312-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c       |  4 ++++
 arch/x86/include/asm/mshyperv.h |  2 ++
 arch/x86/kernel/cpu/mshyperv.c  | 18 ++++++++++++++++++
 drivers/hv/vmbus_drv.c          |  2 --
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 6fb8cb7b9bcc6..6375967a8244d 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -16,6 +16,7 @@
 #include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
 #include <asm/idtentry.h>
+#include <linux/kexec.h>
 #include <linux/version.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
@@ -26,6 +27,8 @@
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 
+int hyperv_init_cpuhp;
+
 void *hv_hypercall_pg;
 EXPORT_SYMBOL_GPL(hv_hypercall_pg);
 
@@ -424,6 +427,7 @@ void __init hyperv_init(void)
 
 	register_syscore_ops(&hv_syscore_ops);
 
+	hyperv_init_cpuhp = cpuhp;
 	return;
 
 remove_cpuhp_state:
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index ffc289992d1b0..30f76b9668579 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -74,6 +74,8 @@ static inline void hv_disable_stimer0_percpu_irq(int irq) {}
 
 
 #if IS_ENABLED(CONFIG_HYPERV)
+extern int hyperv_init_cpuhp;
+
 extern void *hv_hypercall_pg;
 extern void  __percpu  **hyperv_pcpu_input_arg;
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 05ef1f4550cbd..6cc50ab07bded 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -135,14 +135,32 @@ static void hv_machine_shutdown(void)
 {
 	if (kexec_in_progress && hv_kexec_handler)
 		hv_kexec_handler();
+
+	/*
+	 * Call hv_cpu_die() on all the CPUs, otherwise later the hypervisor
+	 * corrupts the old VP Assist Pages and can crash the kexec kernel.
+	 */
+	if (kexec_in_progress && hyperv_init_cpuhp > 0)
+		cpuhp_remove_state(hyperv_init_cpuhp);
+
+	/* The function calls stop_other_cpus(). */
 	native_machine_shutdown();
+
+	/* Disable the hypercall page when there is only 1 active CPU. */
+	if (kexec_in_progress)
+		hyperv_cleanup();
 }
 
 static void hv_machine_crash_shutdown(struct pt_regs *regs)
 {
 	if (hv_crash_handler)
 		hv_crash_handler(regs);
+
+	/* The function calls crash_smp_send_stop(). */
 	native_machine_crash_shutdown(regs);
+
+	/* Disable the hypercall page when there is only 1 active CPU. */
+	hyperv_cleanup();
 }
 #endif /* CONFIG_KEXEC_CORE */
 #endif /* CONFIG_HYPERV */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4fad3e6745e53..a5a402e776c77 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2542,7 +2542,6 @@ static void hv_kexec_handler(void)
 	/* Make sure conn_state is set as hv_synic_cleanup checks for it */
 	mb();
 	cpuhp_remove_state(hyperv_cpuhp_online);
-	hyperv_cleanup();
 };
 
 static void hv_crash_handler(struct pt_regs *regs)
@@ -2558,7 +2557,6 @@ static void hv_crash_handler(struct pt_regs *regs)
 	cpu = smp_processor_id();
 	hv_stimer_cleanup(cpu);
 	hv_synic_disable_regs(cpu);
-	hyperv_cleanup();
 };
 
 static int hv_synic_suspend(void)
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426A01EFB0F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgFEOSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgFEOSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574AA208FE;
        Fri,  5 Jun 2020 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366698;
        bh=u97YBDVTJuQTGmdl7h/p7bp5+7w/PQzD5zSRz9yhpgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JL+W62kiIUTQ3lyyqTbJYASQx9aZ1WieUUrcsIuoqekwJ1u+5DKCB6fqcSdcYNBU9
         oWcfQscZnGxGoXXKntsQ2YF6IA/v6+bkTdu/HQeDWXnCQX7xOgx1ht175JyTn0zllF
         sUhJtgPlHz2F0oX22nFYbKz37prH3SBkM9uY1px0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Donnellan <ajd@linux.ibm.com>,
        "Christopher M. Riedl" <cmr@informatik.wtf>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/38] powerpc/xmon: Restrict when kernel is locked down
Date:   Fri,  5 Jun 2020 16:15:01 +0200
Message-Id: <20200605140253.653389136@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christopher M. Riedl <cmr@informatik.wtf>

[ Upstream commit 69393cb03ccdf29f3b452d3482ef918469d1c098 ]

Xmon should be either fully or partially disabled depending on the
kernel lockdown state.

Put xmon into read-only mode for lockdown=integrity and prevent user
entry into xmon when lockdown=confidentiality. Xmon checks the lockdown
state on every attempted entry:

 (1) during early xmon'ing

 (2) when triggered via sysrq

 (3) when toggled via debugfs

 (4) when triggered via a previously enabled breakpoint

The following lockdown state transitions are handled:

 (1) lockdown=none -> lockdown=integrity
     set xmon read-only mode

 (2) lockdown=none -> lockdown=confidentiality
     clear all breakpoints, set xmon read-only mode,
     prevent user re-entry into xmon

 (3) lockdown=integrity -> lockdown=confidentiality
     clear all breakpoints, set xmon read-only mode,
     prevent user re-entry into xmon

Suggested-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190907061124.1947-3-cmr@informatik.wtf
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c     | 103 ++++++++++++++++++++++++++++-------
 include/linux/security.h     |   2 +
 security/lockdown/lockdown.c |   2 +
 3 files changed, 86 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 8057aafd5f5e..6d130c89fbd8 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -25,6 +25,7 @@
 #include <linux/nmi.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>
+#include <linux/security.h>
 
 #include <asm/debugfs.h>
 #include <asm/ptrace.h>
@@ -187,6 +188,8 @@ static void dump_tlb_44x(void);
 static void dump_tlb_book3e(void);
 #endif
 
+static void clear_all_bpt(void);
+
 #ifdef CONFIG_PPC64
 #define REG		"%.16lx"
 #else
@@ -283,10 +286,38 @@ Commands:\n\
 "  U	show uptime information\n"
 "  ?	help\n"
 "  # n	limit output to n lines per page (for dp, dpa, dl)\n"
-"  zr	reboot\n\
-  zh	halt\n"
+"  zr	reboot\n"
+"  zh	halt\n"
 ;
 
+#ifdef CONFIG_SECURITY
+static bool xmon_is_locked_down(void)
+{
+	static bool lockdown;
+
+	if (!lockdown) {
+		lockdown = !!security_locked_down(LOCKDOWN_XMON_RW);
+		if (lockdown) {
+			printf("xmon: Disabled due to kernel lockdown\n");
+			xmon_is_ro = true;
+		}
+	}
+
+	if (!xmon_is_ro) {
+		xmon_is_ro = !!security_locked_down(LOCKDOWN_XMON_WR);
+		if (xmon_is_ro)
+			printf("xmon: Read-only due to kernel lockdown\n");
+	}
+
+	return lockdown;
+}
+#else /* CONFIG_SECURITY */
+static inline bool xmon_is_locked_down(void)
+{
+	return false;
+}
+#endif
+
 static struct pt_regs *xmon_regs;
 
 static inline void sync(void)
@@ -438,7 +469,10 @@ static bool wait_for_other_cpus(int ncpus)
 
 	return false;
 }
-#endif /* CONFIG_SMP */
+#else /* CONFIG_SMP */
+static inline void get_output_lock(void) {}
+static inline void release_output_lock(void) {}
+#endif
 
 static inline int unrecoverable_excp(struct pt_regs *regs)
 {
@@ -455,6 +489,7 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 	int cmd = 0;
 	struct bpt *bp;
 	long recurse_jmp[JMP_BUF_LEN];
+	bool locked_down;
 	unsigned long offset;
 	unsigned long flags;
 #ifdef CONFIG_SMP
@@ -465,6 +500,8 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 	local_irq_save(flags);
 	hard_irq_disable();
 
+	locked_down = xmon_is_locked_down();
+
 	if (!fromipi) {
 		tracing_enabled = tracing_is_on();
 		tracing_off();
@@ -518,7 +555,8 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 
 	if (!fromipi) {
 		get_output_lock();
-		excprint(regs);
+		if (!locked_down)
+			excprint(regs);
 		if (bp) {
 			printf("cpu 0x%x stopped at breakpoint 0x%tx (",
 			       cpu, BP_NUM(bp));
@@ -570,10 +608,14 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 		}
 		remove_bpts();
 		disable_surveillance();
-		/* for breakpoint or single step, print the current instr. */
-		if (bp || TRAP(regs) == 0xd00)
-			ppc_inst_dump(regs->nip, 1, 0);
-		printf("enter ? for help\n");
+
+		if (!locked_down) {
+			/* for breakpoint or single step, print curr insn */
+			if (bp || TRAP(regs) == 0xd00)
+				ppc_inst_dump(regs->nip, 1, 0);
+			printf("enter ? for help\n");
+		}
+
 		mb();
 		xmon_gate = 1;
 		barrier();
@@ -597,8 +639,9 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 			spin_cpu_relax();
 			touch_nmi_watchdog();
 		} else {
-			cmd = cmds(regs);
-			if (cmd != 0) {
+			if (!locked_down)
+				cmd = cmds(regs);
+			if (locked_down || cmd != 0) {
 				/* exiting xmon */
 				insert_bpts();
 				xmon_gate = 0;
@@ -635,13 +678,16 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 			       "can't continue\n");
 		remove_bpts();
 		disable_surveillance();
-		/* for breakpoint or single step, print the current instr. */
-		if (bp || TRAP(regs) == 0xd00)
-			ppc_inst_dump(regs->nip, 1, 0);
-		printf("enter ? for help\n");
+		if (!locked_down) {
+			/* for breakpoint or single step, print current insn */
+			if (bp || TRAP(regs) == 0xd00)
+				ppc_inst_dump(regs->nip, 1, 0);
+			printf("enter ? for help\n");
+		}
 	}
 
-	cmd = cmds(regs);
+	if (!locked_down)
+		cmd = cmds(regs);
 
 	insert_bpts();
 	in_xmon = 0;
@@ -670,7 +716,10 @@ static int xmon_core(struct pt_regs *regs, int fromipi)
 		}
 	}
 #endif
-	insert_cpu_bpts();
+	if (locked_down)
+		clear_all_bpt();
+	else
+		insert_cpu_bpts();
 
 	touch_nmi_watchdog();
 	local_irq_restore(flags);
@@ -3761,6 +3810,11 @@ static void xmon_init(int enable)
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_xmon(int key)
 {
+	if (xmon_is_locked_down()) {
+		clear_all_bpt();
+		xmon_init(0);
+		return;
+	}
 	/* ensure xmon is enabled */
 	xmon_init(1);
 	debugger(get_irq_regs());
@@ -3782,7 +3836,6 @@ static int __init setup_xmon_sysrq(void)
 device_initcall(setup_xmon_sysrq);
 #endif /* CONFIG_MAGIC_SYSRQ */
 
-#ifdef CONFIG_DEBUG_FS
 static void clear_all_bpt(void)
 {
 	int i;
@@ -3800,18 +3853,22 @@ static void clear_all_bpt(void)
 		iabr = NULL;
 		dabr.enabled = 0;
 	}
-
-	printf("xmon: All breakpoints cleared\n");
 }
 
+#ifdef CONFIG_DEBUG_FS
 static int xmon_dbgfs_set(void *data, u64 val)
 {
 	xmon_on = !!val;
 	xmon_init(xmon_on);
 
 	/* make sure all breakpoints removed when disabling */
-	if (!xmon_on)
+	if (!xmon_on) {
 		clear_all_bpt();
+		get_output_lock();
+		printf("xmon: All breakpoints cleared\n");
+		release_output_lock();
+	}
+
 	return 0;
 }
 
@@ -3837,7 +3894,11 @@ static int xmon_early __initdata;
 
 static int __init early_parse_xmon(char *p)
 {
-	if (!p || strncmp(p, "early", 5) == 0) {
+	if (xmon_is_locked_down()) {
+		xmon_init(0);
+		xmon_early = 0;
+		xmon_on = 0;
+	} else if (!p || strncmp(p, "early", 5) == 0) {
 		/* just "xmon" is equivalent to "xmon=early" */
 		xmon_init(1);
 		xmon_early = 1;
diff --git a/include/linux/security.h b/include/linux/security.h
index 9df7547afc0c..fd022768e91d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -117,12 +117,14 @@ enum lockdown_reason {
 	LOCKDOWN_MODULE_PARAMETERS,
 	LOCKDOWN_MMIOTRACE,
 	LOCKDOWN_DEBUGFS,
+	LOCKDOWN_XMON_WR,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
 	LOCKDOWN_BPF_READ,
 	LOCKDOWN_PERF,
 	LOCKDOWN_TRACEFS,
+	LOCKDOWN_XMON_RW,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 40b790536def..b2f87015d6e9 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -32,12 +32,14 @@ static const char *const lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_MODULE_PARAMETERS] = "unsafe module parameters",
 	[LOCKDOWN_MMIOTRACE] = "unsafe mmio",
 	[LOCKDOWN_DEBUGFS] = "debugfs access",
+	[LOCKDOWN_XMON_WR] = "xmon write access",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
 	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
 	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_TRACEFS] = "use of tracefs",
+	[LOCKDOWN_XMON_RW] = "xmon read and write access",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.25.1




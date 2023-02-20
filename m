Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3446769CDA5
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbjBTNvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbjBTNvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:51:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AB21E2B0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9BF8B80D4B
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D84C4339E;
        Mon, 20 Feb 2023 13:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901074;
        bh=6APp46k1uOUylQ986QImYAz8UAud+XRc7zD0Hyvg5vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUTJZ7Sxyq95gGDLWB/gKm58g4Z2hFZ9CppAU483UkWhnOPHHwAmYWw9ATNsFOsjc
         Ojls/hI9DWLWrflPbw0gh9bGtLOVzJEahjuxjGBXBUraZHJNe6J3HkGIRZuRTcWVZ5
         TT2u2/mkfC0dl1SDW1TPEGZxyWlizomT2ZQ6WMyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/83] kprobes: treewide: Cleanup the error messages for kprobes
Date:   Mon, 20 Feb 2023 14:35:35 +0100
Message-Id: <20230220133553.750204587@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 9c89bb8e327203bc27e09ebd82d8f61ac2ae8b24 ]

This clean up the error/notification messages in kprobes related code.
Basically this defines 'pr_fmt()' macros for each files and update
the messages which describes

 - what happened,
 - what is the kernel going to do or not do,
 - is the kernel fine,
 - what can the user do about it.

Also, if the message is not needed (e.g. the function returns unique
error code, or other error message is already shown.) remove it,
and replace the message with WARN_*() macros if suitable.

Link: https://lkml.kernel.org/r/163163036568.489837.14085396178727185469.stgit@devnote2

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: eb7423273cc9 ("riscv: kprobe: Fixup misaligned load text")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/probes/kprobes/core.c     |  4 +++-
 arch/arm64/kernel/probes/kprobes.c |  5 ++++-
 arch/csky/kernel/probes/kprobes.c  | 10 ++++-----
 arch/mips/kernel/kprobes.c         | 11 +++++----
 arch/riscv/kernel/probes/kprobes.c | 11 +++++----
 arch/s390/kernel/kprobes.c         |  4 +++-
 kernel/kprobes.c                   | 36 +++++++++++++-----------------
 7 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/arch/arm/probes/kprobes/core.c b/arch/arm/probes/kprobes/core.c
index 9d8634e2f12f7..9bcae72dda440 100644
--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -11,6 +11,8 @@
  * Copyright (C) 2007 Marvell Ltd.
  */
 
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
 #include <linux/module.h>
@@ -278,7 +280,7 @@ void __kprobes kprobe_handler(struct pt_regs *regs)
 				break;
 			case KPROBE_REENTER:
 				/* A nested probe was hit in FIQ, it is a BUG */
-				pr_warn("Unrecoverable kprobe detected.\n");
+				pr_warn("Failed to recover from reentered kprobes.\n");
 				dump_kprobe(p);
 				fallthrough;
 			default:
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index b7404dba0d623..2162b6fd7251d 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -7,6 +7,9 @@
  * Copyright (C) 2013 Linaro Limited.
  * Author: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
  */
+
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/extable.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -218,7 +221,7 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 		break;
 	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
-		pr_warn("Unrecoverable kprobe detected.\n");
+		pr_warn("Failed to recover from reentered kprobes.\n");
 		dump_kprobe(p);
 		BUG();
 		break;
diff --git a/arch/csky/kernel/probes/kprobes.c b/arch/csky/kernel/probes/kprobes.c
index 584ed9f36290f..bd92ac376e157 100644
--- a/arch/csky/kernel/probes/kprobes.c
+++ b/arch/csky/kernel/probes/kprobes.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/kprobes.h>
 #include <linux/extable.h>
 #include <linux/slab.h>
@@ -77,10 +79,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	unsigned long probe_addr = (unsigned long)p->addr;
 
-	if (probe_addr & 0x1) {
-		pr_warn("Address not aligned.\n");
-		return -EINVAL;
-	}
+	if (probe_addr & 0x1)
+		return -EILSEQ;
 
 	/* copy instruction */
 	p->opcode = le32_to_cpu(*p->addr);
@@ -229,7 +229,7 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 		break;
 	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
-		pr_warn("Unrecoverable kprobe detected.\n");
+		pr_warn("Failed to recover from reentered kprobes.\n");
 		dump_kprobe(p);
 		BUG();
 		break;
diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
index 75bff0f773198..b0934a0d7aedd 100644
--- a/arch/mips/kernel/kprobes.c
+++ b/arch/mips/kernel/kprobes.c
@@ -11,6 +11,8 @@
  *   Copyright (C) IBM Corporation, 2002, 2004
  */
 
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/kprobes.h>
 #include <linux/preempt.h>
 #include <linux/uaccess.h>
@@ -80,8 +82,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	insn = p->addr[0];
 
 	if (insn_has_ll_or_sc(insn)) {
-		pr_notice("Kprobes for ll and sc instructions are not"
-			  "supported\n");
+		pr_notice("Kprobes for ll and sc instructions are not supported\n");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -219,7 +220,7 @@ static int evaluate_branch_instruction(struct kprobe *p, struct pt_regs *regs,
 	return 0;
 
 unaligned:
-	pr_notice("%s: unaligned epc - sending SIGBUS.\n", current->comm);
+	pr_notice("Failed to emulate branch instruction because of unaligned epc - sending SIGBUS to %s.\n", current->comm);
 	force_sig(SIGBUS);
 	return -EFAULT;
 
@@ -238,10 +239,8 @@ static void prepare_singlestep(struct kprobe *p, struct pt_regs *regs,
 		regs->cp0_epc = (unsigned long)p->addr;
 	else if (insn_has_delayslot(p->opcode)) {
 		ret = evaluate_branch_instruction(p, regs, kcb);
-		if (ret < 0) {
-			pr_notice("Kprobes: Error in evaluating branch\n");
+		if (ret < 0)
 			return;
-		}
 	}
 	regs->cp0_epc = (unsigned long)&p->ainsn.insn[0];
 }
diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index 125241ce82d6a..b53aa0209e079 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0+
 
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/kprobes.h>
 #include <linux/extable.h>
 #include <linux/slab.h>
@@ -65,11 +67,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
 	unsigned long probe_addr = (unsigned long)p->addr;
 
-	if (probe_addr & 0x1) {
-		pr_warn("Address not aligned.\n");
-
-		return -EINVAL;
-	}
+	if (probe_addr & 0x1)
+		return -EILSEQ;
 
 	if (!arch_check_kprobe(p))
 		return -EILSEQ;
@@ -209,7 +208,7 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 		break;
 	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
-		pr_warn("Unrecoverable kprobe detected.\n");
+		pr_warn("Failed to recover from reentered kprobes.\n");
 		dump_kprobe(p);
 		BUG();
 		break;
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 52d056a5f89fc..952d44b0610b0 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -7,6 +7,8 @@
  * s390 port, used ppc64 as template. Mike Grundy <grundym@us.ibm.com>
  */
 
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/moduleloader.h>
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
@@ -259,7 +261,7 @@ static void kprobe_reenter_check(struct kprobe_ctlblk *kcb, struct kprobe *p)
 		 * is a BUG. The code path resides in the .kprobes.text
 		 * section and is executed with interrupts disabled.
 		 */
-		pr_err("Invalid kprobe detected.\n");
+		pr_err("Failed to recover from reentered kprobes.\n");
 		dump_kprobe(p);
 		BUG();
 	}
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 23af2f8e8563e..8818f3a89fef3 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -18,6 +18,9 @@
  *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  */
+
+#define pr_fmt(fmt) "kprobes: " fmt
+
 #include <linux/kprobes.h>
 #include <linux/hash.h>
 #include <linux/init.h>
@@ -892,7 +895,7 @@ static void optimize_all_kprobes(void)
 				optimize_kprobe(p);
 	}
 	cpus_read_unlock();
-	printk(KERN_INFO "Kprobes globally optimized\n");
+	pr_info("kprobe jump-optimization is enabled. All kprobes are optimized if possible.\n");
 out:
 	mutex_unlock(&kprobe_mutex);
 }
@@ -925,7 +928,7 @@ static void unoptimize_all_kprobes(void)
 
 	/* Wait for unoptimizing completion */
 	wait_for_kprobe_optimizer();
-	printk(KERN_INFO "Kprobes globally unoptimized\n");
+	pr_info("kprobe jump-optimization is disabled. All kprobes are based on software breakpoint.\n");
 }
 
 static DEFINE_MUTEX(kprobe_sysctl_mutex);
@@ -1003,7 +1006,7 @@ static int reuse_unused_kprobe(struct kprobe *ap)
 	 * unregistered.
 	 * Thus there should be no chance to reuse unused kprobe.
 	 */
-	printk(KERN_ERR "Error: There should be no unused kprobe here.\n");
+	WARN_ON_ONCE(1);
 	return -EINVAL;
 }
 
@@ -1049,18 +1052,13 @@ static int __arm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
 	int ret = 0;
 
 	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 0, 0);
-	if (ret) {
-		pr_debug("Failed to arm kprobe-ftrace at %pS (%d)\n",
-			 p->addr, ret);
+	if (WARN_ONCE(ret < 0, "Failed to arm kprobe-ftrace at %pS (error %d)\n", p->addr, ret))
 		return ret;
-	}
 
 	if (*cnt == 0) {
 		ret = register_ftrace_function(ops);
-		if (ret) {
-			pr_debug("Failed to init kprobe-ftrace (%d)\n", ret);
+		if (WARN(ret < 0, "Failed to register kprobe-ftrace (error %d)\n", ret))
 			goto err_ftrace;
-		}
 	}
 
 	(*cnt)++;
@@ -1092,14 +1090,14 @@ static int __disarm_kprobe_ftrace(struct kprobe *p, struct ftrace_ops *ops,
 
 	if (*cnt == 1) {
 		ret = unregister_ftrace_function(ops);
-		if (WARN(ret < 0, "Failed to unregister kprobe-ftrace (%d)\n", ret))
+		if (WARN(ret < 0, "Failed to unregister kprobe-ftrace (error %d)\n", ret))
 			return ret;
 	}
 
 	(*cnt)--;
 
 	ret = ftrace_set_filter_ip(ops, (unsigned long)p->addr, 1, 0);
-	WARN_ONCE(ret < 0, "Failed to disarm kprobe-ftrace at %pS (%d)\n",
+	WARN_ONCE(ret < 0, "Failed to disarm kprobe-ftrace at %pS (error %d)\n",
 		  p->addr, ret);
 	return ret;
 }
@@ -1894,7 +1892,7 @@ unsigned long __kretprobe_trampoline_handler(struct pt_regs *regs,
 
 		node = node->next;
 	}
-	pr_err("Oops! Kretprobe fails to find correct return address.\n");
+	pr_err("kretprobe: Return address not found, not execute handler. Maybe there is a bug in the kernel.\n");
 	BUG_ON(1);
 
 found:
@@ -2229,8 +2227,7 @@ EXPORT_SYMBOL_GPL(enable_kprobe);
 /* Caller must NOT call this in usual path. This is only for critical case */
 void dump_kprobe(struct kprobe *kp)
 {
-	pr_err("Dumping kprobe:\n");
-	pr_err("Name: %s\nOffset: %x\nAddress: %pS\n",
+	pr_err("Dump kprobe:\n.symbol_name = %s, .offset = %x, .addr = %pS\n",
 	       kp->symbol_name, kp->offset, kp->addr);
 }
 NOKPROBE_SYMBOL(dump_kprobe);
@@ -2493,8 +2490,7 @@ static int __init init_kprobes(void)
 	err = populate_kprobe_blacklist(__start_kprobe_blacklist,
 					__stop_kprobe_blacklist);
 	if (err) {
-		pr_err("kprobes: failed to populate blacklist: %d\n", err);
-		pr_err("Please take care of using kprobes.\n");
+		pr_err("Failed to populate blacklist (error %d), kprobes not restricted, be careful using them!\n", err);
 	}
 
 	if (kretprobe_blacklist_size) {
@@ -2503,7 +2499,7 @@ static int __init init_kprobes(void)
 			kretprobe_blacklist[i].addr =
 				kprobe_lookup_name(kretprobe_blacklist[i].name, 0);
 			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
+				pr_err("Failed to lookup symbol '%s' for kretprobe blacklist. Maybe the target function is removed or renamed.\n",
 				       kretprobe_blacklist[i].name);
 		}
 	}
@@ -2707,7 +2703,7 @@ static int arm_all_kprobes(void)
 	}
 
 	if (errors)
-		pr_warn("Kprobes globally enabled, but failed to arm %d out of %d probes\n",
+		pr_warn("Kprobes globally enabled, but failed to enable %d out of %d probes. Please check which kprobes are kept disabled via debugfs.\n",
 			errors, total);
 	else
 		pr_info("Kprobes globally enabled\n");
@@ -2750,7 +2746,7 @@ static int disarm_all_kprobes(void)
 	}
 
 	if (errors)
-		pr_warn("Kprobes globally disabled, but failed to disarm %d out of %d probes\n",
+		pr_warn("Kprobes globally disabled, but failed to disable %d out of %d probes. Please check which kprobes are kept enabled via debugfs.\n",
 			errors, total);
 	else
 		pr_info("Kprobes globally disabled\n");
-- 
2.39.0




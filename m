Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CB86130E7
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJaHDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJaHCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FD5BE25
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CE4EB810B9
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36BBC433D6;
        Mon, 31 Oct 2022 07:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199771;
        bh=ne9e3QvC+vsQD3JNmfmN44cJI1CfYzUDCkrW2jDwPbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzydwUzuz11uRr5B7KokTXaVMJoQbkZvjvJ7EZEcQ7IWojCDgFrP8NlpicCA0YbSF
         jjVFepa+aveQ6e7cK18CLUuizk8WApkNSoOpro+w7IKUms4WAG6rA6uGp/xgQDg1Sg
         3QRxX6WYr2zYWNAMsgVN20oa4RVATwXrPAgAamfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Chen <tim.c.chen@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 4.14 17/34] entel_idle: Disable IBRS during long idle
Date:   Mon, 31 Oct 2022 08:02:50 +0100
Message-Id: <20221031070140.518016714@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit bf5835bcdb9635c97f85120dba9bfa21e111130f upstream.

Having IBRS enabled while the SMT sibling is idle unnecessarily slows
down the running sibling. OTOH, disabling IBRS around idle takes two
MSR writes, which will increase the idle latency.

Therefore, only disable IBRS around deeper idle states. Shallow idle
states are bounded by the tick in duration, since NOHZ is not allowed
for them by virtue of their short target residency.

Only do this for mwait-driven idle, since that keeps interrupts disabled
across idle, which makes disabling IBRS vs IRQ-entry a non-issue.

Note: C6 is a random threshold, most importantly C1 probably shouldn't
disable IBRS, benchmarking needed.

Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: no CPUIDLE_FLAG_IRQ_ENABLE]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust context ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    1 
 arch/x86/kernel/cpu/bugs.c           |    6 ++++
 drivers/idle/intel_idle.c            |   45 ++++++++++++++++++++++++++++++-----
 3 files changed, 46 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -293,6 +293,7 @@ static inline void indirect_branch_predi
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 extern void write_spec_ctrl_current(u64 val, bool force);
+extern u64 spec_ctrl_current(void);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -77,6 +77,12 @@ void write_spec_ctrl_current(u64 val, bo
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
+u64 spec_ctrl_current(void)
+{
+	return this_cpu_read(x86_spec_ctrl_current);
+}
+EXPORT_SYMBOL_GPL(spec_ctrl_current);
+
 /*
  * The vendor and possibly platform specific bits which can be modified in
  * x86_spec_ctrl_base.
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -58,11 +58,13 @@
 #include <linux/tick.h>
 #include <trace/events/power.h>
 #include <linux/sched.h>
+#include <linux/sched/smt.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/nospec-branch.h>
 #include <asm/mwait.h>
 #include <asm/msr.h>
 
@@ -97,6 +99,8 @@ static const struct idle_cpu *icpu;
 static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
 static int intel_idle(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv, int index);
+static int intel_idle_ibrs(struct cpuidle_device *dev,
+			   struct cpuidle_driver *drv, int index);
 static void intel_idle_s2idle(struct cpuidle_device *dev,
 			      struct cpuidle_driver *drv, int index);
 static struct cpuidle_state *cpuidle_state_table;
@@ -110,6 +114,12 @@ static struct cpuidle_state *cpuidle_sta
 #define CPUIDLE_FLAG_TLB_FLUSHED	0x10000
 
 /*
+ * Disable IBRS across idle (when KERNEL_IBRS), is exclusive vs IRQ_ENABLE
+ * above.
+ */
+#define CPUIDLE_FLAG_IBRS		BIT(16)
+
+/*
  * MWAIT takes an 8-bit "hint" in EAX "suggesting"
  * the C-state (top nibble) and sub-state (bottom nibble)
  * 0x00 means "MWAIT(C1)", 0x10 means "MWAIT(C2)" etc.
@@ -617,7 +627,7 @@ static struct cpuidle_state skl_cstates[
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 85,
 		.target_residency = 200,
 		.enter = &intel_idle,
@@ -625,7 +635,7 @@ static struct cpuidle_state skl_cstates[
 	{
 		.name = "C7s",
 		.desc = "MWAIT 0x33",
-		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 124,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -633,7 +643,7 @@ static struct cpuidle_state skl_cstates[
 	{
 		.name = "C8",
 		.desc = "MWAIT 0x40",
-		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 200,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -641,7 +651,7 @@ static struct cpuidle_state skl_cstates[
 	{
 		.name = "C9",
 		.desc = "MWAIT 0x50",
-		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 480,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -649,7 +659,7 @@ static struct cpuidle_state skl_cstates[
 	{
 		.name = "C10",
 		.desc = "MWAIT 0x60",
-		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 890,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -678,7 +688,7 @@ static struct cpuidle_state skx_cstates[
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 133,
 		.target_residency = 600,
 		.enter = &intel_idle,
@@ -935,6 +945,24 @@ static __cpuidle int intel_idle(struct c
 	return index;
 }
 
+static __cpuidle int intel_idle_ibrs(struct cpuidle_device *dev,
+				     struct cpuidle_driver *drv, int index)
+{
+	bool smt_active = sched_smt_active();
+	u64 spec_ctrl = spec_ctrl_current();
+	int ret;
+
+	if (smt_active)
+		wrmsrl(MSR_IA32_SPEC_CTRL, 0);
+
+	ret = intel_idle(dev, drv, index);
+
+	if (smt_active)
+		wrmsrl(MSR_IA32_SPEC_CTRL, spec_ctrl);
+
+	return ret;
+}
+
 /**
  * intel_idle_s2idle - simplified "enter" callback routine for suspend-to-idle
  * @dev: cpuidle_device
@@ -1375,6 +1403,11 @@ static void __init intel_idle_cpuidle_dr
 			mark_tsc_unstable("TSC halts in idle"
 					" states deeper than C2");
 
+		if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) &&
+		    cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_IBRS) {
+			drv->states[drv->state_count].enter = intel_idle_ibrs;
+		}
+
 		drv->states[drv->state_count] =	/* structure copy */
 			cpuidle_state_table[cstate];
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E3E1F9880
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgFON2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730494AbgFON2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:28:07 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC1FC05BD1E;
        Mon, 15 Jun 2020 06:28:07 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jkp9I-0002KJ-AK; Mon, 15 Jun 2020 15:27:40 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B24891C00ED;
        Mon, 15 Jun 2020 15:27:39 +0200 (CEST)
Date:   Mon, 15 Jun 2020 13:27:39 -0000
From:   "tip-bot2 for Sean Christopherson" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP
 during wakeup
Cc:     Brad Campbell <lists2009@fnarfbargle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Liam Merwick <liam.merwick@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v5.6@tip-bot2.tec.linutronix.de,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200608174134.11157-1-sean.j.christopherson@intel.com>
References: <20200608174134.11157-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Message-ID: <159222765946.16989.1225221254196496903.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     5d5103595e9e53048bb7e70ee2673c897ab38300
Gitweb:        https://git.kernel.org/tip/5d5103595e9e53048bb7e70ee2673c897ab38300
Author:        Sean Christopherson <sean.j.christopherson@intel.com>
AuthorDate:    Mon, 08 Jun 2020 10:41:34 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 15 Jun 2020 14:18:37 +02:00

x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup

Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the case
where firmware doesn't initialize or save/restore across S3.  This fixes
a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.

Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already deals
with the case where the MSR is locked, and because APs already redo
init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow being
used to reinitialize APs upon wakeup.  Do the call in the early wakeup
flow to avoid dependencies in the syscore_ops chain, e.g. simply adding
a resume hook is not guaranteed to work, as KVM does VMXON in its own
resume hook, kvm_resume(), when KVM has active guests.

Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR")
Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Brad Campbell <lists2009@fnarfbargle.com>
Cc: stable@vger.kernel.org # v5.6
Link: https://lkml.kernel.org/r/20200608174134.11157-1-sean.j.christopherson@intel.com
---
 arch/x86/include/asm/cpu.h    | 5 +++++
 arch/x86/kernel/cpu/centaur.c | 1 +
 arch/x86/kernel/cpu/cpu.h     | 4 ----
 arch/x86/kernel/cpu/zhaoxin.c | 1 +
 arch/x86/power/cpu.c          | 6 ++++++
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index dd17c2d..da78ccb 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -58,4 +58,9 @@ static inline bool handle_guest_split_lock(unsigned long ip)
 	return false;
 }
 #endif
+#ifdef CONFIG_IA32_FEAT_CTL
+void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
+#else
+static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
+#endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 4267925..c5cf336 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -3,6 +3,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/e820/api.h>
 #include <asm/mtrr.h>
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index fb538fc..9d03369 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -81,8 +81,4 @@ extern void update_srbds_msr(void);
 
 extern u64 x86_read_arch_cap_msr(void);
 
-#ifdef CONFIG_IA32_FEAT_CTL
-void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
-#endif
-
 #endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index df1358b..05fa4ef 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 
 #include "cpu.h"
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 7c65102..db1378c 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -193,6 +193,8 @@ static void fix_processor_context(void)
  */
 static void notrace __restore_processor_state(struct saved_context *ctxt)
 {
+	struct cpuinfo_x86 *c;
+
 	if (ctxt->misc_enable_saved)
 		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
 	/*
@@ -263,6 +265,10 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	mtrr_bp_restore();
 	perf_restore_debug_store();
 	msr_restore_context(ctxt);
+
+	c = &cpu_data(smp_processor_id());
+	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
+		init_ia32_feat_ctl(c);
 }
 
 /* Needed by apm.c */

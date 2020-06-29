Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36F420E7E9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391759AbgF2WAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B8CD247A1;
        Mon, 29 Jun 2020 15:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444109;
        bh=jtQ9krYpw0F1Pk4uWyQOXj1u1Ae2KuvA8Ghy1N/XZJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2YMD96Jd6Md7ies4Y/qzqLqjImq0bTdOxBToPh4rPcxRVHbT9v9VLLNQJ0gVB99+
         TpvevKXhgAxgGlpQOTisMEZuKFd0gPnXGuzJ9rNgRjBgB0YCVDATtBOFWmK5ItRE33
         O2Qyd6SaI6/gv0bawDh44Z+ue+EQb3kxHF8QqEgA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Borislav Petkov <bp@suse.de>,
        Liam Merwick <liam.merwick@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 220/265] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup
Date:   Mon, 29 Jun 2020 11:17:33 -0400
Message-Id: <20200629151818.2493727-221-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 5d5103595e9e53048bb7e70ee2673c897ab38300 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpu.h    | 5 +++++
 arch/x86/kernel/cpu/centaur.c | 1 +
 arch/x86/kernel/cpu/cpu.h     | 4 ----
 arch/x86/kernel/cpu/zhaoxin.c | 1 +
 arch/x86/power/cpu.c          | 6 ++++++
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index dd17c2da1af5f..da78ccbd493b7 100644
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
index 426792565d864..c5cf336e50776 100644
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
index fb538fccd24c0..9d033693519aa 100644
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
index df1358ba622bd..05fa4ef634902 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 
 #include "cpu.h"
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index aaff9ed7ff45c..b0d3c5ca6d807 100644
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
-- 
2.25.1


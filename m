Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2711220BE9
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfEPQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43400 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727167AbfEPP6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:51 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImM-0006zL-RO; Thu, 16 May 2019 16:58:47 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001PX-Nz; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Jon Masters" <jcm@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.405536839@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 40/86] x86/speculation: Reorganize speculation
 control MSRs update
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Chen <tim.c.chen@linux.intel.com>

commit 01daf56875ee0cd50ed496a09b20eb369b45dfa5 upstream.

The logic to detect whether there's a change in the previous and next
task's flag relevant to update speculation control MSRs is spread out
across multiple functions.

Consolidate all checks needed for updating speculation control MSRs into
the new __speculation_ctrl_update() helper function.

This makes it easy to pick the right speculation control MSR and the bits
in MSR_IA32_SPEC_CTRL that need updating based on TIF flags changes.

Originally-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185004.151077005@linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/process.c | 46 ++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -335,27 +335,40 @@ static __always_inline void amd_set_ssb_
 	wrmsrl(MSR_AMD64_VIRT_SPEC_CTRL, ssbd_tif_to_spec_ctrl(tifn));
 }
 
-static __always_inline void spec_ctrl_update_msr(unsigned long tifn)
+/*
+ * Update the MSRs managing speculation control, during context switch.
+ *
+ * tifp: Previous task's thread flags
+ * tifn: Next task's thread flags
+ */
+static __always_inline void __speculation_ctrl_update(unsigned long tifp,
+						      unsigned long tifn)
 {
-	u64 msr = x86_spec_ctrl_base | ssbd_tif_to_spec_ctrl(tifn);
+	u64 msr = x86_spec_ctrl_base;
+	bool updmsr = false;
 
-	wrmsrl(MSR_IA32_SPEC_CTRL, msr);
-}
+	/* If TIF_SSBD is different, select the proper mitigation method */
+	if ((tifp ^ tifn) & _TIF_SSBD) {
+		if (static_cpu_has(X86_FEATURE_VIRT_SSBD)) {
+			amd_set_ssb_virt_state(tifn);
+		} else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD)) {
+			amd_set_core_ssb_state(tifn);
+		} else if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+			   static_cpu_has(X86_FEATURE_AMD_SSBD)) {
+			msr |= ssbd_tif_to_spec_ctrl(tifn);
+			updmsr  = true;
+		}
+	}
 
-static __always_inline void __speculation_ctrl_update(unsigned long tifn)
-{
-	if (static_cpu_has(X86_FEATURE_VIRT_SSBD))
-		amd_set_ssb_virt_state(tifn);
-	else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD))
-		amd_set_core_ssb_state(tifn);
-	else
-		spec_ctrl_update_msr(tifn);
+	if (updmsr)
+		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
 }
 
 void speculation_ctrl_update(unsigned long tif)
 {
+	/* Forced update. Make sure all relevant TIF flags are different */
 	preempt_disable();
-	__speculation_ctrl_update(tif);
+	__speculation_ctrl_update(~tif, tif);
 	preempt_enable();
 }
 
@@ -392,8 +405,7 @@ void __switch_to_xtra(struct task_struct
 			hard_enable_TSC();
 	}
 
-	if ((tifp ^ tifn) & _TIF_SSBD)
-		__speculation_ctrl_update(tifn);
+	__speculation_ctrl_update(tifp, tifn);
 }
 
 /*


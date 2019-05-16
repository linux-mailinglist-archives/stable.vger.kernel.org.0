Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89420C09
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfEPQBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42840 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0006zr-Nv; Thu, 16 May 2019 16:58:38 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001PS-N5; Thu, 16 May 2019 16:58:37 +0100
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
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
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
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.563712630@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 39/86] x86/speculation: Rename SSBD update functions
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 26c4d75b234040c11728a8acb796b3a85ba7507c upstream.

During context switch, the SSBD bit in SPEC_CTRL MSR is updated according
to changes of the TIF_SSBD flag in the current and next running task.

Currently, only the bit controlling speculative store bypass disable in
SPEC_CTRL MSR is updated and the related update functions all have
"speculative_store" or "ssb" in their names.

For enhanced mitigation control other bits in SPEC_CTRL MSR need to be
updated as well, which makes the SSB names inadequate.

Rename the "speculative_store*" functions to a more generic name. No
functional change.

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
Link: https://lkml.kernel.org/r/20181125185004.058866968@linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/spec-ctrl.h |  6 +++---
 arch/x86/kernel/cpu/bugs.c       |  4 ++--
 arch/x86/kernel/process.c        | 12 ++++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/spec-ctrl.h
+++ b/arch/x86/include/asm/spec-ctrl.h
@@ -70,11 +70,11 @@ extern void speculative_store_bypass_ht_
 static inline void speculative_store_bypass_ht_init(void) { }
 #endif
 
-extern void speculative_store_bypass_update(unsigned long tif);
+extern void speculation_ctrl_update(unsigned long tif);
 
-static inline void speculative_store_bypass_update_current(void)
+static inline void speculation_ctrl_update_current(void)
 {
-	speculative_store_bypass_update(current_thread_info()->flags);
+	speculation_ctrl_update(current_thread_info()->flags);
 }
 
 #endif
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -255,7 +255,7 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl,
 		tif = setguest ? ssbd_spec_ctrl_to_tif(guestval) :
 				 ssbd_spec_ctrl_to_tif(hostval);
 
-		speculative_store_bypass_update(tif);
+		speculation_ctrl_update(tif);
 	}
 }
 EXPORT_SYMBOL_GPL(x86_virt_spec_ctrl);
@@ -692,7 +692,7 @@ static int ssb_prctl_set(struct task_str
 	 * mitigation until it is next scheduled.
 	 */
 	if (task == current && update)
-		speculative_store_bypass_update_current();
+		speculation_ctrl_update_current();
 
 	return 0;
 }
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -335,27 +335,27 @@ static __always_inline void amd_set_ssb_
 	wrmsrl(MSR_AMD64_VIRT_SPEC_CTRL, ssbd_tif_to_spec_ctrl(tifn));
 }
 
-static __always_inline void intel_set_ssb_state(unsigned long tifn)
+static __always_inline void spec_ctrl_update_msr(unsigned long tifn)
 {
 	u64 msr = x86_spec_ctrl_base | ssbd_tif_to_spec_ctrl(tifn);
 
 	wrmsrl(MSR_IA32_SPEC_CTRL, msr);
 }
 
-static __always_inline void __speculative_store_bypass_update(unsigned long tifn)
+static __always_inline void __speculation_ctrl_update(unsigned long tifn)
 {
 	if (static_cpu_has(X86_FEATURE_VIRT_SSBD))
 		amd_set_ssb_virt_state(tifn);
 	else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD))
 		amd_set_core_ssb_state(tifn);
 	else
-		intel_set_ssb_state(tifn);
+		spec_ctrl_update_msr(tifn);
 }
 
-void speculative_store_bypass_update(unsigned long tif)
+void speculation_ctrl_update(unsigned long tif)
 {
 	preempt_disable();
-	__speculative_store_bypass_update(tif);
+	__speculation_ctrl_update(tif);
 	preempt_enable();
 }
 
@@ -393,7 +393,7 @@ void __switch_to_xtra(struct task_struct
 	}
 
 	if ((tifp ^ tifn) & _TIF_SSBD)
-		__speculative_store_bypass_update(tifn);
+		__speculation_ctrl_update(tifn);
 }
 
 /*


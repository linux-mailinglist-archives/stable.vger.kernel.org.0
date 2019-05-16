Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923DF20BEA
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfEPQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43326 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbfEPP6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:50 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImM-0006zU-QJ; Thu, 16 May 2019 16:58:47 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Pl-QI; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.249528149@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 43/86] x86/speculation: Rework SMT state change
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

commit a74cfffb03b73d41e08f84c2e5c87dec0ce3db9f upstream.

arch_smt_update() is only called when the sysfs SMT control knob is
changed. This means that when SMT is enabled in the sysfs control knob the
system is considered to have SMT active even if all siblings are offline.

To allow finegrained control of the speculation mitigations, the actual SMT
state is more interesting than the fact that siblings could be enabled.

Rework the code, so arch_smt_update() is invoked from each individual CPU
hotplug function, and simplify the update function while at it.

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
Cc: Tim Chen <tim.c.chen@linux.intel.com>
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
Link: https://lkml.kernel.org/r/20181125185004.521974984@linutronix.de
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 11 +++++------
 include/linux/sched/smt.h  |  2 ++
 kernel/cpu.c               | 15 +++++++++------
 3 files changed, 16 insertions(+), 12 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/nospec.h>
 #include <linux/prctl.h>
+#include <linux/sched/smt.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -403,16 +404,14 @@ void arch_smt_update(void)
 		return;
 
 	mutex_lock(&spec_ctrl_mutex);
-	mask = x86_spec_ctrl_base;
-	if (IS_ENABLED(CONFIG_X86_HT))
+
+	mask = x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
+	if (sched_smt_active())
 		mask |= SPEC_CTRL_STIBP;
-	else
-		mask &= ~SPEC_CTRL_STIBP;
 
 	if (mask != x86_spec_ctrl_base) {
 		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
-				IS_ENABLED(CONFIG_X86_HT) ?
-				"Enabling" : "Disabling");
+			mask & SPEC_CTRL_STIBP ? "Enabling" : "Disabling");
 		x86_spec_ctrl_base = mask;
 		on_each_cpu(update_stibp_msr, NULL, 1);
 	}
--- a/include/linux/sched/smt.h
+++ b/include/linux/sched/smt.h
@@ -15,4 +15,6 @@ static __always_inline bool sched_smt_ac
 static inline bool sched_smt_active(void) { return false; }
 #endif
 
+void arch_smt_update(void);
+
 #endif
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
+#include <linux/sched/smt.h>
 #include <linux/unistd.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
@@ -179,6 +180,12 @@ void cpu_hotplug_enable(void)
 
 #endif	/* CONFIG_HOTPLUG_CPU */
 
+/*
+ * Architectures that need SMT-specific errata handling during SMT hotplug
+ * should override this.
+ */
+void __weak arch_smt_update(void) { }
+
 /* Need to know about CPUs going up/down? */
 int __ref register_cpu_notifier(struct notifier_block *nb)
 {
@@ -394,6 +401,7 @@ out_release:
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+	arch_smt_update();
 	return err;
 }
 
@@ -495,7 +503,7 @@ out_notify:
 		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 out:
 	cpu_hotplug_done();
-
+	arch_smt_update();
 	return ret;
 }
 


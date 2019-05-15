Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6371F264
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfEOMDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729787AbfEOLMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1FD216FD;
        Wed, 15 May 2019 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918750;
        bh=IkVquPmi2ENgpVsO/PiNee7bREyvEPL0sBJQjUPvmto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pf/be454uTJ++mMblqSN2INmpUWeM6oIuw+EW0xztKTK/rEIeT+YX6VvEZVtbDgKm
         Dtqn703ioLzR1zGWM1bhiSLXMw5qSxpkDJcAsYOG3h+T759fswWR77U/ET3AmfS9JY
         MqqEBElecJnkNBttPRqd50EvRkjl2KbHNqvRkAHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Dave Stewart <david.c.stewart@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 210/266] x86/speculation: Rework SMT state change
Date:   Wed, 15 May 2019 12:55:17 +0200
Message-Id: <20190515090730.071222249@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   11 +++++------
 include/linux/sched/smt.h  |    2 ++
 kernel/cpu.c               |   10 +++++++++-
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/nospec.h>
 #include <linux/prctl.h>
+#include <linux/sched/smt.h>
 
 #include <asm/spec-ctrl.h>
 #include <asm/cmdline.h>
@@ -340,16 +341,14 @@ void arch_smt_update(void)
 		return;
 
 	mutex_lock(&spec_ctrl_mutex);
-	mask = x86_spec_ctrl_base;
-	if (IS_ENABLED(CONFIG_SMP))
+
+	mask = x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
+	if (sched_smt_active())
 		mask |= SPEC_CTRL_STIBP;
-	else
-		mask &= ~SPEC_CTRL_STIBP;
 
 	if (mask != x86_spec_ctrl_base) {
 		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
-				IS_ENABLED(CONFIG_SMP) ?
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
@@ -199,6 +200,12 @@ void cpu_hotplug_enable(void)
 EXPORT_SYMBOL_GPL(cpu_hotplug_enable);
 #endif	/* CONFIG_HOTPLUG_CPU */
 
+/*
+ * Architectures that need SMT-specific errata handling during SMT hotplug
+ * should override this.
+ */
+void __weak arch_smt_update(void) { }
+
 /* Need to know about CPUs going up/down? */
 int register_cpu_notifier(struct notifier_block *nb)
 {
@@ -434,6 +441,7 @@ out_release:
 	cpu_hotplug_done();
 	if (!err)
 		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
+	arch_smt_update();
 	return err;
 }
 
@@ -537,7 +545,7 @@ out_notify:
 		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 out:
 	cpu_hotplug_done();
-
+	arch_smt_update();
 	return ret;
 }
 



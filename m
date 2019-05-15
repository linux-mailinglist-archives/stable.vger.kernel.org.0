Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C81F296
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfEOMFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfEOLLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 824F52084E;
        Wed, 15 May 2019 11:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918675;
        bh=ljqYy/Z9kslG+EL17A7e1VuFNCzcXOpz/hNK9vQqN4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PZdUtnkGqwEn977jz/63jrBz2xpjDWAaAMcUGbRuPhUXY5MxDWqVGScsUm3LcvRS
         hBb95l56JKl8lwgfLkhJtjYLCP5M+AsRZEqM09Aca+ovKgXUIvOatp1aXNgl30Fw/e
         b8WgwFYq55JwKsRbUoTOVSYQ4lL3mUXJY2B58kJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
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
Subject: [PATCH 4.4 223/266] x86/speculation: Add prctl() control for indirect branch speculation
Date:   Wed, 15 May 2019 12:55:30 +0200
Message-Id: <20190515090730.539243783@linuxfoundation.org>
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

commit 9137bb27e60e554dab694eafa4cca241fa3a694f upstream.

Add the PR_SPEC_INDIRECT_BRANCH option for the PR_GET_SPECULATION_CTRL and
PR_SET_SPECULATION_CTRL prctls to allow fine grained per task control of
indirect branch speculation via STIBP and IBPB.

Invocations:
 Check indirect branch speculation status with
 - prctl(PR_GET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, 0, 0, 0);

 Enable indirect branch speculation with
 - prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_ENABLE, 0, 0);

 Disable indirect branch speculation with
 - prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_DISABLE, 0, 0);

 Force disable indirect branch speculation with
 - prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_FORCE_DISABLE, 0, 0);

See Documentation/userspace-api/spec_ctrl.rst.

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
Link: https://lkml.kernel.org/r/20181125185005.866780996@linutronix.de
[bwh: Backported to 4.4:
 - Renumber the PFA flags
 - Drop changes in tools/include/uapi/linux/prctl.h
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/spec_ctrl.txt          |    9 ++++
 arch/x86/include/asm/nospec-branch.h |    1 
 arch/x86/kernel/cpu/bugs.c           |   67 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process.c            |    5 ++
 include/linux/sched.h                |    9 ++++
 include/uapi/linux/prctl.h           |    1 
 6 files changed, 92 insertions(+)

--- a/Documentation/spec_ctrl.txt
+++ b/Documentation/spec_ctrl.txt
@@ -92,3 +92,12 @@ Speculation misfeature controls
    * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_STORE_BYPASS, PR_SPEC_ENABLE, 0, 0);
    * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_STORE_BYPASS, PR_SPEC_DISABLE, 0, 0);
    * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_STORE_BYPASS, PR_SPEC_FORCE_DISABLE, 0, 0);
+
+- PR_SPEC_INDIR_BRANCH: Indirect Branch Speculation in User Processes
+                        (Mitigate Spectre V2 style attacks against user processes)
+
+  Invocations:
+   * prctl(PR_GET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, 0, 0, 0);
+   * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_ENABLE, 0, 0);
+   * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_DISABLE, 0, 0);
+   * prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, PR_SPEC_FORCE_DISABLE, 0, 0);
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -178,6 +178,7 @@ enum spectre_v2_mitigation {
 enum spectre_v2_user_mitigation {
 	SPECTRE_V2_USER_NONE,
 	SPECTRE_V2_USER_STRICT,
+	SPECTRE_V2_USER_PRCTL,
 };
 
 /* The Speculative Store Bypass disable variants */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -561,6 +561,8 @@ void arch_smt_update(void)
 	case SPECTRE_V2_USER_STRICT:
 		update_stibp_strict();
 		break;
+	case SPECTRE_V2_USER_PRCTL:
+		break;
 	}
 
 	mutex_unlock(&spec_ctrl_mutex);
@@ -747,12 +749,50 @@ static int ssb_prctl_set(struct task_str
 	return 0;
 }
 
+static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
+{
+	switch (ctrl) {
+	case PR_SPEC_ENABLE:
+		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
+			return 0;
+		/*
+		 * Indirect branch speculation is always disabled in strict
+		 * mode.
+		 */
+		if (spectre_v2_user == SPECTRE_V2_USER_STRICT)
+			return -EPERM;
+		task_clear_spec_ib_disable(task);
+		task_update_spec_tif(task);
+		break;
+	case PR_SPEC_DISABLE:
+	case PR_SPEC_FORCE_DISABLE:
+		/*
+		 * Indirect branch speculation is always allowed when
+		 * mitigation is force disabled.
+		 */
+		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
+			return -EPERM;
+		if (spectre_v2_user == SPECTRE_V2_USER_STRICT)
+			return 0;
+		task_set_spec_ib_disable(task);
+		if (ctrl == PR_SPEC_FORCE_DISABLE)
+			task_set_spec_ib_force_disable(task);
+		task_update_spec_tif(task);
+		break;
+	default:
+		return -ERANGE;
+	}
+	return 0;
+}
+
 int arch_prctl_spec_ctrl_set(struct task_struct *task, unsigned long which,
 			     unsigned long ctrl)
 {
 	switch (which) {
 	case PR_SPEC_STORE_BYPASS:
 		return ssb_prctl_set(task, ctrl);
+	case PR_SPEC_INDIRECT_BRANCH:
+		return ib_prctl_set(task, ctrl);
 	default:
 		return -ENODEV;
 	}
@@ -785,11 +825,34 @@ static int ssb_prctl_get(struct task_str
 	}
 }
 
+static int ib_prctl_get(struct task_struct *task)
+{
+	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
+		return PR_SPEC_NOT_AFFECTED;
+
+	switch (spectre_v2_user) {
+	case SPECTRE_V2_USER_NONE:
+		return PR_SPEC_ENABLE;
+	case SPECTRE_V2_USER_PRCTL:
+		if (task_spec_ib_force_disable(task))
+			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
+		if (task_spec_ib_disable(task))
+			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
+		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
+	case SPECTRE_V2_USER_STRICT:
+		return PR_SPEC_DISABLE;
+	default:
+		return PR_SPEC_NOT_AFFECTED;
+	}
+}
+
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 {
 	switch (which) {
 	case PR_SPEC_STORE_BYPASS:
 		return ssb_prctl_get(task);
+	case PR_SPEC_INDIRECT_BRANCH:
+		return ib_prctl_get(task);
 	default:
 		return -ENODEV;
 	}
@@ -886,6 +949,8 @@ static char *stibp_state(void)
 		return ", STIBP: disabled";
 	case SPECTRE_V2_USER_STRICT:
 		return ", STIBP: forced";
+	case SPECTRE_V2_USER_PRCTL:
+		return "";
 	}
 	return "";
 }
@@ -898,6 +963,8 @@ static char *ibpb_state(void)
 			return ", IBPB: disabled";
 		case SPECTRE_V2_USER_STRICT:
 			return ", IBPB: always-on";
+		case SPECTRE_V2_USER_PRCTL:
+			return "";
 		}
 	}
 	return "";
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -372,6 +372,11 @@ static unsigned long speculation_ctrl_up
 			set_tsk_thread_flag(tsk, TIF_SSBD);
 		else
 			clear_tsk_thread_flag(tsk, TIF_SSBD);
+
+		if (task_spec_ib_disable(tsk))
+			set_tsk_thread_flag(tsk, TIF_SPEC_IB);
+		else
+			clear_tsk_thread_flag(tsk, TIF_SPEC_IB);
 	}
 	/* Return the updated threadinfo flags*/
 	return task_thread_info(tsk)->flags;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2169,6 +2169,8 @@ static inline void memalloc_noio_restore
 #define PFA_SPREAD_SLAB  2      /* Spread some slab caches over cpuset */
 #define PFA_SPEC_SSB_DISABLE		4	/* Speculative Store Bypass disabled */
 #define PFA_SPEC_SSB_FORCE_DISABLE	5	/* Speculative Store Bypass force disabled*/
+#define PFA_SPEC_IB_DISABLE		6	/* Indirect branch speculation restricted */
+#define PFA_SPEC_IB_FORCE_DISABLE	7	/* Indirect branch speculation permanently restricted */
 
 
 #define TASK_PFA_TEST(name, func)					\
@@ -2199,6 +2201,13 @@ TASK_PFA_CLEAR(SPEC_SSB_DISABLE, spec_ss
 TASK_PFA_TEST(SPEC_SSB_FORCE_DISABLE, spec_ssb_force_disable)
 TASK_PFA_SET(SPEC_SSB_FORCE_DISABLE, spec_ssb_force_disable)
 
+TASK_PFA_TEST(SPEC_IB_DISABLE, spec_ib_disable)
+TASK_PFA_SET(SPEC_IB_DISABLE, spec_ib_disable)
+TASK_PFA_CLEAR(SPEC_IB_DISABLE, spec_ib_disable)
+
+TASK_PFA_TEST(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
+TASK_PFA_SET(SPEC_IB_FORCE_DISABLE, spec_ib_force_disable)
+
 /*
  * task->jobctl flags
  */
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -202,6 +202,7 @@ struct prctl_mm_map {
 #define PR_SET_SPECULATION_CTRL		53
 /* Speculation control variants */
 # define PR_SPEC_STORE_BYPASS		0
+# define PR_SPEC_INDIRECT_BRANCH	1
 /* Return and control values for PR_SET/GET_SPECULATION_CTRL */
 # define PR_SPEC_NOT_AFFECTED		0
 # define PR_SPEC_PRCTL			(1UL << 0)



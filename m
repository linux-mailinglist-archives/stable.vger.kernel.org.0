Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2CEB20C36
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfEPQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42724 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726901AbfEPP6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:45 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zu-F0; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Qz-Am; Thu, 16 May 2019 16:58:38 +0100
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
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.518041847@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 58/86] x86/speculation: Add seccomp Spectre v2 user
 space protection mode
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

commit 6b3e64c237c072797a9ec918654a60e3a46488e2 upstream.

If 'prctl' mode of user space protection from spectre v2 is selected
on the kernel command-line, STIBP and IBPB are applied on tasks which
restrict their indirect branch speculation via prctl.

SECCOMP enables the SSBD mitigation for sandboxed tasks already, so it
makes sense to prevent spectre v2 user space to user space attacks as
well.

The Intel mitigation guide documents how STIPB works:

   Setting bit 1 (STIBP) of the IA32_SPEC_CTRL MSR on a logical processor
   prevents the predicted targets of indirect branches on any logical
   processor of that core from being controlled by software that executes
   (or executed previously) on another logical processor of the same core.

Ergo setting STIBP protects the task itself from being attacked from a task
running on a different hyper-thread and protects the tasks running on
different hyper-threads from being attacked.

While the document suggests that the branch predictors are shielded between
the logical processors, the observed performance regressions suggest that
STIBP simply disables the branch predictor more or less completely. Of
course the document wording is vague, but the fact that there is also no
requirement for issuing IBPB when STIBP is used points clearly in that
direction. The kernel still issues IBPB even when STIBP is used until Intel
clarifies the whole mechanism.

IBPB is issued when the task switches out, so malicious sandbox code cannot
mistrain the branch predictor for the next user space task on the same
logical processor.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
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
Link: https://lkml.kernel.org/r/20181125185006.051663132@linutronix.de
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt  |  9 ++++++++-
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           | 17 ++++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3223,9 +3223,16 @@ bytes respectively. Such letter suffixes
 				  per thread.  The mitigation control state
 				  is inherited on fork.
 
+			seccomp
+				- Same as "prctl" above, but all seccomp
+				  threads will enable the mitigation unless
+				  they explicitly opt out.
+
 			auto    - Kernel selects the mitigation depending on
 				  the available CPU features and vulnerability.
-				  Default is prctl.
+
+			Default mitigation:
+			If CONFIG_SECCOMP=y then "seccomp", otherwise "prctl"
 
 			Not specifying this option is equivalent to
 			spectre_v2_user=auto.
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -179,6 +179,7 @@ enum spectre_v2_user_mitigation {
 	SPECTRE_V2_USER_NONE,
 	SPECTRE_V2_USER_STRICT,
 	SPECTRE_V2_USER_PRCTL,
+	SPECTRE_V2_USER_SECCOMP,
 };
 
 /* The Speculative Store Bypass disable variants */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -308,12 +308,14 @@ enum spectre_v2_user_cmd {
 	SPECTRE_V2_USER_CMD_AUTO,
 	SPECTRE_V2_USER_CMD_FORCE,
 	SPECTRE_V2_USER_CMD_PRCTL,
+	SPECTRE_V2_USER_CMD_SECCOMP,
 };
 
 static const char * const spectre_v2_user_strings[] = {
 	[SPECTRE_V2_USER_NONE]		= "User space: Vulnerable",
 	[SPECTRE_V2_USER_STRICT]	= "User space: Mitigation: STIBP protection",
 	[SPECTRE_V2_USER_PRCTL]		= "User space: Mitigation: STIBP via prctl",
+	[SPECTRE_V2_USER_SECCOMP]	= "User space: Mitigation: STIBP via seccomp and prctl",
 };
 
 static const struct {
@@ -325,6 +327,7 @@ static const struct {
 	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
 	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
 	{ "prctl",	SPECTRE_V2_USER_CMD_PRCTL,	false },
+	{ "seccomp",	SPECTRE_V2_USER_CMD_SECCOMP,	false },
 };
 
 static void __init spec_v2_user_print_cond(const char *reason, bool secure)
@@ -383,10 +386,16 @@ spectre_v2_user_select_mitigation(enum s
 	case SPECTRE_V2_USER_CMD_FORCE:
 		mode = SPECTRE_V2_USER_STRICT;
 		break;
-	case SPECTRE_V2_USER_CMD_AUTO:
 	case SPECTRE_V2_USER_CMD_PRCTL:
 		mode = SPECTRE_V2_USER_PRCTL;
 		break;
+	case SPECTRE_V2_USER_CMD_AUTO:
+	case SPECTRE_V2_USER_CMD_SECCOMP:
+		if (IS_ENABLED(CONFIG_SECCOMP))
+			mode = SPECTRE_V2_USER_SECCOMP;
+		else
+			mode = SPECTRE_V2_USER_PRCTL;
+		break;
 	}
 
 	/* Initialize Indirect Branch Prediction Barrier */
@@ -398,6 +407,7 @@ spectre_v2_user_select_mitigation(enum s
 			static_branch_enable(&switch_mm_always_ibpb);
 			break;
 		case SPECTRE_V2_USER_PRCTL:
+		case SPECTRE_V2_USER_SECCOMP:
 			static_branch_enable(&switch_mm_cond_ibpb);
 			break;
 		default:
@@ -649,6 +659,7 @@ void arch_smt_update(void)
 		update_stibp_strict();
 		break;
 	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
 		update_indir_branch_cond();
 		break;
 	}
@@ -891,6 +902,8 @@ void arch_seccomp_spec_mitigate(struct t
 {
 	if (ssb_mode == SPEC_STORE_BYPASS_SECCOMP)
 		ssb_prctl_set(task, PR_SPEC_FORCE_DISABLE);
+	if (spectre_v2_user == SPECTRE_V2_USER_SECCOMP)
+		ib_prctl_set(task, PR_SPEC_FORCE_DISABLE);
 }
 #endif
 
@@ -922,6 +935,7 @@ static int ib_prctl_get(struct task_stru
 	case SPECTRE_V2_USER_NONE:
 		return PR_SPEC_ENABLE;
 	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
 		if (task_spec_ib_force_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
 		if (task_spec_ib_disable(task))
@@ -1037,6 +1051,7 @@ static char *stibp_state(void)
 	case SPECTRE_V2_USER_STRICT:
 		return ", STIBP: forced";
 	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
 		if (static_key_enabled(&switch_to_cond_stibp))
 			return ", STIBP: conditional";
 	}


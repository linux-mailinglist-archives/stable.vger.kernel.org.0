Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0551F280
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbfEOLLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbfEOLLX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE55420644;
        Wed, 15 May 2019 11:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918682;
        bh=Qb4qIwvhSifkqHSWaarVNQNRIDxQgVLbsHuAewCk//c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLvJRt93yQIWa1Di07ID+QIF1cQl6ErwCOEm8hofTok93AOj4nDqBK6EnaoWX1nNc
         /BPTRt5nnHKHAItA0vHU+L5tXPy7qQtwCnYTQvK/a932wXVmcgBAbt/oVjxsrB3ySM
         IFPAdIzMEwcJQI/OxFga694msQ3WKYN+QSmzYTGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: [PATCH 4.4 225/266] x86/speculation: Add seccomp Spectre v2 user space protection mode
Date:   Wed, 15 May 2019 12:55:32 +0200
Message-Id: <20190515090730.608765884@linuxfoundation.org>
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
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt  |    9 ++++++++-
 arch/x86/include/asm/nospec-branch.h |    1 +
 arch/x86/kernel/cpu/bugs.c           |   17 ++++++++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3651,9 +3651,16 @@ bytes respectively. Such letter suffixes
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
@@ -245,12 +245,14 @@ enum spectre_v2_user_cmd {
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
@@ -262,6 +264,7 @@ static const struct {
 	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
 	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
 	{ "prctl",	SPECTRE_V2_USER_CMD_PRCTL,	false },
+	{ "seccomp",	SPECTRE_V2_USER_CMD_SECCOMP,	false },
 };
 
 static void __init spec_v2_user_print_cond(const char *reason, bool secure)
@@ -320,10 +323,16 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -335,6 +344,7 @@ spectre_v2_user_select_mitigation(enum s
 			static_branch_enable(&switch_mm_always_ibpb);
 			break;
 		case SPECTRE_V2_USER_PRCTL:
+		case SPECTRE_V2_USER_SECCOMP:
 			static_branch_enable(&switch_mm_cond_ibpb);
 			break;
 		default:
@@ -586,6 +596,7 @@ void arch_smt_update(void)
 		update_stibp_strict();
 		break;
 	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
 		update_indir_branch_cond();
 		break;
 	}
@@ -828,6 +839,8 @@ void arch_seccomp_spec_mitigate(struct t
 {
 	if (ssb_mode == SPEC_STORE_BYPASS_SECCOMP)
 		ssb_prctl_set(task, PR_SPEC_FORCE_DISABLE);
+	if (spectre_v2_user == SPECTRE_V2_USER_SECCOMP)
+		ib_prctl_set(task, PR_SPEC_FORCE_DISABLE);
 }
 #endif
 
@@ -859,6 +872,7 @@ static int ib_prctl_get(struct task_stru
 	case SPECTRE_V2_USER_NONE:
 		return PR_SPEC_ENABLE;
 	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
 		if (task_spec_ib_force_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
 		if (task_spec_ib_disable(task))
@@ -975,6 +989,7 @@ static char *stibp_state(void)
 	case SPECTRE_V2_USER_STRICT:
 		return ", STIBP: forced";
 	case SPECTRE_V2_USER_PRCTL:
+	case SPECTRE_V2_USER_SECCOMP:
 		if (static_key_enabled(&switch_to_cond_stibp))
 			return ", STIBP: conditional";
 	}



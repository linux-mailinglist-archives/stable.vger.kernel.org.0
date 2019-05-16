Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1020C4C
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfEPQDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:03:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42528 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbfEPP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:43 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImG-0006zS-RJ; Thu, 16 May 2019 16:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001Qu-9M; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.26224445@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 57/86] x86/speculation: Enable prctl mode for
 spectre_v2_user
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

commit 7cc765a67d8e04ef7d772425ca5a2a1e2b894c15 upstream.

Now that all prerequisites are in place:

 - Add the prctl command line option

 - Default the 'auto' mode to 'prctl'

 - When SMT state changes, update the static key which controls the
   conditional STIBP evaluation on context switch.

 - At init update the static key which controls the conditional IBPB
   evaluation on context switch.

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
Link: https://lkml.kernel.org/r/20181125185005.958421388@linutronix.de
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Docuemntation/kernel-parameters.txt |  7 +++-
 arch/x86/kernel/cpu/bugs.c          | 41 +++++++++++++++----
 2 files changed, 38 insertions(+), 10 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3218,9 +3218,14 @@ bytes respectively. Such letter suffixes
 			off     - Unconditionally disable mitigations. Is
 				  enforced by spectre_v2=off
 
+			prctl   - Indirect branch speculation is enabled,
+				  but mitigation can be enabled via prctl
+				  per thread.  The mitigation control state
+				  is inherited on fork.
+
 			auto    - Kernel selects the mitigation depending on
 				  the available CPU features and vulnerability.
-				  Default is off.
+				  Default is prctl.
 
 			Not specifying this option is equivalent to
 			spectre_v2_user=auto.
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -307,11 +307,13 @@ enum spectre_v2_user_cmd {
 	SPECTRE_V2_USER_CMD_NONE,
 	SPECTRE_V2_USER_CMD_AUTO,
 	SPECTRE_V2_USER_CMD_FORCE,
+	SPECTRE_V2_USER_CMD_PRCTL,
 };
 
 static const char * const spectre_v2_user_strings[] = {
 	[SPECTRE_V2_USER_NONE]		= "User space: Vulnerable",
 	[SPECTRE_V2_USER_STRICT]	= "User space: Mitigation: STIBP protection",
+	[SPECTRE_V2_USER_PRCTL]		= "User space: Mitigation: STIBP via prctl",
 };
 
 static const struct {
@@ -322,6 +324,7 @@ static const struct {
 	{ "auto",	SPECTRE_V2_USER_CMD_AUTO,	false },
 	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
 	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
+	{ "prctl",	SPECTRE_V2_USER_CMD_PRCTL,	false },
 };
 
 static void __init spec_v2_user_print_cond(const char *reason, bool secure)
@@ -375,12 +378,15 @@ spectre_v2_user_select_mitigation(enum s
 		smt_possible = false;
 
 	switch (spectre_v2_parse_user_cmdline(v2_cmd)) {
-	case SPECTRE_V2_USER_CMD_AUTO:
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
 	case SPECTRE_V2_USER_CMD_FORCE:
 		mode = SPECTRE_V2_USER_STRICT;
 		break;
+	case SPECTRE_V2_USER_CMD_AUTO:
+	case SPECTRE_V2_USER_CMD_PRCTL:
+		mode = SPECTRE_V2_USER_PRCTL;
+		break;
 	}
 
 	/* Initialize Indirect Branch Prediction Barrier */
@@ -391,6 +397,9 @@ spectre_v2_user_select_mitigation(enum s
 		case SPECTRE_V2_USER_STRICT:
 			static_branch_enable(&switch_mm_always_ibpb);
 			break;
+		case SPECTRE_V2_USER_PRCTL:
+			static_branch_enable(&switch_mm_cond_ibpb);
+			break;
 		default:
 			break;
 		}
@@ -403,6 +412,12 @@ spectre_v2_user_select_mitigation(enum s
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
+	/*
+	 * If SMT is not possible or STIBP is not available clear the STIPB
+	 * mode.
+	 */
+	if (!smt_possible || !boot_cpu_has(X86_FEATURE_STIBP))
+		mode = SPECTRE_V2_USER_NONE;
 set_mode:
 	spectre_v2_user = mode;
 	/* Only print the STIBP mode when SMT possible */
@@ -610,6 +625,15 @@ static void update_stibp_strict(void)
 	on_each_cpu(update_stibp_msr, NULL, 1);
 }
 
+/* Update the static key controlling the evaluation of TIF_SPEC_IB */
+static void update_indir_branch_cond(void)
+{
+	if (sched_smt_active())
+		static_branch_enable(&switch_to_cond_stibp);
+	else
+		static_branch_disable(&switch_to_cond_stibp);
+}
+
 void arch_smt_update(void)
 {
 	/* Enhanced IBRS implies STIBP. No update required. */
@@ -625,6 +649,7 @@ void arch_smt_update(void)
 		update_stibp_strict();
 		break;
 	case SPECTRE_V2_USER_PRCTL:
+		update_indir_branch_cond();
 		break;
 	}
 
@@ -1012,7 +1037,8 @@ static char *stibp_state(void)
 	case SPECTRE_V2_USER_STRICT:
 		return ", STIBP: forced";
 	case SPECTRE_V2_USER_PRCTL:
-		return "";
+		if (static_key_enabled(&switch_to_cond_stibp))
+			return ", STIBP: conditional";
 	}
 	return "";
 }
@@ -1020,14 +1046,11 @@ static char *stibp_state(void)
 static char *ibpb_state(void)
 {
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
-		switch (spectre_v2_user) {
-		case SPECTRE_V2_USER_NONE:
-			return ", IBPB: disabled";
-		case SPECTRE_V2_USER_STRICT:
+		if (static_key_enabled(&switch_mm_always_ibpb))
 			return ", IBPB: always-on";
-		case SPECTRE_V2_USER_PRCTL:
-			return "";
-		}
+		if (static_key_enabled(&switch_mm_cond_ibpb))
+			return ", IBPB: conditional";
+		return ", IBPB: disabled";
 	}
 	return "";
 }


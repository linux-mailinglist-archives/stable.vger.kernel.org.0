Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B9B1F292
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbfEOMEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:04:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729564AbfEOLLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEEFD20881;
        Wed, 15 May 2019 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918677;
        bh=7BFzbaLC0yakN2DUl3F+/sEjUg4rbbg9o+p02h4w2cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjjPM9QIqUhYf00tLkymMzlZy8sQ/h9hP9nqwhfWD7fK27BMBjDOetmUR7H29/bHE
         LYTJQd4M5HjQmlLJhL1H6Dvho3gsXpiy5GC0ehvwPtaDD/0DkCtqCZoltW/gLj+VMQ
         +nD9cbrNgsJLDgam4LoLJzU01AgMOkUh60KsUACQ=
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
Subject: [PATCH 4.4 224/266] x86/speculation: Enable prctl mode for spectre_v2_user
Date:   Wed, 15 May 2019 12:55:31 +0200
Message-Id: <20190515090730.573725348@linuxfoundation.org>
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
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    7 +++++-
 arch/x86/kernel/cpu/bugs.c          |   41 ++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 10 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3646,9 +3646,14 @@ bytes respectively. Such letter suffixes
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
@@ -244,11 +244,13 @@ enum spectre_v2_user_cmd {
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
@@ -259,6 +261,7 @@ static const struct {
 	{ "auto",	SPECTRE_V2_USER_CMD_AUTO,	false },
 	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
 	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
+	{ "prctl",	SPECTRE_V2_USER_CMD_PRCTL,	false },
 };
 
 static void __init spec_v2_user_print_cond(const char *reason, bool secure)
@@ -312,12 +315,15 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -328,6 +334,9 @@ spectre_v2_user_select_mitigation(enum s
 		case SPECTRE_V2_USER_STRICT:
 			static_branch_enable(&switch_mm_always_ibpb);
 			break;
+		case SPECTRE_V2_USER_PRCTL:
+			static_branch_enable(&switch_mm_cond_ibpb);
+			break;
 		default:
 			break;
 		}
@@ -340,6 +349,12 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -547,6 +562,15 @@ static void update_stibp_strict(void)
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
@@ -562,6 +586,7 @@ void arch_smt_update(void)
 		update_stibp_strict();
 		break;
 	case SPECTRE_V2_USER_PRCTL:
+		update_indir_branch_cond();
 		break;
 	}
 
@@ -950,7 +975,8 @@ static char *stibp_state(void)
 	case SPECTRE_V2_USER_STRICT:
 		return ", STIBP: forced";
 	case SPECTRE_V2_USER_PRCTL:
-		return "";
+		if (static_key_enabled(&switch_to_cond_stibp))
+			return ", STIBP: conditional";
 	}
 	return "";
 }
@@ -958,14 +984,11 @@ static char *stibp_state(void)
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



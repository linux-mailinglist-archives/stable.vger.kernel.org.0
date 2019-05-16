Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6816520C37
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfEPQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:02:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42638 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zl-EE; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001R4-Bb; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Kees Cook" <keescook@chromium.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Tim Chen" <tim.c.chen@linux.intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.915450840@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 59/86] x86/speculation: Provide IBPB always command
 line options
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

commit 55a974021ec952ee460dc31ca08722158639de72 upstream.

Provide the possibility to enable IBPB always in combination with 'prctl'
and 'seccomp'.

Add the extra command line options and rework the IBPB selection to
evaluate the command instead of the mode selected by the STIPB switch case.

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
Link: https://lkml.kernel.org/r/20181125185006.144047038@linutronix.de
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt | 12 +++++++
 arch/x86/kernel/cpu/bugs.c          | 34 +++++++++++++------
 2 files changed, 35 insertions(+), 11 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3223,11 +3223,23 @@ bytes respectively. Such letter suffixes
 				  per thread.  The mitigation control state
 				  is inherited on fork.
 
+			prctl,ibpb
+				- Like "prctl" above, but only STIBP is
+				  controlled per thread. IBPB is issued
+				  always when switching between different user
+				  space processes.
+
 			seccomp
 				- Same as "prctl" above, but all seccomp
 				  threads will enable the mitigation unless
 				  they explicitly opt out.
 
+			seccomp,ibpb
+				- Like "seccomp" above, but only STIBP is
+				  controlled per thread. IBPB is issued
+				  always when switching between different
+				  user space processes.
+
 			auto    - Kernel selects the mitigation depending on
 				  the available CPU features and vulnerability.
 
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -308,7 +308,9 @@ enum spectre_v2_user_cmd {
 	SPECTRE_V2_USER_CMD_AUTO,
 	SPECTRE_V2_USER_CMD_FORCE,
 	SPECTRE_V2_USER_CMD_PRCTL,
+	SPECTRE_V2_USER_CMD_PRCTL_IBPB,
 	SPECTRE_V2_USER_CMD_SECCOMP,
+	SPECTRE_V2_USER_CMD_SECCOMP_IBPB,
 };
 
 static const char * const spectre_v2_user_strings[] = {
@@ -323,11 +325,13 @@ static const struct {
 	enum spectre_v2_user_cmd	cmd;
 	bool				secure;
 } v2_user_options[] __initdata = {
-	{ "auto",	SPECTRE_V2_USER_CMD_AUTO,	false },
-	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
-	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
-	{ "prctl",	SPECTRE_V2_USER_CMD_PRCTL,	false },
-	{ "seccomp",	SPECTRE_V2_USER_CMD_SECCOMP,	false },
+	{ "auto",		SPECTRE_V2_USER_CMD_AUTO,		false },
+	{ "off",		SPECTRE_V2_USER_CMD_NONE,		false },
+	{ "on",			SPECTRE_V2_USER_CMD_FORCE,		true  },
+	{ "prctl",		SPECTRE_V2_USER_CMD_PRCTL,		false },
+	{ "prctl,ibpb",		SPECTRE_V2_USER_CMD_PRCTL_IBPB,		false },
+	{ "seccomp",		SPECTRE_V2_USER_CMD_SECCOMP,		false },
+	{ "seccomp,ibpb",	SPECTRE_V2_USER_CMD_SECCOMP_IBPB,	false },
 };
 
 static void __init spec_v2_user_print_cond(const char *reason, bool secure)
@@ -373,6 +377,7 @@ spectre_v2_user_select_mitigation(enum s
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
+	enum spectre_v2_user_cmd cmd;
 
 	if (!boot_cpu_has(X86_FEATURE_IBPB) && !boot_cpu_has(X86_FEATURE_STIBP))
 		return;
@@ -380,17 +385,20 @@ spectre_v2_user_select_mitigation(enum s
 	if (!IS_ENABLED(CONFIG_X86_HT))
 		smt_possible = false;
 
-	switch (spectre_v2_parse_user_cmdline(v2_cmd)) {
+	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
 	case SPECTRE_V2_USER_CMD_FORCE:
 		mode = SPECTRE_V2_USER_STRICT;
 		break;
 	case SPECTRE_V2_USER_CMD_PRCTL:
+	case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
 		mode = SPECTRE_V2_USER_PRCTL;
 		break;
 	case SPECTRE_V2_USER_CMD_AUTO:
 	case SPECTRE_V2_USER_CMD_SECCOMP:
+	case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
 		if (IS_ENABLED(CONFIG_SECCOMP))
 			mode = SPECTRE_V2_USER_SECCOMP;
 		else
@@ -402,12 +410,15 @@ spectre_v2_user_select_mitigation(enum s
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
 
-		switch (mode) {
-		case SPECTRE_V2_USER_STRICT:
+		switch (cmd) {
+		case SPECTRE_V2_USER_CMD_FORCE:
+		case SPECTRE_V2_USER_CMD_PRCTL_IBPB:
+		case SPECTRE_V2_USER_CMD_SECCOMP_IBPB:
 			static_branch_enable(&switch_mm_always_ibpb);
 			break;
-		case SPECTRE_V2_USER_PRCTL:
-		case SPECTRE_V2_USER_SECCOMP:
+		case SPECTRE_V2_USER_CMD_PRCTL:
+		case SPECTRE_V2_USER_CMD_AUTO:
+		case SPECTRE_V2_USER_CMD_SECCOMP:
 			static_branch_enable(&switch_mm_cond_ibpb);
 			break;
 		default:
@@ -415,7 +426,8 @@ spectre_v2_user_select_mitigation(enum s
 		}
 
 		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
-			mode == SPECTRE_V2_USER_STRICT ? "always-on" : "conditional");
+			static_key_enabled(&switch_mm_always_ibpb) ?
+			"always-on" : "conditional");
 	}
 
 	/* If enhanced IBRS is enabled no STIPB required */


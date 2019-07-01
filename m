Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89B620C25
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfEPP6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42596 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImG-0006zE-H0; Thu, 16 May 2019 16:58:40 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001Q9-Ug; Thu, 16 May 2019 16:58:37 +0100
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
        "David Woodhouse" <dwmw@amazon.co.uk>,
        "Asit Mallick" <asit.k.mallick@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Kees Cook" <keescook@chromium.org>,
        "Jiri Kosina" <jkosina@suse.cz>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tom Lendacky" <thomas.lendacky@amd.com>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "Casey Schaufler" <casey.schaufler@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Dave Stewart" <david.c.stewart@intel.com>,
        "Waiman Long" <longman9394@gmail.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "Andrea Arcangeli" <aarcange@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.393112422@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 48/86] x86/speculation: Add command line control for
 indirect branch speculation
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

commit fa1202ef224391b6f5b26cdd44cc50495e8fab54 upstream.

Add command line control for user space indirect branch speculation
mitigations. The new option is: spectre_v2_user=

The initial options are:

    -  on:   Unconditionally enabled
    - off:   Unconditionally disabled
    -auto:   Kernel selects mitigation (default off for now)

When the spectre_v2= command line argument is either 'on' or 'off' this
implies that the application to application control follows that state even
if a contradicting spectre_v2_user= argument is supplied.

Originally-by: Tim Chen <tim.c.chen@linux.intel.com>
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
Link: https://lkml.kernel.org/r/20181125185005.082720373@linutronix.de
[bwh: Backported to 3.16:
 - Don't use __ro_after_init or cpu_smt_control
 - Adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3176,9 +3176,13 @@ bytes respectively. Such letter suffixes
 
 	spectre_v2=	[X86] Control mitigation of Spectre variant 2
 			(indirect branch speculation) vulnerability.
+			The default operation protects the kernel from
+			user space attacks.
 
-			on   - unconditionally enable
-			off  - unconditionally disable
+			on   - unconditionally enable, implies
+			       spectre_v2_user=on
+			off  - unconditionally disable, implies
+			       spectre_v2_user=off
 			auto - kernel detects whether your CPU model is
 			       vulnerable
 
@@ -3188,6 +3192,12 @@ bytes respectively. Such letter suffixes
 			CONFIG_RETPOLINE configuration option, and the
 			compiler with which the kernel was built.
 
+			Selecting 'on' will also enable the mitigation
+			against user space to user space task attacks.
+
+			Selecting 'off' will disable both the kernel and
+			the user space protections.
+
 			Specific mitigations can also be selected manually:
 
 			retpoline	  - replace indirect branches
@@ -3197,6 +3207,24 @@ bytes respectively. Such letter suffixes
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
 
+	spectre_v2_user=
+			[X86] Control mitigation of Spectre variant 2
+		        (indirect branch speculation) vulnerability between
+		        user space tasks
+
+			on	- Unconditionally enable mitigations. Is
+				  enforced by spectre_v2=on
+
+			off     - Unconditionally disable mitigations. Is
+				  enforced by spectre_v2=off
+
+			auto    - Kernel selects the mitigation depending on
+				  the available CPU features and vulnerability.
+				  Default is off.
+
+			Not specifying this option is equivalent to
+			spectre_v2_user=auto.
+
 	spec_store_bypass_disable=
 			[HW] Control Speculative Store Bypass (SSB) Disable mitigation
 			(Speculative Store Bypass vulnerability)
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -3,6 +3,8 @@
 #ifndef _ASM_X86_NOSPEC_BRANCH_H_
 #define _ASM_X86_NOSPEC_BRANCH_H_
 
+#include <linux/static_key.h>
+
 #include <asm/alternative.h>
 #include <asm/alternative-asm.h>
 #include <asm/cpufeatures.h>
@@ -172,6 +174,12 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_IBRS_ENHANCED,
 };
 
+/* The indirect branch speculation control variants */
+enum spectre_v2_user_mitigation {
+	SPECTRE_V2_USER_NONE,
+	SPECTRE_V2_USER_STRICT,
+};
+
 /* The Speculative Store Bypass disable variants */
 enum ssb_mitigation {
 	SPEC_STORE_BYPASS_NONE,
@@ -248,5 +256,7 @@ do {									\
 	preempt_enable();						\
 } while (0)
 
+DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_NOSPEC_BRANCH_H_ */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -51,6 +51,9 @@ static u64 x86_spec_ctrl_mask = SPEC_CTR
 u64 x86_amd_ls_cfg_base;
 u64 x86_amd_ls_cfg_ssbd_mask;
 
+/* Control conditional STIPB in switch_to() */
+DEFINE_STATIC_KEY_FALSE(switch_to_cond_stibp);
+
 #ifdef CONFIG_X86_32
 
 static double __initdata x = 4195835.0;
@@ -252,6 +255,8 @@ static void x86_amd_ssb_disable(void)
 
 static enum spectre_v2_mitigation spectre_v2_enabled = SPECTRE_V2_NONE;
 
+static enum spectre_v2_user_mitigation spectre_v2_user = SPECTRE_V2_USER_NONE;
+
 #ifdef RETPOLINE
 static bool spectre_v2_bad_module;
 
@@ -290,6 +295,103 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_RETPOLINE_AMD,
 };
 
+enum spectre_v2_user_cmd {
+	SPECTRE_V2_USER_CMD_NONE,
+	SPECTRE_V2_USER_CMD_AUTO,
+	SPECTRE_V2_USER_CMD_FORCE,
+};
+
+static const char * const spectre_v2_user_strings[] = {
+	[SPECTRE_V2_USER_NONE]		= "User space: Vulnerable",
+	[SPECTRE_V2_USER_STRICT]	= "User space: Mitigation: STIBP protection",
+};
+
+static const struct {
+	const char			*option;
+	enum spectre_v2_user_cmd	cmd;
+	bool				secure;
+} v2_user_options[] __initdata = {
+	{ "auto",	SPECTRE_V2_USER_CMD_AUTO,	false },
+	{ "off",	SPECTRE_V2_USER_CMD_NONE,	false },
+	{ "on",		SPECTRE_V2_USER_CMD_FORCE,	true  },
+};
+
+static void __init spec_v2_user_print_cond(const char *reason, bool secure)
+{
+	if (boot_cpu_has_bug(X86_BUG_SPECTRE_V2) != secure)
+		pr_info("spectre_v2_user=%s forced on command line.\n", reason);
+}
+
+static enum spectre_v2_user_cmd __init
+spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
+{
+	char arg[20];
+	int ret, i;
+
+	switch (v2_cmd) {
+	case SPECTRE_V2_CMD_NONE:
+		return SPECTRE_V2_USER_CMD_NONE;
+	case SPECTRE_V2_CMD_FORCE:
+		return SPECTRE_V2_USER_CMD_FORCE;
+	default:
+		break;
+	}
+
+	ret = cmdline_find_option(boot_command_line, "spectre_v2_user",
+				  arg, sizeof(arg));
+	if (ret < 0)
+		return SPECTRE_V2_USER_CMD_AUTO;
+
+	for (i = 0; i < ARRAY_SIZE(v2_user_options); i++) {
+		if (match_option(arg, ret, v2_user_options[i].option)) {
+			spec_v2_user_print_cond(v2_user_options[i].option,
+						v2_user_options[i].secure);
+			return v2_user_options[i].cmd;
+		}
+	}
+
+	pr_err("Unknown user space protection option (%s). Switching to AUTO select\n", arg);
+	return SPECTRE_V2_USER_CMD_AUTO;
+}
+
+static void __init
+spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
+{
+	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
+	bool smt_possible = IS_ENABLED(CONFIG_SMP);
+
+	if (!boot_cpu_has(X86_FEATURE_IBPB) && !boot_cpu_has(X86_FEATURE_STIBP))
+		return;
+
+	if (!IS_ENABLED(CONFIG_X86_HT))
+		smt_possible = false;
+
+	switch (spectre_v2_parse_user_cmdline(v2_cmd)) {
+	case SPECTRE_V2_USER_CMD_AUTO:
+	case SPECTRE_V2_USER_CMD_NONE:
+		goto set_mode;
+	case SPECTRE_V2_USER_CMD_FORCE:
+		mode = SPECTRE_V2_USER_STRICT;
+		break;
+	}
+
+	/* Initialize Indirect Branch Prediction Barrier */
+	if (boot_cpu_has(X86_FEATURE_IBPB)) {
+		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
+		pr_info("Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier\n");
+	}
+
+	/* If enhanced IBRS is enabled no STIPB required */
+	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+		return;
+
+set_mode:
+	spectre_v2_user = mode;
+	/* Only print the STIBP mode when SMT possible */
+	if (smt_possible)
+		pr_info("%s\n", spectre_v2_user_strings[mode]);
+}
+
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE_MINIMAL]		= "Vulnerable: Minimal generic ASM retpoline",
@@ -445,12 +547,6 @@ specv2_set_mode:
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-	/* Initialize Indirect Branch Prediction Barrier if supported */
-	if (boot_cpu_has(X86_FEATURE_IBPB)) {
-		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
-		pr_info("Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier\n");
-	}
-
 	/*
 	 * Retpoline means the kernel is safe because it has no indirect
 	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
@@ -467,23 +563,21 @@ specv2_set_mode:
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
 
+	/* Set up IBPB and STIBP depending on the general spectre V2 command */
+	spectre_v2_user_select_mitigation(cmd);
+
 	/* Enable STIBP if appropriate */
 	arch_smt_update();
 }
 
 static bool stibp_needed(void)
 {
-	if (spectre_v2_enabled == SPECTRE_V2_NONE)
-		return false;
-
 	/* Enhanced IBRS makes using STIBP unnecessary. */
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return false;
 
-	if (!boot_cpu_has(X86_FEATURE_STIBP))
-		return false;
-
-	return true;
+	/* Check for strict user mitigation mode */
+	return spectre_v2_user == SPECTRE_V2_USER_STRICT;
 }
 
 static void update_stibp_msr(void *info)
@@ -820,10 +914,13 @@ static char *stibp_state(void)
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return "";
 
-	if (x86_spec_ctrl_base & SPEC_CTRL_STIBP)
-		return ", STIBP";
-	else
-		return "";
+	switch (spectre_v2_user) {
+	case SPECTRE_V2_USER_NONE:
+		return ", STIBP: disabled";
+	case SPECTRE_V2_USER_STRICT:
+		return ", STIBP: forced";
+	}
+	return "";
 }
 
 static char *ibpb_state(void)


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AABD1EDB3
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfEOLMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729805AbfEOLMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70D6F20881;
        Wed, 15 May 2019 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918752;
        bh=P3DJtJNfMXjKvj52yuwynEvezQgo/FOuNiaUjd2XLKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIEpVs/g1PIEAVZKnc3mjrWkIWxAuot8h5LJuTyrhGO/RbWQXOr4DvqOsCXRe+GmA
         GdyKedANx3Jg961hj92WFiET6og2ZDFis0WdCr0gGU/Qy0z6gMwvQpHdEYlj1uR1jx
         qav9AGGZ8ROA0n4onK5W+kCe7sh0H+m4bmBlwzZ8=
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
Subject: [PATCH 4.4 211/266] x86/speculation: Reorder the spec_v2 code
Date:   Wed, 15 May 2019 12:55:18 +0200
Message-Id: <20190515090730.107426523@linuxfoundation.org>
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

commit 15d6b7aab0793b2de8a05d8a828777dd24db424e upstream.

Reorder the code so it is better grouped. No functional change.

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
Link: https://lkml.kernel.org/r/20181125185004.707122879@linutronix.de
[bwh: Backported to 4.4:
 - We still have the minimal mitigation modes
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |  174 ++++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -115,30 +115,6 @@ void __init check_bugs(void)
 #endif
 }
 
-/* The kernel command line selection */
-enum spectre_v2_mitigation_cmd {
-	SPECTRE_V2_CMD_NONE,
-	SPECTRE_V2_CMD_AUTO,
-	SPECTRE_V2_CMD_FORCE,
-	SPECTRE_V2_CMD_RETPOLINE,
-	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
-	SPECTRE_V2_CMD_RETPOLINE_AMD,
-};
-
-static const char *spectre_v2_strings[] = {
-	[SPECTRE_V2_NONE]			= "Vulnerable",
-	[SPECTRE_V2_RETPOLINE_MINIMAL]		= "Vulnerable: Minimal generic ASM retpoline",
-	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	= "Vulnerable: Minimal AMD ASM retpoline",
-	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
-	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
-	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
-};
-
-#undef pr_fmt
-#define pr_fmt(fmt)     "Spectre V2 : " fmt
-
-static enum spectre_v2_mitigation spectre_v2_enabled = SPECTRE_V2_NONE;
-
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
@@ -208,6 +184,11 @@ static void x86_amd_ssb_disable(void)
 		wrmsrl(MSR_AMD64_LS_CFG, msrval);
 }
 
+#undef pr_fmt
+#define pr_fmt(fmt)     "Spectre V2 : " fmt
+
+static enum spectre_v2_mitigation spectre_v2_enabled = SPECTRE_V2_NONE;
+
 #ifdef RETPOLINE
 static bool spectre_v2_bad_module;
 
@@ -229,6 +210,45 @@ static inline const char *spectre_v2_mod
 static inline const char *spectre_v2_module_string(void) { return ""; }
 #endif
 
+static inline bool match_option(const char *arg, int arglen, const char *opt)
+{
+	int len = strlen(opt);
+
+	return len == arglen && !strncmp(arg, opt, len);
+}
+
+/* The kernel command line selection for spectre v2 */
+enum spectre_v2_mitigation_cmd {
+	SPECTRE_V2_CMD_NONE,
+	SPECTRE_V2_CMD_AUTO,
+	SPECTRE_V2_CMD_FORCE,
+	SPECTRE_V2_CMD_RETPOLINE,
+	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
+	SPECTRE_V2_CMD_RETPOLINE_AMD,
+};
+
+static const char *spectre_v2_strings[] = {
+	[SPECTRE_V2_NONE]			= "Vulnerable",
+	[SPECTRE_V2_RETPOLINE_MINIMAL]		= "Vulnerable: Minimal generic ASM retpoline",
+	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	= "Vulnerable: Minimal AMD ASM retpoline",
+	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
+	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
+	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
+};
+
+static const struct {
+	const char *option;
+	enum spectre_v2_mitigation_cmd cmd;
+	bool secure;
+} mitigation_options[] = {
+	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
+	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
+	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
+	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_AMD,	  false },
+	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
+	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
+};
+
 static void __init spec2_print_if_insecure(const char *reason)
 {
 	if (boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
@@ -246,31 +266,11 @@ static inline bool retp_compiler(void)
 	return __is_defined(RETPOLINE);
 }
 
-static inline bool match_option(const char *arg, int arglen, const char *opt)
-{
-	int len = strlen(opt);
-
-	return len == arglen && !strncmp(arg, opt, len);
-}
-
-static const struct {
-	const char *option;
-	enum spectre_v2_mitigation_cmd cmd;
-	bool secure;
-} mitigation_options[] = {
-	{ "off",               SPECTRE_V2_CMD_NONE,              false },
-	{ "on",                SPECTRE_V2_CMD_FORCE,             true },
-	{ "retpoline",         SPECTRE_V2_CMD_RETPOLINE,         false },
-	{ "retpoline,amd",     SPECTRE_V2_CMD_RETPOLINE_AMD,     false },
-	{ "retpoline,generic", SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
-	{ "auto",              SPECTRE_V2_CMD_AUTO,              false },
-};
-
 static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 {
+	enum spectre_v2_mitigation_cmd cmd = SPECTRE_V2_CMD_AUTO;
 	char arg[20];
 	int ret, i;
-	enum spectre_v2_mitigation_cmd cmd = SPECTRE_V2_CMD_AUTO;
 
 	if (cmdline_find_option_bool(boot_command_line, "nospectre_v2"))
 		return SPECTRE_V2_CMD_NONE;
@@ -313,48 +313,6 @@ static enum spectre_v2_mitigation_cmd __
 	return cmd;
 }
 
-static bool stibp_needed(void)
-{
-	if (spectre_v2_enabled == SPECTRE_V2_NONE)
-		return false;
-
-	/* Enhanced IBRS makes using STIBP unnecessary. */
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
-		return false;
-
-	if (!boot_cpu_has(X86_FEATURE_STIBP))
-		return false;
-
-	return true;
-}
-
-static void update_stibp_msr(void *info)
-{
-	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
-}
-
-void arch_smt_update(void)
-{
-	u64 mask;
-
-	if (!stibp_needed())
-		return;
-
-	mutex_lock(&spec_ctrl_mutex);
-
-	mask = x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
-	if (sched_smt_active())
-		mask |= SPEC_CTRL_STIBP;
-
-	if (mask != x86_spec_ctrl_base) {
-		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
-			mask & SPEC_CTRL_STIBP ? "Enabling" : "Disabling");
-		x86_spec_ctrl_base = mask;
-		on_each_cpu(update_stibp_msr, NULL, 1);
-	}
-	mutex_unlock(&spec_ctrl_mutex);
-}
-
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -459,6 +417,48 @@ specv2_set_mode:
 	arch_smt_update();
 }
 
+static bool stibp_needed(void)
+{
+	if (spectre_v2_enabled == SPECTRE_V2_NONE)
+		return false;
+
+	/* Enhanced IBRS makes using STIBP unnecessary. */
+	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+		return false;
+
+	if (!boot_cpu_has(X86_FEATURE_STIBP))
+		return false;
+
+	return true;
+}
+
+static void update_stibp_msr(void *info)
+{
+	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+}
+
+void arch_smt_update(void)
+{
+	u64 mask;
+
+	if (!stibp_needed())
+		return;
+
+	mutex_lock(&spec_ctrl_mutex);
+
+	mask = x86_spec_ctrl_base & ~SPEC_CTRL_STIBP;
+	if (sched_smt_active())
+		mask |= SPEC_CTRL_STIBP;
+
+	if (mask != x86_spec_ctrl_base) {
+		pr_info("Spectre v2 cross-process SMT mitigation: %s STIBP\n",
+			mask & SPEC_CTRL_STIBP ? "Enabling" : "Disabling");
+		x86_spec_ctrl_base = mask;
+		on_each_cpu(update_stibp_msr, NULL, 1);
+	}
+	mutex_unlock(&spec_ctrl_mutex);
+}
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"Speculative Store Bypass: " fmt
 



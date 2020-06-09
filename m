Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE891F367E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 10:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgFIIyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 04:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgFIIxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 04:53:53 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9A2C05BD43;
        Tue,  9 Jun 2020 01:53:52 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jia10-0005d0-1E; Tue, 09 Jun 2020 10:53:50 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id A48B91C0475;
        Tue,  9 Jun 2020 10:53:49 +0200 (CEST)
Date:   Tue, 09 Jun 2020 08:53:49 -0000
From:   "tip-bot2 for Anthony Steinhauser" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/speculation: Avoid force-disabling IBPB based
 on STIBP and enhanced IBRS.
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159169282952.17951.3529693809120577424.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     21998a351512eba4ed5969006f0c55882d995ada
Gitweb:        https://git.kernel.org/tip/21998a351512eba4ed5969006f0c55882d995ada
Author:        Anthony Steinhauser <asteinhauser@google.com>
AuthorDate:    Tue, 19 May 2020 06:40:42 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 10:50:54 +02:00

x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.

When STIBP is unavailable or enhanced IBRS is available, Linux
force-disables the IBPB mitigation of Spectre-BTB even when simultaneous
multithreading is disabled. While attempts to enable IBPB using
prctl(PR_SET_SPECULATION_CTRL, PR_SPEC_INDIRECT_BRANCH, ...) fail with
EPERM, the seccomp syscall (or its prctl(PR_SET_SECCOMP, ...) equivalent)
which are used e.g. by Chromium or OpenSSH succeed with no errors but the
application remains silently vulnerable to cross-process Spectre v2 attacks
(classical BTB poisoning). At the same time the SYSFS reporting
(/sys/devices/system/cpu/vulnerabilities/spectre_v2) displays that IBPB is
conditionally enabled when in fact it is unconditionally disabled.

STIBP is useful only when SMT is enabled. When SMT is disabled and STIBP is
unavailable, it makes no sense to force-disable also IBPB, because IBPB
protects against cross-process Spectre-BTB attacks regardless of the SMT
state. At the same time since missing STIBP was only observed on AMD CPUs,
AMD does not recommend using STIBP, but recommends using IBPB, so disabling
IBPB because of missing STIBP goes directly against AMD's advice:
https://developer.amd.com/wp-content/resources/Architecture_Guidelines_Update_Indirect_Branch_Control.pdf

Similarly, enhanced IBRS is designed to protect cross-core BTB poisoning
and BTB-poisoning attacks from user space against kernel (and
BTB-poisoning attacks from guest against hypervisor), it is not designed
to prevent cross-process (or cross-VM) BTB poisoning between processes (or
VMs) running on the same core. Therefore, even with enhanced IBRS it is
necessary to flush the BTB during context-switches, so there is no reason
to force disable IBPB when enhanced IBRS is available.

Enable the prctl control of IBPB even when STIBP is unavailable or enhanced
IBRS is available.

Fixes: 7cc765a67d8e ("x86/speculation: Enable prctl mode for spectre_v2_user")
Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/cpu/bugs.c | 87 +++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ed54b3b..8d57562 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -495,7 +495,9 @@ early_param("nospectre_v1", nospectre_v1_cmdline);
 static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
 	SPECTRE_V2_NONE;
 
-static enum spectre_v2_user_mitigation spectre_v2_user __ro_after_init =
+static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
+	SPECTRE_V2_USER_NONE;
+static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 
 #ifdef CONFIG_RETPOLINE
@@ -641,15 +643,6 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 		break;
 	}
 
-	/*
-	 * At this point, an STIBP mode other than "off" has been set.
-	 * If STIBP support is not being forced, check if STIBP always-on
-	 * is preferred.
-	 */
-	if (mode != SPECTRE_V2_USER_STRICT &&
-	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
-		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
-
 	/* Initialize Indirect Branch Prediction Barrier */
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
@@ -672,23 +665,36 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 		pr_info("mitigation: Enabling %s Indirect Branch Prediction Barrier\n",
 			static_key_enabled(&switch_mm_always_ibpb) ?
 			"always-on" : "conditional");
+
+		spectre_v2_user_ibpb = mode;
 	}
 
-	/* If enhanced IBRS is enabled no STIBP required */
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	/*
+	 * If enhanced IBRS is enabled or SMT impossible, STIBP is not
+	 * required.
+	 */
+	if (!smt_possible || spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
 	/*
-	 * If SMT is not possible or STIBP is not available clear the STIBP
-	 * mode.
+	 * At this point, an STIBP mode other than "off" has been set.
+	 * If STIBP support is not being forced, check if STIBP always-on
+	 * is preferred.
+	 */
+	if (mode != SPECTRE_V2_USER_STRICT &&
+	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
+		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
+
+	/*
+	 * If STIBP is not available, clear the STIBP mode.
 	 */
-	if (!smt_possible || !boot_cpu_has(X86_FEATURE_STIBP))
+	if (!boot_cpu_has(X86_FEATURE_STIBP))
 		mode = SPECTRE_V2_USER_NONE;
+
+	spectre_v2_user_stibp = mode;
+
 set_mode:
-	spectre_v2_user = mode;
-	/* Only print the STIBP mode when SMT possible */
-	if (smt_possible)
-		pr_info("%s\n", spectre_v2_user_strings[mode]);
+	pr_info("%s\n", spectre_v2_user_strings[mode]);
 }
 
 static const char * const spectre_v2_strings[] = {
@@ -921,7 +927,7 @@ void cpu_bugs_smt_update(void)
 {
 	mutex_lock(&spec_ctrl_mutex);
 
-	switch (spectre_v2_user) {
+	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		break;
 	case SPECTRE_V2_USER_STRICT:
@@ -1164,14 +1170,16 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 {
 	switch (ctrl) {
 	case PR_SPEC_ENABLE:
-		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return 0;
 		/*
 		 * Indirect branch speculation is always disabled in strict
 		 * mode.
 		 */
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
@@ -1182,10 +1190,12 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		 * Indirect branch speculation is always allowed when
 		 * mitigation is force disabled.
 		 */
-		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return -EPERM;
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
+		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return 0;
 		task_set_spec_ib_disable(task);
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
@@ -1216,7 +1226,8 @@ void arch_seccomp_spec_mitigate(struct task_struct *task)
 {
 	if (ssb_mode == SPEC_STORE_BYPASS_SECCOMP)
 		ssb_prctl_set(task, PR_SPEC_FORCE_DISABLE);
-	if (spectre_v2_user == SPECTRE_V2_USER_SECCOMP)
+	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP)
 		ib_prctl_set(task, PR_SPEC_FORCE_DISABLE);
 }
 #endif
@@ -1247,22 +1258,24 @@ static int ib_prctl_get(struct task_struct *task)
 	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V2))
 		return PR_SPEC_NOT_AFFECTED;
 
-	switch (spectre_v2_user) {
-	case SPECTRE_V2_USER_NONE:
+	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 		return PR_SPEC_ENABLE;
-	case SPECTRE_V2_USER_PRCTL:
-	case SPECTRE_V2_USER_SECCOMP:
+	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		return PR_SPEC_DISABLE;
+	else if (spectre_v2_user_ibpb == SPECTRE_V2_USER_PRCTL ||
+	    spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_PRCTL ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP) {
 		if (task_spec_ib_force_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_FORCE_DISABLE;
 		if (task_spec_ib_disable(task))
 			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
 		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
-	case SPECTRE_V2_USER_STRICT:
-	case SPECTRE_V2_USER_STRICT_PREFERRED:
-		return PR_SPEC_DISABLE;
-	default:
+	} else
 		return PR_SPEC_NOT_AFFECTED;
-	}
 }
 
 int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
@@ -1501,7 +1514,7 @@ static char *stibp_state(void)
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return "";
 
-	switch (spectre_v2_user) {
+	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		return ", STIBP: disabled";
 	case SPECTRE_V2_USER_STRICT:

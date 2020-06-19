Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F6720177E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395350AbgFSQjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388847AbgFSOqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:46:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2DFD2083B;
        Fri, 19 Jun 2020 14:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577992;
        bh=5Om2jZONb1caL9tM/afV46mg7zckZ3LN3vlOivZNruw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzJBCRSzrq+NoIqjvOyP+l+MNdMmvQNDW/F4CO0pRbgVxVOVaZ/6eDCOEzGyDgKLA
         RStsYcVhgV3HhrnhkV8Z3hRXWuVw4SRX8km5ehocayW3oExiQ6XqmMYMOgTaUmamoJ
         OjpOwHwaGqL/6EEYOb0Fqxz7X8JSO3YeBRfRfnH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/190] x86/speculation: Avoid force-disabling IBPB based on STIBP and enhanced IBRS.
Date:   Fri, 19 Jun 2020 16:31:26 +0200
Message-Id: <20200619141635.632671510@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Steinhauser <asteinhauser@google.com>

[ Upstream commit 21998a351512eba4ed5969006f0c55882d995ada ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 87 ++++++++++++++++++++++----------------
 1 file changed, 50 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ecd7ff665efe..ffcf30ec0aae 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -581,7 +581,9 @@ early_param("nospectre_v1", nospectre_v1_cmdline);
 static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
 	SPECTRE_V2_NONE;
 
-static enum spectre_v2_user_mitigation spectre_v2_user __ro_after_init =
+static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
+	SPECTRE_V2_USER_NONE;
+static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 
 #ifdef CONFIG_RETPOLINE
@@ -727,15 +729,6 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
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
@@ -758,23 +751,36 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
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
@@ -1005,7 +1011,7 @@ void arch_smt_update(void)
 {
 	mutex_lock(&spec_ctrl_mutex);
 
-	switch (spectre_v2_user) {
+	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		break;
 	case SPECTRE_V2_USER_STRICT:
@@ -1238,14 +1244,16 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
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
@@ -1256,10 +1264,12 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
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
@@ -1290,7 +1300,8 @@ void arch_seccomp_spec_mitigate(struct task_struct *task)
 {
 	if (ssb_mode == SPEC_STORE_BYPASS_SECCOMP)
 		ssb_prctl_set(task, PR_SPEC_FORCE_DISABLE);
-	if (spectre_v2_user == SPECTRE_V2_USER_SECCOMP)
+	if (spectre_v2_user_ibpb == SPECTRE_V2_USER_SECCOMP ||
+	    spectre_v2_user_stibp == SPECTRE_V2_USER_SECCOMP)
 		ib_prctl_set(task, PR_SPEC_FORCE_DISABLE);
 }
 #endif
@@ -1319,22 +1330,24 @@ static int ib_prctl_get(struct task_struct *task)
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
@@ -1573,7 +1586,7 @@ static char *stibp_state(void)
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return "";
 
-	switch (spectre_v2_user) {
+	switch (spectre_v2_user_stibp) {
 	case SPECTRE_V2_USER_NONE:
 		return ", STIBP: disabled";
 	case SPECTRE_V2_USER_STRICT:
-- 
2.25.1




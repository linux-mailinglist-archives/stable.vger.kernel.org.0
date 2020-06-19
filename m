Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879F22016E7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388850AbgFSOqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388838AbgFSOqa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:46:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 314E220A8B;
        Fri, 19 Jun 2020 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577989;
        bh=2geJ1HC8sbOSBhL2sqC+ZhlfgC+NLuBZuPi5yQ1oKYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1V95gEedGa5uz4yi72L0RFG/uu/3PgUZfvY8f6OHvacPixcb82r3ACupsbattjo9
         Nbz0SIZJ3YM0bF9fXXXNNkxre1Yj5MkmncXRDwCXIEwyvptzLbLGG+YlB7XR4K5L44
         rZtUqahARiwh+EdGNQOaboIUntwC/y20s6p0jbLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/190] x86/speculation: Add support for STIBP always-on preferred mode
Date:   Fri, 19 Jun 2020 16:31:25 +0200
Message-Id: <20200619141635.583521394@linuxfoundation.org>
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

From: Thomas Lendacky <Thomas.Lendacky@amd.com>

[ Upstream commit 20c3a2c33e9fdc82e9e8e8d2a6445b3256d20191 ]

Different AMD processors may have different implementations of STIBP.
When STIBP is conditionally enabled, some implementations would benefit
from having STIBP always on instead of toggling the STIBP bit through MSR
writes. This preference is advertised through a CPUID feature bit.

When conditional STIBP support is requested at boot and the CPU advertises
STIBP always-on mode as preferred, switch to STIBP "on" support. To show
that this transition has occurred, create a new spectre_v2_user_mitigation
value and a new spectre_v2_user_strings message. The new mitigation value
is used in spectre_v2_user_select_mitigation() to print the new mitigation
message as well as to return a new string from stibp_state().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Link: https://lkml.kernel.org/r/20181213230352.6937.74943.stgit@tlendack-t1.amdoffice.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h   |  1 +
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           | 28 ++++++++++++++++++++++------
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 764cbf1774d9..e08866cd2287 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -291,6 +291,7 @@
 #define X86_FEATURE_AMD_IBPB		(13*32+12) /* "" Indirect Branch Prediction Barrier */
 #define X86_FEATURE_AMD_IBRS		(13*32+14) /* "" Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* "" Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* "" Single Thread Indirect Branch Predictors always-on preferred */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index b73a16a56e4f..041d2a04be1d 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -232,6 +232,7 @@ enum spectre_v2_mitigation {
 enum spectre_v2_user_mitigation {
 	SPECTRE_V2_USER_NONE,
 	SPECTRE_V2_USER_STRICT,
+	SPECTRE_V2_USER_STRICT_PREFERRED,
 	SPECTRE_V2_USER_PRCTL,
 	SPECTRE_V2_USER_SECCOMP,
 };
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 3c3406a36812..ecd7ff665efe 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -633,10 +633,11 @@ enum spectre_v2_user_cmd {
 };
 
 static const char * const spectre_v2_user_strings[] = {
-	[SPECTRE_V2_USER_NONE]		= "User space: Vulnerable",
-	[SPECTRE_V2_USER_STRICT]	= "User space: Mitigation: STIBP protection",
-	[SPECTRE_V2_USER_PRCTL]		= "User space: Mitigation: STIBP via prctl",
-	[SPECTRE_V2_USER_SECCOMP]	= "User space: Mitigation: STIBP via seccomp and prctl",
+	[SPECTRE_V2_USER_NONE]			= "User space: Vulnerable",
+	[SPECTRE_V2_USER_STRICT]		= "User space: Mitigation: STIBP protection",
+	[SPECTRE_V2_USER_STRICT_PREFERRED]	= "User space: Mitigation: STIBP always-on protection",
+	[SPECTRE_V2_USER_PRCTL]			= "User space: Mitigation: STIBP via prctl",
+	[SPECTRE_V2_USER_SECCOMP]		= "User space: Mitigation: STIBP via seccomp and prctl",
 };
 
 static const struct {
@@ -726,6 +727,15 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 		break;
 	}
 
+	/*
+	 * At this point, an STIBP mode other than "off" has been set.
+	 * If STIBP support is not being forced, check if STIBP always-on
+	 * is preferred.
+	 */
+	if (mode != SPECTRE_V2_USER_STRICT &&
+	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
+		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
+
 	/* Initialize Indirect Branch Prediction Barrier */
 	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBPB);
@@ -999,6 +1009,7 @@ void arch_smt_update(void)
 	case SPECTRE_V2_USER_NONE:
 		break;
 	case SPECTRE_V2_USER_STRICT:
+	case SPECTRE_V2_USER_STRICT_PREFERRED:
 		update_stibp_strict();
 		break;
 	case SPECTRE_V2_USER_PRCTL:
@@ -1233,7 +1244,8 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		 * Indirect branch speculation is always disabled in strict
 		 * mode.
 		 */
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT)
+		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
@@ -1246,7 +1258,8 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		 */
 		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
 			return -EPERM;
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT)
+		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return 0;
 		task_set_spec_ib_disable(task);
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
@@ -1317,6 +1330,7 @@ static int ib_prctl_get(struct task_struct *task)
 			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
 		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
 	case SPECTRE_V2_USER_STRICT:
+	case SPECTRE_V2_USER_STRICT_PREFERRED:
 		return PR_SPEC_DISABLE;
 	default:
 		return PR_SPEC_NOT_AFFECTED;
@@ -1564,6 +1578,8 @@ static char *stibp_state(void)
 		return ", STIBP: disabled";
 	case SPECTRE_V2_USER_STRICT:
 		return ", STIBP: forced";
+	case SPECTRE_V2_USER_STRICT_PREFERRED:
+		return ", STIBP: always-on";
 	case SPECTRE_V2_USER_PRCTL:
 	case SPECTRE_V2_USER_SECCOMP:
 		if (static_key_enabled(&switch_to_cond_stibp))
-- 
2.25.1




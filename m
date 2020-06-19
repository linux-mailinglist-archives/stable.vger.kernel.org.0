Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0DD2017FC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392876AbgFSQpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388293AbgFSOls (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:41:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D464920A8B;
        Fri, 19 Jun 2020 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577707;
        bh=VeBmcM1VsRoL8tIxDmU/l9d2xSjTtAm/S1Y1+cfF6R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdQ4cxP9qh9gMsl9edO8TGG7+pKQh1P01wOyKhYctDyMKyIKFu8PfxdxYvEKor5Wf
         5ryWI5BHgt6yExhZpUvd/PhoKST8BKp1niCzCcEfpzLM4aqIu0/CGtUIhmjPWYqUbB
         4a8PV1+UKEg6PR8LyOD8QBO7mRL5S+vYj2BGKJGk=
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
Subject: [PATCH 4.9 026/128] x86/speculation: Add support for STIBP always-on preferred mode
Date:   Fri, 19 Jun 2020 16:32:00 +0200
Message-Id: <20200619141621.555351584@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
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
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           | 28 ++++++++++++++++++++++------
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2cd5d12a842c..8ceb7a8a249c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -273,6 +273,7 @@
 #define X86_FEATURE_AMD_IBPB	(13*32+12) /* "" Indirect Branch Prediction Barrier */
 #define X86_FEATURE_AMD_IBRS	(13*32+14) /* "" Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP	(13*32+15) /* "" Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* "" Single Thread Indirect Branch Predictors always-on preferred */
 #define X86_FEATURE_AMD_SSBD	(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD	(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO	(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
@@ -312,7 +313,6 @@
 #define X86_FEATURE_SUCCOR	(17*32+1) /* Uncorrectable error containment and recovery */
 #define X86_FEATURE_SMCA	(17*32+3) /* Scalable MCA */
 
-
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 18 */
 #define X86_FEATURE_AVX512_4VNNIW	(18*32+ 2) /* AVX-512 Neural Network Instructions */
 #define X86_FEATURE_AVX512_4FMAPS	(18*32+ 3) /* AVX-512 Multiply Accumulation Single precision */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 8d56d701b5f7..4af16acc001a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -223,6 +223,7 @@ enum spectre_v2_mitigation {
 enum spectre_v2_user_mitigation {
 	SPECTRE_V2_USER_NONE,
 	SPECTRE_V2_USER_STRICT,
+	SPECTRE_V2_USER_STRICT_PREFERRED,
 	SPECTRE_V2_USER_PRCTL,
 	SPECTRE_V2_USER_SECCOMP,
 };
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 704ffc01a226..82549060b824 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -632,10 +632,11 @@ enum spectre_v2_user_cmd {
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
@@ -725,6 +726,15 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
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
@@ -1007,6 +1017,7 @@ void arch_smt_update(void)
 	case SPECTRE_V2_USER_NONE:
 		break;
 	case SPECTRE_V2_USER_STRICT:
+	case SPECTRE_V2_USER_STRICT_PREFERRED:
 		update_stibp_strict();
 		break;
 	case SPECTRE_V2_USER_PRCTL:
@@ -1241,7 +1252,8 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		 * Indirect branch speculation is always disabled in strict
 		 * mode.
 		 */
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT)
+		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);
@@ -1254,7 +1266,8 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		 */
 		if (spectre_v2_user == SPECTRE_V2_USER_NONE)
 			return -EPERM;
-		if (spectre_v2_user == SPECTRE_V2_USER_STRICT)
+		if (spectre_v2_user == SPECTRE_V2_USER_STRICT ||
+		    spectre_v2_user == SPECTRE_V2_USER_STRICT_PREFERRED)
 			return 0;
 		task_set_spec_ib_disable(task);
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
@@ -1325,6 +1338,7 @@ static int ib_prctl_get(struct task_struct *task)
 			return PR_SPEC_PRCTL | PR_SPEC_DISABLE;
 		return PR_SPEC_PRCTL | PR_SPEC_ENABLE;
 	case SPECTRE_V2_USER_STRICT:
+	case SPECTRE_V2_USER_STRICT_PREFERRED:
 		return PR_SPEC_DISABLE;
 	default:
 		return PR_SPEC_NOT_AFFECTED;
@@ -1574,6 +1588,8 @@ static char *stibp_state(void)
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




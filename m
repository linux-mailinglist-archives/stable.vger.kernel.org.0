Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EEA20BC1
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfEPP6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42610 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726813AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zm-BS; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001RV-Gd; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Jon Masters" <jcm@redhat.com>,
        "Frederic Weisbecker" <frederic@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.390154116@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 64/86] x86/speculation/mds: Add BUG_MSBDS_ONLY
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

commit e261f209c3666e842fd645a1e31f001c3a26def9 upstream.

This bug bit is set on CPUs which are only affected by Microarchitectural
Store Buffer Data Sampling (MSBDS) and not by any other MDS variant.

This is important because the Store Buffers are partitioned between
Hyper-Threads so cross thread forwarding is not possible. But if a thread
enters or exits a sleep state the store buffer is repartitioned which can
expose data from one thread to the other. This transition can be mitigated.

That means that for CPUs which are only affected by MSBDS SMT can be
enabled, if the CPU is not affected by other SMT sensitive vulnerabilities,
e.g. L1TF. The XEON PHI variants fall into that category. Also the
Silvermont/Airmont ATOMs, but for them it's not really relevant as they do
not support SMT, but mark them for completeness sake.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 3.16:
 - Assign the next available bug flag
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/common.c       | 20 ++++++++++++--------
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -273,5 +273,6 @@
 #define X86_BUG_SPEC_STORE_BYPASS X86_BUG(8) /* CPU is affected by speculative store bypass attack */
 #define X86_BUG_L1TF		X86_BUG(9) /* CPU is affected by L1 Terminal Fault */
 #define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural data sampling */
+#define X86_BUG_MSBDS_ONLY	X86_BUG(11) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -812,6 +812,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_SSB		BIT(2)
 #define NO_L1TF		BIT(3)
 #define NO_MDS		BIT(4)
+#define MSBDS_ONLY	BIT(5)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -835,16 +836,16 @@ static const __initconst struct x86_cpu_
 	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
 	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
 
-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF),
-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF),
-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF),
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY),
 
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF),
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY),
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF),
@@ -888,8 +889,11 @@ static void __init cpu_set_bug_bits(stru
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
-	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO))
+	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO)) {
 		setup_force_cpu_bug(X86_BUG_MDS);
+		if (cpu_matches(MSBDS_ONLY))
+			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
+	}
 
 	if (cpu_matches(NO_MELTDOWN))
 		return;


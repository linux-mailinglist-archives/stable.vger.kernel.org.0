Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7453020C24
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfEPP6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42642 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726866AbfEPP6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:44 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImH-0006zp-9p; Thu, 16 May 2019 16:58:41 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImE-0001RQ-FP; Thu, 16 May 2019 16:58:38 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andi Kleen" <ak@linux.intel.com>, "Borislav Petkov" <bp@suse.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Jon Masters" <jcm@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Frederic Weisbecker" <frederic@kernel.org>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.140207505@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 63/86] x86/speculation/mds: Add basic bug
 infrastructure for MDS
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

From: Andi Kleen <ak@linux.intel.com>

commit ed5194c2732c8084af9fd159c146ea92bf137128 upstream.

Microarchitectural Data Sampling (MDS), is a class of side channel attacks
on internal buffers in Intel CPUs. The variants are:

 - Microarchitectural Store Buffer Data Sampling (MSBDS) (CVE-2018-12126)
 - Microarchitectural Fill Buffer Data Sampling (MFBDS) (CVE-2018-12130)
 - Microarchitectural Load Port Data Sampling (MLPDS) (CVE-2018-12127)

MSBDS leaks Store Buffer Entries which can be speculatively forwarded to a
dependent load (store-to-load forwarding) as an optimization. The forward
can also happen to a faulting or assisting load operation for a different
memory address, which can be exploited under certain conditions. Store
buffers are partitioned between Hyper-Threads so cross thread forwarding is
not possible. But if a thread enters or exits a sleep state the store
buffer is repartitioned which can expose data from one thread to the other.

MFBDS leaks Fill Buffer Entries. Fill buffers are used internally to manage
L1 miss situations and to hold data which is returned or sent in response
to a memory or I/O operation. Fill buffers can forward data to a load
operation and also write data to the cache. When the fill buffer is
deallocated it can retain the stale data of the preceding operations which
can then be forwarded to a faulting or assisting load operation, which can
be exploited under certain conditions. Fill buffers are shared between
Hyper-Threads so cross thread leakage is possible.

MLDPS leaks Load Port Data. Load ports are used to perform load operations
from memory or I/O. The received data is then forwarded to the register
file or a subsequent operation. In some implementations the Load Port can
contain stale data from a previous operation which can be forwarded to
faulting or assisting loads under certain conditions, which again can be
exploited eventually. Load ports are shared between Hyper-Threads so cross
thread leakage is possible.

All variants have the same mitigation for single CPU thread case (SMT off),
so the kernel can treat them as one MDS issue.

Add the basic infrastructure to detect if the current CPU is affected by
MDS.

[ tglx: Rewrote changelog ]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 3.16:
 - Use CPU feature word 10 and next available bug flag
 - Adjust filename, context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeatures.h    |  2 ++
 arch/x86/include/uapi/asm/msr-index.h |  5 +++++
 arch/x86/kernel/cpu/common.c          | 23 +++++++++++++++--------
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -243,6 +243,7 @@
 #define X86_FEATURE_AVX512CD	( 9*32+28) /* AVX-512 Conflict Detection */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 10 */
+#define X86_FEATURE_MD_CLEAR		(10*32+10) /* VERW clears CPU buffers */
 #define X86_FEATURE_SPEC_CTRL		(10*32+26) /* "" Speculation Control (IBRS + IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(10*32+27) /* "" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_ARCH_CAPABILITIES	(10*32+29) /* IA32_ARCH_CAPABILITIES MSR (Intel) */
@@ -271,5 +272,6 @@
 #define X86_BUG_SPECTRE_V2	X86_BUG(7) /* CPU is affected by Spectre variant 2 attack with indirect branches */
 #define X86_BUG_SPEC_STORE_BYPASS X86_BUG(8) /* CPU is affected by speculative store bypass attack */
 #define X86_BUG_L1TF		X86_BUG(9) /* CPU is affected by L1 Terminal Fault */
+#define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural data sampling */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -65,6 +65,11 @@
 						    * attack, so no Speculative Store Bypass
 						    * control required.
 						    */
+#define ARCH_CAP_MDS_NO			(1UL << 5) /*
+						    * Not susceptible to
+						    * Microarchitectural Data
+						    * Sampling (MDS) vulnerabilities.
+						    */
 
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -811,6 +811,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_MELTDOWN	BIT(1)
 #define NO_SSB		BIT(2)
 #define NO_L1TF		BIT(3)
+#define NO_MDS		BIT(4)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -827,6 +828,7 @@ static const __initconst struct x86_cpu_
 	VULNWL(INTEL,	5, X86_MODEL_ANY,	NO_SPECULATION),
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
+	/* Intel Family 6 */
 	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
 	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
 	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
@@ -843,17 +845,19 @@ static const __initconst struct x86_cpu_
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
 
 	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF),
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_L1TF),
-	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_L1TF),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_L1TF),
-
-	VULNWL_AMD(0x0f,		NO_MELTDOWN | NO_SSB | NO_L1TF),
-	VULNWL_AMD(0x10,		NO_MELTDOWN | NO_SSB | NO_L1TF),
-	VULNWL_AMD(0x11,		NO_MELTDOWN | NO_SSB | NO_L1TF),
-	VULNWL_AMD(0x12,		NO_MELTDOWN | NO_SSB | NO_L1TF),
+
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF),
+
+	/* AMD Family 0xf - 0x12 */
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS),
 	{}
 };
 
@@ -884,6 +888,9 @@ static void __init cpu_set_bug_bits(stru
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
+	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO))
+		setup_force_cpu_bug(X86_BUG_MDS);
+
 	if (cpu_matches(NO_MELTDOWN))
 		return;
 


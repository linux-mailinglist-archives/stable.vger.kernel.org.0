Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169791F28E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfEOME3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbfEOLLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3A62084E;
        Wed, 15 May 2019 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918695;
        bh=/54wH11Q94Jz/FkSoHx1TjmuFPhVt1TwV6MXYmywSDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=miJFNoVvTjl5E7jYPk0NzzRZxuYJFNVmws2A1mXQbUOs8ujIwCD1MbQJfU2kyK9lH
         YlEZUWFVCRR5LnNFwL6/EQDpb16NIdJv+/J7idTmKKGDiJ2x3QL/xwwiERA9DLmNlL
         ogxVqJtTBDygyOLtUp1PDqg/mZpp9CqL7pzIvj7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 230/266] x86/speculation/mds: Add basic bug infrastructure for MDS
Date:   Wed, 15 May 2019 12:55:37 +0200
Message-Id: <20190515090730.783711447@linuxfoundation.org>
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
[bwh: Backported to 4.4: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 ++
 arch/x86/include/asm/msr-index.h   |    5 +++++
 arch/x86/kernel/cpu/common.c       |   25 ++++++++++++++++---------
 3 files changed, 23 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -310,6 +310,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EDX), word 18 */
 #define X86_FEATURE_AVX512_4VNNIW	(18*32+ 2) /* AVX-512 Neural Network Instructions */
 #define X86_FEATURE_AVX512_4FMAPS	(18*32+ 3) /* AVX-512 Multiply Accumulation Single precision */
+#define X86_FEATURE_MD_CLEAR		(18*32+10) /* VERW clears CPU buffers */
 #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* "" Speculation Control (IBRS + IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_FLUSH_L1D		(18*32+28) /* Flush L1D cache */
@@ -335,5 +336,6 @@
 #define X86_BUG_SPECTRE_V2	X86_BUG(16) /* CPU is affected by Spectre variant 2 attack with indirect branches */
 #define X86_BUG_SPEC_STORE_BYPASS X86_BUG(17) /* CPU is affected by speculative store bypass attack */
 #define X86_BUG_L1TF		X86_BUG(18) /* CPU is affected by L1 Terminal Fault */
+#define X86_BUG_MDS		X86_BUG(19) /* CPU is affected by Microarchitectural data sampling */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -66,6 +66,11 @@
 						 * attack, so no Speculative Store Bypass
 						 * control required.
 						 */
+#define ARCH_CAP_MDS_NO			BIT(5)   /*
+						  * Not susceptible to
+						  * Microarchitectural Data
+						  * Sampling (MDS) vulnerabilities.
+						  */
 
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -851,6 +851,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_MELTDOWN	BIT(1)
 #define NO_SSB		BIT(2)
 #define NO_L1TF		BIT(3)
+#define NO_MDS		BIT(4)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -867,6 +868,7 @@ static const __initconst struct x86_cpu_
 	VULNWL(INTEL,	5, X86_MODEL_ANY,	NO_SPECULATION),
 	VULNWL(NSC,	5, X86_MODEL_ANY,	NO_SPECULATION),
 
+	/* Intel Family 6 */
 	VULNWL_INTEL(ATOM_SALTWELL,		NO_SPECULATION),
 	VULNWL_INTEL(ATOM_SALTWELL_TABLET,	NO_SPECULATION),
 	VULNWL_INTEL(ATOM_SALTWELL_MID,		NO_SPECULATION),
@@ -883,17 +885,19 @@ static const __initconst struct x86_cpu_
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
 
@@ -924,6 +928,9 @@ static void __init cpu_set_bug_bits(stru
 	if (ia32_cap & ARCH_CAP_IBRS_ALL)
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
 
+	if (!cpu_matches(NO_MDS) && !(ia32_cap & ARCH_CAP_MDS_NO))
+		setup_force_cpu_bug(X86_BUG_MDS);
+
 	if (cpu_matches(NO_MELTDOWN))
 		return;
 



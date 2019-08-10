Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933B088DBF
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfHJUso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54816 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726797AbfHJUoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00053i-Kj; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003iw-2I; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andrew Cooper" <andrew.cooper3@citrix.com>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.413104328@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 128/157] x86/speculation/swapgs: Exclude ATOMs from
 speculation through SWAPGS
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit f36cf386e3fec258a341d446915862eded3e13d8 upstream.

Intel provided the following information:

 On all current Atom processors, instructions that use a segment register
 value (e.g. a load or store) will not speculatively execute before the
 last writer of that segment retires. Thus they will not use a
 speculatively written segment value.

That means on ATOMs there is no speculation through SWAPGS, so the SWAPGS
entry paths can be excluded from the extra LFENCE if PTI is disabled.

Create a separate bug flag for the through SWAPGS speculation and mark all
out-of-order ATOMs and AMD/HYGON CPUs as not affected. The in-order ATOMs
are excluded from the whole mitigation mess anyway.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 3.16:
 - There's no whitelist entry (or any support) for Hygon CPUs
 - Use the next available X86_BUG number
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/bugs.c         | 18 +++----------
 arch/x86/kernel/cpu/common.c       | 42 +++++++++++++++++++-----------
 3 files changed, 32 insertions(+), 29 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -278,5 +278,6 @@
 #define X86_BUG_L1TF		X86_BUG(9) /* CPU is affected by L1 Terminal Fault */
 #define X86_BUG_MDS		X86_BUG(10) /* CPU is affected by Microarchitectural data sampling */
 #define X86_BUG_MSBDS_ONLY	X86_BUG(11) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
+#define X86_BUG_SWAPGS		X86_BUG(12) /* CPU is affected by speculation through SWAPGS */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -328,18 +328,6 @@ static const char * const spectre_v1_str
 	[SPECTRE_V1_MITIGATION_AUTO] = "Mitigation: usercopy/swapgs barriers and __user pointer sanitization",
 };
 
-static bool is_swapgs_serializing(void)
-{
-	/*
-	 * Technically, swapgs isn't serializing on AMD (despite it previously
-	 * being documented as such in the APM).  But according to AMD, %gs is
-	 * updated non-speculatively, and the issuing of %gs-relative memory
-	 * operands will be blocked until the %gs update completes, which is
-	 * good enough for our purposes.
-	 */
-	return boot_cpu_data.x86_vendor == X86_VENDOR_AMD;
-}
-
 /*
  * Does SMAP provide full mitigation against speculative kernel access to
  * userspace?
@@ -390,9 +378,11 @@ static void __init spectre_v1_select_mit
 			 * PTI as the CR3 write in the Meltdown mitigation
 			 * is serializing.
 			 *
-			 * If neither is there, mitigate with an LFENCE.
+			 * If neither is there, mitigate with an LFENCE to
+			 * stop speculation through swapgs.
 			 */
-			if (!is_swapgs_serializing() && !boot_cpu_has(X86_FEATURE_KAISER))
+			if (boot_cpu_has_bug(X86_BUG_SWAPGS) &&
+			    !boot_cpu_has(X86_FEATURE_KAISER))
 				setup_force_cpu_cap(X86_FEATURE_FENCE_SWAPGS_USER);
 
 			/*
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -813,6 +813,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_L1TF		BIT(3)
 #define NO_MDS		BIT(4)
 #define MSBDS_ONLY	BIT(5)
+#define NO_SWAPGS	BIT(6)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -836,29 +837,37 @@ static const __initconst struct x86_cpu_
 	VULNWL_INTEL(ATOM_BONNELL,		NO_SPECULATION),
 	VULNWL_INTEL(ATOM_BONNELL_MID,		NO_SPECULATION),
 
-	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
-	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY),
-	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY),
-	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY),
-	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY),
-	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_SILVERMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_SILVERMONT_X,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_SILVERMONT_MID,	NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_AIRMONT,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(XEON_PHI_KNL,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
+	VULNWL_INTEL(XEON_PHI_KNM,		NO_SSB | NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
 
 	VULNWL_INTEL(CORE_YONAH,		NO_SSB),
 
-	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY),
+	VULNWL_INTEL(ATOM_AIRMONT_MID,		NO_L1TF | MSBDS_ONLY | NO_SWAPGS),
 
-	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF),
-	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF),
+	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS),
+
+	/*
+	 * Technically, swapgs isn't serializing on AMD (despite it previously
+	 * being documented as such in the APM).  But according to AMD, %gs is
+	 * updated non-speculatively, and the issuing of %gs-relative memory
+	 * operands will be blocked until the %gs update completes, which is
+	 * good enough for our purposes.
+	 */
 
 	/* AMD Family 0xf - 0x12 */
-	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
-	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
-	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
-	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS),
+	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(0x10,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(0x11,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
+	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS),
 	{}
 };
 
@@ -895,6 +904,9 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
 	}
 
+	if (!cpu_matches(NO_SWAPGS))
+		setup_force_cpu_bug(X86_BUG_SWAPGS);
+
 	if (cpu_matches(NO_MELTDOWN))
 		return;
 


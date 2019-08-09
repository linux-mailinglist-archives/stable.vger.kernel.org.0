Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F9B87BB7
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436521AbfHINqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436508AbfHINqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:46:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27008217F5;
        Fri,  9 Aug 2019 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358394;
        bh=IOiDkirbV5vUKvWbcch35iZwYQNPFYylhMJtzk0D4yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2q/XgRBCo9k0DptqUJPTlVfvBkX84/84A3rpl9/L/l6wdBKaz6LMWFduRmDUDDOE
         XGerd4Qltr3ogcUA5aM/SfJhYF19YaySWQtUJhipLARfneC5FM1wy0TYA9iAbqaJX3
         wqX7MlRX5faJN4jWNwMxifRVvS0MVc2NMeHMBm/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 21/21] x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS
Date:   Fri,  9 Aug 2019 15:45:25 +0200
Message-Id: <20190809134242.419727460@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
References: <20190809134241.565496442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
[bwh: Backported to 4.4:
 - There's no whitelist entry (or any support) for Hygon CPUs
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 
 arch/x86/kernel/cpu/bugs.c         |   18 +++------------
 arch/x86/kernel/cpu/common.c       |   42 +++++++++++++++++++++++--------------
 3 files changed, 32 insertions(+), 29 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -339,5 +339,6 @@
 #define X86_BUG_L1TF		X86_BUG(18) /* CPU is affected by L1 Terminal Fault */
 #define X86_BUG_MDS		X86_BUG(19) /* CPU is affected by Microarchitectural data sampling */
 #define X86_BUG_MSBDS_ONLY	X86_BUG(20) /* CPU is only affected by the  MSDBS variant of BUG_MDS */
+#define X86_BUG_SWAPGS		X86_BUG(21) /* CPU is affected by speculation through SWAPGS */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -262,18 +262,6 @@ static const char * const spectre_v1_str
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
@@ -324,9 +312,11 @@ static void __init spectre_v1_select_mit
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
@@ -853,6 +853,7 @@ static void identify_cpu_without_cpuid(s
 #define NO_L1TF		BIT(3)
 #define NO_MDS		BIT(4)
 #define MSBDS_ONLY	BIT(5)
+#define NO_SWAPGS	BIT(6)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -876,29 +877,37 @@ static const __initconst struct x86_cpu_
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
 
@@ -935,6 +944,9 @@ static void __init cpu_set_bug_bits(stru
 			setup_force_cpu_bug(X86_BUG_MSBDS_ONLY);
 	}
 
+	if (!cpu_matches(NO_SWAPGS))
+		setup_force_cpu_bug(X86_BUG_SWAPGS);
+
 	if (cpu_matches(NO_MELTDOWN))
 		return;
 



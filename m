Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6F44F34F
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhKMNUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 08:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhKMNUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 08:20:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C5D60551;
        Sat, 13 Nov 2021 13:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636809459;
        bh=IpUNryb/iwXUxJH/Q5PxIbEcBWb7zviAkv57mPY+zE4=;
        h=Subject:To:Cc:From:Date:From;
        b=rohSc61HTGB3BiRxMl6V73RwPpq1L8sNypVSM3anKxwwQuPbszc0Kdga8fuxPfEdX
         NDEOm0QBNm1KeqYaYNC9Xg2txPRAsfSvxAeZ9nyScLvm2JZPH0RM+Fn3f6OlUPjvrM
         L9+pvfsU2wjQf2uAUb2NGLmYbSznYHp/q+vnm6t4=
Subject: FAILED: patch "[PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL" failed to apply to 4.9-stable tree
To:     jane.malalane@citrix.com, bp@suse.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 14:17:28 +0100
Message-ID: <163680944879178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 415de44076640483648d6c0f6d645a9ee61328ad Mon Sep 17 00:00:00 2001
From: Jane Malalane <jane.malalane@citrix.com>
Date: Thu, 21 Oct 2021 11:47:44 +0100
Subject: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL

Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
makes it unsafe to migrate in a virtualised environment as the
properties across the migration pool might differ.

To be specific, the case which goes wrong is:

1. Zen1 (or earlier) and Zen2 (or later) in a migration pool
2. Linux boots on Zen2, probes and finds the absence of X86_BUG_NULL_SEL
3. Linux is then migrated to Zen1

Linux is now running on a X86_BUG_NULL_SEL-impacted CPU while believing
that the bug is fixed.

The only way to address the problem is to fully trust the "no longer
affected" CPUID bit when virtualised, because in the above case it would
be clear deliberately to indicate the fact "you might migrate to
somewhere which has this behaviour".

Zen3 adds the NullSelectorClearsBase CPUID bit to indicate that loading
a NULL segment selector zeroes the base and limit fields, as well as
just attributes. Zen2 also has this behaviour but doesn't have the NSCB
bit.

 [ bp: Minor touchups. ]

Signed-off-by: Jane Malalane <jane.malalane@citrix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20211021104744.24126-1-jane.malalane@citrix.com

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2131af9f2fa2..4edb6f0f628c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -989,6 +989,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_IRPERF) &&
 	    !cpu_has_amd_erratum(c, amd_erratum_1054))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
+
+	check_null_seg_clears_base(c);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 325d6022599b..1bfeb186452a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1397,9 +1397,8 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
-static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
+static bool detect_null_seg_behavior(void)
 {
-#ifdef CONFIG_X86_64
 	/*
 	 * Empirically, writing zero to a segment selector on AMD does
 	 * not clear the base, whereas writing zero to a segment
@@ -1420,10 +1419,43 @@ static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_FS_BASE, 1);
 	loadsegment(fs, 0);
 	rdmsrl(MSR_FS_BASE, tmp);
-	if (tmp != 0)
-		set_cpu_bug(c, X86_BUG_NULL_SEG);
 	wrmsrl(MSR_FS_BASE, old_base);
-#endif
+	return tmp == 0;
+}
+
+void check_null_seg_clears_base(struct cpuinfo_x86 *c)
+{
+	/* BUG_NULL_SEG is only relevant with 64bit userspace */
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return;
+
+	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
+	if (c->extended_cpuid_level >= 0x80000021 &&
+	    cpuid_eax(0x80000021) & BIT(6))
+		return;
+
+	/*
+	 * CPUID bit above wasn't set. If this kernel is still running
+	 * as a HV guest, then the HV has decided not to advertize
+	 * that CPUID bit for whatever reason.	For example, one
+	 * member of the migration pool might be vulnerable.  Which
+	 * means, the bug is present: set the BUG flag and return.
+	 */
+	if (cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+		set_cpu_bug(c, X86_BUG_NULL_SEG);
+		return;
+	}
+
+	/*
+	 * Zen2 CPUs also have this behaviour, but no CPUID bit.
+	 * 0x18 is the respective family for Hygon.
+	 */
+	if ((c->x86 == 0x17 || c->x86 == 0x18) &&
+	    detect_null_seg_behavior())
+		return;
+
+	/* All the remaining ones are affected */
+	set_cpu_bug(c, X86_BUG_NULL_SEG);
 }
 
 static void generic_identify(struct cpuinfo_x86 *c)
@@ -1459,8 +1491,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	detect_null_seg_behavior(c);
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 95521302630d..ee6f23f7587d 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -75,6 +75,7 @@ extern int detect_extended_topology_early(struct cpuinfo_x86 *c);
 extern int detect_extended_topology(struct cpuinfo_x86 *c);
 extern int detect_ht_early(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
+extern void check_null_seg_clears_base(struct cpuinfo_x86 *c);
 
 unsigned int aperfmperf_get_khz(int cpu);
 
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 6d50136f7ab9..3fcdda4c1e11 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -335,6 +335,8 @@ static void init_hygon(struct cpuinfo_x86 *c)
 	/* Hygon CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	check_null_seg_clears_base(c);
 }
 
 static void cpu_detect_tlb_hygon(struct cpuinfo_x86 *c)


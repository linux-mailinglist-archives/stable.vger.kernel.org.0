Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5FF4521DF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbhKPBHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245341AbhKOTUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AC636334B;
        Mon, 15 Nov 2021 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001179;
        bh=drztPLr1SqrwRzQ6fuPEBF9zkkUE2ppdSBsaEGT3Tx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDpmR1Z8BHLEZ4hC30UmIamVMCbQj4Kn/Gy6kxhLzmUjOcXWpzZd274h1Gnkfp50I
         cSnqcoTSkoMWHUAryM0u0kQkRWISp2z03h+YpRCHRxugY4c+AhJaN2qTlFTmrGamli
         0j2WH8fBHklrH7b+NgqtKmrpn8GIAKBTKjP4FMa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Malalane <jane.malalane@citrix.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 058/917] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Date:   Mon, 15 Nov 2021 17:52:33 +0100
Message-Id: <20211115165430.735573693@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Malalane <jane.malalane@citrix.com>

commit 415de44076640483648d6c0f6d645a9ee61328ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c    |    2 +
 arch/x86/kernel/cpu/common.c |   44 ++++++++++++++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/cpu.h    |    1 
 arch/x86/kernel/cpu/hygon.c  |    2 +
 4 files changed, 42 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -989,6 +989,8 @@ static void init_amd(struct cpuinfo_x86
 	if (cpu_has(c, X86_FEATURE_IRPERF) &&
 	    !cpu_has_amd_erratum(c, amd_erratum_1054))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
+
+	check_null_seg_clears_base(c);
 }
 
 #ifdef CONFIG_X86_32
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1396,9 +1396,8 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
-static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
+static bool detect_null_seg_behavior(void)
 {
-#ifdef CONFIG_X86_64
 	/*
 	 * Empirically, writing zero to a segment selector on AMD does
 	 * not clear the base, whereas writing zero to a segment
@@ -1419,10 +1418,43 @@ static void detect_null_seg_behavior(str
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
@@ -1458,8 +1490,6 @@ static void generic_identify(struct cpui
 
 	get_model_name(c); /* Default name */
 
-	detect_null_seg_behavior(c);
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -75,6 +75,7 @@ extern int detect_extended_topology_earl
 extern int detect_extended_topology(struct cpuinfo_x86 *c);
 extern int detect_ht_early(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
+extern void check_null_seg_clears_base(struct cpuinfo_x86 *c);
 
 unsigned int aperfmperf_get_khz(int cpu);
 
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -335,6 +335,8 @@ static void init_hygon(struct cpuinfo_x8
 	/* Hygon CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	check_null_seg_clears_base(c);
 }
 
 static void cpu_detect_tlb_hygon(struct cpuinfo_x86 *c)



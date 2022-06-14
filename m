Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305F954B94B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357412AbiFNSpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiFNSpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:45:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E2F4BB83;
        Tue, 14 Jun 2022 11:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1A64CE1C16;
        Tue, 14 Jun 2022 18:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B09C3411B;
        Tue, 14 Jun 2022 18:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232208;
        bh=39kRTCXjxG+6omLpX2d9jRF2OOAe/np4h4XxJuM6/oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SltamFWClFEj/LP1VzWXTguZ5ECoywryBGLN5uyolfdEDsfWpYSd4wor1dI4AWnbQ
         sRw3vwgJkVtsYiDnr/fk3+svCavN/B++c+WZHl+qoBiCwHPcxGkbbVBKgw7m/97/50
         7PBYw7R5x+Q0kjwPhDr+zD8Kzr2o6o9QSpngHkPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 07/16] x86/speculation/mmio: Enumerate Processor MMIO Stale Data bug
Date:   Tue, 14 Jun 2022 20:40:08 +0200
Message-Id: <20220614183722.631762010@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
References: <20220614183720.928818645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 51802186158c74a0304f51ab963e7c2b3a2b046f upstream

Processor MMIO Stale Data is a class of vulnerabilities that may
expose data after an MMIO operation. For more details please refer to
Documentation/admin-guide/hw-vuln/processor_mmio_stale_data.rst

Add the Processor MMIO Stale Data bug enumeration. A microcode update
adds new bits to the MSR IA32_ARCH_CAPABILITIES, define them.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[cascardo: adapted family names to the ones in v4.19]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    1 
 arch/x86/include/asm/msr-index.h   |   19 ++++++++++++++++
 arch/x86/kernel/cpu/common.c       |   43 +++++++++++++++++++++++++++++++++++--
 3 files changed, 61 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -394,5 +394,6 @@
 #define X86_BUG_TAA			X86_BUG(22) /* CPU is affected by TSX Async Abort(TAA) */
 #define X86_BUG_ITLB_MULTIHIT		X86_BUG(23) /* CPU may incur MCE during certain page attribute changes */
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
+#define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -96,6 +96,25 @@
 						 * Not susceptible to
 						 * TSX Async Abort (TAA) vulnerabilities.
 						 */
+#define ARCH_CAP_SBDR_SSDP_NO		BIT(13)	/*
+						 * Not susceptible to SBDR and SSDP
+						 * variants of Processor MMIO stale data
+						 * vulnerabilities.
+						 */
+#define ARCH_CAP_FBSDP_NO		BIT(14)	/*
+						 * Not susceptible to FBSDP variant of
+						 * Processor MMIO stale data
+						 * vulnerabilities.
+						 */
+#define ARCH_CAP_PSDP_NO		BIT(15)	/*
+						 * Not susceptible to PSDP variant of
+						 * Processor MMIO stale data
+						 * vulnerabilities.
+						 */
+#define ARCH_CAP_FB_CLEAR		BIT(17)	/*
+						 * VERW clears CPU fill buffer
+						 * even on MDS_NO CPUs.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1019,18 +1019,39 @@ static const __initconst struct x86_cpu_
 					    X86_FEATURE_ANY, issues)
 
 #define SRBDS		BIT(0)
+/* CPU is affected by X86_BUG_MMIO_STALE_DATA */
+#define MMIO		BIT(1)
 
 static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(IVYBRIDGE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_ULT,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(HASWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(HASWELL_X,	BIT(2) | BIT(4),		MMIO),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_XEON_D,X86_STEPPINGS(0x3, 0x5),	MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
+						BIT(7) | BIT(0xB),              MMIO),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0xC),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0xD),	SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0x8),	SRBDS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
+	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
 	{}
 };
 
@@ -1051,6 +1072,13 @@ u64 x86_read_arch_cap_msr(void)
 	return ia32_cap;
 }
 
+static bool arch_cap_mmio_immune(u64 ia32_cap)
+{
+	return (ia32_cap & ARCH_CAP_FBSDP_NO &&
+		ia32_cap & ARCH_CAP_PSDP_NO &&
+		ia32_cap & ARCH_CAP_SBDR_SSDP_NO);
+}
+
 static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
@@ -1108,6 +1136,17 @@ static void __init cpu_set_bug_bits(stru
 	    cpu_matches(cpu_vuln_blacklist, SRBDS))
 		    setup_force_cpu_bug(X86_BUG_SRBDS);
 
+	/*
+	 * Processor MMIO Stale Data bug enumeration
+	 *
+	 * Affected CPU list is generally enough to enumerate the vulnerability,
+	 * but for virtualization case check for ARCH_CAP MSR bits also, VMM may
+	 * not want the guest to enumerate the bug.
+	 */
+	if (cpu_matches(cpu_vuln_blacklist, MMIO) &&
+	    !arch_cap_mmio_immune(ia32_cap))
+		setup_force_cpu_bug(X86_BUG_MMIO_STALE_DATA);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 



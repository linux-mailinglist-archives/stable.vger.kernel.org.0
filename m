Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70720C7D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfEPQFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:05:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42368 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbfEPP6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:41 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0006zN-TI; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImD-0001OU-8v; Thu, 16 May 2019 16:58:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ravi Shankar" <ravi.v.shankar@intel.com>,
        "Tim C Chen" <tim.c.chen@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sai Praneeth" <sai.praneeth.prakhya@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dave Hansen" <dave.hansen@intel.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.465440515@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 27/86] x86/speculation: Support Enhanced IBRS on
 future CPUs
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

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

commit 706d51681d636a0c4a5ef53395ec3b803e45ed4d upstream.

Future Intel processors will support "Enhanced IBRS" which is an "always
on" mode i.e. IBRS bit in SPEC_CTRL MSR is enabled once and never
disabled.

=46romthe specification [1]:

 "With enhanced IBRS, the predicted targets of indirect branches
  executed cannot be controlled by software that was executed in a less
  privileged predictor mode or on another logical processor. As a
  result, software operating on a processor with enhanced IBRS need not
  use WRMSR to set IA32_SPEC_CTRL.IBRS after every transition to a more
  privileged predictor mode. Software can isolate predictor modes
  effectively simply by setting the bit once. Software need not disable
  enhanced IBRS prior to entering a sleep state such as MWAIT or HLT."

If Enhanced IBRS is supported by the processor then use it as the
preferred spectre v2 mitigation mechanism instead of Retpoline. Intel's
Retpoline white paper [2] states:

 "Retpoline is known to be an effective branch target injection (Spectre
  variant 2) mitigation on Intel processors belonging to family 6
  (enumerated by the CPUID instruction) that do not have support for
  enhanced IBRS. On processors that support enhanced IBRS, it should be
  used for mitigation instead of retpoline."

The reason why Enhanced IBRS is the recommended mitigation on processors
which support it is that these processors also support CET which
provides a defense against ROP attacks. Retpoline is very similar to ROP
techniques and might trigger false positives in the CET defense.

If Enhanced IBRS is selected as the mitigation technique for spectre v2,
the IBRS bit in SPEC_CTRL MSR is set once at boot time and never
cleared. Kernel also has to make sure that IBRS bit remains set after
VMEXIT because the guest might have cleared the bit. This is already
covered by the existing x86_spec_ctrl_set_guest() and
x86_spec_ctrl_restore_host() speculation control functions.

Enhanced IBRS still requires IBPB for full mitigation.

[1] Speculative-Execution-Side-Channel-Mitigations.pdf
[2] Retpoline-A-Branch-Target-Injection-Mitigation.pdf
Both documents are available at:
https://bugzilla.kernel.org/show_bug.cgi?id=199511

Originally-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim C Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Link: https://lkml.kernel.org/r/1533148945-24095-1-git-send-email-sai.praneeth.prakhya@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16:
 - Use the first available bit from word 7
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeatures.h   |  1 +
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           | 20 ++++++++++++++++++--
 arch/x86/kernel/cpu/common.c         |  3 +++
 4 files changed, 23 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -196,6 +196,7 @@
 #define X86_FEATURE_SSBD	( 7*32+20) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_ZEN		( 7*32+21) /* "" CPU is AMD family 0x17 (Zen) */
 #define X86_FEATURE_L1TF_PTEINV	( 7*32+22) /* "" L1TF workaround PTE inversion */
+#define X86_FEATURE_IBRS_ENHANCED ( 7*32+23) /* Enhanced IBRS */
 #define X86_FEATURE_RETPOLINE	( 7*32+29) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_AMD ( 7*32+30) /* "" AMD Retpoline mitigation for Spectre variant 2 */
 /* Because the ALTERNATIVE scheme is for members of the X86_FEATURE club... */
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -170,6 +170,7 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_RETPOLINE_GENERIC,
 	SPECTRE_V2_RETPOLINE_AMD,
 	SPECTRE_V2_IBRS,
+	SPECTRE_V2_IBRS_ENHANCED,
 };
 
 /* The Speculative Store Bypass disable variants */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -195,6 +195,7 @@ static const char *spectre_v2_strings[]
 	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	= "Vulnerable: Minimal AMD ASM retpoline",
 	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
 	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
+	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
 };
 
 #undef pr_fmt
@@ -396,6 +397,13 @@ static void __init spectre_v2_select_mit
 
 	case SPECTRE_V2_CMD_FORCE:
 	case SPECTRE_V2_CMD_AUTO:
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+			mode = SPECTRE_V2_IBRS_ENHANCED;
+			/* Force it so VMEXIT will restore correctly */
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			goto specv2_set_mode;
+		}
 		if (IS_ENABLED(CONFIG_RETPOLINE))
 			goto retpoline_auto;
 		break;
@@ -433,6 +441,7 @@ retpoline_auto:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	}
 
+specv2_set_mode:
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
@@ -455,9 +464,16 @@ retpoline_auto:
 
 	/*
 	 * Retpoline means the kernel is safe because it has no indirect
-	 * branches. But firmware isn't, so use IBRS to protect that.
+	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
+	 * speculation around firmware calls only when Enhanced IBRS isn't
+	 * supported.
+	 *
+	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
+	 * the user might select retpoline on the kernel command line and if
+	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
+	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS)) {
+	if (boot_cpu_has(X86_FEATURE_IBRS) && mode != SPECTRE_V2_IBRS_ENHANCED) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -882,6 +882,9 @@ static void __init cpu_set_bug_bits(stru
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
 
+	if (ia32_cap & ARCH_CAP_IBRS_ALL)
+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+
 	if (x86_match_cpu(cpu_no_meltdown))
 		return;
 


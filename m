Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC981ED76
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfEOLJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbfEOLJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79FD920843;
        Wed, 15 May 2019 11:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918576;
        bh=oErbj8uqIlAKMZ35AID9c1n0yDo+aWc+lzVPpBal5aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v62hIVISzLvYBX1BTulVD48KJXxQmrnboHtlrZn8Ov0NGbZA8g11jpoILegw1KsZ2
         w/jiMNVIjNXre+5rzw0P62cYCkjGTEPevkmKV9Plgg91yjgTp4hJ5EAB6nQxZDkDxA
         TU92NNnOvZdD3i5UXYjk00MqmfDWH7XR1kVeBjyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim C Chen <tim.c.chen@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ravi Shankar <ravi.v.shankar@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 4.4 185/266] x86/speculation: Support Enhanced IBRS on future CPUs
Date:   Wed, 15 May 2019 12:54:52 +0200
Message-Id: <20190515090729.188243165@linuxfoundation.org>
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

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

commit 706d51681d636a0c4a5ef53395ec3b803e45ed4d upstream.

Future Intel processors will support "Enhanced IBRS" which is an "always
on" mode i.e. IBRS bit in SPEC_CTRL MSR is enabled once and never
disabled.

>From the specification [1]:

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
[bwh: Backported to 4.4:
 - Use the next bit from feature word 7
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h   |    1 +
 arch/x86/include/asm/nospec-branch.h |    1 +
 arch/x86/kernel/cpu/bugs.c           |   20 ++++++++++++++++++--
 arch/x86/kernel/cpu/common.c         |    3 +++
 4 files changed, 23 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -214,6 +214,7 @@
 #define X86_FEATURE_STIBP	( 7*32+27) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_ZEN		( 7*32+28) /* "" CPU is AMD family 0x17 (Zen) */
 #define X86_FEATURE_L1TF_PTEINV	( 7*32+29) /* "" L1TF workaround PTE inversion */
+#define X86_FEATURE_IBRS_ENHANCED	( 7*32+30) /* Enhanced IBRS */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  ( 8*32+ 0) /* Intel TPR Shadow */
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
@@ -132,6 +132,7 @@ static const char *spectre_v2_strings[]
 	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	= "Vulnerable: Minimal AMD ASM retpoline",
 	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
 	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
+	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
 };
 
 #undef pr_fmt
@@ -332,6 +333,13 @@ static void __init spectre_v2_select_mit
 
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
@@ -369,6 +377,7 @@ retpoline_auto:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	}
 
+specv2_set_mode:
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
@@ -391,9 +400,16 @@ retpoline_auto:
 
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
@@ -915,6 +915,9 @@ static void __init cpu_set_bug_bits(stru
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V1);
 	setup_force_cpu_bug(X86_BUG_SPECTRE_V2);
 
+	if (ia32_cap & ARCH_CAP_IBRS_ALL)
+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+
 	if (x86_match_cpu(cpu_no_meltdown))
 		return;
 



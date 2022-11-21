Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380F66322CD
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 13:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiKUMqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 07:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKUMp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 07:45:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BF6BFF43
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 04:45:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813E76119B
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 12:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5B8C433C1;
        Mon, 21 Nov 2022 12:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669034754;
        bh=7LxHYaSlhv/LKP/Hc1acjhFblsom15NGvuL/bGMCS90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttfyTPZvYFS0XgAMPrYYhPWIvjYvdimXjeqCXpcRrYXceWOUylv/EJ9VSvjM5jsJb
         YKiZDzLUWisSAZGk4AY4eigmOZR6/QK3SP0NNA9lNngPar0AXvhahe70xnfyNpLXU3
         yjOdbhTeC4cKUBP2KJN8x3zK+AA5DqKyDUdmnmic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 31/34] x86/speculation: Disable RRSBA behavior
Date:   Mon, 21 Nov 2022 13:43:53 +0100
Message-Id: <20221121124152.014179597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 4ad3278df6fe2b0852b00d5757fc2ccd8e92c26e upstream.

Some Intel processors may use alternate predictors for RETs on
RSB-underflow. This condition may be vulnerable to Branch History
Injection (BHI) and intramode-BTI.

Kernel earlier added spectre_v2 mitigation modes (eIBRS+Retpolines,
eIBRS+LFENCE, Retpolines) which protect indirect CALLs and JMPs against
such attacks. However, on RSB-underflow, RET target prediction may
fallback to alternate predictors. As a result, RET's predicted target
may get influenced by branch history.

A new MSR_IA32_SPEC_CTRL bit (RRSBA_DIS_S) controls this fallback
behavior when in kernel mode. When set, RETs will not take predictions
from alternate predictors, hence mitigating RETs as well. Support for
this is enumerated by CPUID.7.2.EDX[RRSBA_CTRL] (bit2).

For spectre v2 mitigation, when a user selects a mitigation that
protects indirect CALLs and JMPs against BHI and intramode-BTI, set
RRSBA_DIS_S also to protect RETs for RSB-underflow case.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[bwh: Backported to 5.15: adjust context in scattered.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[sam: Fixed for missing X86_FEATURE_ENTRY_IBPB context]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeatures.h |    2 +-
 arch/x86/include/asm/msr-index.h   |    9 +++++++++
 arch/x86/kernel/cpu/bugs.c         |   26 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c    |    1 +
 4 files changed, 37 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -288,7 +288,7 @@
 /* FREE!				(11*32+ 8) */
 /* FREE!				(11*32+ 9) */
 /* FREE!				(11*32+10) */
-/* FREE!				(11*32+11) */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -47,6 +47,8 @@
 #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
+#define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -121,6 +123,13 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
+#define ARCH_CAP_RRSBA			BIT(19)	/*
+						 * Indicates RET may use predictors
+						 * other than the RSB. With eIBRS
+						 * enabled predictions in kernel mode
+						 * are restricted to targets in
+						 * kernel.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1181,6 +1181,22 @@ static enum spectre_v2_mitigation __init
 	return SPECTRE_V2_RETPOLINE;
 }
 
+/* Disable in-kernel use of non-RSB RET predictors */
+static void __init spec_ctrl_disable_kernel_rrsba(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has(X86_FEATURE_RRSBA_CTRL))
+		return;
+
+	ia32_cap = x86_read_arch_cap_msr();
+
+	if (ia32_cap & ARCH_CAP_RRSBA) {
+		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	}
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1274,6 +1290,16 @@ static void __init spectre_v2_select_mit
 		break;
 	}
 
+	/*
+	 * Disable alternate RSB predictions in kernel when indirect CALLs and
+	 * JMPs gets protection against BHI and Intramode-BTI, but RET
+	 * prediction from a non-RSB predictor is still a risk.
+	 */
+	if (mode == SPECTRE_V2_EIBRS_LFENCE ||
+	    mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	    mode == SPECTRE_V2_RETPOLINE)
+		spec_ctrl_disable_kernel_rrsba();
+
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -21,6 +21,7 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_RRSBA_CTRL,	CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },



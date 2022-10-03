Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391925F30F9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiJCNNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiJCNN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:13:27 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDBA52DFE;
        Mon,  3 Oct 2022 06:13:03 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 79FF642FB9;
        Mon,  3 Oct 2022 13:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802776;
        bh=9MpR03+KKKL3TDuEw6NE82LMOFUlXP99Sfl1wGUy/6o=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=UKDBj8rXMqZ2qM3GAg7mTpnMJTzbVH614pr3xS1RSJpOwy2TDWjwqUUugZlnZw/wk
         9JA73BskQiw1i2Mvx/PE1DJix2psniPT1jnXqC2LDlGeLlOSkgtfYfcS/G9lihP1KD
         cITDStpgx+aDE5t/zTssyDEu3K+IJme/EITqfZJmWjIjo1U2wn84W6BgQUV7IfGDyX
         fAa3xMuxd6ThbhbsaAekF9MXkIUJuGWqIdNNmK5vam0YQEUayeLE12lOMLRsKWlc1r
         rqRIvxpnIZoTzkx09zPjmcCHZBOibw/sf2yqOQG+aT81n0WbHLPjIRQtd2X5F/+Lu1
         l+dgfanFXbOIA==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 34/37] x86/speculation: Disable RRSBA behavior
Date:   Mon,  3 Oct 2022 10:10:35 -0300
Message-Id: <20221003131038.12645-35-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
[cascardo: no tools/arch/x86/include/asm/msr-index.h]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/msr-index.h   |  9 +++++++++
 arch/x86/kernel/cpu/bugs.c         | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c    |  1 +
 4 files changed, 37 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d6fc05367439..b2415826f8ea 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -286,6 +286,7 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 973784cfe23a..12a24b25ce26 100644
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
@@ -130,6 +132,13 @@
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
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 3b7cc3380b54..56feba04d1f5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1181,6 +1181,22 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
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
@@ -1274,6 +1290,16 @@ static void __init spectre_v2_select_mitigation(void)
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
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 53004dbd55c4..a03e309a0ac5 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -26,6 +26,7 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_RRSBA_CTRL,	CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },
-- 
2.34.1


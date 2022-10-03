Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBE5F30CE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJCNMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiJCNMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:12:08 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B50F4DB0A;
        Mon,  3 Oct 2022 06:11:53 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0BF0442FB9;
        Mon,  3 Oct 2022 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802705;
        bh=pzZweCv7IRMoTBXdgC41zW24/z2qhkNUBrTgeuYdHrc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nNtBT7YA8DXaT+F+eVonvXWHLbvoLQPokr6Y88/W7p8bOjy1oADdr2eLXEe/eBy90
         hxIBFFLpOFqpRD3r+DdrAvZz2r2Os5LijkJKd9mkNtwxJjtr62qPQ1iItaHdy2R7Pl
         yO0SDxtTiTSuNsl7/rzxI3N/SGXhAMEb6dy6Ap6XJfTsOGTx8mK9zC5KsvHhvKwfA8
         efdH8xhqyjoo1AmwUfplGVBOmu/ViVmEcTfji02niPGS9L7omQ8FEcAYcyhkvW9S2I
         EKA7r3IT9uuwst5V4GPaRPPfBtqTipmiW82wtOCoOKyAGTBfaQ2znweubR7zJq7BMb
         6WPFKoQ3AJZhA==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 14/37] x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
Date:   Mon,  3 Oct 2022 10:10:15 -0300
Message-Id: <20221003131038.12645-15-cascardo@canonical.com>
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

commit 7c693f54c873691a4b7da05c7e0f74e67745d144 upstream.

Extend spectre_v2= boot option with Kernel IBRS.

  [jpoimboe: no STIBP with IBRS]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 .../admin-guide/kernel-parameters.txt         |  1 +
 arch/x86/include/asm/nospec-branch.h          |  1 +
 arch/x86/kernel/cpu/bugs.c                    | 66 +++++++++++++++----
 3 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e0fb1e5e5113..8f71a17ad544 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4553,6 +4553,7 @@
 			eibrs		  - enhanced IBRS
 			eibrs,retpoline   - enhanced IBRS + Retpolines
 			eibrs,lfence      - enhanced IBRS + LFENCE
+			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 2e7da90a5f73..2de7c08fa36e 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -234,6 +234,7 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_EIBRS,
 	SPECTRE_V2_EIBRS_RETPOLINE,
 	SPECTRE_V2_EIBRS_LFENCE,
+	SPECTRE_V2_IBRS,
 };
 
 /* The indirect branch speculation control variants */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 549d603b5f6e..497562e78876 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -877,6 +877,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_EIBRS,
 	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
 	SPECTRE_V2_CMD_EIBRS_LFENCE,
+	SPECTRE_V2_CMD_IBRS,
 };
 
 enum spectre_v2_user_cmd {
@@ -949,11 +950,12 @@ spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 {
-	return (mode == SPECTRE_V2_EIBRS ||
-		mode == SPECTRE_V2_EIBRS_RETPOLINE ||
-		mode == SPECTRE_V2_EIBRS_LFENCE);
+	return mode == SPECTRE_V2_IBRS ||
+	       mode == SPECTRE_V2_EIBRS ||
+	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	       mode == SPECTRE_V2_EIBRS_LFENCE;
 }
 
 static void __init
@@ -1018,12 +1020,12 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	}
 
 	/*
-	 * If no STIBP, enhanced IBRS is enabled or SMT impossible, STIBP is not
-	 * required.
+	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
+	 * STIBP is not required.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -1048,6 +1050,7 @@ static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
+	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
 };
 
 static const struct {
@@ -1065,6 +1068,7 @@ static const struct {
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
+	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
 };
 
 static void __init spec_v2_print_cond(const char *reason, bool secure)
@@ -1127,6 +1131,24 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
+	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
+		pr_err("%s selected but not Intel CPU. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if (cmd == SPECTRE_V2_CMD_IBRS && !boot_cpu_has(X86_FEATURE_IBRS)) {
+		pr_err("%s selected but CPU doesn't have IBRS. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if (cmd == SPECTRE_V2_CMD_IBRS && boot_cpu_has(X86_FEATURE_XENPV)) {
+		pr_err("%s selected but running as XenPV guest. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
 	spec_v2_print_cond(mitigation_options[i].option,
 			   mitigation_options[i].secure);
 	return cmd;
@@ -1166,6 +1188,14 @@ static void __init spectre_v2_select_mitigation(void)
 			break;
 		}
 
+		if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+		    retbleed_cmd != RETBLEED_CMD_OFF &&
+		    boot_cpu_has(X86_FEATURE_IBRS) &&
+		    boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+			mode = SPECTRE_V2_IBRS;
+			break;
+		}
+
 		mode = spectre_v2_select_retpoline();
 		break;
 
@@ -1182,6 +1212,10 @@ static void __init spectre_v2_select_mitigation(void)
 		mode = spectre_v2_select_retpoline();
 		break;
 
+	case SPECTRE_V2_CMD_IBRS:
+		mode = SPECTRE_V2_IBRS;
+		break;
+
 	case SPECTRE_V2_CMD_EIBRS:
 		mode = SPECTRE_V2_EIBRS;
 		break;
@@ -1198,7 +1232,7 @@ static void __init spectre_v2_select_mitigation(void)
 	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
-	if (spectre_v2_in_eibrs_mode(mode)) {
+	if (spectre_v2_in_ibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 		write_spec_ctrl_current(x86_spec_ctrl_base, true);
@@ -1209,6 +1243,10 @@ static void __init spectre_v2_select_mitigation(void)
 	case SPECTRE_V2_EIBRS:
 		break;
 
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		break;
+
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_EIBRS_LFENCE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
@@ -1235,17 +1273,17 @@ static void __init spectre_v2_select_mitigation(void)
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
 	/*
-	 * Retpoline means the kernel is safe because it has no indirect
-	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
-	 * speculation around firmware calls only when Enhanced IBRS isn't
-	 * supported.
+	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
+	 * and Enhanced IBRS protect firmware too, so enable IBRS around
+	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
+	 * enabled.
 	 *
 	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
 	 * the user might select retpoline on the kernel command line and if
 	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
 	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_eibrs_mode(mode)) {
+	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
@@ -1951,7 +1989,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
-- 
2.34.1


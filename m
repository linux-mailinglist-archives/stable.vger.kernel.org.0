Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8876F57DDE9
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiGVJWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbiGVJVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:21:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28A4AF731;
        Fri, 22 Jul 2022 02:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E913B827C6;
        Fri, 22 Jul 2022 09:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1513C341CA;
        Fri, 22 Jul 2022 09:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481256;
        bh=X/4QCstTlTlNBBmAg+VN5BgPZKZQwVUj0R+jS+Vvhlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB5UwyQFC555T4Ulpgd5AvsFq50cIErl49i+/pso5VDplhJqoiMaidBfhib2xrI5J
         t1zn65hBhds0eOzUCm0Pq+VnzP1Arjahh4tTfHZFpa86beBQEu+IwRMe22MaDXMCW2
         prBDhIV9oHozzJeRwj5DvUOLaC/PM0nWYs0qIuyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 48/89] x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS
Date:   Fri, 22 Jul 2022 11:11:22 +0200
Message-Id: <20220722091136.055625548@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    1 
 arch/x86/include/asm/nospec-branch.h            |    1 
 arch/x86/kernel/cpu/bugs.c                      |   66 ++++++++++++++++++------
 3 files changed, 54 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5335,6 +5335,7 @@
 			eibrs		  - enhanced IBRS
 			eibrs,retpoline   - enhanced IBRS + Retpolines
 			eibrs,lfence      - enhanced IBRS + LFENCE
+			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -212,6 +212,7 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_EIBRS,
 	SPECTRE_V2_EIBRS_RETPOLINE,
 	SPECTRE_V2_EIBRS_LFENCE,
+	SPECTRE_V2_IBRS,
 };
 
 /* The indirect branch speculation control variants */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -965,6 +965,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_EIBRS,
 	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
 	SPECTRE_V2_CMD_EIBRS_LFENCE,
+	SPECTRE_V2_CMD_IBRS,
 };
 
 enum spectre_v2_user_cmd {
@@ -1037,11 +1038,12 @@ spectre_v2_parse_user_cmdline(enum spect
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
@@ -1106,12 +1108,12 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -1143,6 +1145,7 @@ static const char * const spectre_v2_str
 	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
+	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
 };
 
 static const struct {
@@ -1160,6 +1163,7 @@ static const struct {
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
+	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
 };
 
 static void __init spec_v2_print_cond(const char *reason, bool secure)
@@ -1222,6 +1226,24 @@ static enum spectre_v2_mitigation_cmd __
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
@@ -1261,6 +1283,14 @@ static void __init spectre_v2_select_mit
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
 
@@ -1277,6 +1307,10 @@ static void __init spectre_v2_select_mit
 		mode = spectre_v2_select_retpoline();
 		break;
 
+	case SPECTRE_V2_CMD_IBRS:
+		mode = SPECTRE_V2_IBRS;
+		break;
+
 	case SPECTRE_V2_CMD_EIBRS:
 		mode = SPECTRE_V2_EIBRS;
 		break;
@@ -1293,7 +1327,7 @@ static void __init spectre_v2_select_mit
 	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
-	if (spectre_v2_in_eibrs_mode(mode)) {
+	if (spectre_v2_in_ibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 		write_spec_ctrl_current(x86_spec_ctrl_base, true);
@@ -1304,6 +1338,10 @@ static void __init spectre_v2_select_mit
 	case SPECTRE_V2_EIBRS:
 		break;
 
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		break;
+
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_EIBRS_LFENCE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
@@ -1330,17 +1368,17 @@ static void __init spectre_v2_select_mit
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
@@ -2082,7 +2120,7 @@ static ssize_t mmio_stale_data_show_stat
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {



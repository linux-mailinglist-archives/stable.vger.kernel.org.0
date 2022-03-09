Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3740F4D333E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiCIQL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiCIQJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110A559A78;
        Wed,  9 Mar 2022 08:07:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5A4061797;
        Wed,  9 Mar 2022 16:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB802C340E8;
        Wed,  9 Mar 2022 16:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842064;
        bh=xP2qSKgtr8/+XKIYr8zHTtFIOH8SJRkosgwCc220Zlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VDZVd2FUxj8eblbDreLkxMG0wFclw0+PWLPeM6vFXYe4GKOGsLYZ6CxJzvmA7ST/
         7X2w51KW7cLriaRf3hUShz63ljV66IECfLMCdWxRz5tFGCXY3tQm6aXPhE2GiaEqLU
         3U/lOl2utwYDd1kYiz3JSxXyEhMDpZKqZl10GB1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Patrick Colp <patrick.colp@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 03/43] x86/speculation: Add eIBRS + Retpoline options
Date:   Wed,  9 Mar 2022 16:59:47 +0100
Message-Id: <20220309155859.837339341@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 1e19da8522c81bf46b335f84137165741e0d82b7 upstream.

Thanks to the chaps at VUsec it is now clear that eIBRS is not
sufficient, therefore allow enabling of retpolines along with eIBRS.

Add spectre_v2=eibrs, spectre_v2=eibrs,lfence and
spectre_v2=eibrs,retpoline options to explicitly pick your preferred
means of mitigation.

Since there's new mitigations there's also user visible changes in
/sys/devices/system/cpu/vulnerabilities/spectre_v2 to reflect these
new mitigations.

  [ bp: Massage commit message, trim error messages,
    do more precise eIBRS mode checking. ]

Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Patrick Colp <patrick.colp@oracle.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 -
 arch/x86/kernel/cpu/bugs.c           |  133 +++++++++++++++++++++++++----------
 2 files changed, 99 insertions(+), 38 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -177,7 +177,9 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_NONE,
 	SPECTRE_V2_RETPOLINE,
 	SPECTRE_V2_LFENCE,
-	SPECTRE_V2_IBRS_ENHANCED,
+	SPECTRE_V2_EIBRS,
+	SPECTRE_V2_EIBRS_RETPOLINE,
+	SPECTRE_V2_EIBRS_LFENCE,
 };
 
 /* The indirect branch speculation control variants */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -665,6 +665,9 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_RETPOLINE,
 	SPECTRE_V2_CMD_RETPOLINE_GENERIC,
 	SPECTRE_V2_CMD_RETPOLINE_LFENCE,
+	SPECTRE_V2_CMD_EIBRS,
+	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
+	SPECTRE_V2_CMD_EIBRS_LFENCE,
 };
 
 enum spectre_v2_user_cmd {
@@ -737,6 +740,13 @@ spectre_v2_parse_user_cmdline(enum spect
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return (mode == SPECTRE_V2_EIBRS ||
+		mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+		mode == SPECTRE_V2_EIBRS_LFENCE);
+}
+
 static void __init
 spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 {
@@ -804,7 +814,7 @@ spectre_v2_user_select_mitigation(enum s
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -826,7 +836,9 @@ static const char * const spectre_v2_str
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
 	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
-	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
+	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
+	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
 };
 
 static const struct {
@@ -840,6 +852,9 @@ static const struct {
 	{ "retpoline,amd",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
+	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
+	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
+	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 };
 
@@ -877,15 +892,29 @@ static enum spectre_v2_mitigation_cmd __
 
 	if ((cmd == SPECTRE_V2_CMD_RETPOLINE ||
 	     cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE ||
-	     cmd == SPECTRE_V2_CMD_RETPOLINE_GENERIC) &&
+	     cmd == SPECTRE_V2_CMD_RETPOLINE_GENERIC ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
 	    !IS_ENABLED(CONFIG_RETPOLINE)) {
-		pr_err("%s selected but not compiled in. Switching to AUTO select\n", mitigation_options[i].option);
+		pr_err("%s selected but not compiled in. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
+	if ((cmd == SPECTRE_V2_CMD_EIBRS ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
+	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
+		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
-	if ((cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE) &&
+	if ((cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE ||
+	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE) &&
 	    !boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
-		pr_err("%s selected, but CPU doesn't have a serializing LFENCE. Switching to AUTO select\n", mitigation_options[i].option);
+		pr_err("%s selected, but CPU doesn't have a serializing LFENCE. Switching to AUTO select\n",
+		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
@@ -894,6 +923,25 @@ static enum spectre_v2_mitigation_cmd __
 	return cmd;
 }
 
+static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
+{
+	if (!IS_ENABLED(CONFIG_RETPOLINE)) {
+		pr_err("Kernel not compiled with retpoline; no mitigation available!");
+		return SPECTRE_V2_NONE;
+	}
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
+		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
+			pr_err("LFENCE not serializing, switching to generic retpoline\n");
+			return SPECTRE_V2_RETPOLINE;
+		}
+		return SPECTRE_V2_LFENCE;
+	}
+
+	return SPECTRE_V2_RETPOLINE;
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -914,49 +962,60 @@ static void __init spectre_v2_select_mit
 	case SPECTRE_V2_CMD_FORCE:
 	case SPECTRE_V2_CMD_AUTO:
 		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-			mode = SPECTRE_V2_IBRS_ENHANCED;
-			/* Force it so VMEXIT will restore correctly */
-			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
-			goto specv2_set_mode;
+			mode = SPECTRE_V2_EIBRS;
+			break;
 		}
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_auto;
+
+		mode = spectre_v2_select_retpoline();
 		break;
+
 	case SPECTRE_V2_CMD_RETPOLINE_LFENCE:
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_lfence;
+		mode = SPECTRE_V2_LFENCE;
 		break;
+
 	case SPECTRE_V2_CMD_RETPOLINE_GENERIC:
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_generic;
+		mode = SPECTRE_V2_RETPOLINE;
 		break;
+
 	case SPECTRE_V2_CMD_RETPOLINE:
-		if (IS_ENABLED(CONFIG_RETPOLINE))
-			goto retpoline_auto;
+		mode = spectre_v2_select_retpoline();
+		break;
+
+	case SPECTRE_V2_CMD_EIBRS:
+		mode = SPECTRE_V2_EIBRS;
+		break;
+
+	case SPECTRE_V2_CMD_EIBRS_LFENCE:
+		mode = SPECTRE_V2_EIBRS_LFENCE;
+		break;
+
+	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
+		mode = SPECTRE_V2_EIBRS_RETPOLINE;
 		break;
 	}
-	pr_err("Spectre mitigation: kernel not compiled with retpoline; no mitigation available!");
-	return;
 
-retpoline_auto:
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
-	    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON) {
-	retpoline_lfence:
-		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
-			pr_err("Spectre mitigation: LFENCE not serializing, switching to generic retpoline\n");
-			goto retpoline_generic;
-		}
-		mode = SPECTRE_V2_LFENCE;
+	if (spectre_v2_in_eibrs_mode(mode)) {
+		/* Force it so VMEXIT will restore correctly */
+		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	}
+
+	switch (mode) {
+	case SPECTRE_V2_NONE:
+	case SPECTRE_V2_EIBRS:
+		break;
+
+	case SPECTRE_V2_LFENCE:
+	case SPECTRE_V2_EIBRS_LFENCE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_LFENCE);
+		fallthrough;
+
+	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
-	} else {
-	retpoline_generic:
-		mode = SPECTRE_V2_RETPOLINE;
-		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
+		break;
 	}
 
-specv2_set_mode:
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
@@ -982,7 +1041,7 @@ specv2_set_mode:
 	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
 	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS) && mode != SPECTRE_V2_IBRS_ENHANCED) {
+	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_eibrs_mode(mode)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
@@ -1691,7 +1750,7 @@ static ssize_t tsx_async_abort_show_stat
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A685724FD
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiGLTKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235724AbiGLTJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:09:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0090E52A7;
        Tue, 12 Jul 2022 11:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5999F61491;
        Tue, 12 Jul 2022 18:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BECCC3411C;
        Tue, 12 Jul 2022 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651925;
        bh=TEcxcJgB66C9IgE6OOc7xNQy28ai4Uvq6zolBbutTG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B53azI4Dxv6iHXedGNxrIv8d1CzBHQyrsGqmzzYu0w1gMnB19K2rP4ZiV+I4lm+Wl
         S9Es/HtfkAluAc3BSk7dsInU5icN3HTHJ2QTv2TOuLVhrQfSaD65rDUHLl+erfOIHx
         s70ux2pkwW1eSHAq3hdx7uX7zaWCiCHUtgIRMFFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 25/61] x86/bugs: Add AMD retbleed= boot parameter
Date:   Tue, 12 Jul 2022 20:39:22 +0200
Message-Id: <20220712183237.961160770@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Chartre <alexandre.chartre@oracle.com>

commit 7fbf47c7ce50b38a64576b150e7011ae73d54669 upstream.

Add the "retbleed=<value>" boot parameter to select a mitigation for
RETBleed. Possible values are "off", "auto" and "unret"
(JMP2RET mitigation). The default value is "auto".

Currently, "retbleed=auto" will select the unret mitigation on
AMD and Hygon and no mitigation on Intel (JMP2RET is not effective on
Intel).

  [peterz: rebase; add hygon]
  [jpoimboe: cleanups]

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |   15 +++
 arch/x86/Kconfig                                |    3 
 arch/x86/kernel/cpu/bugs.c                      |  108 +++++++++++++++++++++++-
 3 files changed, 125 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5124,6 +5124,21 @@
 
 	retain_initrd	[RAM] Keep initrd memory after extraction
 
+	retbleed=	[X86] Control mitigation of RETBleed (Arbitrary
+			Speculative Code Execution with Return Instructions)
+			vulnerability.
+
+			off         - unconditionally disable
+			auto        - automatically select a migitation
+			unret       - force enable untrained return thunks,
+				      only effective on AMD Zen {1,2}
+				      based systems.
+
+			Selecting 'auto' will choose a mitigation method at run
+			time according to the CPU.
+
+			Not specifying this option is equivalent to retbleed=auto.
+
 	rfkill.default_state=
 		0	"airplane mode".  All wifi, bluetooth, wimax, gps, fm,
 			etc. communication is blocked by default.
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -469,6 +469,9 @@ config RETPOLINE
 config CC_HAS_SLS
 	def_bool $(cc-option,-mharden-sls=all)
 
+config CC_HAS_RETURN_THUNK
+	def_bool $(cc-option,-mfunction-return=thunk-extern)
+
 config SLS
 	bool "Mitigate Straight-Line-Speculation"
 	depends on CC_HAS_SLS && X86_64
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -37,6 +37,7 @@
 #include "cpu.h"
 
 static void __init spectre_v1_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
@@ -120,6 +121,12 @@ void __init check_bugs(void)
 
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
+	retbleed_select_mitigation();
+	/*
+	 * spectre_v2_select_mitigation() relies on the state set by
+	 * retbleed_select_mitigation(); specifically the STIBP selection is
+	 * forced for UNRET.
+	 */
 	spectre_v2_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
@@ -746,6 +753,100 @@ static int __init nospectre_v1_cmdline(c
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
 #undef pr_fmt
+#define pr_fmt(fmt)     "RETBleed: " fmt
+
+enum retbleed_mitigation {
+	RETBLEED_MITIGATION_NONE,
+	RETBLEED_MITIGATION_UNRET,
+};
+
+enum retbleed_mitigation_cmd {
+	RETBLEED_CMD_OFF,
+	RETBLEED_CMD_AUTO,
+	RETBLEED_CMD_UNRET,
+};
+
+const char * const retbleed_strings[] = {
+	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
+	[RETBLEED_MITIGATION_UNRET]	= "Mitigation: untrained return thunk",
+};
+
+static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
+	RETBLEED_MITIGATION_NONE;
+static enum retbleed_mitigation_cmd retbleed_cmd __ro_after_init =
+	RETBLEED_CMD_AUTO;
+
+static int __init retbleed_parse_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "off"))
+		retbleed_cmd = RETBLEED_CMD_OFF;
+	else if (!strcmp(str, "auto"))
+		retbleed_cmd = RETBLEED_CMD_AUTO;
+	else if (!strcmp(str, "unret"))
+		retbleed_cmd = RETBLEED_CMD_UNRET;
+	else
+		pr_err("Unknown retbleed option (%s). Defaulting to 'auto'\n", str);
+
+	return 0;
+}
+early_param("retbleed", retbleed_parse_cmdline);
+
+#define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
+#define RETBLEED_COMPILER_MSG "WARNING: kernel not compiled with RETPOLINE or -mfunction-return capable compiler!\n"
+
+static void __init retbleed_select_mitigation(void)
+{
+	if (!boot_cpu_has_bug(X86_BUG_RETBLEED) || cpu_mitigations_off())
+		return;
+
+	switch (retbleed_cmd) {
+	case RETBLEED_CMD_OFF:
+		return;
+
+	case RETBLEED_CMD_UNRET:
+		retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+		break;
+
+	case RETBLEED_CMD_AUTO:
+	default:
+		if (!boot_cpu_has_bug(X86_BUG_RETBLEED))
+			break;
+
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+		    boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)
+			retbleed_mitigation = RETBLEED_MITIGATION_UNRET;
+		break;
+	}
+
+	switch (retbleed_mitigation) {
+	case RETBLEED_MITIGATION_UNRET:
+
+		if (!IS_ENABLED(CONFIG_RETPOLINE) ||
+		    !IS_ENABLED(CONFIG_CC_HAS_RETURN_THUNK)) {
+			pr_err(RETBLEED_COMPILER_MSG);
+			retbleed_mitigation = RETBLEED_MITIGATION_NONE;
+			break;
+		}
+
+		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
+		setup_force_cpu_cap(X86_FEATURE_UNRET);
+
+		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+			pr_err(RETBLEED_UNTRAIN_MSG);
+		break;
+
+	default:
+		break;
+	}
+
+	pr_info("%s\n", retbleed_strings[retbleed_mitigation]);
+}
+
+#undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
 static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
@@ -1989,7 +2090,12 @@ static ssize_t srbds_show_state(char *bu
 
 static ssize_t retbleed_show_state(char *buf)
 {
-	return sprintf(buf, "Vulnerable\n");
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET &&
+	    (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+	     boot_cpu_data.x86_vendor != X86_VENDOR_HYGON))
+		return sprintf(buf, "Vulnerable: untrained return thunk on non-Zen uarch\n");
+
+	return sprintf(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
 }
 
 static ssize_t cpu_show_common(struct device *dev, struct device_attribute *attr,



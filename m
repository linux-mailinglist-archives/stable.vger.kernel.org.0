Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9F357AC09
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbiGTBSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbiGTBRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:17:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAB66B778;
        Tue, 19 Jul 2022 18:14:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B74CFB81DE2;
        Wed, 20 Jul 2022 01:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F46EC341CF;
        Wed, 20 Jul 2022 01:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279671;
        bh=MDKVOauRHGJ/D/oj1cTxiUs775+YxuzscTSEc584fhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+l9CFYXKqo0aT9gP9fjlIlfMsI/0jeURnC6Ns7bO0XnBuc/NA9bX9rdh0SkEnCkK
         v1635mNINv8fH82pJfU7yMTM76rJIK1PhHAqPp/QgKG2BVSLg9I9Tyo1WLL978JT1Z
         gEFvndMCHgVJzOLUb07zVVj8491NOGhdETvS2/CTrru8Guydk7rkrpK5oV9Mmu0ZWt
         vcnDFIbVPbPFW8eSyP+KcCdguH6bPYlJbKYt9+Q6OZ/mHzZKK1sdeSus9tbjI3EyAV
         KKuaDx0+jAMMM7a2wBrpae+kdafPaqdGTeie4YFyO0lTCMAvjKCzCIF2OjFLue3ZWB
         ZP8A6vQvG6x8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, paulmck@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, damien.lemoal@opensource.wdc.com,
        jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
        alexandre.chartre@oracle.com, sblbir@amazon.com,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 11/42] x86/bugs: Enable STIBP for JMP2RET
Date:   Tue, 19 Jul 2022 21:13:19 -0400
Message-Id: <20220720011350.1024134-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit e8ec1b6e08a2102d8755ccb06fa26d540f26a2fa ]

For untrained return thunks to be fully effective, STIBP must be enabled
or SMT disabled.

Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         | 16 +++--
 arch/x86/kernel/cpu/bugs.c                    | 58 +++++++++++++++----
 2 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 961843aa8403..998420529fbc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4972,11 +4972,17 @@
 			Speculative Code Execution with Return Instructions)
 			vulnerability.
 
-			off         - unconditionally disable
-			auto        - automatically select a migitation
-			unret       - force enable untrained return thunks,
-				      only effective on AMD Zen {1,2}
-				      based systems.
+			off          - no mitigation
+			auto         - automatically select a migitation
+			auto,nosmt   - automatically select a mitigation,
+				       disabling SMT if necessary for
+				       the full mitigation (only on Zen1
+				       and older without STIBP).
+			unret        - force enable untrained return thunks,
+				       only effective on AMD f15h-f17h
+				       based systems.
+			unret,nosmt  - like unret, will disable SMT when STIBP
+			               is not available.
 
 			Selecting 'auto' will choose a mitigation method at run
 			time according to the CPU.
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 3e01a88f7d5d..27bb40a718ae 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -776,19 +776,34 @@ static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
 static enum retbleed_mitigation_cmd retbleed_cmd __ro_after_init =
 	RETBLEED_CMD_AUTO;
 
+static int __ro_after_init retbleed_nosmt = false;
+
 static int __init retbleed_parse_cmdline(char *str)
 {
 	if (!str)
 		return -EINVAL;
 
-	if (!strcmp(str, "off"))
-		retbleed_cmd = RETBLEED_CMD_OFF;
-	else if (!strcmp(str, "auto"))
-		retbleed_cmd = RETBLEED_CMD_AUTO;
-	else if (!strcmp(str, "unret"))
-		retbleed_cmd = RETBLEED_CMD_UNRET;
-	else
-		pr_err("Unknown retbleed option (%s). Defaulting to 'auto'\n", str);
+	while (str) {
+		char *next = strchr(str, ',');
+		if (next) {
+			*next = 0;
+			next++;
+		}
+
+		if (!strcmp(str, "off")) {
+			retbleed_cmd = RETBLEED_CMD_OFF;
+		} else if (!strcmp(str, "auto")) {
+			retbleed_cmd = RETBLEED_CMD_AUTO;
+		} else if (!strcmp(str, "unret")) {
+			retbleed_cmd = RETBLEED_CMD_UNRET;
+		} else if (!strcmp(str, "nosmt")) {
+			retbleed_nosmt = true;
+		} else {
+			pr_err("Ignoring unknown retbleed option (%s).", str);
+		}
+
+		str = next;
+	}
 
 	return 0;
 }
@@ -834,6 +849,10 @@ static void __init retbleed_select_mitigation(void)
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		setup_force_cpu_cap(X86_FEATURE_UNRET);
 
+		if (!boot_cpu_has(X86_FEATURE_STIBP) &&
+		    (retbleed_nosmt || cpu_mitigations_auto_nosmt()))
+			cpu_smt_disable(false);
+
 		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
 			pr_err(RETBLEED_UNTRAIN_MSG);
@@ -1080,6 +1099,13 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+		if (mode != SPECTRE_V2_USER_STRICT &&
+		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
+			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation'\n");
+		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
+	}
+
 	spectre_v2_user_stibp = mode;
 
 set_mode:
@@ -2090,10 +2116,18 @@ static ssize_t srbds_show_state(char *buf)
 
 static ssize_t retbleed_show_state(char *buf)
 {
-	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET &&
-	    (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
-	     boot_cpu_data.x86_vendor != X86_VENDOR_HYGON))
-		return sprintf(buf, "Vulnerable: untrained return thunk on non-Zen uarch\n");
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	    if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
+		boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
+		    return sprintf(buf, "Vulnerable: untrained return thunk on non-Zen uarch\n");
+
+	    return sprintf(buf, "%s; SMT %s\n",
+			   retbleed_strings[retbleed_mitigation],
+			   !sched_smt_active() ? "disabled" :
+			   spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
+			   spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ?
+			   "enabled with STIBP protection" : "vulnerable");
+	}
 
 	return sprintf(buf, "%s\n", retbleed_strings[retbleed_mitigation]);
 }
-- 
2.35.1


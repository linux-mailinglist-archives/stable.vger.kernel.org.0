Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322265723FE
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbiGLSxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiGLSxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:53:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3322D6CE9;
        Tue, 12 Jul 2022 11:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 315DBB81B95;
        Tue, 12 Jul 2022 18:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA13C3411C;
        Tue, 12 Jul 2022 18:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651510;
        bh=r1KYi8CpJ9PMhlMf7z/gAKIbGBUAcbhymfilRfURaEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CerL0ISsYeiT3nlrgOoURe9xgALvXWhycIiYg/vbPmGEqI+8BVpIIpRuolbFRL2Vd
         RXHMitI/RSzbhRWnJfi5OYVxmppgpE1qO0TSanNs4o38Y4khu8pAAaYI3mURmVAdn2
         85ajo3VgW1Cgh3cPWjnf3Rum/xGlxtBsAorFGb0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 098/130] x86/bugs: Enable STIBP for JMP2RET
Date:   Tue, 12 Jul 2022 20:39:04 +0200
Message-Id: <20220712183250.985296948@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

From: Kim Phillips <kim.phillips@amd.com>

commit e8ec1b6e08a2102d8755ccb06fa26d540f26a2fa upstream.

For untrained return thunks to be fully effective, STIBP must be enabled
or SMT disabled.

Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |   16 ++++--
 arch/x86/kernel/cpu/bugs.c                      |   58 +++++++++++++++++++-----
 2 files changed, 57 insertions(+), 17 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4660,11 +4660,17 @@
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
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -739,19 +739,34 @@ static enum retbleed_mitigation retbleed
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
@@ -797,6 +812,10 @@ static void __init retbleed_select_mitig
 		setup_force_cpu_cap(X86_FEATURE_RETHUNK);
 		setup_force_cpu_cap(X86_FEATURE_UNRET);
 
+		if (!boot_cpu_has(X86_FEATURE_STIBP) &&
+		    (retbleed_nosmt || cpu_mitigations_auto_nosmt()))
+			cpu_smt_disable(false);
+
 		if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
 			pr_err(RETBLEED_UNTRAIN_MSG);
@@ -1043,6 +1062,13 @@ spectre_v2_user_select_mitigation(enum s
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
@@ -2020,10 +2046,18 @@ static ssize_t srbds_show_state(char *bu
 
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



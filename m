Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BB557AC59
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbiGTBTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241362AbiGTBSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:18:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7256FD8F;
        Tue, 19 Jul 2022 18:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 140A4B81DE3;
        Wed, 20 Jul 2022 01:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBDAC341CB;
        Wed, 20 Jul 2022 01:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279688;
        bh=tt//DfZUzL9cum2aE1NuqVo8+WIRKq8peSgGbEYXEFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSTwJZCC5AodT2jpb5jdQH0q3AMICxW6oPZF1n6ioOWCiSsrJuF1z9qVWtSewbAi7
         Sih6i0+G0xW7mUol9oAltAqBYzEvsJl/wzLWPGJA3grB1o9HbS+ewoueopuMXSFFnY
         rB97XHnF55CzolBtcV37XbsQZv3LXVEma6qgsMM4aL4rdOCzj2PyslFSTVaZyvWfN/
         245z/K7cBvNYbv2zY5pLCOhltGeuKwDUMsbhw1r6jQzUXWeafOrjMFbkqSrh4Ht84e
         jN7KAfHXACfcc4N6vnpSKmRa+TMSHnLh+teVjwd6pvvQAsOc4YxGpzXPOpSpHC66oS
         q5r81Rv7SkhXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        sblbir@amazon.com
Subject: [PATCH AUTOSEL 5.15 14/42] x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
Date:   Tue, 19 Jul 2022 21:13:22 -0400
Message-Id: <20220720011350.1024134-14-sashal@kernel.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 166115c08a9b0b846b783088808a27d739be6e8d ]

retbleed will depend on spectre_v2, while spectre_v2_user depends on
retbleed. Break this cycle.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ae7715385153..7637318f3b7e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -37,8 +37,9 @@
 #include "cpu.h"
 
 static void __init spectre_v1_select_mitigation(void);
-static void __init retbleed_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
+static void __init spectre_v2_user_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
@@ -145,13 +146,19 @@ void __init check_bugs(void)
 
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
+	spectre_v2_select_mitigation();
+	/*
+	 * retbleed_select_mitigation() relies on the state set by
+	 * spectre_v2_select_mitigation(); specifically it wants to know about
+	 * spectre_v2=ibrs.
+	 */
 	retbleed_select_mitigation();
 	/*
-	 * spectre_v2_select_mitigation() relies on the state set by
+	 * spectre_v2_user_select_mitigation() relies on the state set by
 	 * retbleed_select_mitigation(); specifically the STIBP selection is
 	 * forced for UNRET.
 	 */
-	spectre_v2_select_mitigation();
+	spectre_v2_user_select_mitigation();
 	ssb_select_mitigation();
 	l1tf_select_mitigation();
 	md_clear_select_mitigation();
@@ -1005,13 +1012,15 @@ static void __init spec_v2_user_print_cond(const char *reason, bool secure)
 		pr_info("spectre_v2_user=%s forced on command line.\n", reason);
 }
 
+static __ro_after_init enum spectre_v2_mitigation_cmd spectre_v2_cmd;
+
 static enum spectre_v2_user_cmd __init
-spectre_v2_parse_user_cmdline(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_parse_user_cmdline(void)
 {
 	char arg[20];
 	int ret, i;
 
-	switch (v2_cmd) {
+	switch (spectre_v2_cmd) {
 	case SPECTRE_V2_CMD_NONE:
 		return SPECTRE_V2_USER_CMD_NONE;
 	case SPECTRE_V2_CMD_FORCE:
@@ -1045,7 +1054,7 @@ static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
 }
 
 static void __init
-spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_user_select_mitigation(void)
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
@@ -1058,7 +1067,7 @@ spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
 	    cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
 		smt_possible = false;
 
-	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	cmd = spectre_v2_parse_user_cmdline();
 	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
@@ -1346,7 +1355,7 @@ static void __init spectre_v2_select_mitigation(void)
 	}
 
 	/* Set up IBPB and STIBP depending on the general spectre V2 command */
-	spectre_v2_user_select_mitigation(cmd);
+	spectre_v2_cmd = cmd;
 }
 
 static void update_stibp_msr(void * __unused)
-- 
2.35.1


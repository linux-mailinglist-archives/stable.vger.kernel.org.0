Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEC657250D
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiGLTKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiGLTJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:09:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6148FE539;
        Tue, 12 Jul 2022 11:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AC83B81BAC;
        Tue, 12 Jul 2022 18:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB41FC3411C;
        Tue, 12 Jul 2022 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651947;
        bh=LkVA0xiAiMwnxQTu6pYRQJruQNd4vWhOLkXE1iKbhYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0j3uOvNtjjp2Ls9W5/n/8b1rOGPYOSFYQV1FvV13DydSitqT93FkDr2bsxlbupUl
         VVOGqS3o+Jk06WtSx76uMoD7bC8ZMKWeiPqDZ18R3tQJk5NE6MJ1d7PkxdtgFEJpvF
         0PIbvjf8kQ2Bt0+1OBepYLdcr309+PsMDWYouTyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 31/61] x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
Date:   Tue, 12 Jul 2022 20:39:28 +0200
Message-Id: <20220712183238.217475302@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 166115c08a9b0b846b783088808a27d739be6e8d upstream.

retbleed will depend on spectre_v2, while spectre_v2_user depends on
retbleed. Break this cycle.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

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
@@ -1006,13 +1013,15 @@ static void __init spec_v2_user_print_co
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
@@ -1047,7 +1056,7 @@ static inline bool spectre_v2_in_ibrs_mo
 }
 
 static void __init
-spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_user_select_mitigation(void)
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
@@ -1060,7 +1069,7 @@ spectre_v2_user_select_mitigation(enum s
 	    cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
 		smt_possible = false;
 
-	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	cmd = spectre_v2_parse_user_cmdline();
 	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
@@ -1384,7 +1393,7 @@ static void __init spectre_v2_select_mit
 	}
 
 	/* Set up IBPB and STIBP depending on the general spectre V2 command */
-	spectre_v2_user_select_mitigation(cmd);
+	spectre_v2_cmd = cmd;
 }
 
 static void update_stibp_msr(void * __unused)



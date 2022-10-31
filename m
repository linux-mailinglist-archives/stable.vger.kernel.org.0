Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB46F6130E5
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 08:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiJaHDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 03:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJaHCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 03:02:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AB7BE25
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 00:02:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F5CB60FF8
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8323EC433D6;
        Mon, 31 Oct 2022 07:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667199765;
        bh=C/NT4nFCeIQCEW2jbrg+VIVmnqZObc1x8TS26bDk8AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKjSfLv0POoElddlzXfcwhy3gpEGGCyoqYVlsuxp9ogtHQtrc93UaJSnWQ/O5mn9Z
         qNvRQD+J4qG3COBwyLe1sD2uROF8bXY8xAODixfkwrDPUydyMN0JwQo6NXkqd2SDhk
         NKFX7Tnm1wcHEVHtmKLKwiwOSxlBm96F70olMEa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.14 15/34] x86/bugs: Split spectre_v2_select_mitigation() and spectre_v2_user_select_mitigation()
Date:   Mon, 31 Oct 2022 08:02:48 +0100
Message-Id: <20221031070140.471572649@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070140.108124105@linuxfoundation.org>
References: <20221031070140.108124105@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -36,8 +36,9 @@
 #include "cpu.h"
 
 static void __init spectre_v1_select_mitigation(void);
-static void __init retbleed_select_mitigation(void);
 static void __init spectre_v2_select_mitigation(void);
+static void __init retbleed_select_mitigation(void);
+static void __init spectre_v2_user_select_mitigation(void);
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
@@ -136,13 +137,19 @@ void __init check_bugs(void)
 
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
@@ -914,13 +921,15 @@ static void __init spec_v2_user_print_co
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
@@ -955,7 +964,7 @@ static inline bool spectre_v2_in_ibrs_mo
 }
 
 static void __init
-spectre_v2_user_select_mitigation(enum spectre_v2_mitigation_cmd v2_cmd)
+spectre_v2_user_select_mitigation(void)
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
@@ -968,7 +977,7 @@ spectre_v2_user_select_mitigation(enum s
 	    cpu_smt_control == CPU_SMT_NOT_SUPPORTED)
 		smt_possible = false;
 
-	cmd = spectre_v2_parse_user_cmdline(v2_cmd);
+	cmd = spectre_v2_parse_user_cmdline();
 	switch (cmd) {
 	case SPECTRE_V2_USER_CMD_NONE:
 		goto set_mode;
@@ -1285,7 +1294,7 @@ static void __init spectre_v2_select_mit
 	}
 
 	/* Set up IBPB and STIBP depending on the general spectre V2 command */
-	spectre_v2_user_select_mitigation(cmd);
+	spectre_v2_cmd = cmd;
 }
 
 static void update_stibp_msr(void * __unused)



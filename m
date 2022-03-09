Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E274D3278
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiCIQCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiCIQCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCC8175852;
        Wed,  9 Mar 2022 08:01:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9222B8214F;
        Wed,  9 Mar 2022 16:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3E5C340E8;
        Wed,  9 Mar 2022 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841660;
        bh=HSc3wFtLjti/d4eRAAzuyhTWC1ahVbUMNGqKeSkzAyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ7sUY3fvn4DW0U99k2QjRIPRoIoDCYWdEBKctBdiGZ7a9rU2UpDDrsraYJTJDpmI
         ERKtPm+Ecn4ycVb1mZxKq9sjfH1jRZ6dhuWrod7y6SvgdQ5isKrkiDm07guzJ4H9jq
         NqNBQdQ+E1Mu33CiKP8YVYyXnsVZyX0IfrjjjlIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        srinivas.eeda@oracle.com, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 03/24] x86/retpoline: Remove minimal retpoline support
Date:   Wed,  9 Mar 2022 16:59:16 +0100
Message-Id: <20220309155856.398762008@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
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

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit ef014aae8f1cd2793e4e014bbb102bed53f852b7 upstream.

Now that CONFIG_RETPOLINE hard depends on compiler support, there is no
reason to keep the minimal retpoline support around which only provided
basic protection in the assembly files.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Borislav Petkov <bp@suse.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: <srinivas.eeda@oracle.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/f06f0a89-5587-45db-8ed2-0a9d6638d5c0@default
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    2 --
 arch/x86/kernel/cpu/bugs.c           |   13 ++-----------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -223,8 +223,6 @@
 /* The Spectre V2 mitigation variants */
 enum spectre_v2_mitigation {
 	SPECTRE_V2_NONE,
-	SPECTRE_V2_RETPOLINE_MINIMAL,
-	SPECTRE_V2_RETPOLINE_MINIMAL_AMD,
 	SPECTRE_V2_RETPOLINE_GENERIC,
 	SPECTRE_V2_RETPOLINE_AMD,
 	SPECTRE_V2_IBRS_ENHANCED,
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -784,8 +784,6 @@ set_mode:
 
 static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
-	[SPECTRE_V2_RETPOLINE_MINIMAL]		= "Vulnerable: Minimal generic ASM retpoline",
-	[SPECTRE_V2_RETPOLINE_MINIMAL_AMD]	= "Vulnerable: Minimal AMD ASM retpoline",
 	[SPECTRE_V2_RETPOLINE_GENERIC]		= "Mitigation: Full generic retpoline",
 	[SPECTRE_V2_RETPOLINE_AMD]		= "Mitigation: Full AMD retpoline",
 	[SPECTRE_V2_IBRS_ENHANCED]		= "Mitigation: Enhanced IBRS",
@@ -810,11 +808,6 @@ static void __init spec_v2_print_cond(co
 		pr_info("%s selected on command line.\n", reason);
 }
 
-static inline bool retp_compiler(void)
-{
-	return __is_defined(CONFIG_RETPOLINE);
-}
-
 static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = SPECTRE_V2_CMD_AUTO;
@@ -912,14 +905,12 @@ retpoline_auto:
 			pr_err("Spectre mitigation: LFENCE not serializing, switching to generic retpoline\n");
 			goto retpoline_generic;
 		}
-		mode = retp_compiler() ? SPECTRE_V2_RETPOLINE_AMD :
-					 SPECTRE_V2_RETPOLINE_MINIMAL_AMD;
+		mode = SPECTRE_V2_RETPOLINE_AMD;
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE_AMD);
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	} else {
 	retpoline_generic:
-		mode = retp_compiler() ? SPECTRE_V2_RETPOLINE_GENERIC :
-					 SPECTRE_V2_RETPOLINE_MINIMAL;
+		mode = SPECTRE_V2_RETPOLINE_GENERIC;
 		setup_force_cpu_cap(X86_FEATURE_RETPOLINE);
 	}
 



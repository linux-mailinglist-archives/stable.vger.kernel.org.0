Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5754D4C1A
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243092AbiCJO0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243503AbiCJOZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:25:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B958B7C7D;
        Thu, 10 Mar 2022 06:22:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E5E61CEF;
        Thu, 10 Mar 2022 14:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5D4C340E8;
        Thu, 10 Mar 2022 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922109;
        bh=cam9jz1lhBQ1bzbDOOb5/sES4ZWRJgbU5/7XX53WJgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfGPR7nTCLN/sUtzVCxnoXyfRT1TO/26ZsnQ//J9pm/S7V2b/d1PZ+H+r7KK4FSxg
         s4rG9fieNXJfVlJ0GGZxw1JgsjZwlzkCjyV8C/V5JEPTY2g+BKbOB/+MUBDQYSmrAE
         jvSg33J/I6e4+OR0eWPFpWhTmdPvDruS9xuSbEhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Frank van der Linden <fllinden@amazon.com>
Subject: [PATCH 4.19 01/33] x86/speculation: Merge one test in spectre_v2_user_select_mitigation()
Date:   Thu, 10 Mar 2022 15:18:28 +0100
Message-Id: <20220310140807.793272491@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
References: <20220310140807.749164737@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Borislav Petkov <bp@suse.de>

commit a5ce9f2bb665d1d2b31f139a02dbaa2dfbb62fa6 upstream.

Merge the test whether the CPU supports STIBP into the test which
determines whether STIBP is required. Thus try to simplify what is
already an insane logic.

Remove a superfluous newline in a comment, while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Anthony Steinhauser <asteinhauser@google.com>
Link: https://lkml.kernel.org/r/20200615065806.GB14668@zn.tnic
[fllinden@amazon.com: fixed contextual conflict (comment) for 4.19]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -756,10 +756,12 @@ spectre_v2_user_select_mitigation(enum s
 	}
 
 	/*
-	 * If enhanced IBRS is enabled or SMT impossible, STIBP is not
+	 * If no STIBP, enhanced IBRS is enabled or SMT impossible, STIBP is not
 	 * required.
 	 */
-	if (!smt_possible || spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
+	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
+	    !smt_possible ||
+	    spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
 		return;
 
 	/*
@@ -771,12 +773,6 @@ spectre_v2_user_select_mitigation(enum s
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
-	/*
-	 * If STIBP is not available, clear the STIBP mode.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_STIBP))
-		mode = SPECTRE_V2_USER_NONE;
-
 	spectre_v2_user_stibp = mode;
 
 set_mode:
@@ -1255,7 +1251,6 @@ static int ib_prctl_set(struct task_stru
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_NONE &&
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_NONE)
 			return 0;
-
 		/*
 		 * With strict mode for both IBPB and STIBP, the instruction
 		 * code paths avoid checking this task flag and instead,



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF32593B94
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbiHOTrd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345014AbiHOTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2B96D54C;
        Mon, 15 Aug 2022 11:48:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1F09611DB;
        Mon, 15 Aug 2022 18:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B77CC433D6;
        Mon, 15 Aug 2022 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589321;
        bh=qtqnXj6pQ+/+Vwp2iNF9jsPKncWlXe0QUMxDlQHbSKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cei7pfXz1edLybruNKsHplku+siojwatrR0w3BLSEGfng33LT0nnUAiLxGMOa3L1A
         CLcEPadyuns+b4YGNdQWuKCloAfHRAyV8Kxb5O2BzCk65HGceZF/FFLtOOfW6hg6ya
         bMdd9ZL7fwkNGUdhd9E9Pgie/n7RFrSDSE4bF5aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.15 681/779] x86/bugs: Enable STIBP for IBPB mitigated RETBleed
Date:   Mon, 15 Aug 2022 20:05:25 +0200
Message-Id: <20220815180406.462224184@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit e6cfcdda8cbe81eaf821c897369a65fec987b404 upstream.

AMD's "Technical Guidance for Mitigating Branch Type Confusion,
Rev. 1.0 2022-07-12" whitepaper, under section 6.1.2 "IBPB On
Privileged Mode Entry / SMT Safety" says:

  Similar to the Jmp2Ret mitigation, if the code on the sibling thread
  cannot be trusted, software should set STIBP to 1 or disable SMT to
  ensure SMT safety when using this mitigation.

So, like already being done for retbleed=unret, and now also for
retbleed=ibpb, force STIBP on machines that have it, and report its SMT
vulnerability status accordingly.

 [ bp: Remove the "we" and remove "[AMD]" applicability parameter which
   doesn't work here. ]

Fixes: 3ebc17006888 ("x86/bugs: Add retbleed=ibpb")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # 5.10, 5.15, 5.19
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Link: https://lore.kernel.org/r/20220804192201.439596-1-kim.phillips@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |   29 +++++++++++++++++-------
 arch/x86/kernel/cpu/bugs.c                      |   10 ++++----
 2 files changed, 27 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4974,20 +4974,33 @@
 			Speculative Code Execution with Return Instructions)
 			vulnerability.
 
+			AMD-based UNRET and IBPB mitigations alone do not stop
+			sibling threads from influencing the predictions of other
+			sibling threads. For that reason, STIBP is used on pro-
+			cessors that support it, and mitigate SMT on processors
+			that don't.
+
 			off          - no mitigation
 			auto         - automatically select a migitation
 			auto,nosmt   - automatically select a mitigation,
 				       disabling SMT if necessary for
 				       the full mitigation (only on Zen1
 				       and older without STIBP).
-			ibpb	     - mitigate short speculation windows on
-				       basic block boundaries too. Safe, highest
-				       perf impact.
-			unret        - force enable untrained return thunks,
-				       only effective on AMD f15h-f17h
-				       based systems.
-			unret,nosmt  - like unret, will disable SMT when STIBP
-			               is not available.
+			ibpb         - On AMD, mitigate short speculation
+				       windows on basic block boundaries too.
+				       Safe, highest perf impact. It also
+				       enables STIBP if present. Not suitable
+				       on Intel.
+			ibpb,nosmt   - Like "ibpb" above but will disable SMT
+				       when STIBP is not available. This is
+				       the alternative for systems which do not
+				       have STIBP.
+			unret        - Force enable untrained return thunks,
+				       only effective on AMD f15h-f17h based
+				       systems.
+			unret,nosmt  - Like unret, but will disable SMT when STIBP
+				       is not available. This is the alternative for
+				       systems which do not have STIBP.
 
 			Selecting 'auto' will choose a mitigation method at run
 			time according to the CPU.
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -152,7 +152,7 @@ void __init check_bugs(void)
 	/*
 	 * spectre_v2_user_select_mitigation() relies on the state set by
 	 * retbleed_select_mitigation(); specifically the STIBP selection is
-	 * forced for UNRET.
+	 * forced for UNRET or IBPB.
 	 */
 	spectre_v2_user_select_mitigation();
 	ssb_select_mitigation();
@@ -1172,7 +1172,8 @@ spectre_v2_user_select_mitigation(void)
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
-	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET ||
+	    retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 		if (mode != SPECTRE_V2_USER_STRICT &&
 		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
 			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation\n");
@@ -2353,10 +2354,11 @@ static ssize_t srbds_show_state(char *bu
 
 static ssize_t retbleed_show_state(char *buf)
 {
-	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET ||
+	    retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 	    if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 		boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
-		    return sprintf(buf, "Vulnerable: untrained return thunk on non-Zen uarch\n");
+		    return sprintf(buf, "Vulnerable: untrained return thunk / IBPB on non-AMD based uarch\n");
 
 	    return sprintf(buf, "%s; SMT %s\n",
 			   retbleed_strings[retbleed_mitigation],



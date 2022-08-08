Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0046D58CD64
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 20:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244161AbiHHSKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 14:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244187AbiHHSKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 14:10:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F2518E3D;
        Mon,  8 Aug 2022 11:10:04 -0700 (PDT)
Date:   Mon, 08 Aug 2022 18:10:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659982202;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7z+ZjaWxPvCiQRvG6ZSOFuETI932HC3F70oLn3aAjo=;
        b=WPYXn4oAhpLXCvQoQVFZCF8uSLzkBSd5lCotnjg4yBEmn029tdzYW+jwAEeBM9gl+WdgzJ
        WQT5RVWT8O5LR71BfHtXCYW8+7O5UnM8mnlZR+6/QdKTGpa18pXUWm4AQJpkyM/3OFEB3G
        snUv7ZAwBj87SO32T2EorE3r5oR4lUQY3AySne8wsS3P2EjXz3VIV+QbEk4CCPuta0HOrn
        g18Z8WNHpt3RR0ovbpFkrIMxxJ+zl+Lt8Sp+yA32jU/vv0BKxZ/CzLVS62HB/IH4HeQM1a
        xy7ygpIxwffVbQIKhRgqyTAQ6cUx5mDyEtg4U9rhP7CConPf9uS8wbTTt3flMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659982202;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7z+ZjaWxPvCiQRvG6ZSOFuETI932HC3F70oLn3aAjo=;
        b=1a1Nx19Wa22n89pQR0QGD9NSDAQl7B/dAnpWS/cZ4LJMHmyAQ0ikIrXdu+DBFEpZ/igVUe
        ZIBectNd7Y67NUCg==
From:   "tip-bot2 for Kim Phillips" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/bugs: Enable STIBP for IBPB mitigated RETBleed
Cc:     Kim Phillips <kim.phillips@amd.com>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        5.10@tip-bot2.tec.linutronix.de, 5.15@tip-bot2.tec.linutronix.de,
        5.19@tip-bot2.tec.linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20220804192201.439596-1-kim.phillips@amd.com>
References: <20220804192201.439596-1-kim.phillips@amd.com>
MIME-Version: 1.0
Message-ID: <165998220075.15455.8105823437964757898.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e6cfcdda8cbe81eaf821c897369a65fec987b404
Gitweb:        https://git.kernel.org/tip/e6cfcdda8cbe81eaf821c897369a65fec987b404
Author:        Kim Phillips <kim.phillips@amd.com>
AuthorDate:    Mon, 08 Aug 2022 09:32:33 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 08 Aug 2022 19:12:17 +02:00

x86/bugs: Enable STIBP for IBPB mitigated RETBleed

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
---
 Documentation/admin-guide/kernel-parameters.txt | 29 +++++++++++-----
 arch/x86/kernel/cpu/bugs.c                      | 10 +++---
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 5e9147f..523b196 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5209,20 +5209,33 @@
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
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6761668..d50686c 100644
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
@@ -1179,7 +1179,8 @@ spectre_v2_user_select_mitigation(void)
 	    boot_cpu_has(X86_FEATURE_AMD_STIBP_ALWAYS_ON))
 		mode = SPECTRE_V2_USER_STRICT_PREFERRED;
 
-	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET) {
+	if (retbleed_mitigation == RETBLEED_MITIGATION_UNRET ||
+	    retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
 		if (mode != SPECTRE_V2_USER_STRICT &&
 		    mode != SPECTRE_V2_USER_STRICT_PREFERRED)
 			pr_info("Selecting STIBP always-on mode to complement retbleed mitigation\n");
@@ -2320,10 +2321,11 @@ static ssize_t srbds_show_state(char *buf)
 
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

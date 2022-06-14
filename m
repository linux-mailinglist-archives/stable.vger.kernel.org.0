Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B7254B98C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357611AbiFNStI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357841AbiFNSsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:48:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D904C40B;
        Tue, 14 Jun 2022 11:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0556EB8186A;
        Tue, 14 Jun 2022 18:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59250C3411D;
        Tue, 14 Jun 2022 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232276;
        bh=HgomLUh3OgV+hHkM6exgL6tIrZ+w1wX5ZZFM+z6QCus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrLq6i8g4PZJzvmqGnnq/pYWVkGBXDg0aMD4+2iYo8q9DVT+fGMBl90U6MOUjxEcM
         9yhCJC/xMzK9eRFjIb9weLJt88FmwUDe+kb86eWAmmJOgrbgz6YDZVU2wu1PUUB1TE
         RM4Tv+OYsfPJZw/ZyXP9iDiRob04y9Hw5R8KQAik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 03/11] x86/speculation: Add a common function for MD_CLEAR mitigation update
Date:   Tue, 14 Jun 2022 20:40:25 +0200
Message-Id: <20220614183720.731921997@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183719.878453780@linuxfoundation.org>
References: <20220614183719.878453780@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit f52ea6c26953fed339aa4eae717ee5c2133c7ff2 upstream

Processor MMIO Stale Data mitigation uses similar mitigation as MDS and
TAA. In preparation for adding its mitigation, add a common function to
update all mitigations that depend on MD_CLEAR.

  [ bp: Add a newline in md_clear_update_mitigation() to separate
    statements better. ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   59 +++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -41,7 +41,7 @@ static void __init spectre_v2_select_mit
 static void __init ssb_select_mitigation(void);
 static void __init l1tf_select_mitigation(void);
 static void __init mds_select_mitigation(void);
-static void __init mds_print_mitigation(void);
+static void __init md_clear_update_mitigation(void);
 static void __init taa_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 
@@ -114,10 +114,10 @@ void __init check_bugs(void)
 	srbds_select_mitigation();
 
 	/*
-	 * As MDS and TAA mitigations are inter-related, print MDS
-	 * mitigation until after TAA mitigation selection is done.
+	 * As MDS and TAA mitigations are inter-related, update and print their
+	 * mitigation after TAA mitigation selection is done.
 	 */
-	mds_print_mitigation();
+	md_clear_update_mitigation();
 
 	arch_smt_update();
 
@@ -258,14 +258,6 @@ static void __init mds_select_mitigation
 	}
 }
 
-static void __init mds_print_mitigation(void)
-{
-	if (!boot_cpu_has_bug(X86_BUG_MDS) || cpu_mitigations_off())
-		return;
-
-	pr_info("%s\n", mds_strings[mds_mitigation]);
-}
-
 static int __init mds_cmdline(char *str)
 {
 	if (!boot_cpu_has_bug(X86_BUG_MDS))
@@ -320,7 +312,7 @@ static void __init taa_select_mitigation
 	/* TSX previously disabled by tsx=off */
 	if (!boot_cpu_has(X86_FEATURE_RTM)) {
 		taa_mitigation = TAA_MITIGATION_TSX_DISABLED;
-		goto out;
+		return;
 	}
 
 	if (cpu_mitigations_off()) {
@@ -334,7 +326,7 @@ static void __init taa_select_mitigation
 	 */
 	if (taa_mitigation == TAA_MITIGATION_OFF &&
 	    mds_mitigation == MDS_MITIGATION_OFF)
-		goto out;
+		return;
 
 	if (boot_cpu_has(X86_FEATURE_MD_CLEAR))
 		taa_mitigation = TAA_MITIGATION_VERW;
@@ -366,18 +358,6 @@ static void __init taa_select_mitigation
 
 	if (taa_nosmt || cpu_mitigations_auto_nosmt())
 		cpu_smt_disable(false);
-
-	/*
-	 * Update MDS mitigation, if necessary, as the mds_user_clear is
-	 * now enabled for TAA mitigation.
-	 */
-	if (mds_mitigation == MDS_MITIGATION_OFF &&
-	    boot_cpu_has_bug(X86_BUG_MDS)) {
-		mds_mitigation = MDS_MITIGATION_FULL;
-		mds_select_mitigation();
-	}
-out:
-	pr_info("%s\n", taa_strings[taa_mitigation]);
 }
 
 static int __init tsx_async_abort_parse_cmdline(char *str)
@@ -402,6 +382,33 @@ static int __init tsx_async_abort_parse_
 early_param("tsx_async_abort", tsx_async_abort_parse_cmdline);
 
 #undef pr_fmt
+#define pr_fmt(fmt)     "" fmt
+
+static void __init md_clear_update_mitigation(void)
+{
+	if (cpu_mitigations_off())
+		return;
+
+	if (!static_key_enabled(&mds_user_clear))
+		goto out;
+
+	/*
+	 * mds_user_clear is now enabled. Update MDS mitigation, if
+	 * necessary.
+	 */
+	if (mds_mitigation == MDS_MITIGATION_OFF &&
+	    boot_cpu_has_bug(X86_BUG_MDS)) {
+		mds_mitigation = MDS_MITIGATION_FULL;
+		mds_select_mitigation();
+	}
+out:
+	if (boot_cpu_has_bug(X86_BUG_MDS))
+		pr_info("MDS: %s\n", mds_strings[mds_mitigation]);
+	if (boot_cpu_has_bug(X86_BUG_TAA))
+		pr_info("TAA: %s\n", taa_strings[taa_mitigation]);
+}
+
+#undef pr_fmt
 #define pr_fmt(fmt)	"SRBDS: " fmt
 
 enum srbds_mitigations {



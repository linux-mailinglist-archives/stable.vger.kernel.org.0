Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4126D4FC00E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 17:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347684AbiDKPQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347632AbiDKPQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 11:16:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEF63153C;
        Mon, 11 Apr 2022 08:13:54 -0700 (PDT)
Date:   Mon, 11 Apr 2022 15:13:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649690033;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pz/YgZN/i/6l5rzG54XHKTm1a05a/HnhHITJiOjyQXs=;
        b=zuVNx6Bh8mjqIA5jxXXKyj/WUOYuMeU2nOiEqNzeZHhj3kAbSkkEwAAGjqKggH1UR7jSr+
        f23NAyjFy/HRbp1sPyGvbuV9R9D3WMJA1LIg7aZumOFrQWqjiQuqX6H1arTvMqQa6rJ7X2
        D+L1icm/AfYhk1MIZ9uZcPgYjFxzi0AM7B50uYC5ThXEisgV3ekK3os6fGWv8AwxQBHoNO
        RFqKRRdxOerTli3vKMm0/HHgVwGoM4M0uz8RNGafZiD2kj6ULn7lBJFlKGg6SLeEFBeYAN
        fmM7bqv0/u2AM6bk47djzEM/rmwcMMSMskrmH8SoTKEmbCiRP61DcIcxKAsHjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649690033;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pz/YgZN/i/6l5rzG54XHKTm1a05a/HnhHITJiOjyQXs=;
        b=/y9VSJ6ViuXbqXSjn/fAX2/3dv0SQXDtxHsira7P0iEXWpyIw+TLCrierDdBgZoKmUmBRZ
        8bzeZWp2OnD7zwAg==
From:   "tip-bot2 for Pawan Gupta" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits
Cc:     kernel test robot <lkp@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3C5b323e77e251a9c8bcdda498c5cc0095be1e1d3c=2E16469?=
 =?utf-8?q?43780=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
References: =?utf-8?q?=3C5b323e77e251a9c8bcdda498c5cc0095be1e1d3c=2E164694?=
 =?utf-8?q?3780=2Egit=2Epawan=2Ekumar=2Egupta=40linux=2Eintel=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <164969003214.4207.13820079927003826597.tip-bot2@tip-bot2>
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

Commit-ID:     258f3b8c3210b03386e4ad92b4bd8652b5c1beb3
Gitweb:        https://git.kernel.org/tip/258f3b8c3210b03386e4ad92b4bd8652b5c1beb3
Author:        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
AuthorDate:    Thu, 10 Mar 2022 14:00:59 -08:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 11 Apr 2022 09:54:34 +02:00

x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits

tsx_clear_cpuid() uses MSR_TSX_FORCE_ABORT to clear CPUID.RTM and
CPUID.HLE. Not all CPUs support MSR_TSX_FORCE_ABORT, alternatively use
MSR_IA32_TSX_CTRL when supported.

  [ bp: Document how and why TSX gets disabled. ]

Fixes: 293649307ef9 ("x86/tsx: Clear CPUID bits when TSX always force aborts")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/5b323e77e251a9c8bcdda498c5cc0095be1e1d3c.1646943780.git.pawan.kumar.gupta@linux.intel.com
---
 arch/x86/kernel/cpu/intel.c |  1 +-
 arch/x86/kernel/cpu/tsx.c   | 54 +++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8321c43..8abf995 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -722,6 +722,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 	else if (tsx_ctrl_state == TSX_CTRL_DISABLE)
 		tsx_disable();
 	else if (tsx_ctrl_state == TSX_CTRL_RTM_ALWAYS_ABORT)
+		/* See comment over that function for more details. */
 		tsx_clear_cpuid();
 
 	split_lock_init();
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 9c7a5f0..ec6ff80 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -58,7 +58,7 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
+static bool tsx_ctrl_is_supported(void)
 {
 	u64 ia32_cap = x86_read_arch_cap_msr();
 
@@ -84,6 +84,44 @@ static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 	return TSX_CTRL_ENABLE;
 }
 
+/*
+ * Disabling TSX is not a trivial business.
+ *
+ * First of all, there's a CPUID bit: X86_FEATURE_RTM_ALWAYS_ABORT
+ * which says that TSX is practically disabled (all transactions are
+ * aborted by default). When that bit is set, the kernel unconditionally
+ * disables TSX.
+ *
+ * In order to do that, however, it needs to dance a bit:
+ *
+ * 1. The first method to disable it is through MSR_TSX_FORCE_ABORT and
+ * the MSR is present only when *two* CPUID bits are set:
+ *
+ * - X86_FEATURE_RTM_ALWAYS_ABORT
+ * - X86_FEATURE_TSX_FORCE_ABORT
+ *
+ * 2. The second method is for CPUs which do not have the above-mentioned
+ * MSR: those use a different MSR - MSR_IA32_TSX_CTRL and disable TSX
+ * through that one. Those CPUs can also have the initially mentioned
+ * CPUID bit X86_FEATURE_RTM_ALWAYS_ABORT set and for those the same strategy
+ * applies: TSX gets disabled unconditionally.
+ *
+ * When either of the two methods are present, the kernel disables TSX and
+ * clears the respective RTM and HLE feature flags.
+ *
+ * An additional twist in the whole thing presents late microcode loading
+ * which, when done, may cause for the X86_FEATURE_RTM_ALWAYS_ABORT CPUID
+ * bit to be set after the update.
+ *
+ * A subsequent hotplug operation on any logical CPU except the BSP will
+ * cause for the supported CPUID feature bits to get re-detected and, if
+ * RTM and HLE get cleared all of a sudden, but, userspace did consult
+ * them before the update, then funny explosions will happen. Long story
+ * short: the kernel doesn't modify CPUID feature bits after booting.
+ *
+ * That's why, this function's call in init_intel() doesn't clear the
+ * feature flags.
+ */
 void tsx_clear_cpuid(void)
 {
 	u64 msr;
@@ -97,6 +135,10 @@ void tsx_clear_cpuid(void)
 		rdmsrl(MSR_TSX_FORCE_ABORT, msr);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrl(MSR_TSX_FORCE_ABORT, msr);
+	} else if (tsx_ctrl_is_supported()) {
+		rdmsrl(MSR_IA32_TSX_CTRL, msr);
+		msr |= TSX_CTRL_CPUID_CLEAR;
+		wrmsrl(MSR_IA32_TSX_CTRL, msr);
 	}
 }
 
@@ -106,13 +148,11 @@ void __init tsx_init(void)
 	int ret;
 
 	/*
-	 * Hardware will always abort a TSX transaction if both CPUID bits
-	 * RTM_ALWAYS_ABORT and TSX_FORCE_ABORT are set. In this case, it is
-	 * better not to enumerate CPUID.RTM and CPUID.HLE bits. Clear them
-	 * here.
+	 * Hardware will always abort a TSX transaction when the CPUID bit
+	 * RTM_ALWAYS_ABORT is set. In this case, it is better not to enumerate
+	 * CPUID.RTM and CPUID.HLE bits. Clear them here.
 	 */
-	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
-	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
+	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT)) {
 		tsx_ctrl_state = TSX_CTRL_RTM_ALWAYS_ABORT;
 		tsx_clear_cpuid();
 		setup_clear_cpu_cap(X86_FEATURE_RTM);

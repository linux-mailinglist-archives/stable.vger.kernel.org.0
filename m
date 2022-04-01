Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983164EF0CC
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347948AbiDAOgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347624AbiDAOdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B0125845E;
        Fri,  1 Apr 2022 07:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9469B82507;
        Fri,  1 Apr 2022 14:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15253C2BBE4;
        Fri,  1 Apr 2022 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823416;
        bh=P1qmtvTvbAosRiPmOJrhHgT+I3aEB92MB2blXWFUFOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dr1u9Nk368FK6SoIQxr4qFbzj4zmUYoz19o8ZpHNOuh+bo0OTP5awt+N3JHKkppBY
         LCsod78OZ8x+treIhvuN63MPotq+kCkqr0to1RY6OysDDc0A1RQtj+UYtnceQgxtND
         JvYAbx3CCz2faE+Ii3WpJZtNl1JCxJ/OieCI5iq7uGPyjRfZXO8fuVI/QCgu+xW/AM
         O8vgzaR5ceBHZWvTpNZVoLdBlAwOgR/JULKi3gN4Ed7+/oKtOUBHXEls4MCekcYHVH
         7WCg4W5UddRCE++mDtV5ZMuYbPd0Qe2ZBGZ9yoregttNbEnTWXlvlyn+gkmqJ07jx8
         d77aZ5ROuzpCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jue Wang <juew@google.com>, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 084/149] x86/mce: Work around an erratum on fast string copy instructions
Date:   Fri,  1 Apr 2022 10:24:31 -0400
Message-Id: <20220401142536.1948161-84-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Jue Wang <juew@google.com>

[ Upstream commit 8ca97812c3c830573f965a07bbd84223e8c5f5bd ]

A rare kernel panic scenario can happen when the following conditions
are met due to an erratum on fast string copy instructions:

1) An uncorrected error.
2) That error must be in first cache line of a page.
3) Kernel must execute page_copy from the page immediately before that
page.

The fast string copy instructions ("REP; MOVS*") could consume an
uncorrectable memory error in the cache line _right after_ the desired
region to copy and raise an MCE.

Bit 0 of MSR_IA32_MISC_ENABLE can be cleared to disable fast string
copy and will avoid such spurious machine checks. However, that is less
preferable due to the permanent performance impact. Considering memory
poison is rare, it's desirable to keep fast string copy enabled until an
MCE is seen.

Intel has confirmed the following:
1. The CPU erratum of fast string copy only applies to Skylake,
Cascade Lake and Cooper Lake generations.

Directly return from the MCE handler:
2. Will result in complete execution of the "REP; MOVS*" with no data
loss or corruption.
3. Will not result in another MCE firing on the next poisoned cache line
due to "REP; MOVS*".
4. Will resume execution from a correct point in code.
5. Will result in the same instruction that triggered the MCE firing a
second MCE immediately for any other software recoverable data fetch
errors.
6. Is not safe without disabling the fast string copy, as the next fast
string copy of the same buffer on the same CPU would result in a PANIC
MCE.

This should mitigate the erratum completely with the only caveat that
the fast string copy is disabled on the affected hyper thread thus
performance degradation.

This is still better than the OS crashing on MCEs raised on an
irrelevant process due to "REP; MOVS*' accesses in a kernel context,
e.g., copy_page.

Tested:

Injected errors on 1st cache line of 8 anonymous pages of process
'proc1' and observed MCE consumption from 'proc2' with no panic
(directly returned).

Without the fix, the host panicked within a few minutes on a
random 'proc2' process due to kernel access from copy_page.

  [ bp: Fix comment style + touch ups, zap an unlikely(), improve the
    quirk function's readability. ]

Signed-off-by: Jue Wang <juew@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20220218013209.2436006-1-juew@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c     | 64 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/internal.h |  5 ++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 5818b837fd4d..2d719e0d2e40 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -834,6 +834,59 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
 	m->cs = regs->cs;
 }
 
+/*
+ * Disable fast string copy and return from the MCE handler upon the first SRAR
+ * MCE on bank 1 due to a CPU erratum on Intel Skylake/Cascade Lake/Cooper Lake
+ * CPUs.
+ * The fast string copy instructions ("REP; MOVS*") could consume an
+ * uncorrectable memory error in the cache line _right after_ the desired region
+ * to copy and raise an MCE with RIP pointing to the instruction _after_ the
+ * "REP; MOVS*".
+ * This mitigation addresses the issue completely with the caveat of performance
+ * degradation on the CPU affected. This is still better than the OS crashing on
+ * MCEs raised on an irrelevant process due to "REP; MOVS*" accesses from a
+ * kernel context (e.g., copy_page).
+ *
+ * Returns true when fast string copy on CPU has been disabled.
+ */
+static noinstr bool quirk_skylake_repmov(void)
+{
+	u64 mcgstatus   = mce_rdmsrl(MSR_IA32_MCG_STATUS);
+	u64 misc_enable = mce_rdmsrl(MSR_IA32_MISC_ENABLE);
+	u64 mc1_status;
+
+	/*
+	 * Apply the quirk only to local machine checks, i.e., no broadcast
+	 * sync is needed.
+	 */
+	if (!(mcgstatus & MCG_STATUS_LMCES) ||
+	    !(misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING))
+		return false;
+
+	mc1_status = mce_rdmsrl(MSR_IA32_MCx_STATUS(1));
+
+	/* Check for a software-recoverable data fetch error. */
+	if ((mc1_status &
+	     (MCI_STATUS_VAL | MCI_STATUS_OVER | MCI_STATUS_UC | MCI_STATUS_EN |
+	      MCI_STATUS_ADDRV | MCI_STATUS_MISCV | MCI_STATUS_PCC |
+	      MCI_STATUS_AR | MCI_STATUS_S)) ==
+	     (MCI_STATUS_VAL |                   MCI_STATUS_UC | MCI_STATUS_EN |
+	      MCI_STATUS_ADDRV | MCI_STATUS_MISCV |
+	      MCI_STATUS_AR | MCI_STATUS_S)) {
+		misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
+		mce_wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		mce_wrmsrl(MSR_IA32_MCx_STATUS(1), 0);
+
+		instrumentation_begin();
+		pr_err_once("Erratum detected, disable fast string copy instructions.\n");
+		instrumentation_end();
+
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Do a quick check if any of the events requires a panic.
  * This decides if we keep the events around or clear them.
@@ -1403,6 +1456,9 @@ noinstr void do_machine_check(struct pt_regs *regs)
 	else if (unlikely(!mca_cfg.initialized))
 		return unexpected_machine_check(regs);
 
+	if (mce_flags.skx_repmov_quirk && quirk_skylake_repmov())
+		goto clear;
+
 	/*
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
@@ -1545,6 +1601,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 out:
 	instrumentation_end();
 
+clear:
 	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
@@ -1858,6 +1915,13 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
 		if (c->x86 == 6 && c->x86_model == 45)
 			mce_flags.snb_ifu_quirk = 1;
+
+		/*
+		 * Skylake, Cascacde Lake and Cooper Lake require a quirk on
+		 * rep movs.
+		 */
+		if (c->x86 == 6 && c->x86_model == INTEL_FAM6_SKYLAKE_X)
+			mce_flags.skx_repmov_quirk = 1;
 	}
 
 	if (c->x86_vendor == X86_VENDOR_ZHAOXIN) {
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 52c633950b38..24d099e2d2a2 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -170,7 +170,10 @@ struct mce_vendor_flags {
 	/* SandyBridge IFU quirk */
 	snb_ifu_quirk		: 1,
 
-	__reserved_0		: 57;
+	/* Skylake, Cascade Lake, Cooper Lake REP;MOVS* quirk */
+	skx_repmov_quirk	: 1,
+
+	__reserved_0		: 56;
 };
 
 extern struct mce_vendor_flags mce_flags;
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33A41F367B
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 10:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgFIIxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 04:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgFIIxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 04:53:52 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549F3C03E97C;
        Tue,  9 Jun 2020 01:53:52 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jia0z-0005cA-M9; Tue, 09 Jun 2020 10:53:49 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 32A6D1C007F;
        Tue,  9 Jun 2020 10:53:49 +0200 (CEST)
Date:   Tue, 09 Jun 2020 08:53:49 -0000
From:   "tip-bot2 for Anthony Steinhauser" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/speculation: Prevent rogue cross-process SSBD shutdown
Cc:     Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <159169282906.17951.4114513671319540773.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     dbbe2ad02e9df26e372f38cc3e70dab9222c832e
Gitweb:        https://git.kernel.org/tip/dbbe2ad02e9df26e372f38cc3e70dab9222c832e
Author:        Anthony Steinhauser <asteinhauser@google.com>
AuthorDate:    Sun, 05 Jan 2020 12:19:43 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 09 Jun 2020 10:50:55 +02:00

x86/speculation: Prevent rogue cross-process SSBD shutdown

On context switch the change of TIF_SSBD and TIF_SPEC_IB are evaluated
to adjust the mitigations accordingly. This is optimized to avoid the
expensive MSR write if not needed.

This optimization is buggy and allows an attacker to shutdown the SSBD
protection of a victim process.

The update logic reads the cached base value for the speculation control
MSR which has neither the SSBD nor the STIBP bit set. It then OR's the
SSBD bit only when TIF_SSBD is different and requests the MSR update.

That means if TIF_SSBD of the previous and next task are the same, then
the base value is not updated, even if TIF_SSBD is set. The MSR write is
not requested.

Subsequently if the TIF_STIBP bit differs then the STIBP bit is updated
in the base value and the MSR is written with a wrong SSBD value.

This was introduced when the per task/process conditional STIPB
switching was added on top of the existing SSBD switching.

It is exploitable if the attacker creates a process which enforces SSBD
and has the contrary value of STIBP than the victim process (i.e. if the
victim process enforces STIBP, the attacker process must not enforce it;
if the victim process does not enforce STIBP, the attacker process must
enforce it) and schedule it on the same core as the victim process. If
the victim runs after the attacker the victim becomes vulnerable to
Spectre V4.

To fix this, update the MSR value independent of the TIF_SSBD difference
and dependent on the SSBD mitigation method available. This ensures that
a subsequent STIPB initiated MSR write has the correct state of SSBD.

[ tglx: Handle X86_FEATURE_VIRT_SSBD & X86_FEATURE_VIRT_SSBD correctly
        and massaged changelog ]

Fixes: 5bfbe3ad5840 ("x86/speculation: Prepare for per task indirect branch speculation control")
Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org

---
 arch/x86/kernel/process.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 35638f1..8f4533c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -545,28 +545,20 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 
 	lockdep_assert_irqs_disabled();
 
-	/*
-	 * If TIF_SSBD is different, select the proper mitigation
-	 * method. Note that if SSBD mitigation is disabled or permanentely
-	 * enabled this branch can't be taken because nothing can set
-	 * TIF_SSBD.
-	 */
-	if (tif_diff & _TIF_SSBD) {
-		if (static_cpu_has(X86_FEATURE_VIRT_SSBD)) {
+	/* Handle change of TIF_SSBD depending on the mitigation method. */
+	if (static_cpu_has(X86_FEATURE_VIRT_SSBD)) {
+		if (tif_diff & _TIF_SSBD)
 			amd_set_ssb_virt_state(tifn);
-		} else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD)) {
+	} else if (static_cpu_has(X86_FEATURE_LS_CFG_SSBD)) {
+		if (tif_diff & _TIF_SSBD)
 			amd_set_core_ssb_state(tifn);
-		} else if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-			   static_cpu_has(X86_FEATURE_AMD_SSBD)) {
-			msr |= ssbd_tif_to_spec_ctrl(tifn);
-			updmsr  = true;
-		}
+	} else if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+		   static_cpu_has(X86_FEATURE_AMD_SSBD)) {
+		updmsr |= !!(tif_diff & _TIF_SSBD);
+		msr |= ssbd_tif_to_spec_ctrl(tifn);
 	}
 
-	/*
-	 * Only evaluate TIF_SPEC_IB if conditional STIBP is enabled,
-	 * otherwise avoid the MSR write.
-	 */
+	/* Only evaluate TIF_SPEC_IB if conditional STIBP is enabled. */
 	if (IS_ENABLED(CONFIG_SMP) &&
 	    static_branch_unlikely(&switch_to_cond_stibp)) {
 		updmsr |= !!(tif_diff & _TIF_SPEC_IB);

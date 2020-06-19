Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B02B2016DE
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgFSOpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388725AbgFSOpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B5020DD4;
        Fri, 19 Jun 2020 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577938;
        bh=q2zQ0nGgEorAAenwcS6lLOujzX58gZy3nOacLP8+7g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/AgIvRIv7vYhpa6qe0b9lJWj8xe3QQNM0egvyzO7vrSJAf0Ps5sgw071XZR7roWE
         eICH/P/tEl6XINgbTm0c4tpnFKAsNpiahzz7uAulkZnXAjs0QY+PiMpmoR4fyeZ4vS
         7IrlRSHtYz6KUom0VLuzudafx5BXvr2OJuTij41g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 020/190] x86/speculation: Prevent rogue cross-process SSBD shutdown
Date:   Fri, 19 Jun 2020 16:31:05 +0200
Message-Id: <20200619141634.487399613@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Steinhauser <asteinhauser@google.com>

commit dbbe2ad02e9df26e372f38cc3e70dab9222c832e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/process.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -414,28 +414,20 @@ static __always_inline void __speculatio
 	u64 msr = x86_spec_ctrl_base;
 	bool updmsr = false;
 
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



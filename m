Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4FE4890CF
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbiAJHZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:25:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35358 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiAJHY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDADE61194;
        Mon, 10 Jan 2022 07:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A074EC36AED;
        Mon, 10 Jan 2022 07:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799498;
        bh=5AycrP6fhzyZWUTosB32ZZVjaR3QhOE2NrfcmR2OBgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy+8zGmFtgBn25kOEN92gjvDe4WCcmnKfizXADfwfoNStC8SCOTjIK4Wv8BjSxGo7
         tLMiKYwj+tV7CviYjwf09kESPkMm/yJaQCvUqPe3mfQK41URMWIkO70SIXn6lvPFMA
         g+AYq74/JaP+5BBEwnLp/sYfOnu1vlC63pbNo4cE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.9 14/21] arm64: move !VHE work to end of el2_setup
Date:   Mon, 10 Jan 2022 08:23:01 +0100
Message-Id: <20220110071813.280605016@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit d61c97a7773d0848b4bf5c4697855c7ce117362c upstream.

We only need to initialise sctlr_el1 if we're installing an EL2 stub, so
we may as well defer this until we're doing so. Similarly, we can defer
intialising CPTR_EL2 until then, as we do not access any trapped
functionality as part of el2_setup.

This patch modified el2_setup accordingly, allowing us to remove a
branch and simplify the code flow.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/head.S |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -553,26 +553,6 @@ set_hcr:
 	msr	vpidr_el2, x0
 	msr	vmpidr_el2, x1
 
-	/*
-	 * When VHE is not in use, early init of EL2 and EL1 needs to be
-	 * done here.
-	 * When VHE _is_ in use, EL1 will not be used in the host and
-	 * requires no configuration, and all non-hyp-specific EL2 setup
-	 * will be done via the _EL1 system register aliases in __cpu_setup.
-	 */
-	cbnz	x2, 1f
-
-	/* sctlr_el1 */
-	mov	x0, #0x0800			// Set/clear RES{1,0} bits
-CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
-CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
-	msr	sctlr_el1, x0
-
-	/* Coprocessor traps. */
-	mov	x0, #0x33ff
-	msr	cptr_el2, x0			// Disable copro. traps to EL2
-1:
-
 #ifdef CONFIG_COMPAT
 	msr	hstr_el2, xzr			// Disable CP15 traps to EL2
 #endif
@@ -598,6 +578,23 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// C
 	ret
 
 install_el2_stub:
+	/*
+	 * When VHE is not in use, early init of EL2 and EL1 needs to be
+	 * done here.
+	 * When VHE _is_ in use, EL1 will not be used in the host and
+	 * requires no configuration, and all non-hyp-specific EL2 setup
+	 * will be done via the _EL1 system register aliases in __cpu_setup.
+	 */
+	/* sctlr_el1 */
+	mov	x0, #0x0800			// Set/clear RES{1,0} bits
+CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
+CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
+	msr	sctlr_el1, x0
+
+	/* Coprocessor traps. */
+	mov	x0, #0x33ff
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+
 	/* Hypervisor stub */
 	adrp	x0, __hyp_stub_vectors
 	add	x0, x0, #:lo12:__hyp_stub_vectors



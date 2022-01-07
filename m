Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6812487D3F
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 20:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiAGToI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 14:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiAGToH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 14:44:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E928C06173E
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 11:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E2FB82760
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 19:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F80C36AED;
        Fri,  7 Jan 2022 19:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641584644;
        bh=GO9iL6Qi1ajaccImX9GcZ0L+1uDe8ATmtJQ1yhUiskc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdHb8k14YHP2arXIYvO53uNJtJ/AGs0FKgM+Ddpjyh6/rQ/uQoSFxMHmpP+JUXxfs
         G87IB4eDF8GPCQTExwyXpCtvlOVIRobDAdmNCWT312YtpcftbxxO9dGRsj/TVQWTX7
         BgApLX1YFxCJ5A1x6vZtORG3tzbPWwvbO1KdOFSh9fXM3CMlcP65OzfLerB/trfJms
         bnTz73Q3W8tqjHIghJDQkqZqhDOEofvYNbSFGIkaLUL4bd5jqqEyLJ28n+tYLXdwpB
         Td8p0DsyaT/o64uTdcuAhhUylQHK2sD333vG4jdaypOnboTg1SPglHQPUKRnEasrWu
         odBJjYwtp/E0A==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH RFC 4.9 4/5] arm64: move !VHE work to end of el2_setup
Date:   Fri,  7 Jan 2022 12:43:34 -0700
Message-Id: <20220107194335.3090066-5-nathan@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107194335.3090066-1-nathan@kernel.org>
References: <20220107194335.3090066-1-nathan@kernel.org>
MIME-Version: 1.0
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
---
 arch/arm64/kernel/head.S | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index b15abc6ae4af..c067b13e93cc 100644
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
@@ -598,6 +578,23 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
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
-- 
2.34.1


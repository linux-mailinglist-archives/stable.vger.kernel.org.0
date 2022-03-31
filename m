Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0844EE08F
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbiCaSgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiCaSgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:36:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D7B61F0820;
        Thu, 31 Mar 2022 11:34:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10BB8139F;
        Thu, 31 Mar 2022 11:34:38 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 674FB3F718;
        Thu, 31 Mar 2022 11:34:37 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, catalin.marinas@arm.com
Subject: [stable:PATCH v4.14.274 10/27] arm64: entry: Make the trampoline cleanup optional
Date:   Thu, 31 Mar 2022 19:33:43 +0100
Message-Id: <20220331183400.73183-11-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220331183400.73183-1-james.morse@arm.com>
References: <20220331183400.73183-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d739da1694a0eaef0358a42b76904b611539b77b upstream.

Subsequent patches will add additional sets of vectors that use
the same tricks as the kpti vectors to reach the full-fat vectors.
The full-fat vectors contain some cleanup for kpti that is patched
in by alternatives when kpti is in use. Once there are additional
vectors, the cleanup will be needed in more cases.

But on big/little systems, the cleanup would be harmful if no
trampoline vector were in use. Instead of forcing CPUs that don't
need a trampoline vector to use one, make the trampoline cleanup
optional.

Entry at the top of the vectors will skip the cleanup. The trampoline
vectors can then skip the first instruction, triggering the cleanup
to run.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 81069ad43a5e..1211e0da5476 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -76,16 +76,20 @@
 	.align 7
 .Lventry_start\@:
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-alternative_if ARM64_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
+	/*
+	 * This must be the first instruction of the EL0 vector entries. It is
+	 * skipped by the trampoline vectors, to trigger the cleanup.
+	 */
+	b	.Lskip_tramp_vectors_cleanup\@
 	.if	\regsize == 64
 	mrs	x30, tpidrro_el0
 	msr	tpidrro_el0, xzr
 	.else
 	mov	x30, xzr
 	.endif
+.Lskip_tramp_vectors_cleanup\@:
 	.endif
-alternative_else_nop_endif
 #endif
 
 	sub	sp, sp, #S_FRAME_SIZE
@@ -1035,7 +1039,7 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
 #endif
 	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors)
+	add	x30, x30, #(1b - tramp_vectors + 4)
 	isb
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?
-- 
2.30.2


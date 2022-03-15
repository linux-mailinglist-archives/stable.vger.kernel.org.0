Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940614DA24B
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351013AbiCOSZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351019AbiCOSZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:25:50 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4574728E06
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:24:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EB431476;
        Tue, 15 Mar 2022 11:24:38 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 633EE3F73D;
        Tue, 15 Mar 2022 11:24:37 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com
Subject: [stable:PATCH v5.4.184 06/22] arm64: entry: Make the trampoline cleanup optional
Date:   Tue, 15 Mar 2022 18:23:59 +0000
Message-Id: <20220315182415.3900464-7-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315182415.3900464-1-james.morse@arm.com>
References: <20220315182415.3900464-1-james.morse@arm.com>
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
index 98991aa9d0b1..a6dcd68ce7de 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -61,16 +61,20 @@
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
@@ -1079,7 +1083,7 @@ alternative_if_not ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM
 	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
 alternative_else_nop_endif
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors)
+	add	x30, x30, #(1b - tramp_vectors + 4)
 	isb
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?
-- 
2.30.2


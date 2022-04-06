Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6772A4F68CC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 20:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbiDFSJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 14:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbiDFSIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 14:08:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18C0B1965D3;
        Wed,  6 Apr 2022 09:46:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9F6A23A;
        Wed,  6 Apr 2022 09:46:28 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48D143F73B;
        Wed,  6 Apr 2022 09:46:28 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [stable:PATCH v4.9.309 30/43] arm64: entry: Don't assume tramp_vectors is the start of the vectors
Date:   Wed,  6 Apr 2022 17:45:33 +0100
Message-Id: <20220406164546.1888528-30-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406164546.1888528-1-james.morse@arm.com>
References: <0220406164217.1888053-1-james.morse@arm.com>
 <20220406164546.1888528-1-james.morse@arm.com>
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

commit ed50da7764535f1e24432ded289974f2bf2b0c5a upstream.

The tramp_ventry macro uses tramp_vectors as the address of the vectors
when calculating which ventry in the 'full fat' vectors to branch to.

While there is one set of tramp_vectors, this will be true.
Adding multiple sets of vectors will break this assumption.

Move the generation of the vectors to a macro, and pass the start
of the vectors as an argument to tramp_ventry.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 4c4f7df5f0f3..114922c1c3e3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -926,7 +926,7 @@ __ni_sys_trace:
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
-	.macro tramp_ventry, regsize = 64
+	.macro tramp_ventry, vector_start, regsize
 	.align	7
 1:
 	.if	\regsize == 64
@@ -948,9 +948,9 @@ __ni_sys_trace:
 #else
 	ldr	x30, =vectors
 #endif
-	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
+	prfm	plil1strm, [x30, #(1b - \vector_start)]
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors + 4)
+	add	x30, x30, #(1b - \vector_start + 4)
 	isb
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?
@@ -968,19 +968,21 @@ __ni_sys_trace:
 	eret
 	.endm
 
-	.align	11
-ENTRY(tramp_vectors)
+	.macro	generate_tramp_vector
+.Lvector_start\@:
 	.space	0x400
 
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64
+	.endr
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 32
+	.endr
+	.endm
 
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
+	.align	11
+ENTRY(tramp_vectors)
+	generate_tramp_vector
 END(tramp_vectors)
 
 ENTRY(tramp_exit_native)
-- 
2.30.2


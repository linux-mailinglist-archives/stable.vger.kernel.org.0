Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11681531633
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241607AbiEWRoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242295AbiEWRhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:37:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BD041F83;
        Mon, 23 May 2022 10:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2372560BFA;
        Mon, 23 May 2022 17:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B379C385AA;
        Mon, 23 May 2022 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326928;
        bh=u42GP9FIxBLiQVUy+Zvlt236BnGmDPCoe9IJWjgsAAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZdgmEbQrGAwCOj6zrh1cyyNzDOTPiUrBiH8VkDygprxiJ8kXzscymPK92XOufail
         1CVWNoTEU4LfxNsSNbrPqNo4F+tKJkDFfQTRFNRZGUp0Tbgu2KzfoA6qHqgyNpDdf9
         /474Dh4ZOXfywaBE77lDrsy181LlzRh4rxmkI5jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 095/158] arm64: kexec: load from kimage prior to clobbering
Date:   Mon, 23 May 2022 19:04:12 +0200
Message-Id: <20220523165847.094019976@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit eb3d8ea3e1f03f4b0b72d8f5ed9eb7c3165862e8 ]

In arm64_relocate_new_kernel() we load some fields out of the kimage
structure after relocation has occurred. As the kimage structure isn't
allocated to be relocation-safe, it may be clobbered during relocation,
and we may load junk values out of the structure.

Due to this, kexec may fail when the kimage allocation happens to fall
within a PA range that an object will be relocated to. This has been
observed to occur for regular kexec on a QEMU TCG 'virt' machine with
2GiB of RAM, where the PA range of the new kernel image overlaps the
kimage structure.

Avoid this by ensuring we load all values from the kimage structure
prior to relocation.

I've tested this atop v5.16 and v5.18-rc6.

Fixes: 878fdbd70486 ("arm64: kexec: pass kimage as the only argument to relocation function")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/20220516160735.731404-1-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/relocate_kernel.S | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/relocate_kernel.S b/arch/arm64/kernel/relocate_kernel.S
index f0a3df9e18a3..413f899e4ac6 100644
--- a/arch/arm64/kernel/relocate_kernel.S
+++ b/arch/arm64/kernel/relocate_kernel.S
@@ -37,6 +37,15 @@
  * safe memory that has been set up to be preserved during the copy operation.
  */
 SYM_CODE_START(arm64_relocate_new_kernel)
+	/*
+	 * The kimage structure isn't allocated specially and may be clobbered
+	 * during relocation. We must load any values we need from it prior to
+	 * any relocation occurring.
+	 */
+	ldr	x28, [x0, #KIMAGE_START]
+	ldr	x27, [x0, #KIMAGE_ARCH_EL2_VECTORS]
+	ldr	x26, [x0, #KIMAGE_ARCH_DTB_MEM]
+
 	/* Setup the list loop variables. */
 	ldr	x18, [x0, #KIMAGE_ARCH_ZERO_PAGE] /* x18 = zero page for BBM */
 	ldr	x17, [x0, #KIMAGE_ARCH_TTBR1]	/* x17 = linear map copy */
@@ -72,21 +81,20 @@ SYM_CODE_START(arm64_relocate_new_kernel)
 	ic	iallu
 	dsb	nsh
 	isb
-	ldr	x4, [x0, #KIMAGE_START]			/* relocation start */
-	ldr	x1, [x0, #KIMAGE_ARCH_EL2_VECTORS]	/* relocation start */
-	ldr	x0, [x0, #KIMAGE_ARCH_DTB_MEM]		/* dtb address */
 	turn_off_mmu x12, x13
 
 	/* Start new image. */
-	cbz	x1, .Lel1
-	mov	x1, x4				/* relocation start */
-	mov	x2, x0				/* dtb address */
+	cbz	x27, .Lel1
+	mov	x1, x28				/* kernel entry point */
+	mov	x2, x26				/* dtb address */
 	mov	x3, xzr
 	mov	x4, xzr
 	mov     x0, #HVC_SOFT_RESTART
 	hvc	#0				/* Jumps from el2 */
 .Lel1:
+	mov	x0, x26				/* dtb address */
+	mov	x1, xzr
 	mov	x2, xzr
 	mov	x3, xzr
-	br	x4				/* Jumps from el1 */
+	br	x28				/* Jumps from el1 */
 SYM_CODE_END(arm64_relocate_new_kernel)
-- 
2.35.1




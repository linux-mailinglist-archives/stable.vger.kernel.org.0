Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49024D339B
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiCIQLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbiCIQJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0912D1E3;
        Wed,  9 Mar 2022 08:07:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E61E61797;
        Wed,  9 Mar 2022 16:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE6EC340E8;
        Wed,  9 Mar 2022 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842055;
        bh=25Hk37nJ7k4GM1ojM6Tgufom7M/GqJr5xVZym4GE6GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3PAFpwtz0UL4L/zDWtjLnwQlsGsPECe+GbOHNgVg3kFoEP1J+q1YOLZWO7lsGEho
         w2q8ba4EVzE+4cODFLUzSKBuEjd4cEJ2tpQLsGDzbTSjETPOLkVpPJb9GETb6SBK1z
         i20dylWjkTdC9705F4MZL+Njqy3YA539/LaT4MS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 25/43] arm64: entry: Free up another register on kptis tramp_exit path
Date:   Wed,  9 Mar 2022 17:00:09 +0100
Message-Id: <20220309155900.466319965@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 03aff3a77a58b5b52a77e00537a42090ad57b80b upstream.

Kpti stashes x30 in far_el1 while it uses x30 for all its work.

Making the vectors a per-cpu data structure will require a second
register.

Allow tramp_exit two registers before it unmaps the kernel, by
leaving x30 on the stack, and stashing x29 in far_el1.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -419,14 +419,16 @@ alternative_else_nop_endif
 	ldp	x24, x25, [sp, #16 * 12]
 	ldp	x26, x27, [sp, #16 * 13]
 	ldp	x28, x29, [sp, #16 * 14]
-	ldr	lr, [sp, #S_LR]
-	add	sp, sp, #PT_REGS_SIZE		// restore sp
 
 	.if	\el == 0
-alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
+alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
+	eret
+alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	4f
-	msr	far_el1, x30
+	msr	far_el1, x29
 	tramp_alias	x30, tramp_exit_native
 	br	x30
 4:
@@ -434,6 +436,9 @@ alternative_insn eret, nop, ARM64_UNMAP_
 	br	x30
 #endif
 	.else
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
+
 	/* Ensure any device/NC reads complete */
 	alternative_insn nop, "dmb sy", ARM64_WORKAROUND_1508412
 
@@ -674,10 +679,12 @@ alternative_else_nop_endif
 	.macro tramp_exit, regsize = 64
 	adr	x30, tramp_vectors
 	msr	vbar_el1, x30
-	tramp_unmap_kernel	x30
+	ldr	lr, [sp, #S_LR]
+	tramp_unmap_kernel	x29
 	.if	\regsize == 64
-	mrs	x30, far_el1
+	mrs	x29, far_el1
 	.endif
+	add	sp, sp, #PT_REGS_SIZE		// restore sp
 	eret
 	sb
 	.endm



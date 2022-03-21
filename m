Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06E34E28B6
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348404AbiCUOAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348707AbiCUN6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE94179420;
        Mon, 21 Mar 2022 06:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC36612A0;
        Mon, 21 Mar 2022 13:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFACC340E8;
        Mon, 21 Mar 2022 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870951;
        bh=iqOckIo6jhfcvNG2gMBYFRi7xPN+WjyixetCij8eTRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGg8CD2YprMP16ZkequPUhyBvHFYSGBhgtG57kPMRzDLLflxc+yM3rcgVboFcTa7I
         t3Gdkhot+aTZaqvfxnIDkzQrHVH8k1Q3QjGSMagYg6BkJFPTtSJU7pUfV1Gmjr4WfM
         PitQRwoNhmf0f+nT/HqUU6x7i5re+tVVJdK9vUss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.19 28/57] arm64: entry: Free up another register on kptis tramp_exit path
Date:   Mon, 21 Mar 2022 14:52:09 +0100
Message-Id: <20220321133222.807964635@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/kernel/entry.S |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -348,18 +348,20 @@ alternative_else_nop_endif
 	ldp	x24, x25, [sp, #16 * 12]
 	ldp	x26, x27, [sp, #16 * 13]
 	ldp	x28, x29, [sp, #16 * 14]
-	ldr	lr, [sp, #S_LR]
-	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on eret context synchronization
 	 * when returning from IPI handler, and when returning to user-space.
 	 */
 
 	.if	\el == 0
-alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
+alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
+	eret
+alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	4f
-	msr	far_el1, x30
+	msr	far_el1, x29
 	tramp_alias	x30, tramp_exit_native
 	br	x30
 4:
@@ -367,6 +369,8 @@ alternative_insn eret, nop, ARM64_UNMAP_
 	br	x30
 #endif
 	.else
+	ldr	lr, [sp, #S_LR]
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	eret
 	.endif
 	.endm
@@ -996,10 +1000,12 @@ alternative_insn isb, nop, ARM64_WORKARO
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
+	add	sp, sp, #S_FRAME_SIZE		// restore sp
 	eret
 	.endm
 



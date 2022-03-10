Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884E74D48F2
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbiCJONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242980AbiCJOMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:12:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E6B15471D;
        Thu, 10 Mar 2022 06:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AEE9B82678;
        Thu, 10 Mar 2022 14:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C4DC36AE3;
        Thu, 10 Mar 2022 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921457;
        bh=mQatgqh/6NzDSIrRy2F06cmfP6PjNZfpbO5vp69JtKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPBs72IGqNFsFpqtRmeRjR2JOc2ostZonabDPbshlzRHY596Bt0MX+cJe39CGCSYf
         vUlxw470pFS9Y1OQ+Jp3UNv0zYLnZonpmPZjerwdLA9ejHe+xMDUkgGYXbR8pTxnPf
         Ai4UBtlGwZy5AS2QNICpouj3hnKyIADMqWrOk9vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 23/53] arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
Date:   Thu, 10 Mar 2022 15:09:28 +0100
Message-Id: <20220310140812.501579321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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

commit 6c5bf79b69f911560fbf82214c0971af6e58e682 upstream.

Systems using kpti enter and exit the kernel through a trampoline mapping
that is always mapped, even when the kernel is not. tramp_valias is a macro
to find the address of a symbol in the trampoline mapping.

Adding extra sets of vectors will expand the size of the entry.tramp.text
section to beyond 4K. tramp_valias will be unable to generate addresses
for symbols beyond 4K as it uses the 12 bit immediate of the add
instruction.

As there are now two registers available when tramp_alias is called,
use the extra register to avoid the 4K limit of the 12 bit immediate.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -103,9 +103,12 @@
 .org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
-	.macro tramp_alias, dst, sym
+	.macro tramp_alias, dst, sym, tmp
 	mov_q	\dst, TRAMP_VALIAS
-	add	\dst, \dst, #(\sym - .entry.tramp.text)
+	adr_l	\tmp, \sym
+	add	\dst, \dst, \tmp
+	adr_l	\tmp, .entry.tramp.text
+	sub	\dst, \dst, \tmp
 	.endm
 
 	/*
@@ -429,10 +432,10 @@ alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	4f
 	msr	far_el1, x29
-	tramp_alias	x30, tramp_exit_native
+	tramp_alias	x30, tramp_exit_native, x29
 	br	x30
 4:
-	tramp_alias	x30, tramp_exit_compat
+	tramp_alias	x30, tramp_exit_compat, x29
 	br	x30
 #endif
 	.else
@@ -998,7 +1001,7 @@ alternative_if_not ARM64_UNMAP_KERNEL_AT
 alternative_else_nop_endif
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline
+	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline, tmp=x3
 	br	x5
 #endif
 SYM_CODE_END(__sdei_asm_handler)



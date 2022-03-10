Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C552E4D4A02
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244472AbiCJOd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244836AbiCJO3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:29:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC7DDCE0D;
        Thu, 10 Mar 2022 06:24:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFD89B82544;
        Thu, 10 Mar 2022 14:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DAFC340EB;
        Thu, 10 Mar 2022 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922283;
        bh=Z7pnDDP4PixJazKkW3aaIvDxwShxt7Bmhfqwcoma7Ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YH4ZFcpE5T63uJpCoScnVcnVck/Hu7uigm/BzJBvBP2clNE4LAfMVTPARm4gTcjEU
         Gha8JP5PvSsDUAU9rtHVta6bqjufbrnu4tWE8nYXuERRULRBgsYFP5MAR8aYr/nKm6
         8M6yAuD7g5sWTllYHfyHzzzVYOVmMwqjCN8WLJqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 29/58] arm64: entry: Dont assume tramp_vectors is the start of the vectors
Date:   Thu, 10 Mar 2022 15:18:49 +0100
Message-Id: <20220310140813.706610992@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -822,7 +822,7 @@ alternative_else_nop_endif
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
-	.macro tramp_ventry, regsize = 64
+	.macro tramp_ventry, vector_start, regsize
 	.align	7
 1:
 	.if	\regsize == 64
@@ -845,10 +845,10 @@ alternative_insn isb, nop, ARM64_WORKARO
 	ldr	x30, =vectors
 #endif
 alternative_if_not ARM64_WORKAROUND_CAVIUM_TX2_219_PRFM
-	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
+	prfm	plil1strm, [x30, #(1b - \vector_start)]
 alternative_else_nop_endif
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors + 4)
+	add	x30, x30, #(1b - \vector_start + 4)
 	isb
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?
@@ -867,19 +867,21 @@ alternative_else_nop_endif
 	sb
 	.endm
 
-	.align	11
-SYM_CODE_START_NOALIGN(tramp_vectors)
+	.macro	generate_tramp_vector
+.Lvector_start\@:
 	.space	0x400
 
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
-	tramp_ventry
-
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
-	tramp_ventry	32
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64
+	.endr
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 32
+	.endr
+	.endm
+
+	.align	11
+SYM_CODE_START_NOALIGN(tramp_vectors)
+	generate_tramp_vector
 SYM_CODE_END(tramp_vectors)
 
 SYM_CODE_START(tramp_exit_native)



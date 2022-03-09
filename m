Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88244D32CF
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiCIQMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbiCIQJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6F0DF3D;
        Wed,  9 Mar 2022 08:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C153615FA;
        Wed,  9 Mar 2022 16:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975F6C340E8;
        Wed,  9 Mar 2022 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842129;
        bh=xdJQTRGaTq4mpUn1+PLonlgXKiG2oKDP/uWJOZNH/V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjZOWFJuTC3jy0q/ilcO1L5pKDjnKVYpTPvCw+hLHwCU/COdSAAtMw5gv8Snh9UbO
         yS3bOS2GDJiMI1M2LZS3VTrRZfpGMbbt1+bTcg8ty7kDfshwVheBS7eV67lVSU6ITv
         cWYTWJVQ+GDAF4y/yr42Q+bgy2IXK4rYsmgHWWQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 28/43] arm64: entry: Dont assume tramp_vectors is the start of the vectors
Date:   Wed,  9 Mar 2022 17:00:12 +0100
Message-Id: <20220309155900.551542956@linuxfoundation.org>
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
@@ -652,7 +652,7 @@ alternative_else_nop_endif
 	sub	\dst, \dst, PAGE_SIZE
 	.endm
 
-	.macro tramp_ventry, regsize = 64
+	.macro tramp_ventry, vector_start, regsize
 	.align	7
 1:
 	.if	\regsize == 64
@@ -675,10 +675,10 @@ alternative_insn isb, nop, ARM64_WORKARO
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
@@ -697,19 +697,21 @@ alternative_else_nop_endif
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



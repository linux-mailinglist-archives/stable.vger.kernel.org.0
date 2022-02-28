Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92D4C7297
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiB1R1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiB1R1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:27:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D06788B14;
        Mon, 28 Feb 2022 09:26:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3895E6135F;
        Mon, 28 Feb 2022 17:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F539C340E7;
        Mon, 28 Feb 2022 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069179;
        bh=IXCkHH0HWeISy7aMM/CGHlDw/KGsTSjG8aYHNGerVpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBsPHu6ylAbhkypdXdx8EWWK3ix6dodfr9r/ryb1fAgrxLnFYx9U5kwlToaloiYut
         mtZ4uOizuneGALluLHPH76B4g7y6BEjL6FVDpKCVb4GmoAd+/ax/fn4Uhq+6toy5eO
         L+JXj2p6VBF+cV7i81T5/WX7xDWni3sUwREPv3ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 03/29] parisc/unaligned: Fix fldd and fstd unaligned handlers on 32-bit kernel
Date:   Mon, 28 Feb 2022 18:23:30 +0100
Message-Id: <20220228172142.042888559@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit dd2288f4a020d693360e3e8d72f8b9d9c25f5ef6 upstream.

Usually the kernel provides fixup routines to emulate the fldd and fstd
floating-point instructions if they load or store 8-byte from/to a not
natuarally aligned memory location.

On a 32-bit kernel I noticed that those unaligned handlers didn't worked and
instead the application got a SEGV.
While checking the code I found two problems:

First, the OPCODE_FLDD_L and OPCODE_FSTD_L cases were ifdef'ed out by the
CONFIG_PA20 option, and as such those weren't built on a pure 32-bit kernel.
This is now fixed by moving the CONFIG_PA20 #ifdef to prevent the compilation
of OPCODE_LDD_L and OPCODE_FSTD_L only, and handling the fldd and fstd
instructions.

The second problem are two bugs in the 32-bit inline assembly code, where the
wrong registers where used. The calculation of the natural alignment used %2
(vall) instead of %3 (ior), and the first word was stored back to address %1
(valh) instead of %3 (ior).

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/unaligned.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -410,7 +410,7 @@ static int emulate_std(struct pt_regs *r
 	__asm__ __volatile__ (
 "	mtsp	%4, %%sr1\n"
 "	zdep	%2, 29, 2, %%r19\n"
-"	dep	%%r0, 31, 2, %2\n"
+"	dep	%%r0, 31, 2, %3\n"
 "	mtsar	%%r19\n"
 "	zvdepi	-2, 32, %%r19\n"
 "1:	ldw	0(%%sr1,%3),%%r20\n"
@@ -422,7 +422,7 @@ static int emulate_std(struct pt_regs *r
 "	andcm	%%r21, %%r19, %%r21\n"
 "	or	%1, %%r20, %1\n"
 "	or	%2, %%r21, %2\n"
-"3:	stw	%1,0(%%sr1,%1)\n"
+"3:	stw	%1,0(%%sr1,%3)\n"
 "4:	stw	%%r1,4(%%sr1,%3)\n"
 "5:	stw	%2,8(%%sr1,%3)\n"
 "	copy	%%r0, %0\n"
@@ -610,7 +610,6 @@ void handle_unaligned(struct pt_regs *re
 		ret = ERR_NOTHANDLED;	/* "undefined", but lets kill them. */
 		break;
 	}
-#ifdef CONFIG_PA20
 	switch (regs->iir & OPCODE2_MASK)
 	{
 	case OPCODE_FLDD_L:
@@ -621,14 +620,15 @@ void handle_unaligned(struct pt_regs *re
 		flop=1;
 		ret = emulate_std(regs, R2(regs->iir),1);
 		break;
+#ifdef CONFIG_PA20
 	case OPCODE_LDD_L:
 		ret = emulate_ldd(regs, R2(regs->iir),0);
 		break;
 	case OPCODE_STD_L:
 		ret = emulate_std(regs, R2(regs->iir),0);
 		break;
-	}
 #endif
+	}
 	switch (regs->iir & OPCODE3_MASK)
 	{
 	case OPCODE_FLDW_L:



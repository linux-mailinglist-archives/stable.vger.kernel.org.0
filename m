Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE08328BED
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbhCASm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240179AbhCASgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F00DD65286;
        Mon,  1 Mar 2021 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619861;
        bh=boC0s/vZwpW/83mfi+2o0z/wAakmJeX6on3qlkZBqfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxAYs3MkjozJj0c5ig3uqcFdWKjBGhpHxCHiL6uAKP0RNTj2pxRl3k9GSCIfcVyT2
         W8CiOaNk5HfhdUOKiNai/wrYMWUkbtt5NNSqIW/QP+NTY8wkigkG7XqijBEa6BsEdU
         g4FRwxB+xWRMe6ZE4EvalDmUbrwcEqdhEw8E9CCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 607/663] powerpc/32: Preserve cr1 in exception prolog stack check to fix build error
Date:   Mon,  1 Mar 2021 17:14:15 +0100
Message-Id: <20210301161211.883656422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 3642eb21256a317ac14e9ed560242c6d20cf06d9 upstream.

THREAD_ALIGN_SHIFT = THREAD_SHIFT + 1 = PAGE_SHIFT + 1
Maximum PAGE_SHIFT is 18 for 256k pages so
THREAD_ALIGN_SHIFT is 19 at the maximum.

No need to clobber cr1, it can be preserved when moving r1
into CR when we check stack overflow.

This reduces the number of instructions in Machine Check Exception
prolog and fixes a build failure reported by the kernel test robot
on v5.10 stable when building with RTAS + VMAP_STACK + KVM. That
build failure is due to too many instructions in the prolog hence
not fitting between 0x200 and 0x300. Allthough the problem doesn't
show up in mainline, it is still worth the change.

Fixes: 98bf2d3f4970 ("powerpc/32s: Fix RTAS machine check with VMAP stack")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5ae4d545e3ac58e133d2599e0deb88843cb494fc.1612768623.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_32.h        |    2 +-
 arch/powerpc/kernel/head_book3s_32.S |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -56,7 +56,7 @@
 1:
 	tophys_novmstack r11, r11
 #ifdef CONFIG_VMAP_STACK
-	mtcrf	0x7f, r1
+	mtcrf	0x3f, r1
 	bt	32 - THREAD_ALIGN_SHIFT, stack_overflow
 #endif
 .endm
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -280,12 +280,6 @@ MachineCheck:
 7:	EXCEPTION_PROLOG_2
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 #ifdef CONFIG_PPC_CHRP
-#ifdef CONFIG_VMAP_STACK
-	mfspr	r4, SPRN_SPRG_THREAD
-	tovirt(r4, r4)
-	lwz	r4, RTAS_SP(r4)
-	cmpwi	cr1, r4, 0
-#endif
 	beq	cr1, machine_check_tramp
 	twi	31, 0, 0
 #else



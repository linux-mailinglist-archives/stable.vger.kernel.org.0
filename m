Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4153B2B6283
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgKQN3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731551AbgKQN3Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9396220781;
        Tue, 17 Nov 2020 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619756;
        bh=z9NTU619R+5CEdd4pUp0MofU7lmkDm90S80NkQVZqFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xnu4ScunJTB40gu/ljLL7YzHWyxlOR/voweKkyv2dmrve5GEl1vBfaDo8Z9UMyY3V
         kxi3C1ppb3bcSfh9XtD2hdWIA+2g30f+43rZZog/E6iHiE60nsiKgdOo3+creiYhmv
         P/toHLczufvQcPHIqvu+fVgST4VUQP89e+Ew7Bss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 146/151] powerpc/603: Always fault when _PAGE_ACCESSED is not set
Date:   Tue, 17 Nov 2020 14:06:16 +0100
Message-Id: <20201117122128.530783513@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 11522448e641e8f1690c9db06e01985e8e19b401 upstream.

The kernel expects pte_young() to work regardless of CONFIG_SWAP.

Make sure a minor fault is taken to set _PAGE_ACCESSED when it
is not already set, regardless of the selection of CONFIG_SWAP.

Fixes: 84de6ab0e904 ("powerpc/603: don't handle PAGE_ACCESSED in TLB miss handlers.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a44367744de54e2315b2f1a8cbbd7f88488072e0.1602342806.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/powerpc/kernel/head_32.S |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -418,11 +418,7 @@ InstructionTLBMiss:
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
-#else
-	li	r1,_PAGE_PRESENT | _PAGE_EXEC
-#endif
 #if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC)
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
@@ -484,11 +480,7 @@ DataLoadTLBMiss:
 	lis	r1,PAGE_OFFSET@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r1, _PAGE_PRESENT
-#endif
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
@@ -564,11 +556,7 @@ DataStoreTLBMiss:
 	lis	r1,PAGE_OFFSET@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT
-#endif
 	bge-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */



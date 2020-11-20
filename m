Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF72BA88C
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgKTLJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbgKTLHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63DEA22255;
        Fri, 20 Nov 2020 11:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870435;
        bh=gljOvNHXp1VTBEnY7Lwwr+Y4r9gqVd7Of+cJhgsToVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7TBPt1qeMDZwVlThiR9yu+0hgivVZWc2Ei+OJZ8reM9p3elG9t8mcCSuQY5el1IC
         ffPqlvpDO5KoQGv58qBOD8pKhRndXofZPJK+hMPaLwrPTVO1w1cdP7IyPCAdoN6poz
         j9T8uWNl0Kj5um+WJzjba+QPpVu+h+gDpIknNP2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 11/17] powerpc/8xx: Always fault when _PAGE_ACCESSED is not set
Date:   Fri, 20 Nov 2020 12:03:38 +0100
Message-Id: <20201120104541.615620653@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 29daf869cbab69088fe1755d9dd224e99ba78b56 upstream.

The kernel expects pte_young() to work regardless of CONFIG_SWAP.

Make sure a minor fault is taken to set _PAGE_ACCESSED when it
is not already set, regardless of the selection of CONFIG_SWAP.

This adds at least 3 instructions to the TLB miss exception
handlers fast path. Following patch will reduce this overhead.

Also update the rotation instruction to the correct number of bits
to reflect all changes done to _PAGE_ACCESSED over time.

Fixes: d069cb4373fe ("powerpc/8xx: Don't touch ACCESSED when no SWAP.")
Fixes: 5f356497c384 ("powerpc/8xx: remove unused _PAGE_WRITETHRU")
Fixes: e0a8e0d90a9f ("powerpc/8xx: Handle PAGE_USER via APG bits")
Fixes: 5b2753fc3e8a ("powerpc/8xx: Implementation of PAGE_EXEC")
Fixes: a891c43b97d3 ("powerpc/8xx: Prepare handlers for _PAGE_HUGE for 512k pages.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/af834e8a0f1fa97bfae65664950f0984a70c4750.1602492856.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_8xx.S |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -229,9 +229,7 @@ SystemCall:
 
 InstructionTLBMiss:
 	mtspr	SPRN_SPRG_SCRATCH0, r10
-#if defined(ITLB_MISS_KERNEL) || defined(CONFIG_SWAP)
 	mtspr	SPRN_SPRG_SCRATCH1, r11
-#endif
 
 	/* If we are faulting a kernel address, we have to use the
 	 * kernel page tables.
@@ -278,11 +276,9 @@ InstructionTLBMiss:
 #ifdef ITLB_MISS_KERNEL
 	mtcr	r11
 #endif
-#ifdef CONFIG_SWAP
-	rlwinm	r11, r10, 32-5, _PAGE_PRESENT
+	rlwinm	r11, r10, 32-7, _PAGE_PRESENT
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
-#endif
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 20 and 23 must be clear.
 	 * Software indicator bits 22, 24, 25, 26, and 27 must be
@@ -296,9 +292,7 @@ InstructionTLBMiss:
 
 	/* Restore registers */
 0:	mfspr	r10, SPRN_SPRG_SCRATCH0
-#if defined(ITLB_MISS_KERNEL) || defined(CONFIG_SWAP)
 	mfspr	r11, SPRN_SPRG_SCRATCH1
-#endif
 	rfi
 	patch_site	0b, patch__itlbmiss_exit_1
 
@@ -308,9 +302,7 @@ InstructionTLBMiss:
 	addi	r10, r10, 1
 	stw	r10, (itlb_miss_counter - PAGE_OFFSET)@l(0)
 	mfspr	r10, SPRN_SPRG_SCRATCH0
-#if defined(ITLB_MISS_KERNEL) || defined(CONFIG_SWAP)
 	mfspr	r11, SPRN_SPRG_SCRATCH1
-#endif
 	rfi
 #endif
 
@@ -394,11 +386,9 @@ DataStoreTLBMiss:
 	 * r11 = ((r10 & PRESENT) & ((r10 & ACCESSED) >> 5));
 	 * r10 = (r10 & ~PRESENT) | r11;
 	 */
-#ifdef CONFIG_SWAP
-	rlwinm	r11, r10, 32-5, _PAGE_PRESENT
+	rlwinm	r11, r10, 32-7, _PAGE_PRESENT
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
-#endif
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 24, 25, 26, and 27 must be
 	 * set.  All other Linux PTE bits control the behavior



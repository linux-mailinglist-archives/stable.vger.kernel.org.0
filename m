Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317485943A5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347928AbiHOWUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350806AbiHOWSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5608A3FA23;
        Mon, 15 Aug 2022 12:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E775E610A3;
        Mon, 15 Aug 2022 19:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CA6C433D6;
        Mon, 15 Aug 2022 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592536;
        bh=OggAWeCjBbOVAOvprMgUN8UYloEZQLkYuRLZdxCUCV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1yw+Cz8UZLmszdteRROVKaDaKKaJ3DD3PexnTJ5OaYohuVk3LvjZjtIqX6eBGI2p
         B0+ER0xlAtHJf1NuG+byWAntHyJW5Va/w8KWXBppRLNra66yJtgFNBGAPHQeAugoc4
         SnpzAtPtA+sn88eQPiCWnmKDuxhDo6W/CCcUEezs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.19 0126/1157] powerpc/64e: Fix early TLB miss with KUAP
Date:   Mon, 15 Aug 2022 19:51:22 +0200
Message-Id: <20220815180444.659154606@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 09317643117ade87c03158341e87466413fa8f1a upstream.

With KUAP, the TLB miss handler bails out when an access to user
memory is performed with a nul TID.

But the normal TLB miss routine which is only used early during boot
does the check regardless for all memory areas, not only user memory.

By chance there is no early IO or vmalloc access, but when KASAN
come we will start having early TLB misses.

Fix it by creating a special branch for user accesses similar to the
one in the 'bolted' TLB miss handlers. Unfortunately SPRN_MAS1 is
now read too early and there are no registers available to preserve
it so it will be read a second time.

Fixes: 57bc963837f5 ("powerpc/kuap: Wire-up KUAP on book3e/64")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/8d6c5859a45935d6e1a336da4dc20be421e8cea7.1656427701.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/nohash/tlb_low_64e.S |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/powerpc/mm/nohash/tlb_low_64e.S
+++ b/arch/powerpc/mm/nohash/tlb_low_64e.S
@@ -583,7 +583,7 @@ itlb_miss_fault_e6500:
 	 */
 	rlwimi	r11,r14,32-19,27,27
 	rlwimi	r11,r14,32-16,19,19
-	beq	normal_tlb_miss
+	beq	normal_tlb_miss_user
 	/* XXX replace the RMW cycles with immediate loads + writes */
 1:	mfspr	r10,SPRN_MAS1
 	cmpldi	cr0,r15,8		/* Check for vmalloc region */
@@ -626,7 +626,7 @@ itlb_miss_fault_e6500:
 
 	cmpldi	cr0,r15,0			/* Check for user region */
 	std	r14,EX_TLB_ESR(r12)		/* write crazy -1 to frame */
-	beq	normal_tlb_miss
+	beq	normal_tlb_miss_user
 
 	li	r11,_PAGE_PRESENT|_PAGE_BAP_SX	/* Base perm */
 	oris	r11,r11,_PAGE_ACCESSED@h
@@ -653,6 +653,12 @@ itlb_miss_fault_e6500:
  * r11 = PTE permission mask
  * r10 = crap (free to use)
  */
+normal_tlb_miss_user:
+#ifdef CONFIG_PPC_KUAP
+	mfspr	r14,SPRN_MAS1
+	rlwinm.	r14,r14,0,0x3fff0000
+	beq-	normal_tlb_miss_access_fault /* KUAP fault */
+#endif
 normal_tlb_miss:
 	/* So we first construct the page table address. We do that by
 	 * shifting the bottom of the address (not the region ID) by
@@ -683,11 +689,6 @@ finish_normal_tlb_miss:
 	/* Check if required permissions are met */
 	andc.	r15,r11,r14
 	bne-	normal_tlb_miss_access_fault
-#ifdef CONFIG_PPC_KUAP
-	mfspr	r11,SPRN_MAS1
-	rlwinm.	r10,r11,0,0x3fff0000
-	beq-	normal_tlb_miss_access_fault /* KUAP fault */
-#endif
 
 	/* Now we build the MAS:
 	 *
@@ -709,9 +710,7 @@ finish_normal_tlb_miss:
 	rldicl	r10,r14,64-8,64-8
 	cmpldi	cr0,r10,BOOK3E_PAGESZ_4K
 	beq-	1f
-#ifndef CONFIG_PPC_KUAP
 	mfspr	r11,SPRN_MAS1
-#endif
 	rlwimi	r11,r14,31,21,24
 	rlwinm	r11,r11,0,21,19
 	mtspr	SPRN_MAS1,r11



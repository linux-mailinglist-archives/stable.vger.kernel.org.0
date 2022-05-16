Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A652905A
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346822AbiEPUEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348452AbiEPT6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:58:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A7A49904;
        Mon, 16 May 2022 12:50:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F66560ABE;
        Mon, 16 May 2022 19:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE70C385AA;
        Mon, 16 May 2022 19:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730640;
        bh=WqEgjAv/oS4TRk1I5pfGDXx8BL7jPuyx/k9WWIWW6uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcPEvyRiH4EioRmjqdu51V6ifapiqMIXgwLn6q2VrUr/UEHmtARlRkBrkcTxJOmYR
         BW8JZPz9H9AGvtnrQQCYL9JctsSMtSldw7hGTwohMkTq2KyLjtKaSnav8OpTSVmo75
         BCyGderAZvf9QV3MQ+rXrSXBfSFWqR8QVnkt8FHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Evans <matt@ozlabs.org>,
        Alexander Graf <graf@amazon.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 064/102] KVM: PPC: Book3S PR: Enable MSR_DR for switch_mmu_context()
Date:   Mon, 16 May 2022 21:36:38 +0200
Message-Id: <20220516193625.833644141@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Graf <graf@amazon.com>

commit ee8348496c77e3737d0a6cda307a521f2cff954f upstream.

Commit 863771a28e27 ("powerpc/32s: Convert switch_mmu_context() to C")
moved the switch_mmu_context() to C. While in principle a good idea, it
meant that the function now uses the stack. The stack is not accessible
from real mode though.

So to keep calling the function, let's turn on MSR_DR while we call it.
That way, all pointer references to the stack are handled virtually.

In addition, make sure to save/restore r12 on the stack, as it may get
clobbered by the C function.

Fixes: 863771a28e27 ("powerpc/32s: Convert switch_mmu_context() to C")
Cc: stable@vger.kernel.org # v5.14+
Reported-by: Matt Evans <matt@ozlabs.org>
Signed-off-by: Alexander Graf <graf@amazon.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220510123717.24508-1-graf@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_32_sr.S | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_32_sr.S b/arch/powerpc/kvm/book3s_32_sr.S
index e3ab9df6cf19..6cfcd20d4668 100644
--- a/arch/powerpc/kvm/book3s_32_sr.S
+++ b/arch/powerpc/kvm/book3s_32_sr.S
@@ -122,11 +122,27 @@
 
 	/* 0x0 - 0xb */
 
-	/* 'current->mm' needs to be in r4 */
-	tophys(r4, r2)
-	lwz	r4, MM(r4)
-	tophys(r4, r4)
-	/* This only clobbers r0, r3, r4 and r5 */
+	/* switch_mmu_context() needs paging, let's enable it */
+	mfmsr   r9
+	ori     r11, r9, MSR_DR
+	mtmsr   r11
+	sync
+
+	/* switch_mmu_context() clobbers r12, rescue it */
+	SAVE_GPR(12, r1)
+
+	/* Calling switch_mmu_context(<inv>, current->mm, <inv>); */
+	lwz	r4, MM(r2)
 	bl	switch_mmu_context
 
+	/* restore r12 */
+	REST_GPR(12, r1)
+
+	/* Disable paging again */
+	mfmsr   r9
+	li      r6, MSR_DR
+	andc    r9, r9, r6
+	mtmsr	r9
+	sync
+
 .endm
-- 
2.36.1




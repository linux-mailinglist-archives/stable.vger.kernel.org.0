Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D922BA7FD
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgKTLDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:03:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgKTLDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:03:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A69522255;
        Fri, 20 Nov 2020 11:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870231;
        bh=7TWe9lY+5QXU9QLWXrhqzDH7IO1/lIcgGOrbwSSI+mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgL51h1eRpOqXV42Ycq/YkQxuuo+g1VMJC5vcJd2D5e4lL/6rmX2aWB/sE8I6yW8U
         DVHdyDZda7ZiuTteAq41LnF2IheCsov06MqWMHHB4/JKb/QQrBIAwRN4OwhcSICKZk
         HwqDtHclHYwjZTjac6mjWv6edKtO40NREsh4aGis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 12/15] powerpc/8xx: Always fault when _PAGE_ACCESSED is not set
Date:   Fri, 20 Nov 2020 12:03:10 +0100
Message-Id: <20201120104540.161286579@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
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
 arch/powerpc/kernel/head_8xx.S |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -361,11 +361,9 @@ InstructionTLBMiss:
 	/* Load the MI_TWC with the attributes for this "segment." */
 	MTSPR_CPU6(SPRN_MI_TWC, r11, r3)	/* Set segment attributes */
 
-#ifdef CONFIG_SWAP
-	rlwinm	r11, r10, 32-5, _PAGE_PRESENT
+	rlwinm	r11, r10, 32-11, _PAGE_PRESENT
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
-#endif
 	li	r11, RPN_PATTERN
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 20-23 and 28 must be clear.
@@ -436,11 +434,9 @@ DataStoreTLBMiss:
 	 * r11 = ((r10 & PRESENT) & ((r10 & ACCESSED) >> 5));
 	 * r10 = (r10 & ~PRESENT) | r11;
 	 */
-#ifdef CONFIG_SWAP
-	rlwinm	r11, r10, 32-5, _PAGE_PRESENT
+	rlwinm	r11, r10, 32-11, _PAGE_PRESENT
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
-#endif
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 22 and 28 must be clear.
 	 * Software indicator bits 24, 25, 26, and 27 must be



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F1B2ABAA3
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387770AbgKINVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388012AbgKINVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 031BC206D8;
        Mon,  9 Nov 2020 13:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928062;
        bh=8YdJdY382QSEOjK9jFF6B7jhR85Sfy/nDMfGLnlL7Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uw1AZN4O6CaLKs2i3doMddrDLMvMyowIsEroXtPP+lmMQqr2EElUIMIjSzI0LfIqB
         UJiSlZ65UPgmNw8gTWRF0TP36eA+uL24S6t8v/y2vgVj1Q5NdJ+sjBzdiHNx7wxRi0
         KxCMJrAZz363Ht4fnubq51qYvEnP2LjUnZ0Lb6jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 114/133] powerpc/40x: Always fault when _PAGE_ACCESSED is not set
Date:   Mon,  9 Nov 2020 13:56:16 +0100
Message-Id: <20201109125036.171681591@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 0540b0d2ce9073fd2a736d636218faa61c99e572 upstream.

The kernel expects pte_young() to work regardless of CONFIG_SWAP.

Make sure a minor fault is taken to set _PAGE_ACCESSED when it
is not already set, regardless of the selection of CONFIG_SWAP.

Fixes: 2c74e2586bb9 ("powerpc/40x: Rework 40x PTE access and TLB miss")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/b02ca2ed2d3676a096219b48c0f69ec982a75bcf.1602342801.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_40x.S |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -285,11 +285,7 @@ _ENTRY(saved_ksp_limit)
 
 	rlwimi	r11, r10, 22, 20, 29	/* Compute PTE address */
 	lwz	r11, 0(r11)		/* Get Linux PTE */
-#ifdef CONFIG_SWAP
 	li	r9, _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r9, _PAGE_PRESENT
-#endif
 	andc.	r9, r9, r11		/* Check permission */
 	bne	5f
 
@@ -370,11 +366,7 @@ _ENTRY(saved_ksp_limit)
 
 	rlwimi	r11, r10, 22, 20, 29	/* Compute PTE address */
 	lwz	r11, 0(r11)		/* Get Linux PTE */
-#ifdef CONFIG_SWAP
 	li	r9, _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
-#else
-	li	r9, _PAGE_PRESENT | _PAGE_EXEC
-#endif
 	andc.	r9, r9, r11		/* Check permission */
 	bne	5f
 



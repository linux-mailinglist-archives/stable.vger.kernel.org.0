Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FDE2B65E9
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgKQN7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730670AbgKQNS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52B5B24654;
        Tue, 17 Nov 2020 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619105;
        bh=O8sN/Fj7w+5g61Gjf9SEq4lrUkuxb/eAuuxjUzW77+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfgn3NbvhhyTc8spwsyTYbNl+XWrzkULpLIt/vN31h3pUKD3Ayzfuwh+s4oRFhj6F
         Tyj8SknAex9ICLU1tygWOiO7IcgpGUzFcMQpacyIOyJhJBM6/XXN7V3mdPHwKyOhJT
         7sUPGFlzNxu0USkQH0OHBXQG23b85Yx3Tq9aTfak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 029/101] crypto: arm64/aes-modes - get rid of literal load of addend vector
Date:   Tue, 17 Nov 2020 14:04:56 +0100
Message-Id: <20201117122114.510330023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit ed6ed11830a9ded520db31a6e2b69b6b0a1eb0e2 upstream.

Replace the literal load of the addend vector with a sequence that
performs each add individually. This sequence is only 2 instructions
longer than the original, and 2% faster on Cortex-A53.

This is an improvement by itself, but also works around a Clang issue,
whose integrated assembler does not implement the GNU ARM asm syntax
completely, and does not support the =literal notation for FP registers
(more info at https://bugs.llvm.org/show_bug.cgi?id=38642)

Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/aes-modes.S |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -232,17 +232,19 @@ AES_ENTRY(aes_ctr_encrypt)
 	bmi		.Lctr1x
 	cmn		w6, #4			/* 32 bit overflow? */
 	bcs		.Lctr1x
-	ldr		q8, =0x30000000200000001	/* addends 1,2,3[,0] */
-	dup		v7.4s, w6
+	add		w7, w6, #1
 	mov		v0.16b, v4.16b
-	add		v7.4s, v7.4s, v8.4s
+	add		w8, w6, #2
 	mov		v1.16b, v4.16b
-	rev32		v8.16b, v7.16b
+	add		w9, w6, #3
 	mov		v2.16b, v4.16b
+	rev		w7, w7
 	mov		v3.16b, v4.16b
-	mov		v1.s[3], v8.s[0]
-	mov		v2.s[3], v8.s[1]
-	mov		v3.s[3], v8.s[2]
+	rev		w8, w8
+	mov		v1.s[3], w7
+	rev		w9, w9
+	mov		v2.s[3], w8
+	mov		v3.s[3], w9
 	ld1		{v5.16b-v7.16b}, [x20], #48	/* get 3 input blocks */
 	bl		aes_encrypt_block4x
 	eor		v0.16b, v5.16b, v0.16b



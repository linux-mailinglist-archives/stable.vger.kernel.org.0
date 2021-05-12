Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DF537CC06
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbhELQjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234027AbhELQcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64A8761961;
        Wed, 12 May 2021 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835097;
        bh=mR/WiV/w0/3WcnudLURQeZbeanChhZMNhZqG0c+pcxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGDPZWitxVvMd7zT9eeyCHuyo5IiyFOKosAPZpj/X4LsUf3EZry9UWkPDl77DUGpe
         uld2DVXYBzELBr6o112r9HuLjF6EgPZL70GdtjsgZ3S2pRjPtJVfazQbeChx0ZDDZj
         s4H/PaTW+iVRmG+j2aS8KZ8ijJtixY9h3PxtB4dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 207/677] crypto: arm/blake2s - fix for big endian
Date:   Wed, 12 May 2021 16:44:13 +0200
Message-Id: <20210512144844.119642341@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit d2f2516a3882c0c6463e33c9b112b39bd483f821 ]

The new ARM BLAKE2s code doesn't work correctly (fails the self-tests)
in big endian kernel builds because it doesn't swap the endianness of
the message words when loading them.  Fix this.

Fixes: 5172d322d34c ("crypto: arm/blake2s - add ARM scalar optimized BLAKE2s")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/blake2s-core.S | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/crypto/blake2s-core.S b/arch/arm/crypto/blake2s-core.S
index bed897e9a181..86345751bbf3 100644
--- a/arch/arm/crypto/blake2s-core.S
+++ b/arch/arm/crypto/blake2s-core.S
@@ -8,6 +8,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 	// Registers used to hold message words temporarily.  There aren't
 	// enough ARM registers to hold the whole message block, so we have to
@@ -38,6 +39,23 @@
 #endif
 .endm
 
+.macro _le32_bswap	a, tmp
+#ifdef __ARMEB__
+	rev_l		\a, \tmp
+#endif
+.endm
+
+.macro _le32_bswap_8x	a, b, c, d, e, f, g, h,  tmp
+	_le32_bswap	\a, \tmp
+	_le32_bswap	\b, \tmp
+	_le32_bswap	\c, \tmp
+	_le32_bswap	\d, \tmp
+	_le32_bswap	\e, \tmp
+	_le32_bswap	\f, \tmp
+	_le32_bswap	\g, \tmp
+	_le32_bswap	\h, \tmp
+.endm
+
 // Execute a quarter-round of BLAKE2s by mixing two columns or two diagonals.
 // (a0, b0, c0, d0) and (a1, b1, c1, d1) give the registers containing the two
 // columns/diagonals.  s0-s1 are the word offsets to the message words the first
@@ -180,8 +198,10 @@ ENTRY(blake2s_compress_arch)
 	tst		r1, #3
 	bne		.Lcopy_block_misaligned
 	ldmia		r1!, {r2-r9}
+	_le32_bswap_8x	r2, r3, r4, r5, r6, r7, r8, r9,  r14
 	stmia		r12!, {r2-r9}
 	ldmia		r1!, {r2-r9}
+	_le32_bswap_8x	r2, r3, r4, r5, r6, r7, r8, r9,  r14
 	stmia		r12, {r2-r9}
 .Lcopy_block_done:
 	str		r1, [sp, #68]		// Update message pointer
@@ -268,6 +288,7 @@ ENTRY(blake2s_compress_arch)
 1:
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	ldr		r3, [r1], #4
+	_le32_bswap	r3, r4
 #else
 	ldrb		r3, [r1, #0]
 	ldrb		r4, [r1, #1]
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D722D23658
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389394AbfETM1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389391AbfETM1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:27:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39CCB21479;
        Mon, 20 May 2019 12:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355220;
        bh=vcsAg9xRpXy+KlU7TP4BpvChs2PpjWCmcKckfnNXW2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHt4pftRC2QIfvA4CHsy6H0uB9k2TSrxzCcMNG76g3aBxuKf9HrOgpYyvC+umepyN
         QOLaHKATSZUn+CIoNuHjUCtWqOR3WRP+bqABdt7AkhjXrFLRY6O9klqdhuUPbJblvh
         s3xXZTNj4W+Xkkf4tefUerM2Gi30bRyIgzmNt354=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.0 036/123] crypto: arm64/gcm-aes-ce - fix no-NEON fallback code
Date:   Mon, 20 May 2019 14:13:36 +0200
Message-Id: <20190520115247.139025144@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 580e295178402d14bbf598a5702f8e01fc59dbaa upstream.

The arm64 gcm-aes-ce algorithm is failing the extra crypto self-tests
following my patches to test the !may_use_simd() code paths, which
previously were untested.  The problem is that in the !may_use_simd()
case, an odd number of AES blocks can be processed within each step of
the skcipher_walk.  However, the skcipher_walk is being done with a
"stride" of 2 blocks and is advanced by an even number of blocks after
each step.  This causes the encryption to produce the wrong ciphertext
and authentication tag, and causes the decryption to incorrectly fail.

Fix it by only processing an even number of blocks per step.

Fixes: c2b24c36e0a3 ("crypto: arm64/aes-gcm-ce - fix scatterwalk API violation")
Fixes: 71e52c278c54 ("crypto: arm64/aes-ce-gcm - operate on two input blocks at a time")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/ghash-ce-glue.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -418,9 +418,11 @@ static int gcm_encrypt(struct aead_reque
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 		while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+			const int blocks =
+				walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
 			u8 *dst = walk.dst.virt.addr;
 			u8 *src = walk.src.virt.addr;
+			int remaining = blocks;
 
 			do {
 				__aes_arm64_encrypt(ctx->aes_key.key_enc,
@@ -430,9 +432,9 @@ static int gcm_encrypt(struct aead_reque
 
 				dst += AES_BLOCK_SIZE;
 				src += AES_BLOCK_SIZE;
-			} while (--blocks > 0);
+			} while (--remaining > 0);
 
-			ghash_do_update(walk.nbytes / AES_BLOCK_SIZE, dg,
+			ghash_do_update(blocks, dg,
 					walk.dst.virt.addr, &ctx->ghash_key,
 					NULL);
 
@@ -553,7 +555,7 @@ static int gcm_decrypt(struct aead_reque
 		put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
 		while (walk.nbytes >= (2 * AES_BLOCK_SIZE)) {
-			int blocks = walk.nbytes / AES_BLOCK_SIZE;
+			int blocks = walk.nbytes / (2 * AES_BLOCK_SIZE) * 2;
 			u8 *dst = walk.dst.virt.addr;
 			u8 *src = walk.src.virt.addr;
 



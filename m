Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E840F236DE
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbfETMR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387523AbfETMR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A361921019;
        Mon, 20 May 2019 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354648;
        bh=Oew7obFmunycMIJ2UJPJdli7xmc7FLlH1V4LzxOuboI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBvx0J2Ux3gArt9ROzFeWrcLF7FJZFqRoSYkAKN5/fc2bOW3O61RJKPuuIKniHVt8
         LDxyFomOgZFXznw7BXDuJUxrPdQk109v5j/pGuu6v0BASqidWwfizt5jmdlMmgw08X
         WS3z8ZonIbh/6+2gpZmlfsu82Q7X9Z0E7izPeMAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 37/44] crypto: arm/aes-neonbs - dont access already-freed walk.iv
Date:   Mon, 20 May 2019 14:14:26 +0200
Message-Id: <20190520115235.408291823@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 767f015ea0b7ab9d60432ff6cd06b664fd71f50f upstream.

If the user-provided IV needs to be aligned to the algorithm's
alignmask, then skcipher_walk_virt() copies the IV into a new aligned
buffer walk.iv.  But skcipher_walk_virt() can fail afterwards, and then
if the caller unconditionally accesses walk.iv, it's a use-after-free.

arm32 xts-aes-neonbs doesn't set an alignmask, so currently it isn't
affected by this despite unconditionally accessing walk.iv.  However
this is more subtle than desired, and it was actually broken prior to
the alignmask being removed by commit cc477bf64573 ("crypto: arm/aes -
replace bit-sliced OpenSSL NEON code").  Thus, update xts-aes-neonbs to
start checking the return value of skcipher_walk_virt().

Fixes: e4e7f10bfc40 ("ARM: add support for bit sliced AES using NEON instructions")
Cc: <stable@vger.kernel.org> # v3.13+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm/crypto/aesbs-glue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/crypto/aesbs-glue.c
+++ b/arch/arm/crypto/aesbs-glue.c
@@ -265,6 +265,8 @@ static int aesbs_xts_encrypt(struct blkc
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);
@@ -289,6 +291,8 @@ static int aesbs_xts_decrypt(struct blkc
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt_block(desc, &walk, 8 * AES_BLOCK_SIZE);
+	if (err)
+		return err;
 
 	/* generate the initial tweak */
 	AES_encrypt(walk.iv, walk.iv, &ctx->twkey);



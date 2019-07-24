Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307AF7462D
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389336AbfGYFoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391189AbfGYFoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:44:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A0DE22C7D;
        Thu, 25 Jul 2019 05:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033449;
        bh=HMENl/L5+knTn/Fjjyg+GxPo4hsqznlJ+G8e9eT390w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGjgTmiWzLmQ+wE3xDz/ZhvyYLG0HHydm8PD/drj2HSQpSn09NHo2S1GJxL98DjAi
         AZqrN/S/QXrxzjRTKKAw2XCiFGjYbIOI/Fn4P3Ndtb5KqvykGziu076c/cmFz6G9tD
         za66C1sxeOyNRJfGenoJ7lgEno8xGRjJwqqJa9ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 172/271] crypto: ghash - fix unaligned memory access in ghash_setkey()
Date:   Wed, 24 Jul 2019 21:20:41 +0200
Message-Id: <20190724191709.922316026@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 5c6bc4dfa515738149998bb0db2481a4fdead979 upstream.

Changing ghash_mod_init() to be subsys_initcall made it start running
before the alignment fault handler has been installed on ARM.  In kernel
builds where the keys in the ghash test vectors happened to be
misaligned in the kernel image, this exposed the longstanding bug that
ghash_setkey() is incorrectly casting the key buffer (which can have any
alignment) to be128 for passing to gf128mul_init_4k_lle().

Fix this by memcpy()ing the key to a temporary buffer.

Don't fix it by setting an alignmask on the algorithm instead because
that would unnecessarily force alignment of the data too.

Fixes: 2cdc6899a88e ("crypto: ghash - Add GHASH digest algorithm for GCM")
Reported-by: Peter Robinson <pbrobinson@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/ghash-generic.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -34,6 +34,7 @@ static int ghash_setkey(struct crypto_sh
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+	be128 k;
 
 	if (keylen != GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -42,7 +43,12 @@ static int ghash_setkey(struct crypto_sh
 
 	if (ctx->gf128)
 		gf128mul_free_4k(ctx->gf128);
-	ctx->gf128 = gf128mul_init_4k_lle((be128 *)key);
+
+	BUILD_BUG_ON(sizeof(k) != GHASH_BLOCK_SIZE);
+	memcpy(&k, key, GHASH_BLOCK_SIZE); /* avoid violating alignment rules */
+	ctx->gf128 = gf128mul_init_4k_lle(&k);
+	memzero_explicit(&k, GHASH_BLOCK_SIZE);
+
 	if (!ctx->gf128)
 		return -ENOMEM;
 



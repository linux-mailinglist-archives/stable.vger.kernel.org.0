Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7D23013B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 19:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfE3Rvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 13:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3Rvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 13:51:46 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 298D925EBD;
        Thu, 30 May 2019 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559238705;
        bh=i3XOSxLt0gd25Lvgu66PwiGPL7WdnuFqSIPbfSPRNvs=;
        h=From:To:Cc:Subject:Date:From;
        b=rdLpfIoVgc/waPa/9jjiNG++x8Ie13iqFnrqFxGMBVvq5z5bOtk5kqjgmoUd9EqNh
         xaTAvep02q+Ww1Bxy9imO7Z98/KYj5jqMwhBXRwW10U8QdMwnmPyXc4nz19bRSP2XJ
         Xaix7O+I2Qi5LiV+n1IAEWeN19gjYBYLSopFY8Cw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Peter Robinson <pbrobinson@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] crypto: ghash - fix unaligned memory access in ghash_setkey()
Date:   Thu, 30 May 2019 10:50:39 -0700
Message-Id: <20190530175039.195574-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

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
---
 crypto/ghash-generic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index e6307935413c1..c8a347798eae6 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -34,6 +34,7 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+	be128 k;
 
 	if (keylen != GHASH_BLOCK_SIZE) {
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -42,7 +43,12 @@ static int ghash_setkey(struct crypto_shash *tfm,
 
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
 
-- 
2.22.0.rc1.257.g3120a18244-goog


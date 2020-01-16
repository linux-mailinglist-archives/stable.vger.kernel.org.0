Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE9613E3C9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbgAPRDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:03:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388024AbgAPRC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F9C24653;
        Thu, 16 Jan 2020 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194175;
        bh=7xz+vLnFw4XjnRLafaQcO0K8hzVM1v1QHQw2s1h9R3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKz9uwGZgwfXW1zZw1M1kT0RzuyUwj6yYdLXGx5lUr4o/sYPSnrZy016LSdpoOEvF
         casriQ2qURnN0gZfRmYaPHZOgkgBb1PRQLYP1wPnkoJB73WzMJ8bx3uw0MB0wAL1FH
         xnfyn478eq3vstIeASNMdS9yWEWbXjeC2LKUxM1M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 253/671] crypto: ccree - reduce kernel stack usage with clang
Date:   Thu, 16 Jan 2020 11:52:42 -0500
Message-Id: <20200116165940.10720-136-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5db46ac29a6797541943d3c4081821747e342732 ]

Building with clang for a 32-bit architecture runs over the stack
frame limit in the setkey function:

drivers/crypto/ccree/cc_cipher.c:318:12: error: stack frame size of 1152 bytes in function 'cc_cipher_setkey' [-Werror,-Wframe-larger-than=]

The problem is that there are two large variables: the temporary
'tmp' array and the SHASH_DESC_ON_STACK() declaration. Moving
the first into the block in which it is used reduces the
total frame size to 768 bytes, which seems more reasonable
and is under the warning limit.

Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-By: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 54a39164aab8..28a5b8b38fa2 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -306,7 +306,6 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(sktfm);
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	u32 tmp[DES3_EDE_EXPKEY_WORDS];
 	struct cc_crypto_alg *cc_alg =
 			container_of(tfm->__crt_alg, struct cc_crypto_alg,
 				     skcipher_alg.base);
@@ -332,6 +331,7 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	 * HW does the expansion on its own.
 	 */
 	if (ctx_p->flow_mode == S_DIN_to_DES) {
+		u32 tmp[DES3_EDE_EXPKEY_WORDS];
 		if (keylen == DES3_EDE_KEY_SIZE &&
 		    __des3_ede_setkey(tmp, &tfm->crt_flags, key,
 				      DES3_EDE_KEY_SIZE)) {
-- 
2.20.1


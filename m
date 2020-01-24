Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD5148498
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389790AbgAXLPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389143AbgAXLPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:00 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D12DA2075D;
        Fri, 24 Jan 2020 11:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864500;
        bh=X9i5C4/sC5uBnkoCnSFyPe6JepwPdQ+sVLyu9VPvxuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiKWtfi6yLE3AOm9TerVN6nd8tDSPZ91cPYije+vkuJcBP9mPAQhhIVoU5K5XGcfF
         yR5T6x7s25cxQZft48Rz7mBtE79RHsH+RKAUgj1EXHGTPgAoKs1xIW0ksDft4VHotx
         fzjxVk2zsrmeJIfZFaT8LWasajIY6fVI9y3omqz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 269/639] crypto: ccree - reduce kernel stack usage with clang
Date:   Fri, 24 Jan 2020 10:27:19 +0100
Message-Id: <20200124093120.395167362@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 54a39164aab8f..28a5b8b38fa2f 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C527498F95
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348366AbiAXTxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346805AbiAXTsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E4AAB81142;
        Mon, 24 Jan 2022 19:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8241EC340E5;
        Mon, 24 Jan 2022 19:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053720;
        bh=po8e2/5PZlaR1L4ebFA+7hbiUKq4RTDZucpG7BuzS80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URNNM7f5X/6z6x6I6CT/BbKGNrOvF0crskxICMnPS2zepDgEoVMtSYfNYJQlPy3Mv
         orIjllDKPhSvWAjdaPVzWv0rI32e151C4pi3gqLj9Hnqh6fyv/dwnlmcjkYDrL4enW
         XqAl3gyQV8rSncM3bSlY+8fRkhUj08Bu/M+ta9jE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/563] crypto: stm32/cryp - check early input data
Date:   Mon, 24 Jan 2022 19:38:41 +0100
Message-Id: <20220124184029.782338718@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>

[ Upstream commit 39e6e699c7fb92bdb2617b596ca4a4ea35c5d2a7 ]

Some auto tests failed because driver wasn't returning the expected
error with some input size/iv value/tag size.
Now:
 Return 0 early for empty buffer. (We don't need to start the engine for
 an empty input buffer).
 Accept any valid authsize for gcm(aes).
 Return -EINVAL if iv for ccm(aes) is invalid.
 Return -EINVAL if buffer size is a not a multiple of algorithm block size.

Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-cryp.c | 114 +++++++++++++++++++++++++++++-
 1 file changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index e2bcc4f98b0ae..fd7fb73a4d450 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -799,7 +799,20 @@ static int stm32_cryp_aes_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 static int stm32_cryp_aes_gcm_setauthsize(struct crypto_aead *tfm,
 					  unsigned int authsize)
 {
-	return authsize == AES_BLOCK_SIZE ? 0 : -EINVAL;
+	switch (authsize) {
+	case 4:
+	case 8:
+	case 12:
+	case 13:
+	case 14:
+	case 15:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int stm32_cryp_aes_ccm_setauthsize(struct crypto_aead *tfm,
@@ -823,31 +836,61 @@ static int stm32_cryp_aes_ccm_setauthsize(struct crypto_aead *tfm,
 
 static int stm32_cryp_aes_ecb_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_ECB | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_ecb_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_ECB);
 }
 
 static int stm32_cryp_aes_cbc_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CBC | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_cbc_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CBC);
 }
 
 static int stm32_cryp_aes_ctr_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CTR | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_ctr_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_AES | FLG_CTR);
 }
 
@@ -861,53 +904,122 @@ static int stm32_cryp_aes_gcm_decrypt(struct aead_request *req)
 	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_GCM);
 }
 
+static inline int crypto_ccm_check_iv(const u8 *iv)
+{
+	/* 2 <= L <= 8, so 1 <= L' <= 7. */
+	if (iv[0] < 1 || iv[0] > 7)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int stm32_cryp_aes_ccm_encrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_ccm_check_iv(req->iv);
+	if (err)
+		return err;
+
 	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_CCM | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_aes_ccm_decrypt(struct aead_request *req)
 {
+	int err;
+
+	err = crypto_ccm_check_iv(req->iv);
+	if (err)
+		return err;
+
 	return stm32_cryp_aead_crypt(req, FLG_AES | FLG_CCM);
 }
 
 static int stm32_cryp_des_ecb_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_ECB | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_des_ecb_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_ECB);
 }
 
 static int stm32_cryp_des_cbc_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_CBC | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_des_cbc_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_DES | FLG_CBC);
 }
 
 static int stm32_cryp_tdes_ecb_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_ECB | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_tdes_ecb_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_ECB);
 }
 
 static int stm32_cryp_tdes_cbc_encrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_CBC | FLG_ENCRYPT);
 }
 
 static int stm32_cryp_tdes_cbc_decrypt(struct skcipher_request *req)
 {
+	if (req->cryptlen % DES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (req->cryptlen == 0)
+		return 0;
+
 	return stm32_cryp_crypt(req, FLG_TDES | FLG_CBC);
 }
 
-- 
2.34.1




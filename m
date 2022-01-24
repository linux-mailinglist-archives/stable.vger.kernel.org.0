Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB15499A6B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353537AbiAXVny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454654AbiAXVdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75BDC0612F3;
        Mon, 24 Jan 2022 12:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B36CB81253;
        Mon, 24 Jan 2022 20:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE77C340E7;
        Mon, 24 Jan 2022 20:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055686;
        bh=po8e2/5PZlaR1L4ebFA+7hbiUKq4RTDZucpG7BuzS80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06HCHkiSw4icqZVnOnubmI/cSKw8ytx3F6MVrAlqsLGLQN+SanCmGFX/zZ5y+MbEN
         Qq74OW4loHkL1qPSVwEyoks4M9FT8kkjI9kM1pPiyuop499xZdLf3aL6BIEDDx9/9Q
         EzPeihjE9SDKFPNv9efU05emE63ytPqc91lHdtvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 233/846] crypto: stm32/cryp - check early input data
Date:   Mon, 24 Jan 2022 19:35:50 +0100
Message-Id: <20220124184108.974205884@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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




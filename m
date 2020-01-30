Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9082F14E0FF
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgA3Skf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:40:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729978AbgA3Skf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:40:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C69D214AF;
        Thu, 30 Jan 2020 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409633;
        bh=aGwpC8iju2NDmog4SVcTMHJcsWidLpQKpc1y0YLMHAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/2YUu23ctYJo8caWk1OGr9x6im1Nk6gGVx1nGeyd4FbOat24AG4FyjLScJG21mEe
         AU2NTuFQjyAF9alaUt6cGqzOfZHMvFR7ooostB1cNU+BMZv9wza1Hh/gBvf+rS25+Y
         jKAIzzwvv1v61QKwz9Of6g7J5HUYGHCWY1z/iM7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atul Gupta <atul.gupta@chelsio.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.5 28/56] crypto: chelsio - fix writing tfm flags to wrong place
Date:   Thu, 30 Jan 2020 19:38:45 +0100
Message-Id: <20200130183614.222569639@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit bd56cea012fc2d6381e8cd3209510ce09f9de8c9 upstream.

The chelsio crypto driver is casting 'struct crypto_aead' directly to
'struct crypto_tfm', which is incorrect because the crypto_tfm isn't the
first field of 'struct crypto_aead'.  Consequently, the calls to
crypto_tfm_set_flags() are modifying some other field in the struct.

Also, the driver is setting CRYPTO_TFM_RES_BAD_KEY_LEN in
->setauthsize(), not just in ->setkey().  This is incorrect since this
flag is for bad key lengths, not for bad authentication tag lengths.

Fix these bugs by removing the broken crypto_tfm_set_flags() calls from
->setauthsize() and by fixing them in ->setkey().

Fixes: 324429d74127 ("chcr: Support for Chelsio's Crypto Hardware")
Cc: <stable@vger.kernel.org> # v4.9+
Cc: Atul Gupta <atul.gupta@chelsio.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/chelsio/chcr_algo.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -3195,9 +3195,6 @@ static int chcr_gcm_setauthsize(struct c
 		aeadctx->mayverify = VERIFY_SW;
 		break;
 	default:
-
-		  crypto_tfm_set_flags((struct crypto_tfm *) tfm,
-			CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	return crypto_aead_setauthsize(aeadctx->sw_cipher, authsize);
@@ -3222,8 +3219,6 @@ static int chcr_4106_4309_setauthsize(st
 		aeadctx->mayverify = VERIFY_HW;
 		break;
 	default:
-		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
-				     CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	return crypto_aead_setauthsize(aeadctx->sw_cipher, authsize);
@@ -3264,8 +3259,6 @@ static int chcr_ccm_setauthsize(struct c
 		aeadctx->mayverify = VERIFY_HW;
 		break;
 	default:
-		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
-				     CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 	return crypto_aead_setauthsize(aeadctx->sw_cipher, authsize);
@@ -3290,8 +3283,7 @@ static int chcr_ccm_common_setkey(struct
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 		mk_size = CHCR_KEYCTX_MAC_KEY_SIZE_256;
 	} else {
-		crypto_tfm_set_flags((struct crypto_tfm *)aead,
-				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		aeadctx->enckey_len = 0;
 		return	-EINVAL;
 	}
@@ -3329,8 +3321,7 @@ static int chcr_aead_rfc4309_setkey(stru
 	int error;
 
 	if (keylen < 3) {
-		crypto_tfm_set_flags((struct crypto_tfm *)aead,
-				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		aeadctx->enckey_len = 0;
 		return	-EINVAL;
 	}
@@ -3380,8 +3371,7 @@ static int chcr_gcm_setkey(struct crypto
 	} else if (keylen == AES_KEYSIZE_256) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 	} else {
-		crypto_tfm_set_flags((struct crypto_tfm *)aead,
-				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		pr_err("GCM: Invalid key length %d\n", keylen);
 		ret = -EINVAL;
 		goto out;



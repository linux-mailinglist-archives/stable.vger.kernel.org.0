Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C487D121260
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfLPRwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfLPRwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D9902166E;
        Mon, 16 Dec 2019 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518726;
        bh=/0oP2aOmkN4YPfnfmuZKKa5D6e4/N1L0vU89h5RbObk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZy6slkSskF6yqk1d3lkA7Sq61sxj563aQTyFz0FzyAZ3nkVbxKLgBHXJWqooOOhm
         bXqbdR8RkzghTLMpi3ndwiPUk5Mj2KnwqD++ARFSO9y9IoWH+29Ua91JSjongrjVDJ
         SxReNY+M9DlwldLrCcdOeyqOjKY4VMnbDoaO9Aec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/267] crypto: ecc - check for invalid values in the key verification test
Date:   Mon, 16 Dec 2019 18:46:07 +0100
Message-Id: <20191216174853.358885933@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Chikunov <vt@altlinux.org>

[ Upstream commit 2eb4942b6609d35a4e835644a33203b0aef7443d ]

Currently used scalar multiplication algorithm (Matthieu Rivain, 2011)
have invalid values for scalar == 1, n-1, and for regularized version
n-2, which was previously not checked. Verify that they are not used as
private keys.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ecc.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 18f32f2a5e1c9..3b422e24e647e 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -904,30 +904,43 @@ static inline void ecc_swap_digits(const u64 *in, u64 *out,
 		out[i] = __swab64(in[ndigits - 1 - i]);
 }
 
-int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
-		     const u64 *private_key, unsigned int private_key_len)
+static int __ecc_is_key_valid(const struct ecc_curve *curve,
+			      const u64 *private_key, unsigned int ndigits)
 {
-	int nbytes;
-	const struct ecc_curve *curve = ecc_get_curve(curve_id);
+	u64 one[ECC_MAX_DIGITS] = { 1, };
+	u64 res[ECC_MAX_DIGITS];
 
 	if (!private_key)
 		return -EINVAL;
 
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
-
-	if (private_key_len != nbytes)
+	if (curve->g.ndigits != ndigits)
 		return -EINVAL;
 
-	if (vli_is_zero(private_key, ndigits))
+	/* Make sure the private key is in the range [2, n-3]. */
+	if (vli_cmp(one, private_key, ndigits) != -1)
 		return -EINVAL;
-
-	/* Make sure the private key is in the range [1, n-1]. */
-	if (vli_cmp(curve->n, private_key, ndigits) != 1)
+	vli_sub(res, curve->n, one, ndigits);
+	vli_sub(res, res, one, ndigits);
+	if (vli_cmp(res, private_key, ndigits) != 1)
 		return -EINVAL;
 
 	return 0;
 }
 
+int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
+		     const u64 *private_key, unsigned int private_key_len)
+{
+	int nbytes;
+	const struct ecc_curve *curve = ecc_get_curve(curve_id);
+
+	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+
+	if (private_key_len != nbytes)
+		return -EINVAL;
+
+	return __ecc_is_key_valid(curve, private_key, ndigits);
+}
+
 /*
  * ECC private keys are generated using the method of extra random bits,
  * equivalent to that described in FIPS 186-4, Appendix B.4.1.
@@ -971,11 +984,8 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 	if (err)
 		return err;
 
-	if (vli_is_zero(priv, ndigits))
-		return -EINVAL;
-
-	/* Make sure the private key is in the range [1, n-1]. */
-	if (vli_cmp(curve->n, priv, ndigits) != 1)
+	/* Make sure the private key is in the valid range. */
+	if (__ecc_is_key_valid(curve, priv, ndigits))
 		return -EINVAL;
 
 	ecc_swap_digits(priv, privkey, ndigits);
-- 
2.20.1




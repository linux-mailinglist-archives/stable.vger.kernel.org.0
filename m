Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E201D328B9B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbhCASiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236703AbhCASaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:30:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCBC0651A9;
        Mon,  1 Mar 2021 17:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618752;
        bh=06Dlie7K3smpX3prx+bOGmlIjEG3pFPeCWJSSyyBBYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoGJv4D2Ax2CPff34g90qbkcxHjvTcX15BOwIXUuA44hfmyRaNR2dYgX7/iqco78u
         mU1wqi/MQr3yoNNz87nk0RS29evhtEAOnrxOYWZ1jP4hYzG58tW99OK9HiWYkJQmNv
         2dONuFUsSc5E9YDhviZFfP3uupRLGecp0auJBqXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/663] crypto: talitos - Fix ctr(aes) on SEC1
Date:   Mon,  1 Mar 2021 17:07:32 +0100
Message-Id: <20210301161151.876616591@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 43a942d27eaaf33bca560121cbe42f3637e92880 ]

While ctr(aes) requires the use of a special descriptor on SEC2 (see
commit 70d355ccea89 ("crypto: talitos - fix ctr-aes-talitos")), that
special descriptor doesn't work on SEC1, see commit e738c5f15562
("powerpc/8xx: Add DT node for using the SEC engine of the MPC885").

However, the common nonsnoop descriptor works properly on SEC1 for
ctr(aes).

Add a second template for ctr(aes) that will be registered
only on SEC1.

Fixes: 70d355ccea89 ("crypto: talitos - fix ctr-aes-talitos")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 806d4996af8d0..ae86557291c3f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2764,6 +2764,22 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_SEL0_AESU |
 				     DESC_HDR_MODE0_AESU_CTR,
 	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "ctr(aes)",
+			.base.cra_driver_name = "ctr-aes-talitos",
+			.base.cra_blocksize = 1,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.setkey = skcipher_aes_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CTR,
+	},
 	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
 			.base.cra_name = "ecb(des)",
@@ -3181,6 +3197,12 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 			t_alg->algt.alg.skcipher.setkey ?: skcipher_setkey;
 		t_alg->algt.alg.skcipher.encrypt = skcipher_encrypt;
 		t_alg->algt.alg.skcipher.decrypt = skcipher_decrypt;
+		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
+		    DESC_TYPE(t_alg->algt.desc_hdr_template) !=
+		    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {
+			devm_kfree(dev, t_alg);
+			return ERR_PTR(-ENOTSUPP);
+		}
 		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.aead.base;
-- 
2.27.0




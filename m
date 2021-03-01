Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F683289DB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbhCASGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239222AbhCAR7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:59:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0BE6534D;
        Mon,  1 Mar 2021 17:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620688;
        bh=PvLN8e7YTc6QoTIypQ2jxEJGTywRO8jPrjHFFs2U9zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYDGOEFhSL6OToQ09rZBVC4e1bCgsqLKub4FlWqoz6Bgwm3o8XklT3ETCwsV7hbZg
         5MlmycgfyPXmwvqr9wbV2uoPuqrcU95m24Y1esnVCiGuNjPN48bPXybqDx3QOH/vDb
         SyeKRXoZbD1PeibzXRQl7LXOLmKDHAQJCIL0hYTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 244/775] crypto: talitos - Fix ctr(aes) on SEC1
Date:   Mon,  1 Mar 2021 17:06:52 +0100
Message-Id: <20210301161213.685759809@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index b656983c1ef4e..25c9f825b8b54 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2765,6 +2765,22 @@ static struct talitos_alg_template driver_algs[] = {
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
@@ -3182,6 +3198,12 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F10423F998
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHHXgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgHHXgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2754F206D8;
        Sat,  8 Aug 2020 23:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929776;
        bh=D/f7KeSvbnpfeuO5AHy05pktd39Vhn5bLwVvks2iLkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZkma3nj6Qj4gESbZp0bc0DmthshN/Sl/UlQt0+yhAShQw+XONLM6axOPjQRLwUz/
         Hhg7FJlJF5CIKzCyivCM2wXYrsnQApQOB4d0Q5tH1XR74AtR7Drg3+ERQpfp7iflfH
         0OnJ5EHlKDspqzcLelsahaFlt/WekqdYr7Re/+6k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 26/72] crypto: qat - allow xts requests not multiple of block
Date:   Sat,  8 Aug 2020 19:34:55 -0400
Message-Id: <20200808233542.3617339-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 528f776df67c440361b2847b4da400d8754bf030 ]

Allow AES-XTS requests that are not multiple of the block size.
If a request is smaller than the block size, return -EINVAL.

This fixes the following issue reported by the crypto testmgr self-test:

  alg: skcipher: qat_aes_xts encryption failed on test vector "random: len=116 klen=64"; expected_error=0, actual_error=-22, cfg="random: inplace may_sleep use_finup src_divs=[<reimport>45.85%@+4077, <flush>54.15%@alignmask+18]"

Fixes: 96ee111a659e ("crypto: qat - return error for block...")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index e14d3dd291f09..1b050391c0c90 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -55,6 +55,7 @@
 #include <crypto/hmac.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
+#include <crypto/xts.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -1102,6 +1103,14 @@ static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
 	return qat_alg_skcipher_encrypt(req);
 }
 
+static int qat_alg_skcipher_xts_encrypt(struct skcipher_request *req)
+{
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
+	return qat_alg_skcipher_encrypt(req);
+}
+
 static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
@@ -1161,6 +1170,15 @@ static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
 
 	return qat_alg_skcipher_decrypt(req);
 }
+
+static int qat_alg_skcipher_xts_decrypt(struct skcipher_request *req)
+{
+	if (req->cryptlen < XTS_BLOCK_SIZE)
+		return -EINVAL;
+
+	return qat_alg_skcipher_decrypt(req);
+}
+
 static int qat_alg_aead_init(struct crypto_aead *tfm,
 			     enum icp_qat_hw_auth_algo hash,
 			     const char *hash_name)
@@ -1354,8 +1372,8 @@ static struct skcipher_alg qat_skciphers[] = { {
 	.init = qat_alg_skcipher_init_tfm,
 	.exit = qat_alg_skcipher_exit_tfm,
 	.setkey = qat_alg_skcipher_xts_setkey,
-	.decrypt = qat_alg_skcipher_blk_decrypt,
-	.encrypt = qat_alg_skcipher_blk_encrypt,
+	.decrypt = qat_alg_skcipher_xts_decrypt,
+	.encrypt = qat_alg_skcipher_xts_encrypt,
 	.min_keysize = 2 * AES_MIN_KEY_SIZE,
 	.max_keysize = 2 * AES_MAX_KEY_SIZE,
 	.ivsize = AES_BLOCK_SIZE,
-- 
2.25.1


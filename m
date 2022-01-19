Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D364931B0
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346916AbiASAPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:15:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47630 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347584AbiASAO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:14:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DC76B81835;
        Wed, 19 Jan 2022 00:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02791C340E8;
        Wed, 19 Jan 2022 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642551296;
        bh=+cyvg79Yoc1+H+2u1HYQD/NiYmUvcj5Tf7vTlBCGeck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghM5M8Icx8UJsYh+afyAa1Wq0/G53gIa4CSA5ulAf7X45HJPLRUnEkxq0MvdD2f8/
         3sTvGaauD5/6IowA1USStvJ3CujJ/Hvvf5MiKjYeQjsmw/ifitgEGDx+VImJUeSkWe
         UwYg6Hj4KA61rH8Y1JTXTB8soRDxasihI4hratpnfaiQ+ZIa+NaPNx5+4/pl34iq75
         3Ibvlt2Zm5UAYB99AOI5+XdPtEMIcx8SM9jH6qXiFjUycZ5pU6adHrghgoHCOy+bgn
         ENYOUqDBCGdUcCKa40UqvEbbo8T2mIGiAM/j9pzkKRw4KNEuTZD5HJQVbyP66tiCxx
         Wf+wdxKVa4RGg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH v2 3/5] crypto: rsa-pkcs1pad - restore signature length check
Date:   Tue, 18 Jan 2022 16:13:04 -0800
Message-Id: <20220119001306.85355-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119001306.85355-1-ebiggers@kernel.org>
References: <20220119001306.85355-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

RSA PKCS#1 v1.5 signatures are required to be the same length as the RSA
key size.  RFC8017 specifically requires the verifier to check this
(https://datatracker.ietf.org/doc/html/rfc8017#section-8.2.2).

Commit a49de377e051 ("crypto: Add hash param to pkcs1pad") changed the
kernel to allow longer signatures, but didn't explain this part of the
change; it seems to be unrelated to the rest of the commit.

Revert this change, since it doesn't appear to be correct.

We can be pretty sure that no one is relying on overly-long signatures
(which would have to be front-padded with zeroes) being supported, given
that they would have been broken since commit c7381b012872
("crypto: akcipher - new verify API for public key algorithms").

Fixes: a49de377e051 ("crypto: Add hash param to pkcs1pad")
Cc: <stable@vger.kernel.org> # v4.6+
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Suggested-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 7b223adebabf6..6b556ddeb3a00 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -538,7 +538,7 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 
 	if (WARN_ON(req->dst) ||
 	    WARN_ON(!req->dst_len) ||
-	    !ctx->key_size || req->src_len < ctx->key_size)
+	    !ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
 	req_ctx->out_buf = kmalloc(ctx->key_size + req->dst_len, GFP_KERNEL);
-- 
2.34.1


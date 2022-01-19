Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69184931A9
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbiASAO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:14:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiASAO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:14:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C7526149D;
        Wed, 19 Jan 2022 00:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E7FC340E7;
        Wed, 19 Jan 2022 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642551295;
        bh=rwNbvR7l9A7jq9pAfFXzkkqQCCLy8eTD4trOlDfx0jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUunRrWZN0qs8Uf9q8HwckNLbsdI17a64TPYIpreYnCvHvOMwegUw1KIwGBo5fHKL
         wbt7qjo5bjetg5rz7w4MsYMJsuzgSYaDskBrqP6k/amjz4nNQTRLxJwi/usJQnFbJt
         HwOfIe99eDZfnpFsYsWMM50YmUasrlzQ6mCpHGHm/RQJN2Cby1EDW7kdbpLCAMV1Pj
         AK2+h5BNzyeDx+fsa9jStTFSH7yKs9C6wZT0g9PzoaL/sh+E3R/GjEW4/R+EnXAxSi
         E34+UmjT2JwoJt+Bkywo+UMO2Mhxbu3sdCAQIeJVfLUjRQY2msYDDghk9sNyo5F7Pw
         4XfzeX83U7+BQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/5] crypto: rsa-pkcs1pad - correctly get hash from source scatterlist
Date:   Tue, 18 Jan 2022 16:13:03 -0800
Message-Id: <20220119001306.85355-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119001306.85355-1-ebiggers@kernel.org>
References: <20220119001306.85355-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit c7381b012872 ("crypto: akcipher - new verify API for public key
algorithms") changed akcipher_alg::verify to take in both the signature
and the actual hash and do the signature verification, rather than just
return the hash expected by the signature as was the case before.  To do
this, it implemented a hack where the signature and hash are
concatenated with each other in one scatterlist.

Obviously, for this to work correctly, akcipher_alg::verify needs to
correctly extract the two items from the scatterlist it is given.
Unfortunately, it doesn't correctly extract the hash in the case where
the signature is longer than the RSA key size, as it assumes that the
signature's length is equal to the RSA key size.  This causes a prefix
of the hash, or even the entire hash, to be taken from the *signature*.

(Note, the case of a signature longer than the RSA key size should not
be allowed in the first place; a separate patch will fix that.)

It is unclear whether the resulting scheme has any useful security
properties.

Fix this by correctly extracting the hash from the scatterlist.

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 1b35457814258..7b223adebabf6 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -495,7 +495,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 			   sg_nents_for_len(req->src,
 					    req->src_len + req->dst_len),
 			   req_ctx->out_buf + ctx->key_size,
-			   req->dst_len, ctx->key_size);
+			   req->dst_len, req->src_len);
 	/* Do the actual verification step. */
 	if (memcmp(req_ctx->out_buf + ctx->key_size, out_buf + pos,
 		   req->dst_len) != 0)
-- 
2.34.1


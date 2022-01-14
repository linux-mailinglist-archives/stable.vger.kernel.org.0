Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066C48E5F5
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiANIWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60024 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbiANIVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CC0D61E34;
        Fri, 14 Jan 2022 08:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E28C36AED;
        Fri, 14 Jan 2022 08:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642148471;
        bh=Y8I8G02qtt+1LJcVr6kJCIIHChwaLeQ0Deg0+o4Caa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZ4JjzxTCh0Vi1sV81c40V13i0OhsdxV4lUsjAoo4dzwr+ZZA7AtFa/LjnOanKa0U
         6Aw0v21mbmsg83jWnPNsntNj82bzqVDW2Nu7oKFUxfXi+iCBj7UpGyptUpkOIoQq7e
         ZE3c49Gxn4G2mRak6E9pB3jC0FcWkM95wHw+BqJfsSLBRqpkdDY+wQLtV11i0hIoxZ
         aGfFYAzD8sgaSOsAc5OhpPOA9/2tYRATEJf8l5IhWRykOr/w0oTL2Yn5FNuaEZnSMG
         lWg+9nSn5tV5h4qGu4rwUwKSI2lq2oEKc2CzzFRl7C9jiKyasH6a8i6fgwVm+J0ro5
         tha7V8d1vmSiw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     keyrings@vger.kernel.org, Vitaly Chikunov <vt@altlinux.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] crypto: rsa-pkcs1pad - correctly get hash from source scatterlist
Date:   Fri, 14 Jan 2022 00:19:37 -0800
Message-Id: <20220114081939.218416-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081939.218416-1-ebiggers@kernel.org>
References: <20220114081939.218416-1-ebiggers@kernel.org>
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

It is unclear whether the resulting scheme has any useful security
properties.

Fix this by correctly extracting the hash from the scatterlist.

Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/rsa-pkcs1pad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 1b3545781425..7b223adebabf 100644
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


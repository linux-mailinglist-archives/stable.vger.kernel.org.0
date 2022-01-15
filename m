Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8506C48F4E2
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 06:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiAOFIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 00:08:15 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:55614 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiAOFIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 00:08:15 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 54FC072C8DC;
        Sat, 15 Jan 2022 08:08:13 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 363CD4A46FE;
        Sat, 15 Jan 2022 08:08:13 +0300 (MSK)
Date:   Sat, 15 Jan 2022 08:08:12 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: rsa-pkcs1pad - correctly get hash from
 source scatterlist
Message-ID: <20220115050812.q7o5ij7c3jhloru7@altlinux.org>
References: <20220114081939.218416-1-ebiggers@kernel.org>
 <20220114081939.218416-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220114081939.218416-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric,

On Fri, Jan 14, 2022 at 12:19:37AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Commit c7381b012872 ("crypto: akcipher - new verify API for public key
> algorithms") changed akcipher_alg::verify to take in both the signature
> and the actual hash and do the signature verification, rather than just
> return the hash expected by the signature as was the case before.  To do
> this, it implemented a hack where the signature and hash are
> concatenated with each other in one scatterlist.
> 
> Obviously, for this to work correctly, akcipher_alg::verify needs to
> correctly extract the two items from the scatterlist it is given.
> Unfortunately, it doesn't correctly extract the hash in the case where
> the signature is longer than the RSA key size, as it assumes that the
> signature's length is equal to the RSA key size.  This causes a prefix
> of the hash, or even the entire hash, to be taken from the *signature*.
> 
> It is unclear whether the resulting scheme has any useful security
> properties.
> 
> Fix this by correctly extracting the hash from the scatterlist.
> 
> Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
> Cc: <stable@vger.kernel.org> # v5.2+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/rsa-pkcs1pad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
> index 1b3545781425..7b223adebabf 100644
> --- a/crypto/rsa-pkcs1pad.c
> +++ b/crypto/rsa-pkcs1pad.c
> @@ -495,7 +495,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
>  			   sg_nents_for_len(req->src,
>  					    req->src_len + req->dst_len),
>  			   req_ctx->out_buf + ctx->key_size,
> -			   req->dst_len, ctx->key_size);
> +			   req->dst_len, req->src_len);

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Reviewing this I noticed that while req->src_len is checked in
pkcs1pad_verify() to be not shorter than ctx->key_size it's never
checked to be not longer. Signatures longer than RSA modulus N (which is
ctx->key_size) are still invalid (RFC8017 8.2.2). (So, assumption they
are equal was in accord with the standard, but not with the current
codebase.)

I suggest to add this check too while we at it.

There was such check before, but it was removed in a49de377e051 ("crypto:
Add hash param to pkcs1pad") for an unknown reason:

  -    if (!ctx->key_size || req->src_len != ctx->key_size)
  +    if (!ctx->key_size || req->src_len < ctx->key_size)
           return -EINVAL;

Thanks,

>  	/* Do the actual verification step. */
>  	if (memcmp(req_ctx->out_buf + ctx->key_size, out_buf + pos,
>  		   req->dst_len) != 0)
> -- 
> 2.34.1

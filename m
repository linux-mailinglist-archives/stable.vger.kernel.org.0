Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA3B48F542
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 06:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiAOFsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 00:48:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35828 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiAOFsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 00:48:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D168B82668;
        Sat, 15 Jan 2022 05:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8AAC36AE3;
        Sat, 15 Jan 2022 05:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642225681;
        bh=s6YoHefLtqCOhAQXJ3KUCdfGdNsilqm6jK16QH0hGEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m9e55GKvgj1lE0KXjFK1lOAzEbpnb9zLwboWDq5BgjJr1xW+qy6iefLBwS6T6g/8E
         KU8xnQouSqIB2PRAjVB6lf7AMm7qz4k0oYoTztNRB922VcKlrzy26C3KgRw9yW8cMe
         uhzFQ64Fav6JfjZ9Jeqtq4nCRXgv47cW3g1wtFQnB1Zq8OjMR0GjA8XimALaKI18wM
         ubwkvahXdfuO3rX927kXtpYEYx87F0OZJDB08RoX2djAXzoal2Ew8bsKs4cdUv7NYY
         zp2cHh8e8vnfywabrq1DzaZK/dkQPunVihR/XyUTg2KkXlr+F4YgAyq0Dp6kWkTL6Z
         uNgKV6iAYX+gg==
Date:   Fri, 14 Jan 2022 21:47:59 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] crypto: rsa-pkcs1pad - correctly get hash from
 source scatterlist
Message-ID: <YeJgDzSsSepEio6P@sol.localdomain>
References: <20220114081939.218416-1-ebiggers@kernel.org>
 <20220114081939.218416-2-ebiggers@kernel.org>
 <20220115050812.q7o5ij7c3jhloru7@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220115050812.q7o5ij7c3jhloru7@altlinux.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 08:08:12AM +0300, Vitaly Chikunov wrote:
> Eric,
> 
> On Fri, Jan 14, 2022 at 12:19:37AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Commit c7381b012872 ("crypto: akcipher - new verify API for public key
> > algorithms") changed akcipher_alg::verify to take in both the signature
> > and the actual hash and do the signature verification, rather than just
> > return the hash expected by the signature as was the case before.  To do
> > this, it implemented a hack where the signature and hash are
> > concatenated with each other in one scatterlist.
> > 
> > Obviously, for this to work correctly, akcipher_alg::verify needs to
> > correctly extract the two items from the scatterlist it is given.
> > Unfortunately, it doesn't correctly extract the hash in the case where
> > the signature is longer than the RSA key size, as it assumes that the
> > signature's length is equal to the RSA key size.  This causes a prefix
> > of the hash, or even the entire hash, to be taken from the *signature*.
> > 
> > It is unclear whether the resulting scheme has any useful security
> > properties.
> > 
> > Fix this by correctly extracting the hash from the scatterlist.
> > 
> > Fixes: c7381b012872 ("crypto: akcipher - new verify API for public key algorithms")
> > Cc: <stable@vger.kernel.org> # v5.2+
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  crypto/rsa-pkcs1pad.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
> > index 1b3545781425..7b223adebabf 100644
> > --- a/crypto/rsa-pkcs1pad.c
> > +++ b/crypto/rsa-pkcs1pad.c
> > @@ -495,7 +495,7 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
> >  			   sg_nents_for_len(req->src,
> >  					    req->src_len + req->dst_len),
> >  			   req_ctx->out_buf + ctx->key_size,
> > -			   req->dst_len, ctx->key_size);
> > +			   req->dst_len, req->src_len);
> 
> Reviewed-by: Vitaly Chikunov <vt@altlinux.org>
> 
> Reviewing this I noticed that while req->src_len is checked in
> pkcs1pad_verify() to be not shorter than ctx->key_size it's never
> checked to be not longer. Signatures longer than RSA modulus N (which is
> ctx->key_size) are still invalid (RFC8017 8.2.2). (So, assumption they
> are equal was in accord with the standard, but not with the current
> codebase.)
> 
> I suggest to add this check too while we at it.
> 
> There was such check before, but it was removed in a49de377e051 ("crypto:
> Add hash param to pkcs1pad") for an unknown reason:
> 
>   -    if (!ctx->key_size || req->src_len != ctx->key_size)
>   +    if (!ctx->key_size || req->src_len < ctx->key_size)
>            return -EINVAL;
> 
> Thanks,
> 

Yes, after sending this out I was looking at the PKCS#1 v1.5 encoding
specification, and I had noticed that too:

     "1.  Length checking: If the length of the signature S is not k
          octets, output 'invalid signature' and stop."

I agree that we should enforce that too, although it's curious that commit
a49de377e051 removed that check.  Hopefully that was just a mistake and not
something that someone was actually relying on.  I'll send a separate patch for
that; I think it should be separate from this patch.

- Eric

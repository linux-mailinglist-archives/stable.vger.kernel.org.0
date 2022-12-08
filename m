Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101A06479AD
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 00:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLHXSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 18:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLHXSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 18:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D6579C93;
        Thu,  8 Dec 2022 15:18:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD65620B3;
        Thu,  8 Dec 2022 23:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875B3C433EF;
        Thu,  8 Dec 2022 23:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670541480;
        bh=rd79PBsqcgAsOpiLcHMxEP/sk2UK4Dh/a8VVAA6SQ/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vp1HXQUb5QfqqnrUWIs78XUnzr8cBvRwQ5ycZ50tmQqCKltrtum4u7Oqrc6zGSbYq
         SPD4//EXmEFrt0mEuLUNh4mjFoEiSnuqReSIfjUsJ0u5h0nQi2L9/yohC2SCcHN2zF
         D9gP16Km5VXBDyI8NnNlzFIqWxRvvQPJlO0+Z6xgyt/aPZeC6Xw3Kmq1xHe1lomjn8
         mTdx5szDs2CccXckuLKnsbO1Mj6RJo7xvAi3Qx92Kb1LCUqGmCkEwyGorBGQstq0Xo
         qegdmvVWVEfMFpbkeDPco4FZph5m2hahdb69Cbpy5vAzpvfnFoVGfTjitjOjGFu9jd
         lW/Ltxb8gp0fA==
Date:   Thu, 8 Dec 2022 15:17:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: Make a copy of sig and digest in
 vmalloced stack
Message-ID: <Y5JwpdGF50oFKw0z@sol.localdomain>
References: <20221208164610.867747-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208164610.867747-1-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 05:46:10PM +0100, Roberto Sassu wrote:
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 2f8352e88860..307799ffbc3e 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -363,7 +363,8 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	struct scatterlist src_sg[2];
>  	char alg_name[CRYPTO_MAX_ALG_NAME];
>  	char *key, *ptr;
> -	int ret;
> +	char *sig_s, *digest;
> +	int ret, verif_bundle_len;
>  
>  	pr_devel("==>%s()\n", __func__);
>  
> @@ -400,8 +401,21 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	if (!req)
>  		goto error_free_tfm;
>  
> -	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
> -		      GFP_KERNEL);
> +	verif_bundle_len = pkey->keylen + sizeof(u32) * 2 + pkey->paramlen;
> +
> +	sig_s = sig->s;
> +	digest = sig->digest;
> +
> +	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> +		if (!virt_addr_valid(sig_s))
> +			verif_bundle_len += sig->s_size;
> +
> +		if (!virt_addr_valid(digest))
> +			verif_bundle_len += sig->digest_size;
> +	}
> +
> +	/* key points to a buffer which could contain the sig and digest too. */
> +	key = kmalloc(verif_bundle_len, GFP_KERNEL);
>  	if (!key)
>  		goto error_free_req;
>  
> @@ -424,9 +438,24 @@ int public_key_verify_signature(const struct public_key *pkey,
>  			goto error_free_key;
>  	}
>  
> +	if (IS_ENABLED(CONFIG_VMAP_STACK)) {
> +		ptr += pkey->paramlen;
> +
> +		if (!virt_addr_valid(sig_s)) {
> +			sig_s = ptr;
> +			memcpy(sig_s, sig->s, sig->s_size);
> +			ptr += sig->s_size;
> +		}
> +
> +		if (!virt_addr_valid(digest)) {
> +			digest = ptr;
> +			memcpy(digest, sig->digest, sig->digest_size);
> +		}
> +	}
> +
>  	sg_init_table(src_sg, 2);
> -	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> -	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
> +	sg_set_buf(&src_sg[0], sig_s, sig->s_size);
> +	sg_set_buf(&src_sg[1], digest, sig->digest_size);
>  	akcipher_request_set_crypt(req, src_sg, NULL, sig->s_size,
>  				   sig->digest_size);
>  	crypto_init_wait(&cwait);

We should try to avoid adding error-prone special cases.  How about just doing
the copy of the signature and digest unconditionally?  That would be much
simpler.  It would even mean that the scatterlist would only need one element.

Also, the size of buffer needed is only

	max(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
	    sig->s_size + sig->digest_size)

... since the signature and digest aren't needed until the key was already used.

- Eric

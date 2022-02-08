Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EC94AD4D5
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352166AbiBHJ0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 04:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiBHJ0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 04:26:30 -0500
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D438CC03FEC3;
        Tue,  8 Feb 2022 01:26:28 -0800 (PST)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 13F6F72C905;
        Tue,  8 Feb 2022 12:26:28 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id E61EB4A46EA;
        Tue,  8 Feb 2022 12:26:27 +0300 (MSK)
Date:   Tue, 8 Feb 2022 12:26:27 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KEYS: asymmetric: properly validate hash_algo and
 encoding
Message-ID: <20220208092627.7id2k7vze5sh6zdk@altlinux.org>
References: <20220208052448.409152-1-ebiggers@kernel.org>
 <20220208052448.409152-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220208052448.409152-3-ebiggers@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 09:24:48PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> It is insecure to allow arbitrary hash algorithms and signature
> encodings to be used with arbitrary signature algorithms.  Notably,
> ECDSA, ECRDSA, and SM2 all sign/verify raw hash values and don't
> disambiguate between different hash algorithms like RSA PKCS#1 v1.5
> padding does.  Therefore, they need to be restricted to certain sets of
> hash algorithms (ideally just one, but in practice small sets are used).
> Additionally, the encoding is an integral part of modern signature
> algorithms, and is not supposed to vary.
> 
> Therefore, tighten the checks of hash_algo and encoding done by
> software_key_determine_akcipher().
> 
> Also rearrange the parameters to software_key_determine_akcipher() to
> put the public_key first, as this is the most important parameter and it
> often determines everything else.
> 
> Fixes: 299f561a6693 ("x509: Add support for parsing x509 certs with ECDSA keys")
> Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> Cc: stable@vger.kernel.org
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> Tested-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Small question below.

> ---
>  crypto/asymmetric_keys/public_key.c | 111 +++++++++++++++++++---------
>  1 file changed, 76 insertions(+), 35 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index e36213945686..7c9e6be35c30 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -60,39 +60,83 @@ static void public_key_destroy(void *payload0, void *payload3)
>  }
>  
>  /*
> - * Determine the crypto algorithm name.
> + * Given a public_key, and an encoding and hash_algo to be used for signing
> + * and/or verification with that key, determine the name of the corresponding
> + * akcipher algorithm.  Also check that encoding and hash_algo are allowed.
>   */
> -static
> -int software_key_determine_akcipher(const char *encoding,
> -				    const char *hash_algo,
> -				    const struct public_key *pkey,
> -				    char alg_name[CRYPTO_MAX_ALG_NAME])
> +static int
> +software_key_determine_akcipher(const struct public_key *pkey,
> +				const char *encoding, const char *hash_algo,
> +				char alg_name[CRYPTO_MAX_ALG_NAME])
>  {
>  	int n;
>  
> -	if (strcmp(encoding, "pkcs1") == 0) {
> -		/* The data wangled by the RSA algorithm is typically padded
> -		 * and encoded in some manner, such as EMSA-PKCS1-1_5 [RFC3447
> -		 * sec 8.2].
> +	if (!encoding)
> +		return -EINVAL;
> +
> +	if (strcmp(pkey->pkey_algo, "rsa") == 0) {
> +		/*
> +		 * RSA signatures usually use EMSA-PKCS1-1_5 [RFC3447 sec 8.2].
> +		 */
> +		if (strcmp(encoding, "pkcs1") == 0) {
> +			if (!hash_algo)
> +				n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
> +					     "pkcs1pad(%s)",
> +					     pkey->pkey_algo);
> +			else
> +				n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
> +					     "pkcs1pad(%s,%s)",
> +					     pkey->pkey_algo, hash_algo);
> +			return n >= CRYPTO_MAX_ALG_NAME ? -EINVAL : 0;
> +		}
> +		if (strcmp(encoding, "raw") != 0)
> +			return -EINVAL;

Should raw RSA be allowed at all? I understand it was there before, but
I wonder what is the use case.

Thanks,

> +		/*
> +		 * Raw RSA cannot differentiate between different hash
> +		 * algorithms.
> +		 */
> +		if (hash_algo)
> +			return -EINVAL;
> +	} else if (strncmp(pkey->pkey_algo, "ecdsa", 5) == 0) {
> +		if (strcmp(encoding, "x962") != 0)
> +			return -EINVAL;
> +		/*
> +		 * ECDSA signatures are taken over a raw hash, so they don't
> +		 * differentiate between different hash algorithms.  That means
> +		 * that the verifier should hard-code a specific hash algorithm.
> +		 * Unfortunately, in practice ECDSA is used with multiple SHAs,
> +		 * so we have to allow all of them and not just one.
>  		 */
>  		if (!hash_algo)
> -			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
> -				     "pkcs1pad(%s)",
> -				     pkey->pkey_algo);
> -		else
> -			n = snprintf(alg_name, CRYPTO_MAX_ALG_NAME,
> -				     "pkcs1pad(%s,%s)",
> -				     pkey->pkey_algo, hash_algo);
> -		return n >= CRYPTO_MAX_ALG_NAME ? -EINVAL : 0;
> -	}
> -
> -	if (strcmp(encoding, "raw") == 0 ||
> -	    strcmp(encoding, "x962") == 0) {
> -		strcpy(alg_name, pkey->pkey_algo);
> -		return 0;
> +			return -EINVAL;
> +		if (strcmp(hash_algo, "sha1") != 0 &&
> +		    strcmp(hash_algo, "sha224") != 0 &&
> +		    strcmp(hash_algo, "sha256") != 0 &&
> +		    strcmp(hash_algo, "sha384") != 0 &&
> +		    strcmp(hash_algo, "sha512") != 0)
> +			return -EINVAL;
> +	} else if (strcmp(pkey->pkey_algo, "sm2") == 0) {
> +		if (strcmp(encoding, "raw") != 0)
> +			return -EINVAL;
> +		if (!hash_algo)
> +			return -EINVAL;
> +		if (strcmp(hash_algo, "sm3") != 0)
> +			return -EINVAL;
> +	} else if (strcmp(pkey->pkey_algo, "ecrdsa") == 0) {
> +		if (strcmp(encoding, "raw") != 0)
> +			return -EINVAL;
> +		if (!hash_algo)
> +			return -EINVAL;
> +		if (strcmp(hash_algo, "streebog256") != 0 &&
> +		    strcmp(hash_algo, "streebog512") != 0)
> +			return -EINVAL;
> +	} else {
> +		/* Unknown public key algorithm */
> +		return -ENOPKG;
>  	}
> -
> -	return -ENOPKG;
> +	if (strscpy(alg_name, pkey->pkey_algo, CRYPTO_MAX_ALG_NAME) < 0)
> +		return -EINVAL;
> +	return 0;
>  }
>  
>  static u8 *pkey_pack_u32(u8 *dst, u32 val)
> @@ -113,9 +157,8 @@ static int software_key_query(const struct kernel_pkey_params *params,
>  	u8 *key, *ptr;
>  	int ret, len;
>  
> -	ret = software_key_determine_akcipher(params->encoding,
> -					      params->hash_algo,
> -					      pkey, alg_name);
> +	ret = software_key_determine_akcipher(pkey, params->encoding,
> +					      params->hash_algo, alg_name);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -179,9 +222,8 @@ static int software_key_eds_op(struct kernel_pkey_params *params,
>  
>  	pr_devel("==>%s()\n", __func__);
>  
> -	ret = software_key_determine_akcipher(params->encoding,
> -					      params->hash_algo,
> -					      pkey, alg_name);
> +	ret = software_key_determine_akcipher(pkey, params->encoding,
> +					      params->hash_algo, alg_name);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -340,9 +382,8 @@ int public_key_verify_signature(const struct public_key *pkey,
>  			return -EKEYREJECTED;
>  	}
>  
> -	ret = software_key_determine_akcipher(sig->encoding,
> -					      sig->hash_algo,
> -					      pkey, alg_name);
> +	ret = software_key_determine_akcipher(pkey, sig->encoding,
> +					      sig->hash_algo, alg_name);
>  	if (ret < 0)
>  		return ret;
>  
> -- 
> 2.35.1

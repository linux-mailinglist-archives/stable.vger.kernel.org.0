Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD94BD334
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 02:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245461AbiBUBnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 20:43:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244863AbiBUBnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 20:43:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070422D1DD;
        Sun, 20 Feb 2022 17:42:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C47B80E3A;
        Mon, 21 Feb 2022 01:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6BEC340E8;
        Mon, 21 Feb 2022 01:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645407763;
        bh=pGNV0WNLasdpFDi9voZnTNRkhKAaDu5d3GJSFurCXEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p2FClMjPKzn4ne0a/lru2ZZR0iqz+93V/XN0PvHWd8IFw8H3qgsKBfxwdDaJsBzyI
         yMK6drAQ6K2+FLpRx+8gpxkc/A3KM/TAiEegm8SGVYb0jb8atAtd12YLkOGA0X5aFt
         goda749DpAwVrleA3cKWTGNBJrecFRTaBEvjs0ZXTzU8c4wm6EeGs6ou/mOM0v2Ihv
         /jenNeRSzGsGgqOQ0IxxIM5k1gBCNSpTfEs5dO/94PETKfC/t38KZhHAmjJO2MpDiS
         cozCk6cxFPuYC9AUwyq4ah06SpZxbCPm1ZnRCmMwvkGp5rPo7yE95fiijCbAZb8m+w
         T8i6aFu+mWJRA==
Date:   Mon, 21 Feb 2022 02:43:21 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: asymmetric: enforce that sig algo matches key
 algo
Message-ID: <YhLuOeIKLwlucpKv@kernel.org>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201003414.55380-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 04:34:13PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Most callers of public_key_verify_signature(), including most indirect
> callers via verify_signature() as well as pkcs7_verify_sig_chain(),
> don't check that public_key_signature::pkey_algo matches
> public_key::pkey_algo.  These should always match.  However, a malicious
> signature could intentionally declare an unintended algorithm.  It is
> essential that such signatures be rejected outright, or that the
> algorithm of the *key* be used -- not the algorithm of the signature as
> that would allow attackers to choose the algorithm used.
> 
> Currently, public_key_verify_signature() correctly uses the key's
> algorithm when deciding which akcipher to allocate.  That's good.
> However, it uses the signature's algorithm when deciding whether to do
> the first step of SM2, which is incorrect.  Also, v4.19 and older
> kernels used the signature's algorithm for the entire process.
> 
> Prevent such errors by making public_key_verify_signature() enforce that
> the signature's algorithm matches the key's algorithm.
> 
> Also remove two checks of this done by callers, which are now redundant.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/asymmetric_keys/pkcs7_verify.c    |  6 ------
>  crypto/asymmetric_keys/public_key.c      | 15 +++++++++++++++
>  crypto/asymmetric_keys/x509_public_key.c |  6 ------
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
> index 0b4d07aa88111..f94a1d1ad3a6c 100644
> --- a/crypto/asymmetric_keys/pkcs7_verify.c
> +++ b/crypto/asymmetric_keys/pkcs7_verify.c
> @@ -174,12 +174,6 @@ static int pkcs7_find_key(struct pkcs7_message *pkcs7,
>  		pr_devel("Sig %u: Found cert serial match X.509[%u]\n",
>  			 sinfo->index, certix);
>  
> -		if (strcmp(x509->pub->pkey_algo, sinfo->sig->pkey_algo) != 0) {
> -			pr_warn("Sig %u: X.509 algo and PKCS#7 sig algo don't match\n",
> -				sinfo->index);
> -			continue;
> -		}
> -
>  		sinfo->signer = x509;
>  		return 0;
>  	}
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 4fefb219bfdc8..aba7113d86c76 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -325,6 +325,21 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	BUG_ON(!sig);
>  	BUG_ON(!sig->s);
>  
> +	/*
> +	 * The signature's claimed public key algorithm *must* match the key's
> +	 * actual public key algorithm.
> +	 *
> +	 * Small exception: ECDSA signatures don't specify the curve, but ECDSA
> +	 * keys do.  So the strings can mismatch slightly in that case:
> +	 * "ecdsa-nist-*" for the key, but "ecdsa" for the signature.
> +	 */
> +	if (!sig->pkey_algo)
> +		return -EINVAL;
> +	if (strcmp(pkey->pkey_algo, sig->pkey_algo) != 0 &&
> +	    (strncmp(pkey->pkey_algo, "ecdsa-", 6) != 0 ||
> +	     strcmp(sig->pkey_algo, "ecdsa") != 0))
> +		return -EKEYREJECTED;
> +
>  	ret = software_key_determine_akcipher(sig->encoding,
>  					      sig->hash_algo,
>  					      pkey, alg_name);
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index fe14cae115b51..71cc1738fbfd2 100644
> --- a/crypto/asymmetric_keys/x509_public_key.c
> +++ b/crypto/asymmetric_keys/x509_public_key.c
> @@ -128,12 +128,6 @@ int x509_check_for_self_signed(struct x509_certificate *cert)
>  			goto out;
>  	}
>  
> -	ret = -EKEYREJECTED;
> -	if (strcmp(cert->pub->pkey_algo, cert->sig->pkey_algo) != 0 &&
> -	    (strncmp(cert->pub->pkey_algo, "ecdsa-", 6) != 0 ||
> -	     strcmp(cert->sig->pkey_algo, "ecdsa") != 0))
> -		goto out;
> -
>  	ret = public_key_verify_signature(cert->pub, cert->sig);
>  	if (ret < 0) {
>  		if (ret == -ENOPKG) {
> -- 
> 2.35.1
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

David, do you want to pick this?

BR, Jarkko

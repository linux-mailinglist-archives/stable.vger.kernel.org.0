Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D484AD42F
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352668AbiBHI6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352625AbiBHI6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:58:32 -0500
X-Greylist: delayed 471 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 00:58:30 PST
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA3B7C03FEC1;
        Tue,  8 Feb 2022 00:58:30 -0800 (PST)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1436A72C905;
        Tue,  8 Feb 2022 11:50:38 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id E823E4A46EA;
        Tue,  8 Feb 2022 11:50:37 +0300 (MSK)
Date:   Tue, 8 Feb 2022 11:50:37 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KEYS: asymmetric: enforce that sig algo matches
 key algo
Message-ID: <20220208085037.lo53hi6ohjusr7pv@altlinux.org>
References: <20220208052448.409152-1-ebiggers@kernel.org>
 <20220208052448.409152-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220208052448.409152-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 09:24:47PM -0800, Eric Biggers wrote:
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
> the signature's algorithm (if given) matches the key's algorithm.
> 
> Also remove two checks of this done by callers, which are now redundant.
> 
> Cc: stable@vger.kernel.org
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> Tested-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,

> ---
>  crypto/asymmetric_keys/pkcs7_verify.c    |  6 ------
>  crypto/asymmetric_keys/public_key.c      | 15 +++++++++++++++
>  crypto/asymmetric_keys/x509_public_key.c |  6 ------
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
> index 0b4d07aa8811..f94a1d1ad3a6 100644
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
> index 4fefb219bfdc..e36213945686 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -325,6 +325,21 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	BUG_ON(!sig);
>  	BUG_ON(!sig->s);
>  
> +	/*
> +	 * If the signature specifies a public key algorithm, it *must* match
> +	 * the key's actual public key algorithm.
> +	 *
> +	 * Small exception: ECDSA signatures don't specify the curve, but ECDSA
> +	 * keys do.  So the strings can mismatch slightly in that case:
> +	 * "ecdsa-nist-*" for the key, but "ecdsa" for the signature.
> +	 */
> +	if (sig->pkey_algo) {
> +		if (strcmp(pkey->pkey_algo, sig->pkey_algo) != 0 &&
> +		    (strncmp(pkey->pkey_algo, "ecdsa-", 6) != 0 ||
> +		     strcmp(sig->pkey_algo, "ecdsa") != 0))
> +			return -EKEYREJECTED;
> +	}
> +
>  	ret = software_key_determine_akcipher(sig->encoding,
>  					      sig->hash_algo,
>  					      pkey, alg_name);
> diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
> index fe14cae115b5..71cc1738fbfd 100644
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

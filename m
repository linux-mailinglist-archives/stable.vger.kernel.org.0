Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2E54A6A57
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 03:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiBBCwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 21:52:33 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:56388 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiBBCwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 21:52:33 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1D6F072C8FA;
        Wed,  2 Feb 2022 05:52:31 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id E361B4A46F0;
        Wed,  2 Feb 2022 05:52:30 +0300 (MSK)
Date:   Wed, 2 Feb 2022 05:52:30 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: asymmetric: enforce that sig algo matches key
 algo
Message-ID: <20220202025230.hrfochvm3uyuh2wm@altlinux.org>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220201003414.55380-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric,

On Mon, Jan 31, 2022 at 04:34:13PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Most callers of public_key_verify_signature(), including most indirect
> callers via verify_signature() as well as pkcs7_verify_sig_chain(),
> don't check that public_key_signature::pkey_algo matches
> public_key::pkey_algo.  These should always match.

Why should they match?

public_key_signature is the data prepared to verify the cert's
signature. The cert's signature algorithm could be different from the
public key algorithm defined in the cert itself. They should match only
for self-signed certs. For example, you should be able to sign RSA
public key with ECDSA signature and vice versa. Or 256-bit EC-RDSA with
512-bit EC-RDSA. This check will prevent this.


> However, a malicious
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

This seem incorrect too, as sig->pkey_algo could be NULL for direct
signature verification calls. For example, for keyctl pkey_verify.

(Side note: keyctl pkey_verify will not work for non-RSA signatures,
though, due to other bug - because signature size is twice key size for
them, but akcipher_alg::max_size cannot distinguish this, and
max_data_size, key_size, and max_sig_size are set from it).

> +	if (strcmp(pkey->pkey_algo, sig->pkey_algo) != 0 &&
> +	    (strncmp(pkey->pkey_algo, "ecdsa-", 6) != 0 ||
> +	     strcmp(sig->pkey_algo, "ecdsa") != 0))

This seems to be taken from x509_check_for_self_signed, that's why this
should not work for non-self-signed certs.

Thanks,

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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CB148F8D5
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 19:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbiAOSpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 13:45:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46046 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiAOSpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 13:45:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8583B60EF4;
        Sat, 15 Jan 2022 18:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640B6C36AE7;
        Sat, 15 Jan 2022 18:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642272316;
        bh=S2o3F8q/v+ENUGMR7l2ss+PwZsM5dCBts1hel2Rnogw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5GrD3/mx6i2Y269G2eXryQNYRkEAfdPzCPtHvswYYbEe7S2dzHbdY/aj7EbJ3mFF
         3qeDVf9rehpzDlCunRe4ouOFijTDT7R2UXkUYk93mFSwLltY4DfsGckq8J+aIembA8
         4u53CCd3ejoKgnPKDw4zz05S1Lo77H0dI+/8A7oy8Tu84sBQCoga3HR49Ha41r5QjI
         RrglfdMC//mqVBZ3AsBd5pEzRwwRVEIlonXm1tNhmeMq7Tj/RWNtMSgrF5Dv9dnNgB
         gBbJL8y233k1HW8SoTpUvYHlr7athvqaIzEhr3f0o6LTL3Dc0wJwvlGNlW6A+XZ1Hx
         muVv+pyGHaiPQ==
Date:   Sat, 15 Jan 2022 20:45:03 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KEYS: fix length validation in keyctl_pkey_params_get_2()
Message-ID: <YeMWLyceg4xcwShF@iki.fi>
References: <20220113200454.72609-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113200454.72609-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 12:04:54PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In many cases, keyctl_pkey_params_get_2() is validating the user buffer
> lengths against the wrong algorithm properties.  Fix it to check against
> the correct properties.
> 
> Probably this wasn't noticed before because for all asymmetric keys of
> the "public_key" subtype, max_data_size == max_sig_size == max_enc_size
> == max_dec_size.  However, this isn't necessarily true for the
> "asym_tpm" subtype (it should be, but it's not strictly validated).  Of
> course, future key types could have different values as well.

With a quick look, asym_tpm is TPM 1.x only, which only has 2048-bit RSA
keys.

> Fixes: 00d60fd3b932 ("KEYS: Provide keyctls to drive the new key type ops for asymmetric keys [ver #2]")
> Cc: <stable@vger.kernel.org> # v4.20+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  security/keys/keyctl_pkey.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/security/keys/keyctl_pkey.c b/security/keys/keyctl_pkey.c
> index 5de0d599a274..97bc27bbf079 100644
> --- a/security/keys/keyctl_pkey.c
> +++ b/security/keys/keyctl_pkey.c
> @@ -135,15 +135,23 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
>  
>  	switch (op) {
>  	case KEYCTL_PKEY_ENCRYPT:
> +		if (uparams.in_len  > info.max_dec_size ||
> +		    uparams.out_len > info.max_enc_size)
> +			return -EINVAL;
> +		break;
>  	case KEYCTL_PKEY_DECRYPT:
>  		if (uparams.in_len  > info.max_enc_size ||
>  		    uparams.out_len > info.max_dec_size)
>  			return -EINVAL;
>  		break;
>  	case KEYCTL_PKEY_SIGN:
> +		if (uparams.in_len  > info.max_data_size ||
> +		    uparams.out_len > info.max_sig_size)
> +			return -EINVAL;
> +		break;
>  	case KEYCTL_PKEY_VERIFY:
> -		if (uparams.in_len  > info.max_sig_size ||
> -		    uparams.out_len > info.max_data_size)
> +		if (uparams.in_len  > info.max_data_size ||
> +		    uparams.in2_len > info.max_sig_size)
>  			return -EINVAL;
>  		break;
>  	default:
> @@ -151,7 +159,7 @@ static int keyctl_pkey_params_get_2(const struct keyctl_pkey_params __user *_par
>  	}
>  
>  	params->in_len  = uparams.in_len;
> -	params->out_len = uparams.out_len;
> +	params->out_len = uparams.out_len; /* Note: same as in2_len */
>  	return 0;
>  }
>  
> 
> base-commit: feb7a43de5ef625ad74097d8fd3481d5dbc06a59
> -- 
> 2.34.1
> 

/Jarkko

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F7F2F58C3
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbhANC4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 21:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbhANC4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 21:56:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FB72235FA;
        Thu, 14 Jan 2021 02:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610592940;
        bh=pHW2B/FjsYZUeZYVTsSMdXSjTFntYNHNKbf3cLsyRII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K2aGv3ZJ7mxc7qcpy7KfhtA+4m/6vmGaaCBtUXxI6su//MvljyyJl8AHka/C+qQTI
         k+QVMikYV6svcGyOnzmVW8iwAmplQLivKfOxtNHHja93ukJY8OBXomwcGjzL45Jvoh
         /Hkf+RDHneTlEdX6rbb3Y8lhUEqr80Lcu/y3A8qgNLnmG1+y35RoLQ2hdGu0jt8xDV
         GgNYucOT9yoUUzz0T7njc1d/75A5hGggP21vyYN6Vrv402KwJtr5obQaF3cTtvjS0C
         HA/XTjz/KNJMVrf+MALnmDrlEj2+dNZsBIo+wkVAgahSsLq4oogyoy3gFAFqOggSJA
         QAxv5cCrS6XFg==
Date:   Thu, 14 Jan 2021 04:55:34 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
Message-ID: <X/+yphcab4AERQJS@kernel.org>
References: <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2648795.1610536273@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 11:11:13AM +0000, David Howells wrote:
> I'm intending to use Tianjia's patch.  Would you like to add a Reviewed-by?
> 
> David

I can give.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> ---
> commit 11078a592e6dcea6b9f30e822d3d30e3defc99ca
> Author: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Date:   Thu Jan 7 17:28:55 2021 +0800
> 
>     X.509: Fix crash caused by NULL pointer
>     
>     On the following call path, `sig->pkey_algo` is not assigned
>     in asymmetric_key_verify_signature(), which causes runtime
>     crash in public_key_verify_signature().
>     
>       keyctl_pkey_verify
>         asymmetric_key_verify_signature
>           verify_signature
>             public_key_verify_signature
>     
>     This patch simply check this situation and fixes the crash
>     caused by NULL pointer.
>     
>     Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
>     Cc: stable@vger.kernel.org # v5.10+
>     Reported-by: Tobias Markus <tobias@markus-regensburg.de>
>     Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>     Signed-off-by: David Howells <dhowells@redhat.com>
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 8892908ad58c..788a4ba1e2e7 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	if (ret)
>  		goto error_free_key;
>  
> -	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
> +	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
> +	    sig->data_size) {
>  		ret = cert_sig_digest_update(sig, tfm);
>  		if (ret)
>  			goto error_free_key;
> 
> 

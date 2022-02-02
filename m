Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1C04A6A74
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 04:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243972AbiBBDKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 22:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiBBDKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 22:10:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF84C061714;
        Tue,  1 Feb 2022 19:10:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCEB616B0;
        Wed,  2 Feb 2022 03:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D3AC340E9;
        Wed,  2 Feb 2022 03:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643771435;
        bh=FQeoLDzMQ4M5j3HDHqVjfWUbB6R2teq76o+xJct+/kM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nIibsmWsvF9Ny+MOzkxuZB95QouQspdG7fy86Kyc+hIpEol/Opbf9kKTOCn9CXDUx
         PoSpPKW75FApaQcY8KrCcDm9Ms9kTS3NEL+e6l0XL90/Kwk3/aeP/f/Qg82eEtU1yE
         bmKrZAa6zt80/Wl1a58OHxY+4NjCxYqwDY7B395h2bECV33OFSzGtvKTHTMLX24Cok
         Injqo7dkFQIidHO0S6drHtnBvmRCqMFOvMvjo+rchqmkz7S5FqCO0Im3yL3naLrL/5
         sGQKJ5koeBtFyBlomer1f6eXRBfTj/OUJ7tApBYeQIdebcO0tkfdS01XysZJfU73la
         dqoF/LYIikWDQ==
Date:   Tue, 1 Feb 2022 19:10:33 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: asymmetric: enforce that sig algo matches key
 algo
Message-ID: <Yfn2KZgjuFRSJzSj@sol.localdomain>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
 <20220202025230.hrfochvm3uyuh2wm@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202025230.hrfochvm3uyuh2wm@altlinux.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 02, 2022 at 05:52:30AM +0300, Vitaly Chikunov wrote:
> Eric,
> 
> On Mon, Jan 31, 2022 at 04:34:13PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Most callers of public_key_verify_signature(), including most indirect
> > callers via verify_signature() as well as pkcs7_verify_sig_chain(),
> > don't check that public_key_signature::pkey_algo matches
> > public_key::pkey_algo.  These should always match.
> 
> Why should they match?

For the reasons I explain in the rest of the commit message.  To summarize: to
have a valid signature verification scheme the algorithm must be fixed by the
key, and not attacker-controlled.

> 
> public_key_signature is the data prepared to verify the cert's
> signature. The cert's signature algorithm could be different from the
> public key algorithm defined in the cert itself. They should match only
> for self-signed certs. For example, you should be able to sign RSA
> public key with ECDSA signature and vice versa. Or 256-bit EC-RDSA with
> 512-bit EC-RDSA. This check will prevent this.

That has nothing to do with this patch, as this patch is only dealing with the
signature.  A cert's public key algorithm can be different, and that is fine.

> > diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> > index 4fefb219bfdc8..aba7113d86c76 100644
> > --- a/crypto/asymmetric_keys/public_key.c
> > +++ b/crypto/asymmetric_keys/public_key.c
> > @@ -325,6 +325,21 @@ int public_key_verify_signature(const struct public_key *pkey,
> >  	BUG_ON(!sig);
> >  	BUG_ON(!sig->s);
> >  
> > +	/*
> > +	 * The signature's claimed public key algorithm *must* match the key's
> > +	 * actual public key algorithm.
> > +	 *
> > +	 * Small exception: ECDSA signatures don't specify the curve, but ECDSA
> > +	 * keys do.  So the strings can mismatch slightly in that case:
> > +	 * "ecdsa-nist-*" for the key, but "ecdsa" for the signature.
> > +	 */
> > +	if (!sig->pkey_algo)
> > +		return -EINVAL;
> 
> This seem incorrect too, as sig->pkey_algo could be NULL for direct
> signature verification calls. For example, for keyctl pkey_verify.

We can make it optional if some callers aren't providing it.  Of course, such
callers wouldn't be able to verify ECDSA signatures.

- Eric

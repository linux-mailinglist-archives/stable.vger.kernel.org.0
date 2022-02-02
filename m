Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325A14A6B4B
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 06:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbiBBFUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 00:20:18 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:49816 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiBBFUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 00:20:17 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id BC8EC72C8FA;
        Wed,  2 Feb 2022 08:20:14 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 862D44A46F0;
        Wed,  2 Feb 2022 08:20:14 +0300 (MSK)
Date:   Wed, 2 Feb 2022 08:20:14 +0300
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
Message-ID: <20220202052014.fflcmgpykwbfzdt4@altlinux.org>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
 <20220202025230.hrfochvm3uyuh2wm@altlinux.org>
 <Yfn2KZgjuFRSJzSj@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Yfn2KZgjuFRSJzSj@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 07:10:33PM -0800, Eric Biggers wrote:
> On Wed, Feb 02, 2022 at 05:52:30AM +0300, Vitaly Chikunov wrote:
> > Eric,
> > 
> > On Mon, Jan 31, 2022 at 04:34:13PM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Most callers of public_key_verify_signature(), including most indirect
> > > callers via verify_signature() as well as pkcs7_verify_sig_chain(),
> > > don't check that public_key_signature::pkey_algo matches
> > > public_key::pkey_algo.  These should always match.
> > 
> > Why should they match?
> 
> For the reasons I explain in the rest of the commit message.  To summarize: to
> have a valid signature verification scheme the algorithm must be fixed by the
> key, and not attacker-controlled.
> 
> > 
> > public_key_signature is the data prepared to verify the cert's
> > signature. The cert's signature algorithm could be different from the
> > public key algorithm defined in the cert itself. They should match only
> > for self-signed certs. For example, you should be able to sign RSA
> > public key with ECDSA signature and vice versa. Or 256-bit EC-RDSA with
> > 512-bit EC-RDSA. This check will prevent this.
> 
> That has nothing to do with this patch, as this patch is only dealing with the
> signature.  A cert's public key algorithm can be different, and that is fine.

You are right and I was mistaken about that (obscured by keyctl
pkey_verify error and self-signed keys verification). Then it's all
good!

I also tested these patches to work well with rsa-ecdsa and ecrdsa
certificates using keyctl restrict_keyring.

Thanks,

> 
> > > diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> > > index 4fefb219bfdc8..aba7113d86c76 100644
> > > --- a/crypto/asymmetric_keys/public_key.c
> > > +++ b/crypto/asymmetric_keys/public_key.c
> > > @@ -325,6 +325,21 @@ int public_key_verify_signature(const struct public_key *pkey,
> > >  	BUG_ON(!sig);
> > >  	BUG_ON(!sig->s);
> > >  
> > > +	/*
> > > +	 * The signature's claimed public key algorithm *must* match the key's
> > > +	 * actual public key algorithm.
> > > +	 *
> > > +	 * Small exception: ECDSA signatures don't specify the curve, but ECDSA
> > > +	 * keys do.  So the strings can mismatch slightly in that case:
> > > +	 * "ecdsa-nist-*" for the key, but "ecdsa" for the signature.
> > > +	 */
> > > +	if (!sig->pkey_algo)
> > > +		return -EINVAL;
> > 
> > This seem incorrect too, as sig->pkey_algo could be NULL for direct
> > signature verification calls. For example, for keyctl pkey_verify.
> 
> We can make it optional if some callers aren't providing it.  Of course, such
> callers wouldn't be able to verify ECDSA signatures.
> 
> - Eric

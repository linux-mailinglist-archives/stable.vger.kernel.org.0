Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F20CD9C4
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 01:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfJFXwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 19:52:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:3412 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfJFXwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 19:52:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Oct 2019 16:52:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="204901648"
Received: from mwebb1-mobl.ger.corp.intel.com (HELO localhost) ([10.251.93.103])
  by orsmga002.jf.intel.com with ESMTP; 06 Oct 2019 16:52:38 -0700
Date:   Mon, 7 Oct 2019 02:52:38 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191006235238.GA16641@linux.intel.com>
References: <1570140491.5046.33.camel@linux.ibm.com>
 <1570147177.10818.11.camel@HansenPartnership.com>
 <20191004182216.GB6945@linux.intel.com>
 <1570213491.3563.27.camel@HansenPartnership.com>
 <20191004183342.y63qdvspojyf3m55@cantor>
 <1570214574.3563.32.camel@HansenPartnership.com>
 <20191004200728.xoj6jlgbhv57gepc@cantor>
 <20191004201134.nuesk6hxtxajnxh2@cantor>
 <1570227068.17537.4.camel@HansenPartnership.com>
 <1570322333.5046.145.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1570322333.5046.145.camel@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 05, 2019 at 08:38:53PM -0400, Mimi Zohar wrote:
> On Fri, 2019-10-04 at 15:11 -0700, James Bottomley wrote:
> 
> > +
> > +/**
> > + * tpm_get_random() - get random bytes influenced by the TPM's RNG
> > + * @chip:	a &struct tpm_chip instance, %NULL for the default chip
> > + * @out:	destination buffer for the random bytes
> > + * @max:	the max number of bytes to write to @out
> > + *
> > + * Uses the TPM as a source of input to the kernel random number
> > + * generator and then takes @max bytes directly from the kernel.  In
> > + * the worst (no other entropy) case, this will return the pure TPM
> > + * random number, but if the kernel RNG has any entropy at all it will
> > + * return a mixed entropy output which doesn't rely on a single
> > + * source.
> > + *
> > + * Return: number of random bytes read or a negative error value.
> > + */
> > +int tpm_get_random(struct tpm_chip *chip, u8 *out, size_t max)
> > +{
> > +	int rc;
> > +
> > +	rc = __tpm_get_random(chip, out, max);
> > +	if (rc <= 0)
> > +		return rc;
> > +	/*
> > +	 * assume the TPM produces pure randomness, so the amount of
> > +	 * entropy is the number of bits returned
> > +	 */
> > +	add_hwgenerator_randomness(out, rc, rc * 8);
> > +	get_random_bytes(out, rc);
> 
> Using the TPM as a source of input to the kernel random number
> generator is fine, but please don't change the meaning of trusted
> keys.  The trusted-encrypted keys documentation clearly states
> "Trusted Keys use a TPM both to generate and to seal the keys."
> 
> If you really want to use a different random number source instead of
> the TPM, then define a new trusted key option (eg. rng=kernel), with
> the default being the TPM.

I'll add a patch that updates the documentation because it is clearly
not a good practice to use TPM to generate keys that are not keys
residing inside the TPM.

With TEE coming in, TPM is not the only hardware measure anymore sealing
the keys and we don't want a mess where every hardware asset does their
own proprietary key generation. The proprietary technology should only
take care of the sealing part.

/Jarkko

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49E3CC2AE
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfJDSaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 14:30:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:43310 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfJDSaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 14:30:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 11:30:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="205911849"
Received: from nzaki1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.4.57])
  by fmsmga001.fm.intel.com with ESMTP; 04 Oct 2019 11:30:04 -0700
Date:   Fri, 4 Oct 2019 21:30:03 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Safford, David (GE Global Research, US)" <david.safford@ge.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        "Wiseman, Monty (GE Global Research, US)" <monty.wiseman@ge.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191004183003.GD6945@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004182711.GC6945@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > There are many good reasons for wanting the keys to be based on the
> > TPM generator.  As the source for the kernel random number generator
> > itself says, some systems lack good randomness at startup, and systems
> > should preserve and reload the pool across shutdown and startup.
> > There are use cases for trusted keys which need to generate keys 
> > before such scripts have run. Also, in some use cases, we need to show
> > that trusted keys are FIPS compliant, which is possible with TPM
> > generated keys.
> 
> If you are able to call tpm_get_random(), the driver has already
> registered TPN as hwrng. With this solution you fail to follow the
> principle of defense in depth. If the TPM random number generator
> is compromissed (has a bug) using the entropy pool will decrease
> the collateral damage.

I.e. you make everything depend on single point of failure instead
of multiple (e.g. rdrand, TPM, whatnot).

/Jarkko

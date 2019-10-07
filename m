Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC149CD9D3
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 02:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfJGAF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 20:05:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:28126 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfJGAF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 20:05:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Oct 2019 17:05:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,265,1566889200"; 
   d="scan'208";a="204904213"
Received: from mwebb1-mobl.ger.corp.intel.com (HELO localhost) ([10.251.93.103])
  by orsmga002.jf.intel.com with ESMTP; 06 Oct 2019 17:05:22 -0700
Date:   Mon, 7 Oct 2019 03:05:20 +0300
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
Message-ID: <20191007000520.GA17116@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
 <20191004182711.GC6945@linux.intel.com>
 <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 04, 2019 at 07:56:01PM +0000, Safford, David (GE Global Research, US) wrote:
> 
> > From: linux-integrity-owner@vger.kernel.org <linux-integrity-
> > owner@vger.kernel.org> On Behalf Of Jarkko Sakkinen
> > Sent: Friday, October 4, 2019 2:27 PM
> > Subject: EXT: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
> > 
> > If you are able to call tpm_get_random(), the driver has already registered
> > TPN as hwrng. With this solution you fail to follow the principle of defense in
> > depth. If the TPM random number generator is compromissed (has a bug)
> > using the entropy pool will decrease the collateral damage.
> 
> And if the entropy pool has a bug or is misconfigured, you lose everything.
> That does not sound like defense in depth to me. In the real world
> I am not aware of a single instance of RNG vulnerability on a TPM.
> I am directly aware of several published vulnerabilities in embedded systems 
> due to a badly ported version of the kernel random pool. In addition, 
> the random generator in a TPM is hardware isolated, and less likely to be
> vulnerable to side channel or memory manipulation errors. The TPM
> RNG is typically FIPS certified.  The use of the TPM RNG was a deliberate
> design choice in trusted keys.

Hmm... so is RDRAND opcode FIPS certified.

Kernel has the random number generator for two reasons:

1. To protect against bugs in hwrng's.
2. To protect against deliberate backdoors in hwrng's.

How TPM RNG is guaranteed to protect against both 1 and 2?

If I would agree what you say, that'd be argument against using kernel
random number generator *anywhere* in the kernel. Even with the entropy
issues it is least worst thing to use for key generations for better
or worse.

/Jarkko

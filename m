Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85EECC287
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 20:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfJDSW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 14:22:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:10975 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbfJDSWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 14:22:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 11:22:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="198932519"
Received: from nzaki1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.4.57])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Oct 2019 11:22:18 -0700
Date:   Fri, 4 Oct 2019 21:22:16 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191004182216.GB6945@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <1570024819.4999.119.camel@linux.ibm.com>
 <20191003114119.GF8933@linux.intel.com>
 <1570107752.4421.183.camel@linux.ibm.com>
 <20191003175854.GB19679@linux.intel.com>
 <1570128827.5046.19.camel@linux.ibm.com>
 <20191003215125.GA30511@linux.intel.com>
 <20191003215743.GB30511@linux.intel.com>
 <1570140491.5046.33.camel@linux.ibm.com>
 <1570147177.10818.11.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570147177.10818.11.camel@HansenPartnership.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 04:59:37PM -0700, James Bottomley wrote:
> I think the principle of using multiple RNG sources for strong keys is
> a sound one, so could I propose a compromise:  We have a tpm subsystem
> random number generator that, when asked for <n> random bytes first
> extracts <n> bytes from the TPM RNG and places it into the kernel
> entropy pool and then asks for <n> random bytes from the kernel RNG? 
> That way, it will always have the entropy to satisfy the request and in
> the worst case, where the kernel has picked up no other entropy sources
> at all it will be equivalent to what we have now (single entropy
> source) but usually it will be a much better mixed entropy source.

I think we should rely the existing architecture where TPM is
contributing to the entropy pool as hwrng.

/Jarkko

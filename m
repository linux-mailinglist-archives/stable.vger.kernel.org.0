Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0A5C4219
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 22:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfJAUyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 16:54:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:14871 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfJAUyv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 16:54:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 13:54:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="275119848"
Received: from nbaca1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.57])
  by orsmga001.jf.intel.com with ESMTP; 01 Oct 2019 13:54:46 -0700
Date:   Tue, 1 Oct 2019 23:54:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
Message-ID: <20191001205445.GC26709@linux.intel.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
 <20190928180559.jivt5zlisr43fnva@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190928180559.jivt5zlisr43fnva@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 28, 2019 at 11:05:59AM -0700, Jerry Snitselaar wrote:
> On Thu Sep 26 19, Jarkko Sakkinen wrote:
> > Only the kernel random pool should be used for generating random numbers.
> > TPM contributes to that pool among the other sources of entropy. In here it
> > is not, agreed, absolutely critical because TPM is what is trusted anyway
> > but in order to remove tpm_get_random() we need to first remove all the > > call sites.  > > 
> > Cc: stable@vger.kernel.org
> > Fixes: 0c36264aa1d5 ("KEYS: asym_tpm: Add loadkey2 and flushspecific [ver #2]")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> > crypto/asymmetric_keys/asym_tpm.c | 7 ++-----
> > 1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
> > index 76d2ce3a1b5b..c14b8d186e93 100644
> > --- a/crypto/asymmetric_keys/asym_tpm.c
> > +++ b/crypto/asymmetric_keys/asym_tpm.c
> > @@ -6,6 +6,7 @@
> > #include <linux/kernel.h>
> > #include <linux/seq_file.h>
> > #include <linux/scatterlist.h>
> > +#include <linux/random.h>
> > #include <linux/tpm.h>
> > #include <linux/tpm_command.h>
> > #include <crypto/akcipher.h>
> > @@ -54,11 +55,7 @@ static int tpm_loadkey2(struct tpm_buf *tb,
> > 	}
> > 
> > 	/* generate odd nonce */
> > -	ret = tpm_get_random(NULL, nonceodd, TPM_NONCE_SIZE);
> > -	if (ret < 0) {
> > -		pr_info("tpm_get_random failed (%d)\n", ret);
> > -		return ret;
> > -	}
> > +	get_random_bytes(nonceodd, TPM_NONCE_SIZE);
> > 
> > 	/* calculate authorization HMAC value */
> > 	ret = TSS_authhmac(authdata, keyauth, SHA1_DIGEST_SIZE, enonce,
> > -- 
> > 2.20.1
> > 
> 
> Should tpm_unbind and tpm_sign in asym_tpm.c be switched as well then?

Without doubt. Thanks. I'll send an update soon.

/Jarkko

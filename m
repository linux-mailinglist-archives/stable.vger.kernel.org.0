Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF66E1748D3
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 20:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgB2TCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 14:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727341AbgB2TCo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 14:02:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AEB2467D;
        Sat, 29 Feb 2020 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583002962;
        bh=v/dxdUzMi5BClO84askTDLqpiG52LyTh0c5NKk9qtfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y9C2W3o9s2rZc5/yf3FQD10PIYSBtS3kkn635kUER/NjdBk1sn1R//j3YtjDZ1GU9
         jP1Iu9X994V18yD3+S8Dr3dLv/WXaN1trJLbfDq4BcC8AZaAr/c/llKSWkNs9ZAsuD
         7DZ02C9FiNbF7HWLf65cMMSxSi8gez6uqomPBLJA=
Date:   Sat, 29 Feb 2020 20:02:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vikash Bansal <bvikas@vmware.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Sharath George <sharathg@vmware.com>,
        Steven Rostedt <srostedt@vmware.com>,
        Ajay Kaher <akaher@vmware.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Stephan Mueller <smueller@chronox.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4.19.y, v4.14.y, v4.9.y] crypto: drbg - add FIPS 140-2
 CTRNG for noise source
Message-ID: <20200229190239.GB832132@kroah.com>
References: <20200227055805.3011-1-bvikas@vmware.com>
 <20200227070030.GA290231@kroah.com>
 <87EC78FF-21EE-4921-B819-CBA4D328E159@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87EC78FF-21EE-4921-B819-CBA4D328E159@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 29, 2020 at 10:01:49AM +0000, Vikash Bansal wrote:
> 
> On 27/02/20, 12:30 PM, "Greg KH" <gregkh@linuxfoundation.org> wrote:
> 
>     
> > On Thu, Feb 27, 2020 at 05:58:05AM +0000, Vikash Bansal wrote:
> >> From: Stephan Mueller <smueller@chronox.de>
> >>
> >> commit db07cd26ac6a418dc2823187958edcfdb415fa83 upstream
> >>
> >> FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
> >> source. Up to kernel 4.8 drivers/char/random.c provided this continuous
> >> self test. Afterwards it was moved to a location that is inconsistent
> >> with the FIPS 140-2 requirements. The relevant patch was
> >> e192be9d9a30555aae2ca1dc3aad37cba484cd4a .
> >>
> >> Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
> >> seed. This patch resurrects the function drbg_fips_continous_test that
> >> existed some time ago and applies it to the noise sources. The patch
> >> that removed the drbg_fips_continous_test was
> >> b3614763059b82c26bdd02ffcb1c016c1132aad0 .
> >>
> >> The Jitter RNG implements its own FIPS 140-2 self test and thus does not
> >> need to be subjected to the test in the DRBG.
> >>
> >> The patch contains a tiny fix to ensure proper zeroization in case of an
> >> error during the Jitter RNG data gathering.
> >>
> >> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> >> Reviewed-by: Yann Droneaud <ydroneaud@opteya.com>
> >> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> >> Signed-off-by: Vikash Bansal <bvikas@vmware.com>
> >> ---
> >>  crypto/drbg.c         | 94 +++++++++++++++++++++++++++++++++++++++++--
> >>  include/crypto/drbg.h |  2 +
> >>  2 files changed, 93 insertions(+), 3 deletions(-)
> >    
> > This looks like a new feature to me, why is it needed in the stable
> > kernel trees?  What bug does it fix?
> 
> In 4.19.y, 4.14.y & 4.9.y, DRBG implementation is as per NIST recommendation
> defined in NIST SP800-9A and it designed to be ready for FIPS certification.
> But it has missed one of the NIST test requirement define in FIPS 140-2(4.9.2),
> so it is not ready for NIST FIPS certification.
> With this patch FIPS 140-2(4.9.2) continuous test requirement will be fulfilled.

Then use 5.4 or newer kernels if you need such a certification.  Adding
this new feature to older kernels is just that, a new feature.

What is preventing you from using 5.4?  It's much better security wise
than older kernels for a whole load of reasons.

thanks,

greg k-h

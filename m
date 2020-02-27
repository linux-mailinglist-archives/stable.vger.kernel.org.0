Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B689A171132
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 08:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgB0HAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 02:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726575AbgB0HAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 02:00:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 482DE24683;
        Thu, 27 Feb 2020 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582786832;
        bh=61ZsepioHFZjQ0D9/9H1BXNqbeED3FxNKaQ3c53npQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cGQZ4abji9pVxxNn8IznWaokOj9xhA0Blr3bdk56nGjIVXenFRAlEmmjspzJjZI7e
         Jw+BpKLSfIZy8g1c2nOzJqEhc75wKs8c88qRrdp9HFkfX0d+y+10sWlgqty5S8dlfM
         Ihdlpu8X9zNMA8F5oL1HDJyMAdcNNJgOs6Rtaagk=
Date:   Thu, 27 Feb 2020 08:00:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vikash Bansal <bvikas@vmware.com>
Cc:     stable@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        anishs@vmware.com, vsirnapalli@vmware.com, sharathg@vmware.com,
        srostedt@vmware.com, akaher@vmware.com, rostedt@goodmis.org,
        Stephan Mueller <smueller@chronox.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4.19.y, v4.14.y, v4.9.y] crypto: drbg - add FIPS 140-2
 CTRNG for noise source
Message-ID: <20200227070030.GA290231@kroah.com>
References: <20200227055805.3011-1-bvikas@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227055805.3011-1-bvikas@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 05:58:05AM +0000, Vikash Bansal wrote:
> From: Stephan Mueller <smueller@chronox.de>
> 
> commit db07cd26ac6a418dc2823187958edcfdb415fa83 upstream
> 
> FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
> source. Up to kernel 4.8 drivers/char/random.c provided this continuous
> self test. Afterwards it was moved to a location that is inconsistent
> with the FIPS 140-2 requirements. The relevant patch was
> e192be9d9a30555aae2ca1dc3aad37cba484cd4a .
> 
> Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
> seed. This patch resurrects the function drbg_fips_continous_test that
> existed some time ago and applies it to the noise sources. The patch
> that removed the drbg_fips_continous_test was
> b3614763059b82c26bdd02ffcb1c016c1132aad0 .
> 
> The Jitter RNG implements its own FIPS 140-2 self test and thus does not
> need to be subjected to the test in the DRBG.
> 
> The patch contains a tiny fix to ensure proper zeroization in case of an
> error during the Jitter RNG data gathering.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> Reviewed-by: Yann Droneaud <ydroneaud@opteya.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Vikash Bansal <bvikas@vmware.com>
> ---
>  crypto/drbg.c         | 94 +++++++++++++++++++++++++++++++++++++++++--
>  include/crypto/drbg.h |  2 +
>  2 files changed, 93 insertions(+), 3 deletions(-)

This looks like a new feature to me, why is it needed in the stable
kernel trees?  What bug does it fix?

thanks,

greg k-h

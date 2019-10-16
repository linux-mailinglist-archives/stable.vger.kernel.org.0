Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6917D9106
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393116AbfJPMeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 08:34:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55966 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733070AbfJPMeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 08:34:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 95DF98EE0CC;
        Wed, 16 Oct 2019 05:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571229255;
        bh=DLovgWcYpoVQPuDx5Rz7kbFf0gXtdi0u6vI43N1Bp0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o14jG9dc+ikKCo66qGBQlCFm7kBAJKESbhF9cGoKLps4Qdla9QfbpwQZTQdxwy4pr
         Ie8/keP0YBtAJc2dqVABjG8Bk+7XZ8GO0TIJNzabgoJEmWxtYSrJ6FVvTTQf0x74lS
         fmlDUGpZZHSpfBzrcxRH1i4cN9PklcmjSLJN2XEM=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MeFCJHFdFf8g; Wed, 16 Oct 2019 05:34:15 -0700 (PDT)
Received: from [192.168.100.84] (unknown [24.246.103.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 61D5F8EE02B;
        Wed, 16 Oct 2019 05:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571229255;
        bh=DLovgWcYpoVQPuDx5Rz7kbFf0gXtdi0u6vI43N1Bp0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o14jG9dc+ikKCo66qGBQlCFm7kBAJKESbhF9cGoKLps4Qdla9QfbpwQZTQdxwy4pr
         Ie8/keP0YBtAJc2dqVABjG8Bk+7XZ8GO0TIJNzabgoJEmWxtYSrJ6FVvTTQf0x74lS
         fmlDUGpZZHSpfBzrcxRH1i4cN9PklcmjSLJN2XEM=
Message-ID: <1571229252.3477.7.camel@HansenPartnership.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "Safford, David (GE Global Research, US)" <david.safford@ge.com>,
        Ken Goldman <kgold@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Oct 2019 08:34:12 -0400
In-Reply-To: <20191016110031.GE10184@linux.intel.com>
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A22E@ALPMBAPA12.e2k.ad.ge.com>
         <20191004182711.GC6945@linux.intel.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
         <20191007000520.GA17116@linux.intel.com>
         <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
         <20191008234935.GA13926@linux.intel.com>
         <20191008235339.GB13926@linux.intel.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
         <20191014190033.GA15552@linux.intel.com>
         <1571081397.3728.9.camel@HansenPartnership.com>
         <20191016110031.GE10184@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-10-16 at 14:00 +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 14, 2019 at 12:29:57PM -0700, James Bottomley wrote:
> > The job of the in-kernel rng is simply to produce a mixed entropy
> > pool from which we can draw random numbers.  The idea is that quite
> > a few attackers have identified the rng as being a weak point in
> > the security architecture of the kernel, so if we mix entropy from
> > all the sources we have, you have to compromise most of them to
> > gain some predictive power over the rng sequence.
> 
> The documentation says that krng is suitable for key generation.
> Should the documentation changed to state that it is unsuitable?

How do you get that from the argument above?  The krng is about the
best we have in terms of unpredictable key generation, so of course it
is suitable ... provided you give the entropy enough time to have
sufficient entropy.  It's also not foolproof ... Bernstein did a
speculation about how you could compromise all our input sources for
entropy.  However the more sources we have the more difficult the
compromise becomes.

> > The point is not how certified the TPM RNG is, the point is that
> > it's a single source and if we rely on it solely for some
> > applications, like trusted keys, then it gives the attackers a
> > single known point to go after.  This may be impossible for script
> > kiddies, but it won't be for nation states ... are you going to
> > exclusively trust the random number you got from your chinese
> > certified TPM?
> 
> I'd suggest approach where TPM RNG result is xored with krng result.

reversible ciphers are generally frowned upon in random number
generation, that's why the krng uses chacha20.  In general I think we
shouldn't try to code our own mixing and instead should get the krng to
do it for us using whatever the algorithm du jour that the crypto guys
have blessed is.  That's why I proposed adding the TPM output to the
krng as entropy input and then taking the output of the krng.

James

> > Remember also that the attack doesn't have to be to the TPM only,
> > it could be the pathway by which we get the random number, which
> > involves components outside of the TPM certification.
> 
> Yeah, I do get this.
> 
> /Jarkko
> 


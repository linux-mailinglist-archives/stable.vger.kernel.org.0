Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA159D99BB
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 21:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436686AbfJPTKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 15:10:33 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35082 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732084AbfJPTKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 15:10:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7838D8EE0CC;
        Wed, 16 Oct 2019 12:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571253032;
        bh=pZvAVmDqMp56efKKwit5bs7uRqUQsjVTFJozEct6wvU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ClJJXg/ZVGUv+nH7L2Plg7+hQNHIidZPswodVDriX2adntBmJVShn1Hck6smY7GPI
         4SIfWp+esnM5gawAtRrAIu4tHPIHDPA7EH9LSDbx3nqSqZB5B4mNhumvgovOHIPXN5
         fBnxmGSn/rxr/5/10m3EOjyZb870ftman3umiOnE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FHHZIyJXfYlB; Wed, 16 Oct 2019 12:10:32 -0700 (PDT)
Received: from [9.232.197.57] (unknown [129.33.253.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2BF048EE02B;
        Wed, 16 Oct 2019 12:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1571253032;
        bh=pZvAVmDqMp56efKKwit5bs7uRqUQsjVTFJozEct6wvU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ClJJXg/ZVGUv+nH7L2Plg7+hQNHIidZPswodVDriX2adntBmJVShn1Hck6smY7GPI
         4SIfWp+esnM5gawAtRrAIu4tHPIHDPA7EH9LSDbx3nqSqZB5B4mNhumvgovOHIPXN5
         fBnxmGSn/rxr/5/10m3EOjyZb870ftman3umiOnE=
Message-ID: <1571253029.17520.5.camel@HansenPartnership.com>
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
Date:   Wed, 16 Oct 2019 15:10:29 -0400
In-Reply-To: <20191016162543.GB6279@linux.intel.com>
References: <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2A38B@ALPMBAPA12.e2k.ad.ge.com>
         <20191007000520.GA17116@linux.intel.com>
         <59b88042-9c56-c891-f75e-7c0719eb5ff9@linux.ibm.com>
         <20191008234935.GA13926@linux.intel.com>
         <20191008235339.GB13926@linux.intel.com>
         <BCA04D5D9A3B764C9B7405BBA4D4A3C035F2B995@ALPMBAPA12.e2k.ad.ge.com>
         <20191014190033.GA15552@linux.intel.com>
         <1571081397.3728.9.camel@HansenPartnership.com>
         <20191016110031.GE10184@linux.intel.com>
         <1571229252.3477.7.camel@HansenPartnership.com>
         <20191016162543.GB6279@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-10-16 at 19:25 +0300, Jarkko Sakkinen wrote:
> On Wed, Oct 16, 2019 at 08:34:12AM -0400, James Bottomley wrote:
> > reversible ciphers are generally frowned upon in random number
> > generation, that's why the krng uses chacha20.  In general I think
> > we shouldn't try to code our own mixing and instead should get the
> > krng to do it for us using whatever the algorithm du jour that the
> > crypto guys have blessed is.  That's why I proposed adding the TPM
> > output to the krng as entropy input and then taking the output of
> > the krng.
> 
> It is already registered as hwrng. What else?

It only contributes entropy once at start of OS.

>  Was the issue that it is only used as seed when the rng is init'd
> first? I haven't at this point gone to the internals of krng.

Basically it was similar to your xor patch except I got the kernel rng
to do the mixing, so it would use the chacha20 cipher at the moment
until they decide that's unsafe and change it to something else:

https://lore.kernel.org/linux-crypto/1570227068.17537.4.camel@HansenPartnership.com/

It uses add_hwgenerator_randomness() to do the mixing.  It also has an
unmixed source so that read of the TPM hwrng device works as expected.

James






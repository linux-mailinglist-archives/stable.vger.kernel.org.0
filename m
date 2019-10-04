Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD624CC2DE
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 20:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfJDSnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 14:43:02 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60460 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbfJDSnC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 14:43:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2D7ED8EE21D;
        Fri,  4 Oct 2019 11:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570214580;
        bh=M74BA6tZivmW9mP21CAJFbPqbr1TAq/9ADBP/A9ZWCU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lDID8OIt0ZoWsUhcV9xGKmNthRBBOfWUHonDTKSjA6LoJ/9SHYXTalE3NXX5NjWud
         GnbDsj5BSMKN7HrlBwZmEIE5it50+cKw7/Gq8Hy9g1trWY1TLFmRZLcHMEp3doU5EP
         QB0qnuFiFQJukSgdNFdrdm1KRZUxFwe4W32uPuME=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 41kHJ_Bxesff; Fri,  4 Oct 2019 11:42:59 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 630708EE0EE;
        Fri,  4 Oct 2019 11:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570214578;
        bh=M74BA6tZivmW9mP21CAJFbPqbr1TAq/9ADBP/A9ZWCU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BfZjm1wfN2MVKPY+jvDeZiktbgRzU31b3o8X+q8WouZEqANNy/ySb6YPUcZ5MQcAD
         t7KviywM4RRCfrVF8s8/cb+iZqvx9HOB3pH8SevfVrQMIKyN7nJ9qZUe5ztkHLjmy6
         F5VsKsL7UYugGwZkXmjEArIWxnVjDZen55Euh170=
Message-ID: <1570214574.3563.32.camel@HansenPartnership.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jerry Snitselaar <jsnitsel@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 04 Oct 2019 11:42:54 -0700
In-Reply-To: <20191004183342.y63qdvspojyf3m55@cantor>
References: <20191003114119.GF8933@linux.intel.com>
         <1570107752.4421.183.camel@linux.ibm.com>
         <20191003175854.GB19679@linux.intel.com>
         <1570128827.5046.19.camel@linux.ibm.com>
         <20191003215125.GA30511@linux.intel.com>
         <20191003215743.GB30511@linux.intel.com>
         <1570140491.5046.33.camel@linux.ibm.com>
         <1570147177.10818.11.camel@HansenPartnership.com>
         <20191004182216.GB6945@linux.intel.com>
         <1570213491.3563.27.camel@HansenPartnership.com>
         <20191004183342.y63qdvspojyf3m55@cantor>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-10-04 at 11:33 -0700, Jerry Snitselaar wrote:
> On Fri Oct 04 19, James Bottomley wrote:
> > On Fri, 2019-10-04 at 21:22 +0300, Jarkko Sakkinen wrote:
> > > On Thu, Oct 03, 2019 at 04:59:37PM -0700, James Bottomley wrote:
> > > > I think the principle of using multiple RNG sources for strong
> > > > keys is a sound one, so could I propose a compromise:  We have
> > > > a tpm subsystem random number generator that, when asked for
> > > > <n> random bytes first extracts <n> bytes from the TPM RNG and
> > > > places it into the kernel entropy pool and then asks for <n>
> > > > random bytes from the kernel RNG? That way, it will always have
> > > > the entropy to satisfy the request and in the worst case, where
> > > > the kernel has picked up no other entropy sources at all it
> > > > will be equivalent to what we have now (single entropy source)
> > > > but usually it will be a much better mixed entropy source.
> > > 
> > > I think we should rely the existing architecture where TPM is
> > > contributing to the entropy pool as hwrng.
> > 
> > That doesn't seem to work: when I trace what happens I see us
> > inject 32 bytes of entropy at boot time, but never again.  I think
> > the problem is the kernel entropy pool is push not pull and we have
> > no triggering event in the TPM to get us to push.  I suppose we
> > could set a timer to do this or perhaps there is a pull hook and we
> > haven't wired it up correctly?
> > 
> > James
> > 
> 
> Shouldn't hwrng_fillfn be pulling from it?

It should, but the problem seems to be it only polls the "current" hw
rng ... it doesn't seem to have a concept that there may be more than
one.  What happens, according to a brief reading of the code, is when
multiple are registered, it determines what the "best" one is and then
only pulls from that.  What I think it should be doing is filling from
all of them using the entropy quality to adjust how many bits we get.

James


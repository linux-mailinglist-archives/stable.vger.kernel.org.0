Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C210ECB292
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfJCX7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 19:59:40 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44132 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730905AbfJCX7k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 19:59:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 519E08EE21D;
        Thu,  3 Oct 2019 16:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570147179;
        bh=6O8ZC/kLYkGy46YrjCCuRLlBQjcK3lJe0wWZA1ib33k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gHREQLZqG1tjSW8UCzDvhN70XysKVjJr+0QT/GG778vyZksFD2B/Y31DL8sdhIz+Y
         e5ZOkkmGAZtbBOpDhH+Z9cDawWQr5cg4uPpsruM4VNoKcGH7Vn7nLalmKthysDLPA7
         5zq26ZCJysabBTzAzYuUZ3DgSU7U/XZdtdySY/TE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tJOVXcp-lVYk; Thu,  3 Oct 2019 16:59:38 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 641A88EE144;
        Thu,  3 Oct 2019 16:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1570147178;
        bh=6O8ZC/kLYkGy46YrjCCuRLlBQjcK3lJe0wWZA1ib33k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bBOdzo0iejucXCgXhFuo4MiIolWZeKeAsuOhJ+oTuNDxWCM9VJi7YPQiWzZKeC59/
         Ix4YKzkvUrR1Ea8VBv+pFxmToWe/G/D335f3IP6DEWjXbo3U9XPWKlw02bvhQGCSLP
         3uZKs33kpK+G8COpgz/XMUDekFUy5myxG7qiImS8=
Message-ID: <1570147177.10818.11.camel@HansenPartnership.com>
Subject: Re: [PATCH] KEYS: asym_tpm: Switch to get_random_bytes()
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Mimi Zohar <zohar@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     David Safford <david.safford@ge.com>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 03 Oct 2019 16:59:37 -0700
In-Reply-To: <1570140491.5046.33.camel@linux.ibm.com>
References: <20190926171601.30404-1-jarkko.sakkinen@linux.intel.com>
         <1570024819.4999.119.camel@linux.ibm.com>
         <20191003114119.GF8933@linux.intel.com>
         <1570107752.4421.183.camel@linux.ibm.com>
         <20191003175854.GB19679@linux.intel.com>
         <1570128827.5046.19.camel@linux.ibm.com>
         <20191003215125.GA30511@linux.intel.com>
         <20191003215743.GB30511@linux.intel.com>
         <1570140491.5046.33.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2019-10-03 at 18:08 -0400, Mimi Zohar wrote:
> On Fri, 2019-10-04 at 00:57 +0300, Jarkko Sakkinen wrote:
> > On Fri, Oct 04, 2019 at 12:51:25AM +0300, Jarkko Sakkinen wrote:
> > > On Thu, Oct 03, 2019 at 02:53:47PM -0400, Mimi Zohar wrote:
> > > > [Cc'ing David Safford]
> > > > 
> > > > On Thu, 2019-10-03 at 20:58 +0300, Jarkko Sakkinen wrote:
> > > > > On Thu, Oct 03, 2019 at 09:02:32AM -0400, Mimi Zohar wrote:
> > > > > > On Thu, 2019-10-03 at 14:41 +0300, Jarkko Sakkinen wrote:
> > > > > > > On Wed, Oct 02, 2019 at 10:00:19AM -0400, Mimi Zohar
> > > > > > > wrote:
> > > > > > > > On Thu, 2019-09-26 at 20:16 +0300, Jarkko Sakkinen
> > > > > > > > wrote:
> > > > > > > > > Only the kernel random pool should be used for
> > > > > > > > > generating random numbers.
> > > > > > > > > TPM contributes to that pool among the other sources
> > > > > > > > > of entropy. In here it
> > > > > > > > > is not, agreed, absolutely critical because TPM is
> > > > > > > > > what is trusted anyway
> > > > > > > > > but in order to remove tpm_get_random() we need to
> > > > > > > > > first remove all the
> > > > > > > > > call sites.
> > > > > > > > 
> > > > > > > > At what point during boot is the kernel random pool
> > > > > > > > available?  Does this imply that you're planning on
> > > > > > > > changing trusted keys as well?
> > > > > > > 
> > > > > > > Well trusted keys *must* be changed to use it. It is not
> > > > > > > a choice because using a proprietary random number
> > > > > > > generator instead of defacto one in the kernel can be
> > > > > > > categorized as a *regression*.
> > > > > > 
> > > > > > I really don't see how using the TPM random number for TPM
> > > > > > trusted keys would be considered a regression.  That by
> > > > > > definition is a trusted key.  If anything, changing what is
> > > > > > currently being done would be the regression. 
> > > > > 
> > > > > It is really not a TPM trusted key. It trusted key that gets
> > > > > sealed with the TPM. The key itself is used in clear by
> > > > > kernel. The random number generator exists in the kernel to
> > > > > for a reason.
> > > > > 
> > > > > It is without doubt a regression.
> > > > 
> > > > You're misusing the term "regression" here.  A regression is
> > > > something that previously worked and has stopped working.  In
> > > > this case, trusted keys has always been based on the TPM random
> > > > number generator.  Before changing this, there needs to be some
> > > > guarantees that the kernel random number generator has a pool
> > > > of random numbers early, on all systems including embedded
> > > > devices, not just servers.
> > > 
> > > I'm not using the term regression incorrectly here. Wrong
> > > function was used to generate random numbers for the payload
> > > here. It is an obvious bug.
> > 
> > At the time when trusted keys was introduced I'd say that it was a
> > wrong design decision and badly implemented code. But you are right
> > in that as far that code is considered it would unfair to speak of
> > a regression.

I think that's a bit unfair: when the code was written, a decade ago,
the TPM was thought to be the state of the art in terms of random
number generators.  Of course, since then the kernel RNG has become way
better and we've become more aware of nation state actors thinking that
influencing the RNG is the best way to compromise strong crypto.

> > asym-tpm.c on the other hand this is fresh new code. There has been
> > *countless* of discussions over the years that random numbers
> > should come from multiple sources of entropy. There is no other
> > categorization than a bug for the tpm_get_random() there.
> 
> This week's LWN article on "5.4 Merge window, part 2" discusses
> "boot- time entropy".  This article couldn't have been more perfectly
> timed.

I think the principle of using multiple RNG sources for strong keys is
a sound one, so could I propose a compromise:  We have a tpm subsystem
random number generator that, when asked for <n> random bytes first
extracts <n> bytes from the TPM RNG and places it into the kernel
entropy pool and then asks for <n> random bytes from the kernel RNG? 
That way, it will always have the entropy to satisfy the request and in
the worst case, where the kernel has picked up no other entropy sources
at all it will be equivalent to what we have now (single entropy
source) but usually it will be a much better mixed entropy source.

James


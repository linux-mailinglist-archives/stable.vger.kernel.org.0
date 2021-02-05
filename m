Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8954D3102AA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBECTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:19:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhBECTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 21:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1288764F9C;
        Fri,  5 Feb 2021 02:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612491538;
        bh=MKW/fYjZaBRm+U5gGYCM1y9kfRgrFjxcJFbjpchOmU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dnRDqOJq88kswz0BE3ymdbaNOb5uVsM+mw2UZ5vkq2K4aRz7RXrTrRyWExEaGk183
         ZRd+FVoXnxzoKPVYXRQWsey5YThYLB+l/uL2TIRabMH/qikaW5LeSlq4VX5g2iKi1W
         bt9F2gNdZ11nthhQe3XjNektq9vQoSK/bbejqrBD9fJaGKzeYFpcCHu85YlP02zzJI
         Cow3XZwg/xHmivSUBMPmOnhQf++VSAHQmz8fSOgp46wm6BStEoKpjdOHyuuvZTtz97
         7uxxEzWpk+SbtX2pwNUiNGiCnXGAVZIBMAXGW9YpcW1D4YXAJgo06qYCcbzYNr9fv7
         IZ80HXnYCibpw==
Date:   Fri, 5 Feb 2021 04:18:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
Message-ID: <YByrCnswkIlz1w1t@kernel.org>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 04:34:11PM -0800, James Bottomley wrote:
> On Fri, 2021-02-05 at 00:50 +0100, Lino Sanfilippo wrote:
> > From: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > 
> > In tpm2_del_space() chip->ops is used for flushing the sessions.
> > However
> > this function may be called after tpm_chip_unregister() which sets
> > the chip->ops pointer to NULL.
> > Avoid a possible NULL pointer dereference by checking if chip->ops is
> > still
> > valid before accessing it.
> > 
> > Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of
> > tpm_transmit()")
> > Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> > ---
> >  drivers/char/tpm/tpm2-space.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-
> > space.c
> > index 784b8b3..9a29a40 100644
> > --- a/drivers/char/tpm/tpm2-space.c
> > +++ b/drivers/char/tpm/tpm2-space.c
> > @@ -58,12 +58,17 @@ int tpm2_init_space(struct tpm_space *space,
> > unsigned int buf_size)
> >  
> >  void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space)
> >  {
> > -	mutex_lock(&chip->tpm_mutex);
> > -	if (!tpm_chip_start(chip)) {
> > -		tpm2_flush_sessions(chip, space);
> > -		tpm_chip_stop(chip);
> > +	down_read(&chip->ops_sem);
> > +	if (chip->ops) {
> > +		mutex_lock(&chip->tpm_mutex);
> > +		if (!tpm_chip_start(chip)) {
> > +			tpm2_flush_sessions(chip, space);
> > +			tpm_chip_stop(chip);
> > +		}
> > +		mutex_unlock(&chip->tpm_mutex);
> >  	}
> > -	mutex_unlock(&chip->tpm_mutex);
> > +	up_read(&chip->ops_sem);
> > +
> >  	kfree(space->context_buf);
> >  	kfree(space->session_buf);
> >  }
> 
> 
> Actually, this still isn't right.  As I said to the last person who
> reported this, we should be doing a get/put on the ops, not rolling our
> own here:
> 
> https://lore.kernel.org/linux-integrity/e7566e1e48f5be9dca034b4bfb67683b5d3cb88f.camel@HansenPartnership.com/
> 
> The reporter went silent before we could get this tested, but could you
> try, please, because your patch is still hand rolling the ops get/put,
> just slightly better than it had been done previously.
> 
> James

Thanks for pointing this out. I'd strongly support Jason's proposal:

https://lore.kernel.org/linux-integrity/20201215175624.GG5487@ziepe.ca/

It's the best long-term way to fix this.

Honestly, I have to admit that this thread leaked from me. It happened
exactly at the time when I was on vacation. Something must have gone wrong
when I pulled emails after that.

/Jarkko

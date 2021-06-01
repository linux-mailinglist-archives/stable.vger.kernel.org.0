Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F80397967
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhFARpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhFARpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 13:45:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F997610C9;
        Tue,  1 Jun 2021 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622569439;
        bh=u4lyF2D/HM0weSlbfmy4xXBEbBV0fkP40AvuTgbqoSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWJZBhHh7tjA0Na3UlJWwo7bdj0zK7IYbeGk0UmmJ6mep1NlWeRGL6WskMvEEh0Al
         IivUACj2zaX4i/wZdN3hUPkTSHD8sxE5rc5Nkmmfp71v5r+37a3F8DHw80LKMoAI0i
         AJKct3SjIsoWxFn+glt4K9qijXQ5u0RbZeH/JicwmM2czQAQyGcBKU0Xqu+O0tBwY5
         VWEApeOwdpwfdo4RyF0PgvBYuCVxodF03WYgwaLxDj86rReIXw0cspmjU3WcOqReES
         XVpntZthvnJzZSS4yZnGvQ6JgOBl1fNw4i46bqzVtlRoWsWIKE+AoWGcYEAjVh2GJJ
         6q4df1YvZtvfg==
Date:   Tue, 1 Jun 2021 20:43:57 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] tpm: Replace WARN_ONCE() with dev_err_once() in
 tpm_tis_status()
Message-ID: <20210601174357.6ogui7jztcqt2lrt@kernel.org>
References: <20210531053427.118552-1-jarkko@kernel.org>
 <YLR5MSiVpv52FcZe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLR5MSiVpv52FcZe@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 07:50:41AM +0200, Greg KH wrote:
> On Mon, May 31, 2021 at 08:34:27AM +0300, Jarkko Sakkinen wrote:
> > Do not torn down the system when getting invalid status from a TPM chip.
> > This can happen when panic-on-warn is used.
> > 
> > In addition, print out the value of TPM_STS.x instead of "invalid
> > status". In order to get the earlier benefits for forensics, also call
> > dump_stack().
> > 
> > Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
> > Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
> > Cc: stable@vger.kernel.org
> > Cc: Hans de Goede <hdegoede@redhat.com>
> > Cc: Greg KH <greg@kroah.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> > 
> > v2:
> > Dump also stack only once.
> 
> Huh?
> 
> > 
> >  drivers/char/tpm/tpm_tis_core.c | 28 ++++++++++++++++++++--------
> >  1 file changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
> > index 55b9d3965ae1..ce410f19eff2 100644
> > --- a/drivers/char/tpm/tpm_tis_core.c
> > +++ b/drivers/char/tpm/tpm_tis_core.c
> > @@ -188,21 +188,33 @@ static int request_locality(struct tpm_chip *chip, int l)
> >  static u8 tpm_tis_status(struct tpm_chip *chip)
> >  {
> >  	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
> > -	int rc;
> > +	static unsigned long klog_once;
> >  	u8 status;
> > +	int rc;
> >  
> >  	rc = tpm_tis_read8(priv, TPM_STS(priv->locality), &status);
> >  	if (rc < 0)
> >  		return 0;
> >  
> >  	if (unlikely((status & TPM_STS_READ_ZERO) != 0)) {
> > -		/*
> > -		 * If this trips, the chances are the read is
> > -		 * returning 0xff because the locality hasn't been
> > -		 * acquired.  Usually because tpm_try_get_ops() hasn't
> > -		 * been called before doing a TPM operation.
> > -		 */
> > -		WARN_ONCE(1, "TPM returned invalid status\n");
> > +		if  (!test_and_set_bit(BIT(0), &klog_once)) {
> 
> Odd whitespace...
> 
> Anyway, why?  Isn't this what the ratelimit stuff should give you?  How
> badly is this being tripped so much so that you need to only do this
> once per entire system and not per-device?

The problem with "v1" was that the message was printed once, but the
dump_stack() was called however many times. And ratelimited stuff is
afaik only for printk's, there's no ratelimited dump_stack().

What you're saying makes sense tho. It would be sane behaviour to do
this once-per-device, instead of just once.

Since struct tpm_chip already has a bitmask flags, I'll just add a
TPM_CHIP_FLAG_INVALID_STATUS, and:

        if (test_and_set_bit(TPM_CHIP_FLAG_INVALID_STATUS, &chip->flags)) {
                /* ... */

> thanks,
> 
> greg k-h

Thank you.

/Jarkko

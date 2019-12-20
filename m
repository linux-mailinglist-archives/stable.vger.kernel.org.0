Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347171275C7
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 07:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTG2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 01:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfLTG2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 01:28:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0727424680;
        Fri, 20 Dec 2019 06:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576823328;
        bh=TdXbszKN3r8/fbvvZnRz49hQydGBL8c+do/5KQN4mCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=olo69ygy1z2Xj5n7VPbFHrVQxeJdB1IZIzRWQhGfE1m6ij+WCy3Ef4wQntcKa+Kao
         4mOG7v5Xc5vGPAWqlLep9m8Ltq0dl5A+cx4RXsVBo9WZrz8lvMCtfO44/djZ02hQrn
         3XVAd2+akO3QJoxJqYDv088zuT1IoQpbqlIBc73M=
Date:   Fri, 20 Dec 2019 07:28:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Stefani Seibold <stefani@seibold.net>, stable@vger.kernel.org
Subject: Re: broken sound since 5.4.3
Message-ID: <20191220062846.GA2183748@kroah.com>
References: <02def6201f9533106e0f195afed1422981215eb0.camel@seibold.net>
 <240a7610-577a-8253-e880-b55182460c17@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <240a7610-577a-8253-e880-b55182460c17@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 05:24:20PM -0500, Laura Abbott wrote:
> On 12/19/19 3:59 PM, Stefani Seibold wrote:
> > Hi,
> > 
> > the current Linux Kernel is going kills my speakers of my monitor.
> > 
> > Audio level is always 100 at percent.
> > 
> > I broke down the issue to the following patch:
> > 
> > diff --git a/sound/hda/hdac_stream.c b/sound/hda/hdac_stream.c
> > index d8fe7ff0cd58..f9707fb05efe 100644
> > --- a/sound/hda/hdac_stream.c
> > +++ b/sound/hda/hdac_stream.c
> > @@ -96,12 +96,14 @@ void snd_hdac_stream_start(struct hdac_stream *azx_dev, bool fresh_start)
> >   			      1 << azx_dev->index,
> >   			      1 << azx_dev->index);
> >   	/* set stripe control */
> > -	if (azx_dev->substream)
> > -		stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
> > -	else
> > -		stripe_ctl = 0;
> > -	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
> > -				stripe_ctl);
> > +	if (azx_dev->stripe) {
> > +		if (azx_dev->substream)
> > +			stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
> > +		else
> > +			stripe_ctl = 0;
> > +		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
> > +					stripe_ctl);
> > +	}
> >   	/* set DMA start and interrupt mask */
> >   	snd_hdac_stream_updateb(azx_dev, SD_CTL,
> >   				0, SD_CTL_DMA_START | SD_INT_MASK);
> > @@ -118,7 +120,10 @@ void snd_hdac_stream_clear(struct hdac_stream *azx_dev)
> >   	snd_hdac_stream_updateb(azx_dev, SD_CTL,
> >   				SD_CTL_DMA_START | SD_INT_MASK, 0);
> >   	snd_hdac_stream_writeb(azx_dev, SD_STS, SD_INT_MASK); /* to be sure */
> > -	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK, 0);
> > +	if (azx_dev->stripe) {
> > +		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK, 0);
> > +		azx_dev->stripe = 0;
> > +	}
> >   	azx_dev->running = false;
> >   }
> >   EXPORT_SYMBOL_GPL(snd_hdac_stream_clear);
> > 
> > 
> > 
> 
> I think this is fixed by 6fd739c04ffd ("ALSA: hda: Fix regression by strip mask fix")
> This is already tagged for stable but it would be nice to pick it up sooner.

Now queued up, thanks.

greg k-h

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874D312767D
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 08:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfLTHa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 02:30:29 -0500
Received: from www84.your-server.de ([213.133.104.84]:49774 "EHLO
        www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfLTHa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 02:30:28 -0500
Received: from [188.192.102.182] (helo=[192.168.0.7])
        by www84.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <stefani@seibold.net>)
        id 1iiCjy-0003Zp-Fd; Fri, 20 Dec 2019 08:30:26 +0100
Message-ID: <53d7a648ad756efbfa2d79b69a485fada1c5092d.camel@seibold.net>
Subject: Re: broken sound since 5.4.3
From:   Stefani Seibold <stefani@seibold.net>
To:     Laura Abbott <labbott@redhat.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Date:   Fri, 20 Dec 2019 08:30:23 +0100
In-Reply-To: <240a7610-577a-8253-e880-b55182460c17@redhat.com>
References: <02def6201f9533106e0f195afed1422981215eb0.camel@seibold.net>
         <240a7610-577a-8253-e880-b55182460c17@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Success, this will fix the regression. Thank you for the support and
merry christmas :-)

Am Donnerstag, den 19.12.2019, 17:24 -0500 schrieb Laura Abbott:
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
> > @@ -96,12 +96,14 @@ void snd_hdac_stream_start(struct hdac_stream
> > *azx_dev, bool fresh_start)
> >   			      1 << azx_dev->index,
> >   			      1 << azx_dev->index);
> >   	/* set stripe control */
> > -	if (azx_dev->substream)
> > -		stripe_ctl = snd_hdac_get_stream_stripe_ctl(bus,
> > azx_dev->substream);
> > -	else
> > -		stripe_ctl = 0;
> > -	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
> > -				stripe_ctl);
> > +	if (azx_dev->stripe) {
> > +		if (azx_dev->substream)
> > +			stripe_ctl =
> > snd_hdac_get_stream_stripe_ctl(bus, azx_dev->substream);
> > +		else
> > +			stripe_ctl = 0;
> > +		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B,
> > SD_CTL_STRIPE_MASK,
> > +					stripe_ctl);
> > +	}
> >   	/* set DMA start and interrupt mask */
> >   	snd_hdac_stream_updateb(azx_dev, SD_CTL,
> >   				0, SD_CTL_DMA_START | SD_INT_MASK);
> > @@ -118,7 +120,10 @@ void snd_hdac_stream_clear(struct hdac_stream
> > *azx_dev)
> >   	snd_hdac_stream_updateb(azx_dev, SD_CTL,
> >   				SD_CTL_DMA_START | SD_INT_MASK, 0);
> >   	snd_hdac_stream_writeb(azx_dev, SD_STS, SD_INT_MASK); /* to be
> > sure */
> > -	snd_hdac_stream_updateb(azx_dev, SD_CTL_3B, SD_CTL_STRIPE_MASK,
> > 0);
> > +	if (azx_dev->stripe) {
> > +		snd_hdac_stream_updateb(azx_dev, SD_CTL_3B,
> > SD_CTL_STRIPE_MASK, 0);
> > +		azx_dev->stripe = 0;
> > +	}
> >   	azx_dev->running = false;
> >   }
> >   EXPORT_SYMBOL_GPL(snd_hdac_stream_clear);
> > 
> > 
> > 
> 
> I think this is fixed by 6fd739c04ffd ("ALSA: hda: Fix regression by
> strip mask fix")
> This is already tagged for stable but it would be nice to pick it up
> sooner.
> 
> Thanks,
> Laura
> 


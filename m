Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB90151871
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBDKFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbgBDKFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 05:05:41 -0500
Received: from localhost (unknown [212.187.182.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB6921D7E;
        Tue,  4 Feb 2020 10:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580810741;
        bh=ydG7oHl6UEGUJ5PULCZPSOsM9FlmM3TxwNrJs/CzYIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u4Nq2APgyPAtxR9GfW2rgOgAgLWRzv/9dPZ9DN6ydK0YvYAqO7Xe3KBkDPPFIvlqg
         GbXfEgRS0xtTUPYVvarpKN5h9EVfztA4G9OZP+ExDnUZ9wgD6h6eJmlpARXKh100uI
         wvEaw75CZKv+zfNrnFnoJuD9MV1gYMPa3Yd7n0ak=
Date:   Tue, 4 Feb 2020 10:03:32 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 65/90] Input: aiptek - use descriptors of current
 altsetting
Message-ID: <20200204100332.GC1088789@kroah.com>
References: <20200203161917.612554987@linuxfoundation.org>
 <20200203161925.451117468@linuxfoundation.org>
 <20200204081155.GC26725@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204081155.GC26725@localhost>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 09:11:55AM +0100, Johan Hovold wrote:
> On Mon, Feb 03, 2020 at 04:20:08PM +0000, Greg Kroah-Hartman wrote:
> > From: Johan Hovold <johan@kernel.org>
> > 
> > [ Upstream commit cfa4f6a99fb183742cace65ec551b444852b8ef6 ]
> > 
> > Make sure to always use the descriptors of the current alternate setting
> > to avoid future issues when accessing fields that may differ between
> > settings.
> > 
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Acked-by: Vladis Dronov <vdronov@redhat.com>
> > Link: https://lore.kernel.org/r/20191210113737.4016-4-johan@kernel.org
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/input/tablet/aiptek.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
> > index 06d0ffef4a171..e08b0ef078e81 100644
> > --- a/drivers/input/tablet/aiptek.c
> > +++ b/drivers/input/tablet/aiptek.c
> > @@ -1713,7 +1713,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
> >  
> >  	aiptek->inputdev = inputdev;
> >  	aiptek->intf = intf;
> > -	aiptek->ifnum = intf->altsetting[0].desc.bInterfaceNumber;
> > +	aiptek->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
> >  	aiptek->inDelay = 0;
> >  	aiptek->endDelay = 0;
> >  	aiptek->previousJitterable = 0;
> 
> I asked Sasha to drop this one directly when he added it, so it's
> probable gone from all the stable queues by now.

Oops, no, let me go drop it.

> But I'm still curious how this ended up being selected for stable in the
> first place? There's no fixes or stable tag in the commit, and I never
> received a mail from the AUTOSEL scripts.

I don't know, there was a bunch of last-minute patches picked up for
this round based on some "fixes needed due to other fixes".

thanks,

greg k-h

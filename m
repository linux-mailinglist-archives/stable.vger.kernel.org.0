Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1321518AF
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 11:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgBDKSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 05:18:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44180 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgBDKSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 05:18:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so17936465ljj.11;
        Tue, 04 Feb 2020 02:18:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QA9HPiPbuM4UHxdBV/KaiKxSA4ykX+SAvXggwSMLDg8=;
        b=T49sjA7IVhZ3+uGbC4aY2XHFnljFEoda1YYVxJpyq3azzzI5AOpeQf4V4JsoS3IGld
         +UFY377gBpSagUeBE52PqJ13f55YLe83z0Nmb407SITR/YTIh9Nlxc1nY57XhSHjOehW
         fH5wsTi1rS2HRHi6IyaHSzFRfmstuNgZxUTLuoigOgZHtZl+QXqdLFxvGa76BBT9OreA
         U4lVedr7t0cn5HjtziNMwW/AT3m8WFdS7D5lodHlMAnYmYrr4QTAqKiUDVPjrJq7qTXH
         JxrKmcagzQsAhLaXpxswhXsb10bxUMiqpHi4JCG4ahQ29nHvcuXW22MM9nw/NdgE8YhV
         Fakw==
X-Gm-Message-State: APjAAAUcvBu770u80BbNEbz4sYyweepwqckO3Nfon81Sq0CssFaZW2gl
        6WNLDbstQU2hFNXhaMU/HNI=
X-Google-Smtp-Source: APXvYqyztY+5ijDrHtyvYSbwGDigg67WKXUahFCofHM0sleA0A6OTiQlMXGjH1SAiWMBH3WZwdoaqA==
X-Received: by 2002:a2e:a491:: with SMTP id h17mr16898840lji.101.1580811527179;
        Tue, 04 Feb 2020 02:18:47 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id d22sm10250256lfi.49.2020.02.04.02.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 02:18:46 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iyvIF-0003Yx-MZ; Tue, 04 Feb 2020 11:18:55 +0100
Date:   Tue, 4 Feb 2020 11:18:55 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 65/90] Input: aiptek - use descriptors of current
 altsetting
Message-ID: <20200204101855.GI26725@localhost>
References: <20200203161917.612554987@linuxfoundation.org>
 <20200203161925.451117468@linuxfoundation.org>
 <20200204081155.GC26725@localhost>
 <20200204100332.GC1088789@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204100332.GC1088789@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 10:03:32AM +0000, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2020 at 09:11:55AM +0100, Johan Hovold wrote:
> > On Mon, Feb 03, 2020 at 04:20:08PM +0000, Greg Kroah-Hartman wrote:
> > > From: Johan Hovold <johan@kernel.org>
> > > 
> > > [ Upstream commit cfa4f6a99fb183742cace65ec551b444852b8ef6 ]
> > > 
> > > Make sure to always use the descriptors of the current alternate setting
> > > to avoid future issues when accessing fields that may differ between
> > > settings.
> > > 
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > Acked-by: Vladis Dronov <vdronov@redhat.com>
> > > Link: https://lore.kernel.org/r/20191210113737.4016-4-johan@kernel.org
> > > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/input/tablet/aiptek.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
> > > index 06d0ffef4a171..e08b0ef078e81 100644
> > > --- a/drivers/input/tablet/aiptek.c
> > > +++ b/drivers/input/tablet/aiptek.c
> > > @@ -1713,7 +1713,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
> > >  
> > >  	aiptek->inputdev = inputdev;
> > >  	aiptek->intf = intf;
> > > -	aiptek->ifnum = intf->altsetting[0].desc.bInterfaceNumber;
> > > +	aiptek->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
> > >  	aiptek->inDelay = 0;
> > >  	aiptek->endDelay = 0;
> > >  	aiptek->previousJitterable = 0;
> > 
> > I asked Sasha to drop this one directly when he added it, so it's
> > probable gone from all the stable queues by now.
> 
> Oops, no, let me go drop it.
> 
> > But I'm still curious how this ended up being selected for stable in the
> > first place? There's no fixes or stable tag in the commit, and I never
> > received a mail from the AUTOSEL scripts.
> 
> I don't know, there was a bunch of last-minute patches picked up for
> this round based on some "fixes needed due to other fixes".

Ah, yeah, could be dependencies otherwise, but then you usually send a
notice about that. And in this case this is the last commit to this
particular driver in Linus's tree too.

Johan

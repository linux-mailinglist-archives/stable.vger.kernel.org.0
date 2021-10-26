Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C6A43B1E7
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 14:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhJZMJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 08:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233838AbhJZMJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 08:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E88960E05;
        Tue, 26 Oct 2021 12:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635250032;
        bh=5UPpA3J3tlAokOz6B34fDtDFsO0+mmeco3ZVTn3rKOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6mfWS66LrSGEjYVEif3tz+5FEp0/Y3oKJopxn5uS7/SH0k5SnfJSm04RJOEOk8fk
         6KG6qPkzoRcF6JCwd0M0mrp1YSs0QAuqBR6B0X/OpeyT07njShauhD7ocDmpw55O+5
         IErBq4AFG+C64i9xRDN9ODPUbT+vUFUMsYewbLxAqcVfyYP5PgGZ70aLXonTCxzvHd
         KdLmjZ6I/DW2tnrtkxSWWz/jTUFybwj9xTQllfW9fgOq9t3/TKnsiO8AY8F47nc70W
         /fht8AbY0nwFBhP1mHY00++qb5bOw22i43yAshblzPShk4vKirskrb6nac9PB0poBS
         g4IBREQ0dIq+A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfLEF-0001fI-Ns; Tue, 26 Oct 2021 14:06:56 +0200
Date:   Tue, 26 Oct 2021 14:06:55 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
 <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 02:15:20PM +0300, Laurent Pinchart wrote:
> On Tue, Oct 26, 2021 at 11:55:05AM +0100, Kieran Bingham wrote:
> > Quoting Johan Hovold (2021-10-26 10:55:11)
> > > Add the missing bulk-endpoint max-packet sanity check to probe() to
> > > avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
> > > device has broken descriptors (or when doing descriptor fuzz testing).
> > > 
> > > Note that USB core will reject URBs submitted for endpoints with zero
> > > wMaxPacketSize but that drivers doing packet-size calculations still
> > > need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> > > endpoint descriptors with maxpacket=0")).
> > > 
> > > Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> > > Cc: stable@vger.kernel.org      # 2.6.26
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >  drivers/media/usb/uvc/uvc_video.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > > index e16464606b14..85ac5c1081b6 100644
> > > --- a/drivers/media/usb/uvc/uvc_video.c
> > > +++ b/drivers/media/usb/uvc/uvc_video.c
> > > @@ -1958,6 +1958,10 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
> > >                 if (ep == NULL)
> > >                         return -EIO;
> > >  
> > > +               /* Reject broken descriptors. */
> > > +               if (usb_endpoint_maxp(&ep->desc) == 0)
> > > +                       return -EIO;
> > 
> > Is there any value in identifying this with a specific return code like
> > -ENODATA?
> 
> Going one step further, wouldn't it be better to fail probe() for those
> devices ?

This is not how the driver works today. Look at the "return -EIO" just
above in case the expected endpoint is missing. And similarly for the
isochronous case for which zero wMaxPacket isn't handled until
uvc_video_start_transfer() either (a few lines further up still).

Note however the copy-paste error in the commit message mentioning
probe(), which is indeed where this would typically be handled.

Do you want me to resend or can you change

	s/probe()/uvc_video_start_transfer()/

in the commit message when applying if you think this is acceptable as
is?

Johan

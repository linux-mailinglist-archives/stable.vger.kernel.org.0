Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CD543BCAF
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 23:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbhJZVxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 17:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239706AbhJZVxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 17:53:37 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBEC061570;
        Tue, 26 Oct 2021 14:51:13 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1471D3F0;
        Tue, 26 Oct 2021 23:51:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1635285070;
        bh=nrejLrqebeFZ6uqJmuowbCLTFPqWxMstNwb5FIhCx34=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EYZYX0JpMoyFYiT1HGuTbclLHei5CLtJvu+pPeBso7QBvg52Kki5PJS3AGSeMUM3g
         kpWkj/vXoHupgmOJxoiLVGOab2Pi6B+UpChcmmBz7pMmdYpqyDYhaU/FbH4aAZr2Aq
         LecS/ATO3DGeqbelKaqMNS+YPpCFdWwUo7cLmEpI=
Date:   Wed, 27 Oct 2021 00:50:46 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
 <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
 <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On Tue, Oct 26, 2021 at 02:06:55PM +0200, Johan Hovold wrote:
> On Tue, Oct 26, 2021 at 02:15:20PM +0300, Laurent Pinchart wrote:
> > On Tue, Oct 26, 2021 at 11:55:05AM +0100, Kieran Bingham wrote:
> > > Quoting Johan Hovold (2021-10-26 10:55:11)
> > > > Add the missing bulk-endpoint max-packet sanity check to probe() to
> > > > avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
> > > > device has broken descriptors (or when doing descriptor fuzz testing).
> > > > 
> > > > Note that USB core will reject URBs submitted for endpoints with zero
> > > > wMaxPacketSize but that drivers doing packet-size calculations still
> > > > need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> > > > endpoint descriptors with maxpacket=0")).
> > > > 
> > > > Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> > > > Cc: stable@vger.kernel.org      # 2.6.26
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > ---
> > > >  drivers/media/usb/uvc/uvc_video.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > > > index e16464606b14..85ac5c1081b6 100644
> > > > --- a/drivers/media/usb/uvc/uvc_video.c
> > > > +++ b/drivers/media/usb/uvc/uvc_video.c
> > > > @@ -1958,6 +1958,10 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
> > > >                 if (ep == NULL)
> > > >                         return -EIO;
> > > >  
> > > > +               /* Reject broken descriptors. */
> > > > +               if (usb_endpoint_maxp(&ep->desc) == 0)
> > > > +                       return -EIO;
> > > 
> > > Is there any value in identifying this with a specific return code like
> > > -ENODATA?
> > 
> > Going one step further, wouldn't it be better to fail probe() for those
> > devices ?
> 
> This is not how the driver works today. Look at the "return -EIO" just
> above in case the expected endpoint is missing. And similarly for the
> isochronous case for which zero wMaxPacket isn't handled until
> uvc_video_start_transfer() either (a few lines further up still).

That's a good point, it wouldn't be reasonable to ask you to fix all
that :-)

> Note however the copy-paste error in the commit message mentioning
> probe(), which is indeed where this would typically be handled.
> 
> Do you want me to resend or can you change
> 
> 	s/probe()/uvc_video_start_transfer()/
> 
> in the commit message when applying if you think this is acceptable as
> is?

I can fix this when applying.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

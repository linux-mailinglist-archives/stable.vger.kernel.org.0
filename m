Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC3243B0D7
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 13:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhJZLSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 07:18:09 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:45352 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhJZLSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 07:18:08 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 196243F0;
        Tue, 26 Oct 2021 13:15:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1635246943;
        bh=WxA0PSLaqHfqEyChJwTJYKvReBL3f+/2oUC5lcN5GHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ucXfWtQUi5q+VLNAVYwATavzowlEIhtqsygINS7W+DRWUsI8RE+sb1aFgq93u2VPB
         K73haXlDyxHFXzDYcf17TUahjEZJIeQHvIDlEkKudUF2cnNgqRlPOdRyw/QbhtybJ7
         zcEFCevaqgsHsVyJhEZLuT/qO8QCC5/LeGb6ZADk=
Date:   Tue, 26 Oct 2021 14:15:20 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <163524570516.1184428.14632987312253060787@Monstersaurus>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 11:55:05AM +0100, Kieran Bingham wrote:
> Quoting Johan Hovold (2021-10-26 10:55:11)
> > Add the missing bulk-endpoint max-packet sanity check to probe() to
> > avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
> > device has broken descriptors (or when doing descriptor fuzz testing).
> > 
> > Note that USB core will reject URBs submitted for endpoints with zero
> > wMaxPacketSize but that drivers doing packet-size calculations still
> > need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> > endpoint descriptors with maxpacket=0")).
> > 
> > Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> > Cc: stable@vger.kernel.org      # 2.6.26
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> > index e16464606b14..85ac5c1081b6 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1958,6 +1958,10 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
> >                 if (ep == NULL)
> >                         return -EIO;
> >  
> > +               /* Reject broken descriptors. */
> > +               if (usb_endpoint_maxp(&ep->desc) == 0)
> > +                       return -EIO;
> 
> Is there any value in identifying this with a specific return code like
> -ENODATA?

Going one step further, wouldn't it be better to fail probe() for those
devices ?

> But either way, this seems sane.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > +
> >                 ret = uvc_init_video_bulk(stream, ep, gfp_flags);
> >         }
> >  

-- 
Regards,

Laurent Pinchart

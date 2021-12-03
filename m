Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A544D4675A1
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 11:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbhLCK4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 05:56:11 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:50412 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbhLCK4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 05:56:11 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 57C0BA59;
        Fri,  3 Dec 2021 11:52:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1638528766;
        bh=gRR+IXbjrfOBB7AE2iBz2rWScEFKRnf1B2FF0CZ3jz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lVpTe4zmfbQeDpw/iGDaz0nqxUXzeXqg0eUa7f8wLC7QICzSJ65HX2d8ydxArxgy0
         1nrAae1QlZniNTLmC8SV641Jim5ntea1t4OiwhXkjoNkUpxqh9KGP5uIP7DV7ALEqy
         AM7ad6b87KmRDprxBaTgWVGPyhzLTDnK3FFC5tRs=
Date:   Fri, 3 Dec 2021 12:52:19 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: uvcvideo: fix division by zero at stream start
Message-ID: <Yan241Kg7O+qgQXG@pendragon.ideasonboard.com>
References: <20211026095511.26673-1-johan@kernel.org>
 <163524570516.1184428.14632987312253060787@Monstersaurus>
 <YXfjSJ+fm+LV/m+M@pendragon.ideasonboard.com>
 <YXfvXzgnvPVqwqZs@hovoldconsulting.com>
 <YXh4NqnpzOnPiA5/@pendragon.ideasonboard.com>
 <Yanxc/229JFkuP/v@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yanxc/229JFkuP/v@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On Fri, Dec 03, 2021 at 11:29:07AM +0100, Johan Hovold wrote:
> On Wed, Oct 27, 2021 at 12:50:46AM +0300, Laurent Pinchart wrote:
> > On Tue, Oct 26, 2021 at 02:06:55PM +0200, Johan Hovold wrote:
> > > On Tue, Oct 26, 2021 at 02:15:20PM +0300, Laurent Pinchart wrote:
> > > > On Tue, Oct 26, 2021 at 11:55:05AM +0100, Kieran Bingham wrote:
> > > > > Quoting Johan Hovold (2021-10-26 10:55:11)
> > > > > > Add the missing bulk-endpoint max-packet sanity check to probe() to
> > > > > > avoid division by zero in uvc_alloc_urb_buffers() in case a malicious
> > > > > > device has broken descriptors (or when doing descriptor fuzz testing).
> > > > > > 
> > > > > > Note that USB core will reject URBs submitted for endpoints with zero
> > > > > > wMaxPacketSize but that drivers doing packet-size calculations still
> > > > > > need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> > > > > > endpoint descriptors with maxpacket=0")).
> > > > > > 
> > > > > > Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
> > > > > > Cc: stable@vger.kernel.org      # 2.6.26
> > > > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > >
> > > Note however the copy-paste error in the commit message mentioning
> > > probe(), which is indeed where this would typically be handled.
> > > 
> > > Do you want me to resend or can you change
> > > 
> > > 	s/probe()/uvc_video_start_transfer()/
> > > 
> > > in the commit message when applying if you think this is acceptable as
> > > is?
> > 
> > I can fix this when applying.
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I noticed that this one hasn't showed up in linux-next yet. Do you still
> have it in your queue or do you want me to resend?

It should be in Mauro's queue now:

https://lore.kernel.org/all/YacOun3Diggsi05V@pendragon.ideasonboard.com/

-- 
Regards,

Laurent Pinchart

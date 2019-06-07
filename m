Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD4138F2D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfFGPfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbfFGPfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:35:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D18208C3;
        Fri,  7 Jun 2019 15:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921701;
        bh=r5Q15giHbJbeP/94KegRcAhcakgqDxX289S/PXN3R4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZJC29pNH6j1Ab7ehG9Ua7ksRuD5Qu+n/w83RxuP81Q2j8vAcztoY3iiPx5nOV03fq
         zNQK/55DC4yOnLjdnWgiGzc+XqisJojxk0yxbb82sasJDiyZkPrGWVxr/24Dw3ve4x
         GNsyn2xX6tBToLnR7J7BMSrZcsCHa83DY8avqJHI=
Date:   Fri, 7 Jun 2019 17:34:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Nadav Amit <namit@vmware.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Tomasz Figa <tfiga@chromium.org>,
        Guenter Roeck <groeck@chromium.org>
Subject: Re: [PATCH 3.16 025/305] media: uvcvideo: Fix uvc_alloc_entity()
 allocation alignment
Message-ID: <20190607153458.GA23803@kroah.com>
References: <lsq.1549201507.384106140@decadent.org.uk>
 <lsq.1549201508.623062416@decadent.org.uk>
 <CAD=FV=U263K-OEdnDzL=4oxLHXTkqgQygYCup=jSCRGvv+vMsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=U263K-OEdnDzL=4oxLHXTkqgQygYCup=jSCRGvv+vMsw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 08:09:27AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Sun, Feb 3, 2019 at 5:50 AM Ben Hutchings <ben@decadent.org.uk> wrote:
> >
> > 3.16.63-rc1 review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Nadav Amit <namit@vmware.com>
> >
> > commit 89dd34caf73e28018c58cd193751e41b1f8bdc56 upstream.
> >
> > The use of ALIGN() in uvc_alloc_entity() is incorrect, since the size of
> > (entity->pads) is not a power of two. As a stop-gap, until a better
> > solution is adapted, use roundup() instead.
> >
> > Found by a static assertion. Compile-tested only.
> >
> > Fixes: 4ffc2d89f38a ("uvcvideo: Register subdevices for each entity")
> >
> > Signed-off-by: Nadav Amit <namit@vmware.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> >  drivers/media/usb/uvc/uvc_driver.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -826,7 +826,7 @@ static struct uvc_entity *uvc_alloc_enti
> >         unsigned int size;
> >         unsigned int i;
> >
> > -       extra_size = ALIGN(extra_size, sizeof(*entity->pads));
> > +       extra_size = roundup(extra_size, sizeof(*entity->pads));
> >         num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
> >         size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
> >              + num_inputs;
> 
> Funny that this commit made its way to 3.16 but didn't make its way to
> 4.19 (at least checking 4.19.43).  I haven't seen any actual crashes
> caused by the lack of this commit but it seems like the kind of thing
> we probably want picked back to other stable kernels too.

Good idea, now queued up.

greg k-h

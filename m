Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D325A6E9
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 09:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgIBHjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 03:39:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBHjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 03:39:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7902207EA;
        Wed,  2 Sep 2020 07:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599032371;
        bh=V95cSOGyyG0x3a+6A3hgMX0ZEOTzZ4PFNGdkXzgCVFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bqGauJGvCpJ/DEnGL/p3rcUDwJwGtVr2IWlePg+u6ih/X6xR4iYh6U/9LtrNiRaXe
         9QBLYVFuh9iXdC4LNF4G9t45O4xX3lFjOL0Usby9LQWRuYNu633+CDKFAb3vJP40o2
         Ysps5jM3JzlA6WqFnH8XGKHhYsZpLPe8pBC9wZW0=
Date:   Wed, 2 Sep 2020 09:39:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 047/125] media: davinci: vpif_capture: fix potential
 double free
Message-ID: <20200902073956.GF1610179@kroah.com>
References: <20200901150934.576210879@linuxfoundation.org>
 <20200901150936.857115610@linuxfoundation.org>
 <20200901183912.GA5295@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901183912.GA5295@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 08:42:58PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 602649eadaa0c977e362e641f51ec306bc1d365d ]
> > 
> > In case of errors vpif_probe_complete() releases memory for vpif_obj.sd
> > and unregisters the V4L2 device. But then this is done again by
> > vpif_probe() itself. The patch removes the cleaning from
> > vpif_probe_complete().
> 
> > Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/media/platform/davinci/vpif_capture.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> > index a96f53ce80886..cf1d11e6dd8c4 100644
> > --- a/drivers/media/platform/davinci/vpif_capture.c
> > +++ b/drivers/media/platform/davinci/vpif_capture.c
> > @@ -1489,8 +1489,6 @@ probe_out:
> >  		/* Unregister video device */
> >  		video_unregister_device(&ch->video_dev);
> >  	}
> > -	kfree(vpif_obj.sd);
> > -	v4l2_device_unregister(&vpif_obj.v4l2_dev);
> >  
> >  	return err;
> >  }
> 
> This one is wrong. Unlike mainline, 4.19 does check return value of
> vpif_probe_complete(), and thus it will lead to memory leak in 4.19.

Thanks, now dropped.

greg k-h

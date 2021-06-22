Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAB43B0142
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 12:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFVKZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 06:25:05 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:40082 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhFVKZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 06:25:03 -0400
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D4C0FA66;
        Tue, 22 Jun 2021 12:22:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1624357367;
        bh=EiLfqJLjNI4MHuc9zgewmgiTpuQYcWHw5T68hl/HWVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chBgc8qQsksQ1od6jgbTJFx/5L0P0vg+ByH9nNoJxeIdKB1ODS8gu3yx1Ta7bunK5
         M4tawS3vutqw2RXRdyWIlvBJFvKk+p5dFM8wbuprf70LheLq07ly6zGYeYSG4TQAe2
         EO4JJdoaUgHUC/W/yXvqTrV8lydsvRBCIcjqnmHk=
Date:   Tue, 22 Jun 2021 13:22:18 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] media: uvc: don't do DMA on stack
Message-ID: <YNG52qDyIo3Md/xz@pendragon.ideasonboard.com>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
 <YNCeIvQJIOCm8g+P@pendragon.ideasonboard.com>
 <20210621163408.7c9705aa@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210621163408.7c9705aa@coco.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mauro,

On Mon, Jun 21, 2021 at 04:34:08PM +0200, Mauro Carvalho Chehab wrote:
> Em Mon, 21 Jun 2021 17:11:46 +0300 Laurent Pinchart escreveu:
> > On Mon, Jun 21, 2021 at 03:40:19PM +0200, Mauro Carvalho Chehab wrote:
> > > As warned by smatch:
> > > 	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
> > > 	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)
> > > 
> > > those two functions call uvc_query_ctrl passing a pointer to
> > > a data at the DMA stack. those are used to send URBs via
> > > usb_control_msg(). Using DMA stack is not supported and should
> > > not work anymore on modern Linux versions.
> > > 
> > > So, use a kmalloc'ed buffer.
> > > 
> > > Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > > ---
> > >  drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++--------
> > >  1 file changed, 22 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> > > index 252136cc885c..a95bf7318848 100644
> > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > > @@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
> > >  {
> > >  	struct uvc_fh *handle = fh;
> > >  	struct uvc_video_chain *chain = handle->chain;
> > > +	u8 *buf;
> > >  	int ret;
> > > -	u8 i;
> > >  
> > >  	if (chain->selector == NULL ||
> > >  	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
> > > @@ -908,13 +908,20 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
> > >  		return 0;
> > >  	}
> > >  
> > > +	buf = kmalloc(1, GFP_KERNEL);
> > > +	if (!buf)
> > > +		return -ENOMEM;
> > > +
> > >  	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
> > >  			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
> > > -			     &i, 1);
> > > +			     buf, 1);
> > >  	if (ret < 0)
> > >  		return ret;  
> > 
> > Memory leak :-)
> 
> Argh ;-)
> 
> Clearly, I'm needing more caffeine today, but it is too damn hot
> here...
> 
> > 
> > 	if (!ret)
> > 		*input = *buf - 1;
> > 
> > 	kfree(buf);
> > 
> > 	return ret;
> > 
> > >  
> > > -	*input = i - 1;
> > > +	*input = *buf - 1;
> > > +
> > > +	kfree(buf);
> > > +
> > >  	return 0;
> > >  }
> > >  
> > > @@ -922,8 +929,8 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
> > >  {
> > >  	struct uvc_fh *handle = fh;
> > >  	struct uvc_video_chain *chain = handle->chain;
> > > +	char *buf;  
> > 
> > 	u8 *buf;
> > 
> > With these two changes,
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Thanks!
> 
> > Do I need to take the patch in my tree ?
> 
> It is up to you.
> 
> I suspect that it would be easier to just merge it at media_stage,
> together with the other patches from the smatch series, but it is
> up to you.
> 
> Just let me know if you prefer to merge it via your tree, and I'll drop
> it from my queue, or otherwise I'll merge directly at media_stage,
> after waiting for a while on feedbacks on the remaining patches.

Please merge it directly, it's less work for me :-)

-- 
Regards,

Laurent Pinchart

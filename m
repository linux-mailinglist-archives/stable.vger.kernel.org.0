Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E7A3AEB6D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFUOg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 10:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhFUOg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 10:36:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E8FF61156;
        Mon, 21 Jun 2021 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624286053;
        bh=1vK4PgLlKnKBTI0SKfA81lZ6oF+ZmIp6CAkgOSLx/0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PARjnRxi8nYtLY+3exj4TTmX+mteXjW5ltnlBH6H08rqeJJYnaa0ULBZkElSppGy0
         FurR31ilvog5WnMPkn0jAZbLWOYGS9hsYEA8vVNDZf5WXZ+jqAF6AKrE2j3WfB8uYB
         wowjYQsBV7ndFVi+fqUOdJjfp3a1QfcvdwUSlfr2duZXSBnEBEBqpl09P9Rqq6IYqe
         S6vsdtAxo0XoYdLevqir6sMl8q3bKXvqyZeEFmjbndnvlYQB6tZAiXop+tBC6Dv+e4
         M3C8sWTJODzEj/1VhrPo4SL3ZMEASBbkfBswzSza5K0TOOhrGBdzq73OhKPg+Pp31h
         GuuJv8mhlDiuA==
Date:   Mon, 21 Jun 2021 16:34:08 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] media: uvc: don't do DMA on stack
Message-ID: <20210621163408.7c9705aa@coco.lan>
In-Reply-To: <YNCeIvQJIOCm8g+P@pendragon.ideasonboard.com>
References: <6832dffafd54a6a95b287c4a1ef30250d6b9237a.1624282817.git.mchehab+huawei@kernel.org>
        <YNCeIvQJIOCm8g+P@pendragon.ideasonboard.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Mon, 21 Jun 2021 17:11:46 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Mon, Jun 21, 2021 at 03:40:19PM +0200, Mauro Carvalho Chehab wrote:
> > As warned by smatch:
> > 	drivers/media/usb/uvc/uvc_v4l2.c:911 uvc_ioctl_g_input() error: doing dma on the stack (&i)
> > 	drivers/media/usb/uvc/uvc_v4l2.c:943 uvc_ioctl_s_input() error: doing dma on the stack (&i)
> > 
> > those two functions call uvc_query_ctrl passing a pointer to
> > a data at the DMA stack. those are used to send URBs via
> > usb_control_msg(). Using DMA stack is not supported and should
> > not work anymore on modern Linux versions.
> > 
> > So, use a kmalloc'ed buffer.
> > 
> > Cc: stable@vger.kernel.org	# Kernel 4.9 and upper
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >  drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++--------
> >  1 file changed, 22 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
> > index 252136cc885c..a95bf7318848 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -899,8 +899,8 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
> >  {
> >  	struct uvc_fh *handle = fh;
> >  	struct uvc_video_chain *chain = handle->chain;
> > +	u8 *buf;
> >  	int ret;
> > -	u8 i;
> >  
> >  	if (chain->selector == NULL ||
> >  	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
> > @@ -908,13 +908,20 @@ static int uvc_ioctl_g_input(struct file *file, void *fh, unsigned int *input)
> >  		return 0;
> >  	}
> >  
> > +	buf = kmalloc(1, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> >  	ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR, chain->selector->id,
> >  			     chain->dev->intfnum,  UVC_SU_INPUT_SELECT_CONTROL,
> > -			     &i, 1);
> > +			     buf, 1);
> >  	if (ret < 0)
> >  		return ret;  
> 
> Memory leak :-)

Argh ;-)

Clearly, I'm needing more caffeine today, but it is too damn hot
here...

> 
> 	if (!ret)
> 		*input = *buf - 1;
> 
> 	kfree(buf);
> 
> 	return ret;
> 
> >  
> > -	*input = i - 1;
> > +	*input = *buf - 1;
> > +
> > +	kfree(buf);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -922,8 +929,8 @@ static int uvc_ioctl_s_input(struct file *file, void *fh, unsigned int input)
> >  {
> >  	struct uvc_fh *handle = fh;
> >  	struct uvc_video_chain *chain = handle->chain;
> > +	char *buf;  
> 
> 	u8 *buf;
> 
> With these two changes,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

> Do I need to take the patch in my tree ?

It is up to you.

I suspect that it would be easier to just merge it at media_stage,
together with the other patches from the smatch series, but it is
up to you.

Just let me know if you prefer to merge it via your tree, and I'll drop
it from my queue, or otherwise I'll merge directly at media_stage,
after waiting for a while on feedbacks on the remaining patches.

Thanks,
Mauro

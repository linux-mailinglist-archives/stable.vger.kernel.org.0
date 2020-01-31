Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8AF14EFF5
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 16:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgAaPm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 10:42:59 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57724 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgAaPm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 10:42:59 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id F201A29567B
Message-ID: <262a2c7a1ad470f8d386bb26da2258608c49f9a7.camel@collabora.com>
Subject: Re: [PATCH v3] media: v4l2-core: fix a use-after-free bug of
 sd->devnode
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        linux-media@vger.kernel.org
Cc:     dafna3@gmail.com, helen.koike@collabora.com, stable@vger.kernel.org
Date:   Fri, 31 Jan 2020 12:42:51 -0300
In-Reply-To: <fe36e4a9-2369-3150-b823-97fb4bf1afe4@xs4all.nl>
References: <20191120122217.845-1-dafna.hirschfeld@collabora.com>
         <fe36e4a9-2369-3150-b823-97fb4bf1afe4@xs4all.nl>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-01-16 at 12:57 +0100, Hans Verkuil wrote:
> On 11/20/19 1:22 PM, Dafna Hirschfeld wrote:
> > sd->devnode is released after calling
> > v4l2_subdev_release. Therefore it should be set
> > to NULL so that the subdev won't hold a pointer
> > to a released object. This fixes a reference
> > after free bug in function
> > v4l2_device_unregister_subdev
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")
> > Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
> > Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> > changes since v2:
> > - since this is a regresion fix, I added Fixes and Cc to stable tags,
> > - change the commit title and log to be more clear.
> > 
> >  drivers/media/v4l2-core/v4l2-device.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> > index 63d6b147b21e..2b3595671d62 100644
> > --- a/drivers/media/v4l2-core/v4l2-device.c
> > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > @@ -177,6 +177,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
> >  {
> >  	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
> >  
> > +	sd->devnode = NULL;
> >  	if (sd->internal_ops && sd->internal_ops->release)
> >  		sd->internal_ops->release(sd);
> 
> I'd move the sd->devnode = NULL; line here. That way the
> sd->internal_ops->release(sd) callback can still use it.
> 

Hi everyone,

Please note this fix is useful to fix a kernel oops
when rkisp1 driver is removed.

Can we get a v4 addressing Hans' feedback?

Thanks,
Ezequiel

> Unless I am missing something?
> 
> >  	module_put(owner);
> > 
> 
> Regards,
> 
> 	Hans



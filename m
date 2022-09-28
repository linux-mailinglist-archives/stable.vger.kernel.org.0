Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA97D5EE695
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 22:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiI1UWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 16:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiI1UWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 16:22:10 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D0A74DFD;
        Wed, 28 Sep 2022 13:22:01 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 433796BE;
        Wed, 28 Sep 2022 22:21:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1664396518;
        bh=ZVnn371ol3lmPTrCOy0R2eVwN8pZhNwjNTXUvUfoQqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O9cJMKfab+8Wu7hvOGEeJzXmby9I9rmPYVjTCDIut4xl2qcGwcltJAeye5Vc0ZNXV
         7oTexktRi/HHJVw0MJ+K2+aqBhXuXl8Icia68vemMqeYHEy5jQEz2ZqYO2WjZBEhrS
         dnSFiRMWDucfJyWIt8uYq0sVrl2tD8PVzi1Xm8LU=
Date:   Wed, 28 Sep 2022 23:21:56 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: uvc: Fix argument to sizeof() in
 uvc_register_video()
Message-ID: <YzSs5HVeBZUI6E+b@pendragon.ideasonboard.com>
References: <20220928201921.3152163-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220928201921.3152163-1-nathan@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nathan,

Thank you for the patch.

On Wed, Sep 28, 2022 at 01:19:21PM -0700, Nathan Chancellor wrote:
> When building s390 allmodconfig after commit 9b91a6523078 ("usb: gadget:
> uvc: increase worker prio to WQ_HIGHPRI"), the following error occurs:
> 
>   In file included from ../include/linux/string.h:253,
>                    from ../include/linux/bitmap.h:11,
>                    from ../include/linux/cpumask.h:12,
>                    from ../include/linux/smp.h:13,
>                    from ../include/linux/lockdep.h:14,
>                    from ../include/linux/rcupdate.h:29,
>                    from ../include/linux/rculist.h:11,
>                    from ../include/linux/pid.h:5,
>                    from ../include/linux/sched.h:14,
>                    from ../include/linux/ratelimit.h:6,
>                    from ../include/linux/dev_printk.h:16,
>                    from ../include/linux/device.h:15,
>                    from ../drivers/usb/gadget/function/f_uvc.c:9:
>   In function ‘fortify_memset_chk’,
>       inlined from ‘uvc_register_video’ at ../drivers/usb/gadget/function/f_uvc.c:424:2:
>   ../include/linux/fortify-string.h:301:25: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>     301 |                         __write_overflow_field(p_size_field, size);
>         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This points to the memset() in uvc_register_video(). It is clear that
> the argument to sizeof() is incorrect, as uvc->vdev (a 'struct
> video_device') is being zeroed out but the size of uvc->video (a 'struct
> uvc_video') is being used as the third arugment to memset().
> 
> pahole shows that prior to commit 9b91a6523078 ("usb: gadget: uvc:
> increase worker prio to WQ_HIGHPRI"), 'struct video_device' and
> 'struct ucv_video' had the same size, meaning that the argument to
> sizeof() is incorrect semantically but there is no visible issue:
> 
>   $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
>   video_device    1400    4
>   uvc_video       1400    3
> 
> After that change, uvc_video becomes slightly larger, meaning that the
> memset() will overwrite by 8 bytes:
> 
>   $ pahole -s build/drivers/usb/gadget/function/f_uvc.o | grep -E "(uvc_video|video_device)\s+"
>   video_device    1400    4
>   uvc_video       1408    3
> 
> Fix the arugment to sizeof() so that there is no overwrite.
> 
> Cc: stable@vger.kernel.org
> Fixes: e4ce9ed835bc ("usb: gadget: uvc: ensure the vdev is unset")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Good catch.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/usb/gadget/function/f_uvc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
> index 71669e0e4d00..86bb0098fb66 100644
> --- a/drivers/usb/gadget/function/f_uvc.c
> +++ b/drivers/usb/gadget/function/f_uvc.c
> @@ -421,7 +421,7 @@ uvc_register_video(struct uvc_device *uvc)
>  	int ret;
>  
>  	/* TODO reference counting. */
> -	memset(&uvc->vdev, 0, sizeof(uvc->video));
> +	memset(&uvc->vdev, 0, sizeof(uvc->vdev));
>  	uvc->vdev.v4l2_dev = &uvc->v4l2_dev;
>  	uvc->vdev.v4l2_dev->dev = &cdev->gadget->dev;
>  	uvc->vdev.fops = &uvc_v4l2_fops;
> 
> base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff

-- 
Regards,

Laurent Pinchart

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45031184627
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 12:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCMLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 07:45:46 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:47300 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMLpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 07:45:46 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 71C165F;
        Fri, 13 Mar 2020 12:45:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1584099944;
        bh=P5B3Oa6NlauVXZmtjyeovSV12joG3gvC2PmEu8TtQG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BEvvNc3TzPs6/xKADbS1BO2tulqCyaW67V5I6JkV6zuF9rCpAwoXzNMtdRi0QLkcU
         FN4O1PghsEW6DNnHu4/XLO39H8DVVIUPTjKx+M558XkW5gmIFXsrUs79NoBtJzBXsf
         avPAzevn4So3rKC8PrVPvqfFhEnWLK3Hv692SfWs=
Date:   Fri, 13 Mar 2020 13:45:40 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] media: ov5640: fix use of destroyed mutex
Message-ID: <20200313114540.GA4751@pendragon.ideasonboard.com>
References: <20200313082258.6930-1-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200313082258.6930-1-tomi.valkeinen@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi,

Thank you for the patch.

On Fri, Mar 13, 2020 at 10:22:58AM +0200, Tomi Valkeinen wrote:
> v4l2_ctrl_handler_free() uses hdl->lock, which in ov5640 driver is set
> to sensor's own sensor->lock. In ov5640_remove(), the driver destroys the
> sensor->lock first, and then calls v4l2_ctrl_handler_free(), resulting
> in the use of the destroyed mutex.
> 
> Fix this by calling v4l2_ctrl_handler_free() before mutex_destroy().
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/i2c/ov5640.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 854031f0b64a..64511de4eea8 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -3104,9 +3104,9 @@ static int ov5640_remove(struct i2c_client *client)
>  	struct ov5640_dev *sensor = to_ov5640_dev(sd);
>  
>  	v4l2_async_unregister_subdev(&sensor->sd);
> +	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
>  	mutex_destroy(&sensor->lock);
>  	media_entity_cleanup(&sensor->sd.entity);
> -	v4l2_ctrl_handler_free(&sensor->ctrls.handler);

While at it, could you move the mutex after media_entity_cleanup() too,
to avoid future problems in case it gets used through that path ?

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

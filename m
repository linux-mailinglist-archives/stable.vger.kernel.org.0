Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139542F9CCC
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389468AbhARK0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388602AbhARJVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 04:21:25 -0500
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48AFC061757;
        Mon, 18 Jan 2021 01:20:44 -0800 (PST)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6A1702BB;
        Mon, 18 Jan 2021 10:20:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1610961643;
        bh=lSpPBNH4GxmInqL7nxgnJuS72aoB4h9fsNc8PNsk8so=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L24tSlz52D9ffLZ/21xRFDF0YPPN6QT1GoxIif+9C0XQ1sCiCDZxoebjl68ujGq9o
         BeR6ABeqvvddZ0KlCL8/MSwgnI7sBJy1mrBfcEr7CFOMMFeU2yJ4xlpFcGMsKW74ya
         sy9TKjgJqJMoboyB3mUXUXuwUYiYgAqe1fmvIvmE=
Date:   Mon, 18 Jan 2021 11:20:27 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] media: i2c: max9286: fix access to unallocated memory
Message-ID: <YAVS2zyhRkOQQe4L@pendragon.ideasonboard.com>
References: <20210118081446.46555-1-tomi.valkeinen@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210118081446.46555-1-tomi.valkeinen@ideasonboard.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tomi,

Thank you for the patch.

On Mon, Jan 18, 2021 at 10:14:46AM +0200, Tomi Valkeinen wrote:
> The asd allocated with v4l2_async_notifier_add_fwnode_subdev() must be
> of size max9286_asd, otherwise access to max9286_asd->source will go to
> unallocated memory.
> 
> Fixes: 86d37bf31af6 ("media: i2c: max9286: Allocate v4l2_async_subdev dynamically")
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
> Cc: stable@vger.kernel.org # v5.10+

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/max9286.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
> index c82c1493e099..b1e2476d3c9e 100644
> --- a/drivers/media/i2c/max9286.c
> +++ b/drivers/media/i2c/max9286.c
> @@ -580,7 +580,7 @@ static int max9286_v4l2_notifier_register(struct max9286_priv *priv)
>  
>  		asd = v4l2_async_notifier_add_fwnode_subdev(&priv->notifier,
>  							    source->fwnode,
> -							    sizeof(*asd));
> +							    sizeof(struct max9286_asd));
>  		if (IS_ERR(asd)) {
>  			dev_err(dev, "Failed to add subdev for source %u: %ld",
>  				i, PTR_ERR(asd));

-- 
Regards,

Laurent Pinchart

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261392EC05B
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 16:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbhAFPZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 10:25:58 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:53616 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFPZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 10:25:57 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A98F6878;
        Wed,  6 Jan 2021 16:25:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1609946715;
        bh=RxoggioJL/yFyeJTW2egcYD+uKCSGG6VL0xYVOs1NCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fGrJL2XeQ9y2HWt9V68W5b1g6S29KM6o8ZZkrsTqKVLlBVBWVEnyOy7RyShUuISmO
         D3ksYHGKi9tIu1VQZVRweHvjxjJ02Cc0FOsXTFwBxzzVUVUtmBo+zDCXyezF1medge
         Ukd83Qw7uNsrCagLU+bpRONeCALmk04yKEsUk+hw=
Date:   Wed, 6 Jan 2021 17:25:03 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Naushir Patuck <naush@raspberrypi.com>
Cc:     linux-media@vger.kernel.org, stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        John Cox <jc@kynesim.co.uk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v2] Revert "media: videobuf2: Fix length check for single
 plane dmabuf queueing"
Message-ID: <X/XWT57Sm5xuYIGv@pendragon.ideasonboard.com>
References: <20210106135210.12337-1-naush@raspberrypi.com>
 <20210106151657.16210-1-naush@raspberrypi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210106151657.16210-1-naush@raspberrypi.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naush,

Thank you for the patch.

(CC'ing John Cox as the author of the commit being reverted, and Hans
Verkuil as he has merged it)

On Wed, Jan 06, 2021 at 03:16:57PM +0000, Naushir Patuck wrote:
> The updated length check for dmabuf types broke existing usage in v4l2
> userland clients.
> 
> Fixes: 961d3b27 ("media: videobuf2: Fix length check for single plane dmabuf queueing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Naushir Patuck <naush@raspberrypi.com>
> Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 96d3b2b2aa31..3f61f5863bf7 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -118,8 +118,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  				return -EINVAL;
>  		}
>  	} else {
> -		length = (b->memory == VB2_MEMORY_USERPTR ||
> -			  b->memory == VB2_MEMORY_DMABUF)
> +		length = (b->memory == VB2_MEMORY_USERPTR)
>  			? b->length : vb->planes[0].length;
>  
>  		if (b->bytesused > length)

-- 
Regards,

Laurent Pinchart

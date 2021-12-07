Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E9446AEE1
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351467AbhLGATU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:19:20 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:44534 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbhLGATT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:19:19 -0500
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1D60B556;
        Tue,  7 Dec 2021 01:15:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1638836149;
        bh=JIjLfOsdEqlSWkYHUVufTQ41uM2M1qAGROWivZ5gNRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=asVXyw7YYQt2/i8zhtloFJhRUunnXMQH1hDRGDixMckUe6SyOU9dodZT/eysXdDdK
         +YQumvWFXlkuyMB681DtqraGrYAxQRhwUTdp6xIM/ZS1FshxlQjMFeY/e3GLmqSa6z
         7dAxJRTdMBbk7VRciKnRJnADA08JZ4gcP7RRBPW4=
Date:   Tue, 7 Dec 2021 02:15:21 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ricardo Ribalda <ricardo.ribalda@gmail.com>
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 2/3] media: v4l2-dev.c: Allow driver-defined entity names
Message-ID: <Ya6nmXKvTqhMVToH@pendragon.ideasonboard.com>
References: <20211207000629.4985-1-ribalda@chromium.org>
 <20211207000629.4985-3-ribalda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211207000629.4985-3-ribalda@chromium.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Tue, Dec 07, 2021 at 01:06:28AM +0100, Ricardo Ribalda wrote:
> If the driver provides an name for an entity, use it.
> This is particularly useful for drivers that export multiple video
> devices for the same hardware (i.e. metadata and data).

This seems reasonable (especially given that I've proposed it), but I
may be missing unintented consequences. Other reviews would be useful.

> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d03ace324db0..4c00503b9349 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -832,7 +832,9 @@ static int video_register_media_controller(struct video_device *vdev)
>  	}
>  
>  	if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN) {
> -		vdev->entity.name = vdev->name;
> +		/* Use entity names provided by the driver, if available. */
> +		if (!vdev->entity.name)
> +			vdev->entity.name = vdev->name;

We need to document this.

>  
>  		/* Needed just for backward compatibility with legacy MC API */
>  		vdev->entity.info.dev.major = VIDEO_MAJOR;

-- 
Regards,

Laurent Pinchart

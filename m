Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222141D356D
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 17:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgENPnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 11:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgENPnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 11:43:55 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36F9C061A0C;
        Thu, 14 May 2020 08:43:54 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: nicolas)
        with ESMTPSA id 08A7D2A2F7B
Message-ID: <9082c3117b9e9e65f35fc7ad91009c6ce412a842.camel@collabora.com>
Subject: Re: [PATCH] media: cedrus: Propagate OUTPUT resolution to CAPTURE
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc:     stable@vger.kernel.org, kernel@collabora.com,
        Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 May 2020 11:43:40 -0400
In-Reply-To: <20200514153903.341287-1-nicolas.dufresne@collabora.com>
References: <20200514153903.341287-1-nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le jeudi 14 mai 2020 à 11:39 -0400, Nicolas Dufresne a écrit :
> As per spec, the CAPTURE resolution should be automatically set based on
> the OTUPUT resolution. This patch properly propagate width/height to the
> capture when the OUTPUT format is set and override the user provided
> width/height with configured OUTPUT resolution when the CAPTURE fmt is
> updated.
> 
> This also prevents userspace from selecting a CAPTURE resolution that is
> too small, avoiding unwanted page faults.

Side note, this patch is based on top of "Samuel Holland <samuel@sholland.org>"
patches:

	[PATCH v3 1/2] media: cedrus: Program output format during each run
	[PATCH v3 2/2] media: cedrus: Implement runtime PM

As the patchset also fixes concurrent decoding issues. This was tested using
GStreamer implementation, which strictly follow the Stateless CODEC spec and
expect OUTPUT to CAPTURE width/height propagation.

> 
> Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> index 16d82309e7b6..a6d6b15adc2e 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -247,6 +247,8 @@ static int cedrus_try_fmt_vid_cap(struct file *file, void
> *priv,
>  		return -EINVAL;
>  
>  	pix_fmt->pixelformat = fmt->pixelformat;
> +	pix_fmt->width = ctx->src_fmt.width;
> +	pix_fmt->height = ctx->src_fmt.height;
>  	cedrus_prepare_format(pix_fmt);
>  
>  	return 0;
> @@ -319,11 +321,14 @@ static int cedrus_s_fmt_vid_out(struct file *file, void
> *priv,
>  		break;
>  	}
>  
> -	/* Propagate colorspace information to capture. */
> +	/* Propagate format information to capture. */
>  	ctx->dst_fmt.colorspace = f->fmt.pix.colorspace;
>  	ctx->dst_fmt.xfer_func = f->fmt.pix.xfer_func;
>  	ctx->dst_fmt.ycbcr_enc = f->fmt.pix.ycbcr_enc;
>  	ctx->dst_fmt.quantization = f->fmt.pix.quantization;
> +	ctx->dst_fmt.width = ctx->src_fmt.width;
> +	ctx->dst_fmt.height = ctx->src_fmt.height;
> +	cedrus_prepare_format(&ctx->dst_fmt);
>  
>  	return 0;
>  }


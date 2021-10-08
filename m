Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC77426E25
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbhJHP4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243056AbhJHP4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 11:56:14 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23418C061762
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 08:54:19 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id jo30so6643460qvb.3
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 08:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=JHQQ/ZPuMNBwfivK9zPtMYjZexbN/EgHfRTfb4X4FQM=;
        b=WilbUexRA01zQ0bMJZW4pqq0QhYgb4cjNMoYFpt/WN/kAwF2xzUpyfU1vmmjKkQnvx
         uOROisI1Hd25EaL/aZ4K1rDMkV4aT4ZtcAM3mAqwnnE1WvfK99MCJ6feMHFjtHQT7SjE
         VV5YT5M4Qo+Uu8Zd5HJaQM4LtKuMVcqpMf0JX9jpDrbdtZmOJ6dnujH4Db/u7CovMjCq
         DeFsPhEgFBltMLYOMkvGKaUwP0faoEj5P91nNZRBOTdRlQi3FSJBsTKOWNk8jci6DPXN
         KlDu1ZdeqcrMoQRYjtv8GcVZ1Ky8gx91c3Y4UgfFucJr5iRXsPSkEbZsLiWaNvZKPlf1
         vRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JHQQ/ZPuMNBwfivK9zPtMYjZexbN/EgHfRTfb4X4FQM=;
        b=OEInNTB2b+loqYY4oPYp5cAoZ45pL9W9asVl5wkPJ2xJo+RjJJfP8EuIyNxHRAFQC5
         k/eDwdauC0iRPdH/6SapYQOV30GYMScirZNhNbyvJwkpFvhmoBUw/taR/cBUKcuWIUx0
         QN6+8ur25qQ/QBaJ7j+dcrFB8EXfnvlr98F0RJbXWT4ZWBGZmR3qKRNWXOP8ljciPT3G
         +A+jCr9YZwCMk/sKsUMsxZxT/6OHUh8/uDEg8+39jsf8T4sONBM9hZ2KNb2L15OVUvWO
         ZPCRcSWVULaAEzgKQFPenyAvi/slkMnR2WCwejfrQRJ4nlVljrAHPym/oRz0Ol0Pg3MD
         UiRA==
X-Gm-Message-State: AOAM531OoPuTWRcUAgAZanB6FeGLnD4BwxRJ+5QbaGgEpkkAUj0vxcws
        c1L9efGTEneYrWicwFV2IpSsCw==
X-Google-Smtp-Source: ABdhPJzVAQ4pK19I9ktgZs5SQ2HXyEEnpkAMWqKmsXbgQremDteXueDeFV7UIfAnw16lGzesZAT+CA==
X-Received: by 2002:a05:6214:1267:: with SMTP id r7mr10933942qvv.16.1633708458308;
        Fri, 08 Oct 2021 08:54:18 -0700 (PDT)
Received: from nicolas-tpx395.localdomain (173-246-12-168.qc.cable.ebox.net. [173.246.12.168])
        by smtp.gmail.com with ESMTPSA id 207sm2261102qkd.56.2021.10.08.08.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:54:18 -0700 (PDT)
Message-ID: <a2759c8f5ec47bf6a96f69e103994dc20198c39b.camel@ndufresne.ca>
Subject: Re: [PATCH 2/2] media: rkvdec: Support dynamic resolution changes
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Chen-Yu Tsai <wenst@chromium.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Date:   Fri, 08 Oct 2021 11:54:16 -0400
In-Reply-To: <20211008100423.739462-3-wenst@chromium.org>
References: <20211008100423.739462-1-wenst@chromium.org>
         <20211008100423.739462-3-wenst@chromium.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le vendredi 08 octobre 2021 à 18:04 +0800, Chen-Yu Tsai a écrit :
> The mem-to-mem stateless decoder API specifies support for dynamic
> resolution changes. In particular, the decoder should accept format
> changes on the OUTPUT queue even when buffers have been allocated,
> as long as it is not streaming.

As commented in the code, it also requires the CAPTURE side not to be busy, not
sure if its worth clarifying, I don't really mind.

> 
> Relax restrictions for S_FMT as described in the previous paragraph,
> and as long as the codec format remains the same. This aligns it with
> the Hantro and Cedrus decoders. This change was mostly based on commit
> ae02d49493b5 ("media: hantro: Fix s_fmt for dynamic resolution changes").
> 
> Since rkvdec_s_fmt() is now just a wrapper around the output/capture
> variants without any additional shared functionality, drop the wrapper
> and call the respective functions directly.
> 
> Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>

Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>

> ---
>  drivers/staging/media/rkvdec/rkvdec.c | 40 +++++++++++++--------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
> index 7131156c1f2c..3f3f96488d74 100644
> --- a/drivers/staging/media/rkvdec/rkvdec.c
> +++ b/drivers/staging/media/rkvdec/rkvdec.c
> @@ -280,31 +280,20 @@ static int rkvdec_try_output_fmt(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int rkvdec_s_fmt(struct file *file, void *priv,
> -			struct v4l2_format *f,
> -			int (*try_fmt)(struct file *, void *,
> -				       struct v4l2_format *))
> +static int rkvdec_s_capture_fmt(struct file *file, void *priv,
> +				struct v4l2_format *f)
>  {
>  	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
>  	struct vb2_queue *vq;
> +	int ret;
>  
> -	if (!try_fmt)
> -		return -EINVAL;
> -
> -	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	/* Change not allowed if queue is busy */
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +			     V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
>  	if (vb2_is_busy(vq))
>  		return -EBUSY;
>  
> -	return try_fmt(file, priv, f);
> -}
> -
> -static int rkvdec_s_capture_fmt(struct file *file, void *priv,
> -				struct v4l2_format *f)
> -{
> -	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
> -	int ret;
> -
> -	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_capture_fmt);
> +	ret = rkvdec_try_capture_fmt(file, priv, f);
>  	if (ret)
>  		return ret;
>  
> @@ -319,9 +308,20 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
>  	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
>  	const struct rkvdec_coded_fmt_desc *desc;
>  	struct v4l2_format *cap_fmt;
> -	struct vb2_queue *peer_vq;
> +	struct vb2_queue *peer_vq, *vq;
>  	int ret;
>  
> +	/*
> +	 * In order to support dynamic resolution change, the decoder admits
> +	 * a resolution change, as long as the pixelformat remains. Can't be
> +	 * done if streaming.
> +	 */
> +	vq = v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> +	if (vb2_is_streaming(vq) ||
> +	    (vb2_is_busy(vq) &&
> +	     f->fmt.pix_mp.pixelformat != ctx->coded_fmt.fmt.pix_mp.pixelformat))
> +		return -EBUSY;
> +
>  	/*
>  	 * Since format change on the OUTPUT queue will reset the CAPTURE
>  	 * queue, we can't allow doing so when the CAPTURE queue has buffers
> @@ -331,7 +331,7 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
>  	if (vb2_is_busy(peer_vq))
>  		return -EBUSY;
>  
> -	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_output_fmt);
> +	ret = rkvdec_try_output_fmt(file, priv, f);
>  	if (ret)
>  		return ret;
>  



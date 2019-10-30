Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B04BE99A1
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 11:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfJ3KDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 06:03:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34025 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfJ3KDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 06:03:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so1581439wrr.1;
        Wed, 30 Oct 2019 03:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FMrNiLDlAG4LHDqZ/Yl8QilQGiUU1TiZ+I44MHl2pe8=;
        b=HNN3Pn/vNFFcDuiCrIDZIAg0jUIX3Ma1J5xZ3pi4cQbbPvRlhWTxNCRZL1BXGTPgBV
         mZPHjz9jzkrIab3DlA5QEPaVJmy/ml4Tiz+kinEe21oAK4IzLkyNrQqRwGZjY526zI03
         Z5/XYQ5xvo82fUpG0b99AjLqOdTD5Hy5ATzwdglzhLO2gOMRy7HmXuhcVJ4mJ9T62sQQ
         IGOs35f/F3IXziTFj002YE8D8BG+FaADlIa+AjvOYNtyG4bUsls0rfgjy5xaOS3Ln+1r
         GdSeKJfaSlW8NXyZh1Z+dmZ6LV0170yMWq0z9sHwaV8MAjf2aN8k+utW+vHNhwTNZuSc
         YfSw==
X-Gm-Message-State: APjAAAXTKukUTE41VU2SDz8W6jg53jemBoHMy4yFizvee+S+yDRsfMh2
        5OO/oOaso980dlZW7c6YhWU=
X-Google-Smtp-Source: APXvYqx9yWpySXQAETRsK0lzvhrydwfQ9Qwl8MxBphTqjmTCxz57hjMnqNjhMrjsPw6+qJUa5JnAIA==
X-Received: by 2002:adf:ec4b:: with SMTP id w11mr1963541wrn.243.1572429785547;
        Wed, 30 Oct 2019 03:03:05 -0700 (PDT)
Received: from pi (100.50.158.77.rev.sfr.net. [77.158.50.100])
        by smtp.gmail.com with ESMTPSA id a11sm1768504wmh.40.2019.10.30.03.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 03:03:04 -0700 (PDT)
Received: from johan by pi with local (Exim 4.92.2)
        (envelope-from <johan@pi>)
        id 1iPknS-0002ZQ-F2; Wed, 30 Oct 2019 11:01:46 +0100
Date:   Wed, 30 Oct 2019 11:01:46 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     David Airlie <airlied@linux.ie>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Fabien Dessenne <fabien.dessenne@st.com>
Subject: Re: [PATCH 1/4] drm/msm: fix memleak on release
Message-ID: <20191030100146.GC4691@localhost>
References: <20191010131333.23635-1-johan@kernel.org>
 <20191010131333.23635-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010131333.23635-2-johan@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 03:13:30PM +0200, Johan Hovold wrote:
> If a process is interrupted while accessing the "gpu" debugfs file and
> the drm device struct_mutex is contended, release() could return early
> and fail to free related resources.
> 
> Note that the return value from release() is ignored.
> 
> Fixes: 4f776f4511c7 ("drm/msm/gpu: Convert the GPU show function to use the GPU state")
> Cc: stable <stable@vger.kernel.org>     # 4.18
> Cc: Jordan Crouse <jcrouse@codeaurora.org>
> Cc: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---

Rob, Sean,

Sending a reminder about this one, which is not yet in linux-next.

Perhaps Daniel can pick it up otherwise?

Thanks,
Johan

>  drivers/gpu/drm/msm/msm_debugfs.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/msm/msm_debugfs.c b/drivers/gpu/drm/msm/msm_debugfs.c
> index 6be879578140..1c74381a4fc9 100644
> --- a/drivers/gpu/drm/msm/msm_debugfs.c
> +++ b/drivers/gpu/drm/msm/msm_debugfs.c
> @@ -47,12 +47,8 @@ static int msm_gpu_release(struct inode *inode, struct file *file)
>  	struct msm_gpu_show_priv *show_priv = m->private;
>  	struct msm_drm_private *priv = show_priv->dev->dev_private;
>  	struct msm_gpu *gpu = priv->gpu;
> -	int ret;
> -
> -	ret = mutex_lock_interruptible(&show_priv->dev->struct_mutex);
> -	if (ret)
> -		return ret;
>  
> +	mutex_lock(&show_priv->dev->struct_mutex);
>  	gpu->funcs->gpu_state_put(show_priv->state);
>  	mutex_unlock(&show_priv->dev->struct_mutex);

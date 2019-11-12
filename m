Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B46F95AE
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 17:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKLQcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 11:32:21 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41606 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfKLQcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 11:32:21 -0500
Received: by mail-ed1-f67.google.com with SMTP id a21so15417908edj.8;
        Tue, 12 Nov 2019 08:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2Jz3E/qC25NF9IiKUouiFwK/DvFsp3VH/99djW83Tw=;
        b=juR6/t7s9JzCUry7/6lTMFF27i/rneVimIPKY2HgzFAnMiFuV1WmO2ww+Pj8PdVbej
         qP6gfhPakJK4d6SPvlUeYiQWRLeOka1T5sxZZLeaLfpdnYbQ46HBKD5amyqCU6c8u5nW
         m9YuvO9yG5zyNdHia7jl93PojR4QMnOZj/9qK/h2bw+OdnE5vgw/8B95LZ5HFdCvF500
         K9rOVtrRpx3vVI/iVCupSf21kBaSLBnRbBJdWNbM+WjxE8v33s1/0LZU/1bkbih/Uvk1
         H56RFOj2/JCuZqeW0hNsE0Gci+GtOe0ILTaF4vIDij05gs6AXmjaeyVB4RgsjMf+3uQh
         yXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2Jz3E/qC25NF9IiKUouiFwK/DvFsp3VH/99djW83Tw=;
        b=tBvbb2PAXL/CevqviHs6GcibHgRUuo7bdMjJBRNLPcsO4RuBoDdeq4biQsUj8Oulmr
         vIZaW+xm437l6iKVQF6+YGGw5t9AaqshMlNMBT4GDf+HWDRp8Q95jC9uFDoidkGlmUyZ
         Kw/97pjzy6P3dxHVJpD2D+SS5DUirlaaBegvZN8B2QtbEEwDWhrEWgwG7AHWgExO1dgZ
         Gh6t5V669STraYmo5PHOz7wpytzfuZV9DNi7s8daZQ3hNHej8OxUerNcwdODYVuBs0kd
         WxvMc8zUA84UA8It+bIsAs9TWb4uEslBL1UzND9nd8daaMN20lpmI4eFn6uTSgV61liC
         YDew==
X-Gm-Message-State: APjAAAXI6InRXONHPE0zbKQnwVtv6POTfm94xYG9CzGhovIPknsA3Hm4
        Twd+9E5c5CakRmXiFyCWvGjgL9MytIWMIDNEkpQBkhj2
X-Google-Smtp-Source: APXvYqxUJWvwSmr0nM3W2I8m8qS350GR+Yh1XQx0NXoCk7SkB+BvkcrjP5jRJcrXZBYMM4/uW4AMh0vphypZhJFQYwE=
X-Received: by 2002:a17:906:73d5:: with SMTP id n21mr29350021ejl.228.1573576338515;
 Tue, 12 Nov 2019 08:32:18 -0800 (PST)
MIME-Version: 1.0
References: <20191010131333.23635-1-johan@kernel.org> <20191010131333.23635-2-johan@kernel.org>
 <20191030100146.GC4691@localhost> <20191112104001.GP11035@localhost> <20191112140155.GJ23790@phenom.ffwll.local>
In-Reply-To: <20191112140155.GJ23790@phenom.ffwll.local>
From:   Rob Clark <robdclark@gmail.com>
Date:   Tue, 12 Nov 2019 08:32:07 -0800
Message-ID: <CAF6AEGvom2wZ89434VLhhgAHCk_MMCGRbxSO+DQsX=+LPOCy8A@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/msm: fix memleak on release
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Johan Hovold <johan@kernel.org>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        freedreno <freedreno@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 6:01 AM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Tue, Nov 12, 2019 at 11:40:01AM +0100, Johan Hovold wrote:
> > On Wed, Oct 30, 2019 at 11:01:46AM +0100, Johan Hovold wrote:
> > > On Thu, Oct 10, 2019 at 03:13:30PM +0200, Johan Hovold wrote:
> > > > If a process is interrupted while accessing the "gpu" debugfs file and
> > > > the drm device struct_mutex is contended, release() could return early
> > > > and fail to free related resources.
> > > >
> > > > Note that the return value from release() is ignored.
> > > >
> > > > Fixes: 4f776f4511c7 ("drm/msm/gpu: Convert the GPU show function to use the GPU state")
> > > > Cc: stable <stable@vger.kernel.org>     # 4.18
> > > > Cc: Jordan Crouse <jcrouse@codeaurora.org>
> > > > Cc: Rob Clark <robdclark@gmail.com>
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > ---
> > >
> > > Rob, Sean,
> > >
> > > Sending a reminder about this one, which is not yet in linux-next.
> > >
> > > Perhaps Daniel can pick it up otherwise?
> >
> > Another two weeks, another reminder. This one is still not in -next.
>
> Well msm is maintained in a separate tree, so the usual group maintainer
> fallback for when patches are stuck doesn't apply.

oh, sorry, this wasn't showing up in patchwork.. or rather it did but
the non-msm related series subject made me overlook it.

I've already sent a PR, but this shouldn't conflict with anything and
I think it can go in via drm-misc/fixes

Reviewed-by: Rob Clark <robdclark@gmail.com>

> Rob, Sean, time to reconsider drm-misc for msm? I think there's some more
> oddball patches that occasionally get stuck for msm ...
>
> Also +Dave.
> -Daniel
>
> >
> > Johan
> >
> > > >  drivers/gpu/drm/msm/msm_debugfs.c | 6 +-----
> > > >  1 file changed, 1 insertion(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/msm/msm_debugfs.c b/drivers/gpu/drm/msm/msm_debugfs.c
> > > > index 6be879578140..1c74381a4fc9 100644
> > > > --- a/drivers/gpu/drm/msm/msm_debugfs.c
> > > > +++ b/drivers/gpu/drm/msm/msm_debugfs.c
> > > > @@ -47,12 +47,8 @@ static int msm_gpu_release(struct inode *inode, struct file *file)
> > > >   struct msm_gpu_show_priv *show_priv = m->private;
> > > >   struct msm_drm_private *priv = show_priv->dev->dev_private;
> > > >   struct msm_gpu *gpu = priv->gpu;
> > > > - int ret;
> > > > -
> > > > - ret = mutex_lock_interruptible(&show_priv->dev->struct_mutex);
> > > > - if (ret)
> > > > -         return ret;
> > > >
> > > > + mutex_lock(&show_priv->dev->struct_mutex);
> > > >   gpu->funcs->gpu_state_put(show_priv->state);
> > > >   mutex_unlock(&show_priv->dev->struct_mutex);
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6B0F8D00
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 11:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfKLKj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 05:39:58 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34923 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfKLKj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 05:39:57 -0500
Received: by mail-lf1-f66.google.com with SMTP id i26so1356135lfl.2;
        Tue, 12 Nov 2019 02:39:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XWXqgjsblbcyWM0h2meBDVZ+XPFRuLEW2MPm0S54S/s=;
        b=CTVAyYnT5d6NFMoTSwruMSYLoQz31YwMh9f1b2imH4VEgUZqDunjh4OAZ0qiGkpMU4
         2yyYvSmP/mCBvvzXw6+syV4fitEOKf6Xv29FqALV9M+3YnhzKPOTM5NjSPKaMvmlZJOl
         H1OVAk3AggiVh8sNvwPUP5fcBb/SCxxC+L1AlFCYp1lMnLMJsa2fZ7HMIaodqMGq8x1R
         d9mXNlWJXeWyv20bvSUJewbMbg1TnYDJCoo4oz1b21dfWaFvROuCVZF5wXZ5sZ8IQXbH
         60XoAVLZoVF/zmJ6ohHK7uFPzhP4N5Cq88cl4vPaMVq3Iz31e3vyFdSosmFZz9UHKLM+
         DFIA==
X-Gm-Message-State: APjAAAXYPD1CN/dYvjmx9RDiixBwB8WCvp6aiseDojWCHXAgbc9lJZlu
        4Sz7/vHAlzl8pCjcACPineI=
X-Google-Smtp-Source: APXvYqxbw5J+tzBKcx+QigjOviaP1PWngnIR6FhtuOsFfYfySEHZWhgInymsNuVEPwxpwVY/mq8xpg==
X-Received: by 2002:a05:6512:21e:: with SMTP id a30mr8849014lfo.76.1573555194825;
        Tue, 12 Nov 2019 02:39:54 -0800 (PST)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id d24sm3344144ljg.73.2019.11.12.02.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 02:39:54 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iUTab-0000IZ-1b; Tue, 12 Nov 2019 11:40:01 +0100
Date:   Tue, 12 Nov 2019 11:40:01 +0100
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
Message-ID: <20191112104001.GP11035@localhost>
References: <20191010131333.23635-1-johan@kernel.org>
 <20191010131333.23635-2-johan@kernel.org>
 <20191030100146.GC4691@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030100146.GC4691@localhost>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 30, 2019 at 11:01:46AM +0100, Johan Hovold wrote:
> On Thu, Oct 10, 2019 at 03:13:30PM +0200, Johan Hovold wrote:
> > If a process is interrupted while accessing the "gpu" debugfs file and
> > the drm device struct_mutex is contended, release() could return early
> > and fail to free related resources.
> > 
> > Note that the return value from release() is ignored.
> > 
> > Fixes: 4f776f4511c7 ("drm/msm/gpu: Convert the GPU show function to use the GPU state")
> > Cc: stable <stable@vger.kernel.org>     # 4.18
> > Cc: Jordan Crouse <jcrouse@codeaurora.org>
> > Cc: Rob Clark <robdclark@gmail.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> 
> Rob, Sean,
> 
> Sending a reminder about this one, which is not yet in linux-next.
> 
> Perhaps Daniel can pick it up otherwise?

Another two weeks, another reminder. This one is still not in -next.

Johan

> >  drivers/gpu/drm/msm/msm_debugfs.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/msm/msm_debugfs.c b/drivers/gpu/drm/msm/msm_debugfs.c
> > index 6be879578140..1c74381a4fc9 100644
> > --- a/drivers/gpu/drm/msm/msm_debugfs.c
> > +++ b/drivers/gpu/drm/msm/msm_debugfs.c
> > @@ -47,12 +47,8 @@ static int msm_gpu_release(struct inode *inode, struct file *file)
> >  	struct msm_gpu_show_priv *show_priv = m->private;
> >  	struct msm_drm_private *priv = show_priv->dev->dev_private;
> >  	struct msm_gpu *gpu = priv->gpu;
> > -	int ret;
> > -
> > -	ret = mutex_lock_interruptible(&show_priv->dev->struct_mutex);
> > -	if (ret)
> > -		return ret;
> >  
> > +	mutex_lock(&show_priv->dev->struct_mutex);
> >  	gpu->funcs->gpu_state_put(show_priv->state);
> >  	mutex_unlock(&show_priv->dev->struct_mutex);

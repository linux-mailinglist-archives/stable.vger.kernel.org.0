Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF6F193DDB
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 12:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgCZLaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 07:30:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33063 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZLaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 07:30:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so7356685wrd.0
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 04:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SH22KWe1hT6c0thd/+qCFAA217uZva8JGmRsF7nMdrA=;
        b=Udzcw45qPPv5A25jk54OFhj4fJwPHOulVPqhrWDFHVr7egVfXw1/rrCOFyiXC9/5Bp
         v/WLaUaIbebAQRjSvqpEPj4tK9OytkaOuGtNkEAudOoSpyHwDtBfqDwnneFLkLXEc/rt
         c1qapb5G/wcuTC+RV9F5OhQpkQRnaZiASAjvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SH22KWe1hT6c0thd/+qCFAA217uZva8JGmRsF7nMdrA=;
        b=R4dCvPnGY1G45WdMkTXb+rnHwVo2rOoCdYNORcLz3H8FphJCAGP2Y7IZEB9ujfe9gm
         Xonu1OPnLbLbDYHl/U+yJQMe3rGtAJkkCWDKm/AigQe/sWIplJRY3+m9PVr76PzKApHQ
         PlhQj13ogreeZGXPu/obdkkJdM2Bw3NUmvlGUVReOWHcLoN7QmR99MPFDx862EMlfw6g
         /rhmTW8CeAH01Zz1xqlnnc6JHc2WEna2TWYVGZ5/gDp+0qvBjVBnYph0hZiYw2SGewzB
         Tuw/Ko4DilVkLhk3rd//Nocwnm0Xs0IXFAqRPoxVPeoFCF1wM/++c7nELl31s3+0iAke
         LeNA==
X-Gm-Message-State: ANhLgQ00m1/NGEIc+5ORWTqTmSbtpAHzwxj0V+04XYtsa8fBP2UgnATD
        xPxAoPvjH4WRualbBAfrVnO2qw==
X-Google-Smtp-Source: ADFU+vtXp3l+t9NAurWabAT9joFdTO4RnwXRXgDGk4vJs2NLHapAKQS6g3wo+eJTwAhIGXmdalQRlw==
X-Received: by 2002:adf:b60d:: with SMTP id f13mr9335271wre.12.1585222203361;
        Thu, 26 Mar 2020 04:30:03 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id c5sm10817838wma.3.2020.03.26.04.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 04:30:01 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:29:59 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/vboxvideo: Add missing
 remove_conflicting_pci_framebuffers call
Message-ID: <20200326112959.GZ2363188@phenom.ffwll.local>
References: <20200325144310.36779-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325144310.36779-1-hdegoede@redhat.com>
X-Operating-System: Linux phenom 5.3.0-3-amd64 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 03:43:10PM +0100, Hans de Goede wrote:
> The vboxvideo driver is missing a call to remove conflicting framebuffers.
> 
> Surprisingly, when using legacy BIOS booting this does not really cause
> any issues. But when using UEFI to boot the VM then plymouth will draw
> on both the efifb /dev/fb0 and /dev/drm/card0 (which has registered
> /dev/fb1 as fbdev emulation).
> 
> VirtualBox will actual display the output of both devices (I guess it is
> showing whatever was drawn last), this causes weird artifacts because of
> pitch issues in the efifb when the VM window is not sized at 1024x768
> (the window will resize to its last size once the vboxvideo driver loads,
> changing the pitch).
> 
> Adding the missing drm_fb_helper_remove_conflicting_pci_framebuffers()
> call fixes this.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2695eae1f6d3 ("drm/vboxvideo: Switch to generic fbdev emulation")
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/gpu/drm/vboxvideo/vbox_drv.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> index 8512d970a09f..261255085918 100644
> --- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
> +++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> @@ -76,6 +76,10 @@ static int vbox_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (ret)
>  		goto err_mode_fini;
>  
> +	ret = drm_fb_helper_remove_conflicting_pci_framebuffers(pdev, "vboxvideodrmfb");
> +	if (ret)
> +		goto err_irq_fini;

To avoid transient issues this should be done as early as possible,
definitely before the drm driver starts to touch the "hw". With that

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I do wonder though why the automatic removal of conflicting framebuffers
doesn't work, fbdev should already do that from register_framebuffer(),
which is called somewhere in drm_fbdev_generic_setup (after a few layers).

Did you check why the two framebuffers don't conflict, and why the uefi
one doesn't get thrown out?
-Daniel

> +
>  	ret = drm_fbdev_generic_setup(&vbox->ddev, 32);
>  	if (ret)
>  		goto err_irq_fini;
> -- 
> 2.26.0.rc2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

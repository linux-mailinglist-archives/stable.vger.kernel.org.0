Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B2132BC41
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445699AbhCCNrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349655AbhCCLAI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 06:00:08 -0500
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FEAC061788
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 02:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds202012; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RgKmcd8Y2kjZxyQZf6Rm/UlmUS6YJhPJkPSy8kcTa5E=; b=rmfHG1dCneW+9c3ZvQhiKCjQ1/
        yn4F6zrJaJlgneU6ZrbT6DmX2bI/8uo+sL/9kTR5zagicV/1LJvLvDOnUaZJfPtID/EYp1SyDQvJI
        MgaYq9hyBc7+N8JRAyZgpl64IvVJ51kLwGkl9kvc+ikTXgvMBakOEEO0zvnhYZK8E3/Udt8ctiM1G
        xhdZr7mpehZOZ9P9kf6HYoemi72OVIXuAPyVRK3elZL0lsrEP6eMfuX7rQ2j7FPVPoq92c38gJ0xo
        zX607DPDxm8Sch419lscBxsipPlZk72i431whfwC4oNJQj929JkYYXT02wziJMEPuurIWz/IvohHd
        UfQpsBGQ==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:64686 helo=[192.168.10.61])
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <noralf@tronnes.org>)
        id 1lHPDR-0004gC-8O; Wed, 03 Mar 2021 11:58:53 +0100
Subject: Re: [PATCH v7] drm: Use USB controller's DMA mask when importing
 dmabufs
To:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        christian.koenig@amd.com, gregkh@linuxfoundation.org,
        hdegoede@redhat.com, sean@poorly.run, stern@rowland.harvard.edu,
        dan.carpenter@oracle.com
Cc:     dri-devel@lists.freedesktop.org, Pavel Machek <pavel@ucw.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
References: <20210303084512.25635-1-tzimmermann@suse.de>
From:   =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>
Message-ID: <f1271ed4-1bb1-0fe6-a5b1-db9dbae575fe@tronnes.org>
Date:   Wed, 3 Mar 2021 11:58:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210303084512.25635-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Den 03.03.2021 09.45, skrev Thomas Zimmermann:
> USB devices cannot perform DMA and hence have no dma_mask set in their
> device structure. Therefore importing dmabuf into a USB-based driver
> fails, which breaks joining and mirroring of display in X11.
> 
> For USB devices, pick the associated USB controller as attachment device.
> This allows the DRM import helpers to perform the DMA setup. If the DMA
> controller does not support DMA transfers, we're out of luck and cannot
> import. Our current USB-based DRM drivers don't use DMA, so the actual
> DMA device is not important.
> 
> Drivers should use DRM_GEM_SHMEM_DROVER_OPS_USB to initialize their
> instance of struct drm_driver.
> 

This doesn't seem to be the case anymore.

> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.

s/un der/under/

> 
> v7:
> 	* fix use-before-init bug in gm12u320 (Dan)
> v6:
> 	* implement workaround in DRM drivers and hold reference to
> 	  DMA device while USB device is in use
> 	* remove dev_is_usb() (Greg)
> 	* collapse USB helper into usb_intf_get_dma_device() (Alan)
> 	* integrate Daniel's TODO statement (Daniel)
> 	* fix typos (Greg)
> v5:
> 	* provide a helper for USB interfaces (Alan)
> 	* add FIXME item to documentation and TODO list (Daniel)
> v4:
> 	* implement workaround with USB helper functions (Greg)
> 	* use struct usb_device->bus->sysdev as DMA device (Takashi)
> v3:
> 	* drop gem_create_object
> 	* use DMA mask of USB controller, if any (Daniel, Christian, Noralf)
> v2:
> 	* move fix to importer side (Christian, Daniel)
> 	* update SHMEM and CMA helpers for new PRIME callbacks
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> Tested-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Christian König <christian.koenig@amd.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> ---
>  Documentation/gpu/todo.rst      | 21 +++++++++++++++++++++
>  drivers/gpu/drm/tiny/gm12u320.c | 28 ++++++++++++++++++++++++++--
>  drivers/gpu/drm/udl/udl_drv.c   | 17 +++++++++++++++++
>  drivers/gpu/drm/udl/udl_drv.h   |  1 +
>  drivers/gpu/drm/udl/udl_main.c  |  9 +++++++++
>  drivers/usb/core/usb.c          | 32 ++++++++++++++++++++++++++++++++
>  include/linux/usb.h             |  2 ++
>  7 files changed, 108 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/tiny/gm12u320.c b/drivers/gpu/drm/tiny/gm12u320.c
> index 0b4f4f2af1ef..4fe372f43cf5 100644
> --- a/drivers/gpu/drm/tiny/gm12u320.c
> +++ b/drivers/gpu/drm/tiny/gm12u320.c

[...]

> @@ -638,12 +656,15 @@ static int gm12u320_usb_probe(struct usb_interface *interface,
>  				      struct gm12u320_device, dev);
>  	if (IS_ERR(gm12u320))
>  		return PTR_ERR(gm12u320);
> +	dev = &gm12u320->dev;
> +
> +	gm12u320->dmadev = usb_intf_get_dma_device(to_usb_interface(dev->dev));
> +	if (!gm12u320->dmadev)
> +		drm_warn(dev, "buffer sharing not supported"); /* not an error */
>  

When implementing this in my own driver I discovered that this device
ref will leak if probing fails after this.

I've done it like this:

	gdrm->dmadev = usb_intf_get_dma_device(intf);
	if (!gdrm->dmadev)
		dev_warn(dev, "buffer sharing not supported");

	ret = drm_dev_register(drm, 0);
	if (ret) {
		put_device(gdrm->dmadev);
		return ret;
	}

An even better solution would be to have a devm_ version of the function.

Noralf.

>  	INIT_DELAYED_WORK(&gm12u320->fb_update.work, gm12u320_fb_update_work);
>  	mutex_init(&gm12u320->fb_update.lock);
>  
> -	dev = &gm12u320->dev;
> -
>  	ret = drmm_mode_config_init(dev);
>  	if (ret)
>  		return ret;

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AED58F08B
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 18:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiHJQkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 12:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbiHJQkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 12:40:31 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8052392
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 09:40:29 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p12-20020a7bcc8c000000b003a5360f218fso1296459wma.3
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 09:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=KbtX/yuBejcio58S+wA08Oms/h9KupDVKtGMajir+nI=;
        b=bFZVxwML6mJ3CaDiAs9wOS/e9YwKjLEAUCUxScTXUw6F4xTgGbQyc3H64MGuPB/LKL
         yYe3gpoolXAbjnr/G7PT8nvgLnOYr7GkZ6vN/Kqt4wz+7XIuBIbwZXFToF78XtxpGXt4
         buGP/phsMI9Zcp9iPALfZ+I3HEGo6oRnrIMFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=KbtX/yuBejcio58S+wA08Oms/h9KupDVKtGMajir+nI=;
        b=svkaV2wwc96y2E7va2JH4eqYR31yYVfp9xHYfHwc528+WE+axaotV0f0B4C8QiZrYC
         WIGi/76C36notN2UrF3Z/EqpzOInu5u6nXwruQTSBYs9bBhiz5b0gKRyO5aW+e/gApTO
         rEALeMx/WthO0k0Hd3bv9Beo84VdvmR+A3ZP0dqllYP+xmhhc5EnNsS6sHOujLhk+wv4
         PSon2y1uOvGZNPyMNcPXTSc5AvkBl1+1C1kasrmVMp+Fh3vePFSsq75mcic8gdBQCv2M
         UHJjqKvfS9G/GXH9x4CcHL1aMbCdxpmmM+4bHGhZyvnfZQ4+F/ub8+qw9+qpXNUNvjJf
         RyaA==
X-Gm-Message-State: ACgBeo2qT1ZJUGfJJVVpb/3StSgS/l9LAFIm+J4SyDhAZ4lhHgL4gLK9
        s1A7acCnsFQl74VFnkH7JPGnZA==
X-Google-Smtp-Source: AA6agR7OR5/6haEXj6Lu6d3vuxWkNY4kjEAXIlDMT8rqpnv17ZQu4lO/cHbzlO/KWtmhX8LvlvXJAQ==
X-Received: by 2002:a1c:7508:0:b0:3a5:923:3994 with SMTP id o8-20020a1c7508000000b003a509233994mr2991924wmc.173.1660149628232;
        Wed, 10 Aug 2022 09:40:28 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id e3-20020adf9bc3000000b0020e6ce4dabdsm16817466wrc.103.2022.08.10.09.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 09:40:27 -0700 (PDT)
Date:   Wed, 10 Aug 2022 18:40:25 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Zack Rusin <zackr@vmware.com>
Cc:     dri-devel@lists.freedesktop.org, krastevm@vmware.com,
        mombasawalam@vmware.com, contact@emersion.fr, ppaalanen@gmail.com,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Chia-I Wu <olvaffe@gmail.com>,
        virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/8] drm: Disable the cursor plane on atomic contexts
 with virtualized drivers
Message-ID: <YvPfedG/uLQNFG7e@phenom.ffwll.local>
References: <20220712033246.1148476-1-zack@kde.org>
 <20220712033246.1148476-2-zack@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712033246.1148476-2-zack@kde.org>
X-Operating-System: Linux phenom 5.10.0-8-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:32:39PM -0400, Zack Rusin wrote:
> From: Zack Rusin <zackr@vmware.com>
> 
> Cursor planes on virtualized drivers have special meaning and require
> that the clients handle them in specific ways, e.g. the cursor plane
> should react to the mouse movement the way a mouse cursor would be
> expected to and the client is required to set hotspot properties on it
> in order for the mouse events to be routed correctly.
> 
> This breaks the contract as specified by the "universal planes". Fix it
> by disabling the cursor planes on virtualized drivers while adding
> a foundation on top of which it's possible to special case mouse cursor
> planes for clients that want it.
> 
> Disabling the cursor planes makes some kms compositors which were broken,
> e.g. Weston, fallback to software cursor which works fine or at least
> better than currently while having no effect on others, e.g. gnome-shell
> or kwin, which put virtualized drivers on a deny-list when running in
> atomic context to make them fallback to legacy kms and avoid this issue.
> 
> Signed-off-by: Zack Rusin <zackr@vmware.com>
> Fixes: 681e7ec73044 ("drm: Allow userspace to ask for universal plane list (v2)")
> Cc: <stable@vger.kernel.org> # v5.4+
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Gurchetan Singh <gurchetansingh@chromium.org>
> Cc: Chia-I Wu <olvaffe@gmail.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: virtualization@lists.linux-foundation.org
> Cc: spice-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/drm_plane.c          | 11 +++++++++++
>  drivers/gpu/drm/qxl/qxl_drv.c        |  2 +-
>  drivers/gpu/drm/vboxvideo/vbox_drv.c |  2 +-
>  drivers/gpu/drm/virtio/virtgpu_drv.c |  3 ++-
>  drivers/gpu/drm/vmwgfx/vmwgfx_drv.c  |  2 +-
>  include/drm/drm_drv.h                | 10 ++++++++++
>  include/drm/drm_file.h               | 12 ++++++++++++
>  7 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
> index 726f2f163c26..e1e2a65c7119 100644
> --- a/drivers/gpu/drm/drm_plane.c
> +++ b/drivers/gpu/drm/drm_plane.c
> @@ -667,6 +667,17 @@ int drm_mode_getplane_res(struct drm_device *dev, void *data,
>  		    !file_priv->universal_planes)
>  			continue;
>  
> +		/*
> +		 * Unless userspace supports virtual cursor plane
> +		 * then if we're running on virtual driver do not
> +		 * advertise cursor planes because they'll be broken
> +		 */
> +		if (plane->type == DRM_PLANE_TYPE_CURSOR &&
> +		    drm_core_check_feature(dev, DRIVER_VIRTUAL)	&&
> +		    file_priv->atomic &&
> +		    !file_priv->supports_virtual_cursor_plane)
> +			continue;
> +
>  		if (drm_lease_held(file_priv, plane->base.id)) {
>  			if (count < plane_resp->count_planes &&
>  			    put_user(plane->base.id, plane_ptr + count))
> diff --git a/drivers/gpu/drm/qxl/qxl_drv.c b/drivers/gpu/drm/qxl/qxl_drv.c
> index 1cb6f0c224bb..0e4212e05caa 100644
> --- a/drivers/gpu/drm/qxl/qxl_drv.c
> +++ b/drivers/gpu/drm/qxl/qxl_drv.c
> @@ -281,7 +281,7 @@ static const struct drm_ioctl_desc qxl_ioctls[] = {
>  };
>  
>  static struct drm_driver qxl_driver = {
> -	.driver_features = DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC,
> +	.driver_features = DRIVER_GEM | DRIVER_MODESET | DRIVER_ATOMIC | DRIVER_VIRTUAL,
>  
>  	.dumb_create = qxl_mode_dumb_create,
>  	.dumb_map_offset = drm_gem_ttm_dumb_map_offset,
> diff --git a/drivers/gpu/drm/vboxvideo/vbox_drv.c b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> index f4f2bd79a7cb..84e75bcc3384 100644
> --- a/drivers/gpu/drm/vboxvideo/vbox_drv.c
> +++ b/drivers/gpu/drm/vboxvideo/vbox_drv.c
> @@ -176,7 +176,7 @@ DEFINE_DRM_GEM_FOPS(vbox_fops);
>  
>  static const struct drm_driver driver = {
>  	.driver_features =
> -	    DRIVER_MODESET | DRIVER_GEM | DRIVER_ATOMIC,
> +	    DRIVER_MODESET | DRIVER_GEM | DRIVER_ATOMIC | DRIVER_VIRTUAL,
>  
>  	.lastclose = drm_fb_helper_lastclose,
>  
> diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
> index 5f25a8d15464..3c5bb006159a 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_drv.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
> @@ -198,7 +198,8 @@ MODULE_AUTHOR("Alon Levy");
>  DEFINE_DRM_GEM_FOPS(virtio_gpu_driver_fops);
>  
>  static const struct drm_driver driver = {
> -	.driver_features = DRIVER_MODESET | DRIVER_GEM | DRIVER_RENDER | DRIVER_ATOMIC,
> +	.driver_features =
> +		DRIVER_MODESET | DRIVER_GEM | DRIVER_RENDER | DRIVER_ATOMIC | DRIVER_VIRTUAL,
>  	.open = virtio_gpu_driver_open,
>  	.postclose = virtio_gpu_driver_postclose,
>  
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> index 01a5b47e95f9..712f6ad0b014 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -1581,7 +1581,7 @@ static const struct file_operations vmwgfx_driver_fops = {
>  
>  static const struct drm_driver driver = {
>  	.driver_features =
> -	DRIVER_MODESET | DRIVER_RENDER | DRIVER_ATOMIC | DRIVER_GEM,
> +	DRIVER_MODESET | DRIVER_RENDER | DRIVER_ATOMIC | DRIVER_GEM | DRIVER_VIRTUAL,
>  	.ioctls = vmw_ioctls,
>  	.num_ioctls = ARRAY_SIZE(vmw_ioctls),
>  	.master_set = vmw_master_set,
> diff --git a/include/drm/drm_drv.h b/include/drm/drm_drv.h
> index f6159acb8856..c4cd7fc350d9 100644
> --- a/include/drm/drm_drv.h
> +++ b/include/drm/drm_drv.h
> @@ -94,6 +94,16 @@ enum drm_driver_feature {
>  	 * synchronization of command submission.
>  	 */
>  	DRIVER_SYNCOBJ_TIMELINE         = BIT(6),
> +	/**
> +	 * @DRIVER_VIRTUAL:
> +	 *
> +	 * Driver is running on top of virtual hardware. The most significant
> +	 * implication of this is a requirement of special handling of the
> +	 * cursor plane (e.g. cursor plane has to actually track the mouse
> +	 * cursor and the clients are required to set hotspot in order for
> +	 * the cursor planes to work correctly).
> +	 */
> +	DRIVER_VIRTUAL                  = BIT(7),

I think the naming here is unfortunate, because people will vonder why
e.g. vkms doesn't set this, and then add it, and confuse stuff completely.

Also it feels a bit wrong to put this onto the driver, when really it's a
cursor flag. I guess you can make it some kind of flag in the drm_plane
structure, or a new plane type, but putting it there instead of into the
"random pile of midlayer-mistake driver flags" would be a lot better.

Otherwise I think the series looks roughly how I'd expect it to look.
-Daniel

>  
>  	/* IMPORTANT: Below are all the legacy flags, add new ones above. */
>  
> diff --git a/include/drm/drm_file.h b/include/drm/drm_file.h
> index e0a73a1e2df7..3e5c36891161 100644
> --- a/include/drm/drm_file.h
> +++ b/include/drm/drm_file.h
> @@ -223,6 +223,18 @@ struct drm_file {
>  	 */
>  	bool is_master;
>  
> +	/**
> +	 * @supports_virtual_cursor_plane:
> +	 *
> +	 * This client is capable of handling the cursor plane with the
> +	 * restrictions imposed on it by the virtualized drivers.
> +	 *
> +	 * The implies that the cursor plane has to behave like a cursor
> +	 * i.e. track cursor movement. It also requires setting of the
> +	 * hotspot properties by the client on the cursor plane.
> +	 */
> +	bool supports_virtual_cursor_plane;
> +
>  	/**
>  	 * @master:
>  	 *
> -- 
> 2.34.1
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

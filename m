Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0768DF38
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 18:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjBGRri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 12:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjBGRrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 12:47:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88191BC3
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 09:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83F8060F71
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 17:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6A1C433D2;
        Tue,  7 Feb 2023 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675792053;
        bh=+64e+8mFJKnm+yEYJF8Wm9cBrBW+Xnn8VVoYGCj2o4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lxPHTo2gRczfX0FFhodjL1OD3Pe7ccpOrMmfFdKFWYKVdnvT1bv/uWyoHYoiFRr2j
         k/JbE9UPKwTdKM2YLNh19Ql5cfYg2zbPzDpI5dLprUCYigNH7pNE/gsuH0lBBsQCaq
         7sEi/3TPeWngpL4gNkJwGZfRGagS3Cta4/+ZHetM=
Date:   Tue, 7 Feb 2023 18:47:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>, Jim Cromie <jim.cromie@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, stable@vger.kernel.org
Subject: Re: [PATCH] drm: Disable dynamic debug as broken
Message-ID: <Y+KOszHLodcTx9Sr@kroah.com>
References: <20230207143337.2126678-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230207143337.2126678-1-jani.nikula@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 04:33:37PM +0200, Jani Nikula wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> CONFIG_DRM_USE_DYNAMIC_DEBUG breaks debug prints for (at least modular)
> drm drivers. The debug prints can be reinstated by manually frobbing
> /sys/module/drm/parameters/debug after the fact, but at that point the
> damage is done and all debugs from driver probe are lost. This makes
> drivers totally undebuggable.
> 
> There's a more complete fix in progress [1], with further details, but
> we need this fixed in stable kernels. Mark the feature as broken and
> disable it by default, with hopes distros follow suit and disable it as
> well.
> 
> [1] https://lore.kernel.org/r/20230125203743.564009-1-jim.cromie@gmail.com
> 
> Fixes: 84ec67288c10 ("drm_print: wrap drm_*_dbg in dyndbg descriptor factory macro")
> Cc: Jim Cromie <jim.cromie@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v6.1+
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>  drivers/gpu/drm/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index f42d4c6a19f2..dc0f94f02a82 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -52,7 +52,8 @@ config DRM_DEBUG_MM
>  
>  config DRM_USE_DYNAMIC_DEBUG
>  	bool "use dynamic debug to implement drm.debug"
> -	default y
> +	default n
> +	depends on BROKEN
>  	depends on DRM
>  	depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
>  	depends on JUMP_LABEL

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

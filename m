Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7746D24256A
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 08:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHLGb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 02:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbgHLGb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Aug 2020 02:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F7AF20768;
        Wed, 12 Aug 2020 06:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597213917;
        bh=aSKIYDCe9tCyqEEVWCR4TOBC4YZZ/qu7KDEDekxFTko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZoXBSqpm1KpbUGNJjLg471ehyQ0rOqZl77C3TpyrozdKhrpJaBpDOWgwMFtkYBu4s
         VBb6Ta6yv989xsvQxX2xY6izCalYXxRHKGtAsR5skSZ2gFlVwZf+KvgAxKbPdY4+ul
         X2A5CLjS7m4ArqQ5o9dXfKGv+XlH92cGMnxQlRxo=
Date:   Wed, 12 Aug 2020 08:31:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Cc:     dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        daniel@ffwll.ch, andrzej.p@collabora.com, daniels@collabora.com
Subject: Re: [PATCH] drm/rockchip: Require the YTR modifier for AFBC
Message-ID: <20200812063154.GB1300894@kroah.com>
References: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 04:26:31PM -0400, Alyssa Rosenzweig wrote:
> The AFBC decoder used in the Rockchip VOP assumes the use of the
> YUV-like colourspace transform (YTR). YTR is lossless for RGB(A)
> buffers, which covers the RGBA8 and RGB565 formats supported in
> vop_convert_afbc_format. Use of YTR is signaled with the
> AFBC_FORMAT_MOD_YTR modifier, which prior to this commit was missing. As
> such, a producer would have to generate buffers that do not use YTR,
> which the VOP would erroneously decode as YTR, leading to severe visual
> corruption.
> 
> The upstream AFBC support was developed against a captured frame, which
> failed to exercise modifier support. Prior to bring-up of AFBC in Mesa
> (in the Panfrost driver), no open userspace respected modifier
> reporting. As such, this change is not expected to affect broken
> userspaces.
> 
> Tested on RK3399 with Panfrost and Weston.
> 
> Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
> ---
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> index 4a2099cb5..857d97cdc 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
> @@ -17,9 +17,20 @@
>  
>  #define NUM_YUV2YUV_COEFFICIENTS 12
>  
> +/* AFBC supports a number of configurable modes. Relevant to us is block size
> + * (16x16 or 32x8), storage modifiers (SPARSE, SPLIT), and the YUV-like
> + * colourspace transform (YTR). 16x16 SPARSE mode is always used. SPLIT mode
> + * could be enabled via the hreg_block_split register, but is not currently
> + * handled. The colourspace transform is implicitly always assumed by the
> + * decoder, so consumers must use this transform as well.
> + *
> + * Failure to match modifiers will cause errors displaying AFBC buffers
> + * produced by conformant AFBC producers, including Mesa.
> + */
>  #define ROCKCHIP_AFBC_MOD \
>  	DRM_FORMAT_MOD_ARM_AFBC( \
>  		AFBC_FORMAT_MOD_BLOCK_SIZE_16x16 | AFBC_FORMAT_MOD_SPARSE \
> +			| AFBC_FORMAT_MOD_YTR \
>  	)
>  
>  enum vop_data_format {
> -- 
> 2.28.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

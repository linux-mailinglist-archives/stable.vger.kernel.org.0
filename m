Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08E1610B4A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJ1HaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 03:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJ1HaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 03:30:18 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD584F64C;
        Fri, 28 Oct 2022 00:30:15 -0700 (PDT)
Received: from eldfell (unknown [194.136.85.206])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pq)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 4E5B8660290F;
        Fri, 28 Oct 2022 08:30:13 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1666942213;
        bh=z+ciR8QtGyLRpkmTeUgYpn3tnblv69hXqxcsMx9CfIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g5fjiNOIUQHXnXBQsyffh8A5rK4ubwA4/hM4iWL8HwSNwR5/kqOicwEz3++/vDks7
         35wb9X2J8qXynxhqgPMeSvzhUbtB0OxHftoEXm8OiPfzEMpV39CjYl9cCRuUnIcKh5
         T/6L2YmugQuHUNvQVz6QqRqYq+/srLEI5wiaQYe/tK3s8/5L7zckTPCqlrMJ1i2seY
         Wo8Ve7Qw8Zn6MGe2gic46RPNei1zMzAkBRCmL//qm5FFitCOxLBVs6Qw+guWaJ7Die
         n4+4P8QkQxJ5Vxuofdo+zydJJ1UsnWNO9S9icoeZBmis1U9MnWwueF3YywZ0Gqx495
         AkEqmozH2wGFg==
Date:   Fri, 28 Oct 2022 10:30:10 +0300
From:   Pekka Paalanen <pekka.paalanen@collabora.com>
To:     Hector Martin <marcan@marcan.st>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
Message-ID: <20221028103010.15994b06.pekka.paalanen@collabora.com>
In-Reply-To: <20221027135711.24425-1-marcan@marcan.st>
References: <20221027135711.24425-1-marcan@marcan.st>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Oct 2022 22:57:11 +0900
Hector Martin <marcan@marcan.st> wrote:

> drm_fb_build_fourcc_list() currently returns all emulated formats
> unconditionally as long as the native format is among them, even though
> not all combinations have conversion helpers. Although the list is
> arguably provided to userspace in precedence order, userspace can pick
> something out-of-order (and thus break when it shouldn't), or simply
> only support a format that is unsupported (and thus think it can work,
> which results in the appearance of a hang as FB blits fail later on,
> instead of the initialization error you'd expect in this case).
> 
> Add checks to filter the list of emulated formats to only those
> supported for conversion to the native format. This presumes that there
> is a single native format (only the first is checked, if there are
> multiple). Refactoring this API to drop the native list or support it
> properly (by returning the appropriate emulated->native mapping table)
> is left for a future patch.
> 
> The simpledrm driver is left as-is with a full table of emulated
> formats. This keeps all currently working conversions available and
> drops all the broken ones (i.e. this a strict bugfix patch, adding no
> new supported formats nor removing any actually working ones). In order
> to avoid proliferation of emulated formats, future drivers should
> advertise only XRGB8888 as the sole emulated format (since some
> userspace assumes its presence).
> 
> This fixes a real user regression where the ?RGB2101010 support commit
> started advertising it unconditionally where not supported, and KWin
> decided to start to use it over the native format and broke, but also
> the fixes the spurious RGB565/RGB888 formats which have been wrongly
> unconditionally advertised since the dawn of simpledrm.
> 
> Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
> Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>

Hi Hector,

I completely agree with all the rationale here.

Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>


Thanks,
pq


> ---
> I'm proposing this alternative approach after a heated discussion on
> IRC. I'm out of ideas, if y'all don't like this one you can figure it
> out for yourseves :-)
> 
> Changes since v1:
> This v2 moves all the changes to the helper (so they will apply to
> the upcoming ofdrm, though ofdrm also needs to be fixed to trim its
> format table to only formats that should be emulated, probably only
> XRGB8888, to avoid further proliferating the use of conversions),
> and avoids touching more than one file. The API still needs cleanup
> as mentioned (supporting more than one native format is fundamentally
> broken, since the helper would need to tell the driver *what* native
> format to use for *each* emulated format somehow), but all current and
> planned users only pass in one native format, so this can (and should)
> be fixed later.
> 
> Aside: After other IRC discussion, I'm testing nuking the
> XRGB2101010 <-> ARGB2101010 advertisement (which does not involve
> conversion) by removing those entries from simpledrm in the Asahi Linux
> downstream tree. As far as I'm concerned, it can be removed if nobody
> complains (by removing those entries from the simpledrm array), if
> maintainers are generally okay with removing advertised formats at all.
> If so, there might be other opportunities for further trimming the list
> non-native formats advertised to userspace.
> 
> Tested with KWin-X11, KWin-Wayland, GNOME-X11, GNOME-Wayland, and Weston
> on both XRGB2101010 and RGB8888 simpledrm framebuffers.
> 
>  drivers/gpu/drm/drm_format_helper.c | 66 ++++++++++++++++++++---------
>  1 file changed, 47 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
> index e2f76621453c..3ee59bae9d2f 100644
> --- a/drivers/gpu/drm/drm_format_helper.c
> +++ b/drivers/gpu/drm/drm_format_helper.c
> @@ -807,6 +807,38 @@ static bool is_listed_fourcc(const uint32_t *fourccs, size_t nfourccs, uint32_t
>  	return false;
>  }
>  
> +static const uint32_t conv_from_xrgb8888[] = {
> +	DRM_FORMAT_XRGB8888,
> +	DRM_FORMAT_ARGB8888,
> +	DRM_FORMAT_XRGB2101010,
> +	DRM_FORMAT_ARGB2101010,
> +	DRM_FORMAT_RGB565,
> +	DRM_FORMAT_RGB888,
> +};
> +
> +static const uint32_t conv_from_rgb565_888[] = {
> +	DRM_FORMAT_XRGB8888,
> +	DRM_FORMAT_ARGB8888,
> +};
> +
> +static bool is_conversion_supported(uint32_t from, uint32_t to)
> +{
> +	switch (from) {
> +	case DRM_FORMAT_XRGB8888:
> +	case DRM_FORMAT_ARGB8888:
> +		return is_listed_fourcc(conv_from_xrgb8888, ARRAY_SIZE(conv_from_xrgb8888), to);
> +	case DRM_FORMAT_RGB565:
> +	case DRM_FORMAT_RGB888:
> +		return is_listed_fourcc(conv_from_rgb565_888, ARRAY_SIZE(conv_from_rgb565_888), to);
> +	case DRM_FORMAT_XRGB2101010:
> +		return to == DRM_FORMAT_ARGB2101010;
> +	case DRM_FORMAT_ARGB2101010:
> +		return to == DRM_FORMAT_XRGB2101010;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /**
>   * drm_fb_build_fourcc_list - Filters a list of supported color formats against
>   *                            the device's native formats
> @@ -827,7 +859,9 @@ static bool is_listed_fourcc(const uint32_t *fourccs, size_t nfourccs, uint32_t
>   * be handed over to drm_universal_plane_init() et al. Native formats
>   * will go before emulated formats. Other heuristics might be applied
>   * to optimize the order. Formats near the beginning of the list are
> - * usually preferred over formats near the end of the list.
> + * usually preferred over formats near the end of the list. Formats
> + * without conversion helpers will be skipped. New drivers should only
> + * pass in XRGB8888 and avoid exposing additional emulated formats.
>   *
>   * Returns:
>   * The number of color-formats 4CC codes returned in @fourccs_out.
> @@ -839,7 +873,7 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>  {
>  	u32 *fourccs = fourccs_out;
>  	const u32 *fourccs_end = fourccs_out + nfourccs_out;
> -	bool found_native = false;
> +	uint32_t native_format = 0;
>  	size_t i;
>  
>  	/*
> @@ -858,26 +892,18 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>  
>  		drm_dbg_kms(dev, "adding native format %p4cc\n", &fourcc);
>  
> -		if (!found_native)
> -			found_native = is_listed_fourcc(driver_fourccs, driver_nfourccs, fourcc);
> +		/*
> +		 * There should only be one native format with the current API.
> +		 * This API needs to be refactored to correctly support arbitrary
> +		 * sets of native formats, since it needs to report which native
> +		 * format to use for each emulated format.
> +		 */
> +		if (!native_format)
> +			native_format = fourcc;
>  		*fourccs = fourcc;
>  		++fourccs;
>  	}
>  
> -	/*
> -	 * The plane's atomic_update helper converts the framebuffer's color format
> -	 * to a native format when copying to device memory.
> -	 *
> -	 * If there is not a single format supported by both, device and
> -	 * driver, the native formats are likely not supported by the conversion
> -	 * helpers. Therefore *only* support the native formats and add a
> -	 * conversion helper ASAP.
> -	 */
> -	if (!found_native) {
> -		drm_warn(dev, "Format conversion helpers required to add extra formats.\n");
> -		goto out;
> -	}
> -
>  	/*
>  	 * The extra formats, emulated by the driver, go second.
>  	 */
> @@ -890,6 +916,9 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>  		} else if (fourccs == fourccs_end) {
>  			drm_warn(dev, "Ignoring emulated format %p4cc\n", &fourcc);
>  			continue; /* end of available output buffer */
> +		} else if (!is_conversion_supported(fourcc, native_format)) {
> +			drm_dbg_kms(dev, "Unsupported emulated format %p4cc\n", &fourcc);
> +			continue; /* format is not supported for conversion */
>  		}
>  
>  		drm_dbg_kms(dev, "adding emulated format %p4cc\n", &fourcc);
> @@ -898,7 +927,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>  		++fourccs;
>  	}
>  
> -out:
>  	return fourccs - fourccs_out;
>  }
>  EXPORT_SYMBOL(drm_fb_build_fourcc_list);


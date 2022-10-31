Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82494613B0A
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 17:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiJaQPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 12:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJaQPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 12:15:34 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78DB12626
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 09:15:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id f27so30683472eje.1
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 09:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hr1TaCp5+0WwKThBbE8Q7EfPsA0Hkr+C7iUAWCV7sho=;
        b=G+lXQWVBrDtIQokUa2jGIFnIkByNRGlA/23v9nVn+TUO+EGj/rkjgtEGwx/p3r5SGz
         k0wpCfJiwcmV4Anm92Y2fyuSSJAgBQF6QAwxq7TQc/5/Y10lp5J0cwnWyrVWU5aR6Zl2
         nlQ4D6zoUlkG7j7BbMAnJPSmkjGWX56C1uxdk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hr1TaCp5+0WwKThBbE8Q7EfPsA0Hkr+C7iUAWCV7sho=;
        b=KANYjLGrq13QykmP60yMeRJLePT30YzbLzsLUC0XRMDbcsTvLvtvJB0eNckbGErxEs
         ajwwJylomTFnvz61V2iSFlbYB/Ib/3sMydxDTSzZAZ8kXaIDxY8Nd3GQOac2dC403p4D
         hc9fWPxYZXLqgWa1OdQ0noIbg+lji2NzbJVF+AB3JGDSbaTNQaOq811fe0XYktXdlDWd
         IEiKexZQmXrgBHN/CIwsK/XyiQBQ2kcmQNVHTD1M2uOtI7T8LcqjXoJMRT1DQ314bYmU
         UBHQdD9C1sDuKVuJ48woDboQCCEOMEkHv7+sDL7CpL+prKsHKtV1zXXFgJWja3WZWkr/
         rmiw==
X-Gm-Message-State: ACrzQf1VB8maOhJLMdHyswc8U1m5Lsunjq/5Ep5NiSERc+y4jNHGzYI1
        WHqyZoqQU7w3+VgIULkM+WAIU7AA+l19GhpG9Ao8gg==
X-Google-Smtp-Source: AMsMyM4f5QoJRX4s8RGR/9kX+oxpsFeUb76uCE6kv6ze3NxkSPZxDueIAW5NeXzVHBSSh/k3osSjPrp7wE6W++f2RDM=
X-Received: by 2002:a17:906:5daa:b0:791:8933:f9f0 with SMTP id
 n10-20020a1709065daa00b007918933f9f0mr13551871ejv.335.1667232930133; Mon, 31
 Oct 2022 09:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221027135711.24425-1-marcan@marcan.st>
In-Reply-To: <20221027135711.24425-1-marcan@marcan.st>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 31 Oct 2022 11:15:18 -0500
Message-ID: <CAFxkdAqjdonoEgOm4Nv-mbyw3OJuuO1=3dXYyn2+yszUp13Bbg@mail.gmail.com>
Subject: Re: [PATCH v2] drm/format-helper: Only advertise supported formats
 for conversion
To:     Hector Martin <marcan@marcan.st>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 8:57 AM Hector Martin <marcan@marcan.st> wrote:
>
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
> Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB210101


> Cc: stable@vger.kernel.org
> Signed-off-by: Hector Martin <marcan@marcan.st>

There is a CC for stable on here, but this patch does not apply in any
way on 6.0 or older kernels as the fourcc bits and considerable churn
came in with the 6.1 merge window.  You don't happen to have a
backport of this to 6.0 do you?

Thanks,
Justin

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
>         return false;
>  }
>
> +static const uint32_t conv_from_xrgb8888[] = {
> +       DRM_FORMAT_XRGB8888,
> +       DRM_FORMAT_ARGB8888,
> +       DRM_FORMAT_XRGB2101010,
> +       DRM_FORMAT_ARGB2101010,
> +       DRM_FORMAT_RGB565,
> +       DRM_FORMAT_RGB888,
> +};
> +
> +static const uint32_t conv_from_rgb565_888[] = {
> +       DRM_FORMAT_XRGB8888,
> +       DRM_FORMAT_ARGB8888,
> +};
> +
> +static bool is_conversion_supported(uint32_t from, uint32_t to)
> +{
> +       switch (from) {
> +       case DRM_FORMAT_XRGB8888:
> +       case DRM_FORMAT_ARGB8888:
> +               return is_listed_fourcc(conv_from_xrgb8888, ARRAY_SIZE(conv_from_xrgb8888), to);
> +       case DRM_FORMAT_RGB565:
> +       case DRM_FORMAT_RGB888:
> +               return is_listed_fourcc(conv_from_rgb565_888, ARRAY_SIZE(conv_from_rgb565_888), to);
> +       case DRM_FORMAT_XRGB2101010:
> +               return to == DRM_FORMAT_ARGB2101010;
> +       case DRM_FORMAT_ARGB2101010:
> +               return to == DRM_FORMAT_XRGB2101010;
> +       default:
> +               return false;
> +       }
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
>         u32 *fourccs = fourccs_out;
>         const u32 *fourccs_end = fourccs_out + nfourccs_out;
> -       bool found_native = false;
> +       uint32_t native_format = 0;
>         size_t i;
>
>         /*
> @@ -858,26 +892,18 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>
>                 drm_dbg_kms(dev, "adding native format %p4cc\n", &fourcc);
>
> -               if (!found_native)
> -                       found_native = is_listed_fourcc(driver_fourccs, driver_nfourccs, fourcc);
> +               /*
> +                * There should only be one native format with the current API.
> +                * This API needs to be refactored to correctly support arbitrary
> +                * sets of native formats, since it needs to report which native
> +                * format to use for each emulated format.
> +                */
> +               if (!native_format)
> +                       native_format = fourcc;
>                 *fourccs = fourcc;
>                 ++fourccs;
>         }
>
> -       /*
> -        * The plane's atomic_update helper converts the framebuffer's color format
> -        * to a native format when copying to device memory.
> -        *
> -        * If there is not a single format supported by both, device and
> -        * driver, the native formats are likely not supported by the conversion
> -        * helpers. Therefore *only* support the native formats and add a
> -        * conversion helper ASAP.
> -        */
> -       if (!found_native) {
> -               drm_warn(dev, "Format conversion helpers required to add extra formats.\n");
> -               goto out;
> -       }
> -
>         /*
>          * The extra formats, emulated by the driver, go second.
>          */
> @@ -890,6 +916,9 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>                 } else if (fourccs == fourccs_end) {
>                         drm_warn(dev, "Ignoring emulated format %p4cc\n", &fourcc);
>                         continue; /* end of available output buffer */
> +               } else if (!is_conversion_supported(fourcc, native_format)) {
> +                       drm_dbg_kms(dev, "Unsupported emulated format %p4cc\n", &fourcc);
> +                       continue; /* format is not supported for conversion */
>                 }
>
>                 drm_dbg_kms(dev, "adding emulated format %p4cc\n", &fourcc);
> @@ -898,7 +927,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device *dev,
>                 ++fourccs;
>         }
>
> -out:
>         return fourccs - fourccs_out;
>  }
>  EXPORT_SYMBOL(drm_fb_build_fourcc_list);
> --
> 2.35.1
>

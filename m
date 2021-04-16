Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06448361BFA
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 11:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbhDPIly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 04:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240613AbhDPIly (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 04:41:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D495C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 01:41:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s14so8747761pjl.5
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 01:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=He3oTSlwnFPi0gSb22caSHrtR7K6cmAux7Z+2T9Xo1o=;
        b=hacERswIX9cIS1UJydG+GKquH1hgrwS2+nCAq/Bgnj2hhImJuvM1HgFl4cg3S6pZev
         JCM/D2hsoeC9Cts3k/lDE+Tk9+6VMkX2XSjBRWjIaS+bPe6By0MTX5I0WkSokhwkTZ2s
         IbESokhSKgVQrq92WrdxoWpJ2zDl3xWxv0TymTHlFtLoHnW/4sc2o/IGhHEL6OREV5PB
         6L4ls7hRTeG8WWZxbf/vK4servXkCqbwQ9exsc6rCarR8bBKnafSkErOolvEAnnBOVyk
         YimIDDJRfC/4fGCP6QUmjQnHe0SUetMfhL8E10Ju8nu1Lfygrl+Nh+deXzi9RCwd4o03
         s9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=He3oTSlwnFPi0gSb22caSHrtR7K6cmAux7Z+2T9Xo1o=;
        b=Le7unZHSvHkSzEXahSgqua93o1tGF8na3d3tq9e7P80UfIBuoQ6X1nrKbN8jSKiLGn
         Ulcd/P6/UVP7L7JjlKwoFJkkv4amfQD2lU1sgLSxzM5XCCsPkT2cTtazrlWiuPgD0NrT
         MVnBIjlnAhxZkCbO6CcuSP4j9rdCHaoWaquxh3awQyUekTqhbxI5dWhVaHNYhSsR8hFA
         oqGIeZRZPBgPqGqBFVRZ+tqUdLc2ykstG1QeeNINVzYX3COu6gH5CTgG+bsMCeZwlzN1
         9J506bzdLRIaZX9vC9QdOHn2GXRkHVkW0Z4Elhx7bBMEvPsA0xY15cJ03y4tjmD5jXvR
         1hAg==
X-Gm-Message-State: AOAM532blo5FED2diwBXgLf3soAl0zbR+X3a5rjgihYSgfrokr0rqIJQ
        yMDQysbwv1KxqZb1nXkdr9QZBZVlyYB5mqGMlwEOgg==
X-Google-Smtp-Source: ABdhPJwF2oXeuk5v0ZBd9FHld186Dr4jfV9Bgsh1mreQZM+bGYmRq9h7B9YLZnGn9NgnTr0mVBmGQE0fwbP36eT7Of4=
X-Received: by 2002:a17:90b:392:: with SMTP id ga18mr8091538pjb.222.1618562488639;
 Fri, 16 Apr 2021 01:41:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210415183619.1431-1-rdunlap@infradead.org>
In-Reply-To: <20210415183619.1431-1-rdunlap@infradead.org>
From:   Robert Foss <robert.foss@linaro.org>
Date:   Fri, 16 Apr 2021 10:41:17 +0200
Message-ID: <CAG3jFyvi-NyOdd8DdKu_QYz593YYvJzXm65DoCLubzHE+-5zNg@mail.gmail.com>
Subject: Re: [PATCH -next] drm: bridge: fix ANX7625 use of mipi_dsi_() functions
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Xin Ji <xji@analogixsemi.com>, Sam Ravnborg <sam@ravnborg.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Randy!

Reviewed-by: Robert Foss <robert.foss@linaro.org>

On Thu, 15 Apr 2021 at 20:36, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> The Analogix DRM ANX7625 bridge driver uses mips_dsi_() function
> interfaces so it should select DRM_MIPI_DSI to prevent build errors.
>
>
> ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
>
>
> Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Xin Ji <xji@analogixsemi.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: dri-devel@lists.freedesktop.org
> Cc: Andrzej Hajda <a.hajda@samsung.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Robert Foss <robert.foss@linaro.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/bridge/analogix/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20210414.orig/drivers/gpu/drm/bridge/analogix/Kconfig
> +++ linux-next-20210414/drivers/gpu/drm/bridge/analogix/Kconfig
> @@ -30,6 +30,7 @@ config DRM_ANALOGIX_ANX7625
>         tristate "Analogix Anx7625 MIPI to DP interface support"
>         depends on DRM
>         depends on OF
> +       select DRM_MIPI_DSI
>         help
>           ANX7625 is an ultra-low power 4K mobile HD transmitter
>           designed for portable devices. It converts MIPI/DPI to

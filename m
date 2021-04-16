Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2AE361D09
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 12:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbhDPJP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 05:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbhDPJP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 05:15:28 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44B8C061756
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:15:02 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v13so47871ple.9
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 02:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xZ5QJbgcxsi5P774OAde+gyqdj3zeY4OT+RguQ4Yh8M=;
        b=aN2W8sVheIWGZcNAWtyWNlsBq7F/94yG45zz5d+cs5hpMT5/rmZvM52iuC7wugTGTe
         32NxhvKwVFzR3StSAVGoWnjzxVayT0FWkrcRHd8nQ9Oxf6PUmj5RMARWmJRfXf+tY3Fe
         7npCshA71UXd5xq1/d2hV5dxUMhxhWK+XC77naU9D+29dOniktLYfu5pjyKk9NuNT8+q
         9aCDOJVSATl5xWT/LmdtKYt99OU4G/Q032oqXc7CdFCZ0avEnJ4kxkF0jeuk3Dn+1tO6
         r8StwudXvFWPihol2//mRYLFaFrchKVxJZFJHdgk1Q3YrRRBjG9XwsoX5zSreXzxir2g
         jWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xZ5QJbgcxsi5P774OAde+gyqdj3zeY4OT+RguQ4Yh8M=;
        b=QAIMNv6Fqk2zTthG+GTesK+9LU9KdRW8BEoYYU8RQ66IBPA+UH1OrboGpZNt57b1ne
         B712/UJElhOqhd1pIfKcQlgp4P0tUeJqcITRlAyxGnAKpFt9B5Hsr17XNzdr3avpIz2K
         0OEN/Xi3gEelpc4eae2Kkdfd07SG2/a6RZWgyCBJ5zH81dJ6hxBoVbQ+VFLl7VcNS31+
         AgsNmGimtt4qskcEYAJknH0RBUUsfWcYTheo3N00P7B5bf83u3wzRj6qB4F/W5JsvnFo
         rt6cKT/Mps//8oTbGCc5DMgABCxKOU2T/eunvLzLe8ug8ie77zqRLqGt2wMaSTrfXb28
         QdIw==
X-Gm-Message-State: AOAM531HOlsQAfT5mBgXYDXt2XIERzRZGDcjXNbZ//auUgLJCln0TiWH
        XM26fRvniqahU/17Ut8IX4CT7Pyc/N6p/3KLj1dv7Q==
X-Google-Smtp-Source: ABdhPJwsng8nHmy0FYR9JGRD2atFcCX5gdaUhjcgL9PrN+cIjSiQQakDN3tUOWLHQXr620+cq5I/pFIdXZkB1m62JWs=
X-Received: by 2002:a17:902:e543:b029:eb:8684:e00b with SMTP id
 n3-20020a170902e543b02900eb8684e00bmr6091661plf.69.1618564502401; Fri, 16 Apr
 2021 02:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210415183619.1431-1-rdunlap@infradead.org> <CAG3jFyvi-NyOdd8DdKu_QYz593YYvJzXm65DoCLubzHE+-5zNg@mail.gmail.com>
In-Reply-To: <CAG3jFyvi-NyOdd8DdKu_QYz593YYvJzXm65DoCLubzHE+-5zNg@mail.gmail.com>
From:   Robert Foss <robert.foss@linaro.org>
Date:   Fri, 16 Apr 2021 11:14:51 +0200
Message-ID: <CAG3jFyukH=ijvn-=2E_tGJdpUHFZ0YXte7MQqncMhoM5Eg7hVQ@mail.gmail.com>
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

Merged for 5.13 in drm-misc-next-fixes

On Fri, 16 Apr 2021 at 10:41, Robert Foss <robert.foss@linaro.org> wrote:
>
> Thanks Randy!
>
> Reviewed-by: Robert Foss <robert.foss@linaro.org>
>
> On Thu, 15 Apr 2021 at 20:36, Randy Dunlap <rdunlap@infradead.org> wrote:
> >
> > The Analogix DRM ANX7625 bridge driver uses mips_dsi_() function
> > interfaces so it should select DRM_MIPI_DSI to prevent build errors.
> >
> >
> > ERROR: modpost: "mipi_dsi_attach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> > ERROR: modpost: "mipi_dsi_device_register_full" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> > ERROR: modpost: "of_find_mipi_dsi_host_by_node" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> > ERROR: modpost: "mipi_dsi_device_unregister" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> > ERROR: modpost: "mipi_dsi_detach" [drivers/gpu/drm/bridge/analogix/anx7625.ko] undefined!
> >
> >
> > Fixes: 8bdfc5dae4e3 ("drm/bridge: anx7625: Add anx7625 MIPI DSI/DPI to DP")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Cc: Xin Ji <xji@analogixsemi.com>
> > Cc: Sam Ravnborg <sam@ravnborg.org>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: Andrzej Hajda <a.hajda@samsung.com>
> > Cc: Neil Armstrong <narmstrong@baylibre.com>
> > Cc: Robert Foss <robert.foss@linaro.org>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/bridge/analogix/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> >
> > --- linux-next-20210414.orig/drivers/gpu/drm/bridge/analogix/Kconfig
> > +++ linux-next-20210414/drivers/gpu/drm/bridge/analogix/Kconfig
> > @@ -30,6 +30,7 @@ config DRM_ANALOGIX_ANX7625
> >         tristate "Analogix Anx7625 MIPI to DP interface support"
> >         depends on DRM
> >         depends on OF
> > +       select DRM_MIPI_DSI
> >         help
> >           ANX7625 is an ultra-low power 4K mobile HD transmitter
> >           designed for portable devices. It converts MIPI/DPI to

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A56CFFF0
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 11:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjC3JkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 05:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjC3JkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 05:40:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81D446B4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 02:40:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6334961FB5
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B185BC433D2
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 09:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680169222;
        bh=TZ7+QJNcppwvyxngwgi947mNMBOSswS1rVlzdkVli48=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lfAihpfQY4n8VZcs8s+DD6cIWE13gYPGFrdhTZ4+I35sJUFiKr4BQCKwHdNbdGf9q
         GCdUnjO4XQ18yWSqyXoyRUDP7P8H9hzppi3Ib9RXd1mhfY1vyLzOvSgAFb/pFxGHVh
         ePDphAHRAY+JasL8xWaGDueljXmmwOG+a8BFPTi5AcDwQI6do04zveA4fyFL4SGwAs
         tD4BpGk9SSGBaihYWcn6AKLdHJQJ7QD51lpAX4O73BurxaphY8y18mEsLFEtNFFd4b
         KbRSWigfVgInAZgU1YCBpwZxl56Q1MsjtrGqQrYIiUw8Y91BVNzjFWHYyjasp7vSXZ
         pk6FIT1VZ8u/g==
Received: by mail-pj1-f41.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so21349261pjb.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 02:40:22 -0700 (PDT)
X-Gm-Message-State: AAQBX9f6397vVxCD+o+vTXPYIGQjwxw8DHXwrRIOS3LZ+hGgAtRv/ILo
        ct8wCa+4Ypb669CL1Kgjzzmip70dQAAUiuaEI/I1QA==
X-Google-Smtp-Source: AKy350Zc060ocRd8FeXDfv9ppwm12XZxKMuK6TCTjOSTZiTrlfJZ3EJN88IehlFDe/vgfu9DrYctMQcRdfywnEtBmxc=
X-Received: by 2002:a17:902:b18a:b0:1a1:8f72:e9b with SMTP id
 s10-20020a170902b18a00b001a18f720e9bmr8239215plr.7.1680169222352; Thu, 30 Mar
 2023 02:40:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230330093131.424828-1-francesco@dolcini.it>
In-Reply-To: <20230330093131.424828-1-francesco@dolcini.it>
From:   Robert Foss <rfoss@kernel.org>
Date:   Thu, 30 Mar 2023 11:40:11 +0200
X-Gmail-Original-Message-ID: <CAN6tsi6DB4wsxAriDWimRE2-FW80LMOsX9DDkNQdifYFCUMjGg@mail.gmail.com>
Message-ID: <CAN6tsi6DB4wsxAriDWimRE2-FW80LMOsX9DDkNQdifYFCUMjGg@mail.gmail.com>
Subject: Re: [PATCH v1] drm/bridge: lt8912b: Fix DSI Video Mode
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Adrien Grassein <adrien.grassein@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 11:31=E2=80=AFAM Francesco Dolcini <francesco@dolci=
ni.it> wrote:
>
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>
> LT8912 DSI port supports only Non-Burst mode video operation with Sync
> Events and continuous clock on clock lane, correct dsi mode flags
> according to that removing MIPI_DSI_MODE_VIDEO_BURST flag.
>
> Cc: <stable@vger.kernel.org>
> Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/gpu/drm/bridge/lontium-lt8912b.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/bridge/lontium-lt8912b.c b/drivers/gpu/drm/b=
ridge/lontium-lt8912b.c
> index b40baced1331..13c131ade268 100644
> --- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
> +++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
> @@ -504,7 +504,6 @@ static int lt8912_attach_dsi(struct lt8912 *lt)
>         dsi->format =3D MIPI_DSI_FMT_RGB888;
>
>         dsi->mode_flags =3D MIPI_DSI_MODE_VIDEO |
> -                         MIPI_DSI_MODE_VIDEO_BURST |
>                           MIPI_DSI_MODE_LPM |
>                           MIPI_DSI_MODE_NO_EOT_PACKET;
>
> --
> 2.25.1
>

Letting this sleep for a few days before applying.

Reviewed-by: Robert Foss <rfoss@kernel.org>

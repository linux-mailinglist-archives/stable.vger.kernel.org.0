Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B523434E21A
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 09:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhC3HXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 03:23:51 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:30064 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbhC3HXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 03:23:34 -0400
Date:   Tue, 30 Mar 2021 07:23:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1617089008;
        bh=uyxiiNlmIpUqH5pV51j68OH6R9OIx2NMn7HBlqoxjWA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=rmdyZIi1rI9f6E7lkoqWOHQnEjeuf+fMw8xGgnB1pafJJytQTJHD08d6TnZpwCV1H
         wn50aEcMlFQFsPnYEiQDxK6CeQLGIgJW6Qi8nTjEeVHD9tF33Gy87vur4wU7cEIPRQ
         IdYxvkfa1ksytU6Lw2iGx/qHe60sKXHcaQIsJUKjjVh1LvKVeCiQOYzF++BXrLvqty
         7XyzUWtBa1ijJ2T3m+BY32SwGVYvwjc47hrmQBMRYbUYt+fHRoB2bDouMO6Mh3zCcc
         oE8jjvWgpnJsV+Chm84hVMT9LjE3vpqIQ9T7v30RoNto1nezDwANJEBqW7gffXtGaw
         ylJdCpXAOvwZA==
To:     Paul Cercueil <paul@crapouillou.net>
From:   Simon Ser <contact@emersion.fr>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sam Ravnborg <sam@ravnborg.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH 1/2] drm/ingenic: Switch IPU plane to type OVERLAY
Message-ID: <BH3N8QICMyp64pmUQyXLwYMnCNBvXxThwvKJIOmyMU0XIgTtorcGd7s7AjnIFXQrLGEoJMuvPcWTiv38syiYOTCDv-bSxswFBX6y3UYqTwE=@emersion.fr>
In-Reply-To: <20210329175046.214629-2-paul@crapouillou.net>
References: <20210329175046.214629-1-paul@crapouillou.net> <20210329175046.214629-2-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> It should have been an OVERLAY from the beginning. The documentation
> stipulates that there should be an unique PRIMARY plane per CRTC.

Thanks for the quick patch! One comment below=E2=80=A6

> Fixes: fc1acf317b01 ("drm/ingenic: Add support for the IPU")
> Cc: <stable@vger.kernel.org> # 5.8+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/gpu/drm/ingenic/ingenic-drm-drv.c | 11 +++++------
>  drivers/gpu/drm/ingenic/ingenic-ipu.c     |  2 +-
>  2 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/=
ingenic/ingenic-drm-drv.c
> index 29742ec5ab95..09225b770bb8 100644
> --- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> +++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
> @@ -419,7 +419,7 @@ static void ingenic_drm_plane_enable(struct ingenic_d=
rm *priv,
>  =09unsigned int en_bit;
>
>  =09if (priv->soc_info->has_osd) {
> -=09=09if (plane->type =3D=3D DRM_PLANE_TYPE_PRIMARY)
> +=09=09if (plane !=3D &priv->f0)

I don't know about this driver but=E2=80=A6 is this really the same as the =
previous
condition? The previous condition would match two planes, this one seems to
match only a single plane. What am I missing?


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25506222CBB
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 22:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgGPU0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 16:26:06 -0400
Received: from crapouillou.net ([89.234.176.41]:41410 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgGPU0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 16:26:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1594931164; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SX7hdu69Ya5NdmyT12h41uasgZBzqU3phiTCNybRetM=;
        b=fygTz1AkK3F+KkSqLcdpUfyr3zmBZjEUKSa/Vt00eTSF72jQDKtklUryyIrQc3Oa8rtmYM
        YWSRB4PVWihapc0vvKQgXHwti43BXsbCFSDEk4IVlkAUUAib8gf6krgrd5yvZjzNZB1DvT
        EDDLKtIE3EVZe0Sk+6bYeKsdbWK+UkI=
Date:   Thu, 16 Jul 2020 22:25:54 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v3 01/12] drm/ingenic: Fix incorrect assumption about
 plane->index
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        od@zcrc.me, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <6RWKDQ.JP0OMXFFTGWS1@crapouillou.net>
In-Reply-To: <20200716174335.GC2235355@ravnborg.org>
References: <20200716163846.174790-1-paul@crapouillou.net>
        <20200716174335.GC2235355@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sam,

Le jeu. 16 juil. 2020 =E0 19:43, Sam Ravnborg <sam@ravnborg.org> a=20
=E9crit :
> Hi Paul.
>=20
> On Thu, Jul 16, 2020 at 06:38:35PM +0200, Paul Cercueil wrote:
>>  plane->index is NOT the index of the color plane in a YUV frame.
>>  Actually, a YUV frame is represented by a single drm_plane, even=20
>> though
>>  it contains three Y, U, V planes.
>>=20
>>  v2-v3: No change
>>=20
>>  Cc: stable@vger.kernel.org # v5.3
>>  Fixes: 90b86fcc47b4 ("DRM: Add KMS driver for the Ingenic JZ47xx=20
>> SoCs")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  Acked-by: Sam Ravnborg <sam@ravnborg.org>
>=20
> A cover letter would have been useful. Please consider that in the
> future.
> All patches in this set are:
> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
>=20
> A few requires some trivial issues fixed. They can be fixed while
> applying.
>=20
> I consider the patch-set ready to go in and I expect you to commit=20
> them.

Great! Thanks!

-Paul

> 	Sam
>=20
>>  ---
>>   drivers/gpu/drm/ingenic/ingenic-drm.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>>  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c=20
>> b/drivers/gpu/drm/ingenic/ingenic-drm.c
>>  index deb37b4a8e91..606d8acb0954 100644
>>  --- a/drivers/gpu/drm/ingenic/ingenic-drm.c
>>  +++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
>>  @@ -386,7 +386,7 @@ static void=20
>> ingenic_drm_plane_atomic_update(struct drm_plane *plane,
>>   		addr =3D drm_fb_cma_get_gem_addr(state->fb, state, 0);
>>   		width =3D state->src_w >> 16;
>>   		height =3D state->src_h >> 16;
>>  -		cpp =3D state->fb->format->cpp[plane->index];
>>  +		cpp =3D state->fb->format->cpp[0];
>>=20
>>   		priv->dma_hwdesc->addr =3D addr;
>>   		priv->dma_hwdesc->cmd =3D width * height * cpp / 4;
>>  --
>>  2.27.0



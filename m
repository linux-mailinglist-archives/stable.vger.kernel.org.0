Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C7A1D67F0
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 14:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgEQMT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 08:19:27 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:45644 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgEQMT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 08:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1589717965; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6rR31/j2rzqBrfWiu7P6GCD7jhwshKtwnMGtC/OSLY=;
        b=fuS89dnmSKIjpFcz/qNlJ+E8jHHaHdPlWnM24ibfuN+m1Jqhubn8n0Bh4nKT4jncckq/lQ
        FWcQUBihGzB60pDmo3T87kL/WrnWkNYFcrYwRsupHAJEDdKNKUTvdCTZgau7p1pudvpXTE
        gum5raRCQxfIwdDXQNnqai/sCrm6VPk=
Date:   Sun, 17 May 2020 14:19:14 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 04/12] gpu/drm: ingenic: Fix bogus crtc_atomic_check
 callback
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, od@zcrc.me, dri-devel@lists.freedesktop.org
Message-Id: <286HAQ.VQDCISW6S4DW2@crapouillou.net>
In-Reply-To: <20200517061737.GC609600@ravnborg.org>
References: <20200516215057.392609-1-paul@crapouillou.net>
        <20200516215057.392609-4-paul@crapouillou.net>
        <20200517061737.GC609600@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sam,

Le dim. 17 mai 2020 =E0 8:17, Sam Ravnborg <sam@ravnborg.org> a =E9crit :
> On Sat, May 16, 2020 at 11:50:49PM +0200, Paul Cercueil wrote:
>>  The code was comparing the SoC's maximum height with the mode's=20
>> width,
>>  and vice-versa. D'oh.
>>=20
>>  Cc: stable@vger.kernel.org # v5.6
>>  Fixes: a7c909b7c037 ("gpu/drm: ingenic: Check for display size in=20
>> CRTC atomic check")
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>=20
> Looks correct.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Pushed to drm-misc-fixes, thanks for the review.

-Paul

>>  ---
>>=20
>>  Notes:
>>      This patch was previously sent standalone.
>>      I marked it as superseded in patchwork.
>>      Nothing has been changed here.
>>=20
>>   drivers/gpu/drm/ingenic/ingenic-drm.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>>  diff --git a/drivers/gpu/drm/ingenic/ingenic-drm.c=20
>> b/drivers/gpu/drm/ingenic/ingenic-drm.c
>>  index 632d72177123..0c472382a08b 100644
>>  --- a/drivers/gpu/drm/ingenic/ingenic-drm.c
>>  +++ b/drivers/gpu/drm/ingenic/ingenic-drm.c
>>  @@ -330,8 +330,8 @@ static int ingenic_drm_crtc_atomic_check(struct=20
>> drm_crtc *crtc,
>>   	if (!drm_atomic_crtc_needs_modeset(state))
>>   		return 0;
>>=20
>>  -	if (state->mode.hdisplay > priv->soc_info->max_height ||
>>  -	    state->mode.vdisplay > priv->soc_info->max_width)
>>  +	if (state->mode.hdisplay > priv->soc_info->max_width ||
>>  +	    state->mode.vdisplay > priv->soc_info->max_height)
>>   		return -EINVAL;
>>=20
>>   	rate =3D clk_round_rate(priv->pix_clk,
>>  --
>>  2.26.2
>>=20
>>  _______________________________________________
>>  dri-devel mailing list
>>  dri-devel@lists.freedesktop.org
>>  https://lists.freedesktop.org/mailman/listinfo/dri-devel



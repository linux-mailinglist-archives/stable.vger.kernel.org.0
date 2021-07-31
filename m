Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382B83DC4C2
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 10:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhGaICl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 04:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhGaICk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Jul 2021 04:02:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1732D60F00;
        Sat, 31 Jul 2021 08:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627718554;
        bh=SL+zQtOluR7oaGk9b/26gphQiXSwy44s+7eTk/8jqE8=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Hl18wsfgtF2Gq3RrkX9EllLmSfNnKiC5zlk0Y17/J3lxPV2ywUg5ZDivQOaBCuHkL
         sMzGgzHbMdSmHte1sibFIlKFV/hE57qej/e0BllNpxwmIfiKdsyNaWOLYu8WSz4bfi
         PeIuLMJ8amOAOvAET08bf3ioMNzPzDmx2L64C34Iny2tShK8jcoYN8GhqGFsQ1DYsD
         5oyXPm9vJI98Lsgdajj+n8HkzCUcwjI7v0llxFFxXbZUZimRISzUP/SlDt3sFj55ng
         MCUjLu8qk7U6cEjVs+YYyooggKY+QhEgBIjFhRfojE8lusAlDUVIc+jPGxIDLde8Hh
         nq44MvaJPKy7g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210721224056.3035016-1-bjorn.andersson@linaro.org>
References: <20210721224056.3035016-1-bjorn.andersson@linaro.org>
Subject: Re: [PATCH v2] clk: qcom: gdsc: Ensure regulator init state matches GDSC state
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Mike Tipton <mdtipton@codeaurora.org>,
        Taniya Das <tdas@codeaurora.org>, Vinod Koul <vkoul@kernel.org>
Date:   Sat, 31 Jul 2021 01:02:31 -0700
Message-ID: <162771855184.714452.5922758777501573850@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Bjorn Andersson (2021-07-21 15:40:56)
> As GDSCs are registered and found to be already enabled gdsc_init()
> ensures that 1) the kernel state matches the hardware state, and 2)
> votable GDSCs are properly enabled from this master as well.
>=20
> But as the (optional) supply regulator is enabled deep into
> gdsc_toggle_logic(), which is only executed for votable GDSCs the
> kernel's state of the regulator might not match the hardware. The
> regulator might be automatically turned off if no other users are
> present or the next call to gdsc_disable() would cause an unbalanced
> regulator_disable().
>=20
> But as the votable case deals with an already enabled GDSC, most of
> gdsc_enable() and gdsc_toggle_logic() can be skipped. Reducing it to
> just clearing the SW_COLLAPSE_MASK and enabling hardware control allow
> us to simply call regulator_enable() in both cases.
>=20
> The enablement of hardware control seems to be an independent property
> from the GDSC being enabled, so this is moved outside that conditional
> segment.
>=20
> Lastly, as the propagation of ALWAY_ON to GENPD_FLAG_ALWAYS_ON needs to
> happen regardless of the initial state this is grouped together with the
> other sc->pd updates at the end of the function.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 37416e554961 ("clk: qcom: gdsc: Handle GDSC regulator supplies")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---

I was hoping someone from qcom would review it. I'll take a look in the
next couple of days and probably throw it on clk-fixes for the next rc.

-Stephen

>=20
> Changes since v1:
> - Refactored into if (on) else if (ALWAYS_ON) style
> - Extracted relevant parts of gdsc_enable() to call under VOTABLE
> - Turn on hwctrl if requested for non-votable gdscs
>=20
>  drivers/clk/qcom/gdsc.c | 54 +++++++++++++++++++++++++++--------------
>  1 file changed, 36 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
> index 51ed640e527b..4ece326ea233 100644
> --- a/drivers/clk/qcom/gdsc.c
> +++ b/drivers/clk/qcom/gdsc.c
> @@ -357,27 +357,43 @@ static int gdsc_init(struct gdsc *sc)
>         if (on < 0)
>                 return on;
> =20
> -       /*
> -        * Votable GDSCs can be ON due to Vote from other masters.
> -        * If a Votable GDSC is ON, make sure we have a Vote.
> -        */
> -       if ((sc->flags & VOTABLE) && on)
> -               gdsc_enable(&sc->pd);
> +       if (on) {
> +               /* The regulator must be on, sync the kernel state */
> +               if (sc->rsupply) {
> +                       ret =3D regulator_enable(sc->rsupply);
> +                       if (ret < 0)
> +                               return ret;
> +               }
> =20
> -       /*
> -        * Make sure the retain bit is set if the GDSC is already on, oth=
erwise
> -        * we end up turning off the GDSC and destroying all the register
> -        * contents that we thought we were saving.
> -        */
> -       if ((sc->flags & RETAIN_FF_ENABLE) && on)
> -               gdsc_retain_ff_on(sc);
> +               /*
> +                * Votable GDSCs can be ON due to Vote from other masters.
> +                * If a Votable GDSC is ON, make sure we have a Vote.
> +                */
> +               if (sc->flags & VOTABLE) {
> +                       ret =3D regmap_update_bits(sc->regmap, sc->gdscr,
> +                                                SW_COLLAPSE_MASK, val);
> +                       if (ret)
> +                               return ret;
> +               }
> +
> +               /* Turn on HW trigger mode if supported */
> +               if (sc->flags & HW_CTRL) {
> +                       ret =3D gdsc_hwctrl(sc, true);
> +                       if (ret < 0)
> +                               return ret;
> +               }
> =20
> -       /* If ALWAYS_ON GDSCs are not ON, turn them ON */
> -       if (sc->flags & ALWAYS_ON) {
> -               if (!on)
> -                       gdsc_enable(&sc->pd);
> +               /*
> +                * Make sure the retain bit is set if the GDSC is already=
 on,
> +                * otherwise we end up turning off the GDSC and destroyin=
g all
> +                * the register contents that we thought we were saving.
> +                */
> +               if (sc->flags & RETAIN_FF_ENABLE)
> +                       gdsc_retain_ff_on(sc);
> +       } else if (sc->flags & ALWAYS_ON) {
> +               /* If ALWAYS_ON GDSCs are not ON, turn them ON */
> +               gdsc_enable(&sc->pd);
>                 on =3D true;
> -               sc->pd.flags |=3D GENPD_FLAG_ALWAYS_ON;
>         }
> =20
>         if (on || (sc->pwrsts & PWRSTS_RET))
> @@ -385,6 +401,8 @@ static int gdsc_init(struct gdsc *sc)
>         else
>                 gdsc_clear_mem_on(sc);
> =20
> +       if (sc->flags & ALWAYS_ON)
> +               sc->pd.flags |=3D GENPD_FLAG_ALWAYS_ON;
>         if (!sc->pd.power_off)
>                 sc->pd.power_off =3D gdsc_disable;
>         if (!sc->pd.power_on)
> --=20
> 2.29.2
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FC23B6E4C
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 08:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhF2GhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 02:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231881AbhF2GhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 02:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 121CE61D6C;
        Tue, 29 Jun 2021 06:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624948494;
        bh=1wm++hlHTVukb+VtFq7EOvTZHLGCKQZBOWjLY6ItRcc=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=M20bEs6wMM/pZeO435Hna09xr8H1RtIw+lLR9t5YVrvKtAjKbWd1WZjGP5gq5wuBZ
         bbhhSJquwXSd03d6n80E7O71mSdDwcG7TCT5QAFBWZSKLRMQDUX44Sj2Rud5nWD4PS
         8QtPeWmR3hdj8WoPKNWwqUReBatfBfqqr4Wrcyq2J2aVcXv5UmkVXRcAcFgNMchide
         pAN1Yjpq6+T1p9F6D+uhosqThNcdsUS4SrfR3Aq9RRBMaGGCazeHN4aa1sq0YFyA5M
         qQBY54W2PEQaPo1l1y9fn53qBJdJOOqTfuSDSt97QsbmhJwjt3Ek6LAp8pURBOeR6W
         1N7M7buK9aLEA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210625225414.1318338-1-bjorn.andersson@linaro.org>
References: <20210625225414.1318338-1-bjorn.andersson@linaro.org>
Subject: Re: [PATCH] clk: qcom: gdsc: Ensure regulator init state matches GDSC state
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmitry.baryshkov@linaro.org
Date:   Mon, 28 Jun 2021 23:34:52 -0700
Message-ID: <162494849279.2516444.9302337933628102536@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Bjorn Andersson (2021-06-25 15:54:14)
> As GDSCs are registered and found to be already enabled
> gdsc_toggle_logic() will be invoked for votable GDSCs and ensure that
> the vote is matching the hardware state. Part of this the related
> regulator will be enabled.
>=20
> But for non-votable GDSCs the regulator and GDSC status will be out of
> sync and as the GDSC is later disabled regulator_disable() will face an
> unbalanced enable-count, or something might turn off the supply under
> the feet of the GDSC.
>=20
> So ensure that the regulator is enabled even for non-votable GDSCs.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 37416e554961 ("clk: qcom: gdsc: Handle GDSC regulator supplies")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/clk/qcom/gdsc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
> index 51ed640e527b..f7e7759cdb90 100644
> --- a/drivers/clk/qcom/gdsc.c
> +++ b/drivers/clk/qcom/gdsc.c
> @@ -359,10 +359,17 @@ static int gdsc_init(struct gdsc *sc)
> =20
>         /*
>          * Votable GDSCs can be ON due to Vote from other masters.
> -        * If a Votable GDSC is ON, make sure we have a Vote.
> +        * If a Votable GDSC is ON, make sure we have a Vote. If
> +        * non-votable, ensure that the supply is kept enabled (as
> +        * is done by gdsc_enable).
>          */
> -       if ((sc->flags & VOTABLE) && on)
> +       if ((sc->flags & VOTABLE) && on) {
>                 gdsc_enable(&sc->pd);
> +       } else if (on) {
> +               ret =3D regulator_enable(sc->rsupply);
> +               if (ret < 0)
> +                       return ret;

Looking at this makes me think we've messed something up with
gdsc_enable() being called or cherry-picking the regulator enable (and
other stuff in this gdsc_init()) out of the enable path. Maybe we should
have a followup patch that replaces the gdsc_enable() with
gdsc_toggle_logic(sc, GDSC_ON) so that we know it isn't doing anything
else during init like asserting a reset when presumably all we want to
do is toggle the enable bit to assert our vote.

And I notice that we already call gdsc_toggle_logic() in gdsc_init(), so
then we'll have a double regulator_enable() in the case of PWRSTS_ON?
And then if the flag is ALWAYS_ON we'll call regulator_enable() yet
again, but luckily only if it isn't on initially, phew! This code is
quite twisted.

It would be super nice to make it more like

	if (on) {
		/* It was on in hardware, sync kernel state */
		regulator_enable();

		if (votable)
			write bit, why do any wait?

		if (retain ff)
			write bit
	} else if (always_on) {
		/* Force on */
		gdsc_enable();
		on =3D true;
	}

	if (on || ...)

> +       }
> =20
>         /*
>          * Make sure the retain bit is set if the GDSC is already on, oth=
erwise

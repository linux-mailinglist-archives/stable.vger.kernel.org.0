Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174E8475FEB
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhLORyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:54:44 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58718 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbhLORyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:54:44 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C55791C0B98; Wed, 15 Dec 2021 18:54:42 +0100 (CET)
Date:   Wed, 15 Dec 2021 18:54:41 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH 4.19 29/74] clk: qcom: regmap-mux: fix parent clock lookup
Message-ID: <20211215175440.GA10909@duo.ucw.cz>
References: <20211213092930.763200615@linuxfoundation.org>
 <20211213092931.784850569@linuxfoundation.org>
 <20211215091623.GA15796@amd>
 <67a77fc5-6db4-ba26-cacb-9758336ad074@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <67a77fc5-6db4-ba26-cacb-9758336ad074@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The function mux_get_parent() uses qcom_find_src_index() to find the
> > > parent clock index, which is incorrect: qcom_find_src_index() uses src
> > > enum for the lookup, while mux_get_parent() should use cfg field (whi=
ch
> > > corresponds to the register value). Add qcom_find_cfg_index() function
> > > doing this kind of lookup and use it for mux parent lookup.
> >=20
> > This appears to have problems with error handling.
> >=20
> > > +++ b/drivers/clk/qcom/clk-regmap-mux.c
> > > @@ -36,7 +36,7 @@ static u8 mux_get_parent(struct clk_hw *
> > >   	val &=3D mask;
> > >   	if (mux->parent_map)
> > > -		return qcom_find_src_index(hw, mux->parent_map, val);
> > > +		return qcom_find_cfg_index(hw, mux->parent_map, val);
> > >   	return val;
> > >   }
> >=20
> > So this returns u8.
> >=20
> > > +int qcom_find_cfg_index(struct clk_hw *hw, const struct parent_map *=
map, u8 cfg)
> > > +{
> > > +	int i, num_parents =3D clk_hw_get_num_parents(hw);
> > > +
> > > +	for (i =3D 0; i < num_parents; i++)
> > > +		if (cfg =3D=3D map[i].cfg)
> > > +			return i;
> > > +
> > > +	return -ENOENT;
> > > +}
> >=20
> > In case of error, -ENOENT will be cast to u8 in caller. I don't
> > believe that is correct.
>=20
> Unfortunately there is no way to return proper error code from
> clk_ops->get_parent() callback. However returning -ENOENT would translate=
 to
> 254. Then clk_core_get_parent_by_index() would determine that there is no
> such parent and return NULL. A call to clk_set_parent would reparent the
> clock.

Yeah, I guess it happens to work.

> Returning some sensible default (e.g. 0) would be much worse, since then =
the
> clock subsystem would assume that the clock has correct parent. A call to
> clk_set_parent would always result in ops->set_parent() call, reparenting
> the clock correctly.

Well ~0 would be sensible in this case. And a comment with explanation.

> Most probably it would be correct to make ops->get_parent() return int
> instead of u8 (either an index or an -ERROR). However this was out of sco=
pe
> for this patch.

Yep, I believe that should happen, long-term.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYbor4AAKCRAw5/Bqldv6
8uxpAKCsBhfEeIr2SDoaCwDe7fv+dnbuwACgrZi/2bZGHKAjmv7On4EfwiTdBpg=
=2beZ
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--

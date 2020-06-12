Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19761F7835
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 15:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgFLNAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 09:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgFLNAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 09:00:07 -0400
Received: from localhost (p54b33104.dip0.t-ipconnect.de [84.179.49.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 228A520801;
        Fri, 12 Jun 2020 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591966806;
        bh=p9zdw6Ix408GDSOOW0UAhlBPPpxUZXF56TDRkRrBo50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zjGYScyOOsAy3gVeFKrd5vkNkraV2RnlZRh01K85GpQCvcot6I/QFrzcOqyNfKGkI
         6G4HIXXSnYdkiTLXeyhxcv+bm0QFVYyWnMWwBEZBRVE6hDKqa3YcDKjdDzqW4b6z7y
         GCptfpJ3oBZpi1ggPlzNz6s/wNWA81iJEkjSk+IQ=
Date:   Fri, 12 Jun 2020 15:00:03 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612130003.GB18557@ninjato>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
 <20200612102113.GA26056@pi3>
 <20200612103149.2onoflu5qgwaooli@pengutronix.de>
 <20200612103949.GB26056@pi3>
 <20200612115116.GA18557@ninjato>
 <859e8211-2c56-8dd5-d6fb-33e4358e4128@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <859e8211-2c56-8dd5-d6fb-33e4358e4128@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 12, 2020 at 02:18:06PM +0200, Marc Kleine-Budde wrote:
> On 6/12/20 1:51 PM, Wolfram Sang wrote:
> >=20
> >> This basically kills the concept of devm for interrupts. Some other
> >=20
> > It only works when you can ensure you have all interrupts disabled (and
> > none pending) in remove() or the error paths of probe() etc.
>=20
> But when requesting the interrupt as shared the interrupt handler can get=
 called
> any time, even if you have disabled the IRQ source in your IP core....The=
 shared
> IRQ debug code tests this.

Yes, so you'd need something like

	if (clks_are_off)
		return IRQ_NONE;

or skip devm_ for interrupts and handle it manually. (IIRC the input
subsystem really frowns upon devm + irqs for such reasons)

D'accord?


--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7jfE8ACgkQFA3kzBSg
KbYU2g//YH252FclavZQfOCs9H4QzD8SUrVlAuUOYIo2XLzjN9/S+n1K4LakWCz8
J6zxoyCp/gTkEqkY1Y0vyvgPCGlO49Cy4DCNgUDEz9fHP1hK5d6QTb9DZS62qGe0
mvVSm+21eLSHPO0H2v6pT+eP8bhQUiHIEWs8yxTSbI1QM8VysbSFJXx3rgwSb7s5
Os5hOy6/4O5rn9StieglVEZ2CNl0ZoAqpvOHPziGkhlYB6XzfLRLjYY+9tDOcM+d
Eza2rjTYPrm3v1nqsbNz3/44PVjgyMMwuHehVllaSVfkCsAUiBCnnmwZXNr1N4oT
c4MNBQAInQw0jqDesVX+Y+YTbaa8McEZFs6giB6C6wb+Cg3Y+dILxtFdtZO6zg5+
RTEPjFl+pOUwqj8CwxQ3DPJPpxnKTssp/+lnVNMmFxqAqjk5Xf9xHRIYlexPi9Ai
GJfwOLCo5sOjAnCqFG8n6PYdyCDbmzmBw58rqlL5MKEKzAchbbwKQVLiVgBthVw3
7lj2JUWrPEBUVMMO7DGulNaz0mvfXhRoNfbyTp373rcN03kRLQoNFHSYIZTBLg+f
Z4JVGFjSK8Thf/0kFMWKakmmRvW5u0isnMwSbPIE4cuL6tdkrLadPpPYlscPL+wt
3dqTVphas2XIcGTH4/PLXQj1uZnxFU12ST1WP0TBZXY77Ydvw1E=
=key/
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F21821656
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 11:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfEQJdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 05:33:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33524 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbfEQJdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 05:33:44 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 2A2F380398; Fri, 17 May 2019 11:33:32 +0200 (CEST)
Date:   Fri, 17 May 2019 11:33:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH 4.19 042/113] ocelot: Dont sleep in atomic context
 (irqs_disabled())
Message-ID: <20190517093341.GA18565@amd>
References: <20190515090652.640988966@linuxfoundation.org>
 <20190515090656.813206864@linuxfoundation.org>
 <20190517081642.GC17012@amd>
 <VI1PR04MB488053E08D56380DBB6EFB05960B0@VI1PR04MB4880.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <VI1PR04MB488053E08D56380DBB6EFB05960B0@VI1PR04MB4880.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >On Wed 2019-05-15 12:55:33, Greg Kroah-Hartman wrote:
> >> [ Upstream commit a8fd48b50deaa20808bbf0f6685f6f1acba6a64c ]
> >>
> >> Preemption disabled at:
> >>  [<ffff000008cabd54>] dev_set_rx_mode+0x1c/0x38
> >>  Call trace:
> >>  [<ffff00000808a5c0>] dump_backtrace+0x0/0x3d0
> >>  [<ffff00000808a9a4>] show_stack+0x14/0x20
> >>  [<ffff000008e6c0c0>] dump_stack+0xac/0xe4
> >>  [<ffff0000080fe76c>] ___might_sleep+0x164/0x238
> >>  [<ffff0000080fe890>] __might_sleep+0x50/0x88
> >>  [<ffff0000082261e4>] kmem_cache_alloc+0x17c/0x1d0
> >>  [<ffff000000ea0ae8>] ocelot_set_rx_mode+0x108/0x188
> >[mscc_ocelot_common]
> >>  [<ffff000008cabcf0>] __dev_set_rx_mode+0x58/0xa0
> >>  [<ffff000008cabd5c>] dev_set_rx_mode+0x24/0x38
> >>
> >> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> >
> >Is it right fix? Warning is gone, but now allocation is more likely to
> >fail, causing mc_add() to fail under memory pressure.
> >
>=20
> So far this contributes to fixing a kernel hang issue, seen occasionally
> when the switch interfaces were brought up.
> Other than that I would look into improving this code.
> It looks suboptimal at least.  Do we really need to allocate whole
> struct netdev_hw_addr elements? Can the allocation size be reduced?
> What about pre-allocating enough room for ha elements outside the
> atomic context (set_rx_mode() in this case)?

Pre-allocating the elements sounds like a obvious solution, yes.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzef/UACgkQMOfwapXb+vJjGgCgstxXfIUGi5SKgeRmDcJmlcjT
VUUAn3UEZsjB0dizYH96Q9/AOiF/k8I2
=PdRN
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--

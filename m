Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDE82152B
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbfEQIQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 04:16:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59751 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfEQIQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 04:16:45 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 4A918803AC; Fri, 17 May 2019 10:16:33 +0200 (CEST)
Date:   Fri, 17 May 2019 10:16:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 042/113] ocelot: Dont sleep in atomic context
 (irqs_disabled())
Message-ID: <20190517081642.GC17012@amd>
References: <20190515090652.640988966@linuxfoundation.org>
 <20190515090656.813206864@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <20190515090656.813206864@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-05-15 12:55:33, Greg Kroah-Hartman wrote:
> [ Upstream commit a8fd48b50deaa20808bbf0f6685f6f1acba6a64c ]
>=20
> Preemption disabled at:
>  [<ffff000008cabd54>] dev_set_rx_mode+0x1c/0x38
>  Call trace:
>  [<ffff00000808a5c0>] dump_backtrace+0x0/0x3d0
>  [<ffff00000808a9a4>] show_stack+0x14/0x20
>  [<ffff000008e6c0c0>] dump_stack+0xac/0xe4
>  [<ffff0000080fe76c>] ___might_sleep+0x164/0x238
>  [<ffff0000080fe890>] __might_sleep+0x50/0x88
>  [<ffff0000082261e4>] kmem_cache_alloc+0x17c/0x1d0
>  [<ffff000000ea0ae8>] ocelot_set_rx_mode+0x108/0x188 [mscc_ocelot_common]
>  [<ffff000008cabcf0>] __dev_set_rx_mode+0x58/0xa0
>  [<ffff000008cabd5c>] dev_set_rx_mode+0x24/0x38
>=20
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")

Is it right fix? Warning is gone, but now allocation is more likely to
fail, causing mc_add() to fail under memory pressure.

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzebeoACgkQMOfwapXb+vJ/CwCfa6vQLNtyTZ0M7WK1NylWwZSv
AwoAniRk1HNlXKY50kn9UDlJv9mqDPtX
=KwS2
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--

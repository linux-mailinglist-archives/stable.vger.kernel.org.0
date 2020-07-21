Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7A9227EDB
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgGUL3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 07:29:11 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52022 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbgGUL3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 07:29:11 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D56031C0BE5; Tue, 21 Jul 2020 13:29:08 +0200 (CEST)
Date:   Tue, 21 Jul 2020 13:29:08 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 041/133] Revert "usb/ohci-platform: Fix a warning
 when hibernating"
Message-ID: <20200721112908.GA17950@duo.ucw.cz>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152805.704517976@linuxfoundation.org>
 <20200720210722.GA11552@amd>
 <20200721012943.GA406581@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20200721012943.GA406581@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > >After some investigations, we concluded the following:
> > > > - the issue does not exist in vanilla v5.8-rc4+
> > > > - [bisecting shows that] the panic on v4.14.186 is caused by the la=
ck
> > > >   of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
> > > >   link support"). Getting evidence for that is easy. Reverting
> > > >   987351e1ea7772 in vanilla leads to a similar backtrace [2].
> > > >
> > > >Questions:
> > > > - Backporting 987351e1ea7772 ("phy: core: Add consumer device
> > > >   link support") to v4.14.187 looks challenging enough, so probably=
 not
> > > >   worth it. Anybody to contradict this?
> >=20
> > I'm not sure about v4.14.187, but backport to v4.19 is quite simple
> > (just ignore single non-existing file) and passes basic testing.
> >=20
> > Would that be better solution for 4.19 and newer?
>=20
> If Eugeniu could confirm that doing so on 4.19+ works for him, sure.

He did:

Message-ID: <20200721065054.GA8290@lxhi-065.adit-jv.com>
Technically yes. Backporting 987351e1ea7772 to v4.19.x avoids the panic.
=2E..
FWIW I confirm that:
* setup [A] leads to the issue reported in [C]
* setup [B] resolves the issue reported in [C]

[A] v4.19 + 16bdc04cc98 + 1cb3b0095c3 + 79112cc3c29f
[B] v4.19 + 16bdc04cc98 + 1cb3b0095c3 + 79112cc3c29f + 987351e1ea7
[C] https://lore.kernel.org/linux-usb/20200709070023.GA18414@lxhi-065.adit-=
jv.com/


Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXxbRhAAKCRAw5/Bqldv6
8hJ+AKDAFdFixJDxmhT3TZraQIz6vlnJBwCgwNhXgRjEqVH5eG8Xi+xbJOfHHvY=
=6niu
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--

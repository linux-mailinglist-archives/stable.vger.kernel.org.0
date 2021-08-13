Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3423EB356
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238937AbhHMJbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:31:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49496 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbhHMJbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:31:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 052401C0B76; Fri, 13 Aug 2021 11:31:05 +0200 (CEST)
Date:   Fri, 13 Aug 2021 11:31:04 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jason@jlekstrand.net,
        Jonathan Gray <jsg@jsg.id.au>
Subject: Determining corresponding mainline patch for stable patches Re:
 [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in eb_parse()
Message-ID: <20210813093104.GA20799@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
 <20210811072843.GC10829@duo.ucw.cz>
 <YROARN2fMPzhFMNg@kroah.com>
 <20210811122702.GA8045@duo.ucw.cz>
 <YRPLbV+Dq2xTnv2e@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <YRPLbV+Dq2xTnv2e@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > From: Jonathan Gray <jsg@jsg.id.au>
> > > > >=20
> > > > > The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 =
in
> > > > > 6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it sho=
uld
> > > > > have leading to 'batch' being used uninitialised.  The 5.13 backp=
ort and
> > > > > the mainline commit did not remove the portion this patch adds ba=
ck.
> > > >=20
> > > > This patch has no upstream equivalent, right?
> > > >=20
> > > > Which is okay -- it explains it in plain english, but it shows that
> > > > scripts should not simply search for anything that looks like SHA a=
nd
> > > > treat it as upsteam commit it.
> > >=20
> > > Sounds like you have a broken script if you do it that way.
> >=20
> > That is what you told me to do!
> >=20
> > https://lore.kernel.org/stable/YQEvUay+1Rzp04SO@kroah.com/
>=20
> Yes, which is fine for matching sha1 values.

I'd really like reliable / automated way to tell upstream commit from
given -stable commit.=20

> > I would happily adapt my script, but there's no
> > good/documented/working way to determine upstream commit given -stable
> > commit.
> >=20
> > If we could agree on
> >=20
> > Commit: (SHA)
> >=20
> > in the beggining of body, that would be great.
> >=20
> > Upstream: (SHA)
> >=20
> > in sign-off area would be even better.
>=20
> What exactly are you trying to do when you find a sha1?  For some reason
> my scripts work just fine with a semi-free-form way that we currently
> have been doing this for the past 17+ years.  What are you attempting to
> do that requires such a fixed format?

Is there any problem having a fixed format? You are producing -stable
kernels, so you are not the one needing such functionality.

Anyway... We do reviews here, and we review patches on multiple
branches (4.4, 4.19, 5.10). So I'm using scripts to group backports of
the same patch together, for easier review and to flag patches that do
not have upstream equivalent for extra review. (Example of the review
file below)

There are other uses. When we were creating 5.10-cip branch, we used
automatic scripts to verify that all patches from 4.19-cip are
included in 5.10-cip. Determining mainline patch for given commit was
essential for that.

Other use was actually suggested by you: you jokingly wanted to
replace CVE-XXX with mainline commit IDs. But that needs reliable way
to determine upstream commit from stable commit to work nicely.
(And yes, we are actually trying to maintain the mapping, see for
example
https://gitlab.com/cip-project/cip-kernel/cip-kernel-sec/-/blob/master/issu=
es/CVE-2016-10147.yml )

Best regards,
								Pavel


a |150198841 135cbd o: 5.10| spi: imx: mx51-ecspi: Reinstate low-speed CONF=
IGREG delay
a |8916a8606 53ca18 o: 5.10| spi: imx: mx51-ecspi: Fix low-speed CONFIGREG =
delay calculation
v |2c32af963 5c0424 o: 5.10| scsi: sr: Return correct event when media even=
t code is 3
v |671402b0e 5c0424 o: 4.19| scsi: sr: Return correct event when media even=
t code is 3
a |a78c94304 5c0424 o: 4.4| scsi: sr: Return correct event when media event=
 code is 3
v |9acc1f082 c592b4 o: 5.10| media: videobuf2-core: dequeue if start_stream=
ing fails
v |8f33cda2c c592b4 o: 4.19| media: videobuf2-core: dequeue if start_stream=
ing fails
a |f18813d9c c592b4 .: 4.4| media: videobuf2-core: dequeue if start_streami=
ng fails
a |da6c08058 36862c .: 5.10| ARM: dts: stm32: Disable LAN8710 EDPD on DHCOM
a |630677821 15f68f .: 5.10| ARM: dts: stm32: Fix touchscreen IRQ line assi=
gnment on DHCOM
a |f84d7d425 7199dd .: 5.10| dmaengine: imx-dma: configure the generic DMA =
type to make it work
a |e0188a8de d51c59 o: 5.10| net, gro: Set inner transport header offset in=
 tcp/udp GRO hook
a |72795b111 e11e86 .: 5.10| net: dsa: sja1105: overwrite dynamic FDB entri=
es with static ones in .port_fdb_add
a |0c548fae4 6c5fc1 .: 5.10| net: dsa: sja1105: invalidate dynamic FDB entr=
ies learned concurrently with statically added ones


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRY72AAKCRAw5/Bqldv6
8kAKAKCwygxPhJPdNZ0z1NKOfIYKJ8r5XwCfSMmPoyForoYtVTOV7+d9glOR8HE=
=OYaB
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--

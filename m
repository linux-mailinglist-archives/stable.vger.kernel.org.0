Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9024D41D538
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348885AbhI3IJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 04:09:44 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:49613 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348910AbhI3IJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 04:09:43 -0400
Received: (Authenticated sender: thomas.perrot@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 48D641BF207;
        Thu, 30 Sep 2021 08:07:59 +0000 (UTC)
Message-ID: <54c063613fe63282a1c26b312c772e89b662eae6.camel@bootlin.com>
Subject: Re: [PATCH] bus: mhi: pci_generic: increase timeout value for
 operations to 24000ms
From:   Thomas Perrot <thomas.perrot@bootlin.com>
To:     Aleksander Morgado <aleksander@aleksander.es>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        hemantk@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>,
        stable <stable@vger.kernel.org>
Date:   Thu, 30 Sep 2021 10:07:57 +0200
In-Reply-To: <CAAP7ucL1Zv6g8G0SWAjEAjr6OSVTyDmvmFkH+vMmmBwOH2=ZUQ@mail.gmail.com>
References: <20210805140231.268273-1-thomas.perrot@bootlin.com>
         <f358044a-78d0-ad63-a777-87b4b9d94745@aleksander.es>
         <73A52D61-FCAB-4A2B-BA96-0117F6942842@linaro.org>
         <CAAP7ucL1Zv6g8G0SWAjEAjr6OSVTyDmvmFkH+vMmmBwOH2=ZUQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-GLaBsdgJhSTUDVRwrQzr"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-GLaBsdgJhSTUDVRwrQzr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, 2021-09-29 at 15:17 +0200, Aleksander Morgado wrote:
> Hey Mani,
>=20
> > > > diff --git a/drivers/bus/mhi/pci_generic.c
> > > > b/drivers/bus/mhi/pci_generic.c
> > > > index 4dd1077354af..e08ed6e5031b 100644
> > > > --- a/drivers/bus/mhi/pci_generic.c
> > > > +++ b/drivers/bus/mhi/pci_generic.c
> > > > @@ -248,7 +248,7 @@ static struct mhi_event_config
> > > > modem_qcom_v1_mhi_events[] =3D {
> > > >=20
> > > > =C2=A0 static const struct mhi_controller_config
> > > > modem_qcom_v1_mhiv_config =3D {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 .max_channels =3D 128,
> > > > -=C2=A0=C2=A0=C2=A0 .timeout_ms =3D 8000,
> > > > +=C2=A0=C2=A0=C2=A0 .timeout_ms =3D 24000,
> > >=20
> > >=20
> > > This modem_qcom_v1_mhiv_config config applies to all generic SDX24,
> > > SDX55 and SDX65 modules.
> > > Other vendor-branded SDX55 based modules in this same file (Foxconn
> > > SDX55, MV31), have 20000ms as timeout.
> > > Other vendor-branded SDX24 based modules in this same file (Quectel
> > > EM12xx), have also 20000ms as timeout.
> > > Maybe it makes sense to have a common timeout for all?
> > >=20
> >=20
> > Eventhough the baseport coming from Qualcomm for the modem chipsets
> > are same, it is possible that the vendors might have customized the
> > firmware for their own usecase. That could be the cause of the delay
> > for modem booting.
> >=20
> > So I don't think we should use the same timeout of 2400ms for all
> > modems.
> >=20
>=20
> Please note it's 24000ms what's being suggested here, not 2400ms.
>=20
> > > Thomas, is the 24000ms value taken from experimentation, or is it a
> > > safe enough value? Maybe 20000ms as in other modules would have
> > > been enough?
> > >=20

I made experimentation on a Sierra EM9190 (SDX55) engineering sample,
using a old development firmware.

So, I agree that setting the same timeout of 24000ms for all modems, is
not necessarily relevant.
However, the current default value seems too low, in view of timeouts
used on vendor-branded, then using a higher value seems relevant.

Moreover, Sierra EM919x modems use a custom controller configuration,
we are currently working on it. As our tests not being sufficiently
conclusive, so we have not yet submitted.

Best regards,
Thomas

> >=20
> > It was derived from testing I believe.
>=20
> Following your reasoning above, shouldn't this 24000ms timeout be
> applied only to the Sierra Wireless EM91xx devices (which may have
> custom firmware bits delaying the initialization a bit longer), and
> not to the generic SDX24, SDX55 and SDX65?
>=20
> If I'm not mistaken, Thomas is testing with a custom mhi_pci_generic
> entry for the EM91xx; as in
> https://forum.sierrawireless.com/t/sierra-wireless-airprime-em919x-pcie-s=
upport/24927
> .
> I'm also playing with that same entry on my own setup, but have other
> problems of my own :)
>=20
>=20
> --
> Aleksander
> https://aleksander.es

--=20
Thomas Perrot, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com


--=-GLaBsdgJhSTUDVRwrQzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQGzBAABCAAdFiEEh0B3xqajCiMDqBIhn8ALBXH+Cu0FAmFVcF0ACgkQn8ALBXH+
Cu3ITgwAkPHJvqrm6FR4/p9MLmahgWI11bVVYo/FpG2G3Yi9Ft64GcUSVj7OMdpb
pL5BSuWyHsCHCVowNhBVF2ZJyxmTLxI23PpUAVf94W1zApAvBXGeSaaV0ULXp6ay
1qkBQmxDRONqf1KRwfu3sHNjosBCUmZJZi+FsYV649RhW46JhdAnH+176UhmqPQF
lFsHVdWMBBZ4T7yL3DAm3fo99dQy036uYlmCGOa5Utp4L51E1J0c386OLJWJUHBh
ONQ8pgItLol1z4CP4fVdbVMwZ1I9FEhNfzS2rG7aET889poOSe06Jke42QK52SJh
pPh6ii7qwVql4v3IAGmEFFo04qC9Wf/OU6qW9ZuT98FSEyc+ulVkFI3/G/GOgzMS
nlQ4v0EtEZOyIwANn8seR+LuS5JyRehxXDaPNQZ5Z2bQGVIPgP5cSjcRmYUuauXB
4K5Y5q+qIa5A4KdKWZ6tDg9DnKXbE4A4pA0zIIVEH4XR1w9Qt7OI5P2OWOtShZQA
YKE2VZKY
=lA97
-----END PGP SIGNATURE-----

--=-GLaBsdgJhSTUDVRwrQzr--


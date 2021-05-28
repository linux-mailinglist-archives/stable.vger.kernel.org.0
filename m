Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA10393EFE
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 10:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhE1Ixm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 04:53:42 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51938 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbhE1Ixl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 04:53:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 629EF1C0B76; Fri, 28 May 2021 10:52:06 +0200 (CEST)
Date:   Fri, 28 May 2021 10:52:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hemant Kumar <hemantk@codeaurora.org>, quic_jhugo@quicinc.com
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
Message-ID: <20210528085205.GB28312@amd>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org>
 <20210510205650.GA17966@amd>
 <20210511061623.GA8651@thinkpad>
 <64a8ebbdc9fc7de48b25b9e2bc896d47@codeaurora.org>
 <20210524041947.GB8823@work>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <20210524041947.GB8823@work>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
> > > > >
> > > > > When clearing up the channel context after client drivers are
> > > > > done using channels, the configuration is currently not being
> > > > > reset entirely. Ensure this is done to appropriately handle
> > > > > issues where clients unaware of the context state end up calling
> > > > > functions which expect a context.
> > > >=20
> > > > > +++ b/drivers/bus/mhi/core/init.c
> > > > > @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > > > > +	u32 tmp;
> > > > > @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> > > > ...
> > > > > +	tmp =3D chan_ctxt->chcfg;
> > > > > +	tmp &=3D ~CHAN_CTX_CHSTATE_MASK;
> > > > > +	tmp |=3D (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > > > > +	chan_ctxt->chcfg =3D tmp;
> > > > > +
> > > > > +	/* Update to all cores */
> > > > > +	smp_wmb();
> > > > >  }
> > > >=20
> > > > This is really interesting code; author was careful to make sure ch=
cfg
> > > > is updated atomically, but C compiler is free to undo that. Plus, t=
his
> > > > will make all kinds of checkers angry.
> > > >=20
> > > > Does the file need to use READ_ONCE and WRITE_ONCE?
> > > >=20
> > >=20
> > > Thanks for looking into this.
> > >=20
> > > I agree that the order could be mangled between chcfg read & write and
> > > using READ_ONCE & WRITE_ONCE seems to be a good option.
> > >=20
> > > Bhaumik, can you please submit a patch and tag stable?

> > Hemant and I went over this patch and we noticed this particular functi=
on is
> > already being called with the channel mutex lock held. This would take =
care
> > of
> > the atomicity and we also probably don't need the smp_wmb() barrier as =
the
> > mutex
> > unlock will implicitly take care of it.
> >=20
>=20
> okay
>=20
> > To the point of compiler re-ordering, we would need some help to unders=
tand
> > the
> > purpose of READ_ONCE()/WRITE_ONCE() for these dependent statements:
> >=20
> > > +	tmp =3D chan_ctxt->chcfg;
> > > +	tmp &=3D ~CHAN_CTX_CHSTATE_MASK;
> > > +	tmp |=3D (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> > > +	chan_ctxt->chcfg =3D tmp;
> >=20
> > Since RMW operation means that the chan_ctxt->chcfg is copied to a local
> > variable (tmp) and the _same_ is being written back to chan_ctxt->chcfg=
, can
> > compiler reorder these dependent statements and cause a different resul=
t?
> >=20
>=20
> Well, I agree that there is a minimal guarantee with modern day CPUs on
> not breaking the order of dependent memory accesses (like here tmp
> variable is the one which gets read and written) but we want to make
> sure that this won't break on future CPUs as well. So IMO using
> READ_ONCE and WRITE_ONCE adds extra level of safety.

Umm, if this is protected by locking, already, we really should not
add READ_ONCE. Code should be clear, not having "extra safety levels".

I assumed it was running unlocked due to the way it was written.

Best regards,
    	       	    	      	     	 	       	      Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCwrzUACgkQMOfwapXb+vKgiQCgm7FALvKqkJTbtsA7LqWcF46c
5fgAoI3mX891I2KyvesWYo9xN1pj+nW1
=GsyN
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--

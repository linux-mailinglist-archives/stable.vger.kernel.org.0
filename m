Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB7A029A
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 15:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfH1NFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 09:05:01 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:51402 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfH1NFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 09:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=naopO757xIYN06SYLPcZIJpP1zvJUPLNlmQXoJgdMJo=; b=QkB3853UYCR3GwckjGXxv+l6k
        75NoGa0F43e50JSX07TJ9SKzXf8lVTc8HFG/x6T3PdVYGUOkhoRIIDcVHEn9efcJUlC0n+L5lGjUs
        Ed2ri4419SpfiKl3s6B7G2iMcoS8KvC/bP7SWUZ6YDC4+wo+fmLF+tgoNO4pjGa4PmmHU=;
Received: from ypsilon.sirena.org.uk ([2001:470:1f1d:6b5::7])
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1i2xdA-0004Cl-MH; Wed, 28 Aug 2019 13:04:56 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 2D0E72742B61; Wed, 28 Aug 2019 14:04:54 +0100 (BST)
Date:   Wed, 28 Aug 2019 14:04:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Ricard Wanderlof <ricard.wanderlof@axis.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.2 040/123] ASoC: Fail card instantiation if DAI
 format setup fails
Message-ID: <20190828130454.GH4298@sirena.co.uk>
References: <20190814021047.14828-1-sashal@kernel.org>
 <20190814021047.14828-40-sashal@kernel.org>
 <20190814092213.GC4640@sirena.co.uk>
 <20190826013515.GG5281@sasha-vm>
 <20190827110014.GD23391@sirena.co.uk>
 <20190828021311.GV5281@sasha-vm>
 <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1908280859060.5799@lnxricardw1.se.axis.com>
X-Cookie: Oatmeal raisin.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2019 at 09:07:17AM +0200, Ricard Wanderlof wrote:
> On Wed, 28 Aug 2019, Sasha Levin wrote:
> > On Tue, Aug 27, 2019 at 12:00:14PM +0100, Mark Brown wrote:

> > > If anyone ran into this on the older kernel and fixed or worked
> > > around it locally there's a reasonable chance this will then
> > > break what they're doing.  The patch itself is perfectly fine but

I should also have added that there's also the potential that things are
just working as they are and that detecting errors will cause new
failures.

> > But there's not much we can do here. We can't hold off on fixing
> > breakage such as this because existing users have workarounds for this.

If people are running into problems here then they just don't have
working audio; if they're shipping with that presumably they either
don't mind about it or have done something to fix it.  Either way this
patch won't by itself give anyone working audio that didn't have it
before.

> > Are we breaking kernel ABI with this patch then?

> > And what about new users? We'll let them get hit by the issue and
> > develop their own workarounds?

Hopefully we don't have too many new users adopting the older stables
you want to backport to...  in any case this patch just makes the error
reporting more forceful, it won't actually fix the issue it's reporting.

> My $0.02 here: In my specific case, we noticed the problem because there=
=20
> was an unexpected left shift in the captured audio data, since the codec=
=20
> and CPU DAIs were using different formats when the DAI format was not=20
> explicitly set. The fix for that was to add

> simple-audio-card,format=3D "i2s";

> to the devicetree audio card section which of course should have been=20
> there all the time. The fact that the kernel failed halt the=20
> initialization of the audio card lengthened the debug time, but did not=
=20
> provoke me to attempt a workaround, since the information (the error=20
> printout from the ALSA framework when an invalid daifmt setting was made)=
=20
> was actually right there in the kernel log.

> Possibly there might be other usecases, but in our case, if the kernel ha=
d=20
> stopped the audio initialization it would then have been more obvious=20
> where to start looking.

Right, returning the error makes things more obvious for system
integrators so it's a good change to have.  On the other hand there's
potential breakage if for example the hardware happens to default to the
correct format or an error is detected after enough configuration has
been done to the hardware to make it function well enough.  In that case
we'll start returning an error, failing to initialize the card and the
system will loose audio.

Basically this patch won't make anything work that didn't work before.

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1me/UACgkQJNaLcl1U
h9BaWQf/aabrvbqmtF6WEYaqMKTR9lN5PgdF4H5Egc2MSfnZadD2nCJp8OeU/FiS
pJO0Teh3DdEA1LlbUHvoVGhICqGzye3pFrfy2EG9XPHk/Le/XEdddbUJCB1X3e9C
92l6mvdf++Csr91n4W/jjEjmbDZWLNrPqAx2QNrMq0hsOGGD0SZsVpb5/U1mjEYL
6+BfOF8GHj9o2pWcbJmfunzElb5aPibo1gQ2eef/xPxPfLxJ4l5NNTZOkOp1XxKL
9khYfCPxzGB3/jX0kGtR3PW1Rvi+SLYpwG7WTf1JqsBqYEUcYuTP/zmkyz7hPKXv
nPGJmnpjcSCQ1XS9wy2wCRfABvWbSw==
=fYkG
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--

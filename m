Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C219328848
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhCARiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:38:21 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:60936 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbhCARat (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 12:30:49 -0500
Received: from [2a02:1811:d34:3700:3b8d:b310:d327:e418] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmMj-0002Y3-CX; Mon, 01 Mar 2021 18:29:53 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1lGmMi-004iRU-8s; Mon, 01 Mar 2021 18:29:52 +0100
Date:   Mon, 1 Mar 2021 18:29:52 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: futex breakage in 4.9 stable branch
Message-ID: <YD0kkNH+I4xyoTwy@decadent.org.uk>
References: <161408880177110@kroah.com>
 <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
 <YDygp3WYafzcgt+s@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hnV11/jEZcSFOAHY"
Content-Disposition: inline
In-Reply-To: <YDygp3WYafzcgt+s@kroah.com>
X-SA-Exim-Connect-IP: 2a02:1811:d34:3700:3b8d:b310:d327:e418
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hnV11/jEZcSFOAHY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 01, 2021 at 09:07:03AM +0100, Greg Kroah-Hartman wrote:
> On Mon, Mar 01, 2021 at 01:13:08AM +0100, Ben Hutchings wrote:
> > On Tue, 2021-02-23 at 15:00 +0100, Greg Kroah-Hartman wrote:
> > > I'm announcing the release of the 4.9.258 kernel.
> > >=20
> > > All users of the 4.9 kernel series must upgrade.
> > >=20
> > > The updated 4.9.y git tree can be found at:
> > > =A0=A0=A0=A0=A0=A0=A0=A0git://git.kernel.org/pub/scm/linux/kernel/git=
/stable/linux-stable.git linux-4.9.y
> > > and can be browsed at the normal kernel.org git web browser:
> > > =A0=A0=A0=A0=A0=A0=A0=A0
> >=20
> > The backported futex fixes are still incomplete/broken in this version.
> > If I enable lockdep and run the futex self-tests (from 5.10):
> >=20
> > - on 4.9.246, they pass with no lockdep output
> > - on 4.9.257 and 4.9.258, they pass but futex_requeue_pi trigers a
> >   lockdep splat
> >=20
> > I have a local branch that essentially updates futex and rtmutex in
> > 4.9-stable to match 4.14-stable.  With this, the tests pass and lockdep
> > is happy.
> >=20
> > Unfortunately, that branch has about another 60 commits.

I have now rebased that on top of 4.9.258, and there are "only" 39
commits.

> > Further, the
> > more we change futex in 4.9, the more difficult it is going to be to
> > update the 4.9-rt branch.  But I don't see any better option available
> > at the moment.
> >=20
> > Thoughts?
>=20
> There were some posted futex fixes for 4.9 (and 4.4) on the stable list
> that I have not gotten to yet.
>=20
> Hopefully after these are merged (this week), these issues will be
> resolved.

I'm afraid they are not sufficient.

> If not, then yes, they need to be fixed and any help you can provide
> would be appreciated.
>=20
> As for "difficulty", yes, it's rough, but the changes backported were
> required, for obvious reasons :(

I had another look at the locking bug and I was able to make a series
of 7 commits (on top of the 2 already queued) that is sufficient to
make lockdep happy.  But I am not very confident that there won't be
other regressions.  I'll send that over shortly.

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--hnV11/jEZcSFOAHY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmA9JIsACgkQ57/I7JWG
EQlg1xAA0jQ7fOh7ySmmd/JbnyQw43AcpLzRCIrdvP785nRiiC0bBqaEAdvwW4tK
MaukRiiaKB5RIRW6ZVsOu7C0worNwrP62moJejSq2Dper/Lww2Zqi2LqHoaYfdY+
hY5H3gVSSjqOe2eyrC4YJIgkIzv38mcOBqRZIhkPtkJP8qmF5UpRqPd/yhbJOXIE
CJhHg0BrtZvjD1XOQrHhjOKXWzWeF9HZlENLFeXdWlofLa/TPpK3XuFNNRuhMy53
hoUR5PvDeSh4m1kKaQE+0n8riynkIujpfHdf9F+gECC6+zABe9c55hS4ukFCxWuN
td6uJ+2KRQHuLNB4GKXBeApYnhmRKSrpI1ZeSkTdvEvIzZhQb9B23rkSZCUQVxWT
o/vWIDq28E2Q0vl8EUB9exavuO9m4nNexV/dAVQ6t3/z17uziM2kEcw9uFjnEKch
2f6nNyadhYqY+MBSKVMfmWVLyvsuV+GQcIiZcM2QGmYTecVLQ1LN4UI2JntOBTE9
89aHm6djJT1EW3Cs3zdkZZ3CuHsw0QtDeZYBOAkymFeC82i9e1MBRkE1I6KAtf02
B0mQiu7z7f0N1nRftSnnttt2EYpRbR0eDqvnJ/8kK5ejrqCHn2ZJQDnaLYwdBnOT
KYoLa+YyG77YMeuj1aiVYurOc4RyQwmCXu8ntS8VcjmBQqBSkbw=
=aH3/
-----END PGP SIGNATURE-----

--hnV11/jEZcSFOAHY--

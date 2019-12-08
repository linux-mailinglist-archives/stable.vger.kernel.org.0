Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77F52116357
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfLHSJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 13:09:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33892 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbfLHSJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 13:09:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ie102-0003Xn-5H; Sun, 08 Dec 2019 18:09:42 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1ie101-0005jy-FI; Sun, 08 Dec 2019 18:09:41 +0000
Message-ID: <92faedffaa625da9d385a6af2e554d8e4744fa7a.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 43/72] thermal: Fix use-after-free when
 unregistering thermal zone device
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "wvw@google.com" <wvw@google.com>
Date:   Sun, 08 Dec 2019 18:09:36 +0000
In-Reply-To: <20191208162216.GA330015@splinter>
References: <lsq.1575813164.154362148@decadent.org.uk>
         <lsq.1575813165.267246545@decadent.org.uk>
         <20191208162216.GA330015@splinter>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-wirjlZ8bMGe+H7G2uA/P"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-wirjlZ8bMGe+H7G2uA/P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-12-08 at 16:22 +0000, Ido Schimmel wrote:
> On Sun, Dec 08, 2019 at 01:53:27PM +0000, Ben Hutchings wrote:
> > 3.16.79-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Ido Schimmel <idosch@mellanox.com>
> >=20
> > commit 1851799e1d2978f68eea5d9dff322e121dcf59c1 upstream.
> >=20
> > thermal_zone_device_unregister() cancels the delayed work that polls th=
e
> > thermal zone, but it does not wait for it to finish. This is racy with
> > respect to the freeing of the thermal zone device, which can result in =
a
> > use-after-free [1].
> >=20
> > Fix this by waiting for the delayed work to finish before freeing the
> > thermal zone device. Note that thermal_zone_device_set_polling() is
> > never invoked from an atomic context, so it is safe to call
> > cancel_delayed_work_sync() that can block.
>=20
> Ben,
>=20
> Wei Wang (copied) found a problem with this patch and fixed it:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D163b00cde7cf2206e248789d2780121ad5e6a70b
>=20
> I believe you should take both patches to your tree.

Thanks, I will add that now that it is in Linus's tree.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained
by stupidity.



--=-wirjlZ8bMGe+H7G2uA/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3tPGAACgkQ57/I7JWG
EQk0xQ/6A9/1JgUGvhugEymLOWmac/l4/q9YXBkp1D4vPJWLotMhLbySTWoQsZsh
0VGykIh1xPqqwMvWNm4lhOYGIlgBYVEuz4VkCJgvOrFwi/4EW/qRSVpgYeJonX6Z
ADTsovzAnAeZh5wKZ/zJwsZohNnW8lq90zHPG+7APYHeNuA/6N5WPToWdei8W6kp
pmVSTP1BbeVvfBzLGDq4Z2I6MjQyJnW7Zr7oa66K6ZTVZWpibrXRYKa0qB35w2o/
BhBgAhkKitA1ThF83XK5WAETd+4dZKMcpoiUK0+VZOv2Ida2SJbR1Uob8RFJfvRG
1xrzwDmQvxPhjZnpsCT/h2XZJ+fVN5tCQBkQb9kLS7GGTcb8tUzCToBPPrQXkEK7
oar8xSyWSVZuhlNRZw9dOZOfn6stgs3/qn8hnMqeu4AJhOGCHFqkW98rTH632n8j
t/lsOIhAQBoxMZk4p8oqjQ8AzQywt0E5n5izeW4cOrN1m1sPnYAJwiho98HiU66U
+n+R6Cz6TUjHEzKp0gpjVLfEuG12+9RurwcmjPoenAJZQIH+93fKUILbc/QZqmBw
+8PzC18M1eI3VZtrjEUkaSyEEOtH46K5AqaJtQFOPXKbgHn0LJaF4CJbP7E9hcAP
GUnDF2sGm9Bys7L9stfyxjGNU/KGwPE4t7dPYAwQgNCWxGGAwYc=
=9wS6
-----END PGP SIGNATURE-----

--=-wirjlZ8bMGe+H7G2uA/P--

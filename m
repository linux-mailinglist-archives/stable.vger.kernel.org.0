Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38982240B42
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 18:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgHJQhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 12:37:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47400 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgHJQhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 12:37:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6737A1C0BD6; Mon, 10 Aug 2020 18:37:18 +0200 (CEST)
Date:   Mon, 10 Aug 2020 18:37:17 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+1a54a94bd32716796edd@syzkaller.appspotmail.com,
        syzbot+9d2abfef257f3e2d4713@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 06/48] ALSA: seq: oss: Serialize ioctls
Message-ID: <20200810163717.GA24408@amd>
References: <20200810151804.199494191@linuxfoundation.org>
 <20200810151804.528955642@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <20200810151804.528955642@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 80982c7e834e5d4e325b6ce33757012ecafdf0bb upstream.
>=20
> Some ioctls via OSS sequencer API may race and lead to UAF when the
> port create and delete are performed concurrently, as spotted by a
> couple of syzkaller cases.  This patch is an attempt to address it by
> serializing the ioctls with the existing register_mutex.
>=20
> Basically OSS sequencer API is an obsoleted interface and was designed
> without much consideration of the concurrency.  There are very few
> applications with it, and the concurrent performance isn't asked,
> hence this "big hammer" approach should be good enough.

That really is a "big hammer". And I believe it is too big.

In particular, do we need to drop the lock while sleeping in
SNDCTL_SEQ_SYNC: =3D> snd_seq_oss_writeq_sync ?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8xd70ACgkQMOfwapXb+vI+owCfQmddRMmcmzR8eZPLBZ+wUZ4E
LJMAoIUocqpHQx1an8GYl2ZNOkFDfd8G
=cdfu
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--

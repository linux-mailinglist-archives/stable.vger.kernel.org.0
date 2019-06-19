Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558D34B7F0
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 14:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731855AbfFSMQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 08:16:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60171 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731568AbfFSMQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 08:16:42 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id DF92780470; Wed, 19 Jun 2019 14:16:27 +0200 (CEST)
Date:   Wed, 19 Jun 2019 14:16:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.1 043/115] ALSA: seq: Protect in-kernel ioctl calls
 with mutex
Message-ID: <20190619121637.GA19792@amd>
References: <20190617210759.929316339@linuxfoundation.org>
 <20190617210802.258998943@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20190617210802.258998943@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit feb689025fbb6f0aa6297d3ddf97de945ea4ad32 ]
>=20
> ALSA OSS sequencer calls the ioctl function indirectly via
> snd_seq_kernel_client_ctl().  While we already applied the protection
> against races between the normal ioctls and writes via the client's
> ioctl_mutex, this code path was left untouched.  And this seems to be
> the cause of still remaining some rare UAF as spontaneously triggered
> by syzkaller.
>=20
> For the sake of robustness, wrap the ioctl_mutex also for the call via
> snd_seq_kernel_client_ctl(), too.

This is reverted with patch after the next one. Should simply this and
the revert be deleted from the queue?

Thanks,
								Pavel


> diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmg=
r.c
> index 38e7deab6384..b3280e81bfd1 100644
> --- a/sound/core/seq/seq_clientmgr.c
> +++ b/sound/core/seq/seq_clientmgr.c
> @@ -2343,14 +2343,19 @@ int snd_seq_kernel_client_ctl(int clientid, unsig=
ned int cmd, void *arg)
>  {
>  	const struct ioctl_handler *handler;
>  	struct snd_seq_client *client;
> +	int err;
> =20
>  	client =3D clientptr(clientid);
>  	if (client =3D=3D NULL)
>  		return -ENXIO;
> =20
>  	for (handler =3D ioctl_handlers; handler->cmd > 0; ++handler) {
> -		if (handler->cmd =3D=3D cmd)
> -			return handler->func(client, arg);
> +		if (handler->cmd =3D=3D cmd) {
> +			mutex_lock(&client->ioctl_mutex);
> +			err =3D handler->func(client, arg);
> +			mutex_unlock(&client->ioctl_mutex);
> +			return err;
> +		}
>  	}
> =20
>  	pr_debug("ALSA: seq unknown ioctl() 0x%x (type=3D'%c', number=3D0x%02x)=
\n",

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0KJ6UACgkQMOfwapXb+vLRIACgpxVaZo8G/mYONSgkmeOfcYQ/
XHMAoJXByHRwnAmMnp39J/t+b2fnMDfk
=8kd5
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--

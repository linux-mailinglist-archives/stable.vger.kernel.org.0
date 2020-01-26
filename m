Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841E7149C18
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 18:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgAZRaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 12:30:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52342 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbgAZRaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 12:30:00 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivljS-0008Nb-NY; Sun, 26 Jan 2020 17:29:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivljS-0015g7-7C; Sun, 26 Jan 2020 17:29:58 +0000
Message-ID: <59d5ea0b5f00f52d44097310cb50241a2feac7ad.camel@decadent.org.uk>
Subject: Re: [PATCH v4.4.z] pstore/ram: Write new dumps to start of recycled
 zones
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Kees Cook <keescook@chromium.org>, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Aleksandr Yashkin <a.yashkin@inango-systems.com>
Date:   Sun, 26 Jan 2020 17:29:43 +0000
In-Reply-To: <202001071026.8E63B38@keescook>
References: <202001071026.8E63B38@keescook>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-JLAiXzBkGPuydWIOUSx2"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-JLAiXzBkGPuydWIOUSx2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-01-07 at 10:26 -0800, Kees Cook wrote:
> From: Aleksandr Yashkin <a.yashkin@inango-systems.com>
>=20
> [ Upstream commit 9e5f1c19800b808a37fb9815a26d382132c26c3d ]

This looks applicable to 3.16 as well, so I've queued it up.

Ben.

> The ram_core.c routines treat przs as circular buffers. When writing a
> new crash dump, the old buffer needs to be cleared so that the new dump
> doesn't end up in the wrong place (i.e. at the end).
>=20
> The solution to this problem is to reset the circular buffer state before
> writing a new Oops dump.
>=20
> Signed-off-by: Aleksandr Yashkin <a.yashkin@inango-systems.com>
> Signed-off-by: Nikolay Merinov <n.merinov@inango-systems.com>
> Signed-off-by: Ariel Gilman <a.gilman@inango-systems.com>
> Link: https://lore.kernel.org/r/20191223133816.28155-1-n.merinov@inango-s=
ystems.com
> Fixes: 896fc1f0c4c6 ("pstore/ram: Switch to persistent_ram routines")
> [kees: backport to v4.9]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/pstore/ram.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 59d93acc29c7..fa0e89edb62d 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -319,6 +319,17 @@ static int notrace ramoops_pstore_write_buf(enum pst=
ore_type_id type,
> =20
>  	prz =3D cxt->przs[cxt->dump_write_cnt];
> =20
> +	/*
> +	 * Since this is a new crash dump, we need to reset the buffer in
> +	 * case it still has an old dump present. Without this, the new dump
> +	 * will get appended, which would seriously confuse anything trying
> +	 * to check dump file contents. Specifically, ramoops_read_kmsg_hdr()
> +	 * expects to find a dump header in the beginning of buffer data, so
> +	 * we must to reset the buffer values, in order to ensure that the
> +	 * header will be written to the beginning of the buffer.
> +	 */
> +	persistent_ram_zap(prz);
> +
>  	hlen =3D ramoops_write_kmsg_hdr(prz, compressed);
>  	if (size + hlen > prz->buffer_size)
>  		size =3D prz->buffer_size - hlen;
> --=20
> 2.20.1
>=20
>=20
--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.



--=-JLAiXzBkGPuydWIOUSx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4tzIcACgkQ57/I7JWG
EQlJUA//SaRL9fn5z2B/x6FNhF7YwpOd645bnkRk1uXbxJL+P27676Ex7TQXwUW6
EHWice8Npo8COiSRJ90gm3wMHw4mKHTZXc4hKL9FkaXXvIpxVwghDAfaLzS4I61b
4RF8zkxFEi1Q5Dz70aZG8YOr+f+wtHkhRXrtpzkQqLgjzeagVU1jGGisCVuCDPDU
lYgu6xaR/fCkJ3mqD6SHyPuINxE+pXujsuGs2IckWTmPDlTNSyGFAxvTd3+YaZ1n
mj/GZaWyMhKoI6WYrEwmaNN7TkeMqhwVPVwgvLMMUl/zh/eSLel4qvP8gyUNUVSl
fW8dHBDnGjV89vDIJywMagBC/pJkxDdORSOte5zRi08e524Ojki4/EamUblWfjgi
ty8kfNN//rB9Yy5ym8ejyLly9IIFPAg/8Y7O50XKJ/A4J9Are7WKcViQhzKCa02G
+ptGJySXfvaWwVzd3L4O/UhKSILshOpVNx5ztC61p/BcBgtO/jLTyBRf2SZRhcQ4
RVXxNKBB/UcQtErh14gvVK8KyQI+/71dzfCZhB4HYHuA3AkSyVQ4Z3SiXGBIjGwI
azjnfXnSrgVcgUQaOqAcrfEnZxurbB3F6sHdp3BXa+raxg0eIGO1IL/ht9P5nwAd
opZ/d/EK5bT12lMb71G+zY3H0YySQvYPDy7L6FO8NcsuIijyU74=
=V0dH
-----END PGP SIGNATURE-----

--=-JLAiXzBkGPuydWIOUSx2--

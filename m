Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC7124823F
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRJv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:51:29 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48908 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgHRJv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 05:51:28 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0EEFE1C0BB7; Tue, 18 Aug 2020 11:51:25 +0200 (CEST)
Date:   Tue, 18 Aug 2020 11:51:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jbaron@akamai.com, Jim Cromie <jim.cromie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 051/168] dyndbg: fix a BUG_ON in
 ddebug_describe_flags
Message-ID: <20200818095124.GD10974@amd>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143736.291298404@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <20200817143736.291298404@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-08-17 17:16:22, Greg Kroah-Hartman wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
>=20
> [ Upstream commit f678ce8cc3cb2ad29df75d8824c74f36398ba871 ]
>=20
> ddebug_describe_flags() currently fills a caller provided string buffer,
> after testing its size (also passed) in a BUG_ON.  Fix this by
> replacing them with a known-big-enough string buffer wrapped in a
> struct, and passing that instead.
>=20
> Also simplify ddebug_describe_flags() flags parameter from a struct to
> a member in that struct, and hoist the member deref up to the caller.
> This makes the function reusable (soon) where flags are unpacked.

Original code was correct, passing explicit size, this passes strange
structure. BUG_ON can never trigger in the origianl code, so this is
not a bugfix.

Best regards,
								Pavel

> +++ b/lib/dynamic_debug.c
> @@ -85,22 +85,22 @@ static struct { unsigned flag:8; char opt_char; } opt=
_array[] =3D {
>  	{ _DPRINTK_FLAGS_NONE, '_' },
>  };
> =20
> +struct flagsbuf { char buf[ARRAY_SIZE(opt_array)+1]; };
> +
>  /* format a string into buf[] which describes the _ddebug's flags */
> -static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
> -				    size_t maxlen)
> +static char *ddebug_describe_flags(unsigned int flags, struct flagsbuf *=
fb)
>  {
> -	char *p =3D buf;
> +	char *p =3D fb->buf;
>  	int i;
> =20
> -	BUG_ON(maxlen < 6);
>  	for (i =3D 0; i < ARRAY_SIZE(opt_array); ++i)
> -		if (dp->flags & opt_array[i].flag)
> +		if (flags & opt_array[i].flag)
>  			*p++ =3D opt_array[i].opt_char;
> -	if (p =3D=3D buf)
> +	if (p =3D=3D fb->buf)
>  		*p++ =3D '_';
>  	*p =3D '\0';
> =20
> -	return buf;
> +	return fb->buf;
>  }
> =20
>  #define vpr_info(fmt, ...)					\
> @@ -142,7 +142,7 @@ static int ddebug_change(const struct ddebug_query *q=
uery,
>  	struct ddebug_table *dt;
>  	unsigned int newflags;
>  	unsigned int nfound =3D 0;
> -	char flagbuf[10];
> +	struct flagsbuf fbuf;
> =20
>  	/* search for matching ddebugs */
>  	mutex_lock(&ddebug_lock);
> @@ -199,8 +199,7 @@ static int ddebug_change(const struct ddebug_query *q=
uery,
>  			vpr_info("changed %s:%d [%s]%s =3D%s\n",
>  				 trim_prefix(dp->filename), dp->lineno,
>  				 dt->mod_name, dp->function,
> -				 ddebug_describe_flags(dp, flagbuf,
> -						       sizeof(flagbuf)));
> +				 ddebug_describe_flags(dp->flags, &fbuf));
>  		}
>  	}
>  	mutex_unlock(&ddebug_lock);
> @@ -779,7 +778,7 @@ static int ddebug_proc_show(struct seq_file *m, void =
*p)
>  {
>  	struct ddebug_iter *iter =3D m->private;
>  	struct _ddebug *dp =3D p;
> -	char flagsbuf[10];
> +	struct flagsbuf flags;
> =20
>  	vpr_info("called m=3D%p p=3D%p\n", m, p);
> =20
> @@ -792,7 +791,7 @@ static int ddebug_proc_show(struct seq_file *m, void =
*p)
>  	seq_printf(m, "%s:%u [%s]%s =3D%s \"",
>  		   trim_prefix(dp->filename), dp->lineno,
>  		   iter->table->mod_name, dp->function,
> -		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
> +		   ddebug_describe_flags(dp->flags, &flags));
>  	seq_escape(m, dp->format, "\t\r\n\"");
>  	seq_puts(m, "\"\n");
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl87pJwACgkQMOfwapXb+vK8egCeOuLFXFZ8DrogqMjVa0su9IUM
VC8AoJu7I0GDnLFTdQOaAoQVu+f6tfKS
=XkW2
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--

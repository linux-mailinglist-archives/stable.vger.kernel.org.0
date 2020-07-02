Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC93B212EA4
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgGBVRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:17:32 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41964 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgGBVRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:17:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E0ED41C0C0C; Thu,  2 Jul 2020 23:17:29 +0200 (CEST)
Date:   Thu, 2 Jul 2020 23:17:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.19 119/131] tracing: Fix event trigger to accept
 redundant spaces
Message-ID: <20200702211728.GD5787@amd>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-120-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k4f25fnPtRuIRUb3"
Content-Disposition: inline
In-Reply-To: <20200629153502.2494656-120-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k4f25fnPtRuIRUb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 6784beada631800f2c5afd567e5628c843362cee upstream.
>=20
> Fix the event trigger to accept redundant spaces in
> the trigger input.
>=20
> For example, these return -EINVAL
>=20
> echo " traceon" > events/ftrace/print/trigger
> echo "traceon  if common_pid =3D=3D 0" > events/ftrace/print/trigger
> echo "disable_event:kmem:kmalloc " > events/ftrace/print/trigger
>=20
> But these are hard to find what is wrong.
>=20
> To fix this issue, use skip_spaces() to remove spaces
> in front of actual tokens, and set NULL if there is no
> token.

For the record, I'm not fan of this one. It is ABI change, not a
bugfix.

Yes, it makes kernel interface "easier to use". It also changes
interface in the middle of stable series, and if people start relying
on new interface and start putting extra spaces, they'll get nasty
surprise when they move code to the older kernel.

Best regards,
								Pavel

> +++ b/kernel/trace/trace_events_trigger.c
> @@ -211,11 +211,17 @@ static int event_trigger_regex_open(struct inode *i=
node, struct file *file)
> =20
>  static int trigger_process_regex(struct trace_event_file *file, char *bu=
ff)
>  {
> -	char *command, *next =3D buff;
> +	char *command, *next;
>  	struct event_command *p;
>  	int ret =3D -EINVAL;
> =20
> +	next =3D buff =3D skip_spaces(buff);
>  	command =3D strsep(&next, ": \t");
> +	if (next) {
> +		next =3D skip_spaces(next);
> +		if (!*next)
> +			next =3D NULL;
> +	}
>  	command =3D (command[0] !=3D '!') ? command : command + 1;
> =20
>  	mutex_lock(&trigger_cmd_mutex);
> @@ -624,8 +630,14 @@ event_trigger_callback(struct event_command *cmd_ops,
>  	int ret;
> =20
>  	/* separate the trigger from the filter (t:n [if filter]) */
> -	if (param && isdigit(param[0]))
> +	if (param && isdigit(param[0])) {
>  		trigger =3D strsep(&param, " \t");
> +		if (param) {
> +			param =3D skip_spaces(param);
> +			if (!*param)
> +				param =3D NULL;
> +		}
> +	}
> =20
>  	trigger_ops =3D cmd_ops->get_trigger_ops(cmd, trigger);
> =20
> @@ -1361,6 +1373,11 @@ int event_enable_trigger_func(struct event_command=
 *cmd_ops,
>  	trigger =3D strsep(&param, " \t");
>  	if (!trigger)
>  		return -EINVAL;
> +	if (param) {
> +		param =3D skip_spaces(param);
> +		if (!*param)
> +			param =3D NULL;
> +	}
> =20
>  	system =3D strsep(&trigger, ":");
>  	if (!trigger)

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--k4f25fnPtRuIRUb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7+TugACgkQMOfwapXb+vJq0ACfRmSlPRfnv1+7wFG/3Rqsck5K
e7sAoJXDs5V4qmmdSWcfQbQPzHv7luQx
=yZDm
-----END PGP SIGNATURE-----

--k4f25fnPtRuIRUb3--

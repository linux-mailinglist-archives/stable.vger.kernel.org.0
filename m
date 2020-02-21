Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2731F1689E8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 23:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgBUWW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 17:22:56 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38362 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgBUWW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 17:22:56 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8C1681C0411; Fri, 21 Feb 2020 23:22:53 +0100 (CET)
Date:   Fri, 21 Feb 2020 23:22:53 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 112/191] x86/nmi: Remove irq_work from the long
 duration NMI handler
Message-ID: <20200221222252.GA14067@amd>
References: <20200221072250.732482588@linuxfoundation.org>
 <20200221072304.373890261@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20200221072304.373890261@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Fri 2020-02-21 08:41:25, Greg Kroah-Hartman wrote:
> From: Changbin Du <changbin.du@gmail.com>
>=20
> [ Upstream commit 248ed51048c40d36728e70914e38bffd7821da57 ]
>=20
> First, printk() is NMI-context safe now since the safe printk() has been
> implemented and it already has an irq_work to make NMI-context safe.
>=20
> Second, this NMI irq_work actually does not work if a NMI handler causes
> panic by watchdog timeout. It has no chance to run in such case, while
> the safe printk() will flush its per-cpu buffers before panicking.
>=20
> While at it, repurpose the irq_work callback into a function which
> concentrates the NMI duration checking and makes the code easier to
> follow.

I know there were printk() changes recently, but are they all in 4.19?

Does this actually fix any bug in 4.19?

Best regards,
								Pavel
							=09
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 086cf1d1d71d8..0f8b9b900b0e7 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -102,18 +102,22 @@ static int __init nmi_warning_debugfs(void)
>  }
>  fs_initcall(nmi_warning_debugfs);
> =20
> -static void nmi_max_handler(struct irq_work *w)
> +static void nmi_check_duration(struct nmiaction *action, u64 duration)
>  {
> -	struct nmiaction *a =3D container_of(w, struct nmiaction, irq_work);
> +	u64 whole_msecs =3D READ_ONCE(action->max_duration);
>  	int remainder_ns, decimal_msecs;
> -	u64 whole_msecs =3D READ_ONCE(a->max_duration);
> +
> +	if (duration < nmi_longest_ns || duration < action->max_duration)
> +		return;
> +
> +	action->max_duration =3D duration;
> =20
>  	remainder_ns =3D do_div(whole_msecs, (1000 * 1000));
>  	decimal_msecs =3D remainder_ns / 1000;
> =20
>  	printk_ratelimited(KERN_INFO
>  		"INFO: NMI handler (%ps) took too long to run: %lld.%03d msecs\n",
> -		a->handler, whole_msecs, decimal_msecs);
> +		action->handler, whole_msecs, decimal_msecs);
>  }
> =20
>  static int nmi_handle(unsigned int type, struct pt_regs *regs)
> @@ -140,11 +144,7 @@ static int nmi_handle(unsigned int type, struct pt_r=
egs *regs)
>  		delta =3D sched_clock() - delta;
>  		trace_nmi_handler(a->handler, (int)delta, thishandled);
> =20
> -		if (delta < nmi_longest_ns || delta < a->max_duration)
> -			continue;
> -
> -		a->max_duration =3D delta;
> -		irq_work_queue(&a->irq_work);
> +		nmi_check_duration(a, delta);
>  	}
> =20
>  	rcu_read_unlock();
> @@ -162,8 +162,6 @@ int __register_nmi_handler(unsigned int type, struct =
nmiaction *action)
>  	if (!action->handler)
>  		return -EINVAL;
> =20
> -	init_irq_work(&action->irq_work, nmi_max_handler);
> -
>  	raw_spin_lock_irqsave(&desc->lock, flags);
> =20
>  	/*

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl5QWDwACgkQMOfwapXb+vK8pQCfXc7L7u+EWDJS97tDbbXFdWo0
VmcAn1KMa2N/gyXeOJZWraFurLztLMMk
=pvgT
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--

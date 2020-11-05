Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F412A875B
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 20:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbgKETff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 14:35:35 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55774 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732233AbgKETff (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 14:35:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4A8861C0B82; Thu,  5 Nov 2020 20:35:32 +0100 (CET)
Date:   Thu, 5 Nov 2020 20:35:31 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 078/191] ia64: kprobes: Use generic kretprobe
 trampoline handler
Message-ID: <20201105193531.GA19723@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203241.558540091@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20201103203241.558540091@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Masami Hiramatsu <mhiramat@kernel.org>
>=20
> [ Upstream commit e792ff804f49720ce003b3e4c618b5d996256a18 ]
>=20
> Use the generic kretprobe trampoline handler. Don't use
> framepointer verification.
>=20
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/r/159870606883.1229682.12331813108378725668=
=2Estgit@devnote2
> Signed-off-by: Sasha Levin <sashal@kernel.org>

There's no explanation here why this is good idea for -stable.

Plus, this seems to depend on commit
66ada2ccae4ed4dd07ba91df3b5fdb4c11335bd1 which is not present in
stable, so this will likely not build due to lack of
__kretprobe_trampoline_handler symbol. (I don't have ia64 to verify):

$ grep -ri __kretprobe_trampoline_handler .
=2E/arch/ia64/kernel/kprobes.c:	regs->cr_iip =3D __kretprobe_trampoline_han=
dler(regs, kretprobe_trampoline, NULL);
$

I believe it should be dropped.

Best regards,
									Pavel
=2E..
> -	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
> -		hlist_del(&ri->hlist);
> -		kfree(ri);
> -	}
> +	regs->cr_iip =3D __kretprobe_trampoline_handler(regs, kretprobe_trampol=
ine, NULL);

--=20
http://www.livejournal.com/~pavelmachek

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6RUAwAKCRAw5/Bqldv6
8i+CAJwNRSKg9fCi/1xiwSGC2BApgG0m3QCgiRnrgI0hqmKSMayrd73Y4yAZMx4=
=UOTC
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

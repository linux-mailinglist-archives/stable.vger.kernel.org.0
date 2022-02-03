Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1B64A8F4F
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiBCUql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:46:41 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52126 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354785AbiBCUpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:45:20 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B59FD1C0B79; Thu,  3 Feb 2022 21:45:18 +0100 (CET)
Date:   Thu, 3 Feb 2022 21:45:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+5ca851459ed04c778d1d@syzkaller.appspotmail.com,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH 4.14 2/2] can: bcm: fix UAF of bcm op
Message-ID: <20220203204518.GA18824@duo.ucw.cz>
References: <20220127180256.764665162@linuxfoundation.org>
 <20220127180256.840826051@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20220127180256.840826051@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> From: Ziyang Xuan <william.xuanziyang@huawei.com>
>=20
> Stopping tasklet and hrtimer rely on the active state of tasklet and
> hrtimer sequentially in bcm_remove_op(), the op object will be freed
> if they are all unactive. Assume the hrtimer timeout is short, the
> hrtimer cb has been excuted after tasklet conditional judgment which
> must be false after last round tasklet_kill() and before condition
> hrtimer_active(), it is false when execute to hrtimer_active(). Bug
> is triggerd, because the stopping action is end and the op object
> will be freed, but the tasklet is scheduled. The resources of the op
> object will occur UAF bug.
>=20
> Move hrtimer_cancel() behind tasklet_kill() and switch 'while () {...}'
> to 'do {...} while ()' to fix the op UAF problem.

I don't see this commit in mainline or next kernels. What is going on
here? Is it one of those "only needed in -stable" things? Or do we
still need to fix it in the mainline?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfw+3gAKCRAw5/Bqldv6
8uKwAJ0UfJMChXRoN1yhcxHknUTIq0A2DQCfT0NdPdj4mxrex8j1U/PlZy106Og=
=ijM2
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--

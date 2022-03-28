Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FFE4E915B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 11:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiC1JdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 05:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiC1JdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 05:33:01 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59183541A4;
        Mon, 28 Mar 2022 02:31:21 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 135181C0B77; Mon, 28 Mar 2022 11:31:20 +0200 (CEST)
Date:   Mon, 28 Mar 2022 11:31:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?utf-8?B?6LW15a2Q6L2p?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>
Subject: Re: [PATCH 5.10 09/38] llc: fix netdevice reference leaks in
 llc_ui_bind()
Message-ID: <20220328093115.GB26815@amd>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.029041400@linuxfoundation.org>
 <20220326200922.GA9262@duo.ucw.cz>
 <20220326131325.397bc0e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YkAziXrW7/Fbqo/b@kroah.com>
 <20220328090830.GA24435@amd>
 <YkF8HQ7Ih3IUJ3jT@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <YkF8HQ7Ih3IUJ3jT@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Should be in mainline on Thursday, LMK if we need to accelerate.
> > > > IDK if anyone enables LLC2.
> > >=20
> > > I'll queue this up now, thanks.
> >=20
> > As the changelog says, this needs b37a46683739, otherwise there will
> > be oops-es in even more cases.
>=20
> If you look at the change, I think I already handled that issue.  If
> not, please let me know.

I did not notice you making changes there, but no, it is not correct
AFAICT.

# commit 163960a7de1333514c9352deb7c80c6b9fd9abf2
# Author: Eric Dumazet <edumazet@google.com>
# Date:   Thu Mar 24 20:58:27 2022 -0700

#    llc: only change llc->dev when bind() succeeds
=2E..   =20
#     Make sure commit b37a46683739 ("netdevice: add the case if dev is NUL=
L")
#     is already present in your trees.

Before b37a46683739, dev_put can't handle NULL.
   =20
+++ b/net/llc/af_llc.c
@@ -287,14 +288,14 @@ static int llc_ui_autobind(struct socket *sock, struc=
t sockaddr_llc *addr)
=2E..

-		llc->dev =3D dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
-	if (!llc->dev)
+		dev =3D dev_getfirstbyhwtype(&init_net, addr->sllc_arphrd);
+	if (!dev)
 		goto out;
 	rc =3D -EUSERS;
 	llc->laddr.lsap =3D llc_ui_autoport();

One of several paths where we goto out with dev=3D=3DNULL.

@@ -311,10 +317,7 @@ static int llc_ui_autobind(struct socket *sock, struct=
 sockaddr_llc *addr)
 	sock_reset_flag(sk, SOCK_ZAPPED);
 	rc =3D 0;
 out:
-	if (rc) {
-		dev_put(llc->dev);
-		llc->dev =3D NULL;
-	}
+	dev_put(dev);
 	return rc;
 }


But dev_put can't handle NULL.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmJBgGMACgkQMOfwapXb+vLdowCgwQbngZbYidh7mIG29PvDfJZ4
+q4AnRQcCs87Aj7HPbIM2NDGtwl1wTVi
=a95K
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--

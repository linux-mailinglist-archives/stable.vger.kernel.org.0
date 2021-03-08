Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58C330EAE
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCHMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:51:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45980 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhCHMvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 07:51:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 40AAE1C0B76; Mon,  8 Mar 2021 13:50:58 +0100 (CET)
Date:   Mon, 8 Mar 2021 13:50:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 031/102] net: fix dev_ifsioc_locked() race condition
Message-ID: <20210308125057.GA19538@duo.ucw.cz>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210305120904.814003997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <20210305120904.814003997@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 3b23a32a63219f51a5298bc55a65ecee866e79d0 upstream.
>=20
> dev_ifsioc_locked() is called with only RCU read lock, so when
> there is a parallel writer changing the mac address, it could
> get a partially updated mac address, as shown below:
>=20
> Thread 1			Thread 2
> // eth_commit_mac_addr_change()
> memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> 				// dev_ifsioc_locked()
> 				memcpy(ifr->ifr_hwaddr.sa_data,
> 					dev->dev_addr,...);
>=20
> Close this race condition by guarding them with a RW semaphore,
> like netdev_get_name(). We can not use seqlock here as it does not

I guess it may fix a race, but... does it leak kernel stack data to
userland?


> +++ b/drivers/net/tap.c
> @@ -1093,10 +1093,9 @@ static long tap_ioctl(struct file *file,
>  			return -ENOLINK;
>  		}
>  		ret =3D 0;
> -		u =3D tap->dev->type;
> +		dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);
>  		if (copy_to_user(&ifr->ifr_name, tap->dev->name, IFNAMSIZ) ||
> -		    copy_to_user(&ifr->ifr_hwaddr.sa_data, tap->dev->dev_addr, ETH_ALE=
N) ||
> -		    put_user(u, &ifr->ifr_hwaddr.sa_family))
> +		    copy_to_user(&ifr->ifr_hwaddr, &sa, sizeof(sa)))
>  			ret =3D -EFAULT;
>  		tap_put_tap_dev(tap);
>  		rtnl_unlock();

We copy whole "struct sockaddr".

> +int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_=
name)
> +{
> +	size_t size =3D sizeof(sa->sa_data);
> +	struct net_device *dev;
> +	int ret =3D 0;
=2E..
> +	if (!dev->addr_len)
> +		memset(sa->sa_data, 0, size);
> +	else
> +		memcpy(sa->sa_data, dev->dev_addr,
> +		       min_t(size_t, size, dev->addr_len));

But we only coppied dev->addr_len bytes in.

This would be very simple way to plug the leak.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/net/core/dev.c b/net/core/dev.c
index 75ca6c6d01d6..b67ff23a1f0d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8714,11 +8714,9 @@ int dev_get_mac_address(struct sockaddr *sa, struct =
net *net, char *dev_name)
 		ret =3D -ENODEV;
 		goto unlock;
 	}
-	if (!dev->addr_len)
-		memset(sa->sa_data, 0, size);
-	else
-		memcpy(sa->sa_data, dev->dev_addr,
-		       min_t(size_t, size, dev->addr_len));
+	memset(sa->sa_data, 0, size);
+	memcpy(sa->sa_data, dev->dev_addr,
+	       min_t(size_t, size, dev->addr_len));
 	sa->sa_family =3D dev->type;
=20
 unlock:

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYEYdsQAKCRAw5/Bqldv6
8nb3AJwI4RyTgXXMivPUGXjUuWw+FiC/KQCgkfPE8IKJm7cFXpoNCW5MS931Ar8=
=wGL7
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

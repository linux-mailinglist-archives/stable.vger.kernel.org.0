Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20583775E0
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 10:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhEII3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 04:29:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57854 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhEII27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 04:28:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2AC441C0B77; Sun,  9 May 2021 10:27:56 +0200 (CEST)
Date:   Sun, 9 May 2021 10:27:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     stable@vger.kernel.org, mark.d.gray@redhat.com, wens@csie.org,
        Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4] geneve: add transport ports in route lookup for geneve
Message-ID: <20210509082755.GB25504@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Mark Gray <mark.d.gray@redhat.com>

[ Upstream commit 34beb21594519ce64a55a498c2fe7d567bc1ca20 ]

This patch adds transport ports information for route lookup so that
IPsec can select Geneve tunnel traffic to do encryption. This is
needed for OVS/OVN IPsec with encrypted Geneve tunnels.

This can be tested by configuring a host-host VPN using an IKE
daemon and specifying port numbers. For example, for an
Openswan-type configuration, the following parameters should be
configured on both hosts and IPsec set up as-per normal:

$ cat /etc/ipsec.conf

conn in
=2E..
left=3D$IP1
right=3D$IP2
=2E..
leftprotoport=3Dudp/6081
rightprotoport=3Dudp
=2E..
conn out
=2E..
left=3D$IP1
right=3D$IP2
=2E..
leftprotoport=3Dudp
rightprotoport=3Dudp/6081
=2E..

The tunnel can then be setup using "ip" on both hosts (but
changing the relevant IP addresses):

$ ip link add tun type geneve id 1000 remote $IP2
$ ip addr add 192.168.0.1/24 dev tun
$ ip link set tun up

This can then be tested by pinging from $IP1:

$ ping 192.168.0.2

Without this patch the traffic is unencrypted on the wire.

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>
Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[backport to 4.4 for CVE-2020-25645]
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
---
 drivers/net/geneve.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index ee38299f9c57..aa00d71705c6 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -842,7 +842,7 @@ static netdev_tx_t geneve_xmit_skb(struct sk_buff *skb,=
 struct net_device *dev,
=20
 	sport =3D udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	rt =3D geneve_get_v4_rt(skb, dev, &fl4, info,
-			      geneve->dst_port, sport);
+			      info->key.tp_dst, sport);
 	if (IS_ERR(rt)) {
 		err =3D PTR_ERR(rt);
 		goto tx_error;
@@ -925,7 +925,7 @@ static netdev_tx_t geneve6_xmit_skb(struct sk_buff *skb=
, struct net_device *dev,
=20
 	sport =3D udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	dst =3D geneve_get_v6_dst(skb, dev, &fl6, info,
-				geneve->dst_port, sport);
+				info->key.tp_dst, sport);
 	if (IS_ERR(dst)) {
 		err =3D PTR_ERR(dst);
 		goto tx_error;
@@ -1026,7 +1026,7 @@ static int geneve_fill_metadata_dst(struct net_device=
 *dev, struct sk_buff *skb)
 					  1, USHRT_MAX, true);
=20
 		rt =3D geneve_get_v4_rt(skb, dev, &fl4, info,
-				      geneve->dst_port, sport);
+				      info->key.tp_dst, sport);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
=20
@@ -1038,7 +1038,7 @@ static int geneve_fill_metadata_dst(struct net_device=
 *dev, struct sk_buff *skb)
 					  1, USHRT_MAX, true);
=20
 		dst =3D geneve_get_v6_dst(skb, dev, &fl6, info,
-					geneve->dst_port, sport);
+					info->key.tp_dst, sport);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
=20
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany



----- End forwarded message -----

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCXnQsACgkQMOfwapXb+vIgcgCghRY2m7O1IfHrVVMgqQytnsMV
DyUAoKqt8f0UkkVd7bXo1p46jzXaLMr5
=Fegg
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--

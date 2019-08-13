Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB078B79B
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 13:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfHMLxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 07:53:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47686 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726705AbfHMLxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 07:53:25 -0400
Received: from ben by shadbolt.decadent.org.uk with local (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hxVMb-00087f-U5; Tue, 13 Aug 2019 12:53:22 +0100
Date:   Tue, 13 Aug 2019 12:53:17 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Eric Dumazet <edumazet@google.com>
Message-ID: <20190813115317.6cgml2mckd3c6u7z@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="42fw5m7r3t6y5am7"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        shadbolt.decadent.org.uk
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=5.0 tests=NO_RELAYS autolearn=disabled
        version=3.4.2
Subject: [PATCH 3.16-4.14] tcp: Clear sk_send_head after purging the write
 queue
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--42fw5m7r3t6y5am7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Denis Andzakovic discovered a potential use-after-free in older kernel
versions, using syzkaller.  tcp_write_queue_purge() frees all skbs in
the TCP write queue and can leave sk->sk_send_head pointing to freed
memory.  tcp_disconnect() clears that pointer after calling
tcp_write_queue_purge(), but tcp_connect() does not.  It is
(surprisingly) possible to add to the write queue between
disconnection and reconnection, so this needs to be done in both
places.

This bug was introduced by backports of commit 7f582b248d0a ("tcp:
purge write queue in tcp_connect_init()") and does not exist upstream
because of earlier changes in commit 75c119afe14f ("tcp: implement
rb-tree based retransmit queue").  The latter is a major change that's
not suitable for stable.

Reported-by: Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>
Bisected-by: Salvatore Bonaccorso <carnil@debian.org>
Fixes: 7f582b248d0a ("tcp: purge write queue in tcp_connect_init()")
Cc: <stable@vger.kernel.org> # before 4.15
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/tcp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index fed2a78fb8cb..f9b985d4d779 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1517,6 +1517,8 @@ struct tcp_fastopen_context {
 	struct rcu_head		rcu;
 };
=20
+static inline void tcp_init_send_head(struct sock *sk);
+
 /* write queue abstraction */
 static inline void tcp_write_queue_purge(struct sock *sk)
 {
@@ -1524,6 +1526,7 @@ static inline void tcp_write_queue_purge(struct sock =
*sk)
=20
 	while ((skb =3D __skb_dequeue(&sk->sk_write_queue)) !=3D NULL)
 		sk_wmem_free_skb(sk, skb);
+	tcp_init_send_head(sk);
 	sk_mem_reclaim(sk);
 	tcp_clear_all_retrans_hints(tcp_sk(sk));
 	inet_csk(sk)->icsk_backoff =3D 0;

--42fw5m7r3t6y5am7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1SpKgACgkQ57/I7JWG
EQlkCxAAoAsu41RAA0G9oxBErJf56zmO8OH+QYL22+0EZ5vK/pCHfooxI8I7QqO1
MVZoLYxpS3awczrdANmYks1XNsJXRa3F7qm+5hl8p9jvqZqNijdSge7gc8A2rhiV
TznR/1i47cBvetk1NFmZCbc9l+YIxMjZh9P7uZ5Juubi5e2QmInGXWsa2DPK7drc
5Rcxw7BkiKPNUVDGSrv4Rd1j+9KOKGts5pqf112bKOLUXUGSYdY0wPngTgfaSrwd
sin22CwOhnPbADgVJPMwDDHRYMYwQhCy29Z3EgNbMidLZCNbbbuP96PxRwK9VTXN
KJ0y3rFsLlJ4rE6CSw9zbzrQWht6czEJvKtNK0I60T8O5zGKZWdl1H8odGrMiqUG
5YKCnNTJeEMve1bWSHwmNKARhEsf5k7Td5BouNjaNCmsnFNJcA9rmh+ZaI3oF/Vx
oQsfiFcgrjNy7RinyifAGT5weoFl8VjfWIl1SEJXsDKzhJ1JhhwAoqZD2U712Pgm
2pV4uhNEnNJqpQEII25/wauf6LqBQWWMjuUwIA94l4kHt6IDVngKLwH0fEuIab99
W6sV4sO5u/3DjBsZUNpGdbYhxQM1/g4OnKDsR5m0kW7y3PGYqkj5klcl3+bMp3Zc
5Wes+m6fCVMLjlAw53MO0HWYLlFXLmk2AXTT2/VRQsP8hsiC1tY=
=F7mz
-----END PGP SIGNATURE-----

--42fw5m7r3t6y5am7--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6998F95411
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 04:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfHTCLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 22:11:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44218 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728615AbfHTCLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 22:11:45 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hztcc-0001Kd-9T; Tue, 20 Aug 2019 03:11:42 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1hztcb-0003yd-Vn; Tue, 20 Aug 2019 03:11:41 +0100
Message-ID: <41a61a2f87691d2bc839f26cdfe6f5ff2f51e472.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16-4.14] tcp: Clear sk_send_head after purging the
 write queue
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Eric Dumazet <edumazet@google.com>
Date:   Tue, 20 Aug 2019 03:11:37 +0100
In-Reply-To: <20190813115317.6cgml2mckd3c6u7z@decadent.org.uk>
References: <20190813115317.6cgml2mckd3c6u7z@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-0Kxi4EewISbUBuag6yC7"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-0Kxi4EewISbUBuag6yC7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry, this is the same issue that was already fixed by "tcp: reset
sk_send_head in tcp_write_queue_purge".  You can drop my version from
the queue for 4.4 and 4.9 and revert it for 4.14.

Ben.

On Tue, 2019-08-13 at 12:53 +0100, Ben Hutchings wrote:
> Denis Andzakovic discovered a potential use-after-free in older kernel
> versions, using syzkaller.  tcp_write_queue_purge() frees all skbs in
> the TCP write queue and can leave sk->sk_send_head pointing to freed
> memory.  tcp_disconnect() clears that pointer after calling
> tcp_write_queue_purge(), but tcp_connect() does not.  It is
> (surprisingly) possible to add to the write queue between
> disconnection and reconnection, so this needs to be done in both
> places.
>=20
> This bug was introduced by backports of commit 7f582b248d0a ("tcp:
> purge write queue in tcp_connect_init()") and does not exist upstream
> because of earlier changes in commit 75c119afe14f ("tcp: implement
> rb-tree based retransmit queue").  The latter is a major change that's
> not suitable for stable.
>=20
> Reported-by: Denis Andzakovic <denis.andzakovic@pulsesecurity.co.nz>
> Bisected-by: Salvatore Bonaccorso <carnil@debian.org>
> Fixes: 7f582b248d0a ("tcp: purge write queue in tcp_connect_init()")
> Cc: <stable@vger.kernel.org> # before 4.15
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  include/net/tcp.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index fed2a78fb8cb..f9b985d4d779 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1517,6 +1517,8 @@ struct tcp_fastopen_context {
>  	struct rcu_head		rcu;
>  };
> =20
> +static inline void tcp_init_send_head(struct sock *sk);
> +
>  /* write queue abstraction */
>  static inline void tcp_write_queue_purge(struct sock *sk)
>  {
> @@ -1524,6 +1526,7 @@ static inline void tcp_write_queue_purge(struct soc=
k *sk)
> =20
>  	while ((skb =3D __skb_dequeue(&sk->sk_write_queue)) !=3D NULL)
>  		sk_wmem_free_skb(sk, skb);
> +	tcp_init_send_head(sk);
>  	sk_mem_reclaim(sk);
>  	tcp_clear_all_retrans_hints(tcp_sk(sk));
>  	inet_csk(sk)->icsk_backoff =3D 0;
--=20
Ben Hutchings
Experience is what causes a person to make new mistakes
instead of old ones.


--=-0Kxi4EewISbUBuag6yC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1bVtkACgkQ57/I7JWG
EQkFxA//XC8QGKef+QWfAsCbJwa1QlyIMKSWHbLMGT8pBo7g0IcBMvV/Xo8gKxGA
ezcFqMLcgKEfZ71A9INHfNw7+4ZU0tnAEY0hcp+rOQrt96+vjX7gwt9VneIgPw3O
2isiJla6jBtfWPWNbwgVKrm8x72r7QJSY1IkXqqsSqLTUJVV3hFViA4YOC//7FV4
t0emgz6+1Iyr7BRQVLtjfik6LpLwbif3dI7urRShl1jliLqxLSc4iIMffWS+Uwct
Sm7PfZnVdMz3ZV7D3ORxU7ecvrxP8rRX0jNPcYfHlpK6xGifeIw7VfOlSfh8p51i
aEIctjaxY4iNThvFBJ0VdDf1WfdfRUpTsPMiLnwwLLyDrHeoFjprh+RoqSSC+oYH
SjTsngKuI3EzS4SGlWc92dJSRqz0zAh2T+LruebiYv2cAAk4Ua3goICjXWTDepFs
VNbtTYPRcy1+hQ2ABwTQo0Ft9I24eCrq4JKX46tu79HHlreEPEASsx1nRkrLBNfF
Rn2HtOYqYadC/3JNBlwj9bdS+UCSzKSA5CGBH4gucsT5BRczZpYXrKT//LzKU0f4
+afEw9nctg8C7Xt20vE+3xjV7/4KPtQrp0R9ncTqPPA7YNqBbI+qcIz5tHRuTAXr
p+vei2tFHZIkwNq7xYH56Tcw0wy9d6RqTp7y4cZKmND4YESEBj8=
=2IVT
-----END PGP SIGNATURE-----

--=-0Kxi4EewISbUBuag6yC7--

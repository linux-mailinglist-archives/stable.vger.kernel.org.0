Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE291A535B
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 20:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgDKS2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 14:28:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55420 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgDKS2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Apr 2020 14:28:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 15EB81C6385; Sat, 11 Apr 2020 20:28:14 +0200 (CEST)
Date:   Sat, 11 Apr 2020 20:28:13 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 03/54] sctp: fix refcount bug in sctp_wfree
Message-ID: <20200411182813.GA18221@duo.ucw.cz>
References: <20200411115508.284500414@linuxfoundation.org>
 <20200411115508.593027768@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20200411115508.593027768@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The following case cause the bug:
> for the trouble SKB, it was in outq->transmitted list

Ok... but this is one hell of "interesting" code.

> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -165,29 +165,44 @@ static void sctp_clear_owner_w(struct sc
>  	skb_orphan(chunk->skb);
>  }
> =20
> +#define traverse_and_process()	\
> +do {				\
> +	msg =3D chunk->msg;	\
> +	if (msg =3D=3D prev_msg)	\
> +		continue;	\
> +	list_for_each_entry(c, &msg->chunks, frag_list) {	\
> +		if ((clear && asoc->base.sk =3D=3D c->skb->sk) ||	\
> +		    (!clear && asoc->base.sk !=3D c->skb->sk))	\
> +			cb(c);	\
> +	}			\
> +	prev_msg =3D msg;		\
> +} while (0)

Should this be function?

Do you see how it does "continue"? But the do {} while(0) wrapper eats
the continue. "break" would be more clear here, but they are really
equivalent due to way this macro is used.

It is just very, very confusing.

Best regards,
								Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXpIMPQAKCRAw5/Bqldv6
8nGRAJ9i+7V6V7ICNl35CSsTotQAtMT4QACeP2kjyhviB509AsRsg+Jcj713Q1A=
=8Hn4
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
